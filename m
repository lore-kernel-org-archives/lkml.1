Return-Path: <linux-kernel-owner+w=401wt.eu-S1754769AbZENJYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbZENJYx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 May 2009 05:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752251AbZENJYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 May 2009 05:24:43 -0400
Received: from hera.kernel.org ([140.211.167.34]:36319 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbZENJYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 May 2009 05:24:42 -0400
Subject: Re: [PATCH -tip] x86: apic/apic.c default_init_apic_ldr() is
 required only for X86_32
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Yinghai Lu <yinghai@kernel.org>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1242290952.3178.1.camel@localhost.localdomain>
References: <1242251841.3364.17.camel@localhost.localdomain>
	 <alpine.LFD.2.00.0905140952220.3561@localhost.localdomain>
	 <1242290952.3178.1.camel@localhost.localdomain>
Content-Type: text/plain
Date: Thu, 14 May 2009 14:54:10 +0530
Message-Id: <1242293050.3178.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-05-14 at 14:19 +0530, Jaswinder Singh Rajput wrote:
> On Thu, 2009-05-14 at 09:53 +0200, Thomas Gleixner wrote:
> > On Thu, 14 May 2009, Jaswinder Singh Rajput wrote:
> > > 
> > > default_init_apic_ldr() is also required for 64 bit so moving it out
> > > from CONFIG_X86_32.
> > 
> > [linux-2.6-tip]$ git grep default_init_apic_ldr arch/x86/
> > arch/x86/include/asm/apic.h:extern void default_init_apic_ldr(void);
> > arch/x86/kernel/apic/apic.c:void default_init_apic_ldr(void)
> > arch/x86/kernel/apic/probe_32.c:        .init_apic_ldr                  = default_init_apic_ldr,
> > 
> > I have a hard time to see how 64bit requires that function.
> > 
> 
> Here is new patch to make you easy :-)
> 
> [PATCH] x86: apic/apic.c default_init_apic_ldr() is required only for X86_32
> 
> default_init_apic_ldr() is used only by X86_32.
> 

I think it will be better to use this:

[PATCH-tip] x86: apic/apic.c move default_init_apic_ldr() and default_apicid_to_node() to probe_32.c

default_init_apic_ldr() and default_apicid_to_node() is used only by probe_32.c
so move them to probe_32.c and make them static.

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/include/asm/apic.h     |   11 -----------
 arch/x86/kernel/apic/apic.c     |   21 ---------------------
 arch/x86/kernel/apic/probe_32.c |   27 +++++++++++++++++++++++++++
 3 files changed, 27 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index 229d0be..bc9eca8 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -473,15 +473,6 @@ extern void default_setup_apic_routing(void);
 
 extern struct apic apic_default;
 
-/*
- * Set up the logical destination ID.
- *
- * Intel recommends to set DFR, LDR and TPR before enabling
- * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
- * document number 292116).  So here it goes...
- */
-extern void default_init_apic_ldr(void);
-
 static inline int default_apic_id_registered(void)
 {
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
@@ -492,8 +483,6 @@ static inline int default_phys_pkg_id(int cpuid_apic, int index_msb)
 	return cpuid_apic >> index_msb;
 }
 
-extern int default_apicid_to_node(int logical_apicid);
-
 #endif
 
 static inline unsigned int
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index d6d4ffd..b97fd65 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1941,27 +1941,6 @@ int hard_smp_processor_id(void)
 	return read_apic_id();
 }
 
-void default_init_apic_ldr(void)
-{
-	unsigned long val;
-
-	apic_write(APIC_DFR, APIC_DFR_VALUE);
-	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
-	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
-	apic_write(APIC_LDR, val);
-}
-
-#ifdef CONFIG_X86_32
-int default_apicid_to_node(int logical_apicid)
-{
-#ifdef CONFIG_SMP
-	return apicid_2_node[hard_smp_processor_id()];
-#else
-	return 0;
-#endif
-}
-#endif
-
 /*
  * Power management
  */
diff --git a/arch/x86/kernel/apic/probe_32.c b/arch/x86/kernel/apic/probe_32.c
index 440a8bc..47c8a49 100644
--- a/arch/x86/kernel/apic/probe_32.c
+++ b/arch/x86/kernel/apic/probe_32.c
@@ -93,6 +93,33 @@ static int probe_default(void)
 	return 1;
 }
 
+/*
+ * Set up the logical destination ID.
+ *
+ * Intel recommends to set DFR, LDR and TPR before enabling
+ * an APIC.  See e.g. "AP-388 82489DX User's Manual" (Intel
+ * document number 292116).  So here it goes...
+ */
+
+static void default_init_apic_ldr(void)
+{
+	unsigned long val;
+
+	apic_write(APIC_DFR, APIC_DFR_VALUE);
+	val = apic_read(APIC_LDR) & ~APIC_LDR_MASK;
+	val |= SET_APIC_LOGICAL_ID(1UL << smp_processor_id());
+	apic_write(APIC_LDR, val);
+}
+
+static int default_apicid_to_node(int logical_apicid)
+{
+#ifdef CONFIG_SMP
+	return apicid_2_node[hard_smp_processor_id()];
+#else
+	return 0;
+#endif
+}
+
 struct apic apic_default = {
 
 	.name				= "default",
-- 
1.6.0.6



