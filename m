Return-Path: <linux-kernel-owner+w=401wt.eu-S1754527AbXLFMwz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbXLFMwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:52:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754962AbXLFMoG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:44:06 -0500
Received: from nic2.axis.se ([193.13.178.10]:35781 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754958AbXLFMoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:44:04 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <c0f5b9a7dd293b9eb502cf76f97e33f255ca2c9e.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:25:46 +0100
Subject: [PATCH 31/47] Update CRISv32 boot compressed Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old specific targets, use more generic ones instead.
- Use if_changed to avoid creating new images when no change.
- Use KBUILD_CFLAGS instead of CFLAGS.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v32/boot/compressed/Makefile |   47 ++++++++++----------------
 1 files changed, 18 insertions(+), 29 deletions(-)

diff --git a/arch/cris/arch-v32/boot/compressed/Makefile b/arch/cris/arch-v32/boot/compressed/Makefile
index 9f77eda..b9e6b23 100644
--- a/arch/cris/arch-v32/boot/compressed/Makefile
+++ b/arch/cris/arch-v32/boot/compressed/Makefile
@@ -1,41 +1,30 @@
 #
-# lx25/arch/cris/arch-v32/boot/compressed/Makefile
+# arch/cris/arch-v32/boot/compressed/Makefile
 #
-# create a compressed vmlinux image from the original vmlinux files and romfs
-#
-
-target = $(target_compressed_dir)
-src    = $(src_compressed_dir)
 
-CC = gcc-cris -mlinux -march=v32 -I $(TOPDIR)/include
-CFLAGS = -O2
+CC = gcc-cris -mlinux -march=v32 -I $(srctree)/include
+AFLAGS += -I $(srctree)/include/asm/mach/ -I $(srctree)/include/asm/arch
+KBUILD_CFLAGS += -O2 -I $(srctree)/include/asm/mach/ -I $(srctree)/include/asm/arch
 LD = gcc-cris -mlinux -march=v32 -nostdlib
+LDFLAGS = -T $(obj)/decompress.ld
+obj-y = head.o misc.o
+OBJECTS = $(obj)/head.o $(obj)/misc.o
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
-OBJECTS = $(target)/head.o $(target)/misc.o
-
-# files to compress
-SYSTEM = $(objtree)/vmlinux.bin
-
-all: vmlinuz
-
-$(target)/decompress.bin: $(OBJECTS)
-	$(LD) -T $(src)/decompress.ld -o $(target)/decompress.o $(OBJECTS)
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/decompress.o $(target)/decompress.bin
 
-$(objtree)/vmlinuz: $(target) piggy.img $(target)/decompress.bin
-	cat $(target)/decompress.bin piggy.img > $(objtree)/vmlinuz
-	rm -f piggy.img
-	cp $(objtree)/vmlinuz $(src)
+quiet_cmd_image = BUILD   $@
+cmd_image = cat $(obj)/decompress.bin $(obj)/piggy.gz > $@
 
-$(target)/head.o: $(src)/head.S
-	$(CC) -D__ASSEMBLY__ -c $< -o $@
+targets := vmlinux piggy.gz decompress.o decompress.bin
 
-# gzip the kernel image
+$(obj)/decompress.o: $(OBJECTS) FORCE
+	$(call if_changed,ld)
 
-piggy.img: $(SYSTEM)
-	cat $(SYSTEM) | gzip -f -9 > piggy.img
+$(obj)/decompress.bin: $(obj)/decompress.o FORCE
+	$(call if_changed,objcopy)
 
-clean:
-	rm -f piggy.img $(objtree)/vmlinuz vmlinuz.o decompress.o decompress.bin $(OBJECTS)
+$(obj)/vmlinux: $(obj)/piggy.gz $(obj)/decompress.bin FORCE
+	$(call if_changed,image)
 
+$(obj)/piggy.gz: $(obj)/../Image FORCE
+	$(call if_changed,gzip)
-- 
1.5.3.6.970.gd25430

