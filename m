Return-Path: <linux-kernel-owner+w=401wt.eu-S1757058AbXLFMxx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058AbXLFMxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:53:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754468AbXLFMoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:15 -0500
Received: from miranda.se.axis.com ([193.13.178.8]:53773 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014AbXLFMoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:12 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <eea3e37f0a5deb768e7db740f0dd304583e091fd.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:28:26 +0100
Subject: [PATCH 32/47] Update CRISv32 boot rescue Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old specific targets, use more generic ones instead.
- Use if_changed to avoid creating new images when no change.
- Use EXTRA_CFLAGS instead of CFLAGS.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/boot/rescue/Makefile |   41 ++++++++++++-------------------
 1 files changed, 16 insertions(+), 25 deletions(-)

diff --git a/arch/cris/arch-v32/boot/rescue/Makefile b/arch/cris/arch-v32/boot/rescue/Makefile
index f668a81..43260e7 100644
--- a/arch/cris/arch-v32/boot/rescue/Makefile
+++ b/arch/cris/arch-v32/boot/rescue/Makefile
@@ -1,36 +1,27 @@
 #
-# Makefile for rescue code
+# Makefile for rescue (bootstrap) code
 #
-target = $(target_rescue_dir)
-src    = $(src_rescue_dir)
 
 CC = gcc-cris -mlinux -march=v32 $(LINUXINCLUDE)
-CFLAGS = -O2
+EXTRA_CFLAGS = -O2
+AFLAGS += -I $(TOPDIR)/include/asm/arch/mach/ -I $(TOPDIR)/include/asm/arch
+EXTRA_CFLAGS += -I $(TOPDIR)/include/asm/arch/mach/ -I $(TOPDIR)/include/asm/arch
 LD = gcc-cris -mlinux -march=v32 -nostdlib
+LDFLAGS = -T $(obj)/rescue.ld
+LDPOSTFLAGS = -lgcc
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
+obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o
+OBJECT := $(obj)/head.o
 
-all: $(target)/rescue.bin
+targets := rescue.o rescue.bin
 
-rescue: rescue.bin
-	# do nothing
+quiet_cmd_ldlibgcc = LD      $@
+cmd_ldlibgcc = $(LD) $(LDFLAGS) $(filter-out FORCE,$^) $(LDPOSTFLAGS) -o $@
 
-$(target)/rescue.bin: $(target) $(target)/head.o
-	$(LD) -T $(src)/rescue.ld -o $(target)/rescue.o $(target)/head.o
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/rescue.o $(target)/rescue.bin
-	cp -p $(target)/rescue.bin $(objtree)
+$(obj)/rescue.o: $(OBJECTS) FORCE
+	$(call if_changed,ldlibgcc)
 
-$(target):
-	mkdir -p $(target)
-
-$(target)/head.o: $(src)/head.S
-	$(CC) -D__ASSEMBLY__ -c $< -o $*.o
-
-clean:
-	rm -f $(target)/*.o $(target)/*.bin
-
-fastdep:
-
-modules:
-
-modules-install:
+$(obj)/rescue.bin: $(obj)/rescue.o FORCE
+	$(call if_changed,objcopy)
+	cp -p $(obj)/rescue.bin $(objtree)
-- 
1.5.3.6.970.gd25430

