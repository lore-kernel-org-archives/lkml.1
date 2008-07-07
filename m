Return-Path: <linux-kernel-owner+w=401wt.eu-S1756603AbYGGRik@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756603AbYGGRik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 13:38:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753969AbYGGRib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 13:38:31 -0400
Received: from [198.99.130.12] ([198.99.130.12]:56433 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbYGGRia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 13:38:30 -0400
Date: Mon, 7 Jul 2008 13:36:56 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Cc: Benny Halevy <bhalevy@panasas.com>, Adrian Bunk <bunk@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Ulrich Drepper <drepper@redhat.com>
Subject: [PATCH] UML - fix gcc ICEs and unresolved externs
Message-ID: <20080707173656.GB7747@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ This patch needs to get into 2.6.26 ]

There are various constraints on the use of unit-at-a-time:
        i386 uses no-unit-at-a-time for pre-4.0 (not 4.3)
        x86_64 uses unit-at-a-time always

        Uli reported a crash on x86_64 with gcc 4.1.2 with
unit-at-a-time, resulting in commit c0a18111e571138747a98af18b3a2124df56a0d1
        Ingo reported a gcc internal error with gcc 4.3 with
no-unit-at-a-timem, resulting in 22eecde2f9034764a3fd095eecfa3adfb8ec9a98
         Benny Halevy <bhalevy@panasas.com> is seeing extern inlines
not resolved with gcc 4.3 with no-unit-at-a-time

This patch reintroduces unit-at-a-time for gcc >= 4.0, bringing back
the possibility of Uli's crash.  If that happens, we'll debug it.

I started seeing both the internal compiler errors and unresolved
inlines on Fedora 9.  This patch fixes both problems, without so far
reintroducing the crash reported by Uli.
	
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/Makefile        |    1 -
 arch/um/Makefile-i386   |    7 +++++++
 arch/um/Makefile-x86_64 |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

Index: linux-2.6.22/arch/um/Makefile-i386
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile-i386	2008-05-29 11:21:25.000000000 -0400
+++ linux-2.6.22/arch/um/Makefile-i386	2008-07-07 13:11:10.000000000 -0400
@@ -32,4 +32,11 @@ cflags-y += $(call cc-option,-mpreferred
 # an unresolved reference.
 cflags-y += -ffreestanding
 
+# Disable unit-at-a-time mode on pre-gcc-4.0 compilers, it makes gcc use
+# a lot more stack due to the lack of sharing of stacklots.  Also, gcc
+# 4.3.0 needs -funit-at-a-time for extern inline functions.
+KBUILD_CFLAGS += $(shell if [ $(call cc-version) -lt 0400 ] ; then \
+			echo $(call cc-option,-fno-unit-at-a-time); \
+			else echo $(call cc-option,-funit-at-a-time); fi ;)
+
 KBUILD_CFLAGS += $(cflags-y)
Index: linux-2.6.22/arch/um/Makefile-x86_64
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile-x86_64	2008-05-29 11:21:25.000000000 -0400
+++ linux-2.6.22/arch/um/Makefile-x86_64	2008-06-30 12:21:01.000000000 -0400
@@ -21,3 +21,6 @@ HEADER_ARCH := x86
 
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
 LINK-y += -m64
+
+# Do unit-at-a-time unconditionally on x86_64, following the host
+KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
Index: linux-2.6.22/arch/um/Makefile
===================================================================
--- linux-2.6.22.orig/arch/um/Makefile	2008-06-10 11:35:40.000000000 -0400
+++ linux-2.6.22/arch/um/Makefile	2008-07-07 12:54:13.000000000 -0400
@@ -77,7 +77,6 @@ include $(srctree)/$(ARCH_DIR)/Makefile-
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
 PHONY += linux
 
