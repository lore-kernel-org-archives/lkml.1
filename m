Return-Path: <linux-kernel-owner+w=401wt.eu-S932843AbXHWVlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932843AbXHWVlP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 17:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766014AbXHWVik
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 17:38:40 -0400
Received: from saraswathi.solana.com ([198.99.130.12]:55575 "EHLO
	saraswathi.solana.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763954AbXHWVij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 17:38:39 -0400
Date: Thu, 23 Aug 2007 17:38:06 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>,
       Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>,
       Daniel Gryniewicz <dang@gentoo.org>
Subject: [PATCH 1/7] UML - Don't use glibc asm/user.h
Message-ID: <20070823213806.GA9090@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stop including asm/user.h from libc - it seems to be disappearing from
distros.  It's replaced with sys/user.h which defines
user_fpregs_struct and user_fpxregs_struct instead of user_i387_struct
and struct user_fxsr_struct on i386.

As a bonus, on x86_64, I get to dump some stupid typedefs which were
needed in order to get asm/user.h to compile.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
--
 arch/um/sys-i386/user-offsets.c   |    6 +++---
 arch/um/sys-x86_64/user-offsets.c |    9 +--------
 2 files changed, 4 insertions(+), 11 deletions(-)

Index: linux-2.6.22/arch/um/sys-i386/user-offsets.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-i386/user-offsets.c	2007-08-22 09:48:38.000000000 -0400
+++ linux-2.6.22/arch/um/sys-i386/user-offsets.c	2007-08-22 09:48:44.000000000 -0400
@@ -2,9 +2,9 @@
 #include <stddef.h>
 #include <signal.h>
 #include <sys/poll.h>
+#include <sys/user.h>
 #include <sys/mman.h>
 #include <asm/ptrace.h>
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
 	asm volatile("\n->" #sym " %0 " #val : : "i" (val))
@@ -48,8 +48,8 @@ void foo(void)
 	OFFSET(HOST_SC_FP_ST, _fpstate, _st);
 	OFFSET(HOST_SC_FXSR_ENV, _fpstate, _fxsr_env);
 
-	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_i387_struct));
-	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fxsr_struct));
+	DEFINE_LONGS(HOST_FP_SIZE, sizeof(struct user_fpregs_struct));
+	DEFINE_LONGS(HOST_XFP_SIZE, sizeof(struct user_fpxregs_struct));
 
 	DEFINE(HOST_IP, EIP);
 	DEFINE(HOST_SP, UESP);
Index: linux-2.6.22/arch/um/sys-x86_64/user-offsets.c
===================================================================
--- linux-2.6.22.orig/arch/um/sys-x86_64/user-offsets.c	2007-08-22 09:48:38.000000000 -0400
+++ linux-2.6.22/arch/um/sys-x86_64/user-offsets.c	2007-08-22 12:22:33.000000000 -0400
@@ -3,17 +3,10 @@
 #include <signal.h>
 #include <sys/poll.h>
 #include <sys/mman.h>
+#include <sys/user.h>
 #define __FRAME_OFFSETS
 #include <asm/ptrace.h>
 #include <asm/types.h>
-/* For some reason, x86_64 defines u64 and u32 only in <pci/types.h>, which I
- * refuse to include here, even though they're used throughout the headers.
- * These are used in asm/user.h, and that include can't be avoided because of
- * the sizeof(struct user_regs_struct) below.
- */
-typedef __u64 u64;
-typedef __u32 u32;
-#include <asm/user.h>
 
 #define DEFINE(sym, val) \
         asm volatile("\n->" #sym " %0 " #val : : "i" (val))
