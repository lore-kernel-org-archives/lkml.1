Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbZBWOCU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbZBWOCU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 09:02:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZBWOCC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 09:02:02 -0500
Received: from smtp116.mail.mud.yahoo.com ([209.191.84.165]:28146 "HELO
	smtp116.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753745AbZBWOCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 09:02:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=uVILUDDVAG2tyslswAKhG45f4rGIj+d7JtKEgvncY0AUm5ZSxgpmY96aeb0exqoJSxdbFdz/X4vDs+ozV6DXGVBBpo3//JI0STyY2bVQyQ8udenIUp0eH3sRHGPuLk/7K2CWAmv5pjIgZDQyxKwQ06ZTQsuMbTnMyidikqp30rw=  ;
X-YMail-OSG: dmzxchcVM1kx0PWQwZnqOWjpMKslIXzSnjUOM4OdDeSBWs7gZqoX5lg6khnLPbFdZKz_Snz4DguKzgafCkZnX2DHricF0HcW1tkMYEgGQOtk62dHK383_zpivJBszzgnG4UzAuS7lHIdKg93IaZf1VZ5SBnEfpnaipRVXB19aHF9.c8jHq_ozy3kXY7HXcDkwxgjqq0op71GD1pHvWlMukP5TVI-
X-Yahoo-Newman-Property: ymail-3
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: paulmck@linux.vnet.ibm.com
Subject: Re: [PATCH] mm: fix lazy vmap purging (use-after-free error)
Date: Tue, 24 Feb 2009 00:29:36 +1100
User-Agent: KMail/1.9.51 (KDE/4.0.4; ; )
Cc: Vegard Nossum <vegard.nossum@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       stable@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       linux-kernel@vger.kernel.org
References: <20090220140157.GA12799@elte.hu> <20090222030030.GD6860@linux.vnet.ibm.com> <20090223051709.GA5990@linux.vnet.ibm.com>
In-Reply-To: <20090223051709.GA5990@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902240029.37815.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 23 February 2009 16:17:09 Paul E. McKenney wrote:

> The boot CPU runs in the context of its idle thread during boot-up.
> During this time, idle_cpu(0) will always return nonzero, which will
> fool Classic and Hierarchical RCU into deciding that a large chunk of
> the boot-up sequence is a big long quiescent state.  This in turn causes
> RCU to prematurely end grace periods during this time.
>
> This patch creates a new global variable that is set to 1 just before
> the boot CPU first enters the scheduler, after which the idle task
> really is idle.

Nice work all (btw. if this patch goes in rather than using system_state,
then please make the variable __read_mostly).

Vegard, I would like to still use your patch in vmalloc.c as well. It
solves a possible use-after-free with preemptible RCU, and also helps with
a patch I have to conditionally disable lazy vmap unmapping (for Xen).

We _could_ disable RCU there instead to solve the preemptible RCU bug, but
your patch I think is less overhead.

So with appropriate changelog update, please also resend your patch
(with Acked-by: Nick Piggin <npiggin@suse.de>)

Thanks,
Nick

> Located-by: Vegard Nossum <vegard.nossum@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>
>  init/main.c         |    3 +++
>  kernel/rcuclassic.c |    4 +++-
>  kernel/rcutree.c    |    4 +++-
>  3 files changed, 9 insertions(+), 2 deletions(-)
>
> diff --git a/init/main.c b/init/main.c
> index 8442094..51f4b71 100644
> --- a/init/main.c
> +++ b/init/main.c
> @@ -121,6 +121,8 @@ static char *static_command_line;
>  static char *execute_command;
>  static char *ramdisk_execute_command;
>
> +int idle_task_is_really_idle;	/* set to 1 late in boot. */
> +
>  #ifdef CONFIG_SMP
>  /* Setup configured maximum number of CPUs to activate */
>  unsigned int __initdata setup_max_cpus = NR_CPUS;
> @@ -463,6 +465,7 @@ static noinline void __init_refok rest_init(void)
>  	 * at least once to get things moving:
>  	 */
>  	init_idle_bootup_task(current);
> +	idle_task_is_really_idle = 1;
>  	preempt_enable_no_resched();
>  	schedule();
>  	preempt_disable();
> diff --git a/kernel/rcuclassic.c b/kernel/rcuclassic.c
> index bd5a900..a758fa6 100644
> --- a/kernel/rcuclassic.c
> +++ b/kernel/rcuclassic.c
> @@ -678,8 +678,10 @@ int rcu_needs_cpu(int cpu)
>   */
>  void rcu_check_callbacks(int cpu, int user)
>  {
> +	extern int idle_task_is_really_idle;
> +
>  	if (user ||
> -	    (idle_cpu(cpu) && !in_softirq() &&
> +	    (idle_cpu(cpu) && idle_task_is_really_idle && !in_softirq() &&
>  				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
>
>  		/*
> diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> index b2fd602..e996d85 100644
> --- a/kernel/rcutree.c
> +++ b/kernel/rcutree.c
> @@ -947,8 +947,10 @@ static void rcu_do_batch(struct rcu_data *rdp)
>   */
>  void rcu_check_callbacks(int cpu, int user)
>  {
> +	extern int idle_task_is_really_idle;
> +
>  	if (user ||
> -	    (idle_cpu(cpu) && !in_softirq() &&
> +	    (idle_cpu(cpu) && idle_task_is_really_idle && !in_softirq() &&
>  				hardirq_count() <= (1 << HARDIRQ_SHIFT))) {
>
>  		/*
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


