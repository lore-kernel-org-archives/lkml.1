Return-Path: <linux-kernel-owner+w=401wt.eu-S1763739AbZEAAQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763739AbZEAAQt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765336AbZEAACx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:53 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61874 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764794AbZEAACv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:51 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 05/11] x86: convert to use __HEAD and HEAD_TEXT macros.
Date: Thu, 30 Apr 2009 20:01:32 -0400
Message-Id: <1241136098-10376-6-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-5-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
 <1241136098-10376-5-git-send-email-tabbott@mit.edu>
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

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
---
 arch/x86/kernel/head_32.S     |    2 +-
 arch/x86/kernel/head_64.S     |    2 +-
 arch/x86/kernel/vmlinux.lds.S |   12 +++---------
 3 files changed, 5 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index d251f71..9b7920d 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -80,7 +80,7 @@ RESERVE_BRK(pagetables, INIT_MAP_SIZE)
  * any particular GDT layout, because we load our own as soon as we
  * can.
  */
-.section .text.head,"ax",@progbits
+__HEAD
 ENTRY(startup_32)
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
 		us to not reload segments */
diff --git a/arch/x86/kernel/head_64.S b/arch/x86/kernel/head_64.S
index ae9a453..7cd4956 100644
--- a/arch/x86/kernel/head_64.S
+++ b/arch/x86/kernel/head_64.S
@@ -41,7 +41,7 @@ L4_START_KERNEL = pgd_index(__START_KERNEL_map)
 L3_START_KERNEL = pud_index(__START_KERNEL_map)
 
 	.text
-	.section .text.head
+	__HEAD
 	.code64
 	.globl startup_64
 startup_64:
diff --git a/arch/x86/kernel/vmlinux.lds.S b/arch/x86/kernel/vmlinux.lds.S
index 6f73355..791afa7 100644
--- a/arch/x86/kernel/vmlinux.lds.S
+++ b/arch/x86/kernel/vmlinux.lds.S
@@ -66,17 +66,11 @@ SECTIONS
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
1.6.2.1

