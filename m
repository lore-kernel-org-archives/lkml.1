Return-Path: <linux-kernel-owner+w=401wt.eu-S1759008AbZD2HtK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759008AbZD2HtK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:49:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756142AbZD2Hpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57985 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168AbZD2HpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:25 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 12/13] x86, vmlinux.lds: unify percpu
Date: Wed, 29 Apr 2009 09:47:28 +0200
Message-Id: <1240991249-27117-12-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 bit:
- move __init_end outside the .bss output section
  It really did not belong in there

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    6 ------
 arch/x86/kernel/vmlinux_64.lds.S |   26 --------------------------
 3 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 4a433a0..ea21e04 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -325,6 +325,36 @@ SECTIONS
 	}
 #endif
 
+#if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
+	/*
+	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
+	 * output PHDR, so the next output section - __data_nosave - should
+	 * start another section data.init2.  Also, pda should be at the head of
+	 * percpu area.  Preallocate it and define the percpu offset symbol
+	 * so that it can be accessed as a percpu variable.
+	 */
+	. = ALIGN(PAGE_SIZE);
+	PERCPU_VADDR(0, :percpu)
+#else
+	PERCPU(PAGE_SIZE)
+#endif
+
+	. = ALIGN(PAGE_SIZE);
+	/* freed after init ends here */
+	__init_end = .;
+
+#ifdef CONFIG_X86_64
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		. = ALIGN(PAGE_SIZE);
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
+	} :data.init2
+	/* use another section data.init2, see PERCPU_VADDR() above */
+#endif
+
+
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
 #else
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 36c8fbd..d23ee2c 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,11 +1,5 @@
-	PERCPU(PAGE_SIZE)
-
-	. = ALIGN(PAGE_SIZE);
-	/* freed after init ends here */
-
 	/* BSS */
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		__init_end = .;
 		__bss_start = .;
 		*(.bss.page_aligned)
 		*(.bss)
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 1aa5362..a539366 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,29 +1,3 @@
-#ifdef CONFIG_SMP
-	/*
-	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-	 * output PHDR, so the next output section - __data_nosave - should
-	 * start another section data.init2.  Also, pda should be at the head of
-	 * percpu area.  Preallocate it and define the percpu offset symbol
-	 * so that it can be accessed as a percpu variable.
-	 */
-	. = ALIGN(PAGE_SIZE);
-	PERCPU_VADDR(0, :percpu)
-#else
-	PERCPU(PAGE_SIZE)
-#endif
-
-	. = ALIGN(PAGE_SIZE);
-	__init_end = .;
-
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	} :data.init2
-	/* use another section data.init2, see PERCPU_VADDR() above */
-
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
 		. = ALIGN(PAGE_SIZE);
 		__bss_start = .;		/* BSS */
-- 
1.6.0.6

