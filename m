Return-Path: <linux-kernel-owner+w=401wt.eu-S1752090AbZJTEeV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbZJTEeV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Oct 2009 00:34:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750795AbZJTEeU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Oct 2009 00:34:20 -0400
Received: from icculus.org ([67.106.77.212]:51069 "EHLO icculus.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZJTEeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Oct 2009 00:34:20 -0400
Date: Tue, 20 Oct 2009 00:34:09 -0400 (EDT)
From: "Ryan C. Gordon" <icculus@icculus.org>
X-X-Sender: icculus@andre.icculuslan
To: Andreas Schwab <schwab@redhat.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] binfmt_elf: Reorder objects in Makefile to favor platform
 default.
In-Reply-To: <m3r5szfizl.fsf@hase.home>
Message-ID: <alpine.DEB.2.00.0910192223350.18342@andre.icculuslan>
References: <alpine.DEB.2.00.0910190415430.13303@andre.icculuslan> <m3r5szfizl.fsf@hase.home>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Perhaps this should be configurable.  For a 64-bit arch with mostly
> 32-bit userspace the compat format should probably be tried first.

How about this, then?


>From 22b6f98fb51bf68df09b7feb4ee8fbce6e02d01c Mon Sep 17 00:00:00 2001
From: Ryan C. Gordon <icculus@icculus.org>
Date: Tue, 20 Oct 2009 00:32:04 -0400
Subject: [PATCH] binfmt_elf: Reordered object list so compat_binfmt_elf optionally comes first.

This will make it call register_binfmt() first, inserting it at the end of
the list.

Now the kernel will try the compatibility formats as a backup if the actual
system format rejects the binary. As almost all binaries loaded won't be
compatibility formats, this saves a few cycles for each process.

For scenarios where favoring compatibility binaries makes sense, this can
be chosen via the configuration.

Signed-off-by: Ryan C. Gordon <icculus@icculus.org>
---
 fs/Kconfig.binfmt |   14 ++++++++++++++
 fs/Makefile       |    7 +++++++
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index bb4cc5b..b296ab6 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -27,6 +27,20 @@ config COMPAT_BINFMT_ELF
 	bool
 	depends on COMPAT && BINFMT_ELF
 
+config FAVOR_COMPAT_BINFMT_ELF
+	bool "Favor compatibility ELF binaries"
+	depends on COMPAT_BINFMT_ELF
+	default n
+	---help---
+	  Favor "compatibility" ELF binaries. The system will work either way,
+	  but you can save a few cycles per process by choosing the type of
+	  binary you expect to be loading most of the time. This scenario 
+	  makes sense if you have a 64-bit kernel to manage 4+ gigabytes of
+	  physical RAM but want to run mostly 32-bit processes to conserve
+	  that RAM.
+
+	  If unsure, say N.
+
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y
diff --git a/fs/Makefile b/fs/Makefile
index af6d047..36ad1c7 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -40,8 +40,15 @@ obj-$(CONFIG_BINFMT_MISC)	+= binfmt_misc.o
 # binfmt_script is always there
 obj-y				+= binfmt_script.o
 
+# binfmts are registered in order listed here. First registered, last tried!
+ifeq ($(CONFIG_FAVOR_COMPAT_BINFMT_ELF),y)
 obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
 obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
+else
+obj-$(CONFIG_COMPAT_BINFMT_ELF)	+= compat_binfmt_elf.o
+obj-$(CONFIG_BINFMT_ELF)	+= binfmt_elf.o
+endif
+
 obj-$(CONFIG_BINFMT_ELF_FDPIC)	+= binfmt_elf_fdpic.o
 obj-$(CONFIG_BINFMT_SOM)	+= binfmt_som.o
 obj-$(CONFIG_BINFMT_FLAT)	+= binfmt_flat.o
-- 
1.6.0.4

