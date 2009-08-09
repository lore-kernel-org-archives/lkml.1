Return-Path: <linux-kernel-owner+w=401wt.eu-S1752238AbZHIUyS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238AbZHIUyS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Aug 2009 16:54:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751670AbZHIUyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 9 Aug 2009 16:54:18 -0400
Received: from mk-filter-4-a-1.mail.uk.tiscali.com ([212.74.100.55]:6133 "EHLO
	mk-filter-4-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751613AbZHIUyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Aug 2009 16:54:17 -0400
X-Trace: 240009575/mk-filter-4.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/79.69.54.164/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 79.69.54.164
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgoFAL/UfkpPRTak/2dsb2JhbACBUso5hBgF
X-IronPort-AV: E=Sophos;i="4.43,349,1246834800"; 
   d="scan'208";a="240009575"
Date: Sun, 9 Aug 2009 21:53:53 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Ingo Molnar <mingo@elte.hu>, Ben Herrenschmidt <benh@kernel.crashing.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_PREEMPT_RCU in next/mmotm
In-Reply-To: <20090809185753.GG6866@linux.vnet.ibm.com>
Message-ID: <Pine.LNX.4.64.0908092139090.3194@sister.anvils>
References: <Pine.LNX.4.64.0908081956580.12300@sister.anvils>
 <20090808235634.GB6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908090414320.18096@sister.anvils>
 <20090809053308.GD6866@linux.vnet.ibm.com> <Pine.LNX.4.64.0908091209150.23855@sister.anvils>
 <Pine.LNX.4.64.0908091346450.27358@sister.anvils> <20090809185753.GG6866@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 9 Aug 2009, Paul E. McKenney wrote:
> 
> I introduced the problem in commit 7fe616c5dd50a50f334edec1ea0580b90b7af0d9
> by changing from register_cpu_notifier() to hotcpu_notifier().  The former
> lets you know when CPUs come on line unconditionally, the latter only
> when CONFIG_HOTPLUG_CPU is in effect.
> 
> But hotcpu_notifier() is much nicer to use, so I propose introducing
> a cpu_notifier() that is invoked like hotcpu_notifier() is, but is
> unconditional in the same way that register_cpu_notifier().
> 
> Something like the following (untested, probably does not compile):
> 
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index 4d668e0..d5dfc1f 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -48,6 +48,15 @@ struct notifier_block;
>  
>  #ifdef CONFIG_SMP
>  /* Need to know about CPUs going up/down? */
> +#if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
> +#define cpu_notifier(fn, pri) {					\
> +	static struct notifier_block fn##_nb __cpuinitdata =	\
> +		{ .notifier_call = fn, .priority = pri };	\
> +	register_cpu_notifier(&fn##_nb);			\
> +}
> +#else /* #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
> +#define cpu_notifier(fn, pri)	do { (void)(fn); } while (0)
> +#endif /* #else #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE) */
>  #ifdef CONFIG_HOTPLUG_CPU
>  extern int register_cpu_notifier(struct notifier_block *nb);
>  extern void unregister_cpu_notifier(struct notifier_block *nb);
> @@ -99,11 +108,7 @@ extern struct sysdev_class cpu_sysdev_class;
>  
>  extern void get_online_cpus(void);
>  extern void put_online_cpus(void);
> -#define hotcpu_notifier(fn, pri) {				\
> -	static struct notifier_block fn##_nb __cpuinitdata =	\
> -		{ .notifier_call = fn, .priority = pri };	\
> -	register_cpu_notifier(&fn##_nb);			\
> -}
> +#define hotcpu_notifier(fn, pri)	cpu_notifier(fn, pri)
>  #define register_hotcpu_notifier(nb)	register_cpu_notifier(nb)
>  #define unregister_hotcpu_notifier(nb)	unregister_cpu_notifier(nb)
>  int cpu_down(unsigned int cpu);
> diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> index 9f0584e..c1bbfd5 100644
> --- a/kernel/rcupdate.c
> +++ b/kernel/rcupdate.c
> @@ -251,7 +251,7 @@ void __init rcu_init(void)
>  	int i;
>  
>  	__rcu_init();
> -	hotcpu_notifier(rcu_barrier_cpu_hotplug, 0);
> +	cpu_notifier(rcu_barrier_cpu_hotplug, 0);
>  
>  	/*
>  	 * We don't need protection against CPU-hotplug here because
> 
[ removed repeat of rcupdate.c patch ]
> 
> Thoughts?

That builds and works for me, with or without CONFIG_HOTPLUG_CPU.

But I didn't get what you're achieving with the MODULE part of it;
and (I'm not a notifier buff at all) it does seems rather baroque to
me - a single callsite, why not stick with register_cpu_notifier()?

Ah, perhaps it's your ambition to move others over to this
(or perhaps it's your ambition to leave that to someone else ;-)

Hugh
