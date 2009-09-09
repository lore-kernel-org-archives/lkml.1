Return-Path: <linux-kernel-owner+w=401wt.eu-S1752602AbZIICsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbZIICsu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 22:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbZIICsu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 22:48:50 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:45642 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752496AbZIICst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 22:48:49 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@redhat.com>,
       Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH 3/5] x86: convert to use __HEAD and HEAD_TEXT macros.
Date: Tue,  8 Sep 2009 22:48:16 -0400
Message-Id: <1252464498-26293-3-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
References: <1252464498-26293-1-git-send-email-tabbott@ksplice.com>
X-Spam-Flag: NO
X-Spam-Score: 0.00
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This has the consequence of changing the section name use for head
code from ".text.head" to ".head.text".  It also eliminates the
".text.head" output section (instead placing head code at the start of
the .text output section), which should be harmless.

This patch only changes the sections in the actual kernel, not those
in the compressed boot loader.

Signed-off-by: Tim Abbott <tabbott@ksplice.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/head_32.S     |    2 +-
 arch/x86/kernel/head_64.S     |    2 +-
 arch/x86/kernel/vmlinux.lds.S |   12 +++---------
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 3eba3ab..f689c31 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -79,7 +79,7 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+__HEAD
 ENTRY(startup_32)
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index d0bc0a1..780cd92 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -40,7 +40,7 @@ L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
 	.text
-	.section .text.head
+	__HEAD
 	.code64
 	.globl startup_64
 startup_64:
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index e771251..51a8478 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -65,17 +65,11 @@ SECTIONS
 #endif
 
 	/* Text and read-only data */
-
-	/* bootstrapping code */
-	.text.head : AT(ADDR(.text.head) - LOAD_OFFSET) {
-		_text = .;
-		*(.text.head)
-	} :text = 0x9090
-
-	/* The rest of the text */
 	.text :  AT(ADDR(.text) - LOAD_OFFSET) {
+		_text = .;
+		/* bootstrapping code */
+		HEAD_TEXT
 #ifdef CONFIG_X86_32
-		/* not really needed, already page aligned */
 		. = ALIGN(PAGE_SIZE);
 		*(.text.page_aligned)
 #endif
-- 
1.6.3.3

