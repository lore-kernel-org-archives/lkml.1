Return-Path: <linux-kernel-owner+w=401wt.eu-S1763864AbZEAAQ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763864AbZEAAQ1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 20:16:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764687AbZEAACp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 20:02:45 -0400
Received: from BISCAYNE-ONE-STATION.MIT.EDU ([18.7.7.80]:61828 "EHLO
	biscayne-one-station.mit.edu" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765316AbZEAACo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 20:02:44 -0400
From: Tim Abbott <tabbott@MIT.EDU>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Tim Abbott <tabbott@MIT.EDU>, Sam Ravnborg <sam@ravnborg.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 04/11] x86: convert compressed loader to use __HEAD and HEAD_TEXT macros.
Date: Thu, 30 Apr 2009 20:01:31 -0400
Message-Id: <1241136098-10376-5-git-send-email-tabbott@mit.edu>
X-Mailer: git-send-email 1.6.2.1
In-Reply-To: <1241136098-10376-4-git-send-email-tabbott@mit.edu>
References: <1241136098-10376-1-git-send-email-tabbott@mit.edu>
 <1241136098-10376-2-git-send-email-tabbott@mit.edu>
 <1241136098-10376-3-git-send-email-tabbott@mit.edu>
 <1241136098-10376-4-git-send-email-tabbott@mit.edu>
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

Signed-off-by: Tim Abbott <tabbott@mit.edu>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/x86/boot/compressed/head_32.S     |    3 ++-
 arch/x86/boot/compressed/head_64.S     |    3 ++-
 arch/x86/boot/compressed/vmlinux.lds.S |    6 ++++--
 3 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 85bd328..83df56f 100644
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
 
-.section ".text.head","ax",@progbits
+__HEAD
 ENTRY(startup_32)
 	cld
 	/* test KEEP_SEGMENTS flag to see if the bootloader is asking
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index ed4a829..a788a91 100644
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
 
-.section ".text.head"
+__HEAD
 	.code32
 ENTRY(startup_32)
 	cld
diff --git a/arch/x86/boot/compressed/vmlinux.lds.S b/arch/x86/boot/compressed/vmlinux.lds.S
index ffcb191..093fb4f 100644
--- a/arch/x86/boot/compressed/vmlinux.lds.S
+++ b/arch/x86/boot/compressed/vmlinux.lds.S
@@ -1,3 +1,5 @@
+#include <asm-generic/vmlinux.lds.h>
+
 OUTPUT_FORMAT(CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT, CONFIG_OUTPUT_FORMAT)
 
 #ifdef CONFIG_X86_64
@@ -14,9 +16,9 @@ SECTIONS
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
1.6.2.1

