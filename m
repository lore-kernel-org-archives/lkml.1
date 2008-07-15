Return-Path: <linux-kernel-owner+w=401wt.eu-S1761412AbYGORdl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761412AbYGORdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2008 13:33:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754443AbYGORdd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jul 2008 13:33:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:13961 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753921AbYGORdc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2008 13:33:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.30,367,1212390000"; 
   d="scan'208";a="315544858"
Date: Tue, 15 Jul 2008 10:33:18 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: let 32bit use apic_ops too - fix
Message-ID: <20080715173318.GA18203@linux-os.sc.intel.com>
References: <200807080141.05436.yhlu.kernel@gmail.com> <200807102038.26591.yhlu.kernel@gmail.com> <200807111841.55403.yhlu.kernel@gmail.com> <200807132219.35814.yhlu.kernel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200807132219.35814.yhlu.kernel@gmail.com>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 10:19:35PM -0700, Yinghai Lu wrote:
> 
> fix for pv.
> 
> Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
> 
> ---
>  arch/x86/kernel/paravirt.c |    5 ----
>  arch/x86/kernel/vmi_32.c   |   51 ++++++++++++++++++++++++++++++++++++++++++---
>  arch/x86/xen/enlighten.c   |   19 +++++++---------
>  include/asm-x86/paravirt.h |   29 -------------------------
>  4 files changed, 57 insertions(+), 47 deletions(-)
> 
> Index: linux-2.6/arch/x86/kernel/paravirt.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/paravirt.c
> +++ linux-2.6/arch/x86/kernel/paravirt.c
> @@ -373,11 +373,6 @@ struct pv_cpu_ops pv_cpu_ops = {
> 
>  struct pv_apic_ops pv_apic_ops = {
>  #ifdef CONFIG_X86_LOCAL_APIC
> -#ifndef CONFIG_X86_64
> -       .apic_write = native_apic_mem_write,
> -       .apic_write_atomic = native_apic_mem_write_atomic,
> -       .apic_read = native_apic_mem_read,
> -#endif
>         .setup_boot_clock = setup_boot_APIC_clock,
>         .setup_secondary_clock = setup_secondary_APIC_clock,
>         .startup_ipi_hook = paravirt_nop,
> Index: linux-2.6/arch/x86/kernel/vmi_32.c
> ===================================================================
> --- linux-2.6.orig/arch/x86/kernel/vmi_32.c
> +++ linux-2.6/arch/x86/kernel/vmi_32.c
> @@ -676,6 +676,50 @@ static inline int __init probe_vmi_rom(v
>         return 0;
>  }
> 
> +#ifdef CONFIG_X86_LOCAL_APIC
> +static u32 vmi_apic_read(u32 reg)
> +{
> +       return 0;
> +}
> +
> +static void vmi_apic_write(u32 reg, u32 val)
> +{
> +       /* Warn to see if there's any stray references */
> +       WARN_ON(1);
> +}
> +
> +static u64 vmi_apic_icr_read(void)
> +{
> +       return 0;
> +}
> +
> +static void vmi_apic_icr_write(u32 low, u32 id)
> +{
> +       /* Warn to see if there's any stray references */
> +       WARN_ON(1);
> +}
> +
> +static void vmi_apic_wait_icr_idle(void)
> +{
> +       return;
> +}
> +
> +static u32 vmi_safe_apic_wait_icr_idle(void)
> +{
> +       return 0;
> +}
> +
> +static struct apic_ops vmi_basic_apic_ops = {
> +        .read = vmi_apic_read,
> +        .write = vmi_apic_write,
> +        .write_atomic = vmi_apic_write,
> +        .icr_read = vmi_apic_icr_read,
> +        .icr_write = vmi_apic_icr_write,
> +        .wait_icr_idle = vmi_apic_wait_icr_idle,
> +        .safe_wait_icr_idle = vmi_safe_apic_wait_icr_idle,
> +};
> +#endif
> +
>  /*
>   * VMI setup common to all processors
>   */
> @@ -904,9 +948,10 @@ static inline int __init activate_vmi(vo
>  #endif
> 
>  #ifdef CONFIG_X86_LOCAL_APIC
> -       para_fill(pv_apic_ops.apic_read, APICRead);
> -       para_fill(pv_apic_ops.apic_write, APICWrite);
> -       para_fill(pv_apic_ops.apic_write_atomic, APICWrite);
> +       para_fill(vmi_basic_apic_ops.read, APICRead);
> +       para_fill(vmi_basic_apic_ops.write, APICWrite);
> +       para_fill(vmi_basic_apic_ops.write_atomic, APICWrite);
> +       apic_ops = &vmi_basic_apic_ops;

Yinghai, Looking more closely at this, based on my understanding this might be
wrong for VMI. Correct patch should be as follows. Any comments?

thanks,
suresh
---
Fix VMI apic_ops.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index b1375fa..3410196 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -145,6 +145,11 @@ static int modern_apic(void)
 	return lapic_get_version() >= 0x14;
 }
 
+/*
+ * Paravirt kernels also might be using these below ops. So we still
+ * use generic apic_read()/apic_write(), which might be pointing to different
+ * ops in PARAVIRT case.
+ */
 void xapic_wait_icr_idle(void)
 {
 	while (apic_read(APIC_ICR) & APIC_ICR_BUSY)
diff --git a/arch/x86/kernel/vmi_32.c b/arch/x86/kernel/vmi_32.c
index cf30743..d6897e4 100644
--- a/arch/x86/kernel/vmi_32.c
+++ b/arch/x86/kernel/vmi_32.c
@@ -676,50 +676,6 @@ static inline int __init probe_vmi_rom(void)
 	return 0;
 }
 
-#ifdef CONFIG_X86_LOCAL_APIC
-static u32 vmi_apic_read(u32 reg)
-{
-	return 0;
-}
-
-static void vmi_apic_write(u32 reg, u32 val)
-{
-	/* Warn to see if there's any stray references */
-	WARN_ON(1);
-}
-
-static u64 vmi_apic_icr_read(void)
-{
-	return 0;
-}
-
-static void vmi_apic_icr_write(u32 low, u32 id)
-{
-	/* Warn to see if there's any stray references */
-	WARN_ON(1);
-}
-
-static void vmi_apic_wait_icr_idle(void)
-{
-	return;
-}
-
-static u32 vmi_safe_apic_wait_icr_idle(void)
-{
-	return 0;
-}
-
-static struct apic_ops vmi_basic_apic_ops = {
-        .read = vmi_apic_read,
-        .write = vmi_apic_write,
-        .write_atomic = vmi_apic_write,
-        .icr_read = vmi_apic_icr_read,
-        .icr_write = vmi_apic_icr_write,
-        .wait_icr_idle = vmi_apic_wait_icr_idle,
-        .safe_wait_icr_idle = vmi_safe_apic_wait_icr_idle,
-};
-#endif
-
 /*
  * VMI setup common to all processors
  */
@@ -948,10 +904,9 @@ static inline int __init activate_vmi(void)
 #endif
 
 #ifdef CONFIG_X86_LOCAL_APIC
-	para_fill(vmi_basic_apic_ops.read, APICRead);
-	para_fill(vmi_basic_apic_ops.write, APICWrite);
-	para_fill(vmi_basic_apic_ops.write_atomic, APICWrite);
-	apic_ops = &vmi_basic_apic_ops;
+	para_fill(apic_ops->read, APICRead);
+	para_fill(apic_ops->write, APICWrite);
+	para_fill(apic_ops->write_atomic, APICWrite);
 #endif
 
 	/*
