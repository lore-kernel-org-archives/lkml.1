Return-Path: <linux-kernel-owner+w=401wt.eu-S1753550AbYFTCvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550AbYFTCvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 22:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751962AbYFTCvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 22:51:11 -0400
Received: from relay1.sgi.com ([192.48.171.29]:39774 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751873AbYFTCvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 22:51:10 -0400
Date: Thu, 19 Jun 2008 21:51:05 -0500
From: Jack Steiner <steiner@sgi.com>
To: mingo@elte.hu, tglx@linutronix.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH] - Fix stack overflow for large values of MAX_APICS
Message-ID: <20080620025104.GA25571@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

physid_mask_of_physid() causes a huge stack (12k) to be created if the
number of APICS is large. Replace physid_mask_of_physid() with a
new function that does not create large stacks. This is a problem only
on large x86_64 systems.

Signed-off-by: Jack Steiner <steiner@sgi.com>

---

Ingo - the "Increase MAX_APICS patch" can now works. Do you
want me to resend???



 arch/x86/kernel/apic_32.c |    2 +-
 arch/x86/kernel/apic_64.c |    2 +-
 arch/x86/kernel/smpboot.c |    5 ++---
 include/asm-x86/mpspec.h  |    7 +++++++
 4 files changed, 11 insertions(+), 5 deletions(-)

Index: linux/arch/x86/kernel/apic_32.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_32.c	2008-06-19 11:50:07.000000000 -0500
+++ linux/arch/x86/kernel/apic_32.c	2008-06-19 19:28:04.000000000 -0500
@@ -1267,7 +1267,7 @@ int __init APIC_init_uniprocessor(void)
 #ifdef CONFIG_CRASH_DUMP
 	boot_cpu_physical_apicid = GET_APIC_ID(read_apic_id());
 #endif
-	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 
 	setup_local_APIC();
 
Index: linux/arch/x86/kernel/apic_64.c
===================================================================
--- linux.orig/arch/x86/kernel/apic_64.c	2008-06-19 15:59:58.000000000 -0500
+++ linux/arch/x86/kernel/apic_64.c	2008-06-19 19:25:18.000000000 -0500
@@ -920,7 +920,7 @@ int __init APIC_init_uniprocessor(void)
 
 	connect_bsp_APIC();
 
-	phys_cpu_present_map = physid_mask_of_physid(boot_cpu_physical_apicid);
+	physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	apic_write(APIC_ID, SET_APIC_ID(boot_cpu_physical_apicid));
 
 	setup_local_APIC();
Index: linux/arch/x86/kernel/smpboot.c
===================================================================
--- linux.orig/arch/x86/kernel/smpboot.c	2008-06-19 19:06:00.000000000 -0500
+++ linux/arch/x86/kernel/smpboot.c	2008-06-19 19:37:37.000000000 -0500
@@ -1042,10 +1042,9 @@ static __init void disable_smp(void)
 	smpboot_clear_io_apic_irqs();
 
 	if (smp_found_config)
-		phys_cpu_present_map =
-				physid_mask_of_physid(boot_cpu_physical_apicid);
+		physid_set_mask_of_physid(boot_cpu_physical_apicid, &phys_cpu_present_map);
 	else
-		phys_cpu_present_map = physid_mask_of_physid(0);
+		physid_set_mask_of_physid(0, &phys_cpu_present_map);
 	map_cpu_to_logical_apicid();
 	cpu_set(0, per_cpu(cpu_sibling_map, 0));
 	cpu_set(0, per_cpu(cpu_core_map, 0));
Index: linux/include/asm-x86/mpspec.h
===================================================================
--- linux.orig/include/asm-x86/mpspec.h	2008-06-19 11:50:09.000000000 -0500
+++ linux/include/asm-x86/mpspec.h	2008-06-19 19:39:11.000000000 -0500
@@ -122,6 +122,7 @@ typedef struct physid_mask physid_mask_t
 		__physid_mask;						\
 	})
 
+/* Note: will create very large stack frames if physid_mask_t is big */
 #define physid_mask_of_physid(physid)					\
 	({								\
 		physid_mask_t __physid_mask = PHYSID_MASK_NONE;		\
@@ -129,6 +130,12 @@ typedef struct physid_mask physid_mask_t
 		__physid_mask;						\
 	})
 
+static inline void physid_set_mask_of_physid(int physid, physid_mask_t *map)
+{
+	physids_clear(*map);
+	physid_set(physid, *map);
+}
+
 #define PHYSID_MASK_ALL		{ {[0 ... PHYSID_ARRAY_SIZE-1] = ~0UL} }
 #define PHYSID_MASK_NONE	{ {[0 ... PHYSID_ARRAY_SIZE-1] = 0UL} }
 
