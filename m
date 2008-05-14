Return-Path: <linux-kernel-owner+w=401wt.eu-S1763550AbYENPSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763550AbYENPSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 11:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762721AbYENPQC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 11:16:02 -0400
Received: from relay1.sgi.com ([192.48.171.29]:48212 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762712AbYENPP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 11:15:59 -0400
From: Paul Jackson <pj@sgi.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Thomas Gleixner" <tglx@linutronix.de>, "Jack Steiner" <steiner@sgi.com>,
       "Mike Travis" <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel@vger.kernel.org, "Huang, Ying" <ying.huang@intel.com>,
       "Andi Kleen" <andi@firstfloor.org>, "Ingo Molnar" <mingo@elte.hu>,
       Paul Jackson <pj@sgi.com>
Date: Wed, 14 May 2008 08:15:58 -0700
Message-Id: <20080514151558.148486.91282.sendpatchset@jackhammer.engr.sgi.com>
In-Reply-To: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
References: <20080514151504.148486.32236.sendpatchset@jackhammer.engr.sgi.com>
Subject: [PATCH 10/10] x86 boot: add code to add BIOS provided EFI memory entries to kernel
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Jackson <pj@sgi.com>

Add to the kernels boot memory map 'memmap' entries found in
the EFI memory descriptors passed in from the BIOS.

On EFI systems, up to E820MAX == 128 memory map entries can
be passed via the legacy E820 interface (limited by the size
of the 'zeropage').  These entries can be duplicated in the
EFI descriptors also passed from the BIOS, and possibly more
entries passed by the EFI interface, which does not have the
E820MAX limit on number of memory map entries.

This code doesn't worry about the likely duplicate, overlapping
or (unlikely) conflicting entries between the EFI map and the
E820 map.  It just dumps all the EFI entries into the memmap[]
array (which already has the E820 entries) and lets the existing
routine sanitize_e820_map() sort the mess out.

Signed-off-by: Paul Jackson <pj@sgi.com>

---
 arch/x86/kernel/efi.c |   26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- linux.orig/arch/x86/kernel/efi.c	2008-05-06 06:44:32.332774433 -0700
+++ linux/arch/x86/kernel/efi.c	2008-05-06 06:55:20.767816417 -0700
@@ -213,6 +213,31 @@ unsigned long efi_get_time(void)
 		      eft.minute, eft.second);
 }
 
+/*
+ * Tell the kernel about the EFI memory map.  This might include
+ * more than the max 128 entries that can fit in the e820 legacy
+ * (zeropage) memory map.
+ */
+
+static void __init add_efi_memmap(void)
+{
+	void *p;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		efi_memory_desc_t *md = p;
+		unsigned long long start = md->phys_addr;
+		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		int e820_type;
+
+		if (md->attribute & EFI_MEMORY_WB)
+			e820_type = E820_RAM;
+		else
+			e820_type = E820_RESERVED;
+		add_memory_region(start, size, e820_type);
+	}
+	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 #if EFI_DEBUG
 static void __init print_efi_memmap(void)
 {
@@ -370,6 +395,7 @@ void __init efi_init(void)
 	if (memmap.desc_size != sizeof(efi_memory_desc_t))
 		printk(KERN_WARNING "Kernel-defined memdesc"
 		       "doesn't match the one from EFI!\n");
+	add_efi_memmap();
 
 	/* Setup for EFI runtime service */
 	reboot_type = BOOT_EFI;

-- 
                          I won't rest till it's the best ...
                          Programmer, Linux Scalability
                          Paul Jackson <pj@sgi.com> 1.650.933.1373
