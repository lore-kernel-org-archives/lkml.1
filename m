Return-Path: <linux-kernel-owner+w=401wt.eu-S932673AbZEAAN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbZEAAN5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764050AbZEAACS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61752 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765261AbZEAACR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:17 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>
Subject: [PATCH 06/11] x86: use NOSAVE_DATA macro for .data.nosave section.
Date: Thu, 30 Apr 2009 20:01:33 -0400
Message-Id: <1241136098-10376-7-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-6-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
 <1241136098-10376-6-git-send-email-tabbott@mit.edu>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.data.nosave should not need a separate output section; this change
moves it into the .data section.

On x86_64, this has the consequence of moving .data.nosave inside
_edata, which I think should be harmless.

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
---
 arch/x86/kernel/vmlinux.lds.S |   29 ++++++-----------------------
 1 files changed, 6 insertions(+), 23 deletions(-)

diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 791afa7..88b059b 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -103,6 +103,7 @@ SECTIONS
 	. = ALIGN(PAGE_SIZE);
 	.data : AT(ADDR(.data) - LOAD_OFFSET) {
 		PAGE_ALIGNED_DATA
+		NOSAVE_DATA
 		DATA_DATA
 		CONSTRUCTORS
 
@@ -113,17 +114,6 @@ SECTIONS
 	} :data
 
 #ifdef CONFIG_X86_32
-	/* 32 bit has nosave before _edata */
-	. = ALIGN(PAGE_SIZE);
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	}
-#endif
-
-#ifdef CONFIG_X86_32
 	. = ALIGN(32);
 #else
 	. = ALIGN(PAGE_SIZE);
@@ -323,7 +313,7 @@ SECTIONS
 #if defined(CONFIG_X86_64) && defined(CONFIG_SMP)
 	/*
 	 * percpu offsets are zero-based on SMP.  PERCPU_VADDR() changes the
-	 * output PHDR, so the next output section - __data_nosave - should
+	 * output PHDR, so the next output section - .bss - should
 	 * start another section data.init2.  Also, pda should be at the head of
 	 * percpu area.  Preallocate it and define the percpu offset symbol
 	 * so that it can be accessed as a percpu variable.
@@ -341,17 +331,6 @@ SECTIONS
 		__init_end = .;
 	}
 
-#ifdef CONFIG_X86_64
-	.data_nosave : AT(ADDR(.data_nosave) - LOAD_OFFSET) {
-		. = ALIGN(PAGE_SIZE);
-		__nosave_begin = .;
-		*(.data.nosave)
-		. = ALIGN(PAGE_SIZE);
-		__nosave_end = .;
-	} :data.init2
-	/* use another section data.init2, see PERCPU_VADDR() above */
-#endif
-
 	/* BSS */
 	. = ALIGN(PAGE_SIZE);
 	.bss : AT(ADDR(.bss) - LOAD_OFFSET) {
@@ -361,6 +340,10 @@ SECTIONS
 		. = ALIGN(4);
 		__bss_stop = .;
 	}
+#ifdef CONFIG_X86_64
+	 :data.init2
+#endif
+	/* use another section data.init2, see PERCPU_VADDR() above */
 
 	. = ALIGN(PAGE_SIZE);
 	.brk : AT(ADDR(.brk) - LOAD_OFFSET) {
-- 
1.6.2.1

