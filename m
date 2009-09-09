Return-Path: <linux-kernel-owner+w=401wt.eu-S1752813AbZIICvx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752813AbZIICvx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:51:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752766AbZIICvt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:51:49 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:46336 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751536AbZIICvq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:51:46 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@redhat.com>,
       Tim Abbott <tabbott@ksplice.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 2/5] x86: convert compressed loader to use __HEAD and HEAD_TEXT macros.
Date: Tue,  8 Sep 2009 22:48:15 -0400
Message-Id: <1252464498-26293-2-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
References: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".

Linus suggested that we merge the ".text.head" section with ".text"
(presumably while preserving the fact that the head code starts at 0).
When I tried this it caused the kernel to not boot.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/boot/compressed/head_32.S     |    3 ++-
 arch/x86/boot/compressed/head_64.S     |    3 ++-
 arch/x86/boot/compressed/vmlinux.lds.S |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 75e4f00..f543b70 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -23,13 +23,14 @@
  */
 	.text
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/page_types.h>
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
-	.section ".text.head","ax",@progbits
+	__HEAD
 ENTRY(startup_32)
 	cld
 	/*
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index f62c284..077e1b6 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -24,6 +24,7 @@
 	.code32
 	.text
 
+#include <linux/init.h>
 #include <linux/linkage.h>
 #include <asm/segment.h>
 #include <asm/pgtable_types.h>
@@ -33,7 +34,7 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
-	.section ".text.head"
+	__HEAD
 	.code32
 ENTRY(startup_32)
 	cld
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index cc353e1..f4193bb 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -1,3 +1,5 @@
+#include <asm-generic/vmlinux.lds.h>
+
 OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 
 #undef i386
@@ -18,9 +20,9 @@ SECTIONS
 	 * address 0.
 	 */
 	. = 0;
-	.text.head : {
+	.head.text : {
 		_head = . ;
-		*(.text.head)
+		HEAD_TEXT
 		_ehead = . ;
 	}
 	.rodata.compressed : {
-- 
1.6.3.3

