Return-Path: <linux-kernel-owner+w=401wt.eu-S1753876AbYHPWhr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbYHPWhr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2008 18:37:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbYHPWhh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Aug 2008 18:37:37 -0400
Received: from ns2.suse.de ([195.135.220.15]:46852 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbYHPWhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2008 18:37:36 -0400
Subject: patch uml-fix-gcc-ices-and-unresolved-externs.patch added to 2.6.25-stable tree
To: jdike@addtoit.com, bhalevy@panasas.com, bunk@kernel.org,
       drepper@redhat.com, gregkh@suse.de, jdike@linux.intel.com,
       linux-kernel@vger.kernel.org, mingo@elte.hu,
       torvalds@linux-foundation.org,
       user-mode-linux-devel@lists.sourceforge.net
Cc: <stable@kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@suse.de>
Date: Sat, 16 Aug 2008 15:32:42 -0700
In-Reply-To: <20080805201410.GA11794@c2.user-mode-linux.org>
Message-Id: <20080816223733.205181454450@imap.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that we have just queued up the patch titled

    Subject: uml: fix gcc ICEs and unresolved externs

to the 2.6.25-stable tree.  Its filename is

    uml-fix-gcc-ices-and-unresolved-externs.patch

A git repo of this tree can be found at 
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary


>From stable-bounces@linux.kernel.org Tue Aug  5 13:14:46 2008
From: Jeff Dike <jdike@addtoit.com>
Date: Tue, 5 Aug 2008 16:14:10 -0400
Subject: uml: fix gcc ICEs and unresolved externs
To: stable@kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Message-ID: <20080805201410.GA11794@c2.user-mode-linux.org>
Content-Disposition: inline

From: Jeff Dike <jdike@addtoit.com>

commit 4f81c5350b44bcc501ab6f8a089b16d064b4d2f6 upstream

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/um/Makefile        |    1 -
 arch/um/Makefile-i386   |    7 +++++++
 arch/um/Makefile-x86_64 |    3 +++
 3 files changed, 10 insertions(+), 1 deletion(-)

--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -77,7 +77,6 @@ include $(srctree)/$(ARCH_DIR)/Makefile-
 KERNEL_DEFINES = $(strip -Derrno=kernel_errno -Dsigprocmask=kernel_sigprocmask \
 			 -Dmktime=kernel_mktime $(ARCH_KERNEL_DEFINES))
 KBUILD_CFLAGS += $(KERNEL_DEFINES)
-KBUILD_CFLAGS += $(call cc-option,-fno-unit-at-a-time,)
 
 PHONY += linux
 
--- a/arch/um/Makefile-i386
+++ b/arch/um/Makefile-i386
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
--- a/arch/um/Makefile-x86_64
+++ b/arch/um/Makefile-x86_64
@@ -21,3 +21,6 @@ HEADER_ARCH := x86
 
 LINK-$(CONFIG_LD_SCRIPT_DYN) += -Wl,-rpath,/lib64
 LINK-y += -m64
+
+# Do unit-at-a-time unconditionally on x86_64, following the host
+KBUILD_CFLAGS += $(call cc-option,-funit-at-a-time)


Patches currently in stable-queue which might be from jdike@addtoit.com are

queue-2.6.25/uml-fix-build-when-slob-is-enabled.patch
queue-2.6.25/uml-fix-bad-ntp-interaction-with-clock.patch
queue-2.6.25/uml-physical-memory-shouldn-t-include-initial-stack.patch
queue-2.6.25/uml-track-and-make-up-lost-ticks.patch
queue-2.6.25/uml-missed-kmalloc-in-pcap_user.c.patch
queue-2.6.25/uml-deal-with-host-time-going-backwards.patch
queue-2.6.25/uml-deal-with-inaccessible-address-space-start.patch
queue-2.6.25/uml-missing-export-of-csum_partial-on-uml-amd64.patch
queue-2.6.25/uml-memcpy-export-needs-to-follow-host-declaration.patch
queue-2.6.25/uml-stub-needs-to-tolerate-sigwinch.patch
queue-2.6.25/uml-work-around-broken-host-ptrace_sysemu.patch
queue-2.6.25/uml-fix-gcc-ices-and-unresolved-externs.patch
queue-2.6.25/uml-fix-boot-crash.patch
