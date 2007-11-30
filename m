Return-Path: <linux-kernel-owner+w=401wt.eu-S1756379AbXLFMuS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379AbXLFMuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 07:50:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbXLFMnj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 07:43:39 -0500
Received: from nic2.axis.se ([193.13.178.10]:35761 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753720AbXLFMni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 07:43:38 -0500
From: Jesper Nilsson <jesper.nilsson@axis.com>
Message-Id: <4911fbeadd55833fac9f9431324d40f72bf44cc4.1196848533.git.jesper.nilsson@axis.com>
In-Reply-To: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
References: <ca13018bb45763422de40e6109171637091a312e.1196848533.git.jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org,
       sam@ravnborg.org
Date: Fri, 30 Nov 2007 16:11:38 +0100
Subject: [PATCH 26/47] Update CRISv10 rescue Kbuild makefile.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Remove old specific targets, use more generic ones instead.
- Use if_changed to avoid creating new images when no change.
  Removes a lot of cruft.
- Use EXTRA_CFLAGS instead of CFLAGS.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>
---
 arch/cris/arch-v10/boot/rescue/Makefile |   56 ++++++++++--------------------
 1 files changed, 19 insertions(+), 37 deletions(-)

diff --git a/arch/cris/arch-v10/boot/rescue/Makefile b/arch/cris/arch-v10/boot/rescue/Makefile
index 8be9b31..911c894 100644
--- a/arch/cris/arch-v10/boot/rescue/Makefile
+++ b/arch/cris/arch-v10/boot/rescue/Makefile
@@ -1,56 +1,38 @@
 #
-# Makefile for rescue code
+# Makefile for rescue (bootstrap) code
 #
-target = $(target_rescue_dir)
-src    = $(src_rescue_dir)
 
 CC = gcc-cris -mlinux $(LINUXINCLUDE)
-CFLAGS = -O2
+EXTRA_CFLAGS = -O2
+AFLAGS = -traditional
 LD = gcc-cris -mlinux -nostdlib
+LDFLAGS = -T $(obj)/rescue.ld
 OBJCOPY = objcopy-cris
 OBJCOPYFLAGS = -O binary --remove-section=.bss
+obj-$(CONFIG_ETRAX_AXISFLASHMAP) = head.o
+OBJECT := $(obj)/head.o
 
-all: $(target)/rescue.bin $(target)/testrescue.bin $(target)/kimagerescue.bin
+targets := rescue.o rescue.bin
 
-$(target)/rescue.bin: $(target) $(target)/head.o
-	$(LD) -T $(src)/rescue.ld -o $(target)/rescue.o $(target)/head.o
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/rescue.o $(target)/rescue.bin
-# Place a copy in top-level build directory
-	cp -p $(target)/rescue.bin $(objtree)
+$(obj)/rescue.o: $(OBJECT) FORCE
+	$(call if_changed,ld)
 
-$(target)/testrescue.bin: $(target) $(target)/testrescue.o
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/testrescue.o tr.bin
+$(obj)/rescue.bin: $(obj)/rescue.o FORCE
+	$(call if_changed,objcopy)
+	cp -p $(obj)/rescue.bin $(objtree)
+
+$(obj)/testrescue.bin: $(obj)/testrescue.o
+	$(OBJCOPY) $(OBJCOPYFLAGS) $(obj)/testrescue.o tr.bin
 # Pad it to 784 bytes
 	dd if=/dev/zero of=tmp2423 bs=1 count=784
 	cat tr.bin tmp2423 >testrescue_tmp.bin
-	dd if=testrescue_tmp.bin of=$(target)/testrescue.bin bs=1 count=784
+	dd if=testrescue_tmp.bin of=$(obj)/testrescue.bin bs=1 count=784
 	rm tr.bin tmp2423 testrescue_tmp.bin
 
-$(target)/kimagerescue.bin: $(target) $(target)/kimagerescue.o
-	$(OBJCOPY) $(OBJCOPYFLAGS) $(target)/kimagerescue.o ktr.bin
+$(obj)/kimagerescue.bin: $(obj)/kimagerescue.o
+	$(OBJCOPY) $(OBJCOPYFLAGS) $(obj)/kimagerescue.o ktr.bin
 # Pad it to 784 bytes, that's what the rescue loader expects
 	dd if=/dev/zero of=tmp2423 bs=1 count=784
 	cat ktr.bin tmp2423 >kimagerescue_tmp.bin
-	dd if=kimagerescue_tmp.bin of=$(target)/kimagerescue.bin bs=1 count=784
+	dd if=kimagerescue_tmp.bin of=$(obj)/kimagerescue.bin bs=1 count=784
 	rm ktr.bin tmp2423 kimagerescue_tmp.bin
-
-$(target):
-	mkdir -p $(target)
-
-$(target)/head.o: $(src)/head.S
-	$(CC) -D__ASSEMBLY__ -traditional -c $< -o $*.o
-
-$(target)/testrescue.o: $(src)/testrescue.S
-	$(CC) -D__ASSEMBLY__ -traditional -c $< -o $*.o
-
-$(target)/kimagerescue.o: $(src)/kimagerescue.S
-	$(CC) -D__ASSEMBLY__ -traditional -c $< -o $*.o
-
-clean:
-	rm -f $(target)/*.o $(target)/*.bin
-
-fastdep:
-
-modules:
-
-modules-install:
-- 
1.5.3.6.970.gd25430

