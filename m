Return-Path: <linux-kernel-owner+w=401wt.eu-S1753985AbYJ1KQI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbYJ1KQI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 06:16:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753812AbYJ1KPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 06:15:42 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:32798 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753788AbYJ1KPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 06:15:41 -0400
Date: Tue, 28 Oct 2008 11:14:58 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <srostedt@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] lockdep: fix irqs on/off ip tracing
Message-ID: <20081028101458.GA4964@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

81d68a96 "ftrace: trace irq disabled critical timings" added wrappers around
trace_hardirqs_on/off_caller. However these functions use
__builtin_return_address(0) to figure out which function actually disabled
or enabled irqs. The result is that we save the ips of trace_hardirqs_on/off
instead of the real caller. Not very helpful.
However since the patch from Steven the ip already gets passed. So use that
and get rid of __builtin_return_address(0) in these two functions.

Cc: Steven Rostedt <srostedt@redhat.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 kernel/lockdep.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

Index: linux-2.6/kernel/lockdep.c
===================================================================
--- linux-2.6.orig/kernel/lockdep.c
+++ linux-2.6/kernel/lockdep.c
@@ -2169,12 +2169,11 @@ void early_boot_irqs_on(void)
 /*
  * Hardirqs will be enabled:
  */
-void trace_hardirqs_on_caller(unsigned long a0)
+void trace_hardirqs_on_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
-	unsigned long ip;
 
-	time_hardirqs_on(CALLER_ADDR0, a0);
+	time_hardirqs_on(CALLER_ADDR0, ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
@@ -2188,7 +2187,6 @@ void trace_hardirqs_on_caller(unsigned l
 	}
 	/* we'll do an OFF -> ON transition: */
 	curr->hardirqs_enabled = 1;
-	ip = (unsigned long) __builtin_return_address(0);
 
 	if (DEBUG_LOCKS_WARN_ON(!irqs_disabled()))
 		return;
@@ -2224,11 +2222,11 @@ EXPORT_SYMBOL(trace_hardirqs_on);
 /*
  * Hardirqs were disabled:
  */
-void trace_hardirqs_off_caller(unsigned long a0)
+void trace_hardirqs_off_caller(unsigned long ip)
 {
 	struct task_struct *curr = current;
 
-	time_hardirqs_off(CALLER_ADDR0, a0);
+	time_hardirqs_off(CALLER_ADDR0, ip);
 
 	if (unlikely(!debug_locks || current->lockdep_recursion))
 		return;
@@ -2241,7 +2239,7 @@ void trace_hardirqs_off_caller(unsigned 
 		 * We have done an ON -> OFF transition:
 		 */
 		curr->hardirqs_enabled = 0;
-		curr->hardirq_disable_ip = _RET_IP_;
+		curr->hardirq_disable_ip = ip;
 		curr->hardirq_disable_event = ++curr->irq_events;
 		debug_atomic_inc(&hardirqs_off_events);
 	} else
