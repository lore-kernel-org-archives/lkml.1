Return-Path: <linux-kernel-owner+w=401wt.eu-S932699AbXB0IpX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932699AbXB0IpX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 03:45:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161049AbXB0InO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 03:43:14 -0500
Received: from gw.goop.org ([64.81.55.164]:46865 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932991AbXB0Iih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 03:38:37 -0500
Message-Id: <20070227081632.823864420@goop.org>
References: <20070227081337.434798469@goop.org>
User-Agent: quilt/0.46-1
Date: Tue, 27 Feb 2007 00:13:47 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@muc.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       virtualization@lists.osdl.org, xen-devel@lists.xensource.com,
       Chris Wright <chrisw@sous-sol.org>, Zachary Amsden <zach@vmware.com>,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: [patch 10/26] Xen-paravirt_ops: rename struct paravirt_patch to paravirt_patch_site for clarity
Content-Disposition: inline; filename=paravirt-patch-rename-paravirt_patch.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rename struct paravirt_patch to paravirt_patch_site, so that it
clearly refers to a callsite, and not the patch which may be applied
to that callsite.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/alternative.c |    8 +++-----
 arch/i386/kernel/vmi.c         |    4 ----
 include/asm-i386/alternative.h |    6 +++---
 include/asm-i386/paravirt.h    |    5 ++++-
 4 files changed, 10 insertions(+), 13 deletions(-)

===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -350,9 +350,9 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
-{
-	struct paravirt_patch *p;
+void apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end)
+{
+	struct paravirt_patch_site *p;
 
 	for (p = start; p < end; p++) {
 		unsigned int used;
@@ -379,8 +379,6 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
 void __init alternative_instructions(void)
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -70,10 +70,6 @@ struct {
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
 } vmi_ops;
-
-/* XXX move this to alternative.h */
-extern struct paravirt_patch __start_parainstructions[],
-	__stop_parainstructions[];
 
 /*
  * VMI patching routines.
===================================================================
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -118,12 +118,12 @@ static inline void alternatives_smp_swit
 #define LOCK_PREFIX ""
 #endif
 
-struct paravirt_patch;
+struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
+void apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end);
 #else
 static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+apply_paravirt(struct paravirt_patch_site *start, struct paravirt_patch_site *end)
 {}
 #define __start_parainstructions NULL
 #define __stop_parainstructions NULL
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -561,12 +561,15 @@ static inline void pmd_clear(pmd_t *pmdp
 #define arch_leave_lazy_mmu_mode() paravirt_ops.set_lazy_mode(PARAVIRT_LAZY_NONE)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
-struct paravirt_patch {
+struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
 	u8 instrtype;		/* type of this instruction */
 	u8 len;			/* length of original instruction */
 	u16 clobbers;		/* what registers you may clobber */
 };
+
+extern struct paravirt_patch_site __start_parainstructions[],
+	__stop_parainstructions[];
 
 #define paravirt_alt(insn_string, typenum, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\

-- 

