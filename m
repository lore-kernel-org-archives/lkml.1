Return-Path: <linux-kernel-owner+w=401wt.eu-S1755793AbZECWtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755793AbZECWtU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZECWtJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 18:49:09 -0400
Received: from [212.69.161.110] ([212.69.161.110]:49793 "EHLO
	mail09.linbit.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1753420AbZECWtI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 18:49:08 -0400
Date: Mon, 4 May 2009 00:48:09 +0200
From: Lars Ellenberg <lars.ellenberg@linbit.com>
To: Kyle Moffett <kyle@moffetthome.net>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
Message-ID: <20090503224809.GB6243@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com> <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com> <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com> <20090503062720.GA31340@racke> <f73f7ab80905030706i4afd0902ub42d42d60f01e6a2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f73f7ab80905030706i4afd0902ub42d42d60f01e6a2@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 03, 2009 at 10:06:58AM -0400, Kyle Moffett wrote:
> On Sun, May 3, 2009 at 2:27 AM, Lars Ellenberg
> <lars.ellenberg@linbit.com> wrote:
> > When we created our lru_cache stuff, we considered embedding callbacks
> > and internal locking, but decided against it.  Conceptually it should be
> > more like the "list.h" list handling infrastructure.
> >
> > The user will have their own locking in place anyways, and in general
> > their critical section will be a few lines of code larger than the
> > "lru cache" manipulation itself.
> 
> One of the major design-points for the code I'm fiddling with is that
> it allows you to use RCU on your lookup table, which basically means
> lock-free lookup (although I haven't stress-tested that part of it yet
> so the code itself may have subtle bugs).  With a bit more work it's
> probably even possible to make it lock-free even when adding a
> reference to an object that's currently on the LRU.

sounds good.

maybe it is only late, and I just don't see how good your code fits
what we are doing, after just adding twenty-or-so lines of wrapper code.
let me sleep about it.

still, some comments below.

> > And, the specific use of our implementation is that there is a
> > pre-selected maximum count of in-use objects, and the user gets
> > feedback about changes to this "active" set of objects.
> 
> Another major design point (and the reason for the single "evict"
> callback) is that my code does not require manual tuning, it responds
> to memory-pressure dynamically using the "shrinker" mechanism.  So on
> a box with 128MB of RAM your LRU cache will be automatically
> size-limited by other activity on the system to an appropriate size;
> yet it can scale up to tens or hundreds of megabytes on a system with
> hundreds of gigs of RAM under heavy IO load.

I'm in the IO path.
I absolutely do not want some stupid excessive read_ahead setting
or an out-of-bounds badly hacked php cronjob to limit the amount
of write-out I can do when things get tight (because of that badly
behaved process, most likely).

And I do not want to let it grow to an arbitrary number of objects,
that is even one important point of it: giving the admin a tuning knob
to trade resync-time after crash vs. frequency of meta-data updates.
I _want_ manual tuning. We are talking about (at max) a few thousand
small (<=56 bytes, even on 64bit arch), a few hundred kB.

I'm sure your approach has a number of valid uses.
I don't yet see it as a good fit for our purpose, though.
well, maybe it could replace the "inter part" of what we do.

> The real deal-breaker for your code is its usage of "vmalloc", it's
> unlikely to be merged when it relies on vmalloc() of a large
> continuous block for operation.

yes, I already got that part, thanks ;)
it is not a problem, its only in there because we have been lazy.

it is easily changed, either by using kmalloc (the objects, and the
maximum number of objects are both small), or some array of pages.
maybe even using a kmem_cache, partly following your code,
if that makes you happy ;-)

still, the main purpose of your "lru_cache",
and what we do with our "lru_cache",
seems to me to be different.
maybe we should change our name to something more appropriate.

> > That is where the focus is:
> > make the set of active objects easily trackable.
> > So one can easily keep track of who is in, and who is not,
> > by writing a log of just this "diff":
> > seat index was occupied by element_nr A, but now is by element_nr B.
> 
> This could be very easily done with tracepoints and a few minor tweaks
> to the implementation I provided.  I could add an object number and
> various statistics similar to the ones in your code; the only reason I
> didn't before is I did not need them and they detracted slightly from
> the simplicity of the implementation (just 271 lines).
> 
> Keep in mind that by using the kmem_cache infrastructure, you get to
> take advantage of all of the other SLAB debugging features on objects
> allocated through your LRUs.

I'm not oposed to it. I just say we don't need it.
We never allocate through our LRUs.
It is all just reference counting, and changing "seat lables".
Changing seat lables is the important part of it, actually.

> > So from looking at your code, it may be fine for the "lru" part,
> > but it is not suitable for our purposes.
> 
> It would need an extra layer stacked on top to handle the hash-table
> lookups,

yes, we need a fast way to know "is this id currently in the active set?".
that is what we use it most often for.

for our use case, now using label for element_number,
the most important functions would be

lru_cache_is_label_present(),
lru_cache_get_by_label(),
which would need to say "EAGAIN", once the active set is full and all
are in fact used.  and also return back the previous label now evicted,
(or "was free anyways") if successful.

lru_cache_try_get_by_label(),
which is just a combination of these two.

>  but it would solve the vmalloc issue

I hear you ;)

> and allow your LRU lists to dynamically size a bit better.

We currently neither want nor need that.

> It's also not that difficult to apply memory allocation limits (aside
> from the default memory-pressure) and add additional statistics and
> debugging info.

Of course, nothing is difficult, if it has been done already ;)
We don't need memory allocation limits, we want a limit on the
number of active objects. Boils down to the same thing, but for
different reasons.

I dislike the embeded lock as well as the callback.
I see what you need it for.
But for our purposes, we probably would need to just set a
"return NO_PLEASE;". And we do need to embed calls to this stuff in larger
critical sections.  Which means the embeded lock can never have
contention, it would always use the fast path, ok.  But still: unneccessary.

We just happen to also have the "lru" part somewhere.  But in actually it is
all about having a fixed number of "seats", with fixed indices and changeing
labels, then changing these "seat labels", while persistently journalling the
currently in-use labels.

but wait for the next post to see a better documented (or possibly
rewritten) implementation of this.

	Lars
