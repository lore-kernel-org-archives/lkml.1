Return-Path: <linux-kernel-owner+w=401wt.eu-S1752739AbYLZBJf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739AbYLZBJf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Dec 2008 20:09:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYLZBJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Dec 2008 20:09:07 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58173 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138AbYLZBJE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Dec 2008 20:09:04 -0500
Date: Thu, 25 Dec 2008 10:46:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
       akpm@linux-foundation.org, ralf@linux-mips.org, kernel@wantstofly.org,
       hskinnemoen@atmel.com, cooloney@kernel.org, tony.luck@intel.com,
       geert@linux-m68k.org, zippel@linux-m68k.org, jwboyer@linux.vnet.ibm.com,
       mporter@kernel.crashing.org, grant.likely@secretlab.ca,
       paulus@samba.org, benh@kernel.crashing.org, dhowells@redhat.com,
       yasutake.koichi@jp.panasonic.com, lethal@linux-sh.org, hpa@zytor.com
Subject: Re: [PATCH -tip] Switch arm defconfig files from
	CONFIG_CLASSIC_RCU to CONFIG_TREE_RCU.
Message-ID: <20081225184612.GH6912@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1229991147545-git-send-email-paulmck@linux.vnet.ibm.com> <12299911471985-git-send-email-paulmck@linux.vnet.ibm.com> <20081223142542.GC29151@elte.hu> <20081225083611.GA14968@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081225083611.GA14968@elte.hu>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 25, 2008 at 09:36:11AM +0100, Ingo Molnar wrote:
> 
> below is the fix for another small buglet that hits architectures that do 
> not include kernel/Kconfig.preempt.

Hmmm...  Now that you mention it, I made a similar error some time back.
You would think that I would learn.  :-/

Thank you, and Merry Christmas!!!

							Thanx, Paul

