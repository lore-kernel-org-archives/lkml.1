Return-Path: <linux-kernel-owner+w=401wt.eu-S1758836AbZD2JJi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758836AbZD2JJi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:09:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757037AbZD2JGg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:06:36 -0400
Received: from hera.kernel.org ([140.211.167.34]:60520 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757287AbZD2JGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:06:35 -0400
Date: Wed, 29 Apr 2009 09:05:18 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-11-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-11-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify .exit.* and .init.ramfs
Message-ID: <tip-bf6a57418d5445c98047edbec022c9e54d1526e6@git.kernel.org>
Git-Commit-ID: bf6a57418d5445c98047edbec022c9e54d1526e6
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:05:20 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bf6a57418d5445c98047edbec022c9e54d1526e6
Gitweb:     http://git.kernel.org/tip/bf6a57418d5445c98047edbec022c9e54d1526e6
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:27 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:34 +0200

x86, vmlinux.lds: unify .exit.* and .init.ramfs

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-11-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   20 ++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   21 ---------------------
 arch/x86/kernel/vmlinux_64.lds.S |   21 ---------------------
 3 files changed, 20 insertions(+), 42 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index c8dd71e..1ab62a5 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -309,6 +309,26 @@ SECTIONS
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
