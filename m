Return-Path: <linux-kernel-owner+w=401wt.eu-S932796AbZJOPMP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932796AbZJOPMP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Oct 2009 11:12:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbZJOPMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Oct 2009 11:12:14 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:56352 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758527AbZJOPMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Oct 2009 11:12:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=W2GXXUBL9pi9EK1aNeaKv2Agr4hs2bGsS8DWqlg07akt0bXUAXsG7JrN38iTXUVI4m
         i3GyiNunjMK+JH4Ul2vnhvamp+lBrKSkwDl/uaKRXtxdkCthuf5oH9hySgv65ha+s0v4
         RkNvNVIOzkOIjxLFtb3WKe6iOjOADes/fqkeA=
Date: Thu, 15 Oct 2009 19:04:16 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Yinghai Lu <yinghai@kernel.org>,
       "Maciej W. Rozycki" <macro@linux-mips.org>, x86team <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip] x86,apic: allow noop operations to be called almost
	at any time
Message-ID: <20091015150416.GC5331@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As only apic noop is used we allow to use almost any operation
caller wants (and which of them noop driver supports of
course).

Initially it was reported by Ingo Molnar that apic noop
issue a warning for pkg id (which is actually false positive
and should be eliminated).

So we save checking (and warning issue) for read/write
operations while allow any other ops to be freely used.

Also:
 - fix noop_cpu_to_logical_apicid, it should be 0.
 - rename noop_default_phys_pkg_id to noop_phys_pkg_id
   (we use default_ prefix for more general routines
    in apic subsystem).

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 arch/x86/kernel/apic/apic.c      |    1 
 arch/x86/kernel/apic/apic_noop.c |  103 +++++++++++++++++++++------------------
 2 files changed, 58 insertions(+), 46 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/apic/apic.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic.c
@@ -246,6 +246,7 @@ static int modern_apic(void)
  */
 void apic_disable(void)
 {
+	pr_info("APIC: switched to apic NOOP\n");
 	apic = &apic_noop;
 }
 
Index: linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -6,7 +6,7 @@
  *
  * Though in case if apic is disabled (for some reason) we try
  * to not uglify the caller's code and allow to call (some) apic routines
- * like self-ipi, etc... and issue a warning if an operation is not allowed
+ * like self-ipi, etc...
  */
 
 #include <linux/threads.h>
@@ -30,76 +30,88 @@
 #include <asm/acpi.h>
 #include <asm/e820.h>
 
-/*
- * some operations should never be reached with
- * noop apic if it's not turned off, this mostly
- * means the caller forgot to disable apic (or
- * check the apic presence) before doing a call
- */
-static void warn_apic_enabled(void)
+static void noop_init_apic_ldr(void) { }
+static void noop_send_IPI_mask(const struct cpumask *cpumask, int vector) { }
+static void noop_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector) { }
+static void noop_send_IPI_allbutself(int vector) { }
+static void noop_send_IPI_all(int vector) { }
+static void noop_send_IPI_self(int vector) { }
+static void noop_apic_wait_icr_idle(void) { }
+static void noop_apic_icr_write(u32 low, u32 id) { }
+
+static int noop_wakeup_secondary_cpu(int apicid, unsigned long start_eip)
 {
-	WARN_ONCE((cpu_has_apic || !disable_apic),
-		"APIC: Called for NOOP operation with apic enabled\n");
+	return -1;
 }
 
-/*
- * To check operations but do not bloat source code
- */
-#define NOOP_FUNC(func)			func { warn_apic_enabled(); }
-#define NOOP_FUNC_RET(func, ret)	func { warn_apic_enabled(); return ret; }
+static u32 noop_safe_apic_wait_icr_idle(void)
+{
+	return 0;
+}
+
+static u64 noop_apic_icr_read(void)
+{
+	return 0;
+}
 
