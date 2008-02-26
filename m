Return-Path: <linux-kernel-owner+w=401wt.eu-S1759188AbYBZGaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759188AbYBZGaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 01:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752486AbYBZGaM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 01:30:12 -0500
Received: from koto.vergenet.net ([210.128.90.7]:40686 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752902AbYBZGaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 01:30:10 -0500
Subject: [PATCH] update efi region debugging to use MB, GB and TB as well as KB
To: linux-kernel@vger.kernel.org
Cc: Tony Luck <tony.luck@intel.com>, trivial@kernel.org
From: Simon Horman <horms@verge.net.au>
Date: Tue, 26 Feb 2008 15:24:04 +0900
Message-Id: <20080226063004.F1E744F937@tabatha.lab.ultramonkey.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When EFI_DEBUG is defined to a non-zero value in arch/ia64/kernel/efi.c,
the efi memory regions are displayed. This patch enhances the
display code in a few ways:

1. Use TB, GB and MB as well as KB as units.
   Although this introduces rounding errors (KB doesn't as
   size is always a multiple of 4Kb), it does make
   things a lot more readable.

   Also as the range is also shown, it is possible to note the exact size
   if it is important. In my experience, the size field is mostly useful
   for getting a general idea of the size of a region.

   On the rx2620 that I use, there actually is an 8TB region (though not
   backed by physical memory, and 8TB really is a lot more readable than
   8589934592KB.

2. pad the size field with leading spaces to further improve readability

   ...
   ... (   8MB)
   ... ( 928MB)
   ... (   3MB)
   ...

   vs

   ...
   ... (8MB)
   ... (928MB)
   ... (3MB)
   ...


3. Pad the attr field out to 64bits using leading zeros,
   to further improve readability.

   ...
   mem05: type= 2, attr=0x0000000000000008, range=[0x0000000004000000-0x000000000481f000) (   8MB)
   mem06: type= 7, attr=0x0000000000000008, range=[0x000000000481f000-0x000000003e876000) ( 928MB)
   mem07: type= 5, attr=0x8000000000000008, range=[0x000000003e876000-0x000000003eb8e000) (   3MB)
   mem08: type= 4, attr=0x0000000000000008, range=[0x000000003eb8e000-0x000000003ee7a000) (   2MB)
   ...

   ...
   mem05: type= 2, attr=0x8, range=[0x0000000004000000-0x000000000481f000) (   8MB)
   mem06: type= 7, attr=0x8, range=[0x000000000481f000-0x000000003e876000) ( 928MB)
   mem07: type= 5, attr=0x8000000000000008, range=[0x000000003e876000-0x000000003eb8e000) (   3MB)
   mem08: type= 4, attr=0x8, range=[0x000000003eb8e000-0x000000003ee7a000) (   2MB)
   ...

4. Use %d instead of %u for the index field, as i is a signed int.

N.B: This code is not compiled unless EFI_DEBUG is non 0.

Signed-off-by: Simon Horman <horms@verge.net.au>

Index: linux-2.6/arch/ia64/kernel/efi.c
===================================================================
--- linux-2.6.orig/arch/ia64/kernel/efi.c	2008-02-26 15:07:57.000000000 +0900
+++ linux-2.6/arch/ia64/kernel/efi.c	2008-02-26 15:25:33.000000000 +0900
@@ -543,12 +543,30 @@ efi_init (void)
 		for (i = 0, p = efi_map_start; p < efi_map_end;
 		     ++i, p += efi_desc_size)
 		{
+			const char *unit;
+			unsigned long size;
+
 			md = p;
-			printk("mem%02u: type=%u, attr=0x%lx, "
-			       "range=[0x%016lx-0x%016lx) (%luMB)\n",
+			size = md->num_pages << EFI_PAGE_SHIFT;
+
+			if ((size >> 40) > 0) {
+				size >>= 40;
+				unit = "TB";
+			} else if ((size >> 30) > 0) {
+				size >>= 30;
+				unit = "GB";
+			} else if ((size >> 20) > 0) {
+				size >>= 20;
+				unit = "MB";
+			} else {
+				size >>= 10;
+				unit = "KB";
+			}
+
+			printk("mem%02d: type=%2u, attr=0x%016lx, "
+			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
 			       i, md->type, md->attribute, md->phys_addr,
-			       md->phys_addr + efi_md_size(md),
-			       md->num_pages >> (20 - EFI_PAGE_SHIFT));
+			       md->phys_addr + efi_md_size(md), size, unit);
 		}
 	}
 #endif
