Return-Path: <linux-kernel-owner+w=401wt.eu-S1758938AbXJXNjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758938AbXJXNjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 09:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755358AbXJXNiy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 09:38:54 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:46116 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084AbXJXNix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 09:38:53 -0400
Date: Wed, 24 Oct 2007 17:44:04 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: ego@in.ibm.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Dipankar Sarma <dipankar@in.ibm.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC PATCH 4/5] Remove CPU_DEAD/CPU_UP_CANCELLED handling from workqueue.c
Message-ID: <20071024134404.GB82@tv-sign.ru>
References: <20071024052931.GA22722@in.ibm.com> <20071024053716.GD27074@in.ibm.com> <200710241721.05163.rusty@rustcorp.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710241721.05163.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24, Rusty Russell wrote:
>
> On Wednesday 24 October 2007 15:37:16 Gautham R Shenoy wrote:
> > @@ -712,7 +712,7 @@ static void start_workqueue_thread(struc
> >
> >  	if (p != NULL) {
> >  		if (cpu >= 0)
> > -			kthread_bind(p, cpu);
> > +			set_cpus_allowed(p, cpumask_of_cpu(cpu));
> >  		wake_up_process(p);
> >  	}
> 
> Hi Gautham!
> 
> 	This works, although the change is unnecessary.

kthread_bind() changes ->cpu/->cpus_allowed without any locks.

Currently this is possible because nobody can wakeup the new thread
after wait_task_inactive() succeeds. With this patch this is not true
any longer, cwq->thread can sleep, for example, on cwq->more_work.

Oleg.

