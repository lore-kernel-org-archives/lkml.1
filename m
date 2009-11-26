Return-Path: <linux-kernel-owner+w=401wt.eu-S1758985AbZKZJff@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758985AbZKZJff (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:35:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754500AbZKZJfe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:35:34 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:54981 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960AbZKZJfd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:35:33 -0500
Subject: Re: [patch] sched: fix set_task_cpu() and provide an unlocked
 runqueue variant
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1259199068.6186.33.camel@marge.simson.net>
References: <1258891781.14325.34.camel@marge.simson.net>
	 <1259173672.4027.732.camel@laptop>
	 <1259197270.6186.17.camel@marge.simson.net>
	 <1259199068.6186.33.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 26 Nov 2009 10:35:39 +0100
Message-ID: <1259228139.4273.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-11-26 at 02:31 +0100, Mike Galbraith wrote:
> On Thu, 2009-11-26 at 02:01 +0100, Mike Galbraith wrote:
> > On Wed, 2009-11-25 at 19:27 +0100, Peter Zijlstra wrote:
> 
> > > I've got to ask, what's that barrier for?
> > 
> > It's a leftover from frustrated bug hunting.
> 
> To be more specific, I put it there to ensure that min_vruntimes are
> stable. 

min_vruntime should only ever be poked at when holding the respective
rq->lock, even with a barrier a 64bit read on a 32bit machine can go all
funny.

>  I figured that if try_to_wake_up() needs a barrier to look at
> task->state, I had better do the same for the runqueues.

Ah, ttwu() has that barrier for another reason. The wmb in ttwu() is to
ensure the wakee sees the state of the waker at the time of waking.

That is, its about ordering things like:


   A				   B


my_cond = true;
wake_process(my_friend);

				while (!my_cond)
				  schedule();


So that you can actually observe my_cond being true once you wakeup
(schedule acts as a mb() when it actually schedules).

