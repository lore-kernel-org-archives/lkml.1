Return-Path: <linux-kernel-owner+w=401wt.eu-S1759168AbZCBDZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759168AbZCBDZ1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 22:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754069AbZCBDZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 22:25:18 -0500
Received: from hera.kernel.org ([140.211.167.34]:49923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbZCBDZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 22:25:16 -0500
Message-ID: <49AB511E.9010507@kernel.org>
Date: Sun, 01 Mar 2009 19:23:10 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Kevin O'Connor" <kevin@koconnor.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org
Subject: [PATCH] x86: ioremap mptable -v2
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu> <49A23EE0.8000102@kernel.org> <20090228234127.GA29964@morn.localdomain> <49A9FC9A.2030707@kernel.org> <20090301180420.GA27040@morn.localdomain>
In-Reply-To: <20090301180420.GA27040@morn.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: fix boot with mptable above max_low_mapped

try to use early_ioremap it.

v2: also get the exact size for reserve_bootmem in case we got big size than 4k

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-and-tested-by: Kevin O'Connor <kevin@koconnor.net>

---
 arch/x86/kernel/mpparse.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -611,12 +611,20 @@ static void __init __get_smp_config(unsi
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
+		struct mpc_table *mpc;
+		unsigned long size;
 
+		mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
+		size = mpc->length;
+		apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", (unsigned long)mpf->physptr,
+			 mpf->physptr + size);
+		early_iounmap(mpc, PAGE_SIZE);
+		mpc = early_ioremap(mpf->physptr, size);
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
+		if (!smp_read_mpc(mpc, early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -624,9 +632,12 @@ static void __init __get_smp_config(unsi
 			       "BIOS bug, MP table errors detected!...\n");
 			printk(KERN_ERR "... disabling SMP support. "
 			       "(tell your hw vendor)\n");
+			early_iounmap(mpc, size);
 			return;
 		}
 
+		early_iounmap(mpc, size);
+
 		if (early)
 			return;
 #ifdef CONFIG_X86_IO_APIC
@@ -700,7 +711,12 @@ static int __init smp_scan_config(unsign
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
 			if (mpf->physptr) {
-				unsigned long size = PAGE_SIZE;
+				struct mpc_table *mpc;
+				unsigned long size;
+
+				mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
+				size = mpc->length;
+				early_iounmap(mpc, PAGE_SIZE);
 #ifdef CONFIG_X86_32
 				/*
 				 * We cannot access to MPC table to compute[PATCH] x86: ioremap mptable -v2

Impact: fix boot with mptable above max_low_mapped

try to use early_ioremap it.

v2: also get the exact size for reserve_bootmem in case we got big size than 4k

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Reported-and-tested-by: Kevin O'Connor <kevin@koconnor.net>

---
 arch/x86/kernel/mpparse.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -611,12 +611,20 @@ static void __init __get_smp_config(unsi
 		construct_default_ISA_mptable(mpf->feature1);
 
 	} else if (mpf->physptr) {
+		struct mpc_table *mpc;
+		unsigned long size;
 
+		mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
+		size = mpc->length;
+		apic_printk(APIC_VERBOSE, "  mpc: %lx-%lx\n", (unsigned long)mpf->physptr,
+			 mpf->physptr + size);
+		early_iounmap(mpc, PAGE_SIZE);
+		mpc = early_ioremap(mpf->physptr, size);
 		/*
 		 * Read the physical hardware table.  Anything here will
 		 * override the defaults.
 		 */
-		if (!smp_read_mpc(phys_to_virt(mpf->physptr), early)) {
+		if (!smp_read_mpc(mpc, early)) {
 #ifdef CONFIG_X86_LOCAL_APIC
 			smp_found_config = 0;
 #endif
@@ -624,9 +632,12 @@ static void __init __get_smp_config(unsi
 			       "BIOS bug, MP table errors detected!...\n");
 			printk(KERN_ERR "... disabling SMP support. "
 			       "(tell your hw vendor)\n");
+			early_iounmap(mpc, size);
 			return;
 		}
 
+		early_iounmap(mpc, size);
+
 		if (early)
 			return;
 #ifdef CONFIG_X86_IO_APIC
@@ -700,7 +711,12 @@ static int __init smp_scan_config(unsign
 			reserve_bootmem_generic(virt_to_phys(mpf), PAGE_SIZE,
 					BOOTMEM_DEFAULT);
 			if (mpf->physptr) {
-				unsigned long size = PAGE_SIZE;
+				struct mpc_table *mpc;
+				unsigned long size;
+
+				mpc = early_ioremap(mpf->physptr, PAGE_SIZE);
+				size = mpc->length;
+				early_iounmap(mpc, PAGE_SIZE);
 #ifdef CONFIG_X86_32
 				/*
 				 * We cannot access to MPC table to compute
