Return-Path: <linux-kernel-owner+w=401wt.eu-S932522AbYEIQYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522AbYEIQYB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 12:24:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765488AbYEIQWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 12:22:52 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50850 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765410AbYEIQWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 12:22:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: kernel-testers - finding regressions in the kernel
Date: Fri, 9 May 2008 18:22:34 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: brot <schnitzelkuchen@googlemail.com>, Adrian Bunk <bunk@kernel.org>,
       kernel-testers@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <20080507195830.GC32750@cs181133002.pp.htv.fi> <20080508230543.GL22887@cs181133002.pp.htv.fi> <482475E8.5090208@googlemail.com>
In-Reply-To: <482475E8.5090208@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805091822.35738.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter, Ingo, can you please have a look at this?

On Friday, 9 of May 2008, brot wrote:
> Adrian Bunk schrieb:
> > On Thu, May 08, 2008 at 11:54:34PM +0200, brot wrote:
> >> 2008/5/8 Peter Teoh <htmldeveloper@gmail.com>:
> >>
> >>     Recently, I had two different problems:
> >>
> >>     a.   For a problem that started since somewher after 2.6.24-rc9 till
> >>     now, even with the sched-devel git version, the keyboard on entry on
> >>     my laptop will jump/skip some characters.   Sometimes even repeating
> >>     many times SUDDENLY when I just entered once.   That is for Dell
> >>     Inspiron 9300 (Intel ICH6 chipset, ie, already > 3 years old, with FC7
> >>     as the OS).   But no such problem for desktop (Intel/AMD alike).   But
> >>     I don't know what to capture in the kernel when such thing happened.
> >>
> >>
> >> Same here. I think that depends heavily on the load. I have boinc
> >> running all the time, crunching numbers for worldcommunitygrid. As long
> >> as both cores have 100% load, everything is fine. But as soon as another
> >> task gets started (compiling kde is a task where this happens, same
> >> nice) the keyboard gets sluggish, just like Peter said. Also, sometimes
> >> the mp3 player (amarok) stutters.
> >> I am getting this since the early 2.6.25 - rc kernels.  PC is a amd64
> >> (Opteron 170, 2G Ram)
> >>
> >> If i can help somehow to debug that i would me more than happy to help.
> > 
> > Assuming you can create a workload with which you can blindly 
> > distinguish a good kernel from a bad kernel, one of you could
> > bisect the problem (first decide here who of you wants to try it):
> > 
> > After you've verified that 2.6.24 is good and both 2.6.25 and the latest 
> > 2.6.26-rc1-git are bad do:
> > 
> > <--  snip  -->
> > 
> > # install git
> > 
> > # clone Linus' tree:
> > git clone \ 
> >   git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> > 
> > # start bisecting:
> > cd linux-2.6
> > git bisect start
> > git bisect bad v2.6.25
> > git bisect good v2.6.24
> > cp /path/to/.config .
> > 
> > # start a round
> > make oldconfig
> > make
> > # install kernel, check whether it's good or bad, then:
> > git bisect [bad|good]
> > # start next round
> > 
> > 
> > After at about 15 reboots you'll have found the guilty commit
> > ("...  is first bad commit").
> > 
> > 
> > More information on git bisecting:
> >   man git-bisect
> > 
> > <--  snip  -->
> > 
> > You might be busy for several hours, but this has a good chance of 
> > finding the source of your problem.
> > 
> >> Have a nice day,
> >> brot
> > 
> > cu
> > Adrian
> > 
> 
> You were right, i have been busy for the last hours, but i was able to find the source of that problem.
> I am not really sure what to do now, but that is what the last git bisect command said:
> 
> brotkastn linux # git bisect bad
> 3fe69747dab906cd6a8523230276a9820d6a514f is first bad commit
> commit 3fe69747dab906cd6a8523230276a9820d6a514f
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Fri Mar 14 20:55:51 2008 +0100
> 
>     sched: min_vruntime fix
> 
>     Current min_vruntime tracking is incorrect and will cause serious
>     problems when we don't run the leftmost task for some reason.
> 
>     min_vruntime does two things; 1) it's used to determine a forward
>     direction when the u64 vruntime wraps, 2) it's used to track the
>     leftmost vruntime to position newly enqueued tasks from.
> 
>     The current logic advances min_vruntime whenever the current task's
>     vruntime advance. Because the current task may pass the leftmost task
>     still waiting we're failing the second goal. This causes new tasks to be
>     placed too far ahead and thus penalizes their runtime.
> 
>     Fix this by making min_vruntime the min_vruntime of the waiting tasks by
>     tracking it in enqueue/dequeue, and compare against current's vruntime
>     to obtain the absolute minimum when placing new tasks.
> 
>     Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> :040000 040000 a4f0b33e63cdb4e46d16d58a72a9d2dfbce88580 a48374666644a94cb33c0caf70604e2e53e0881e M      kernel
> 
> I hope my testing was usefull.
> 
> Have a nice day everyone,

Thanks,
Rafael
