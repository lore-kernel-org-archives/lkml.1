Return-Path: <linux-kernel-owner+w=401wt.eu-S1758449AbZEKJ5r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758449AbZEKJ5r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 05:57:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757846AbZEKJyi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 05:54:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:53954 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758049AbZEKJyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 05:54:37 -0400
Date: Mon, 11 May 2009 09:53:53 GMT
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       gorcunov@openvz.org, yinghai@kernel.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       yinghai@kernel.org, gorcunov@openvz.org, tglx@linutronix.de,
       eswierk@aristanetworks.com, mingo@elte.hu
In-Reply-To: <49FC85A9.2070702@kernel.org>
References: <49FC85A9.2070702@kernel.org>
Subject: [tip:x86/apic] x86: read apic ID in the !acpi_lapic case
Message-ID: <tip-4401da6111ac58f94234417427d06a72c4048c74@git.kernel.org>
Git-Commit-ID: 4401da6111ac58f94234417427d06a72c4048c74
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 11 May 2009 09:53:55 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4401da6111ac58f94234417427d06a72c4048c74
Gitweb:     http://git.kernel.org/tip/4401da6111ac58f94234417427d06a72c4048c74
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Sat, 2 May 2009 10:40:57 -0700
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Mon, 11 May 2009 11:29:23 +0200

x86: read apic ID in the !acpi_lapic case

Ed found that on 32-bit, boot_cpu_physical_apicid is not read right,
when the mptable is broken.

Interestingly, actually three paths use/set it:

 1. acpi: at that time that is already read from reg
 2. mptable: only read from mptable
 3. no madt, and no mptable, that use default apic id 0 for 64-bit, -1 for 32-bit

so we could read the apic id for the 2/3 path. We trust the hardware
register more than we trust a BIOS data structure (the mptable).

We can also avoid the double set_fixmap() when acpi_lapic
is used, and also need to move cpu_has_apic earlier and
call apic_disable().

Also when need to update the apic id, we'd better read and
set the apic version as well - so that quirks are applied precisely.

v2: make path 3 with 64bit, use -1 as apic id, so could read it later.
v3: fix whitespace problem pointed out by Ed Swierk

[ Impact: get correct apic id for bsp other than acpi path ]

Reported-by: Ed Swierk <eswierk@aristanetworks.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Cyrill Gorcunov <gorcunov@openvz.org>
LKML-Reference: <49FC85A9.2070702@kernel.org>
[ v4: sanity-check in the ACPI case too ]
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/apic/apic.c |   31 +++++++++++++++++++++----------
 1 files changed, 21 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index e258bed..1ee966f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1456,7 +1456,6 @@ static int __init detect_init_APIC(void)
 	}
 
 	mp_lapic_addr = APIC_DEFAULT_PHYS_BASE;
-	boot_cpu_physical_apicid = 0;
 	return 0;
 }
 #else
@@ -1570,6 +1569,8 @@ void __init early_init_lapic_mapping(void)
  */
 void __init init_apic_mappings(void)
 {
+	unsigned int new_apicid;
+
 	if (x2apic_mode) {
 		boot_cpu_physical_apicid = read_apic_id();
 		return;
@@ -1586,21 +1587,31 @@ void __init init_apic_mappings(void)
 	} else
 		apic_phys = mp_lapic_addr;
 
-	set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+	/* lets check if we may NOP'ify apic operations */
+	if (!cpu_has_apic) {
+		pr_info("APIC: disable apic facility\n");
+		apic_disable();
+		return;
+	}
+
+	/*
+	 * acpi lapic path already maps that address in
+	 * acpi_register_lapic_address()
+	 */
+	if (!acpi_lapic)
+		set_fixmap_nocache(FIX_APIC_BASE, apic_phys);
+
 	apic_printk(APIC_VERBOSE, "mapped APIC to %08lx (%08lx)\n",
 				APIC_BASE, apic_phys);
-
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
+	new_apicid = read_apic_id();
+	if (boot_cpu_physical_apicid != new_apicid) {
+		boot_cpu_physical_apicid = new_apicid;
+		apic_version[new_apicid] =
+			 GET_APIC_VERSION(apic_read(APIC_LVR));
 	}
 }
 
