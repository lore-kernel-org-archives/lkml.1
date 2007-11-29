Return-Path: <linux-kernel-owner+w=401wt.eu-S1762609AbXK2Qso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762609AbXK2Qso (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 11:48:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756750AbXK2Qse
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 11:48:34 -0500
Received: from saraswathi.solana.com ([198.99.130.12]:48152 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756234AbXK2Qsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 11:48:33 -0500
Date: Thu, 29 Nov 2007 11:48:21 -0500
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 2/3] UML - Fix command-line CFLAGS and LDFLAGS support
Message-ID: <20071129164821.GA7284@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ 2.6.25 material ]

UML still needed some work in order to allow CFLAGS to be passed in
from the command line.

USER_CFLAGS is produced from KBUILD_CFLAGS in part by removing all the
-I switches.  This is so that kernel headers don't accidentally get
pulled into libc files.  However, a common use of command-line CFLAGS
would be to add -I switches to the build.  This patch specifically
adds any command-line -I flags back to USER_CFLAGS.

I also corrected the spelling of LFLAGS to LDFLAGS.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Makefile |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.22/arch/um/Makefile
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile	2007-11-14 12:58:04.000000000 -0500
+++ linux-2.6.22/arch/um/Makefile	2007-11-18 11:10:02.000000000 -0500
@@ -49,7 +49,7 @@ SYS_DIR		:= $(ARCH_DIR)/include/sysdep-$
 #
 # These apply to USER_CFLAGS to.
 
-KBUILD_CFLAGS += $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\"	\
+KBUILD_CFLAGS += $(CFLAGS) $(CFLAGS-y) -D__arch_um__ -DSUBARCH=\"$(SUBARCH)\" \
 	$(ARCH_INCLUDE) $(MODE_INCLUDE) -Dvmap=kernel_vmap	\
 	-Din6addr_loopback=kernel_in6addr_loopback \
 	-Din6addr_any=kernel_in6addr_any
@@ -58,7 +58,7 @@ KBUILD_AFLAGS += $(ARCH_INCLUDE)
 
 USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
 	$(patsubst -I%,,$(KBUILD_CFLAGS)))) $(ARCH_INCLUDE) $(MODE_INCLUDE) \
-	-D_FILE_OFFSET_BITS=64
+	$(filter -I%,$(CFLAGS)) -D_FILE_OFFSET_BITS=64
 
 include $(srctree)/$(ARCH_DIR)/Makefile-$(SUBARCH)
 
@@ -130,7 +130,7 @@ CPPFLAGS_vmlinux.lds = -U$(SUBARCH) -DST
 # The wrappers will select whether using "malloc" or the kernel allocator.
 LINK_WRAPS = -Wl,--wrap,malloc -Wl,--wrap,free -Wl,--wrap,calloc
 
-LD_FLAGS_CMDLINE = $(foreach opt,$(LFLAGS),-Wl,$(opt))
+LD_FLAGS_CMDLINE = $(foreach opt,$(LDFLAGS),-Wl,$(opt))
 
 CFLAGS_vmlinux := $(LINK-y) $(LINK_WRAPS) $(LD_FLAGS_CMDLINE)
 define cmd_vmlinux__
