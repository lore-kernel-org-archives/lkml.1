Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbXHEPfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbXHEPfa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 11:35:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbXHEPfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 11:35:23 -0400
Received: from ms-smtp-04.nyroc.rr.com ([24.24.2.58]:57351 "EHLO
	ms-smtp-04.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447AbXHEPfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 11:35:22 -0400
Subject: [PATCH RT] put in a relatively high number for rcu read lock upper
	limit.
From: Steven Rostedt <rostedt@goodmis.org>
To: paulmck@linux.vnet.ibm.com
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       RT <linux-rt-users@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070805150449.GA19418@linux.vnet.ibm.com>
References: <1186289484.636.5.camel@localhost.localdomain>
	 <1186290332.636.8.camel@localhost.localdomain>
	 <20070805065948.GB515@elte.hu>
	 <Pine.LNX.4.58.0708051019560.8421@gandalf.stny.rr.com>
	 <20070805150449.GA19418@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Sun, 05 Aug 2007 11:35:00 -0400
Message-Id: <1186328100.636.19.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Paul and Ingo,

Should we just remove the upper limit check, or is something like this
patch sound?

-- Steve

When DEBUG_KERNEL is set, place an upper bound limit on the rcu read
lock set to 100. If we go that deep, then a warn on will print.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-2.6.23-rc1-rt7/kernel/rcupreempt.c
===================================================================
--- linux-2.6.23-rc1-rt7.orig/kernel/rcupreempt.c	2007-08-05 11:25:38.000000000 -0400
+++ linux-2.6.23-rc1-rt7/kernel/rcupreempt.c	2007-08-05 11:30:33.000000000 -0400
@@ -50,6 +50,14 @@
 #include <linux/cpumask.h>
 #include <linux/rcupreempt_trace.h>
 
+#ifdef CONFIG_DEBUG_KERNEL
+/* Picking 100 as a high enough limit on rcu read lock nesting. */
+# define rcu_read_lock_check_upper_limit() \
+		WARN_ON_ONCE(current->rcu_read_lock_nesting > 100);
+#else
+# define rcu_read_lock_check_upper_limit() do { } while(0)
+#endif
+
 /*
  * PREEMPT_RCU data structures.
  */
@@ -129,9 +137,9 @@ void __rcu_read_lock(void)
 			atomic_inc(current->rcu_flipctr2);
 			smp_mb__after_atomic_inc();  /* might optimize out... */
 		}
-	} else {
-		WARN_ON_ONCE(current->rcu_read_lock_nesting > NR_CPUS);
-	}
+	} else
+		rcu_read_lock_check_upper_limit();
+
 	local_irq_restore(oldirq);
 }
 


