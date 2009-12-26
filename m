Return-Path: <linux-kernel-owner+w=401wt.eu-S1751924AbZLZQgK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751924AbZLZQgK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Dec 2009 11:36:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751716AbZLZQgJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Dec 2009 11:36:09 -0500
Received: from mail-gx0-f211.google.com ([209.85.217.211]:63022 "EHLO
	mail-gx0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbZLZQgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Dec 2009 11:36:08 -0500
Date: Sat, 26 Dec 2009 08:36:00 -0800
From: Jun Sun <jsun@junsun.net>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Valid relocation symbol for FLAT format on ARM
Message-ID: <20091226163600.GA16091@Pogoplug>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Apparently newer GCC would generate ANCHOR symbols beyond the end of 
data/bss segment on ARM CPUs. As a result, the exiting validity checking
for relocation symbols in FLAT format will fail.

This also fixes a cosmetic error in printk. Text segment and data/bss
segment are allocated from two different areas. It is not meaningful to
give the diff between them in error reporting messages.

Signed-off-by: Jun Sun <jsun@junsun.net>

diff -Nru linux-2.6.32.2/arch/arm/include/asm/flat.h.orig linux-2.6.32.2/arch/arm/include/asm/flat.h
--- linux-2.6.32.2/arch/arm/include/asm/flat.h.orig	2009-12-18 14:27:07.000000000 -0800
+++ linux-2.6.32.2/arch/arm/include/asm/flat.h	2009-12-26 08:22:43.000000000 -0800
@@ -7,7 +7,12 @@
 
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
-#define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
+#define	flat_reloc_valid(reloc, size)		((reloc) <= (size) + 0x1000)
+/* [JSUN] new gcc 4.x generates ANCHOR symbols in order to reduce the size
+ * of GOT table for PIC code. It is possible the ANCHOR is placed beyond
+ * the end of data/bss segment up to 4K bytes(12 bits), because ARM allows
+ * negative 12-bit offset. Thus we allow 0x1000 extra in reloc address range.
+ */
 #define	flat_get_addr_from_rp(rp, relval, flags, persistent) get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
diff -Nru linux-2.6.32.2/fs/binfmt_flat.c.orig linux-2.6.32.2/fs/binfmt_flat.c
--- linux-2.6.32.2/fs/binfmt_flat.c.orig	2009-12-18 14:27:07.000000000 -0800
+++ linux-2.6.32.2/fs/binfmt_flat.c	2009-12-26 08:22:43.000000000 -0800
@@ -355,7 +355,7 @@
 
 	if (!flat_reloc_valid(r, start_brk - start_data + text_len)) {
 		printk("BINFMT_FLAT: reloc outside program 0x%x (0 - 0x%x/0x%x)",
-		       (int) r,(int)(start_brk-start_code),(int)text_len);
+		       (int) r,(int)(start_brk-start_data+text_len),(int)text_len);
 		goto failed;
 	}
 
