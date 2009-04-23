Return-Path: <linux-kernel-owner+w=401wt.eu-S1756718AbZDWJot@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718AbZDWJot (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 05:44:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZDWJoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 05:44:32 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:62536 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756331AbZDWJoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 05:44:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Loggx8taDwwSofzU++3dSVcRoYlNRV0bNL2eQlvxZ7arQBhFDWEx4+sETSZfqiH80h
         mns3kJ51NKLYp8UzxWDf/oLKaU362FU24qPHra+zhXcVy0YxgpLK+gVLumQCBunfhMXC
         286SDfZVUP33ehpcZzSawgajM7KmKYdwfz/H8=
Date: Thu, 23 Apr 2009 11:44:24 +0200
From: Andrea Righi <righi.andrea@gmail.com>
To: Theodore Tso <tytso@mit.edu>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090423094423.GA9756@linux>
References: <20090421181429.GO19637@balbir.in.ibm.com> <20090421191401.GF15541@mit.edu> <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com> <20090422102239.GA1935@linux> <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com> <20090423012254.GZ15541@mit.edu> <20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com> <20090423043547.GB2723@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423043547.GB2723@mit.edu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 12:35:48AM -0400, Theodore Tso wrote:
> On Thu, Apr 23, 2009 at 11:54:19AM +0900, KAMEZAWA Hiroyuki wrote:
> > > How much testing has been done in terms of whether the I/O throttling
> > > actually works?  Not just, "the kernel doesn't crash", but that where
> > > you have one process generating a large amount of I/O load, in various
> > > different ways, and whether the right things happens?  If so, how has
> > > this been measured?
> > 
> > I/O control people should prove it. And they do, I think.
> > 
> 
> Well, with all due respect, the fact that they only tested removing
> the ext3 patch to fs/jbd2/commit.c, and discovered it had no effect,
> only after I asked some questions about how it could possibly work
> from a theoretical basis, makes me wonder exactly how much testing has
> actually been done to date.  Which is why I asked the question....

This is true in part. Actually io-throttle v12 has been largely tested,
also in production environments (Matt and David in cc can confirm
this) with quite interesting results.

I tested the previous versions usually with many parallel iozone, dd,
using many different configurations.

In v12 writeback IO is not actually limited, what io-throttle did was to
account and limit reads and direct IO in submit_bio() and limit and
account page cache writes in balance_dirty_pages_ratelimited_nr().

This seems to work quite well for the cases when we want avoid that a
single cgroup eats all the IO BW, but in this way in presence of a large
write stream we periodically have bunches of writeback IO that can
disrupt the other cgroups' BW requirements, from the QoS perspective.

The point is that in the new versions (v13 and v14) I merged the
bio-cgroup stuff to track and opportunely handle writeback IO in a
"smoother" way, actually changing some core components of the
io-throttle controller.

And this means it surely needs additional testing before merging in the
mainline.

I'll reproduce all the tests and publish the results ASAP using the new
implementation. I was just waiting to reach a stable point in the
implementation decisions before doing that.

> 
> > > I'm really concerned that given some of the ways that I/O will "leak"
> > > out --- the via pdflush, swap writeout, etc., that without the rest of
> > > the pieces in place, I/O throttling by itself might not prove to be
> > > very effective.  Sure, if the workload is only doing direct I/O, life
> > > is pretty easy and it shouldn't be hard to throttle the cgroup.
> > 
> > It's just a problem of "what we do and what we don't, now".
> > Andrea, Vivek, could you clarify ? As other project, I/O controller
> > will not be 100% at first implementation.
> 
> Yeah, but if the design hasn't been fully validated, maybe the
> implementation isn't ready for merging yet.  I only came across these
> patch series because of the ext3 patch, and when I started looking at
> it just from a high level point of view, I'm concerned about the
> design gaps and exactly how much high level thinking has gone into the
> patches.  This isn't a NACK per se, because I haven't spent the time
> to look at this code very closely (nor do I have the time).

And the ext3 patch BTW was just an experimental test, that has been
useful at the end, because now I have the attention and some feedbacks
also from the fs experts... :)

Anyway, as said above and at least for io-throttle it is not a totally
first implementation. It's a quite old and tested cgroup subsystem, but
some core components have been redesigned. For this reason it surely
needs more testing, and we're still discussing some implementation
details. I'd say the basic interface is stable and as Kamezawa said we
just need to decide what we do, what we don't, which problems the IO
controller should address and which should be considered by other cgroup
subsystems (like the dirty ratio issue).

> 
> Consider this more of a yellow flag being thrown on the field, in the
> hopes that the block layer and VM experts will take a much closer
> review of these patches.  I have a vague sense of disquiet that the
> container patches are touching a very large number of subsystems
> across the kernels, and it's not clear to me the maintainers of all of
> the subsystems have been paying very close attention and doing a
> proper high-level review of the design.

Agreed that IO controller touches a lot of critical kernel components. A
feedback from VM and block layer experts would be really welcome.

> 
> Simply on the strength of a very cursory reivew and asking a few
> questions, it seems to me that the I/O controller was implemented,
> apparently without even thinking about the write throttling problems,
> and this just making me.... very, very, nervous.  

Actually we discussed a lot about write throttling problems. At least I
addressed the problem since io-throttle RFC v2 (posted in Jun 2008).

> 
> I hope someone like akpm is paying very close attention and auditing
> these patches both from an low-level patch cleanliness point of view
> as well as a high-level design review.  Or at least that *someone* is
> doing so and can perhaps document how all of these knobs interact.
> After all, if they are going to be separate, and someone turns the I/O
> throttling knob without bothering to turn the write throttling knob
> --- what's going to happen?  An OOM?  That's not going to be very safe
> or friendly for the sysadmin who plans to be configuring the system.

> 
> Maybe this high level design considerations is happening, and I just
> haven't have seen it.  I sure hope so.

In a previous discussion (http://lkml.org/lkml/2008/11/4/565) we decided
to split the problems: the decision was that IO controller should
consider only IO requests and the memory controller should take care of
the OOM / dirty pages problems. Distinct memcg dirty_ratio seemed to be
a good start. Anyway, I think we're not so far from having an acceptable
solution, also looking at the recent thoughts and discussions in this
thread. For the implementation part, as pointed by Kamezawa per bdi /
task dirty ratio is a very similar problem. Probably we can simply
replicate the same concepts per cgroup.

-Andrea
