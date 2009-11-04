Return-Path: <linux-kernel-owner+w=401wt.eu-S1753174AbZKDR3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbZKDR3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 12:29:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbZKDR3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 12:29:13 -0500
Received: from hera.kernel.org ([140.211.167.34]:43575 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZKDR3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 12:29:12 -0500
Date: Wed, 4 Nov 2009 17:27:40 GMT
From: tip-bot for Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       kyle@mcmartin.ca, roland@redhat.com, tglx@linutronix.de,
       sebastian@breakpoint.cc, oleg@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       kyle@mcmartin.ca, roland@redhat.com, tglx@linutronix.de,
       sebastian@breakpoint.cc, oleg@redhat.com
In-Reply-To: <20091025143758.GA6653@Chamillionaire.breakpoint.cc>
References: <20091025143758.GA6653@Chamillionaire.breakpoint.cc>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/signal] signal: Fix alternate signal stack check
Message-ID: <tip-2a855dd01bc1539111adb7233f587c5c468732ac@git.kernel.org>
Git-Commit-ID: 2a855dd01bc1539111adb7233f587c5c468732ac
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2a855dd01bc1539111adb7233f587c5c468732ac
Gitweb:     http://git.kernel.org/tip/2a855dd01bc1539111adb7233f587c5c468732ac
Author:     Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
AuthorDate: Sun, 25 Oct 2009 15:37:58 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 4 Nov 2009 18:19:12 +0100

signal: Fix alternate signal stack check

All architectures in the kernel increment/decrement the stack pointer
before storing values on the stack.

On architectures which have the stack grow down sas_ss_sp == sp is not
on the alternate signal stack while sas_ss_sp + sas_ss_size == sp is
on the alternate signal stack.

On architectures which have the stack grow up sas_ss_sp == sp is on
the alternate signal stack while sas_ss_sp + sas_ss_size == sp is not
on the alternate signal stack.

The current implementation fails for architectures which have the
stack grow down on the corner case where sas_ss_sp == sp.This was
reported as Debian bug #544905 on AMD64.
Simplified test case: http://download.breakpoint.cc/tc-sig-stack.c

The test case creates the following stack scenario:
   0xn0300	stack top
   0xn0200	alt stack pointer top (when switching to alt stack)
   0xn01ff	alt stack end
   0xn0100	alt stack start == stack pointer

If the signal is sent the stack pointer is pointing to the base
address of the alt stack and the kernel erroneously decides that it
has already switched to the alternate stack because of the current
check for "sp - sas_ss_sp < sas_ss_size"

On parisc (stack grows up) the scenario would be:
   0xn0200	stack pointer
   0xn01ff	alt stack end
   0xn0100	alt stack start = alt stack pointer base
   		    	  	  (when switching to alt stack)
   0xn0000	stack base

This is handled correctly by the current implementation.

[ tglx: Modified for archs which have the stack grow up (parisc) which
  	would fail with the correct implementation for stack grows
  	down. Added a check for sp >= current->sas_ss_sp which is
  	strictly not necessary but makes the code symetric for both
  	variants ]

Signed-off-by: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>
Cc: stable@kernel.org
LKML-Reference: <20091025143758.GA6653@Chamillionaire.breakpoint.cc>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/sched.h |   13 ++++++++++---
 1 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 75e6e60..0f67914 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2086,11 +2086,18 @@ static inline int is_si_special(const struct siginfo *info)
 	return info <= SEND_SIG_FORCED;
 }
 
-/* True if we are on the alternate signal stack.  */
-
+/*
+ * True if we are on the alternate signal stack.
+ */
 static inline int on_sig_stack(unsigned long sp)
 {
-	return (sp - current->sas_ss_sp < current->sas_ss_size);
+#ifdef CONFIG_STACK_GROWSUP
+	return sp >= current->sas_ss_sp &&
+		sp - current->sas_ss_sp < current->sas_ss_size;
+#else
+	return sp > current->sas_ss_sp &&
+		sp - current->sas_ss_sp <= current->sas_ss_size;
+#endif
 }
 
 static inline int sas_ss_flags(unsigned long sp)
