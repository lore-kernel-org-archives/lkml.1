Return-Path: <linux-kernel-owner+w=401wt.eu-S938740AbXFHPLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938740AbXFHPLs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 11:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937165AbXFHPLB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 11:11:01 -0400
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2722 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1765745AbXFHPLA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 11:11:00 -0400
Date: Thu, 7 Jun 2007 14:01:02 +0000
From: Pavel Machek <pavel@ucw.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ingo Molnar <mingo@elte.hu>,
       Zwane Mwaikambo <zwane@linuxpower.ca>
Subject: Re: [PATCH] x86: Document the hotplug code is incompatible with x86 irq handling
Message-ID: <20070607140102.GA9094@ucw.cz>
References: <m1tztt3yqy.fsf@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1tztt3yqy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I just realized that except for doing the code review and noticing
> that the current cpu hotplug code is fundamentally incompatible
> with x86 I haven't done anything about it.  So here is my patch
> to document what is wrong.
> 
> The current cpu hotplug code requires irqs to be migrated from a cpu
> outside of irq context.  On x86 ioapics simply do not support this,
> making the code unfixable without major redesign of the generic cpu
> hotplug code.
> 
> So this patch makes CPU_HOTPLUG on x86 depend on CONFIG_BROKEN
> and adds a WARN_ON so people that do enable it are not in doubt about
> which part of the code is broken, even if it does work for them.


> --- a/arch/i386/kernel/irq.c
> +++ b/arch/i386/kernel/irq.c
> @@ -312,6 +312,19 @@ void fixup_irqs(cpumask_t map)
>  	unsigned int irq;
>  	static int warned;
>  
> +	/* 
> +	 * Function is so wrong at so many levels.
> +	 * - We migrate irqs that are directed at the cpu we are
> +	 *   removing.

Is this about irq pinning?

> +	 * - We cannot safely migrate ioapic irqs on x86 except in
> +	 *   side of irq context.

'inside'?

Can you be more specific for this one?

> +	 * Since someone probably finds this useful just warn very
> +	 * loudly until cpu hotplug is redesigned.
> +	 */
> +	WARN_ON(1);

Ugh, no, this does not warn anyone. This will just make people ask me
why they see stack trace while suspending... and we are not interested
in the stack trace, anyway.

printk(KERN_WARNING)?

> index 5ce9443..a61c4f2 100644
> --- a/arch/x86_64/Kconfig
> +++ b/arch/x86_64/Kconfig
> @@ -429,7 +429,7 @@ config NR_CPUS
>  
>  config HOTPLUG_CPU
>  	bool "Support for suspend on SMP and hot-pluggable CPUs (EXPERIMENTAL)"
> -	depends on SMP && HOTPLUG && EXPERIMENTAL
> +	depends on SMP && HOTPLUG && EXPERIMENTAL && BROKEN
>  	help

Great, this will force everyone and their dog to enable broken, making
broken useless. Please don't.
							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
