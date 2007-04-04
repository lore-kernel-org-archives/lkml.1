Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXDEAQo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXDEAQo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 20:16:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932112AbXDEAQo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 20:16:44 -0400
Received: from 230.sub-75-208-113.myvzw.com ([75.208.113.230]:36876 "EHLO
	mail.goop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932081AbXDEAQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 20:16:43 -0400
Message-Id: <20070404191205.617690202@goop.org>
References: <20070404191151.009821039@goop.org>
User-Agent: quilt/0.46-1
Date: Wed, 04 Apr 2007 12:12:00 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>, Zachary Amsden <zach@vmware.com>
Subject: [patch 09/20] rename struct paravirt_patch to paravirt_patch_site for clarity
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
 arch/i386/kernel/alternative.c |    9 ++++-----
 arch/i386/kernel/vmi.c         |    4 ----
 include/asm-i386/alternative.h |    8 +++++---
 include/asm-i386/paravirt.h    |    5 ++++-
 4 files changed, 13 insertions(+), 13 deletions(-)

===================================================================
--- a/arch/i386/kernel/alternative.c
+++ b/arch/i386/kernel/alternative.c
@@ -335,9 +335,10 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
-{
-	struct paravirt_patch *p;
+void apply_paravirt(struct paravirt_patch_site *start,
+		    struct paravirt_patch_site *end)
+{
+	struct paravirt_patch_site *p;
 
 	if (noreplace_paravirt)
 		return;
@@ -355,8 +356,6 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __parainstructions[],
-	__parainstructions_end[];
 #endif	/* CONFIG_PARAVIRT */
 
 void __init alternative_instructions(void)
===================================================================
--- a/arch/i386/kernel/vmi.c
+++ b/arch/i386/kernel/vmi.c
@@ -70,10 +70,6 @@ static struct {
 	void (*set_initial_ap_state)(int, int);
 	void (*halt)(void);
 } vmi_ops;
-
-/* XXX move this to alternative.h */
-extern struct paravirt_patch __parainstructions[],
-	__parainstructions_end[];
 
 /*
  * VMI patching routines.
===================================================================
--- a/include/asm-i386/alternative.h
+++ b/include/asm-i386/alternative.h
@@ -114,12 +114,14 @@ static inline void alternatives_smp_swit
 #define LOCK_PREFIX ""
 #endif
 
-struct paravirt_patch;
+struct paravirt_patch_site;
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end);
+void apply_paravirt(struct paravirt_patch_site *start,
+		    struct paravirt_patch_site *end);
 #else
 static inline void
-apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+apply_paravirt(struct paravirt_patch_site *start,
+	       struct paravirt_patch_site *end)
 {}
 #define __parainstructions	NULL
 #define __parainstructions_end	NULL
===================================================================
--- a/include/asm-i386/paravirt.h
+++ b/include/asm-i386/paravirt.h
@@ -502,12 +502,15 @@ void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
-struct paravirt_patch {
+struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
 	u8 instrtype;		/* type of this instruction */
 	u8 len;			/* length of original instruction */
 	u16 clobbers;		/* what registers you may clobber */
 };
+
+extern struct paravirt_patch_site __parainstructions[],
+	__parainstructions_end[];
 
 #define paravirt_alt(insn_string, typenum, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\

-- 

