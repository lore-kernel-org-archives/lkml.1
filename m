Return-Path: <linux-kernel-owner+w=401wt.eu-S1760111AbYDOHa2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760111AbYDOHa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2008 03:30:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760004AbYDOH3z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Apr 2008 03:29:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52082 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759857AbYDOH3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2008 03:29:54 -0400
Date: Tue, 15 Apr 2008 00:29:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Erik Bosman <ebn310@few.vu.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrea Arcangeli <andrea@cpushare.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] x86: Implement prctl PR_GET_TSC and PR_SET_TSC
Message-Id: <20080415002918.6a3b40b6.akpm@linux-foundation.org>
In-Reply-To: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
References: <Pine.GSO.4.56.0804111855070.16669@keg.few.vu.nl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Apr 2008 18:55:58 +0200 (CEST) Erik Bosman <ebn310@few.vu.nl> wrote:

> 
>     x86: Implement prctl PR_GET_TSC and PR_SET_TSC
> 
>     This patch adds a configure option CONFIG_DISABLE_TSC
>     (off by default) for the x86 platform to enable the
>     PR_GET_TSC and PR_SET_TSC commands. These control the
>     ability to use the timestamp counter from userspace
>     (the RDTSC instruction.)
> 
>     This patch uses code earlier used to disable the
>     timestamp counter for the SECCOMP framework. It used
>     to disable the RDTSC on 32 bit kernels, but allow it
>     on x86_64. This patch makes SECCOMP disable the
>     timestamp counter whenever CONFIG_DISABLE_TSC is
>     enabled.
> 
> ...
>
> +config DISABLE_TSC
> +	def_bool n
> +	prompt "Make availability of the RDTSC instruction configurable"
> +	depends on (X86_32 || X86_64) && EXPERIMENTAL
> +	help
> +	  While the RDTSC instruction allows for very precise time
> +	  measurements, it is also a source for non-determinism
> +	  during the execution of a process which can be a problem in some
> +	  security contexts. This option adds prctl commands to configure
> +	  and test the availability of the RDTSC instruction on a
> +	  per-process basis. Choosing this option may cause a small
> +	  performance hit during context switching.
> +
> +	  If unsure, say N.
> +
>  config SECCOMP
>  	def_bool y
>  	prompt "Enable seccomp to safely compute untrusted bytecode"
> diff --git a/arch/x86/kernel/process_32.c b/arch/x86/kernel/process_32.c
> index 6496344..e6a861f 100644
> --- a/arch/x86/kernel/process_32.c
> +++ b/arch/x86/kernel/process_32.c
> @@ -36,6 +36,7 @@
>  #include <linux/personality.h>
>  #include <linux/tick.h>
>  #include <linux/percpu.h>
> +#include <linux/prctl.h>
> 
>  #include <asm/uaccess.h>
>  #include <asm/pgtable.h>
> @@ -528,11 +529,12 @@ start_thread(struct pt_regs *regs, unsigned long new_ip, unsigned long new_sp)
>  }
>  EXPORT_SYMBOL_GPL(start_thread);
> 
> -#ifdef CONFIG_SECCOMP
> +#ifdef CONFIG_DISABLE_TSC
>  static void hard_disable_TSC(void)
>  {
>  	write_cr4(read_cr4() | X86_CR4_TSD);
>  }

Won't this break this build if CONFIG_DISABLE_TSC=n and CONFIG_SECCOMP=y?


The prctl.h and sys.c parts look OK to me.  I'll consider this a git-x86
patch.
