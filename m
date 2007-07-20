Return-Path: <linux-kernel-owner+w=401wt.eu-S940478AbXGTQEB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940478AbXGTQEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:04:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S939188AbXGTQDv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:03:51 -0400
Received: from tomts22.bellnexxia.net ([209.226.175.184]:62818 "EHLO
	tomts22-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932355AbXGTQDu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:03:50 -0400
Date: Fri, 20 Jul 2007 12:03:47 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <ak@suse.de>
Cc: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [3/11] x86: Stop MCEs and NMIs during code patching
Message-ID: <20070720160347.GB1960@Krystal>
References: <20070720532.949522000@suse.de> <20070720153247.75CAD14E7C@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20070720153247.75CAD14E7C@wotan.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 12:01:33 up 3 days, 10:35,  3 users,  load average: 0.36, 0.23, 0.19
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (ak@suse.de) wrote:

> Index: linux/arch/x86_64/kernel/nmi.c
> ===================================================================
> --- linux.orig/arch/x86_64/kernel/nmi.c
> +++ linux/arch/x86_64/kernel/nmi.c
> @@ -384,11 +384,14 @@ int __kprobes nmi_watchdog_tick(struct p
>  	return rc;
>  }
>  
> +static unsigned ignore_nmis;
> +
>  asmlinkage __kprobes void do_nmi(struct pt_regs * regs, long error_code)
>  {
>  	nmi_enter();
>  	add_pda(__nmi_count,1);
> -	default_do_nmi(regs);
> +	if (!ignore_nmis) 
> +		default_do_nmi(regs);
>  	nmi_exit();
>  }
>  
> @@ -401,6 +404,18 @@ int do_nmi_callback(struct pt_regs * reg
>  	return 0;
>  }
>  
> +void stop_nmi(void)
> +{
> +	ignore_nmis++;
> +	acpi_nmi_disable();
> +}

I would do:

acpi_nmi_disable();
ignore_nmis++;

Instead, so we minimize the chances to have to drop a do_nmi.

> +
> +void restart_nmi(void)
> +{
> +	ignore_nmis--;
> +	acpi_nmi_enable();
> +}
> +
>  #ifdef CONFIG_SYSCTL
>  
...
>  #endif /* ASM_NMI_H */
> Index: linux/arch/i386/kernel/traps.c
> ===================================================================
> --- linux.orig/arch/i386/kernel/traps.c
> +++ linux/arch/i386/kernel/traps.c
> @@ -774,6 +774,8 @@ static __kprobes void default_do_nmi(str
>  	reassert_nmi();
>  }
>  
> +static int ignore_nmis;
> +
>  fastcall __kprobes void do_nmi(struct pt_regs * regs, long error_code)
>  {
>  	int cpu;
> @@ -784,11 +786,24 @@ fastcall __kprobes void do_nmi(struct pt
>  
>  	++nmi_count(cpu);
>  
> -	default_do_nmi(regs);
> +	if (!ignore_nmis)
> +		default_do_nmi(regs);
>  
>  	nmi_exit();
>  }
>  
> +void stop_nmi(void)
> +{
> +	ignore_nmis++;
> +	acpi_nmi_disable();
> +}
> +

Same here, I would swap the two.

> +void restart_nmi(void)
> +{
> +	ignore_nmis--;
> +	acpi_nmi_enable();
> +}
> +

Besides that, it looks good.

Mathieu

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
