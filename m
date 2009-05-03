Return-Path: <linux-kernel-owner+w=401wt.eu-S1755028AbZECOHP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028AbZECOHP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 10:07:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753351AbZECOG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 10:06:59 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:24637 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082AbZECOG6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 10:06:58 -0400
MIME-Version: 1.0
In-Reply-To: <20090503062720.GA31340@racke>
References: <1241090812-13516-1-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-2-git-send-email-philipp.reisner@linbit.com>
	 <1241090812-13516-3-git-send-email-philipp.reisner@linbit.com>
	 <f73f7ab80905021651y54db1e69y87f0487bc06f0522@mail.gmail.com>
	 <20090503062720.GA31340@racke>
Date: Sun, 3 May 2009 10:06:58 -0400
Message-ID: <f73f7ab80905030706i4afd0902ub42d42d60f01e6a2@mail.gmail.com>
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

On Sun, May 3, 2009 at 2:27 AM, Lars Ellenberg
<lars.ellenberg@linbit.com> wrote:
> When we created our lru_cache stuff, we considered embedding callbacks
> and internal locking, but decided against it.  Conceptually it should be
> more like the "list.h" list handling infrastructure.
>
> The user will have their own locking in place anyways, and in general
> their critical section will be a few lines of code larger than the
> "lru cache" manipulation itself.

One of the major design-points for the code I'm fiddling with is that
it allows you to use RCU on your lookup table, which basically means
lock-free lookup (although I haven't stress-tested that part of it yet
so the code itself may have subtle bugs).  With a bit more work it's
probably even possible to make it lock-free even when adding a
reference to an object that's currently on the LRU.


> And, the specific use of our implementation is that there is a
> pre-selected maximum count of in-use objects, and the user gets
> feedback about changes to this "active" set of objects.

Another major design point (and the reason for the single "evict"
callback) is that my code does not require manual tuning, it responds
to memory-pressure dynamically using the "shrinker" mechanism.  So on
a box with 128MB of RAM your LRU cache will be automatically
size-limited by other activity on the system to an appropriate size;
yet it can scale up to tens or hundreds of megabytes on a system with
hundreds of gigs of RAM under heavy IO load.

The real deal-breaker for your code is its usage of "vmalloc", it's
unlikely to be merged when it relies on vmalloc() of a large
continuous block for operation.


> That is where the focus is:
> make the set of active objects easily trackable.
> So one can easily keep track of who is in, and who is not,
> by writing a log of just this "diff":
> seat index was occupied by element_nr A, but now is by element_nr B.

This could be very easily done with tracepoints and a few minor tweaks
to the implementation I provided.  I could add an object number and
various statistics similar to the ones in your code; the only reason I
didn't before is I did not need them and they detracted slightly from
the simplicity of the implementation (just 271 lines).

Keep in mind that by using the kmem_cache infrastructure, you get to
take advantage of all of the other SLAB debugging features on objects
allocated through your LRUs.  This includes redzones and
poison-on-free.  It also makes the number of objects and the number of
pages allocated show up in /proc/slabinfo and the various SLAB/SLUB
debug tools.


> So from looking at your code, it may be fine for the "lru" part,
> but it is not suitable for our purposes.

It would need an extra layer stacked on top to handle the hash-table
lookups, but it would solve the vmalloc issue and allow your LRU lists
to dynamically size a bit better.  It's also not that difficult to
apply memory allocation limits (aside from the default
memory-pressure) and add additional statistics and debugging info.

Cheers,
Kyle Moffett
