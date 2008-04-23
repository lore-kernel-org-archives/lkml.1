Return-Path: <linux-kernel-owner+w=401wt.eu-S1754298AbYDWV5G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754298AbYDWV5G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 17:57:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbYDWV4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 17:56:54 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:14936 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752068AbYDWV4x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 17:56:53 -0400
Date: Wed, 23 Apr 2008 14:55:17 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dimitri Sivanich <sivanich@sgi.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] disable softlockup detection at boottime
Message-Id: <20080423145517.c786015b.randy.dunlap@oracle.com>
In-Reply-To: <20080423201613.GA8546@sgi.com>
References: <20080423201613.GA8546@sgi.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Apr 2008 15:16:13 -0500 Dimitri Sivanich wrote:

> This patch allows softlockup detection to be disabled by specifying
> a boottime parameter.

Seems to be missing (a) justification/why and
(b) entry in Documentation/kernel-parameters.txt


> Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
> 
> Index: linux/kernel/softlockup.c
> ===================================================================
> --- linux.orig/kernel/softlockup.c	2008-04-23 13:50:06.000000000 -0500
> +++ linux/kernel/softlockup.c	2008-04-23 14:39:36.267398531 -0500
> @@ -24,6 +24,7 @@ static DEFINE_PER_CPU(unsigned long, tou
>  static DEFINE_PER_CPU(unsigned long, print_timestamp);
>  static DEFINE_PER_CPU(struct task_struct *, watchdog_task);
>  
> +static int __read_mostly softlockup_off;
>  static int __read_mostly did_panic;
>  unsigned long __read_mostly softlockup_thresh = 60;
>  
> @@ -53,7 +54,8 @@ void touch_softlockup_watchdog(void)
>  {
>  	int this_cpu = raw_smp_processor_id();
>  
> -	__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
> +	if (!softlockup_off)
> +		__raw_get_cpu_var(touch_timestamp) = get_timestamp(this_cpu);
>  }
>  EXPORT_SYMBOL(touch_softlockup_watchdog);
>  
> @@ -61,6 +63,9 @@ void touch_all_softlockup_watchdogs(void
>  {
>  	int cpu;
>  
> +	if (softlockup_off)
> +		return;
> +
>  	/* Cause each CPU to re-update its timestamp rather than complain */
>  	for_each_online_cpu(cpu)
>  		per_cpu(touch_timestamp, cpu) = 0;
> @@ -79,6 +84,9 @@ void softlockup_tick(void)
>  	struct pt_regs *regs = get_irq_regs();
>  	unsigned long now;
>  
> +	if (softlockup_off)
> +		return;
> +
>  	if (touch_timestamp == 0) {
>  		touch_softlockup_watchdog();
>  		return;
> @@ -306,9 +314,19 @@ __init void spawn_softlockup_task(void)
>  	void *cpu = (void *)(long)smp_processor_id();
>  	int err = cpu_callback(&cpu_nfb, CPU_UP_PREPARE, cpu);
>  
> +	if (softlockup_off)
> +		return;
> +
>  	BUG_ON(err == NOTIFY_BAD);
>  	cpu_callback(&cpu_nfb, CPU_ONLINE, cpu);
>  	register_cpu_notifier(&cpu_nfb);
>  
>  	atomic_notifier_chain_register(&panic_notifier_list, &panic_block);
>  }
> +
> +static int __init disable_softlockup_detection(char *str)
> +{
> +	softlockup_off = 1;
> +	return 1;
> +}
> +__setup("nosoftlockup", disable_softlockup_detection);
> --

---
~Randy
