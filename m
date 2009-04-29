Return-Path: <linux-kernel-owner+w=401wt.eu-S1757638AbZD2JG4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757638AbZD2JG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 05:06:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753706AbZD2JFb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 05:05:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:60448 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbZD2JF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 05:05:28 -0400
Date: Wed, 29 Apr 2009 09:04:04 GMT
From: tip-bot for Sam Ravnborg <sam@ravnborg.org>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       torvalds@linux-foundation.org, sam@ravnborg.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       sam@ravnborg.org, torvalds@linux-foundation.org, tabbott@MIT.EDU,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1240991249-27117-4-git-send-email-sam@ravnborg.org>
References: <1240991249-27117-4-git-send-email-sam@ravnborg.org>
Subject: [tip:x86/kbuild] x86, vmlinux.lds: unify start/end of SECTIONS
Message-ID: <tip-444e0ae4831f99ba25062d9a5ccb7117c62841a0@git.kernel.org>
Git-Commit-ID: 444e0ae4831f99ba25062d9a5ccb7117c62841a0
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 29 Apr 2009 09:04:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  444e0ae4831f99ba25062d9a5ccb7117c62841a0
Gitweb:     http://git.kernel.org/tip/444e0ae4831f99ba25062d9a5ccb7117c62841a0
Author:     Sam Ravnborg <sam@ravnborg.org>
AuthorDate: Wed, 29 Apr 2009 09:47:20 +0200
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 29 Apr 2009 10:20:30 +0200

x86, vmlinux.lds: unify start/end of SECTIONS

[ Impact: cleanup ]

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
LKML-Reference: <1240991249-27117-4-git-send-email-sam@ravnborg.org>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/vmlinux.lds.S    |   14 ++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |    9 ---------
 arch/x86/kernel/vmlinux_64.lds.S |    9 ---------
 3 files changed, 14 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 1a1b303..845776f 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -54,12 +54,26 @@ PHDRS {
 	note PT_NOTE FLAGS(0);          /* ___ */
 }
 
+SECTIONS
+{
+#ifdef CONFIG_X86_32
+        . = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
+        phys_startup_32 = startup_32 - LOAD_OFFSET;
+#else
+        . = __START_KERNEL;
+        phys_startup_64 = startup_64 - LOAD_OFFSET;
+#endif
+
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
 #else
 # include "vmlinux_64.lds.S"
 #endif
 
+        STABS_DEBUG
+        DWARF_DEBUG
+}
+
 
 #ifdef CONFIG_X86_32
 ASSERT((_end - LOAD_OFFSET <= KERNEL_IMAGE_SIZE),
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 4fd40dc..3d3d49c 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,8 +1,3 @@
-SECTIONS
-{
-	. = LOAD_OFFSET + LOAD_PHYSICAL_ADDR;
-	phys_startup_32 = startup_32 - LOAD_OFFSET;
-
 	/* Text and read-only data */
 	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
 		_text = .;
@@ -205,7 +200,3 @@ SECTIONS
 		*(.exitcall.exit)
 		*(.discard)
 	}
-
-	STABS_DEBUG
-	DWARF_DEBUG
-}
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 6e7cbee..2d7fa20 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,8 +1,3 @@
-SECTIONS
-{
-	. = __START_KERNEL;
-	phys_startup_64 = startup_64 - LOAD_OFFSET;
-
 	/* Text and read-only data */
 	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
 		_text = .;
@@ -277,7 +272,3 @@ SECTIONS
 		*(.eh_frame)
 		*(.discard)
 	}
-
-	STABS_DEBUG
-	DWARF_DEBUG
-}
