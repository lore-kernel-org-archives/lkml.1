Return-Path: <linux-kernel-owner+w=401wt.eu-S1755506AbZCMKhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506AbZCMKhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 06:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752353AbZCMKhT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 06:37:19 -0400
Received: from hera.kernel.org ([140.211.167.34]:36937 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZCMKhS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 06:37:18 -0400
Date: Fri, 13 Mar 2009 10:36:27 GMT
From: Ingo Molnar <mingo@elte.hu>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <49B91A7E.76E4.0078.0@novell.com>
References: <49B91A7E.76E4.0078.0@novell.com>
Subject: [tip:core/ipi] generic-ipi: eliminate WARN_ON()s during oops/panic
Message-ID: <tip-641cd4cfcdc71ce01535b31cc4d57d59a1fae1fc@git.kernel.org>
Git-Commit-ID: 641cd4cfcdc71ce01535b31cc4d57d59a1fae1fc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 10:36:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  641cd4cfcdc71ce01535b31cc4d57d59a1fae1fc
Gitweb:     http://git.kernel.org/tip/641cd4cfcdc71ce01535b31cc4d57d59a1fae1fc
Author:     Ingo Molnar <mingo@elte.hu>
AuthorDate: Fri, 13 Mar 2009 10:47:34 +0100
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 10:47:34 +0100

generic-ipi: eliminate WARN_ON()s during oops/panic

Do not output smp-call related warnings in the oops/panic codepath.

Reported-by: Jan Beulich <jbeulich@novell.com>
Acked-by: Peter Zijlstra <peterz@infradead.org>
LKML-Reference: <49B91A7E.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 kernel/smp.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/smp.c b/kernel/smp.c
index 7ad2262..858baac 100644
--- a/kernel/smp.c
+++ b/kernel/smp.c
@@ -5,6 +5,7 @@
  */
 #include <linux/rcupdate.h>
 #include <linux/rculist.h>
+#include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/percpu.h>
 #include <linux/init.h>
@@ -285,7 +286,7 @@ int smp_call_function_single(int cpu, void (*func) (void *info), void *info,
 	this_cpu = get_cpu();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
 
 	if (cpu == this_cpu) {
 		local_irq_save(flags);
@@ -329,7 +330,7 @@ void __smp_call_function_single(int cpu, struct call_single_data *data,
 	csd_lock(data);
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(wait && irqs_disabled());
+	WARN_ON_ONCE(wait && irqs_disabled() && !oops_in_progress);
 
 	generic_exec_single(cpu, data, wait);
 }
@@ -365,7 +366,7 @@ void smp_call_function_many(const struct cpumask *mask,
 	int cpu, next_cpu, this_cpu = smp_processor_id();
 
 	/* Can deadlock when called with interrupts disabled */
-	WARN_ON(irqs_disabled());
+	WARN_ON_ONCE(irqs_disabled() && !oops_in_progress);
 
 	/* So, what's a CPU they want? Ignoring this one. */
 	cpu = cpumask_first_and(mask, cpu_online_mask);
