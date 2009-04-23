Return-Path: <linux-kernel-owner+w=401wt.eu-S1752347AbZDWEhS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347AbZDWEhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 00:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751011AbZDWEhC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 00:37:02 -0400
Received: from THUNK.ORG ([69.25.196.29]:38798 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750791AbZDWEhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 00:37:00 -0400
Date: Thu, 23 Apr 2009 00:35:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       akpm@linux-foundation.org
Cc: Andrea Righi <righi.andrea@gmail.com>, randy.dunlap@oracle.com,
       Carl Henrik Lunde <chlunde@ping.uio.no>,
       Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
       Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
       dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
       agk@sourceware.org, subrata@linux.vnet.ibm.com,
       Paul Menage <menage@google.com>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, dave@linux.vnet.ibm.com,
       matt@bluehost.com, roberto@unbit.it, ngupta@google.com
Subject: Re: [PATCH 9/9] ext3: do not throttle metadata and journal IO
Message-ID: <20090423043547.GB2723@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	akpm@linux-foundation.org, Andrea Righi <righi.andrea@gmail.com>,
	randy.dunlap@oracle.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
	Jens Axboe <jens.axboe@oracle.com>, eric.rannaud@gmail.com,
	Balbir Singh <balbir@linux.vnet.ibm.com>, fernando@oss.ntt.co.jp,
	dradford@bluehost.com, Gui@smtp1.linux-foundation.org,
	agk@sourceware.org, subrata@linux.vnet.ibm.com,
	Paul Menage <menage@google.com>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	dave@linux.vnet.ibm.com, matt@bluehost.com, roberto@unbit.it,
	ngupta@google.com
References: <20090421174620.GD15541@mit.edu> <20090421181429.GO19637@balbir.in.ibm.com> <20090421191401.GF15541@mit.edu> <20090421204905.GA5573@linux> <20090422093349.1ee9ae82.kamezawa.hiroyu@jp.fujitsu.com> <20090422102153.9aec17b9.kamezawa.hiroyu@jp.fujitsu.com> <20090422102239.GA1935@linux> <20090423090535.ec419269.kamezawa.hiroyu@jp.fujitsu.com> <20090423012254.GZ15541@mit.edu> <20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090423115419.c493266a.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 23, 2009 at 11:54:19AM +0900, KAMEZAWA Hiroyuki wrote:
> > How much testing has been done in terms of whether the I/O throttling
> > actually works?  Not just, "the kernel doesn't crash", but that where
> > you have one process generating a large amount of I/O load, in various
> > different ways, and whether the right things happens?  If so, how has
> > this been measured?
> 
> I/O control people should prove it. And they do, I think.
> 

Well, with all due respect, the fact that they only tested removing
the ext3 patch to fs/jbd2/commit.c, and discovered it had no effect,
only after I asked some questions about how it could possibly work
from a theoretical basis, makes me wonder exactly how much testing has
actually been done to date.  Which is why I asked the question....

> > I'm really concerned that given some of the ways that I/O will "leak"
> > out --- the via pdflush, swap writeout, etc., that without the rest of
> > the pieces in place, I/O throttling by itself might not prove to be
> > very effective.  Sure, if the workload is only doing direct I/O, life
> > is pretty easy and it shouldn't be hard to throttle the cgroup.
> 
> It's just a problem of "what we do and what we don't, now".
> Andrea, Vivek, could you clarify ? As other project, I/O controller
> will not be 100% at first implementation.

Yeah, but if the design hasn't been fully validated, maybe the
implementation isn't ready for merging yet.  I only came across these
patch series because of the ext3 patch, and when I started looking at
it just from a high level point of view, I'm concerned about the
design gaps and exactly how much high level thinking has gone into the
patches.  This isn't a NACK per se, because I haven't spent the time
to look at this code very closely (nor do I have the time).

Consider this more of a yellow flag being thrown on the field, in the
hopes that the block layer and VM experts will take a much closer
review of these patches.  I have a vague sense of disquiet that the
container patches are touching a very large number of subsystems
across the kernels, and it's not clear to me the maintainers of all of
the subsystems have been paying very close attention and doing a
proper high-level review of the design.

Simply on the strength of a very cursory reivew and asking a few
questions, it seems to me that the I/O controller was implemented,
apparently without even thinking about the write throttling problems,
and this just making me.... very, very, nervous.  

I hope someone like akpm is paying very close attention and auditing
these patches both from an low-level patch cleanliness point of view
as well as a high-level design review.  Or at least that *someone* is
doing so and can perhaps document how all of these knobs interact.
After all, if they are going to be separate, and someone turns the I/O
throttling knob without bothering to turn the write throttling knob
--- what's going to happen?  An OOM?  That's not going to be very safe
or friendly for the sysadmin who plans to be configuring the system.

Maybe this high level design considerations is happening, and I just
haven't have seen it.  I sure hope so.

						- Ted
