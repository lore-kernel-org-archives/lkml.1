Return-Path: <linux-kernel-owner+w=401wt.eu-S1752388AbXDNWiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbXDNWiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 18:38:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751399AbXDNWiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 18:38:11 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:2357 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbXDNWiK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 18:38:10 -0400
X-AuthUser: davidel@xmailserver.org
Date: Sat, 14 Apr 2007 15:38:04 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: William Lee Irwin III <wli@holomorphy.com>
cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
In-Reply-To: <20070413222151.GD8915@holomorphy.com>
Message-ID: <Pine.LNX.4.64.0704140008001.10930@alien.or.mcafeemobile.com>
References: <20070413202100.GA9957@elte.hu> <20070413222151.GD8915@holomorphy.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 Apr 2007, William Lee Irwin III wrote:

> On Fri, Apr 13, 2007 at 10:21:00PM +0200, Ingo Molnar wrote:
> >    The CFS patch uses a completely different approach and implementation
> >    from RSDL/SD. My goal was to make CFS's interactivity quality exceed
> >    that of RSDL/SD, which is a high standard to meet :-) Testing
> >    feedback is welcome to decide this one way or another. [ and, in any
> >    case, all of SD's logic could be added via a kernel/sched_sd.c module
> >    as well, if Con is interested in such an approach. ]
> >    CFS's design is quite radical: it does not use runqueues, it uses a
> >    time-ordered rbtree to build a 'timeline' of future task execution,
> >    and thus has no 'array switch' artifacts (by which both the vanilla
> >    scheduler and RSDL/SD are affected).
> 
> A binomial heap would likely serve your purposes better than rbtrees.
> It's faster to have the next item to dequeue at the root of the tree
> structure rather than a leaf, for one. There are, of course, other
> priority queue structures (e.g. van Emde Boas) able to exploit the
> limited precision of the priority key for faster asymptotics, though
> actual performance is an open question.

Haven't looked at the scheduler code yet, but for a similar problem I use 
a time ring. The ring has Ns (2 power is better) slots (where tasks are 
queued - in my case they were som sort of timers), and it has a current 
base index (Ib), a current base time (Tb) and a time granularity (Tg). It 
also has a bitmap with bits telling you which slots contains queued tasks. 
An item (task) that has to be scheduled at time T, will be queued in the slot:

S = Ib + min((T - Tb) / Tg, Ns - 1);

Items with T longer than Ns*Tg will be scheduled in the relative last slot 
(chosing a proper Ns and Tg can minimize this).
Queueing is O(1) and de-queueing is O(Ns). You can play with Ns and Tg to 
suite to your needs.
This is a simple bench between time-ring (TR) and CFS queueing:

http://www.xmailserver.org/smart-queue.c

In my box (Dual Opteron 252):

davide@alien:~$ ./smart-queue -n 8            
CFS = 142.21 cycles/loop
TR  = 72.33 cycles/loop
davide@alien:~$ ./smart-queue -n 16
CFS = 188.74 cycles/loop
TR  = 83.79 cycles/loop
davide@alien:~$ ./smart-queue -n 32
CFS = 221.36 cycles/loop
TR  = 75.93 cycles/loop
davide@alien:~$ ./smart-queue -n 64
CFS = 242.89 cycles/loop
TR  = 81.29 cycles/loop



- Davide


