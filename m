Return-Path: <linux-kernel-owner+w=401wt.eu-S1758697AbZD2JK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758697AbZD2JK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757864AbZD2JHG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:07:06 -0400
Received: from hera.kernel.org ([140.211.167.34]:60542 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbZD2JHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:07:03 -0400
Date: Wed, 29 Apr 2009 09:05:40 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-13-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-13-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify remaining parts
Message-ID: <tip-091e52c3551d3031343df24b573b770b4c6c72b6@git.kernel.org>
Git-Commit-ID: 091e52c3551d3031343df24b573b770b4c6c72b6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:05:42 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  091e52c3551d3031343df24b573b770b4c6c72b6
Gitweb:     http://git.kernel.org/tip/091e52c3551d3031343df24b573b770b4c6c72b6
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:29 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:35 +0200

x86, vmlinux.lds: unify remaining parts

32 bit:
- explicit page align .bss
- move ALING() out of .brk output section
- discard *(.eh_frame)

64 bit:
- move ALIGN() out of .bss output section
- move ALIGN() out of .brk output section
- use a dedicated section to define _end

[ Impact: unify and fix section alignments in linker script ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-13-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   32 +++++++++++++++++++++++++++-----
 arch/x86/kernel/vmlinux_32.lds.S |   26 --------------------------
 arch/x86/kernel/vmlinux_64.lds.S |   24 ------------------------
 3 files changed, 27 insertions(+), 55 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1ea2b85..ef3e4f1 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -359,12 +359,34 @@ SECTIONS
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
