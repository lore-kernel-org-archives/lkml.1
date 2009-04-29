Return-Path: <linux-kernel-owner+w=401wt.eu-S1759291AbZD2Hta@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbZD2Hta (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:49:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756208AbZD2Hpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:34 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57979 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754752AbZD2HpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:25 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 11/13] x86, vmlinux.lds: unify .exit.* and .init.ramfs
Date: Wed, 29 Apr 2009 09:47:27 +0200
Message-Id: <1240991249-27117-11-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional change

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   20 ++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   21 ---------------------
 arch/x86/kernel/vmlinux_64.lds.S |   21 ---------------------
 3 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 6cfb1e1..4a433a0 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -304,6 +304,26 @@ SECTIONS
 		*(.altinstr_replacement)
 	}
 
+	/*
+	 * .exit.text is discard at runtime, not link time, to deal with
+	 *  references from .altinstructions and .eh_frame
+	 */
+	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
+		EXIT_TEXT
+	}
+
+	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
+		EXIT_DATA
+	}
+
+#ifdef CONFIG_BLK_DEV_INITRD
+	. = ALIGN(PAGE_SIZE);
+	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
+		__initramfs_start = .;
+		*(.init.ramfs)
+		__initramfs_end = .;
+	}
+#endif
 
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 5df9647..36c8fbd 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,24 +1,3 @@
-	/*
-	 * .exit.text is discard at runtime, not link time, to deal with
-	 *  references from .altinstructions and .eh_frame
-	 */
-	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-		EXIT_TEXT
-	}
-
-	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-		EXIT_DATA
-	}
-
-#if defined(CONFIG_BLK_DEV_INITRD)
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-
 	PERCPU(PAGE_SIZE)
 
 	. = ALIGN(PAGE_SIZE);
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 9ef7096..1aa5362 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,24 +1,3 @@
-	/*
-	 * .exit.text is discard at runtime, not link time, to deal with
-	 *  references from .altinstructions and .eh_frame
-	 */
-	.exit.text : AT(ADDR(.exit.text) - LOAD_OFFSET) {
-		EXIT_TEXT
-	}
-
-	.exit.data : AT(ADDR(.exit.data) - LOAD_OFFSET) {
-		EXIT_DATA
-	}
-
-#ifdef CONFIG_BLK_DEV_INITRD
-	. = ALIGN(PAGE_SIZE);
-	.init.ramfs : AT(ADDR(.init.ramfs) - LOAD_OFFSET) {
-		__initramfs_start = .;
-		*(.init.ramfs)
-		__initramfs_end = .;
-	}
-#endif
-
 #ifdef CONFIG_SMP
 	/*
 	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-- 
1.6.0.6

