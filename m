Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbZHHRyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbZHHRyX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Aug 2009 13:54:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751218AbZHHRyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Aug 2009 13:54:22 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36790 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107AbZHHRyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Aug 2009 13:54:22 -0400
Date: Sat, 8 Aug 2009 19:53:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] OOPS in identify_cpu() on CPUs without CPUID
Message-ID: <20090808175344.GA8099@elte.hu>
References: <200908081908.12240.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200908081908.12240.linux@rainbow-software.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ondrej Zary <linux@rainbow-software.org> wrote:

> Kernel is broken for x86 CPUs without CPUID since 2.6.28. It 
> crashes with NULL pointer dereference in identify_cpu():
> 
> 766        generic_identify(c);
> 767
> 768-->     if (this_cpu->c_identify)
> 769                this_cpu->c_identify(c);
> 
> this_cpu is NULL. This is because it's only initialized in 
> get_cpu_vendor() function, which is not called if the CPU has no 
> CPUID instruction.

indeed ...

> Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
> 
> --- linux-2.6.30.4-orig/arch/x86/kernel/cpu/common.c	2009-06-10 05:05:27.000000000 +0200
> +++ linux-2.6.30.4-router/arch/x86/kernel/cpu/common.c	2009-08-08 18:00:21.000000000 +0200
> @@ -699,6 +699,7 @@
>  
>  static void __cpuinit generic_identify(struct cpuinfo_x86 *c)
>  {
> +	this_cpu = &default_cpu;
>  	c->extended_cpuid_level = 0;
>  
>  	if (!have_cpuid_p())

How about initializing this_cpu instead, via:

static const struct cpu_dev *this_cpu __cpuinitdata = &default_cpu;

?
	Ingo
