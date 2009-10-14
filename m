Return-Path: <linux-kernel-owner+w=401wt.eu-S934002AbZJNUaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002AbZJNUaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933892AbZJNUaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:30:21 -0400
Received: from mail-ew0-f208.google.com ([209.85.219.208]:44969 "EHLO
	mail-ew0-f208.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891AbZJNUaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Wbi6HDJeLrfbT/N/WCB0JthUqZARgOd+0VVIu/1YZvYhCtTwVMjtirDszcjuJxz8d6
         HW4w9B3rQObxw7pdQHw2NEitw+K5oojPFLZxt3/0c5cmVdy9jwI4C+OmlIp2tjS6JW5m
         VzZvhuxU0cnfjD8oB6T93k4Zxr8XiG8KFNdLk=
Date: Thu, 15 Oct 2009 00:29:41 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: x86@kernel.org, yinghai@kernel.org, macro@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: [patch 3/3] x86,apic: limit apic dumping, introduce show_lapic
	setup option
Message-ID: <20091014202941.GE5259@lenovo>
References: <20091013200702.019870576@openvz.org> <20091013201022.926793122@openvz.org> <20091014071217.GL784@elte.hu> <20091014150904.GA5259@lenovo> <20091014175616.GA3403@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091014175616.GA3403@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Ingo Molnar - Wed, Oct 14, 2009 at 07:56:16PM +0200]
| 
| btw., i'm getting this warning on a test-box:
...
| 
| [    0.400000] Checking 'hlt' instruction... OK.
| [    0.440000] SMP alternatives: switching to UP code
| [    0.450000] debug: unmapping init memory 79c7a000..79c80000
| 
| noop_default_phys_pkg_id() should return 0 i guess, and not generate a 
| warning?
| 
| 	Ingo
| 

Ingo, I think the better would be to just make NOOP plain
NOOP without any kind of checking. Something like below
(I still can't fetch last/fresh -tip repo /remote point hangs/
 for this so I've used interdiff).

Comments?

Btw, the base problem from dump you posted is that we've been
cheking only for read/write operations allowing all other ops
be called without any kind of check (and retrieving pkgid happened
there all the time just didn't trigger warn until we've substituted
apic driver completely). Using NOOP without warn should be more
convenient (all previous "dark" places in apic code already covered
with cpu_has_apic/disable_apic checks so the only risk we have --
is code that will appear in future).

	-- Cyrill
---
x86,apic: allow noop operations to be called at any moment

As only apic noop is used we allow to use any operation
caller wants (and which of them noop driver supports of
course).

Initially it was reported by Ingo Molnar that apic noop
issue a warning (which is actually false positive and
should be eliminated). So lets NOOP be plain NOOP --
ie it should do nothing (and be fast) but attempting to
return sane values on read opertaions and be dumb on
write operations.

Reported-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
 apic_noop.c |   87 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 43 insertions(+), 44 deletions(-)

diff -u linux-2.6.git/arch/x86/kernel/apic/apic_noop.c linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
--- linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
+++ linux-2.6.git/arch/x86/kernel/apic/apic_noop.c
@@ -6,7 +6,7 @@
  *
  * Though in case if apic is disabled (for some reason) we try
  * to not uglify the caller's code and allow to call (some) apic routines
- * like self-ipi, etc... and issue a warning if an operation is not allowed
+ * like self-ipi, etc...
  */
 
 #include <linux/threads.h>
@@ -30,40 +30,48 @@
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
+static physid_mask_t noop_ioapic_phys_id_map(physid_mask_t phys_map)
+{
+	return phys_map;
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
+static int noop_cpu_to_logical_apicid(int cpu)
+{
+	return 1;
+}
+
+static int noop_default_phys_pkg_id(int cpuid_apic, int index_msb)
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
@@ -73,33 +81,27 @@
 
 static int noop_apic_id_registered(void)
 {
-	warn_apic_enabled();
 	return physid_isset(read_apic_id(), phys_cpu_present_map);
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
@@ -108,22 +110,19 @@
 
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
-	WARN_ON_ONCE((cpu_has_apic && !disable_apic));
 	return 0;
 }
 
+static void noop_apic_write(u32 reg, u32 v)
+{
+}
+
 struct apic apic_noop = {
 	.name				= "noop",
 	.probe				= noop_probe,
