Return-Path: <linux-kernel-owner+w=401wt.eu-S1758655AbZD2Hrq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758655AbZD2Hrq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:47:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755564AbZD2Hpa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:30 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55958 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 13/13] x86, vmlinux.lds: unify remaining parts
Date: Wed, 29 Apr 2009 09:47:29 +0200
Message-Id: <1240991249-27117-13-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 bit:
- explicit page align .bss
- move ALING() out of .brk output section
- discard *(.eh_frame)

64 bit:
- move ALIGN() out of .bss output section
- move ALING() out of .brk output section
- use a dedicated section to define _end

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   32 +++++++++++++++++++++++++++-----
 arch/x86/kernel/vmlinux_32.lds.S |   26 --------------------------
 arch/x86/kernel/vmlinux_64.lds.S |   24 ------------------------
 3 files changed, 27 insertions(+), 55 deletions(-)
 delete mode 100644 arch/x86/kernel/vmlinux_32.lds.S
 delete mode 100644 arch/x86/kernel/vmlinux_64.lds.S

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index ea21e04..5e6e1cb 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -354,12 +354,34 @@ SECTIONS
 	/* use another section data.init2, see PERCPU_VADDR() above */
 #endif
 
+	/* BSS */
+	. = ALIGN(PAGE_SIZE);
+	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
+		__bss_start = .;
+		*(.bss.page_aligned)
+		*(.bss)
+		. = ALIGN(4);
+		__bss_stop = .;
+	}
 
-#ifdef CONFIG_X86_32
-# include "vmlinux_32.lds.S"
-#else
-# include "vmlinux_64.lds.S"
-#endif
+	. = ALIGN(PAGE_SIZE);
+	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
+		__brk_base = .;
+		. += 64 * 1024;		/* 64k alignment slop space */
+		*(.brk_reservation)	/* areas brk users have reserved */
+		__brk_limit = .;
+	}
+
+	.end : AT(ADDR(.end) - LOAD_OFFSET) {
+		_end = .;
+	}
+
+	/* Sections to be discarded */
+	/DISCARD/ : {
+		*(.exitcall.exit)
+		*(.eh_frame)
+		*(.discard)
+	}
 
         STABS_DEBUG
         DWARF_DEBUG
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
deleted file mode 100644
index d23ee2c..0000000
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ /dev/null
@@ -1,26 +0,0 @@
-	/* BSS */
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		__bss_start = .;
-		*(.bss.page_aligned)
-		*(.bss)
-		. = ALIGN(4);
-		__bss_stop = .;
-	}
-
-	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		__brk_base = .;
-		. += 64 * 1024;		/* 64k alignment slop space */
-		*(.brk_reservation)	/* areas brk users have reserved */
-		__brk_limit = .;
-	}
-
-	.end : AT(ADDR(.end) - LOAD_OFFSET) {
-		_end = . ;
-	}
-
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.discard)
-	}
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
deleted file mode 100644
index a539366..0000000
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ /dev/null
@@ -1,24 +0,0 @@
-	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		__bss_start = .;		/* BSS */
-		*(.bss.page_aligned)
-		*(.bss)
-		__bss_stop = .;
-	}
-
-	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		__brk_base = .;
-		. += 64 * 1024;		/* 64k alignment slop space */
-		*(.brk_reservation)	/* areas brk users have reserved */
-		__brk_limit = .;
-	}
-
-	_end = . ;
-
-	/* Sections to be discarded */
-	/DISCARD/ : {
-		*(.exitcall.exit)
-		*(.eh_frame)
-		*(.discard)
-	}
-- 
1.6.0.6

