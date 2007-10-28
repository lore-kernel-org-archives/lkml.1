Return-Path: <linux-kernel-owner+w=401wt.eu-S1752780AbXJ1VPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbXJ1VPi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2007 17:15:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750895AbXJ1VPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Oct 2007 17:15:31 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:46477 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750812AbXJ1VPa convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2007 17:15:30 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Aq4HADuYJEdMQWvU/2dsb2JhbACBWo5t
Date: Sun, 28 Oct 2007 17:15:27 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix x86_64 TIF_SYSCALL_TRACE race in entry.S
Message-ID: <20071028211527.GA9129@Krystal>
References: <20071026193738.GA1591@Krystal> <20071027180837.GA18134@Krystal> <p73sl3wnzty.fsf@bingen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <p73sl3wnzty.fsf@bingen.suse.de>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 17:06:02 up 90 days, 21:24,  3 users,  load average: 0.14, 0.30, 0.37
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

* Andi Kleen (andi@firstfloor.org) wrote:
> Mathieu Desnoyers <compudj@krystal.dyndns.org> writes:
> 
> > We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.
> >
> 
> That doesn't make sense. If someone is setting those asynchronously you 
> can always race.
> 

Setting the thread flag being an atomic operation, I would expect
setting/clearing it asynchronously from another thread to be a valid
behavior. The only race that I foresee happens if the code that uses the
thread flag reads it more than once and expects it to stay unchanged
between the reads.

> You should really just stop the process like ptrace does before changing
> such things.
> 

Iterating on each thread running on the system and stopping them when
we start kernel tracing seems to have the same impact as throwing a
brick in a quiet lake. :) I would prefer not to do that if we can do
otherwise.

Here is a modified version where I add my test only in the path where we
know that we have work to do, therefore removing the supplementary test
from the performance critical path. Would it be more acceptable ?



Fix x86_64 TIF_SYSCALL_TRACE race in entry.S

When the flag is inactive upon syscall entry and concurrently activated before
exit, we seem to reach a state where the top of stack is incorrect upon return
to user space.

Fix this by fixing the top of stack and jumping to int_ret_from_sys_call if we
detect that thread flags has been modified.

We make sure that the thread flag read is coherent between our new test and the ALLWORK_MASK test by first saving it in a register used for both comparisons.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <ak@muc.de>
---
 arch/x86_64/kernel/entry.S |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux-2.6-lttng/arch/x86_64/kernel/entry.S
===================================================================
--- linux-2.6-lttng.orig/arch/x86_64/kernel/entry.S	2007-10-27 14:01:12.000000000 -0400
+++ linux-2.6-lttng/arch/x86_64/kernel/entry.S	2007-10-28 16:33:56.000000000 -0400
@@ -267,6 +267,8 @@ sysret_check:		
 	/* Handle reschedules */
 	/* edx:	work, edi: workmask */	
 sysret_careful:
+	testl $(_TIF_SYSCALL_TRACE|_TIF_SYSCALL_AUDIT|_TIF_SECCOMP),%edx
+	jnz ret_from_sys_call_trace
 	bt $TIF_NEED_RESCHED,%edx
 	jnc sysret_signal
 	TRACE_IRQS_ON
@@ -278,6 +280,16 @@ sysret_careful:
 	CFI_ADJUST_CFA_OFFSET -8
 	jmp sysret_check
 
+ret_from_sys_call_trace:
+	TRACE_IRQS_ON
+	sti
+	SAVE_REST
+	FIXUP_TOP_OF_STACK %rdi
+	movq %rsp,%rdi
+	LOAD_ARGS ARGOFFSET  /* reload args from stack in case ptrace changed it */
+	RESTORE_REST
+	jmp int_ret_from_sys_call
+
 	/* Handle a signal */ 
 sysret_signal:
 	TRACE_IRQS_ON


-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