> 	Ingo
> 
> --------------->
> >From 12d79bafb75639f406a9f71aab94808c414c836e Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Thu, 25 Dec 2008 09:31:28 +0100
> Subject: [PATCH] rcu: provide RCU options on non-preempt architectures too
> 
> Impact: build fix
> 
> Some old architectures still do not use kernel/Kconfig.preempt, so the
> moving of the RCU options there broke their build:
> 
>  In file included from /home/mingo/tip/include/linux/sem.h:81,
>                  from /home/mingo/tip/include/linux/sched.h:69,
>                  from /home/mingo/tip/arch/alpha/kernel/asm-offsets.c:9:
>  /home/mingo/tip/include/linux/rcupdate.h:62:2: error: #error "Unknown RCU implementation specified to kernel configuration"
> 
> Move these options back to init/Kconfig, which every architecture
> includes.
> 
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  init/Kconfig           |   74 +++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/Kconfig.preempt |   75 ------------------------------------------------
>  2 files changed, 74 insertions(+), 75 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 9dd7958..6b0fded 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -928,6 +928,80 @@ source "block/Kconfig"
>  config PREEMPT_NOTIFIERS
>  	bool
> 
> +choice
> +	prompt "RCU Implementation"
> +	default CLASSIC_RCU
> +
> +config CLASSIC_RCU
> +	bool "Classic RCU"
> +	help
> +	  This option selects the classic RCU implementation that is
> +	  designed for best read-side performance on non-realtime
> +	  systems.
> +
> +	  Select this option if you are unsure.
> +
> +config TREE_RCU
> +	bool "Tree-based hierarchical RCU"
> +	help
> +	  This option selects the RCU implementation that is
> +	  designed for very large SMP system with hundreds or
> +	  thousands of CPUs.
> +
> +config PREEMPT_RCU
> +	bool "Preemptible RCU"
> +	depends on PREEMPT
> +	help
> +	  This option reduces the latency of the kernel by making certain
> +	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> +	  this option is selected then read-only RCU sections become
> +	  preemptible. This helps latency, but may expose bugs due to
> +	  now-naive assumptions about each RCU read-side critical section
> +	  remaining on a given CPU through its execution.
> +
> +endchoice
> +
> +config RCU_TRACE
> +	bool "Enable tracing for RCU"
> +	depends on TREE_RCU || PREEMPT_RCU
> +	help
> +	  This option provides tracing in RCU which presents stats
> +	  in debugfs for debugging RCU implementation.
> +
> +	  Say Y here if you want to enable RCU tracing
> +	  Say N if you are unsure.
> +
> +config RCU_FANOUT
> +	int "Tree-based hierarchical RCU fanout value"
> +	range 2 64 if 64BIT
> +	range 2 32 if !64BIT
> +	depends on TREE_RCU
> +	default 64 if 64BIT
> +	default 32 if !64BIT
> +	help
> +	  This option controls the fanout of hierarchical implementations
> +	  of RCU, allowing RCU to work efficiently on machines with
> +	  large numbers of CPUs.  This value must be at least the cube
> +	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
> +	  systems and up to 262,144 for 64-bit systems.
> +
> +	  Select a specific number if testing RCU itself.
> +	  Take the default if unsure.
> +
> +config RCU_FANOUT_EXACT
> +	bool "Disable tree-based hierarchical RCU auto-balancing"
> +	depends on TREE_RCU
> +	default n
> +	help
> +	  This option forces use of the exact RCU_FANOUT value specified,
> +	  regardless of imbalances in the hierarchy.  This is useful for
> +	  testing RCU itself, and might one day be useful on systems with
> +	  strong NUMA behavior.
> +
> +	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
> +
> +	  Say N if unsure.
> +
>  config TREE_RCU_TRACE
>  	def_bool RCU_TRACE && TREE_RCU
>  	select DEBUG_FS
> diff --git a/kernel/Kconfig.preempt b/kernel/Kconfig.preempt
> index 463f297..bf987b9 100644
> --- a/kernel/Kconfig.preempt
> +++ b/kernel/Kconfig.preempt
> @@ -52,78 +52,3 @@ config PREEMPT
> 
>  endchoice
> 
> -choice
> -	prompt "RCU Implementation"
> -	default CLASSIC_RCU
> -
> -config CLASSIC_RCU
> -	bool "Classic RCU"
> -	help
> -	  This option selects the classic RCU implementation that is
> -	  designed for best read-side performance on non-realtime
> -	  systems.
> -	  
> -	  Select this option if you are unsure.
> -
> -config TREE_RCU
> -	bool "Tree-based hierarchical RCU"
> -	help
> -	  This option selects the RCU implementation that is
> -	  designed for very large SMP system with hundreds or
> -	  thousands of CPUs.
> -
> -config PREEMPT_RCU
> -	bool "Preemptible RCU"
> -	depends on PREEMPT
> -	help
> -	  This option reduces the latency of the kernel by making certain
> -	  RCU sections preemptible. Normally RCU code is non-preemptible, if
> -	  this option is selected then read-only RCU sections become
> -	  preemptible. This helps latency, but may expose bugs due to
> -	  now-naive assumptions about each RCU read-side critical section
> -	  remaining on a given CPU through its execution.
> -
> -endchoice
> -
> -config RCU_TRACE
> -	bool "Enable tracing for RCU"
> -	depends on TREE_RCU || PREEMPT_RCU
> -	help
> -	  This option provides tracing in RCU which presents stats
> -	  in debugfs for debugging RCU implementation.
> -
> -	  Say Y here if you want to enable RCU tracing
> -	  Say N if you are unsure.
> -
> -config RCU_FANOUT
> -	int "Tree-based hierarchical RCU fanout value"
> -	range 2 64 if 64BIT
> -	range 2 32 if !64BIT
> -	depends on TREE_RCU
> -	default 64 if 64BIT
> -	default 32 if !64BIT
> -	help
> -	  This option controls the fanout of hierarchical implementations
> -	  of RCU, allowing RCU to work efficiently on machines with
> -	  large numbers of CPUs.  This value must be at least the cube
> -	  root of NR_CPUS, which allows NR_CPUS up to 32,768 for 32-bit
> -	  systems and up to 262,144 for 64-bit systems.
> -
> -	  Select a specific number if testing RCU itself.
> -	  Take the default if unsure.
> -
> -config RCU_FANOUT_EXACT
> -	bool "Disable tree-based hierarchical RCU auto-balancing"
> -	depends on TREE_RCU
> -	default n
> -	help
> -	  This option forces use of the exact RCU_FANOUT value specified,
> -	  regardless of imbalances in the hierarchy.  This is useful for
> -	  testing RCU itself, and might one day be useful on systems with
> -	  strong NUMA behavior.
> -
> -	  Without RCU_FANOUT_EXACT, the code will balance the hierarchy.
> -
> -	  Say n if unsure.
> -
> -	
