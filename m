Return-Path: <linux-kernel-owner+w=401wt.eu-S1758400AbZD2Hqm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758400AbZD2Hqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:46:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755386AbZD2Hp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:27 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:55943 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754294AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 07/13] x86, vmlinux.lds: unify data output sections
Date: Wed, 29 Apr 2009 09:47:23 +0200
Message-Id: <1240991249-27117-7-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 32 bit this is a non-functional change.

For 64 bit the following functional changes is introduced:
- .data.page_aligned has moved
- .data.cacheline_aligned has moved
- .data.read_mostly has moved
- ALIGN() moved out of output section for .data.cacheline_aligned
- ALIGN() moved out of output section for .data.page_aligned

Notice that 32 bit and 64 bit has different location of _edata.
.data_nosave is 32 bit only as 64 bit is special due to PERCPU.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   55 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   37 -------------------------
 arch/x86/kernel/vmlinux_64.lds.S |   28 -------------------
 3 files changed, 55 insertions(+), 65 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 94b67bf..3d741dd 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -99,6 +99,61 @@ SECTIONS
 
 	RODATA
 
+	/* Data */
+	. = ALIGN(PAGE_SIZE);
+	.data : AT(ADDR(.data) - LOAD_OFFSET) {
+		DATA_DATA
+		CONSTRUCTORS
+
+#ifdef CONFIG_X86_64
+		/* End of data section */
+		_edata = .;
+#endif
+	} :data
+
+#ifdef CONFIG_X86_32
+	/* 32 bit has nosave before _edata */
+	. = ALIGN(PAGE_SIZE);
+	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
+		__nosave_begin = .;
+		*(.data.nosave)
+		. = ALIGN(PAGE_SIZE);
+		__nosave_end = .;
+	}
+#endif
+
+	. = ALIGN(PAGE_SIZE);
+	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
+		*(.data.page_aligned)
+		*(.data.idt)
+	}
+
+#ifdef CONFIG_X86_32
+	. = ALIGN(32);
+#else
+	. = ALIGN(PAGE_SIZE);
+	. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
+#endif
+	.data.cacheline_aligned :
+		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
+		*(.data.cacheline_aligned)
+	}
+
+	/* rarely changed data like cpu maps */
+#ifdef CONFIG_X86_32
+	. = ALIGN(32);
+#else
+	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
+#endif
+	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
+		*(.data.read_mostly)
+
+#ifdef CONFIG_X86_32
+		/* End of data section */
+		_edata = .;
+#endif
+	}
+
 
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 920cc69..8ade846 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,40 +1,3 @@
-	/* writeable */
-	. = ALIGN(PAGE_SIZE);
-	/* Data */
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {
-		DATA_DATA
-		CONSTRUCTORS
-	} :data
-
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	}
-
-	. = ALIGN(PAGE_SIZE);
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		*(.data.page_aligned)
-		*(.data.idt)
-	}
-
-	. = ALIGN(32);
-	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		*(.data.cacheline_aligned)
-	}
-
-	/* rarely changed data like cpu maps */
-	. = ALIGN(32);
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
-
-		/* End of data section */
-		_edata = .;
-	}
-
 	/* init_task */
 	. = ALIGN(THREAD_SIZE);
 	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 641f3f9..8262701 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,26 +1,3 @@
-	/* Align data segment to page size boundary */
-	. = ALIGN(PAGE_SIZE);
-	/* Data */
-	.data : AT(ADDR(.data) - LOAD_OFFSET) {
-		DATA_DATA
-		CONSTRUCTORS
-		/* End of data section */
-		_edata = .;
-	} :data
-
-
-	.data.cacheline_aligned :
-		AT(ADDR(.data.cacheline_aligned) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		. = ALIGN(CONFIG_X86_L1_CACHE_BYTES);
-		*(.data.cacheline_aligned)
-	}
-
-	. = ALIGN(CONFIG_X86_INTERNODE_CACHE_BYTES);
-	.data.read_mostly : AT(ADDR(.data.read_mostly) - LOAD_OFFSET) {
-		*(.data.read_mostly)
-	}
-
 #define VSYSCALL_ADDR (-10*1024*1024)
 #define VSYSCALL_PHYS_ADDR ((LOADADDR(.data.read_mostly) + \
                             SIZEOF(.data.read_mostly) + 4095) & ~(4095))
@@ -95,11 +72,6 @@
 		*(.data.init_task)
 	} :data.init
 
-	.data.page_aligned : AT(ADDR(.data.page_aligned) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		*(.data.page_aligned)
-	}
-
 	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
 		/* might get freed after init */
 		. = ALIGN(PAGE_SIZE);
-- 
1.6.0.6

