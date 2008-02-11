Return-Path: <linux-kernel-owner+w=401wt.eu-S1756663AbYBKWld@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663AbYBKWld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 17:41:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755414AbYBKWlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 17:41:19 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37264 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758736AbYBKWlR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 17:41:17 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Cc: Kyle McMartin <kyle@mcmartin.ca>
Subject: [PATCH 2.6.25] x86: vdso_install fix
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Lightweight detrimental ingredients
   (2) Braille L'eggs
   (3) Solar-frightened clasps
   (4) Impious Garden Weasels
   (5) Satanic agnostic admonition imports
Message-Id: <20080211223851.AF7B1270191@magilla.localdomain>
Date: Mon, 11 Feb 2008 14:38:51 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The makefile magic for installing the 32-bit vdso images on disk
had a little error.  Only one line of change would fix that bug.
This does a little more to reduce the error-prone duplication of
this bit of makefile variable magic.

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 arch/x86/vdso/Makefile |   22 ++++++++++++----------
 1 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/arch/x86/vdso/Makefile b/arch/x86/vdso/Makefile
index d28dda5..f385a4b 100644
--- a/arch/x86/vdso/Makefile
+++ b/arch/x86/vdso/Makefile
@@ -7,7 +7,7 @@ VDSO32-$(CONFIG_X86_32)		:= y
 VDSO32-$(CONFIG_COMPAT)		:= y
 
 vdso-install-$(VDSO64-y)	+= vdso.so
-vdso-install-$(VDSO32-y)	+= $(vdso32-y:=.so)
+vdso-install-$(VDSO32-y)	+= $(vdso32-images)
 
 
 # files to link into the vdso
@@ -63,6 +63,8 @@ vdso32.so-$(CONFIG_X86_32)	+= int80
 vdso32.so-$(CONFIG_COMPAT)	+= syscall
 vdso32.so-$(VDSO32-y)		+= sysenter
 
+vdso32-images			= $(vdso32.so-y:%=vdso32-%.so)
+
 CPPFLAGS_vdso32.lds = $(CPPFLAGS_vdso.lds)
 VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
 
@@ -71,21 +73,21 @@ VDSO_LDFLAGS_vdso32.lds = -m elf_i386 -Wl,-soname=linux-gate.so.1
 override obj-dirs = $(dir $(obj)) $(obj)/vdso32/
 
 targets += vdso32/vdso32.lds
-targets += $(vdso32.so-y:%=vdso32-%.so.dbg) $(vdso32.so-y:%=vdso32-%.so)
+targets += $(vdso32-images) $(vdso32-images:=.dbg)
 targets += vdso32/note.o $(vdso32.so-y:%=vdso32/%.o)
 
-extra-y	+= $(vdso32.so-y:%=vdso32-%.so)
+extra-y	+= $(vdso32-images)
 
-$(obj)/vdso32.o: $(vdso32.so-y:%=$(obj)/vdso32-%.so)
+$(obj)/vdso32.o: $(vdso32-images:%=$(obj)/%)
 
 KBUILD_AFLAGS_32 := $(filter-out -m64,$(KBUILD_AFLAGS))
-$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
-$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): asflags-$(CONFIG_X86_64) += -m32
+$(vdso32-images:%=$(obj)/%.dbg): KBUILD_AFLAGS = $(KBUILD_AFLAGS_32)
+$(vdso32-images:%=$(obj)/%.dbg): asflags-$(CONFIG_X86_64) += -m32
 
-$(vdso32.so-y:%=$(obj)/vdso32-%.so.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
-					 $(obj)/vdso32/vdso32.lds \
-					 $(obj)/vdso32/note.o \
-					 $(obj)/vdso32/%.o
+$(vdso32-images:%=$(obj)/%.dbg): $(obj)/vdso32-%.so.dbg: FORCE \
+				 $(obj)/vdso32/vdso32.lds \
+				 $(obj)/vdso32/note.o \
+				 $(obj)/vdso32/%.o
 	$(call if_changed,vdso)
 
 # Make vdso32-*-syms.lds from each image, and then make sure they match.
