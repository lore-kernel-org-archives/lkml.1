Return-Path: <linux-kernel-owner+w=401wt.eu-S1030197AbXCHIOq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030197AbXCHIOq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2007 03:14:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030206AbXCHIOq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Mar 2007 03:14:46 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52872 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1030197AbXCHIOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2007 03:14:45 -0500
Date: Thu, 8 Mar 2007 09:14:45 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Dave Jones <davej@redhat.com>, David Rientjes <rientjes@google.com>,
       Dominik Brodowski <linux@brodo.de>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86_64: X86_P4_CLOCKMOD must select CPU_FREQ_TABLE
Message-ID: <20070308081445.GM3441@stusta.de>
References: <Pine.LNX.4.64.0703062230001.1819@chino.kir.corp.google.com> <20070307065458.GA15453@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070307065458.GA15453@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2007 at 01:54:58AM -0500, Dave Jones wrote:
> On Tue, Mar 06, 2007 at 10:33:05PM -0800, David Rientjes wrote:
>  > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_verify':p4-clockmod.c:(.text.cpufreq_p4_verify+0x8): undefined reference to `cpufreq_frequency_table_verify'
>  > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_cpu_exit':p4-clockmod.c:(.text.cpufreq_p4_cpu_exit+0x8): undefined reference to `cpufreq_frequency_table_put_attr'
>  > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_cpu_init':p4-clockmod.c:(.text.cpufreq_p4_cpu_init+0x13b): undefined reference to `cpufreq_frequency_table_get_attr'
>  > :p4-clockmod.c:(.text.cpufreq_p4_cpu_init+0x163): undefined reference to `cpufreq_frequency_table_cpuinfo'
>  > arch/x86_64/kernel/built-in.o: In function `cpufreq_p4_target':p4-clockmod.c:(.text.cpufreq_p4_target+0x21): undefined reference to `cpufreq_frequency_table_target'
>  > arch/x86_64/kernel/built-in.o: In function `k8nops':alternative.c:(.data+0x2b70): undefined reference to `cpufreq_freq_attr_scaling_available_freqs'
> 
>  > CONFIG_CPU_FREQ=y
>  > CONFIG_CPU_FREQ_TABLE=m
> 
>  > CONFIG_X86_P4_CLOCKMOD=y
> 
> So P4_CLOCKMOD does a 'select CPU_FREQ_TABLE', but for some reason, that makes it =m,
> not the same as whatever the option that is doing the 'select' is set to
> (which is what I thought it did).


No, it does not on x86_64.


> Given the cpufreq table code is tiny anyway, I'm wondering if its worth the
> pain of having it be modular, instead just making it be built-in to cpufreq.
> 
> Give the diff below a shot?
> 
> 	Dave
> 
> diff --git a/drivers/cpufreq/Kconfig b/drivers/cpufreq/Kconfig
> index d155e81..74747d9 100644
> --- a/drivers/cpufreq/Kconfig
> +++ b/drivers/cpufreq/Kconfig
> @@ -16,7 +16,7 @@ config CPU_FREQ
>  if CPU_FREQ
>  
>  config CPU_FREQ_TABLE
> -       tristate
> +       bool
>  
>  config CPU_FREQ_DEBUG
>         bool "Enable CPUfreq debugging"


This patch is wrong, and it works only by chance due to 
CONFIG_X86_POWERNOW_K8=m and CONFIG_X86_ACPI_CPUFREQ=m.

Below is a fix for the real bug.

cu
Adrian


<--  snip  -->


X86_P4_CLOCKMOD must select CPU_FREQ_TABLE.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc3-mm2/arch/x86_64/kernel/cpufreq/Kconfig.old	2007-03-08 09:12:46.000000000 +0100
+++ linux-2.6.21-rc3-mm2/arch/x86_64/kernel/cpufreq/Kconfig	2007-03-08 09:13:12.000000000 +0100
@@ -75,6 +75,7 @@
 config X86_P4_CLOCKMOD
 	tristate "Intel Pentium 4 clock modulation"
 	depends on EMBEDDED
+	select CPU_FREQ_TABLE
 	help
 	  This adds the clock modulation driver for Intel Pentium 4 / XEON
 	  processors.  When enabled it will lower CPU temperature by skipping

