Return-Path: <linux-kernel-owner+w=401wt.eu-S1757960AbZIFOUe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757960AbZIFOUe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 10:20:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754864AbZIFOUe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 10:20:34 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:43322 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754827AbZIFOUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 10:20:33 -0400
X-Greylist: delayed 736 seconds by postgrey-1.27 at vger.kernel.org; Sun, 06 Sep 2009 10:20:33 EDT
Subject: [PATCH] um: add work around for build problem with bash 4
From: Paul Bolle <pebolle@tiscali.nl>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@karaya.com>, vo.sinh@gmail.com,
       Florian Fainelli <florian@openwrt.org>
Content-Type: text/plain
Date: Sun, 06 Sep 2009 16:08:07 +0200
Message-Id: <1252246087.25757.12.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.91 (2.27.91-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building User Mode Linux fails with bash 4 (see
http://bugzilla.kernel.org/show_bug.cgi?id=13343 ). The UML Makefiles
use an environment variable called CPPFLAGS_vmlinux.lds but bash 4 does
not export environment variables with a dot in their name. Add a hack to
allow building UML with bash 4 (which should not affect other shells).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
Tested-by: Florian Fainelli <florian@openwrt.org>
---
Could this quick hack, which is the simplest work around I could think
of for this issue, be considered for inclusion in v.2.6.31? 

 Makefile        |    6 ++----
 arch/um/kernel/Makefile |    4 ++++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 0728def..dc1ea7d 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -99,9 +99,6 @@ CFLAGS_NO_HARDENING := $(call cc-option, -fno-PIC,) $(call cc-option, -fno-pic,)
 CONFIG_KERNEL_STACK_ORDER ?= 2
 STACK_SIZE := $(shell echo $$[ 4096 * (1 << $(CONFIG_KERNEL_STACK_ORDER)) ] )
 
-CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DSTART=$(START) -DELF_ARCH=$(ELF_ARCH) \
-	-DELF_FORMAT="$(ELF_FORMAT)" -DKERNEL_STACK_SIZE=$(STACK_SIZE)
-
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
@@ -152,4 +149,5 @@ $(SHARED_HEADERS)/kern_constants.h:
 	$(Q)mkdir -p $(dir $@)
 	$(Q)echo '#include "../../../../include/asm/asm-offsets.h"' >$@
 
-export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH
+export SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS HEADER_ARCH DEV_NULL_PATH \
+       ELF_ARCH ELF_FORMAT STACK_SIZE START
diff --git a/arch/um/kernel/Makefile b/arch/um/kernel/Makefile
index 388ec0a..2907436 100644
--- a/arch/um/kernel/Makefile
+++ b/arch/um/kernel/Makefile
@@ -3,6 +3,10 @@
 # Licensed under the GPL
 #
 
+CPPFLAGS_vmlinux.lds = -P -C -U$(ARCH) -U$(SUBARCH) -DSTART=$(START) \
+	-DELF_ARCH=$(ELF_ARCH) -DELF_FORMAT="$(ELF_FORMAT)" \
+	-DKERNEL_STACK_SIZE=$(STACK_SIZE)
+
 extra-y := vmlinux.lds
 clean-files :=
 
-- 
1.6.4.2

