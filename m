Return-Path: <linux-kernel-owner+w=401wt.eu-S932840AbYBVV3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932840AbYBVV3S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 16:29:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756744AbYBVV3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 16:29:05 -0500
Received: from sca-es-mail-1.Sun.COM ([192.18.43.132]:64068 "EHLO
	sca-es-mail-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbYBVV3B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 16:29:01 -0500
Date: Fri, 22 Feb 2008 13:37:26 -0800
From: Yinghai Lu <Yinghai.Lu@Sun.COM>
Subject: [PATCH] x86_64: insert_resorce for lapic addr after
 e820_reserve_resources
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-id: <200802221337.27170.yinghai.lu@sun.com>
Organization: Sun
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7BIT
Content-disposition: inline
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


when comparing the e820 direct from BIOS, and the one by kexec

 BIOS-provided physical RAM map:
- BIOS-e820: 0000000000000000 - 0000000000097400 (usable)
+ BIOS-e820: 0000000000000100 - 0000000000097400 (usable)
  BIOS-e820: 0000000000097400 - 00000000000a0000 (reserved)
  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
  BIOS-e820: 0000000000100000 - 00000000dffa0000 (usable)
- BIOS-e820: 00000000dffae000 - 00000000dffb0000 type 9
+ BIOS-e820: 00000000dffae000 - 00000000dffb0000 (reserved)
  BIOS-e820: 00000000dffb0000 - 00000000dffbe000 (ACPI data)
  BIOS-e820: 00000000dffbe000 - 00000000dfff0000 (ACPI NVS)
  BIOS-e820: 00000000dfff0000 - 00000000e0000000 (reserved)
  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
- BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved) =======> that is local apic address... somewhere we lost it
  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
  BIOS-e820: 0000000100000000 - 0000004020000000 (usable)

found one entry about reserved is missing for the kernel by kexec.

it turns out init_apic_mappings is called before e820_reserve_resources
in setup_arch. but e820_reserve_resources is using request_resource.
it will not handle the conflicts.

there are three ways to fix it
1. change request_resource in e820_reserve_resources to to insert_resource
2. move init_apic_mappings after e820_reserve_resources
3. use late_initcall to insert lapic resource.

this patch is using method 3, that is less intrusive.

in later version could consider to use method 1.

before patch
fed20000-ffffffff : PCI Bus #00
  fee00000-fee00fff : Local APIC
  fefff000-feffffff : pnp 00:09
  ff700000-ffffffff : reserved

with patch will get map in first kernel

fed20000-ffffffff : PCI Bus #00
  fee00000-fee00fff : Local APIC
    fee00000-fee00fff : reserved
  fefff000-feffffff : pnp 00:09
  ff700000-ffffffff : reserved

Signed-off-by: Yinghai Lu <yinghai.lu@sun.com>

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5bdf1bc..cc6dd37 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -905,11 +905,6 @@ void __init init_apic_mappings(void)
 	apic_printk(APIC_VERBOSE, "mapped APIC to %16lx (%16lx)\n",
 				APIC_BASE, apic_phys);
 
-	/* Put local APIC into the resource map. */
-	lapic_resource.start = apic_phys;
-	lapic_resource.end = lapic_resource.start + PAGE_SIZE - 1;
-	insert_resource(&iomem_resource, &lapic_resource);
-
 	/*
 	 * Fetch the APIC ID of the BSP in case we have a
 	 * default configuration (or the MP table is broken).
@@ -1317,3 +1312,21 @@ static __init int setup_apicpmtimer(char *s)
 }
 __setup("apicpmtimer", setup_apicpmtimer);
 
+static int __init lapic_insert_resource(void)
+{
+	if (!apic_phys)
+		return -1;
+
+	/* Put local APIC into the resource map. */
+	lapic_resource.start = apic_phys;
+	lapic_resource.end = lapic_resource.start + PAGE_SIZE - 1;
+	insert_resource(&iomem_resource, &lapic_resource);
+
+	return 0;
+}
+
+/*
+ * need call insert after e820_reserve_resources()
+ * that is using request_resource
+ */
+late_initcall(lapic_insert_resource);
