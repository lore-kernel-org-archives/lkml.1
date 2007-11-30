Return-Path: <linux-kernel-owner+w=401wt.eu-S1756633AbXLFMtu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756633AbXLFMtu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:49:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbXLFMnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:16 -0500
Received: from nic2.axis.se ([193.13.178.10]:35753 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754680AbXLFMnO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:14 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <b58f059cd5ee3abd821af0430b7373523a51da37.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:10:30 +0100
Subject: [PATCH 25/47] Update CRISv10 boot compressed Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old specific targets, use more generic ones instead.
- Use if_changed to avoid creating new images when no change.
- Use EXTRA_CFLAGS instead of CFLAGS.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/boot/compressed/Makefile |   48 ++++++++++----------------
 1 files changed, 19 insertions(+), 29 deletions(-)

diff --git a/arch/cris/arch-v10/boot/compressed/Makefile b/arch/cris/arch-v10/boot/compressed/Makefile
index 6584a44..17ba271 100644
--- a/arch/cris/arch-v10/boot/compressed/Makefile
+++ b/arch/cris/arch-v10/boot/compressed/Makefile
@@ -1,45 +1,35 @@
 #
-# create a compressed vmlinuz image from the binary vmlinux.bin file
+# arch/cris/arch-v10/boot/compressed/Makefile
 #
-target = $(target_compressed_dir)
-src    = $(src_compressed_dir)
 
 CC = gcc-cris -melf $(LINUXINCLUDE)
-CFLAGS = -O2
+EXTRA_CFLAGS = -O2
 LD = ld-cris
+LDFLAGS = -T $(obj)/decompress.ld
+OBJECTS = $(obj)/head.o $(obj)/misc.o
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
-OBJECTS = $(target)/head.o $(target)/misc.o
 
-# files to compress
-SYSTEM = $(objtree)/vmlinux.bin
+quiet_cmd_image = BUILD   $@
+cmd_image = cat $(obj)/decompress.bin $(obj)/piggy.gz > $@
 
-all: $(target_compressed_dir)/vmlinuz
+targets := vmlinux piggy.gz decompress.o decompress.bin
 
-$(target)/decompress.bin: $(OBJECTS)
-	$(LD) -T $(src)/decompress.ld -o $(target)/decompress.o $(OBJECTS)
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/decompress.o $(target)/decompress.bin
+$(obj)/decompress.o: $(OBJECTS) FORCE
+	$(call if_changed,ld)
 
-# Create vmlinuz image in top-level build directory
-$(target_compressed_dir)/vmlinuz: $(target) piggy.img $(target)/decompress.bin
-	@echo "  COMPR   vmlinux.bin --> vmlinuz"
-	@cat $(target)/decompress.bin piggy.img > $(target_compressed_dir)/vmlinuz
-	@rm -f piggy.img
+$(obj)/decompress.bin: $(obj)/decompress.o FORCE
+	$(call if_changed,objcopy)
 
-$(target)/head.o: $(src)/head.S
-	$(CC) -D__ASSEMBLY__ -traditional -c $< -o $@
+$(obj)/head.o: $(obj)/head.S .config
+	@$(CC) -D__ASSEMBLY__ -traditional -c $< -o $@
 
-$(target)/misc.o: $(src)/misc.c
-	$(CC) -D__KERNEL__ -c $< -o $@
+$(obj)/misc.o: $(obj)/misc.c .config
+	@$(CC) -D__KERNEL__ -c $< -o $@
 
-# gzip the kernel image
+$(obj)/vmlinux: $(obj)/piggy.gz $(obj)/decompress.bin FORCE
+	$(call if_changed,image)
 
-piggy.img: $(SYSTEM)
-	@cat $(SYSTEM) | gzip -f -9 > piggy.img
-
-$(target):
-	mkdir -p $(target)
-
-clean:
-	rm -f piggy.img $(objtree)/vmlinuz
+$(obj)/piggy.gz: $(obj)/../Image FORCE
+	$(call if_changed,gzip)
 
-- 
1.5.3.6.970.gd25430

