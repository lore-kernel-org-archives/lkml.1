Return-Path: <linux-kernel-owner+w=401wt.eu-S1758334AbYFBIXF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758334AbYFBIXF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2008 04:23:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbYFBIWz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Jun 2008 04:22:55 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbYFBIWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2008 04:22:54 -0400
Date: Mon, 2 Jun 2008 10:22:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Ulrich Drepper <drepper@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       mtk.manpages@gmail.com, torvalds@linux-foundation.org, x86@kernel.org
Subject: Re: [PATCH 3/3] 64-bit futexes: x86 support
Message-ID: <20080602082226.GA2450@elte.hu>
References: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200805310127.m4V1RLdP013819@devserv.devel.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ulrich Drepper <drepper@redhat.com> wrote:

> This patch adds 64-bit futex support for x86.  As explained in the 
> introduction, this requires a new system call.  The remaining changes 
> are similarly to the x86-64 changes: enable support for FUTEX_WAKE_OP.

great work - the first two patches look good and we've created a new 
-tip topic branch for it, tip/core/futex-64bit.

but this 32-bit x86 patch has problems, it needed 3 fixes to even build 
(see below), then it stopped with various failures related to the 
assembly constraints:

  kernel/futex.c: In function 'do_futex':
  include/asm/futex.h:155: error: can't find a register in class 'GENERAL_REGS' while reloading 'asm'
  [...]

	Ingo

-------------------->
Subject: 64 bit futexes: fixes
From: Ingo Molnar <mingo@elte.hu>
Date: Mon Jun 02 10:07:08 CEST 2008

- various build fixes on 32-bit.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/kernel/sys_i386_32.c |    1 +
 include/asm-x86/futex.h       |    4 ++--
 2 files changed, 3 insertions(+), 2 deletions(-)

Index: linux/arch/x86/kernel/sys_i386_32.c
===================================================================
--- linux.orig/arch/x86/kernel/sys_i386_32.c
+++ linux/arch/x86/kernel/sys_i386_32.c
@@ -18,6 +18,7 @@
 #include <linux/file.h>
 #include <linux/utsname.h>
 #include <linux/ipc.h>
+#include <linux/futex.h>
 
 #include <asm/uaccess.h>
 #include <asm/unistd.h>
Index: linux/include/asm-x86/futex.h
===================================================================
--- linux.orig/include/asm-x86/futex.h
+++ linux/include/asm-x86/futex.h
@@ -65,7 +65,7 @@
 		     _ASM_EXTABLE(1b, 5b)			\
 		     _ASM_EXTABLE(2b, 5b)			\
 		     _ASM_EXTABLE(3b, 5b)			\
-		     : "=&a" (oldvaltemp1), "=&d" (oldvaltmep2),\
+		     : "=&a" (oldvaltemp1), "=&d" (oldvaltemp2),\
 		       "=&r" (ret),				\
 		       "+m" (((u32 __user *) uaddr)[0]),	\
 		       "+m" (((u32 __user *) uaddr)[1]),	\
@@ -127,7 +127,7 @@ static inline int futex_atomic_op_inuser
 #ifdef CONFIG_X86_32
 	/* Not all 32-bit machines support 8-byte cmpxchg.  We just
 	   unconditionally perform a runtime check for the feature.  */
-	if ((op & FUTEX_FLAG_64) && !boot_cpu_has(X86_FEATURE_CX8))
+	if ((op & FUTEX_64_FLAG) && !boot_cpu_has(X86_FEATURE_CX8))
 		return -ENOSYS;
 #endif
 
