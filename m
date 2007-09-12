Return-Path: <linux-kernel-owner+w=401wt.eu-S1765044AbXILUYh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765044AbXILUYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2007 16:24:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbXILUY3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Sep 2007 16:24:29 -0400
Received: from py-out-1112.google.com ([64.233.166.183]:16220 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756218AbXILUY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2007 16:24:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:mime-version:content-type:message-id;
        b=FRvgmrDuPqo1ex9mISgHvlwSkfukfa1xdwDvXxWtp6pDf/+gfijRJUv1YLnm4fmuMKWYZLccD76hoeC77/Mgiow9invj7sRdfhojJmirfChrvINrGPAR5pgGU/mJ3RaXJJumsxV7MwKMtQSE/zqr4Uxr8dH50okV26RPjVlZcwQ=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 1/2] section garbage collection for i386
Date: Wed, 12 Sep 2007 21:24:20 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_1rE6GA8rYQ/087t"
Message-Id: <200709122124.21164.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_1rE6GA8rYQ/087t
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Sam,

This patch is preparatory: it adds a few KEEP() directives where
I forgot them in previous patch set, adds comments which explains
places where KEEP() is definitely not needed, and fixes i386 vdso generation
in an "obviously safe" way.

Please apply.

Signed-off-by: Denys Vlasenko <vda.linux@googlemail.com>
--
vda

--Boundary-00=_1rE6GA8rYQ/087t
Content-Type: text/x-diff;
  charset="us-ascii";
  name="linux-2.6.23-rc4.5.fixes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="linux-2.6.23-rc4.5.fixes.patch"

diff -urpN linux-2.6.23-rc4.gc4/arch/i386/kernel/vsyscall.lds.S linux-2.6.23-rc4.gc5/arch/i386/kernel/vsyscall.lds.S
--- linux-2.6.23-rc4.gc4/arch/i386/kernel/vsyscall.lds.S	2007-07-09 00:32:17.000000000 +0100
+++ linux-2.6.23-rc4.gc5/arch/i386/kernel/vsyscall.lds.S	2007-09-12 19:47:17.000000000 +0100
@@ -23,10 +23,10 @@ SECTIONS
      is insufficient, ld -shared will barf.  Just increase it here.  */
   . = VDSO_PRELINK_asm + 0x400;
 
-  .text           : { *(.text) }		:text =0x90909090
+  .text           : { *(.text) *(.text.*) }	:text =0x90909090
   .note		  : { *(.note.*) }		:text :note
   .eh_frame_hdr   : { *(.eh_frame_hdr) }	:text :eh_frame_hdr
-  .eh_frame       : { KEEP (*(.eh_frame)) }	:text
+  .eh_frame       : { KEEP(*(.eh_frame)) }	:text
   .dynamic        : { *(.dynamic) }		:text :dynamic
   .useless        : {
   	*(.got.plt) *(.got)
diff -urpN linux-2.6.23-rc4.gc4/include/asm-generic/vmlinux.lds.h linux-2.6.23-rc4.gc5/include/asm-generic/vmlinux.lds.h
--- linux-2.6.23-rc4.gc4/include/asm-generic/vmlinux.lds.h	2007-09-12 19:46:32.000000000 +0100
+++ linux-2.6.23-rc4.gc5/include/asm-generic/vmlinux.lds.h	2007-09-12 19:47:17.000000000 +0100
@@ -169,6 +169,7 @@
 #define SCHED_TEXT							\
 		ALIGN_FUNCTION();					\
 		VMLINUX_SYMBOL(__sched_text_start) = .;			\
+		/* No need to KEEP */					\
 		*(.sched.text)						\
 		VMLINUX_SYMBOL(__sched_text_end) = .;
 
@@ -177,12 +178,14 @@
 #define LOCK_TEXT							\
 		ALIGN_FUNCTION();					\
 		VMLINUX_SYMBOL(__lock_text_start) = .;			\
+		/* No need to KEEP */					\
 		*(.spinlock.text)					\
 		VMLINUX_SYMBOL(__lock_text_end) = .;
 
 #define KPROBES_TEXT							\
 		ALIGN_FUNCTION();					\
 		VMLINUX_SYMBOL(__kprobes_text_start) = .;		\
+		/* No need to KEEP */					\
 		*(.kprobes.text)					\
 		VMLINUX_SYMBOL(__kprobes_text_end) = .;
 
@@ -228,14 +231,16 @@
 	. = ALIGN(8);							\
 	__bug_table : AT(ADDR(__bug_table) - LOAD_OFFSET) {		\
 		__start___bug_table = .;				\
-		*(__bug_table)						\
+		/* Support for BUG() */					\
+		KEEP(*(__bug_table))					\
 		__stop___bug_table = .;					\
 	}
 
 #define NOTES								\
 	.notes : AT(ADDR(.notes) - LOAD_OFFSET) {			\
 		VMLINUX_SYMBOL(__start_notes) = .;			\
-		*(.note.*)						\
+		/* For /sys/kernel/notes */				\
+		KEEP(*(.note.*))					\
 		VMLINUX_SYMBOL(__stop_notes) = .;			\
 	}
 

--Boundary-00=_1rE6GA8rYQ/087t--
