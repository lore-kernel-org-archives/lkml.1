Return-Path: <linux-kernel-owner+w=401wt.eu-S1756266AbYGKPr0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266AbYGKPr0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:47:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751482AbYGKPrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:47:18 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58986 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751413AbYGKPrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:47:17 -0400
Date: Fri, 11 Jul 2008 11:46:39 -0400
Message-Id: <200807111546.m6BFkdqA026828@pobox-2.corp.redhat.com>
From: Glauber Costa <gcosta@redhat.com>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       linux-kernel@vger.kernel.org, x86@kernel.org
Subject: [GIT PULL] dwarf headers integration
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo, please pull the latest master git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/glommer/linux-2.6-x86-integration.git master

into your tip/auto-x86-next tree

It contains integration of the dwarf headers.

Thanks!

	Glauber

------------------>
Glauber Costa (4):
      x86: use matching CFI_ENDPROC
      x86: use ignore macro instead of hash comment
      x86: use AS_CFI instead of UNWIND_INFO
      x86: merge dwarf2 headers

 arch/x86/kernel/entry_32.S  |    1 +
 include/asm-x86/dwarf2.h    |   62 ++++++++++++++++++++++++++++++++++++++++--
 include/asm-x86/dwarf2_32.h |   61 ------------------------------------------
 include/asm-x86/dwarf2_64.h |   56 --------------------------------------
 4 files changed, 60 insertions(+), 120 deletions(-)
 delete mode 100644 include/asm-x86/dwarf2_32.h
 delete mode 100644 include/asm-x86/dwarf2_64.h

diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 53393c3..cfe28a7 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -1024,6 +1024,7 @@ ENTRY(xen_sysenter_target)
 	RING0_INT_FRAME
 	addl $5*4, %esp		/* remove xen-provided frame */
 	jmp sysenter_past_esp
+	CFI_ENDPROC
 
 ENTRY(xen_hypervisor_callback)
 	CFI_STARTPROC
diff --git a/include/asm-x86/dwarf2.h b/include/asm-x86/dwarf2.h
index b3cbb0c..0bfe250 100644
--- a/include/asm-x86/dwarf2.h
+++ b/include/asm-x86/dwarf2.h
@@ -1,5 +1,61 @@
-#ifdef CONFIG_X86_32
-# include "dwarf2_32.h"
+#ifndef _DWARF2_H
+#define _DWARF2_H
+
+#ifndef __ASSEMBLY__
+#warning "asm/dwarf2.h should be only included in pure assembly files"
+#endif
+
+/*
+   Macros for dwarf2 CFI unwind table entries.
+   See "as.info" for details on these pseudo ops. Unfortunately
+   they are only supported in very new binutils, so define them
+   away for older version.
+ */
+
+#ifdef CONFIG_AS_CFI
+
+#define CFI_STARTPROC .cfi_startproc
+#define CFI_ENDPROC .cfi_endproc
+#define CFI_DEF_CFA .cfi_def_cfa
+#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
+#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
+#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
+#define CFI_OFFSET .cfi_offset
+#define CFI_REL_OFFSET .cfi_rel_offset
+#define CFI_REGISTER .cfi_register
+#define CFI_RESTORE .cfi_restore
+#define CFI_REMEMBER_STATE .cfi_remember_state
+#define CFI_RESTORE_STATE .cfi_restore_state
+#define CFI_UNDEFINED .cfi_undefined
+
+#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
+#define CFI_SIGNAL_FRAME .cfi_signal_frame
+#else
+#define CFI_SIGNAL_FRAME
+#endif
+
 #else
-# include "dwarf2_64.h"
+
+/* Due to the structure of pre-exisiting code, don't use assembler line
+   comment character # to ignore the arguments. Instead, use a dummy macro. */
+.macro ignore a=0, b=0, c=0, d=0
+.endm
+
+#define CFI_STARTPROC	ignore
+#define CFI_ENDPROC	ignore
+#define CFI_DEF_CFA	ignore
+#define CFI_DEF_CFA_REGISTER	ignore
+#define CFI_DEF_CFA_OFFSET	ignore
+#define CFI_ADJUST_CFA_OFFSET	ignore
+#define CFI_OFFSET	ignore
+#define CFI_REL_OFFSET	ignore
+#define CFI_REGISTER	ignore
+#define CFI_RESTORE	ignore
+#define CFI_REMEMBER_STATE ignore
+#define CFI_RESTORE_STATE ignore
+#define CFI_UNDEFINED ignore
+#define CFI_SIGNAL_FRAME ignore
+
+#endif
+
 #endif
