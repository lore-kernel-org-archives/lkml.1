Return-Path: <linux-kernel-owner+w=401wt.eu-S1754910AbZFXM2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910AbZFXM2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 08:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752498AbZFXM22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 08:28:28 -0400
Received: from mtagate5.de.ibm.com ([195.212.29.154]:46115 "EHLO
	mtagate5.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbZFXM22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 08:28:28 -0400
Date: Wed, 24 Jun 2009 14:28:28 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Paul Mundt <lethal@linux-sh.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624142828.7c6a2337@skybase>
In-Reply-To: <20090624112929.GB2079@linux-sh.org>
References: <20090624131104.705c828d@skybase>
	<20090624112929.GB2079@linux-sh.org>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Jun 2009 20:29:29 +0900
Paul Mundt <lethal@linux-sh.org> wrote:

> On Wed, Jun 24, 2009 at 01:11:04PM +0200, Martin Schwidefsky wrote:
> > Hi Paul,
> > following Ingo's suggestion I'm working on a patch to use a per-cpu
> > hrtimer instead of the timer_hook for the oprofile ticks. Given that
> > oprofile is the only user of the timer_hook I want to remove it
> > completely. That way I came across the register_timer_hook call in
> > arch/sh/oprofile/op_model_sh7750.c. Did this ever work? The startup
> > of oprofile is done in two steps, on module load oprofile_init is
> > called, on profiling start oprofile_start is called.
> > Now for SH7750 this happens:
> > 
> > oprofile_init()
> > 	...
> > 	oprofile_arch_init(&oprofile_ops);
> > 		...
> > 		lmodel->init(); 
> > 		/* init() is sh7750_ppc_init for CPU_SH7750/CPU_7750S */
> > 			sh7750_ppc_reset();
> > 			register_timer_hook(sh7750_timer_notify);
> > 			...
> > 		...
> > 	oprofile_timer_init(&oprofile_ops);
> > 		...
> > 		ops->start = timer_start;
> > 		...
> > 	...
> > 
> > oprofile_start()
> > 	...
> > 	oprofile_ops.start();
> > 	/* start() is timer_start set by oprofile_timer_init */
> > 		register_timer_hook(timer_notify);
> > 	...
> > 
> > As far as I can see the second register_timer_hook will fail
> > because sh7750_timer_notify is already registered. That will cause
> > oprofile_start to fail with -EBUSY, no?
> > 
> No. oprofile_timer_init() is only entered if the performance counters
> fail to register in the SH7750 case, so there is only one timer hook user
> at a time:
> 
> static int __init oprofile_init(void)
> {
>         int err;
> 
>         err = oprofile_arch_init(&oprofile_ops);
> 
>         if (err < 0 || timer) {
>                 printk(KERN_INFO "oprofile: using timer interrupt.\n");
>                 oprofile_timer_init(&oprofile_ops);
>         }
> ...

Oh, I see. That is the reason why the s390 version of
oprofile_arch_init returns -ENODEV. It does so to trigger the fallback
to the timer_hook. That should work for sh as well, no?

> The sh7750 performance counter code has always purposely abused the timer
> interrupt as its profiling interrupt given that the counters themselves do not
> generate IRQs on their own. There are a couple of 64-bit counters that can
> count various events, but have no real event associated with them. As long as
> they are periodically read, they return accurate statistics, but the granularity
> is never better than the timer IRQ.
> 
> In practice oprofile has never been a good fit for these sorts of counters, so
> this has fairly limited use. If there's a way to wiggle these types of counters
> in to the new perf_counter API, then I'll convert that over and just kill the
> old oprofile driver off completely. Barring that, I'll just end up converting it
> over to hrtimers as well, so don't let that stop you from ripping out the timer
> hook bits.
> 
> Most of this code predates hrtimers anyways, and it also predates the timer
> hook, which is only something that we converted to some years back.

Consider the timer_hook as history :-)

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

