Return-Path: <linux-kernel-owner+w=401wt.eu-S1759012AbZD2JJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759012AbZD2JJ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757113AbZD2JGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:06:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:60519 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757291AbZD2JGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:06:35 -0400
Date: Wed, 29 Apr 2009 09:05:29 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-12-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-12-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify percpu
Message-ID: <tip-9d16e78318f174fd4b07916a93e41749d5199267@git.kernel.org>
Git-Commit-ID: 9d16e78318f174fd4b07916a93e41749d5199267
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:05:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9d16e78318f174fd4b07916a93e41749d5199267
Gitweb:     http://git.kernel.org/tip/9d16e78318f174fd4b07916a93e41749d5199267
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:28 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:34 +0200

x86, vmlinux.lds: unify percpu

32 bit:
- move __init_end outside the .bss output section
  It really did not belong in there

[ Impact: 64-bit: cleanup, 32-bit: refactor linker script ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-12-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   30 ++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    6 ------
 arch/x86/kernel/vmlinux_64.lds.S |   26 --------------------------
 3 files changed, 30 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1ab62a5..1ea2b85 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -330,6 +330,36 @@ SECTIONS
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
