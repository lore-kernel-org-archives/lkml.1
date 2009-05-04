Return-Path: <linux-kernel-owner+w=401wt.eu-S1755863AbZEDAss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863AbZEDAss (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 20:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753136AbZEDAsj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 20:48:39 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:53827 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbZEDAsi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 20:48:38 -0400
MIME-Version: 1.0
In-Reply-To: <20090503224809.GB6243@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	 <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com>
	 <20090503062720.GA31340@racke>
	 <f73f7ab80905030706i4afd0902ub42d42d60f01e6a2@mail.gmail.com>
	 <20090503224809.GB6243@racke>
Date: Sun, 3 May 2009 20:48:37 -0400
Message-ID: <f73f7ab80905031748v2be95af8vcd07c6a77dc348f@mail.gmail.com>
Subject: Re: [PATCH 02/16] DRBD: lru_cache
From: Kyle Moffett <kyle@moffetthome.net>
To: Lars Ellenberg <lars.ellenberg@linbit.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-kernel@vger.kernel.org,
       Jens Axboe <jens.axboe@oracle.com>, Greg KH <gregkh@suse.de>,
       Neil Brown <neilb@suse.de>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sam Ravnborg <sam@ravnborg.org>, Dave Jones <davej@redhat.com>,
       Nikanth Karthikesan <knikanth@suse.de>,
       Lars Marowsky-Bree <lmb@suse.de>,
       "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
       Bart Van Assche <bart.vanassche@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 3, 2009 at 6:48 PM, Lars Ellenberg
<lars.ellenberg@linbit.com> wrote:
> On Sun, May 03, 2009 at 10:06:58AM -0400, Kyle Moffett wrote:
>> On Sun, May 3, 2009 at 2:27 AM, Lars Ellenberg <lars.ellenberg@linbit.com> wrote:
>>> And, the specific use of our implementation is that there is a
>>> pre-selected maximum count of in-use objects, and the user gets
>>> feedback about changes to this "active" set of objects.
>>
>> Another major design point (and the reason for the single "evict"
>> callback) is that my code does not require manual tuning, it responds
>> to memory-pressure dynamically using the "shrinker" mechanism.  So on
>> a box with 128MB of RAM your LRU cache will be automatically
>> size-limited by other activity on the system to an appropriate size;
>> yet it can scale up to tens or hundreds of megabytes on a system with
>> hundreds of gigs of RAM under heavy IO load.
>
> I'm in the IO path.
> I absolutely do not want some stupid excessive read_ahead setting
> or an out-of-bounds badly hacked php cronjob to limit the amount
> of write-out I can do when things get tight (because of that badly
> behaved process, most likely).

I completely understand this part, but I think these issues can be
satisfied by the code without limiting its use for other LRU purposes.
 You should also remember that some people *will* want to throttle
DRBD I/O at the expense of other forms of I/O, and memory pressure is
a *big* part of how that is managed.

There are a couple trivial tunables you can apply to the model I
provided to dramatically change the effect of memory pressure on the
LRU:

  (1)  The biggie:  Make sure that the proccess(es) using the
writeout-centric LRUs have PF_LESS_THROTTLE or similar so that they
are throttled less than other processes.  This is good advice
regardless.

  (2)  Change the "seeks" variable in the lru_cache_info structure.
That is forwarded to the "shrinker" code to determine how to weight
memory pressure on these objects.  Specifically, that number is
intended to represent a rough analogy of the number of seeks that it
takes to recreate an object purged from the LRU.  Critical LRUs can
have an artificially inflated "seeks" value to reflect desired
weighting.

  (3)  Add "nr_elem_min" and "nr_elem_max" counters which apply
minimum or maximum bounds for the LRU list, while still allowing it to
dynamically resize within some range.  An example where this is useful
is a large simulation program which writes out the results of its
computation to a DRBD array at the end.  You want to let memory
pressure from the simulation program push out other objects from the
LRU while its running, then allow the LRU to grow large again as it
frees memory and submits I/O.

  (4)  Apply a "lru_scan_factor" which acts as a multiplier or divider
on the "nr_scan" in the lru_cache_shrink() function (as well as its
return value).  This will also cause a change in the weighting of the
shrinker code; if your LRU has 1000 objects in it with 2 seeks to
recreate each object, it will be asked to free much more than if you
claim it has 100 objects with 8 seeks per object.


> And I do not want to let it grow to an arbitrary number of objects,
> that is even one important point of it: giving the admin a tuning knob
> to trade resync-time after crash vs. frequency of meta-data updates.
> I _want_ manual tuning. We are talking about (at max) a few thousand
> small (<=56 bytes, even on 64bit arch), a few hundred kB.

Hmm, I'd be interested to see the numbers on this for large
many-terabyte volumes.  You should consider that most journalling
filesystems have to make similar tradeoffs; people get really
frustrated if things do not (A) have a useful automatic default and
(B) have a runtime-modifiable knob.  See the recent exceptionally long
ext3/ext4 threads on delayed allocation and writeback for some of the
flamewars that can result.


> still, the main purpose of your "lru_cache",
> and what we do with our "lru_cache",
> seems to me to be different.
> maybe we should change our name to something more appropriate.

I definitely agree that what you have isn't really properly named as
an "lru_cache".  It does make me curious, though, what precisely the
performance differences are (for DRBD specifically) between an
appropriately-tuned LRU cache and your fixed-size working set.


>> Keep in mind that by using the kmem_cache infrastructure, you get to
>> take advantage of all of the other SLAB debugging features on objects
>> allocated through your LRUs.
>
> I'm not oposed to it. I just say we don't need it.
> We never allocate through our LRUs.
> It is all just reference counting, and changing "seat lables".
> Changing seat lables is the important part of it, actually.

Well, technically what you're doing is using your LRU as a fixed-size
kmem_cache which returns the oldest object if there are no more free
slots.

>> > So from looking at your code, it may be fine for the "lru" part,
>> > but it is not suitable for our purposes.
>>
>> It would need an extra layer stacked on top to handle the hash-table
>> lookups,
>
> yes, we need a fast way to know "is this id currently in the active set?".
> that is what we use it most often for.
>
> for our use case, now using label for element_number,
> the most important functions would be
>
> lru_cache_is_label_present(),
> lru_cache_get_by_label(),
> which would need to say "EAGAIN", once the active set is full and all
> are in fact used.  and also return back the previous label now evicted,
> (or "was free anyways") if successful.
>
> lru_cache_try_get_by_label(),
> which is just a combination of these two.

I'll try to do a simple mostly-lockless hash-table lookup on top of
this, to show you what my thoughts are.


> but wait for the next post to see a better documented (or possibly
> rewritten) implementation of this.

Yeah, I'm definitely reworking it now that I have a better
understanding of what the DRBD code really wants.  My main intention
is to have the code be flexible enough that filesystems and other
sorts of network-related code can use it transparently, without
requiring much in the way of manual tuning.  See Linus' various
comments on why he *hates* manual tunables.

Cheers,
Kyle Moffett
