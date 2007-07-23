Return-Path: <linux-kernel-owner+w=401wt.eu-S934341AbXGWTdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934341AbXGWTdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 15:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762037AbXGWTdX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 15:33:23 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:36996 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759895AbXGWTdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 15:33:22 -0400
Date: Mon, 23 Jul 2007 15:33:11 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 1/3] UML - Fix string exporting on UML/i386
Message-ID: <20070723193311.GA12383@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In 2.6.23-rc1, i386 fiddled its string support such that UML started
getting undefined references from modules.  The UML asm/string.h was
including the i386 string.h, which defined __HAVE_ARCH_STR*, but the
corresponding implementations weren't being pulled in.

This is fixed by adding arch/i386/lib/string.h to the list of host
architecture files to be pulled in to UML.

A complication is that the libc exports file assumed that the generic
strlen and strstr weren't in use (i.e. __HAVE_ARCH_STR is defined),
then they aren't exported.  This is untrue for strlen, which is
exported in either case, so this logic is not needed.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/os-Linux/user_syms.c |    5 +----
 arch/um/sys-i386/Makefile    |    2 +-
 2 files changed, 2 insertions(+), 5 deletions(-)

Index: linux-2.6.17/arch/um/sys-i386/Makefile
===================================================================
--- linux-2.6.17.orig/arch/um/sys-i386/Makefile	2007-07-23 14:58:46.000000000 -0400
+++ linux-2.6.17/arch/um/sys-i386/Makefile	2007-07-23 14:58:56.000000000 -0400
@@ -4,7 +4,7 @@ obj-y = bug.o bugs.o checksum.o delay.o 
 
 obj-$(CONFIG_MODE_SKAS) += stub.o stub_segv.o
 
-subarch-obj-y = lib/bitops.o lib/semaphore.o
+subarch-obj-y = lib/bitops.o lib/semaphore.o lib/string.o
 subarch-obj-$(CONFIG_HIGHMEM) += mm/highmem.o
 subarch-obj-$(CONFIG_MODULES) += kernel/module.o
 
Index: linux-2.6.17/arch/um/os-Linux/user_syms.c
===================================================================
--- linux-2.6.17.orig/arch/um/os-Linux/user_syms.c	2007-07-23 14:58:18.000000000 -0400
+++ linux-2.6.17/arch/um/os-Linux/user_syms.c	2007-07-23 14:59:22.000000000 -0400
@@ -19,10 +19,7 @@ extern void *memmove(void *, const void 
 extern void *memset(void *, int, size_t);
 extern int printf(const char *, ...);
 
-/* If they're not defined, the export is included in lib/string.c.*/
-#ifdef __HAVE_ARCH_STRLEN
-EXPORT_SYMBOL(strlen);
-#endif
+/* If it's not defined, the export is included in lib/string.c.*/
 #ifdef __HAVE_ARCH_STRSTR
 EXPORT_SYMBOL(strstr);
 #endif
