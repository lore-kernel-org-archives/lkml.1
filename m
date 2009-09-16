Return-Path: <linux-kernel-owner+w=401wt.eu-S1758912AbZIPVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758912AbZIPVUZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 17:20:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754903AbZIPVUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 17:20:18 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:64584 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754801AbZIPVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 17:20:17 -0400
From: Tim Abbott <tabbott@ksplice.com>
To: x86@kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Sam Ravnborg <sam@ravnborg.org>, Tim Abbott <tabbott@ksplice.com>
Subject: [PATCH v3 3/5] x86: convert to use __HEAD and HEAD_TEXT macros.
Date: Wed, 16 Sep 2009 16:44:28 -0400
Message-Id: <1253133870-25140-4-git-send-email-tabbott@ksplice.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
References: <1253133870-25140-1-git-send-email-tabbott@ksplice.com>
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
index 3765092..6ce80c5 100644
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
index b96ca47..5c7826d 100644
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

