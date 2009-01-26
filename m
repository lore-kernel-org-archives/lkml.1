Return-Path: <linux-kernel-owner+w=401wt.eu-S1755116AbZAZXAi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755116AbZAZXAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:00:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751497AbZAZXA2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:00:28 -0500
Received: from rn-out-0910.google.com ([64.233.170.184]:18184 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbZAZXA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:00:26 -0500
Subject: [PATCH] Fix BUG: using smp_processor_id() in preemptible code in
 print_fatal_signal()
From: Ed Swierk <eswierk@aristanetworks.com>
To: rml@tech9.net, linux-kernel@vger.kernel.org,
       kpreempt-tech@lists.sourceforge.net
Content-Type: text/plain
Date: Mon, 26 Jan 2009 15:00:18 -0800
Message-Id: <1233010818.14510.11.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With print-fatal-signals=1 on a kernel with CONFIG_PREEMPT=y, sending an
unexpected signal to a process causes a BUG: using smp_processor_id() in
preemptible code.

get_signal_to_deliver() releases the siglock before calling
print_fatal_signal(), which calls show_regs(), which calls
smp_processor_id(), which is not supposed to be called from a
preemptible thread.

Calling print_fatal_signal() before releasing the siglock avoids this
problem.

Signed-off-by: Ed Swierk <eswierk@aristanetworks.com>

---
Index: linux-2.6.27.4/kernel/signal.c
===================================================================
--- linux-2.6.27.4.orig/kernel/signal.c
+++ linux-2.6.27.4/kernel/signal.c
@@ -1848,6 +1848,11 @@ relock:
 			continue;
 		}
 
+		if (sig_kernel_coredump(signr) && print_fatal_signals) {
+			/* hold lock for smp_processor_id() */
+			print_fatal_signal(regs, info->si_signo);
+		}
+
 		spin_unlock_irq(&sighand->siglock);
 
 		/*
@@ -1856,8 +1861,6 @@ relock:
 		current->flags |= PF_SIGNALED;
 
 		if (sig_kernel_coredump(signr)) {
-			if (print_fatal_signals)
-				print_fatal_signal(regs, info->si_signo);
 			/*
 			 * If it was able to dump core, this kills all
 			 * other threads in the group and synchronizes with


