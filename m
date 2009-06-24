Return-Path: <linux-kernel-owner+w=401wt.eu-S1754597AbZFXLaj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbZFXLaj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 07:30:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751733AbZFXLab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 07:30:31 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:49226 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbZFXLaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 07:30:30 -0400
Date: Wed, 24 Jun 2009 20:29:29 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: register_timer_hook use in arch/sh/oprofile
Message-ID: <20090624112929.GB2079@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Martin Schwidefsky <schwidefsky@de.ibm.com>,
	Ingo Molnar <mingo@elte.hu>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <20090624131104.705c828d@skybase>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090624131104.705c828d@skybase>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 24, 2009 at 01:11:04PM +0200, Martin Schwidefsky wrote:
> Hi Paul,
> following Ingo's suggestion I'm working on a patch to use a per-cpu
> hrtimer instead of the timer_hook for the oprofile ticks. Given that
> oprofile is the only user of the timer_hook I want to remove it
> completely. That way I came across the register_timer_hook call in
> arch/sh/oprofile/op_model_sh7750.c. Did this ever work? The startup
> of oprofile is done in two steps, on module load oprofile_init is
> called, on profiling start oprofile_start is called.
> Now for SH7750 this happens:
> 
> oprofile_init()
> 	...
> 	oprofile_arch_init(&oprofile_ops);
> 		...
> 		lmodel->init(); 
> 		/* init() is sh7750_ppc_init for CPU_SH7750/CPU_7750S */
> 			sh7750_ppc_reset();
> 			register_timer_hook(sh7750_timer_notify);
> 			...
> 		...
> 	oprofile_timer_init(&oprofile_ops);
> 		...
> 		ops->start = timer_start;
> 		...
> 	...
> 
> oprofile_start()
> 	...
> 	oprofile_ops.start();
> 	/* start() is timer_start set by oprofile_timer_init */
> 		register_timer_hook(timer_notify);
> 	...
> 
> As far as I can see the second register_timer_hook will fail
> because sh7750_timer_notify is already registered. That will cause
> oprofile_start to fail with -EBUSY, no?
> 
No. oprofile_timer_init() is only entered if the performance counters
fail to register in the SH7750 case, so there is only one timer hook user
at a time:

static int __init oprofile_init(void)
{
        int err;

        err = oprofile_arch_init(&oprofile_ops);

        if (err < 0 || timer) {
                printk(KERN_INFO "oprofile: using timer interrupt.\n");
                oprofile_timer_init(&oprofile_ops);
        }
...

The sh7750 performance counter code has always purposely abused the timer
interrupt as its profiling interrupt given that the counters themselves do not
generate IRQs on their own. There are a couple of 64-bit counters that can
count various events, but have no real event associated with them. As long as
they are periodically read, they return accurate statistics, but the granularity
is never better than the timer IRQ.

In practice oprofile has never been a good fit for these sorts of counters, so
this has fairly limited use. If there's a way to wiggle these types of counters
in to the new perf_counter API, then I'll convert that over and just kill the
old oprofile driver off completely. Barring that, I'll just end up converting it
over to hrtimers as well, so don't let that stop you from ripping out the timer
hook bits.

Most of this code predates hrtimers anyways, and it also predates the timer
hook, which is only something that we converted to some years back.
