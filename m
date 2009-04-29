Return-Path: <linux-kernel-owner+w=401wt.eu-S1758994AbZD2Hss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758994AbZD2Hss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Apr 2009 03:48:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755926AbZD2Hpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Apr 2009 03:45:33 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:57936 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754377AbZD2HpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Apr 2009 03:45:22 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@MIT.EDU>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 09/13] x86, vmlinux.lds: unify first part of initdata
Date: Wed, 29 Apr 2009 09:47:25 +0200
Message-Id: <1240991249-27117-9-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.2.GIT
In-Reply-To: <20090429073510.GA26386@uranus.ravnborg.org>
References: <20090429073510.GA26386@uranus.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32 bit:
- Move definition of __init_begin outside output_section
  because it covers more than one section
- Move ALIGN() for end-of-section inside .smp_locks output section.
  Same effect but the intent is better documented that
  we need both start and end aligned.

64 bit:
- Move ALIGN() outside output section in .init.setup
- Deleted unused __smp_alt_* symbols

None of the above should result in any functional change.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Cc: Tim Abbott <tabbott@MIT.EDU>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/kernel/vmlinux.lds.S    |   61 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kernel/vmlinux_32.lds.S |   60 -------------------------------------
 arch/x86/kernel/vmlinux_64.lds.S |   59 ------------------------------------
 3 files changed, 61 insertions(+), 119 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 168de19..458fa58 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -226,6 +226,67 @@ SECTIONS
 
 #endif /* CONFIG_X86_64 */
 
+	/* init_task */
+	. = ALIGN(THREAD_SIZE);
+	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
+		*(.data.init_task)
+	}
+#ifdef CONFIG_X86_64
+	 :data.init
+#endif
+
+	/*
+	 * smp_locks might be freed after init
+	 * start/end must be page aligned
+	 */
+	. = ALIGN(PAGE_SIZE);
+	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
+		__smp_locks = .;
+		*(.smp_locks)
+		__smp_locks_end = .;
+		. = ALIGN(PAGE_SIZE);
+	}
+
+	/* Init code and data - will be freed after init */
+	. = ALIGN(PAGE_SIZE);
+	__init_begin = .; /* paired with __init_end */
+	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
+		_sinittext = .;
+		INIT_TEXT
+		_einittext = .;
+	}
+
+	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
+		INIT_DATA
+	}
+
+	. = ALIGN(16);
+	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
+		__setup_start = .;
+		*(.init.setup)
+		__setup_end = .;
+	}
+	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
+		__initcall_start = .;
+		INITCALLS
+		__initcall_end = .;
+	}
+
+	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
+		__con_initcall_start = .;
+		*(.con_initcall.init)
+		__con_initcall_end = .;
+	}
+
+	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
+		__x86_cpu_dev_start = .;
+		*(.x86_cpu_dev.init)
+		__x86_cpu_dev_end = .;
+	}
+
+	SECURITY_INIT
+
+
 #ifdef CONFIG_X86_32
 # include "vmlinux_32.lds.S"
 #else
diff --git a/arch/x86/kernel/vmlinux_32.lds.S b/arch/x86/kernel/vmlinux_32.lds.S
index 8ade846..d8ba539 100644
--- a/arch/x86/kernel/vmlinux_32.lds.S
+++ b/arch/x86/kernel/vmlinux_32.lds.S
@@ -1,63 +1,3 @@
-	/* init_task */
-	. = ALIGN(THREAD_SIZE);
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		*(.data.init_task)
-	}
-
-	. = ALIGN(PAGE_SIZE);
-	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-		/* might get freed after init */
-		__smp_locks = .;
-		*(.smp_locks)
-		__smp_locks_end = .;
-	}
-	/* will be freed after init
-	 * Following ALIGN() is required to make sure no other data falls on the
-	 * same page where __smp_alt_end is pointing as that page might be freed
-	 * after boot. Always make sure that ALIGN() directive is present after
-	 * the section which contains __smp_alt_end.
-	 */
-	. = ALIGN(PAGE_SIZE);
-
-	/* Init code and data - will be freed after init */
-	. = ALIGN(PAGE_SIZE);
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		__init_begin = .;
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-		INIT_DATA
-	}
-
-	. = ALIGN(16);
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-
-	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
-		__x86_cpu_dev_start = .;
-		*(.x86_cpu_dev.init)
-		__x86_cpu_dev_end = .;
-	}
-
-	SECURITY_INIT
-
 	. = ALIGN(4);
 	.altinstructions : AT(ADDR(.altinstructions) - LOAD_OFFSET) {
 		__alt_instructions = .;
diff --git a/arch/x86/kernel/vmlinux_64.lds.S b/arch/x86/kernel/vmlinux_64.lds.S
index 013aa0e..0e8054e 100644
--- a/arch/x86/kernel/vmlinux_64.lds.S
+++ b/arch/x86/kernel/vmlinux_64.lds.S
@@ -1,62 +1,3 @@
-	/* init_task */
-	.data.init_task : AT(ADDR(.data.init_task) - LOAD_OFFSET) {
-		. = ALIGN(THREAD_SIZE);
-		*(.data.init_task)
-	} :data.init
-
-	.smp_locks : AT(ADDR(.smp_locks) - LOAD_OFFSET) {
-		/* might get freed after init */
-		. = ALIGN(PAGE_SIZE);
-		__smp_alt_begin = .;
-		__smp_locks = .;
-		*(.smp_locks)
-		__smp_locks_end = .;
-		. = ALIGN(PAGE_SIZE);
-		__smp_alt_end = .;
-	}
-
-	/* Init code and data */
-	. = ALIGN(PAGE_SIZE);
-	__init_begin = .;	/* paired with __init_end */
-	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
-		_sinittext = .;
-		INIT_TEXT
-		_einittext = .;
-	}
-
-	.init.data : AT(ADDR(.init.data) - LOAD_OFFSET) {
-		__initdata_begin = .;
-		INIT_DATA
-		__initdata_end = .;
-	}
-
-	.init.setup : AT(ADDR(.init.setup) - LOAD_OFFSET) {
-		. = ALIGN(16);
-		__setup_start = .;
-		*(.init.setup)
-		__setup_end = .;
-	}
-
-	.initcall.init : AT(ADDR(.initcall.init) - LOAD_OFFSET) {
-		__initcall_start = .;
-		INITCALLS
-		__initcall_end = .;
-	}
-
-	.con_initcall.init : AT(ADDR(.con_initcall.init) - LOAD_OFFSET) {
-		__con_initcall_start = .;
-		*(.con_initcall.init)
-		__con_initcall_end = .;
-	}
-
-	.x86_cpu_dev.init : AT(ADDR(.x86_cpu_dev.init) - LOAD_OFFSET) {
-		__x86_cpu_dev_start = .;
-		*(.x86_cpu_dev.init)
-		__x86_cpu_dev_end = .;
-	}
-
-	SECURITY_INIT
-
 	. = ALIGN(8);
 	.parainstructions : AT(ADDR(.parainstructions) - LOAD_OFFSET) {
 		__parainstructions = .;
-- 
1.6.0.6

