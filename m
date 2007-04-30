Return-Path: <linux-kernel-owner+w=401wt.eu-S1754529AbXD3Kax@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbXD3Kax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754565AbXD3K2n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:28:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:42961 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754567AbXD3K1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:27:49 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: jeremy@goop.org, rusty@rustcorp.com.au, zach@vmware.com,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [9/40] i386: rename struct paravirt_patch to paravirt_patch_site for clarity
Message-Id: <20070430102742.5385D151F6@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:27:42 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Jeremy Fitzhardinge <jeremy@goop.org>
Rename struct paravirt_patch to paravirt_patch_site, so that it
clearly refers to a callsite, and not the patch which may be applied
to that callsite.

Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Zachary Amsden <zach@vmware.com>

---
 arch/i386/kernel/alternative.c |    7 ++++---
 include/asm-i386/alternative.h |    8 +++++---
 include/asm-i386/paravirt.h    |    5 ++++-
 3 files changed, 13 insertions(+), 7 deletions(-)

===================================================================
Index: linux/arch/i386/kernel/alternative.c
===================================================================
--- linux.orig/arch/i386/kernel/alternative.c
+++ linux/arch/i386/kernel/alternative.c
@@ -325,9 +325,10 @@ void alternatives_smp_switch(int smp)
 #endif
 
 #ifdef CONFIG_PARAVIRT
-void apply_paravirt(struct paravirt_patch *start, struct paravirt_patch *end)
+void apply_paravirt(struct paravirt_patch_site *start,
+		    struct paravirt_patch_site *end)
 {
-	struct paravirt_patch *p;
+	struct paravirt_patch_site *p;
 
 	for (p = start; p < end; p++) {
 		unsigned int used;
@@ -342,7 +343,7 @@ void apply_paravirt(struct paravirt_patc
 	/* Sync to be conservative, in case we patched following instructions */
 	sync_core();
 }
-extern struct paravirt_patch __start_parainstructions[],
+extern struct paravirt_patch_site __start_parainstructions[],
 	__stop_parainstructions[];
 #endif	/* CONFIG_PARAVIRT */
 
Index: linux/include/asm-i386/alternative.h
===================================================================
--- linux.orig/include/asm-i386/alternative.h
+++ linux/include/asm-i386/alternative.h
@@ -115,12 +115,14 @@ static inline void alternatives_smp_swit
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
 #define __start_parainstructions NULL
 #define __stop_parainstructions NULL
Index: linux/include/asm-i386/paravirt.h
===================================================================
--- linux.orig/include/asm-i386/paravirt.h
+++ linux/include/asm-i386/paravirt.h
@@ -505,13 +505,16 @@ void _paravirt_nop(void);
 #define paravirt_nop	((void *)_paravirt_nop)
 
 /* These all sit in the .parainstructions section to tell us what to patch. */
-struct paravirt_patch {
+struct paravirt_patch_site {
 	u8 *instr; 		/* original instructions */
 	u8 instrtype;		/* type of this instruction */
 	u8 len;			/* length of original instruction */
 	u16 clobbers;		/* what registers you may clobber */
 };
 
+extern struct paravirt_patch_site __parainstructions[],
+	__parainstructions_end[];
+
 #define paravirt_alt(insn_string, typenum, clobber)	\
 	"771:\n\t" insn_string "\n" "772:\n"		\
 	".pushsection .parainstructions,\"a\"\n"	\
