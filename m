Return-Path: <linux-kernel-owner+w=401wt.eu-S1756514AbZEBRlv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756514AbZEBRlv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 May 2009 13:41:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753360AbZEBRlm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 May 2009 13:41:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:54985 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752680AbZEBRlm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 May 2009 13:41:42 -0400
Message-ID: <49FC85A9.2070702@kernel.org>
Date: Sat, 02 May 2009 10:40:57 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ed Swierk <eswierk@aristanetworks.com>
Subject: [PATCH] x86: read apic id if it is not acpi_lapic -v2
References: <20090430084145.GD21699@elte.hu> <49FBD0A2.4030309@kernel.org> <20090502070254.GA4791@lenovo>
In-Reply-To: <20090502070254.GA4791@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ed found that on 32bit, boot_cpu_physical_apicid is not read right,
when mptable is broken.

interesting, actually three path
1. acpi: at that time, at that time that is already read from reg.
2. mptable: that only read from mptable.
3. no madt, and no mptable, that use default apic id 0 for 64bit, -1 for 32bit

so could read that apic id for 2/3 path.

also could avoid set fixmap that lapic two times when acpi_lapic is used.
and need to move cpu_has_apic earlier and call apic_disable()

also when need to update that apic id, we'd better to read apic version

v2: make path 3 with 64bit, use -1 as apic id, so could read it later.

[ Impact: get correct apic id for bsp other than acpi path ]

Reported-by: Ed Swierk <eswierk@aristanetworks.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>

---
 arch/x86/kernel/apic/apic.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

Index: linux-2.6/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/apic/apic.c
+++ linux-2.6/arch/x86/kernel/apic/apic.c
@@ -1460,7 +1460,6 @@ static int __init detect_init_APIC(void)
 	}
 
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-	boot_cpu_physical_apicid = 0;
 	return 0;
 }
 #else
@@ -1574,6 +1573,8 @@ void __init early_init_lapic_mapping(voi
  */
 void __init init_apic_mappings(void)
 {
+	unsigned int new_apicid;
+
 	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
@@ -1590,21 +1591,32 @@ void __init init_apic_mappings(void)
 	} else
 		apic_phys = mp_lapic_addr;
 
-	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+	/* lets check if we may to NOP'ify apic operations */
+	if (!cpu_has_apic) {
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+		return;
+	}
+
+	/*
+	 * acpi lapic path already map that address in
+	 * acpi_register_lapic_address()
+	 */
 	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
 				APIC_BASE, apic_phys);
+	if (acpi_lapic)
+		return;
 
+	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
 	 */
-	if (boot_cpu_physical_apicid == -1U)
-		boot_cpu_physical_apicid = read_apic_id();
-
-	/* lets check if we may to NOP'ify apic operations */
-	if (!cpu_has_apic) {
-		pr_info("APIC: disable apic facility\n");
-		apic_disable();
+	new_apicid  = read_apic_id();
+	if (boot_cpu_physical_apicid != new_apicid) {
+		boot_cpu_physical_apicid  = new_apicid;
+		apic_version[new_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
 }
 
