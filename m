Return-Path: <linux-kernel-owner+w=401wt.eu-S1761274AbZLPKQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761274AbZLPKQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 05:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759309AbZLPKQr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 05:16:47 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:44527 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755528AbZLPKQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 05:16:45 -0500
Subject: Re: [PATCH] fix cpu hotplug test failures on powerpc
From: Peter Zijlstra <peterz@infradead.org>
To: Xiaotian Feng <dfeng@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
In-Reply-To: <1260954957-1518-1-git-send-email-dfeng@redhat.com>
References: <4B289955.2010705@in.ibm.com>
	 <1260954957-1518-1-git-send-email-dfeng@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Dec 2009 11:16:32 +0100
Message-ID: <1260958592.17860.25.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-12-16 at 17:15 +0800, Xiaotian Feng wrote:
> Sachin found cpu hotplug test failures on powerpc, which made kernel
> hangs on his POWER box. This is addressed in
> http://marc.info/?l=linux-kernel&m=126052886204649&w=2
> 
> commit 6ad4c18(sched: Fix balance vs hotplug race), switches to
> cpu_active_mask, but at some specific situation, kernel may cause
> some cpu inactive but online.
> 
> In some powerpc machine, hotplug cpu0 is allowed. If cpu0 is the
> last alive cpu, when we tried to offline cpu0, we'll inactive cpu0
> in cpu_down(), after goes into __cpu_down(), kernel found num_online_cpus
> is 1, returned -EBUSY but cpu0 is not changed back to active. So
> cpu0 is inactive but online.
> 
> The fix is to set cpu inactive when we're going to bring down the specific
> cpu in _cpu_down().

Good spotting, thanks! Some comments below.

> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
> Tested-by: Sachin Sant <sachinp@in.ibm.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> ---
>  kernel/cpu.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 291ac58..a1e7165 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -209,6 +209,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  		return -ENOMEM;
>  
>  	cpu_hotplug_begin();
> +	set_cpu_active(cpu, false);
>  	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
>  					hcpu, -1, &nr_calls);
>  	if (err == NOTIFY_BAD) {
> @@ -280,8 +281,6 @@ int __ref cpu_down(unsigned int cpu)
>  		goto out;
>  	}
>  
> -	set_cpu_active(cpu, false);
> -
>  	/*
>  	 * Make sure the all cpus did the reschedule and are not
>  	 * using stale version of the cpu_active_mask.

That renders the synchronize_sched() call down there useless, so might
as well remove it then.

> @@ -387,12 +386,6 @@ int disable_nonboot_cpus(void)
>  	 */
>  	cpumask_clear(frozen_cpus);
>  
> -	for_each_online_cpu(cpu) {
> -		if (cpu == first_cpu)
> -			continue;
> -		set_cpu_active(cpu, false);
> -	}
> -
>  	synchronize_sched();

And here too.

>  	printk("Disabling non-boot CPUs ...\n");



