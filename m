Return-Path: <linux-kernel-owner+w=401wt.eu-S932454AbZHQRVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932454AbZHQRVn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 13:21:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932384AbZHQRVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 13:21:42 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45005 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932333AbZHQRVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 13:21:41 -0400
Subject: Re: [PATCH -tip/core/rcu 2/6] Introduce cpu_notifier() to handle
 !HOTPLUG_CPU case
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       hugh.dickins@tiscali.co.uk, benh@kernel.crashing.org
In-Reply-To: <12503552312611-git-send-email->
References: <20090815165153.GA8886@linux.vnet.ibm.com>
	 <12503552312611-git-send-email->
Content-Type: text/plain
Date: Mon, 17 Aug 2009 10:21:59 -0700
Message-Id: <1250529719.2709.11.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-08-15 at 09:53 -0700, Paul E. McKenney wrote:
> From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> This patch introduces a new cpu_notifier() API that is similar to
> hotcpu_notifier(), but which also notifies of CPUs coming online during
> boot in the !HOTPLUG_CPU case.
[...]
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

These two definitions seem inconsistent.  I think the first one needs to
change to use do { ... } while(0) as well, so it eats the subsequent
semicolon.

Does this really want to live under defined(CONFIG_HOTPLUG_CPU)?  What
happens when onlining CPUs during the !define(CONFIG_HOTPLUG_CPU) case?
This seems somewhat inconsistent with the explanation in your commit
message; can you clarify?

Also, why !defined(MODULE)?

- Josh Triplett

