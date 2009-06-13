Return-Path: <linux-kernel-owner+w=401wt.eu-S1757874AbZFMMYR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbZFMMYR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 08:24:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753111AbZFMMYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 08:24:04 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39700 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbZFMMYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 08:24:03 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] FRV: Fix interaction with new generic header stuff
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       David Howells <dhowells@redhat.com>
Date: Sat, 13 Jun 2009 13:23:54 +0100
Message-ID: <20090613122354.24795.88926.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix interaction with new generic header stuff as added by:

	commit 6103ec56c65c33774c7c38652c8204120c3c7519
	Author: Arnd Bergmann <arnd@arndb.de>
	Date:   Wed May 13 22:56:27 2009 +0000

	    asm-generic: add generic ABI headers

The problem is that asm/signal.h has been made to include asm-generic/signal.h,
but the redundant stuff from asm/signal.h has not been discarded, leading to
multiple redefinitions.

Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David Howells <dhowells@redhat.com>
---

 arch/frv/include/asm/signal.h |  123 +----------------------------------------
 1 files changed, 3 insertions(+), 120 deletions(-)


diff --git a/arch/frv/include/asm/signal.h b/arch/frv/include/asm/signal.h
index 2079197..f071e81 100644
--- a/arch/frv/include/asm/signal.h
+++ b/arch/frv/include/asm/signal.h
@@ -3,107 +3,15 @@
 
 #include <linux/types.h>
 
-/* Avoid too many header ordering problems.  */
-struct siginfo;
-
-#ifdef __KERNEL__
-/* Most things should be clean enough to redefine this at will, if care
-   is taken to make libc match.  */
-
-#define _NSIG		64
-#define _NSIG_BPW	32
-#define _NSIG_WORDS	(_NSIG / _NSIG_BPW)
-
-typedef unsigned long old_sigset_t;		/* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-#else
+#ifndef __KERNEL__
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
 #define NSIG		32
 typedef unsigned long sigset_t;
 
-#endif /* __KERNEL__ */
-
-#define SIGHUP		 1
-#define SIGINT		 2
-#define SIGQUIT		 3
-#define SIGILL		 4
-#define SIGTRAP		 5
-#define SIGABRT		 6
-#define SIGIOT		 6
-#define SIGBUS		 7
-#define SIGFPE		 8
-#define SIGKILL		 9
-#define SIGUSR1		10
-#define SIGSEGV		11
-#define SIGUSR2		12
-#define SIGPIPE		13
-#define SIGALRM		14
-#define SIGTERM		15
-#define SIGSTKFLT	16
-#define SIGCHLD		17
-#define SIGCONT		18
-#define SIGSTOP		19
-#define SIGTSTP		20
-#define SIGTTIN		21
-#define SIGTTOU		22
-#define SIGURG		23
-#define SIGXCPU		24
-#define SIGXFSZ		25
-#define SIGVTALRM	26
-#define SIGPROF		27
-#define SIGWINCH	28
-#define SIGIO		29
-#define SIGPOLL		SIGIO
-/*
-#define SIGLOST		29
-*/
-#define SIGPWR		30
-#define SIGSYS		31
-#define	SIGUNUSED	31
-
-/* These should not be considered constants from userland.  */
-#define SIGRTMIN	32
-#define SIGRTMAX	(_NSIG-1)
-
-/*
- * SA_FLAGS values:
- *
- * SA_ONSTACK indicates that a registered stack_t will be used.
- * SA_RESTART flag to get restarting signals (which were the default long ago)
- * SA_NOCLDSTOP flag to turn off SIGCHLD when children stop.
- * SA_RESETHAND clears the handler when the signal is delivered.
- * SA_NOCLDWAIT flag on SIGCHLD to inhibit zombies.
- * SA_NODEFER prevents the current signal from being masked in the handler.
- *
- * SA_ONESHOT and SA_NOMASK are the historical Linux names for the Single
- * Unix names RESETHAND and NODEFER respectively.
- */
-#define SA_NOCLDSTOP	0x00000001
-#define SA_NOCLDWAIT	0x00000002 /* not supported yet */
-#define SA_SIGINFO	0x00000004
-#define SA_ONSTACK	0x08000000
-#define SA_RESTART	0x10000000
-#define SA_NODEFER	0x40000000
-#define SA_RESETHAND	0x80000000
-
-#define SA_NOMASK	SA_NODEFER
-#define SA_ONESHOT	SA_RESETHAND
-
-#define SA_RESTORER	0x04000000
-
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
+#endif /* !__KERNEL__ */
 
-#define MINSIGSTKSZ	2048
-#define SIGSTKSZ	8192
+#define SA_RESTORER	0x04000000 /* to get struct sigaction correct */
 
 #include <asm-generic/signal.h>
 
@@ -115,16 +23,6 @@ struct old_sigaction {
 	__sigrestore_t sa_restorer;
 };
 
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-	__sigrestore_t sa_restorer;
-	sigset_t sa_mask;		/* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
 #else
 /* Here we must cater to libcs that poke about in kernel headers.  */
 
@@ -143,19 +41,4 @@ struct sigaction {
 
 #endif /* __KERNEL__ */
 
-typedef struct sigaltstack {
-	void __user *ss_sp;
-	int ss_flags;
-	size_t ss_size;
-} stack_t;
-
-#define ptrace_signal_deliver(regs, cookie) do { } while (0)
-
-#ifdef __KERNEL__
-
-#include <asm/sigcontext.h>
-#undef __HAVE_ARCH_SIG_BITOPS
-
-#endif /* __KERNEL__ */
-
 #endif /* _ASM_SIGNAL_H */

