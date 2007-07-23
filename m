Return-Path: <linux-kernel-owner+w=401wt.eu-S1760299AbXGWGPa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760299AbXGWGPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 02:15:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755521AbXGWGPX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 02:15:23 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755484AbXGWGPV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 02:15:21 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Adrian Bunk <bunk@stusta.de>, David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] Move --build-id option
In-Reply-To: Roland McGrath's message of  Sunday, 22 July 2007 23:01:55 -0700 <20070723060155.2B3824D0489@magilla.localdomain>
X-Fcc: ~/Mail/linus
X-Shopping-List: (1) Envious miscreant warriors
   (2) Trenchant silent exclusions
   (3) Hilarious penny flossbags
   (4) Braille Aspersion expectations
   (5) Insipid ripping-cats
Message-Id: <20070723061446.5DAAC4D0489@magilla.localdomain>
Date: Sun, 22 Jul 2007 23:14:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


My original makefile patch to use ld --build-id wound up using it in too
many places.  We want it only for the .ko and vmlinux links (and vmlinux
temporary links that determine the vmlinux layout).

Signed-off-by: Roland McGrath <roland@redhat.com>
---
 Makefile                 |    8 +++-----
 scripts/Makefile.modpost |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/Makefile b/Makefile
index cd47845..fe6c5dd 100644
--- a/Makefile
+++ b/Makefile
@@ -518,8 +518,6 @@ CFLAGS += $(call cc-option,-Wno-pointer-sign,)
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
 			      $(call ld-option, -Wl$(comma)--build-id,))
-LDFLAGS_MODULE += $(LDFLAGS_BUILD_ID)
-LDFLAGS_vmlinux += $(LDFLAGS_BUILD_ID)
 
 # Default kernel image to build when no specific target is given.
 # KBUILD_IMAGE may be overruled on the command line or
@@ -616,9 +614,9 @@ export KBUILD_VMLINUX_OBJS := $(vmlinux-all)
 # Rule to link vmlinux - also used during CONFIG_KALLSYMS
 # May be overridden by arch/$(ARCH)/Makefile
 quiet_cmd_vmlinux__ ?= LD      $@
-      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_vmlinux) -o $@ \
-      -T $(vmlinux-lds) $(vmlinux-init)                          \
-      --start-group $(vmlinux-main) --end-group                  \
+      cmd_vmlinux__ ?= $(LD) $(LDFLAGS) $(LDFLAGS_BUILD_ID) $(LDFLAGS_vmlinux) \
+      -o $@ -T $(vmlinux-lds) $(vmlinux-init)		\
+      --start-group $(vmlinux-main) --end-group		\
       $(filter-out $(vmlinux-lds) $(vmlinux-init) $(vmlinux-main) vmlinux.o FORCE ,$^)
 
 # Generate new vmlinux version
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index c6fcc59..a86a3b1 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -97,8 +97,8 @@ targets += $(modules:.ko=.mod.o)
 
 # Step 6), final link of the modules
 quiet_cmd_ld_ko_o = LD [M]  $@
-      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_MODULE) -o $@		\
-			  $(filter-out FORCE,$^)
+      cmd_ld_ko_o = $(LD) $(LDFLAGS) $(LDFLAGS_BUILD_ID) $(LDFLAGS_MODULE) \
+      		    	  -o $@ $(filter-out FORCE,$^)
 
 $(modules): %.ko :%.o %.mod.o FORCE
 	$(call if_changed,ld_ko_o)
