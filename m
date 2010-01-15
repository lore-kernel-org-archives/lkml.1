Return-Path: <linux-kernel-owner+w=401wt.eu-S1757176Ab0AOAKP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176Ab0AOAKP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:10:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751160Ab0AOAKO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:10:14 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:63559 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932129Ab0AOAKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:10:13 -0500
X-Authority-Analysis: v=1.0 c=1 a=1J7b2nWUegwA:10 a=7U3hwN5JcxgA:10 a=meVymXHHAAAA:8 a=t7CeM3EgAAAA:8 a=DBz23d8DhN_iYfqKJZgA:9 a=3aGtYd2ZOvXpVXPh-kOAM50OzSMA:4 a=jeBq3FmKZ4MA:10 a=2e6ZYRoF4I4A:10
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 39/40] debug_core: Turn off tracing while in the
 debugger
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Jason Wessel <jason.wessel@windriver.com>
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       mingo@elte.hu
In-Reply-To: <1263481176-1897-40-git-send-email-jason.wessel@windriver.com>
References: <1263481176-1897-1-git-send-email-jason.wessel@windriver.com>
	 <1263481176-1897-40-git-send-email-jason.wessel@windriver.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 14 Jan 2010 19:10:10 -0500
Message-ID: <1263514210.28171.3963.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-01-14 at 08:59 -0600, Jason Wessel wrote:
> The kernel debugger should turn off kernel tracing any time the
> debugger is active and restore it on resume.
> 
> CC: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jason Wessel <jason.wessel@windriver.com>
> ---
>  kernel/debug/debug_core.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/debug/debug_core.c b/kernel/debug/debug_core.c
> index 6ca3f7c..464aa65 100644
> --- a/kernel/debug/debug_core.c
> +++ b/kernel/debug/debug_core.c
> @@ -474,6 +474,7 @@ static int kgdb_cpu_enter(struct kgdb_state *ks, struct pt_regs *regs)
>  	int sstep_tries = 100;
>  	int error;
>  	int i, cpu;
> +	int trace_on = 0;
>  acquirelock:
>  	/*
>  	 * Interrupts will be restored by the 'trap return' code, except when
> @@ -518,6 +519,8 @@ return_normal:
>  			 */
>  			if (arch_kgdb_ops.correct_hw_break)
>  				arch_kgdb_ops.correct_hw_break();
> +			if (trace_on)
> +				tracing_on();
>  			atomic_set(&cpu_in_kgdb[cpu], 0);
>  			touch_softlockup_watchdog_sync();
>  			clocksource_touch_watchdog();
> @@ -592,6 +595,9 @@ return_normal:
>  	kgdb_single_step = 0;
>  	kgdb_contthread = current;
>  	exception_level = 0;
> +	trace_on = tracing_is_on();
> +	if (trace_on)
> +		tracing_off();

Hmm, what happens if tracing gets turned on by something else? Will it
break this code? If so, we may need to do something different here.

-- Steve

>  
>  	while (1) {
>  cpu_master_loop:
> @@ -642,6 +648,8 @@ kgdb_restore:
>  		else
>  			kgdb_sstep_pid = 0;
>  	}
> +	if (trace_on)
> +		tracing_on();
>  	/* Free kgdb_active */
>  	atomic_set(&kgdb_active, -1);
>  	touch_softlockup_watchdog_sync();


