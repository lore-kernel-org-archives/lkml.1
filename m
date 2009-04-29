Return-Path: <linux-kernel-owner+w=401wt.eu-S1757172AbZD2Hpp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757172AbZD2Hpp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:45:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754450AbZD2HpX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:23 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55942 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 05/13] x86, vmlinux.lds: unify .text output sections
Date: Wed, 29 Apr 2009 09:47:21 +0200
Message-Id: <1240991249-27117-5-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 bit x86 had a dedicated .text.head output section
whereas 64 bit had it all in a single output section.

In the unified version the dedicated .text.head output section
was kept to have full control over the head code.

32 bit:
- Moved definition of _stext to the linker script.
  The definition is located _after_ .text.page_aligned as this
  is what 32 bit did before.

The ALIGN(8) was introduced so we hit the exact same addres
(on the tested config) before and after the move.

I assume that it is a bug that _stext did not cover the
.text.page_aligned section - it this is true it can be fixed
in a follow-up patch (and the ugly ALIGN() can be dropped).

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/head_32.S        |    7 -------
 arch/x86/kernel/vmlinux.lds.S    |   31 +++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   24 ------------------------
 arch/x86/kernel/vmlinux_64.lds.S |   20 --------------------
 4 files changed, 31 insertions(+), 51 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3068388..dc5ed4b 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -608,13 +608,6 @@ ignore_int:
 ENTRY(initial_code)
 	.long i386_start_kernel
 
-.section .text
-/*
- * Real beginning of normal "text" segment
- */
-ENTRY(stext)
-ENTRY(_stext)
-
 /*
  * BSS section
  */
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 40f3439..597e579 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -59,6 +59,37 @@ SECTIONS
         phys_startup_64 = startup_64 - LOAD_OFFSET;
 #endif
 
+	/* Text and read-only data */
+
+	/* bootstrapping code */
+	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
+		_text = .;
+		*(.text.head)
+	} :text = 0x9090
+
+	/* The rest of the text */
+	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
+#ifdef CONFIG_X86_32
+		/* not really needed, already page aligned */
+		. = ALIGN(PAGE_SIZE);
+		*(.text.page_aligned)
+#endif
+		. = ALIGN(8);
+		_stext = .;
+		TEXT_TEXT
+		SCHED_TEXT
+		LOCK_TEXT
+		KPROBES_TEXT
+		IRQENTRY_TEXT
+		*(.fixup)
+		*(.gnu.warning)
+		/* End of text section */
+		_etext = .;
+	} :text = 0x9090
+
+	NOTES :text :note
+
+
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
 #else
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 3d3d49c..8540092 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,27 +1,3 @@
-	/* Text and read-only data */
-	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
-		_text = .;
-		*(.text.head)
-	} :text = 0x9090
-
-	/* read-only */
-	.text : AT(ADDR(.text) - LOAD_OFFSET) {
-		/* not really needed, already page aligned */
-		. = ALIGN(PAGE_SIZE);
-		*(.text.page_aligned)
-		TEXT_TEXT
-		SCHED_TEXT
-		LOCK_TEXT
-		KPROBES_TEXT
-		IRQENTRY_TEXT
-		*(.fixup)
-		*(.gnu.warning)
-		/* End of text section */
-		_etext = .;
-	} :text = 0x9090
-
-	NOTES :text :note
-
 	/* Exception table */
 	. = ALIGN(16);
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 2d7fa20..b5d4367 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,23 +1,3 @@
-	/* Text and read-only data */
-	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
-		_text = .;
-		/* First the code that has to be first for bootstrapping */
-		*(.text.head)
-		_stext = .;
-		/* Then the rest */
-		TEXT_TEXT
-		SCHED_TEXT
-		LOCK_TEXT
-		KPROBES_TEXT
-		IRQENTRY_TEXT
-		*(.fixup)
-		*(.gnu.warning)
-		/* End of text section */
-		_etext = .;
-	} :text = 0x9090
-
-	NOTES :text :note
-
 	/* Exception table */
 	. = ALIGN(16);
 	__ex_table : AT(ADDR(__ex_table) - LOAD_OFFSET) {
-- 
1.6.0.6

