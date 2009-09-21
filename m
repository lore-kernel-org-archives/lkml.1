Return-Path: <linux-kernel-owner+w=401wt.eu-S1755986AbZIUNwM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986AbZIUNwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 09:52:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752945AbZIUNwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 09:52:11 -0400
Received: from viefep15-int.chello.at ([62.179.121.35]:37281 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbZIUNwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 09:52:10 -0400
X-SourceIP: 213.93.53.227
Subject: Re: sched: Am I missing something?
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Peter Williams <pwil3058@bigpond.net.au>
Cc: Ingo Molnar <mingo@elte.hu>, Mike Galbraith <efault@gmx.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <4AB77E21.6020805@bigpond.net.au>
References: <4AB77E21.6020805@bigpond.net.au>
Content-Type: text/plain
Date: Mon, 21 Sep 2009 15:53:03 +0200
Message-Id: <1253541183.8439.168.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-09-21 at 23:22 +1000, Peter Williams wrote:
> Or is the line:
> 
> 	p->prio = effective_prio(p);
> 
> in wake_up_new_task() an expensive no op.
> 
> As far as I can tell from reading the code, it will always be the case 
> that EITHER rt_prio(p->prio) is true OR p->prio == p->normal_prio when 
> this call is made and, in either case, the value of p->prio will be 
> unchanged.  In addition, when this call is made p->normal_prio is 
> already equal to to normal_prio(p), so the side effects of the function 
> (setting p->normal_prio) are also unnecessary.
> 
> Am I correct or have I missed something?

Yuck @ all that prio code..

I think you're right,  sched_fork() resets the prio, so poking at it in
wake_up_new_task() seems superfluous.

I've been meaning to re-write most of the PI code one of these days, but
so far I've not had time to.

My initial goal is to replace plist with a rb-tree and fix some of the
boost paths to be inside the scheduler. That is, we currently have the
fun situation that we boost a lock owner, which becomes runnable, gets
pushed to another cpu, then current blocks and reschedules, leaving this
cpu to again sort out work.

It would be much easier if we'd first dequeue current, then boost and
then select the owner. Saves a bit of bouncing around.

The rb-tree is needed for things like PI on CFS (yes, you can do a form
of PI on proportional schedulers), and we're going to look at doing a
full sporadic task model deadline scheduler, which needs both deadline
inheritance and bandwidth inheritance.



