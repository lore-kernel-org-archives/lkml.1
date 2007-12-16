Return-Path: <linux-kernel-owner+w=401wt.eu-S1765786AbXLPKvV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765786AbXLPKvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2007 05:51:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760524AbXLPKvL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Dec 2007 05:51:11 -0500
Received: from ananke.telenet-ops.be ([195.130.137.78]:42164 "EHLO
	ananke.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758243AbXLPKvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2007 05:51:08 -0500
Date: Sun, 16 Dec 2007 11:51:00 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-arch@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>
Subject: [PATCH] initrd: Fix virtual/physical mix-up in overwrite test
Message-ID: <Pine.LNX.4.64.0712161148340.5869@anakin>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On recent kernels, I get the following error when using an initrd:

| initrd overwritten (0x00b78000 < 0x07668000) - disabling it.

My Amiga 4000 has 12 MiB of RAM at physical address 0x07400000 (virtual
0x00000000).
The initrd is located at the end of RAM: 0x00b78000 - 0x00c00000 (virtual).
The overwrite test compares the (virtual) initrd location to the (physical)
first available memory location, which fails.

This patch converts initrd_start to a page frame number, so it can be safely
compared with min_low_pfn.

Before the introduction of discontiguous memory support on m68k
(12d810c1b8c2b913d48e629e2b5c01d105029839), min_low_pfn was just left
untouched by the m68k-specific code (zero, I guess), and everything worked
fine.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
On several platforms, initrd_below_start_ok is set to 1:

| arch/mips/kernel/setup.c:       initrd_below_start_ok = 1;
| arch/parisc/mm/init.c:                  initrd_below_start_ok = 1;
| arch/powerpc/kernel/prom.c:                     initrd_below_start_ok = 1;
| arch/ppc/platforms/hdpu.c:                      initrd_below_start_ok = 1;
| arch/xtensa/kernel/setup.c:             initrd_below_start_ok = 1;

Some of these may be workarounds for this bug. Please check.

 init/main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/init/main.c
+++ b/init/main.c
@@ -598,9 +598,9 @@ asmlinkage void __init start_kernel(void
 
 #ifdef CONFIG_BLK_DEV_INITRD
 	if (initrd_start && !initrd_below_start_ok &&
-			initrd_start < min_low_pfn << PAGE_SHIFT) {
+			virt_to_pfn(initrd_start) < min_low_pfn) {
 		printk(KERN_CRIT "initrd overwritten (0x%08lx < 0x%08lx) - "
-		    "disabling it.\n",initrd_start,min_low_pfn << PAGE_SHIFT);
+		    "disabling it.\n", virt_to_pfn(initrd_start), min_low_pfn);
 		initrd_start = 0;
 	}
 #endif

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
