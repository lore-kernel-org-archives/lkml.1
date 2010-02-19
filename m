Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0BSSVU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 13:21:20 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:19124 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0BSSVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 13:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=Zx4uVWqolN56g4yzDXFtrAefD8f6iPORWNpNxqDYApUGH+DBBmefqxx3Bw7F+s/cWe
         knWPdylovJUxK8K1KgCBO4xT32WbzlhsGPv5PafKeb9vBzH1GQWilN9eH5Md9HrHWeWe
         enisfB31lstHNCQD128vwTZZtrrx6YHZxPtUc=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "K . Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Maneesh Soni <maneesh@linux.vnet.ibm.com>,
       Alexandre Julliard <julliard@winehq.org>,
       "Rafael J . Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Roland McGrath <roland@redhat.com>
Subject: [PATCH 2/2] hw-breakpoint: Keep track of dr7 local enable bits
Date: Fri, 19 Feb 2010 19:12:51 +0100
Message-Id: <1266603171-6615-3-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <20100219180435.GB4736@in.ibm.com>
References: <20100219180435.GB4736@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the user enables breakpoints through dr7, he can choose
between "local" or "global" enable bits but given how linux is
implemented, both have the same effect.

That said we don't keep track how the user enabled the breakpoints
so when the user requests the dr7 value, we only translate the
"enabled" status using the global enabled bits. It means that if
the user enabled a breakpoint using the local enabled bit, reading
back dr7 will set the global bit and clear the local one.

Apps like Wine expect a full dr7 POKEUSER/PEEKUSER match for emulated
softwares that implement old reverse engineering protection schemes.

We fix that by keeping track of the whole dr7 value given by the user
in the thread structure to drop this bug. We'll think about
something more proper later.

This fixes a 2.6.32 - 2.6.33-x ptrace regression.

Reported-and-tested-by: Michael Stefaniuc <mstefani@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: K.Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Maneesh Soni <maneesh@linux.vnet.ibm.com>
Cc: Alexandre Julliard <julliard@winehq.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Maciej Rutecki <maciej.rutecki@gmail.com>
---
 arch/x86/include/asm/processor.h |    2 ++
 arch/x86/kernel/ptrace.c         |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index fc801ba..b753ea5 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -450,6 +450,8 @@ struct thread_struct {
 	struct perf_event	*ptrace_bps[HBP_NUM];
 	/* Debug status used for traps, single steps, etc... */
 	unsigned long           debugreg6;
+	/* Keep track of the exact dr7 value set by the user */
+	unsigned long           ptrace_dr7;
 	/* Fault info: */
 	unsigned long		cr2;
 	unsigned long		trap_no;
diff --git a/arch/x86/kernel/ptrace.c b/arch/x86/kernel/ptrace.c
index 017d937..0c1033d 100644
--- a/arch/x86/kernel/ptrace.c
+++ b/arch/x86/kernel/ptrace.c
@@ -702,7 +702,7 @@ static unsigned long ptrace_get_debugreg(struct task_struct *tsk, int n)
 	} else if (n == 6) {
 		val = thread->debugreg6;
 	 } else if (n == 7) {
-		val = ptrace_get_dr7(thread->ptrace_bps);
+		val = thread->ptrace_dr7;
 	}
 	return val;
 }
@@ -778,8 +778,11 @@ int ptrace_set_debugreg(struct task_struct *tsk, int n, unsigned long val)
 			return rc;
 	}
 	/* All that's left is DR7 */
-	if (n == 7)
+	if (n == 7) {
 		rc = ptrace_write_dr7(tsk, val);
+		if (!rc)
+			thread->ptrace_dr7 = val;
+	}
 
 ret_path:
 	return rc;
-- 
1.6.2.3

