Return-Path: <linux-kernel-owner+w=401wt.eu-S1754233AbYFUVWR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233AbYFUVWR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2008 17:22:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbYFUVWD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jun 2008 17:22:03 -0400
Received: from casper.infradead.org ([85.118.1.10]:56328 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752413AbYFUVWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2008 17:22:01 -0400
Subject: Re: v2.6.26-rc7: BUG task_struct: Poison overwritten
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com>
References: <20080621192400.GA2992@damson.getinternet.no>
	 <20080621192845.GB2992@damson.getinternet.no>
	 <19f34abd0806211341i3a3ecd0bi1c849a2fbc4e9c7e@mail.gmail.com>
Content-Type: text/plain
Date: Sat, 21 Jun 2008 23:21:47 +0200
Message-Id: <1214083307.3223.289.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-06-21 at 22:41 +0200, Vegard Nossum wrote:
> On Sat, Jun 21, 2008 at 9:28 PM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> > Oops, seems there was another one a bit earlier (about 5 minutes) that I
> > didn't notice. I don't think it helps that much, but here it is:
> 
> I actually got a third one too, but it's similar to the first two.
> 
> >
> >
> >  =============================================================================
> >  BUG task_struct: Poison overwritten
> >  -----------------------------------------------------------------------------
> >
> >  INFO: 0xf53ab018-0xf53ab02b. First byte 0x71 instead of 0x6b
> >  INFO: Allocated in copy_process+0x70/0x1090 age=110 cpu=1 pid=28664
> >  INFO: Freed in free_task+0x2c/0x30 age=68 cpu=0 pid=28667
> >  INFO: Slab 0xc1ba6cc0 objects=8 used=5 fp=0xf53aafd0 flags=0x400020c3
> >  INFO: Object 0xf53aafd0 @offset=12240 fp=0xf53acfb0
> >
> >  Bytes b4 0xf53aafc0:  5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a 5a ZZZZZZZZZZZZZZZZ
> >   Object 0xf53aafd0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >   Object 0xf53aafe0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >   Object 0xf53aaff0:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >   Object 0xf53ab000:  6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b kkkkkkkkkkkkkkkk
> >   Object 0xf53ab010:  6b 6b 6b 6b 6b 6b 6b 6b 71 19 6f be dd 07 00 00 kkkkkkkkq.o<BE><DD>...
> >   Object 0xf53ab020:  71 19 6f be 6b 6b 6b 6b 6a 6b 6b eb 6b 6b 6b 6b q.o<BE>kkkkjkk<EB>kkkk
> 
> So what to notice is that this is offset hex(0xf53ab018-0xf53aafc0) =
> '0x58L' from the beginning of the object (would be nice to have SLUB
> print that too, btw), which corresponds to (struct
> task_struct).se.vruntime (the "se" is a struct sched_entity). I'm
> putting Ingo and Peter on the Cc.
> 
> What I find odd is that only some of the bytes in there are wrong,
> take the stray "eb" in the last line (above), for example. And these
> variables around offset 0x58 from the struct task struct are all u64s.
> Is it possible that the corruption comes from somewhere else?
> 
> (Does the number look like a valid vruntime, for example?)

Hard to tell, its a virtual timeline so pretty much any value is a valid
value - you'd need a contemporary vruntime from the same cfs_rq to
compare against.

But it looks like there might be some cpu hotplug race with group
scheduling - heiko (s390) and avi (x86_64) reported some cpu hotplug
crashes. We're still looking into those.

> For the record,
> 
> $ grep SCHED .config
> CONFIG_HAVE_UNSTABLE_SCHED_CLOCK=y
> CONFIG_GROUP_SCHED=y
> CONFIG_FAIR_GROUP_SCHED=y
> CONFIG_RT_GROUP_SCHED=y
> CONFIG_USER_SCHED=y
> # CONFIG_CGROUP_SCHED is not set
> CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER=y
> CONFIG_SCHED_SMT=y
> CONFIG_SCHED_MC=y
> CONFIG_SCHED_HRTICK=y
> CONFIG_SCHED_DEBUG=y
> CONFIG_SCHEDSTATS=y




