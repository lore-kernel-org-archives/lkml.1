Return-Path: <linux-kernel-owner+w=401wt.eu-S938590AbXFHHfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S938590AbXFHHfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 03:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967577AbXFHHXf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 03:23:35 -0400
Received: from 216-99-217-87.dsl.aracnet.com ([216.99.217.87]:58369 "EHLO
	sous-sol.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967268AbXFHHXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 03:23:33 -0400
Message-Id: <20070608072237.134603000@sous-sol.org>
References: <20070608072127.352723000@sous-sol.org>
User-Agent: quilt/0.46-1
Date: Fri, 08 Jun 2007 00:22:17 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       David Miller <davem@davemloft.net>, bunk@stusta.de,
       "David S. Miller" <davem@sunset.davemloft.net>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [patch 50/54] SPARC64: Fix two bugs wrt. kernel 4MB TSB.
Content-Disposition: inline; filename=sparc64-fix-two-bugs-wrt.-kernel-4mb-tsb.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-stable review patch.  If anyone has any objections, please let us know.
---------------------

From: David S. Miller <davem@sunset.davemloft.net>

1) The TSB lookup was not using the correct hash mask.

2) It was not aligned on a boundary equal to it's size,
   which is required by the sun4v Hypervisor.

wasn't having it's return value checked, and that bug will be fixed up
as well in a subsequent changeset.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Chris Wright <chrisw@sous-sol.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/sparc64/kernel/head.S |   31 ++++++++++++++++++++++++++-----
 arch/sparc64/mm/init.c     |    7 +++++--
 include/asm-sparc64/tsb.h  |    2 +-
 3 files changed, 32 insertions(+), 8 deletions(-)

--- linux-2.6.21.4.orig/arch/sparc64/kernel/head.S
+++ linux-2.6.21.4/arch/sparc64/kernel/head.S
@@ -653,33 +653,54 @@ setup_tba:
 	 restore
 sparc64_boot_end:
 
-#include "ktlb.S"
-#include "tsb.S"
 #include "etrap.S"
 #include "rtrap.S"
 #include "winfixup.S"
 #include "entry.S"
 #include "sun4v_tlb_miss.S"
 #include "sun4v_ivec.S"
+#include "ktlb.S"
+#include "tsb.S"
 
 /*
  * The following skip makes sure the trap table in ttable.S is aligned
  * on a 32K boundary as required by the v9 specs for TBA register.
  *
  * We align to a 32K boundary, then we have the 32K kernel TSB,
- * then the 32K aligned trap table.
+ * the 64K kernel 4MB TSB, and then the 32K aligned trap table.
  */
 1:
 	.skip	0x4000 + _start - 1b
 
+! 0x0000000000408000
+
 	.globl	swapper_tsb
 swapper_tsb:
 	.skip	(32 * 1024)
 
-! 0x0000000000408000
-
+	.globl	swapper_4m_tsb
+swapper_4m_tsb:
+	.skip	(64 * 1024)
+
+! 0x0000000000420000
+
+	/* Some care needs to be exercised if you try to move the
+	 * location of the trap table relative to other things.  For
+	 * one thing there are br* instructions in some of the
+	 * trap table entires which branch back to code in ktlb.S
+	 * Those instructions can only handle a signed 16-bit
+	 * displacement.
+	 *
+	 * There is a binutils bug (bugzilla #4558) which causes
+	 * the relocation overflow checks for such instructions to
+	 * not be done correctly.  So bintuils will not notice the
+	 * error and will instead write junk into the relocation and
+	 * you'll have an unbootable kernel.
+	 */
 #include "ttable.S"
 
+! 0x0000000000428000
+
 #include "systbls.S"
 
 	.data
--- linux-2.6.21.4.orig/arch/sparc64/mm/init.c
+++ linux-2.6.21.4/arch/sparc64/mm/init.c
@@ -60,8 +60,11 @@ unsigned long kern_linear_pte_xor[2] __r
 unsigned long kpte_linear_bitmap[KPTE_BITMAP_BYTES / sizeof(unsigned long)];
 
 #ifndef CONFIG_DEBUG_PAGEALLOC
-/* A special kernel TSB for 4MB and 256MB linear mappings.  */
-struct tsb swapper_4m_tsb[KERNEL_TSB4M_NENTRIES];
+/* A special kernel TSB for 4MB and 256MB linear mappings.
+ * Space is allocated for this right after the trap table
+ * in arch/sparc64/kernel/head.S
+ */
+extern struct tsb swapper_4m_tsb[KERNEL_TSB4M_NENTRIES];
 #endif
 
 #define MAX_BANKS	32
--- linux-2.6.21.4.orig/include/asm-sparc64/tsb.h
+++ linux-2.6.21.4/include/asm-sparc64/tsb.h
@@ -271,7 +271,7 @@ extern struct tsb_phys_patch_entry __tsb
 #define KERN_TSB4M_LOOKUP_TL1(TAG, REG1, REG2, REG3, REG4, OK_LABEL) \
 	sethi		%hi(swapper_4m_tsb), REG1; \
 	or		REG1, %lo(swapper_4m_tsb), REG1; \
-	and		TAG, (KERNEL_TSB_NENTRIES - 1), REG2; \
+	and		TAG, (KERNEL_TSB4M_NENTRIES - 1), REG2; \
 	sllx		REG2, 4, REG2; \
 	add		REG1, REG2, REG2; \
 	KTSB_LOAD_QUAD(REG2, REG3); \

-- 
