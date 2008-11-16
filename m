Return-Path: <linux-kernel-owner+w=401wt.eu-S1752566AbYKPIuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbYKPIuS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 03:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751366AbYKPIuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 03:50:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:51163 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbYKPIuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 03:50:03 -0500
Message-ID: <491FDE9B.106@kernel.org>
Date: Sun, 16 Nov 2008 00:49:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.17 (X11/20080922)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
Subject: [PATCH] x86: fix es7000 compiling
References: <86802c440810141017q1e99e98sc824441bafc0cd7a@mail.gmail.com> <20081014175318.GA6521@elte.hu> <48F7890F.9040703@kernel.org> <20081016193345.GA15043@elte.hu> <48F7A838.4040908@kernel.org>
In-Reply-To: <48F7A838.4040908@kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

resend

---

Impact: fix es7000 compiling

  CC      arch/x86/kernel/es7000_32.o
arch/x86/kernel/es7000_32.c: In function ‘find_unisys_acpi_oem_table’:
arch/x86/kernel/es7000_32.c:255: error: implicit declaration of function ‘acpi_get_table_with_size’
arch/x86/kernel/es7000_32.c:261: error: implicit declaration of function ‘early_acpi_os_unmap_memory’
arch/x86/kernel/es7000_32.c: In function ‘unmap_unisys_acpi_oem_table’:
arch/x86/kernel/es7000_32.c:277: error: implicit declaration of function ‘__acpi_unmap_table’
make[1]: *** [arch/x86/kernel/es7000_32.o] Error 1

we applied one patch out of order...
| commit a73aaedd95703bd49f4c3f9df06fb7b7373ba905
| Author: Yinghai Lu <yhlu.kernel@gmail.com>
| Date:   Sun Sep 14 02:33:14 2008 -0700
|
|    x86: check dsdt before find oem table for es7000, v2
|
|    v2: use __acpi_unmap_table()

that patch need 
	x86: use early_ioremap in __acpi_map_table
	x86: always explicitly map acpi memory
	acpi: remove final __acpi_map_table mapping before setting acpi_gbl_permanent_mmap
	acpi/x86: introduce __apci_map_table, v4

workaround it here

after those patches applied, need to revert this one

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

diff --git a/arch/x86/kernel/es7000_32.c b/arch/x86/kernel/es7000_32.c
index f454c78..0aa2c44 100644
--- a/arch/x86/kernel/es7000_32.c
+++ b/arch/x86/kernel/es7000_32.c
@@ -250,31 +250,24 @@ int __init find_unisys_acpi_oem_table(unsigned long *oem_addr)
 {
 	struct acpi_table_header *header = NULL;
 	int i = 0;
-	acpi_size tbl_size;
 
-	while (ACPI_SUCCESS(acpi_get_table_with_size("OEM1", i++, &header, &tbl_size))) {
+	while (ACPI_SUCCESS(acpi_get_table("OEM1", i++, &header))) {
 		if (!memcmp((char *) &header->oem_id, "UNISYS", 6)) {
 			struct oem_table *t = (struct oem_table *)header;
 
 			oem_addrX = t->OEMTableAddr;
 			oem_size = t->OEMTableSize;
-			early_acpi_os_unmap_memory(header, tbl_size);
 
 			*oem_addr = (unsigned long)__acpi_map_table(oem_addrX,
 								    oem_size);
 			return 0;
 		}
-		early_acpi_os_unmap_memory(header, tbl_size);
 	}
 	return -1;
 }
 
 void __init unmap_unisys_acpi_oem_table(unsigned long oem_addr)
 {
-	if (!oem_addr)
-		return;
-
-	__acpi_unmap_table((char *)oem_addr, oem_size);
 }
 #endif
 