diff --git a/include/asm-x86/dwarf2_32.h b/include/asm-x86/dwarf2_32.h
deleted file mode 100644
index 6d66398..0000000
--- a/include/asm-x86/dwarf2_32.h
+++ /dev/null
@@ -1,61 +0,0 @@
-#ifndef _DWARF2_H
-#define _DWARF2_H
-
-#ifndef __ASSEMBLY__
-#warning "asm/dwarf2.h should be only included in pure assembly files"
-#endif
-
-/*
-   Macros for dwarf2 CFI unwind table entries.
-   See "as.info" for details on these pseudo ops. Unfortunately
-   they are only supported in very new binutils, so define them
-   away for older version.
- */
-
-#ifdef CONFIG_UNWIND_INFO
-
-#define CFI_STARTPROC .cfi_startproc
-#define CFI_ENDPROC .cfi_endproc
-#define CFI_DEF_CFA .cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
-#define CFI_OFFSET .cfi_offset
-#define CFI_REL_OFFSET .cfi_rel_offset
-#define CFI_REGISTER .cfi_register
-#define CFI_RESTORE .cfi_restore
-#define CFI_REMEMBER_STATE .cfi_remember_state
-#define CFI_RESTORE_STATE .cfi_restore_state
-#define CFI_UNDEFINED .cfi_undefined
-
-#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME .cfi_signal_frame
-#else
-#define CFI_SIGNAL_FRAME
-#endif
-
-#else
-
-/* Due to the structure of pre-exisiting code, don't use assembler line
-   comment character # to ignore the arguments. Instead, use a dummy macro. */
-.macro ignore a=0, b=0, c=0, d=0
-.endm
-
-#define CFI_STARTPROC	ignore
-#define CFI_ENDPROC	ignore
-#define CFI_DEF_CFA	ignore
-#define CFI_DEF_CFA_REGISTER	ignore
-#define CFI_DEF_CFA_OFFSET	ignore
-#define CFI_ADJUST_CFA_OFFSET	ignore
-#define CFI_OFFSET	ignore
-#define CFI_REL_OFFSET	ignore
-#define CFI_REGISTER	ignore
-#define CFI_RESTORE	ignore
-#define CFI_REMEMBER_STATE ignore
-#define CFI_RESTORE_STATE ignore
-#define CFI_UNDEFINED ignore
-#define CFI_SIGNAL_FRAME ignore
-
-#endif
-
-#endif
diff --git a/include/asm-x86/dwarf2_64.h b/include/asm-x86/dwarf2_64.h
deleted file mode 100644
index c950519..0000000
--- a/include/asm-x86/dwarf2_64.h
+++ /dev/null
@@ -1,56 +0,0 @@
-#ifndef _DWARF2_H
-#define _DWARF2_H 1
-
-#ifndef __ASSEMBLY__
-#warning "asm/dwarf2.h should be only included in pure assembly files"
-#endif
-
-/*
-   Macros for dwarf2 CFI unwind table entries.
-   See "as.info" for details on these pseudo ops. Unfortunately
-   they are only supported in very new binutils, so define them
-   away for older version.
- */
-
-#ifdef CONFIG_AS_CFI
-
-#define CFI_STARTPROC .cfi_startproc
-#define CFI_ENDPROC .cfi_endproc
-#define CFI_DEF_CFA .cfi_def_cfa
-#define CFI_DEF_CFA_REGISTER .cfi_def_cfa_register
-#define CFI_DEF_CFA_OFFSET .cfi_def_cfa_offset
-#define CFI_ADJUST_CFA_OFFSET .cfi_adjust_cfa_offset
-#define CFI_OFFSET .cfi_offset
-#define CFI_REL_OFFSET .cfi_rel_offset
-#define CFI_REGISTER .cfi_register
-#define CFI_RESTORE .cfi_restore
-#define CFI_REMEMBER_STATE .cfi_remember_state
-#define CFI_RESTORE_STATE .cfi_restore_state
-#define CFI_UNDEFINED .cfi_undefined
-#ifdef CONFIG_AS_CFI_SIGNAL_FRAME
-#define CFI_SIGNAL_FRAME .cfi_signal_frame
-#else
-#define CFI_SIGNAL_FRAME
-#endif
-
-#else
-
-/* use assembler line comment character # to ignore the arguments. */
-#define CFI_STARTPROC	#
-#define CFI_ENDPROC	#
-#define CFI_DEF_CFA	#
-#define CFI_DEF_CFA_REGISTER	#
-#define CFI_DEF_CFA_OFFSET	#
-#define CFI_ADJUST_CFA_OFFSET	#
-#define CFI_OFFSET	#
-#define CFI_REL_OFFSET	#
-#define CFI_REGISTER	#
-#define CFI_RESTORE	#
-#define CFI_REMEMBER_STATE	#
-#define CFI_RESTORE_STATE	#
-#define CFI_UNDEFINED	#
-#define CFI_SIGNAL_FRAME	#
-
-#endif
-
-#endif
