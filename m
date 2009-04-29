Return-Path: <linux-kernel-owner+w=401wt.eu-S1756297AbZD2JHY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756297AbZD2JHY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:07:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755098AbZD2JFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:05:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:60461 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797AbZD2JFj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:05:39 -0400
Date: Wed, 29 Apr 2009 09:04:14 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-5-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-5-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify .text output sections
Message-ID: <tip-dfc20895d944cfa81d8ff00809b68ecb8f72cbb0@git.kernel.org>
Git-Commit-ID: dfc20895d944cfa81d8ff00809b68ecb8f72cbb0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:04:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dfc20895d944cfa81d8ff00809b68ecb8f72cbb0
Gitweb:     http://git.kernel.org/tip/dfc20895d944cfa81d8ff00809b68ecb8f72cbb0
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:21 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:31 +0200

x86, vmlinux.lds: unify .text output sections

32 bit x86 had a dedicated .text.head output section,
whereas 64 bit had it all in a single output section.

In the unified version the dedicated .text.head output section
was kept to have full control over the head code.

32 bit:

- Moved definition of _stext to the linker script.
  The definition is located _after_ .text.page_aligned as this
  is what 32 bit did before.

The ALIGN(8) was introduced so we hit the exact same address
(on the tested config) before and after the move.

I assume that it is a bug that _stext did not cover the
.text.page_aligned section - if this is true it can be fixed
in a follow-up patch (and the ugly ALIGN() can be dropped).

[ Impact: 64-bit: cleanup, 32-bit: use the 64-bit linker script ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-5-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


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
index 845776f..a7c88bb 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -64,6 +64,37 @@ SECTIONS
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
