Return-Path: <linux-kernel-owner+w=401wt.eu-S1763699AbYHEUOn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763699AbYHEUOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 16:14:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763534AbYHEUO2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 16:14:28 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:48069 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763507AbYHEUO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 16:14:27 -0400
Date: Tue, 5 Aug 2008 16:14:10 -0400
From: Jeff Dike <jdike@addtoit.com>
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 12/14] [UML] fix gcc ICEs and unresolved externs
Message-ID: <20080805201410.GA11794@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 4f81c5350b44bcc501ab6f8a089b16d064b4d2f6

There are various constraints on the use of unit-at-a-time:
 - i386 uses no-unit-at-a-time for pre-4.0 (not 4.3)
 - x86_64 uses unit-at-a-time always

Uli reported a crash on x86_64 with gcc 4.1.2 with unit-at-a-time,
resulting in commit c0a18111e571138747a98af18b3a2124df56a0d1

Ingo reported a gcc internal error with gcc 4.3 with no-unit-at-a-timem,
resulting in 22eecde2f9034764a3fd095eecfa3adfb8ec9a98

Benny Halevy is seeing extern inlines not resolved with gcc 4.3 with
no-unit-at-a-time

This patch reintroduces unit-at-a-time for gcc >= 4.0, bringing back the
possibility of Uli's crash.  If that happens, we'll debug it.

I started seeing both the internal compiler errors and unresolved
inlines on Fedora 9.  This patch fixes both problems, without so far
reintroducing the crash reported by Uli.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Cc: Benny Halevy <bhalevy@panasas.com>
Cc: Adrian Bunk <bunk@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ulrich Drepper <drepper@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 arch/um/Makefile        |    1 -
 arch/um/Makefile-i386   |    7 +++++++
 arch/um/Makefile-x86_64 |    3 +++
 3 files changed, 10 insertions(+), 1 deletions(-)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index dbeab15..ca40397 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -77,7 +77,6 @@ include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
 PHONY += linux
 
diff --git a/arch/um/Makefile-i386 b/arch/um/Makefile-i386
index 561e373..302cbe5 100644
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
@@ -32,4 +32,11 @@ cflags-y += $(call cc-option,-mpreferred-stack-boundary=2)
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
diff --git a/arch/um/Makefile-x86_64 b/arch/um/Makefile-x86_64
index 8ed362f..a9cd7e7 100644
--- a/arch/um/Makefile-x86_64
+++ b/arch/um/Makefile-x86_64
@@ -21,3 +21,6 @@ HEADER_ARCH := x86
 
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
 LINK-y += -m64
+
+# Do unit-at-a-time unconditionally on x86_64, following the host
+KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)
-- 
1.5.5.1

