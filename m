Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbZLKF3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbZLKF3k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 00:29:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZLKF3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 00:29:39 -0500
Received: from kroah.org ([198.145.64.141]:53425 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751365AbZLKF3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 00:29:38 -0500
X-Mailbox-Line: From linux@linux.site Thu Dec 10 21:25:40 2009
Message-Id: <20091211052540.442199443@linux.site>
User-Agent: quilt/0.47-14.9
Date: Thu, 10 Dec 2009 21:23:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
       Oleg Nesterov <oleg@redhat.com>, Roland McGrath <roland@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>, Thomas Gleixner <tglx@linutronix.de>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [01/34] signal: Fix alternate signal stack check
References: <20091211052312.805428372@linux.site>
Content-Disposition: inline; filename=signal-fix-alternate-signal-stack-check.patch
In-Reply-To: <20091211052858.GA23229@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>

commit 2a855dd01bc1539111adb7233f587c5c468732ac upstream.

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
LKML-Reference: <20091025143758.GA6653@Chamillionaire.breakpoint.cc>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/sched.h |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2086,11 +2086,18 @@ static inline int is_si_special(const st
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


