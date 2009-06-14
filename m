Return-Path: <linux-kernel-owner+w=401wt.eu-S1761091AbZFNMEw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761091AbZFNMEw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 08:04:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758571AbZFNMBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 08:01:41 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:52688 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758737AbZFNMBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 08:01:39 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 13/17] Blackfin: convert signal/mmap to asm-generic
Date: Sun, 14 Jun 2009 08:01:14 -0400
Message-Id: <1244980878-2124-14-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
References: <1244980878-2124-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/include/asm/mman.h   |   44 +----------
 arch/blackfin/include/asm/signal.h |  159 +-----------------------------------
 2 files changed, 4 insertions(+), 199 deletions(-)

diff --git a/arch/blackfin/include/asm/mman.h b/arch/blackfin/include/asm/mman.h
index b58f5ad..8eebf89 100644
--- a/arch/blackfin/include/asm/mman.h
+++ b/arch/blackfin/include/asm/mman.h
@@ -1,43 +1 @@
-#ifndef __BFIN_MMAN_H__
-#define __BFIN_MMAN_H__
-
-#define PROT_READ	0x1	/* page can be read */
-#define PROT_WRITE	0x2	/* page can be written */
-#define PROT_EXEC	0x4	/* page can be executed */
-#define PROT_SEM	0x8	/* page may be used for atomic ops */
-#define PROT_NONE	0x0	/* page can not be accessed */
-#define PROT_GROWSDOWN	0x01000000	/* mprotect flag: extend change to start of growsdown vma */
-#define PROT_GROWSUP	0x02000000	/* mprotect flag: extend change to end of growsup vma */
-
-#define MAP_SHARED	0x01	/* Share changes */
-#define MAP_PRIVATE	0x02	/* Changes are private */
-#define MAP_TYPE	0x0f	/* Mask for type of mapping */
-#define MAP_FIXED	0x10	/* Interpret addr exactly */
-#define MAP_ANONYMOUS	0x20	/* don't use a file */
-
-#define MAP_GROWSDOWN	0x0100	/* stack-like segment */
-#define MAP_DENYWRITE	0x0800	/* ETXTBSY */
-#define MAP_EXECUTABLE	0x1000	/* mark it as an executable */
-#define MAP_LOCKED	0x2000	/* pages are locked */
-#define MAP_NORESERVE	0x4000	/* don't check for reservations */
-#define MAP_POPULATE	0x8000	/* populate (prefault) pagetables */
-#define MAP_NONBLOCK	0x10000	/* do not block on IO */
-
-#define MS_ASYNC	1	/* sync memory asynchronously */
-#define MS_INVALIDATE	2	/* invalidate the caches */
-#define MS_SYNC		4	/* synchronous memory sync */
-
-#define MCL_CURRENT	1	/* lock all current mappings */
-#define MCL_FUTURE	2	/* lock all future mappings */
-
-#define MADV_NORMAL	0x0	/* default page-in behavior */
-#define MADV_RANDOM	0x1	/* page-in minimum required */
-#define MADV_SEQUENTIAL	0x2	/* read-ahead aggressively */
-#define MADV_WILLNEED	0x3	/* pre-fault pages */
-#define MADV_DONTNEED	0x4	/* discard these pages */
-
-/* compatibility flags */
-#define MAP_ANON	MAP_ANONYMOUS
-#define MAP_FILE	0
-
-#endif				/* __BFIN_MMAN_H__ */
+#include <asm-generic/mman.h>
diff --git a/arch/blackfin/include/asm/signal.h b/arch/blackfin/include/asm/signal.h
index 2eea907..77a3bf3 100644
--- a/arch/blackfin/include/asm/signal.h
+++ b/arch/blackfin/include/asm/signal.h
@@ -1,160 +1,7 @@
 #ifndef _BLACKFIN_SIGNAL_H
 #define _BLACKFIN_SIGNAL_H
 
-#include <linux/types.h>
+#define SA_RESTORER 0x04000000
+#include <asm-generic/signal.h>
 
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
-typedef unsigned long old_sigset_t;	/* at least 32 bits */
-
-typedef struct {
-	unsigned long sig[_NSIG_WORDS];
-} sigset_t;
-
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-#define NSIG		32
-typedef unsigned long sigset_t;
-
-#endif				/* __KERNEL__ */
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
-#define SIGRTMAX	_NSIG
-
-/*
- * SA_FLAGS values:
- *
- * SA_ONSTACK indicates that a registered stack_t will be used.
- * SA_INTERRUPT is a no-op, but left due to historical reasons. Use the
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
-#define SA_NOCLDWAIT	0x00000002	/* not supported yet */
-#define SA_SIGINFO	0x00000004
-#define SA_ONSTACK	0x08000000
-#define SA_RESTART	0x10000000
-#define SA_NODEFER	0x40000000
-#define SA_RESETHAND	0x80000000
-
-#define SA_NOMASK	SA_NODEFER
-#define SA_ONESHOT	SA_RESETHAND
-
-/*
- * sigaltstack controls
- */
-#define SS_ONSTACK	1
-#define SS_DISABLE	2
-
-#define MINSIGSTKSZ	2048
-#define SIGSTKSZ	8192
-
-#include <asm-generic/signal-defs.h>
-
-#ifdef __KERNEL__
-struct old_sigaction {
-	__sighandler_t sa_handler;
-	old_sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer) (void);
-};
-
-struct sigaction {
-	__sighandler_t sa_handler;
-	unsigned long sa_flags;
-	void (*sa_restorer) (void);
-	sigset_t sa_mask;	/* mask last for extensibility */
-};
-
-struct k_sigaction {
-	struct sigaction sa;
-};
-#else
-/* Here we must cater to libcs that poke about in kernel headers.  */
-
-struct sigaction {
-	union {
-		__sighandler_t _sa_handler;
-		void (*_sa_sigaction) (int, struct siginfo *, void *);
-	} _u;
-	sigset_t sa_mask;
-	unsigned long sa_flags;
-	void (*sa_restorer) (void);
-};
-
-#define sa_handler	_u._sa_handler
-#define sa_sigaction	_u._sa_sigaction
-
-#endif				/* __KERNEL__ */
-
-typedef struct sigaltstack {
-	void __user *ss_sp;
-	int ss_flags;
-	size_t ss_size;
-} stack_t;
-
-#ifdef __KERNEL__
-
-#include <asm/sigcontext.h>
-#undef __HAVE_ARCH_SIG_BITOPS
-
-#define ptrace_signal_deliver(regs, cookie) do { } while (0)
-
-#endif				/* __KERNEL__ */
-
-#endif				/* _BLACKFIN_SIGNAL_H */
+#endif
-- 
1.6.3.1

