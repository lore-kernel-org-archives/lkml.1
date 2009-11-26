Return-Path: <linux-kernel-owner+w=401wt.eu-S1760198AbZKZKQT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760198AbZKZKQT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 05:16:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760120AbZKZKQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 05:16:18 -0500
Received: from mail.gmx.net ([213.165.64.20]:53975 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1760118AbZKZKQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 05:16:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18OqFNRLgYOeI3OraTDpzNX4hcJcmZD0AzBZwwzTN
	jPfTObv86L3qIG
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259228139.4273.6.camel@twins>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
	 <1259197270.6186.17.camel@marge.simson.net>
	 <1259199068.6186.33.camel@marge.simson.net> <1259228139.4273.6.camel@twins>
Content-Type: text/plain
Date: Thu, 26 Nov 2009 11:16:18 +0100
Message-Id: <1259230578.15079.12.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 10:35 +0100, Peter Zijlstra wrote:
> On Thu, 2009-11-26 at 02:31 +0100, Mike Galbraith wrote:
> > On Thu, 2009-11-26 at 02:01 +0100, Mike Galbraith wrote:
> > > On Wed, 2009-11-25 at 19:27 +0100, Peter Zijlstra wrote:
> > 
> > > > I've got to ask, what's that barrier for?
> > > 
> > > It's a leftover from frustrated bug hunting.
> > 
> > To be more specific, I put it there to ensure that min_vruntimes are
> > stable. 
> 
> min_vruntime should only ever be poked at when holding the respective
> rq->lock, even with a barrier a 64bit read on a 32bit machine can go all
> funny.

Yeah, but we're looking at an unlocked runqueue.  But never mind...

> >  I figured that if try_to_wake_up() needs a barrier to look at
> > task->state, I had better do the same for the runqueues.
> 
> Ah, ttwu() has that barrier for another reason. The wmb in ttwu() is to
> ensure the wakee sees the state of the waker at the time of waking.
> 
> That is, its about ordering things like:
> 
> 
>    A				   B
> 
> 
> my_cond = true;
> wake_process(my_friend);
> 
> 				while (!my_cond)
> 				  schedule();
> 
> 
> So that you can actually observe my_cond being true once you wakeup
> (schedule acts as a mb() when it actually schedules).

(Ah!  I think you actually made a wrinkle in grey-ware)

...ATM, I kinda wish I'd not gone off and read barriers.txt.  It hasn't
sunk in yet, but certainly has made me _paranoid as hell_ :-)

	-Mike

