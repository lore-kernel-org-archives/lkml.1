Return-Path: <linux-kernel-owner+w=401wt.eu-S1754787AbZLBIrj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754787AbZLBIrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 03:47:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754700AbZLBIrj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 03:47:39 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:53112 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLBIri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 03:47:38 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4B1629A0.60403@jp.fujitsu.com>
Date: Wed, 02 Dec 2009 17:47:28 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86/mce: timer must be setup unconditionally
References: <4B162A3C0200007800022F98@vpn.id2.novell.com>
In-Reply-To: <4B162A3C0200007800022F98@vpn.id2.novell.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Beulich wrote:
> mce_timer must be passed to setup_timer() in all cases, no matter
> whether it is going to be actually used. Otherwise, when the CPU gets
> brought down, its call to del_timer_sync() will never return, as the
> timer won't have a base associated, and hence lock_timer_base() will
> loop infinitely.

No, what we need to fix is hotplug callbacks.
So correct fix should be like "del/add timer conditionally when hotplug."

Thanks,
H.Seto

> (Patch applying to -tip is attached.)
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: <stable@kernel.org>
> 
> ---
>  arch/x86/kernel/cpu/mcheck/mce.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> --- linux-2.6.32-rc8/arch/x86/kernel/cpu/mcheck/mce.c
> +++ 2.6.32-rc8-x86-mce-setup-timer-always/arch/x86/kernel/cpu/mcheck/mce.c
> @@ -1374,13 +1374,14 @@ static void mce_init_timer(void)
>  	struct timer_list *t = &__get_cpu_var(mce_timer);
>  	int *n = &__get_cpu_var(mce_next_interval);
>  
> +	setup_timer(t, mcheck_timer, smp_processor_id());
> +
>  	if (mce_ignore_ce)
>  		return;
>  
>  	*n = check_interval * HZ;
>  	if (!*n)
>  		return;
> -	setup_timer(t, mcheck_timer, smp_processor_id());
>  	t->expires = round_jiffies(jiffies + *n);
>  	add_timer_on(t, smp_processor_id());
>  }