-NOOP_FUNC(static void noop_init_apic_ldr(void))
-NOOP_FUNC(static void noop_send_IPI_mask(const struct cpumask *cpumask, int vector))
-NOOP_FUNC(static void noop_send_IPI_mask_allbutself(const struct cpumask *cpumask, int vector))
-NOOP_FUNC(static void noop_send_IPI_allbutself(int vector))
-NOOP_FUNC(static void noop_send_IPI_all(int vector))
-NOOP_FUNC(static void noop_send_IPI_self(int vector))
-NOOP_FUNC_RET(static int noop_wakeup_secondary_cpu(int apicid, unsigned long start_eip), -1)
-NOOP_FUNC(static void noop_apic_write(u32 reg, u32 v))
-NOOP_FUNC(void noop_apic_wait_icr_idle(void))
-NOOP_FUNC_RET(static u32 noop_safe_apic_wait_icr_idle(void), 0)
-NOOP_FUNC_RET(static u64 noop_apic_icr_read(void), 0)
-NOOP_FUNC(static void noop_apic_icr_write(u32 low, u32 id))
-NOOP_FUNC_RET(static physid_mask_t noop_ioapic_phys_id_map(physid_mask_t phys_map), phys_map)
-NOOP_FUNC_RET(static int noop_cpu_to_logical_apicid(int cpu), 1)
-NOOP_FUNC_RET(static int noop_default_phys_pkg_id(int cpuid_apic, int index_msb), 0)
-NOOP_FUNC_RET(static unsigned int noop_get_apic_id(unsigned long x), 0)
+static physid_mask_t noop_ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	return phys_map;
+}
+
+static int noop_cpu_to_logical_apicid(int cpu)
+{
+	return 0;
+}
+
+static int noop_phys_pkg_id(int cpuid_apic, int index_msb)
+{
+	return 0;
+}
+
+static unsigned int noop_get_apic_id(unsigned long x)
+{
+	return 0;
+}
 
 static int noop_probe(void)
 {
-	/* should not ever be enabled this way */
+	/*
+	 * NOOP apic should not ever be
+	 * enabled via probe routine
+	 */
 	return 0;
 }
 
 static int noop_apic_id_registered(void)
 {
-	warn_apic_enabled();
-	return physid_isset(read_apic_id(), phys_cpu_present_map);
+	/*
+	 * if we would be really "pedantic"
+	 * we should pass read_apic_id() here
+	 * but since NOOP suppose APIC ID = 0
+	 * lets save a few cycles
+	 */
+	return physid_isset(0, phys_cpu_present_map);
 }
 
 static const struct cpumask *noop_target_cpus(void)
 {
-	warn_apic_enabled();
-
 	/* only BSP here */
 	return cpumask_of(0);
 }
 
 static unsigned long noop_check_apicid_used(physid_mask_t bitmap, int apicid)
 {
-	warn_apic_enabled();
 	return physid_isset(apicid, bitmap);
 }
 
 static unsigned long noop_check_apicid_present(int bit)
 {
-	warn_apic_enabled();
 	return physid_isset(bit, phys_cpu_present_map);
 }
 
 static void noop_vector_allocation_domain(int cpu, struct cpumask *retmask)
 {
-	warn_apic_enabled();
 	if (cpu != 0)
 		pr_warning("APIC: Vector allocated for non-BSP cpu\n");
 	cpumask_clear(retmask);
@@ -108,22 +120,21 @@ static void noop_vector_allocation_domai
 
 int noop_apicid_to_node(int logical_apicid)
 {
-	warn_apic_enabled();
-
 	/* we're always on node 0 */
 	return 0;
 }
 
 static u32 noop_apic_read(u32 reg)
 {
-	/*
-	 * noop-read is always safe until we have
-	 * non-disabled unit
-	 */
 	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 	return 0;
 }
 
+static void noop_apic_write(u32 reg, u32 v)
+{
+	WARN_ON_ONCE((cpu_has_apic || !disable_apic));
+}
+
 struct apic apic_noop = {
 	.name				= "noop",
 	.probe				= noop_probe,
@@ -157,7 +168,7 @@ struct apic apic_noop = {
 	.check_phys_apicid_present	= default_check_phys_apicid_present,
 	.enable_apic_mode		= NULL,
 
-	.phys_pkg_id			= noop_default_phys_pkg_id,
+	.phys_pkg_id			= noop_phys_pkg_id,
 
 	.mps_oem_check			= NULL,
 
