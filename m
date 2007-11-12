Return-Path: <linux-kernel-owner+w=401wt.eu-S1757055AbXKLBp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbXKLBp1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2007 20:45:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752858AbXKLBpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Nov 2007 20:45:14 -0500
Received: from [222.73.24.84] ([222.73.24.84]:49979 "EHLO song.cn.fujitsu.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751819AbXKLBpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2007 20:45:13 -0500
Message-ID: <4737AF9D.7070403@cn.fujitsu.com>
Date: Mon, 12 Nov 2007 09:42:53 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: tony.luck@intel.com
CC: LKML <linux-kernel@vger.kernel.org>, linux-ia64@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] IA64 efi: make full use of macro efi_md_size
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Macro efi_md_size is defined in efi.c, and here we apply it
throughout efi.c.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

---
 arch/ia64/kernel/efi.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 0e4ef20..7392d7b 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -369,7 +369,7 @@ efi_get_pal_addr (void)
 			continue;
 		}
 
-		if (md->num_pages << EFI_PAGE_SHIFT > IA64_GRANULE_SIZE)
+		if (efi_md_size(md) > IA64_GRANULE_SIZE)
 			panic("Woah!  PAL code size bigger than a granule!");
 
 #if EFI_DEBUG
@@ -377,7 +377,7 @@ efi_get_pal_addr (void)
 
 		printk(KERN_INFO "CPU %d: mapping PAL code [0x%lx-0x%lx) into [0x%lx-0x%lx)\n",
 			smp_processor_id(), md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			md->phys_addr + efi_md_size(md),
 			vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
 #endif
 		return __va(md->phys_addr);
@@ -522,7 +522,7 @@ efi_init (void)
 			md = p;
 			printk("mem%02u: type=%u, attr=0x%lx, range=[0x%016lx-0x%016lx) (%luMB)\n",
 			       i, md->type, md->attribute, md->phys_addr,
-			       md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
+			       md->phys_addr + efi_md_size(md),
 			       md->num_pages >> (20 - EFI_PAGE_SHIFT));
 		}
 	}
@@ -655,7 +655,7 @@ efi_memory_descriptor (unsigned long phys_addr)
 	for (p = efi_map_start; p < efi_map_end; p += efi_desc_size) {
 		md = p;
 
-		if (phys_addr - md->phys_addr < (md->num_pages << EFI_PAGE_SHIFT))
+		if (phys_addr - md->phys_addr < efi_md_size(md))
 			 return md;
 	}
 	return NULL;
@@ -1159,7 +1159,7 @@ efi_initialize_iomem_resources(struct resource *code_resource,
 
 		res->name = name;
 		res->start = md->phys_addr;
-		res->end = md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT) - 1;
+		res->end = md->phys_addr + efi_md_size(md) - 1;
 		res->flags = flags;
 
 		if (insert_resource(&iomem_resource, res) < 0)
-- 
1.5.3.rc7

