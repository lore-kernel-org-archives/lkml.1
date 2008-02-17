Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYBQAX6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYBQAX6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2008 19:23:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752959AbYBQAXu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Feb 2008 19:23:50 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:39662 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752782AbYBQAXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2008 19:23:49 -0500
Message-ID: <47B77E90.5050809@sgi.com>
Date: Sat, 16 Feb 2008 16:23:44 -0800
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Mel Gorman <mel@csn.ul.ie>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de, Christoph Lameter <clameter@sgi.com>,
       Jack Steiner <steiner@sgi.com>
Subject: Re: 2.6.24 git2/mm1: cpu_to_node mapping to non-existant nodes causing
 boot failure
References: <20080203171634.58ab668b.akpm@linux-foundation.org> <20080213175241.GA327@csn.ul.ie> <47B33ACF.5030700@sgi.com> <20080214201727.GC30841@csn.ul.ie> <47B4A774.7050509@sgi.com> <20080215020208.GA6500@csn.ul.ie>
In-Reply-To: <20080215020208.GA6500@csn.ul.ie>
Content-Type: multipart/mixed;
 boundary="------------020300070100050002080108"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020300070100050002080108
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Mel Gorman wrote:

> If you send me patches to apply on top of 2.6.25-rc1, I'll give them a spin
> on the machine in question. Reverting didn't work out very well as there are
> too many collisions with patches that were applied later. I eventually got
> the machine booting but it only succeeds because it only brings up one core
> on each processor.  The patch, which is pretty brain damaged is below in case
> it helps you guess what the real problem is. dmesg logs are attached of the
> vanilla failure with acpi=debug and the log with the patch applied showing
> "__cpu_up: bad cpu 1" and "__cpu_up: bad cpu3" (i.e. the second cores of
> each machine).
> 

This should completely undo the change to 16 bit apic ids until we can figure
out the problem with the memory-less nodes.  I checked it on both the numa
and non-numa x86_64 box.

Thanks,
Mike

--------------020300070100050002080108
Content-Type: text/plain;
 name="undo-16-bit-apic"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="undo-16-bit-apic"

---
 arch/x86/kernel/acpi/boot.c  |    2 +-
 arch/x86/kernel/apic_64.c    |    2 +-
 arch/x86/kernel/genapic_64.c |    4 ++--
 arch/x86/kernel/mpparse_64.c |    6 +++---
 arch/x86/mm/numa_64.c        |    2 +-
 include/asm-x86/smp_64.h     |    7 ++++---
 6 files changed, 12 insertions(+), 11 deletions(-)

--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -558,7 +558,7 @@ EXPORT_SYMBOL(acpi_map_lsapic);
 
 int acpi_unmap_lsapic(int cpu)
 {
-	per_cpu(x86_cpu_to_apicid, cpu) = -1;
+	per_cpu(x86_cpu_to_apicid, cpu) = BAD_APICID;
 	cpu_clear(cpu, cpu_present_map);
 	num_processors--;
 
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -1180,7 +1180,7 @@ __cpuinit int apic_is_clustered_box(void
 {
 	int i, clusters, zeros;
 	unsigned id;
-	u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+	u8 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
 	DECLARE_BITMAP(clustermap, NUM_APIC_CLUSTERS);
 
 	bitmap_zero(clustermap, NUM_APIC_CLUSTERS);
--- a/arch/x86/kernel/genapic_64.c
+++ b/arch/x86/kernel/genapic_64.c
@@ -25,10 +25,10 @@
 #endif
 
 /* which logical CPU number maps to which CPU (physical APIC ID) */
-u16 x86_cpu_to_apicid_init[NR_CPUS] __initdata
+u8 x86_cpu_to_apicid_init[NR_CPUS] __initdata
 					= { [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_cpu_to_apicid_early_ptr;
-DEFINE_PER_CPU(u16, x86_cpu_to_apicid) = BAD_APICID;
+DEFINE_PER_CPU(u8, x86_cpu_to_apicid) = BAD_APICID;
 EXPORT_PER_CPU_SYMBOL(x86_cpu_to_apicid);
 
 struct genapic __read_mostly *genapic = &apic_flat;
--- a/arch/x86/kernel/mpparse_64.c
+++ b/arch/x86/kernel/mpparse_64.c
@@ -67,7 +67,7 @@ unsigned disabled_cpus __cpuinitdata;
 /* Bitmask of physically existing CPUs */
 physid_mask_t phys_cpu_present_map = PHYSID_MASK_NONE;
 
-u16 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
+u8 x86_bios_cpu_apicid_init[NR_CPUS] __initdata
 				= { [0 ... NR_CPUS-1] = BAD_APICID };
 void *x86_bios_cpu_apicid_early_ptr;
 DEFINE_PER_CPU(u16, x86_bios_cpu_apicid) = BAD_APICID;
@@ -130,8 +130,8 @@ static void __cpuinit MP_processor_info(
  	}
 	/* are we being called early in kernel startup? */
 	if (x86_cpu_to_apicid_early_ptr) {
-		u16 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
-		u16 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
+		u8 *cpu_to_apicid = x86_cpu_to_apicid_early_ptr;
+		u8 *bios_cpu_apicid = x86_bios_cpu_apicid_early_ptr;
 
 		cpu_to_apicid[cpu] = m->mpc_apicid;
 		bios_cpu_apicid[cpu] = m->mpc_apicid;
--- a/arch/x86/mm/numa_64.c
+++ b/arch/x86/mm/numa_64.c
@@ -619,7 +619,7 @@ void __init init_cpu_to_node(void)
 	int i;
 
 	for (i = 0; i < NR_CPUS; i++) {
-		u16 apicid = x86_cpu_to_apicid_init[i];
+		u8 apicid = x86_cpu_to_apicid_init[i];
 
 		if (apicid == BAD_APICID)
 			continue;
--- a/include/asm-x86/smp_64.h
+++ b/include/asm-x86/smp_64.h
@@ -26,15 +26,16 @@ extern void unlock_ipi_call_lock(void);
 extern int smp_call_function_mask(cpumask_t mask, void (*func)(void *),
 				  void *info, int wait);
 
-extern u16 __initdata x86_cpu_to_apicid_init[];
-extern u16 __initdata x86_bios_cpu_apicid_init[];
+extern u8 __initdata x86_cpu_to_apicid_init[];
+extern u8 __initdata x86_bios_cpu_apicid_init[];
 extern void *x86_cpu_to_apicid_early_ptr;
 extern void *x86_bios_cpu_apicid_early_ptr;
+DECLARE_PER_CPU(u8, x86_cpu_to_apicid); /* physical ID */
+extern u8 bios_cpu_apicid[];
 
 DECLARE_PER_CPU(cpumask_t, cpu_sibling_map);
 DECLARE_PER_CPU(cpumask_t, cpu_core_map);
 DECLARE_PER_CPU(u16, cpu_llc_id);
-DECLARE_PER_CPU(u16, x86_cpu_to_apicid);
 DECLARE_PER_CPU(u16, x86_bios_cpu_apicid);
 
 static inline int cpu_present_to_apicid(int mps_cpu)

--------------020300070100050002080108--
