Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652Ab0ALCt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652Ab0ALCt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753660Ab0ALCtO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:49:14 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:62553 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218Ab0ALCtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:49:13 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Mon, 11 Jan 2010 18:48:01 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [RFC PATCH 3/4] x86: using logical flat for amd cpu too.
In-reply-to: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "ananth@in.ibm.com" <ananth@in.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Message-id: <1263264483-3959-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1263264483-3959-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

not sure it works again, could be bios fix the irq routing dest ?

tested that amd support logical flat too when cpus num <= 8 and even
bsp apic id > 8

so could remove vendor check...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/apic/apic.c     |   11 ++---------
 arch/x86/kernel/apic/probe_64.c |   13 ++-----------
 2 files changed, 4 insertions(+), 20 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1898,15 +1898,8 @@ void __cpuinit generic_processor_info(in
 		max_physical_apicid = apicid;
 
 #ifdef CONFIG_X86_32
-	switch (boot_cpu_data.x86_vendor) {
-	case X86_VENDOR_INTEL:
-		if (num_processors > 8)
-			def_to_bigsmp = 1;
-		break;
-	case X86_VENDOR_AMD:
-		if (max_physical_apicid >= 8)
-			def_to_bigsmp = 1;
-	}
+	if (num_processors > 8)
+		def_to_bigsmp = 1;
 #endif
 
 #if defined(CONFIG_SMP) || defined(CONFIG_X86_64)
Index: linux-2.6/arch/x86/kernel/apic/probe_64.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/probe_64.c
+++ linux-2.6/arch/x86/kernel/apic/probe_64.c
@@ -67,17 +67,8 @@ void __init default_setup_apic_routing(v
 	}
 #endif
 
-	if (apic == &apic_flat) {
-		switch (boot_cpu_data.x86_vendor) {
-		case X86_VENDOR_INTEL:
-			if (num_processors > 8)
-				apic = &apic_physflat;
-			break;
-		case X86_VENDOR_AMD:
-			if (max_physical_apicid >= 8)
-				apic = &apic_physflat;
-		}
-	}
+	if (apic == &apic_flat && num_processors > 8)
+		apic = &apic_physflat;
 
 	printk(KERN_INFO "Setting APIC routing to %s\n", apic->name);
 
