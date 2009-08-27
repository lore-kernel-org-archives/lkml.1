Return-Path: <linux-kernel-owner+w=401wt.eu-S1752109AbZH0Ro1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752109AbZH0Ro1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 13:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZH0RoZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 13:44:25 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:25378 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZH0Rnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 13:43:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kEhotkEhJ7yPw7OW/scUh0hrwXC3W5/cjJVyGzSHLo/tqIcmUknCYeq9poQqnJgH+w
         V69YMMxn4xgp4kCS7+N+wJxUVzDyHB5SamMACwBgDpQjWuE8gtUZjoQVmNdN5Dsl9Oav
         FbpWNee0A60Frocc29fkjzgPiuoOJyznrWVIs=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Jason Baron <jbaron@redhat.com>,
       Paul Mundt <lethal@linux-sh.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Jiaying Zhang <jiayingz@google.com>, Martin Bligh <mbligh@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Josh Stone <jistone@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anwin" <hpa@zytor.com>,
       Hendrik Brueckner <brueckner@linux.vnet.ibm.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [PATCH 5/7] tracing: Define NR_syscalls for x86_64
Date: Thu, 27 Aug 2009 19:43:33 +0200
Message-Id: <1251395015-6329-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
References: <1251395015-6329-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Baron <jbaron@redhat.com>

Express the available number of syscalls in a standard way by defining
NR_syscalls.

The common way to define it is to place its definition in asm/unistd.h
However, the number of syscalls is defined using __NR_syscall_max in
x86-64 after building a dynamic header file "asm-offsets.h"

The source file that generates this header, asm-offsets-64.c includes
unistd.h, then if we want to express NR_syscalls from __NR_syscall_max
in unistd.h only after generating the dynamic header file, we need a
watchguard.

If unistd.h is included from asm-offsets-64.c, then we are generating
asm-offset.h which defines __NR_syscall_max. At this time, we don't
want to (we can't) define NR_syscalls, then we do nothing.
Otherwise we define NR_syscalls because we know asm-offsets.h has
been generated.

Signed-off-by: Jason Baron <jbaron@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Paul Mundt <lethal@linux-sh.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: Jiaying Zhang <jiayingz@google.com>
Cc: Martin Bligh <mbligh@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Josh Stone <jistone@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: H. Peter Anwin <hpa@zytor.com>
Cc: Hendrik Brueckner <brueckner@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
LKML-Reference: <20090826160910.GB2658@redhat.com>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 arch/x86/include/asm/unistd_64.h |    6 ++++++
 arch/x86/kernel/asm-offsets_64.c |    1 +
 2 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/unistd_64.h b/arch/x86/include/asm/unistd_64.h
index 900e161..b9f3c60 100644
--- a/arch/x86/include/asm/unistd_64.h
+++ b/arch/x86/include/asm/unistd_64.h
@@ -688,6 +688,12 @@ __SYSCALL(__NR_perf_counter_open, sys_perf_counter_open)
 #endif	/* __NO_STUBS */
 
 #ifdef __KERNEL__
+
+#ifndef COMPILE_OFFSETS
+#include <asm/asm-offsets.h>
+#define NR_syscalls (__NR_syscall_max + 1)
+#endif
+
 /*
  * "Conditional" syscalls
  *
diff --git a/arch/x86/kernel/asm-offsets_64.c b/arch/x86/kernel/asm-offsets_64.c
index 898ecc4..4a6aeed 100644
--- a/arch/x86/kernel/asm-offsets_64.c
+++ b/arch/x86/kernel/asm-offsets_64.c
@@ -3,6 +3,7 @@
  * This code generates raw asm output which is post-processed to extract
  * and format the required data.
  */
+#define COMPILE_OFFSETS
 
 #include <linux/crypto.h>
 #include <linux/sched.h> 
-- 
1.6.2.3

