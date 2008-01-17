Return-Path: <linux-kernel-owner+w=401wt.eu-S1755707AbYAQPo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707AbYAQPo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 10:44:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752227AbYAQPoT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 10:44:19 -0500
Received: from free-electrons.com ([88.191.23.47]:55308 "EHLO
	sd-2511.dedibox.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557AbYAQPoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 10:44:18 -0500
From: Michael Opdenacker <michael-lists@free-electrons.com>
Organization: Free Electrons
To: linux-kernel@vger.kernel.org, Linux-tiny@selenic.com
Subject: [PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c compiling
Date: Thu, 17 Jan 2008 16:43:48 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801171643.49301.michael-lists@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH] x86: fix unconditional arch/x86/kernel/pcspeaker.c compiling

Applies to 2.6.24-rc8-git1

This patch results from Linux Tiny's efforts to hunt for unnecessary
code added unconditionally with "obj-y +="

This patch make the compilation of arch/x86/kernel/pcspeaker.c
depend on PC speaker support. Before that, this file was always
compiled even if pc speaker support wasn't enabled.

I'm checking that CONFIG_INPUT_PCSPKR is not set to "m",
as arch/x86/kernel/pcspeaker.c shouldn't be compiled as a module:
- It defines no init and exit functions
- It defines an initcall which only makes sense at
  kernel boot time.

Results: if PC speaker support is disabled
- It reduces the uncompressed kernel size by 218 bytes!!! ;)
- It must also bring a tiny reduction in boot time
  but suppressing a useless initcall.

Your comments?

---
Signed-off-by: Michael Opdenacker <michael@free-electrons.com>

diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32
--- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_32	2008-01-17 09:48:58.000000000 +0100
+++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_32	2008-01-17 10:06:56.000000000 +0100
@@ -45,10 +45,13 @@
 
 obj-$(CONFIG_VMI)		+= vmi_32.o vmiclock_32.o
 obj-$(CONFIG_PARAVIRT)		+= paravirt_32.o
-obj-y				+= pcspeaker.o
-
 obj-$(CONFIG_SCx200)		+= scx200_32.o
 
+ifeq ($(CONFIG_INPUT_PCSPKR),y)
+	obj-y			+= pcspeaker.o
+endif
+
+
 # vsyscall_32.o contains the vsyscall DSO images as __initdata.
 # We must build both images before we can assemble it.
 # Note: kbuild does not track this dependency due to usage of .incbin
diff -Naur linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_64 linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_64
--- linux-2.6.24-rc8-git1/arch/x86/kernel/Makefile_64	2008-01-17 09:48:58.000000000 +0100
+++ linux-2.6.24-rc8-git1-nopcspeaker/arch/x86/kernel/Makefile_64	2008-01-17 10:19:08.000000000 +0100
@@ -40,6 +40,9 @@
 obj-$(CONFIG_PCI)		+= early-quirks.o
 
 obj-y				+= topology.o
-obj-y				+= pcspeaker.o
+
+ifeq ($(CONFIG_INPUT_PCSPKR),y)
+        obj-y                   += pcspeaker.o
+endif
 
 CFLAGS_vsyscall_64.o		:= $(PROFILING) -g0

-- 
Michael Opdenacker, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)
