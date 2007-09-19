Return-Path: <linux-kernel-owner+w=401wt.eu-S1754853AbXISTnW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853AbXISTnW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 15:43:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751135AbXISTnJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 15:43:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36954 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750835AbXISTnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 15:43:07 -0400
Date: Wed, 19 Sep 2007 12:39:11 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Ingo Molnar <mingo@elte.hu>
cc: Chuck Ebbert <cebbert@redhat.com>, Antoine Martin <antoine@nagafix.co.uk>,
       Satyam Sharma <satyam.sharma@gmail.com>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: CFS: some bad numbers with Java/database threading [FIXED]
In-Reply-To: <20070919191837.GA19500@elte.hu>
Message-ID: <alpine.LFD.0.999.0709191230230.16478@woody.linux-foundation.org>
References: <46E871FE.9010908@nagafix.co.uk> <20070913112427.GA20686@elte.hu>
 <20070914083246.GA20514@elte.hu> <a781481a0709140306k3faf3585haae26853fe81381c@mail.gmail.com>
 <46EAA7E4.8020700@nagafix.co.uk> <20070914153216.GA27213@elte.hu>
 <46F00417.7080301@redhat.com> <20070918224656.GA26719@elte.hu>
 <46F058EE.1080408@redhat.com> <20070919191837.GA19500@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 19 Sep 2007, Ingo Molnar wrote:
> 
> Linus, what do you think? I have no strong feelings, I think the patch 
> cannot hurt (it does not change anything by default) - but we should not 
> turn the workaround flag on by default.

I disagree. I think CFS made "sched_yield()" worse, and what you call "bug 
workaround" is likely the *better* behaviour.

The fact is, sched_yield() is not - and should not be - about 
"recalculating the position in the scheduler queue" like you do now in 
CFS.

It very much is about moving the thread *dead last* within its priority 
group. 

That's what it does for round-robin, and it's not about fairness, it's 
about

 - Opengroup:

	DESCRIPTION

	    The sched_yield() function forces the running thread to 
	relinquish the processor until it again becomes the head of its 
	thread list. It takes no arguments.

 - Linux man-page:

	DESCRIPTION

	    A process can relinquish the processor voluntarily without 
	blocking by calling sched_yield.  The process will then be moved 
	to the end of the queue for its static priority and a new process 
	gets to run.

and quite frankly, the current CFS behaviour simply looks buggy. It should 
simply not move it to the "right place" in the rbtree. It should move it 
*last*.

			Linus
