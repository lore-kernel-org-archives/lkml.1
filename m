Return-Path: <linux-kernel-owner+w=401wt.eu-S1763544AbXE2GXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763544AbXE2GXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 02:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753330AbXE2GXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 02:23:08 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:33905 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235AbXE2GXH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 02:23:07 -0400
X-IronPort-AV: i="4.14,587,1170651600"; 
   d="scan'208"; a="40377352:sNHT22456826"
From: Bryan Wu <bryan.wu@analog.com>
To: linux-kernel@vger.kernel.org
Cc: Bernd Schmidt <bernd.schmidt@analog.com>, Bryan Wu <bryan.wu@analog.com>,
       David McCullough <davidm@snapgear.com>,
       Greg Ungerer <gerg@snapgear.com>
Subject: [PATCH] binfmt_flat: minimum support for the Blackfin relocations
Date: Tue, 29 May 2007 14:24:27 +0800
Message-Id: <1180419867864-git-send-email-bryan.wu@analog.com>
X-Mailer: git-send-email 1.5.2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bernd Schmidt <bernd.schmidt@analog.com>

This just adds minimum support for the Blackfin relocations,
since we don't have enough space in each reloc. The idea
is to store a value with one relocation so that subsequent ones can
access it.

Signed-off-by: Bernd Schmidt <bernd.schmidt@analog.com>
Signed-off-by: Bryan Wu <bryan.wu@analog.com>
Cc: David McCullough <davidm@snapgear.com>
Cc: Greg Ungerer <gerg@snapgear.com>
---
 fs/binfmt_flat.c             |    5 ++++-
 include/asm-h8300/flat.h     |    3 ++-
 include/asm-m32r/flat.h      |    3 ++-
 include/asm-m68knommu/flat.h |    3 ++-
 include/asm-sh/flat.h        |    3 ++-
 include/asm-v850/flat.h      |    4 +++-
 6 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index 7b0265d..13b58f8 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -742,6 +742,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 	 * __start to address 4 so that is okay).
 	 */
 	if (rev > OLD_FLAT_VERSION) {
+		unsigned long persistent = 0;
 		for (i=0; i < relocs; i++) {
 			unsigned long addr, relval;
 
@@ -749,6 +750,8 @@ static int load_flat_file(struct linux_binprm * bprm,
 			   relocated (of course, the address has to be
 			   relocated first).  */
 			relval = ntohl(reloc[i]);
+			if (flat_set_persistent (relval, &persistent))
+				continue;
 			addr = flat_get_relocate_addr(relval);
 			rp = (unsigned long *) calc_reloc(addr, libinfo, id, 1);
 			if (rp == (unsigned long *)RELOC_FAILED) {
@@ -757,7 +760,7 @@ static int load_flat_file(struct linux_binprm * bprm,
 			}
 
 			/* Get the pointer's value.  */
-			addr = flat_get_addr_from_rp(rp, relval, flags);
+			addr = flat_get_addr_from_rp(rp, relval, flags, &persistent);
 			if (addr != 0) {
 				/*
 				 * Do the relocation.  PIC relocs in the data section are
diff --git a/include/asm-h8300/flat.h b/include/asm-h8300/flat.h
index c20eee7..2a87350 100644
--- a/include/asm-h8300/flat.h
+++ b/include/asm-h8300/flat.h
@@ -9,6 +9,7 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		1
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
+#define	flat_set_persistent(relval, p)		0
 
 /*
  * on the H8 a couple of the relocations have an instruction in the
@@ -18,7 +19,7 @@
  */
 
 #define	flat_get_relocate_addr(rel)		(rel)
-#define flat_get_addr_from_rp(rp, relval, flags) \
+#define flat_get_addr_from_rp(rp, relval, flags, persistent) \
         (get_unaligned(rp) & ((flags & FLAT_FLAG_GOTPIC) ? 0xffffffff: 0x00ffffff))
 #define flat_put_addr_at_rp(rp, addr, rel) \
 	put_unaligned (((*(char *)(rp)) << 24) | ((addr) & 0x00ffffff), rp)
diff --git a/include/asm-m32r/flat.h b/include/asm-m32r/flat.h
index 1b285f6..d851cf0 100644
--- a/include/asm-m32r/flat.h
+++ b/include/asm-m32r/flat.h
@@ -15,9 +15,10 @@
 #define	flat_stack_align(sp)		(*sp += (*sp & 3 ? (4 - (*sp & 3)): 0))
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
+#define	flat_set_persistent(relval, p)		0
 #define	flat_reloc_valid(reloc, size)		\
 	(((reloc) - textlen_for_m32r_lo16_data) <= (size))
-#define flat_get_addr_from_rp(rp, relval, flags) \
+#define flat_get_addr_from_rp(rp, relval, flags, persistent) \
 	m32r_flat_get_addr_from_rp(rp, relval, (text_len) )
 
 #define flat_put_addr_at_rp(rp, addr, relval) \
diff --git a/include/asm-m68knommu/flat.h b/include/asm-m68knommu/flat.h
index 2d836ed..814b517 100644
--- a/include/asm-m68knommu/flat.h
+++ b/include/asm-m68knommu/flat.h
@@ -9,8 +9,9 @@
 #define	flat_argvp_envp_on_stack()		1
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags)	get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
+#define	flat_set_persistent(relval, p)		0
 
 #endif /* __M68KNOMMU_FLAT_H__ */
diff --git a/include/asm-sh/flat.h b/include/asm-sh/flat.h
index 0d5cc04..dc4f595 100644
--- a/include/asm-sh/flat.h
+++ b/include/asm-sh/flat.h
@@ -16,8 +16,9 @@
 #define	flat_argvp_envp_on_stack()		0
 #define	flat_old_ram_flag(flags)		(flags)
 #define	flat_reloc_valid(reloc, size)		((reloc) <= (size))
-#define	flat_get_addr_from_rp(rp, relval, flags)	get_unaligned(rp)
+#define	flat_get_addr_from_rp(rp, relval, flags, p)	get_unaligned(rp)
 #define	flat_put_addr_at_rp(rp, val, relval)	put_unaligned(val,rp)
 #define	flat_get_relocate_addr(rel)		(rel)
+#define	flat_set_persistent(relval, p)		0
 
 #endif /* __ASM_SH_FLAT_H */
diff --git a/include/asm-v850/flat.h b/include/asm-v850/flat.h
index 3888f59..17f0ea5 100644
--- a/include/asm-v850/flat.h
+++ b/include/asm-v850/flat.h
@@ -25,6 +25,7 @@
 #define	flat_stack_align(sp)		/* nothing needed */
 #define	flat_argvp_envp_on_stack()	0
 #define	flat_old_ram_flag(flags)	(flags)
+#define	flat_set_persistent(relval, p)	0
 
 /* We store the type of relocation in the top 4 bits of the `relval.' */
 
@@ -46,7 +47,8 @@ flat_get_relocate_addr (unsigned long relval)
    For the v850, RP should always be half-word aligned.  */
 static inline unsigned long flat_get_addr_from_rp (unsigned long *rp,
 						   unsigned long relval,
-						   unsigned long flags)
+						   unsigned long flags,
+						   unsigned long *persistent)
 {
 	short *srp = (short *)rp;
 
-- 
1.5.2
