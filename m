Return-Path: <linux-kernel-owner+w=401wt.eu-S1760305AbZBLT3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760305AbZBLT3g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 14:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759112AbZBLT3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 14:29:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:35088 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178AbZBLT3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 14:29:24 -0500
Date: Thu, 12 Feb 2009 14:29:22 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       =?ISO-8859-15?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>, wli@holomorphy.com,
       Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [git pull] sched: do not account for NMIs
Message-ID: <alpine.DEB.1.10.0902121422000.15469@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/tracing/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/tracing/core


Steven Rostedt (1):
      sched: do not account for NMIs

----
 include/linux/hardirq.h |   32 ++++++++++++++++----------------
 1 files changed, 16 insertions(+), 16 deletions(-)
---------------------------
commit 2a7b8df04c11a70105c1abe67d006455d3bdc944
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Thu Feb 12 14:16:46 2009 -0500

    sched: do not account for NMIs
    
    Impact: avoid corruption in system time accounting
    
    Martin Schwidefsky told me that there was an issue with NMIs and
    system accounting. The problem is that the accounting code is
    not reentrant, and if an NMI goes off after an interrupt it can
    corrupt the accounting.
    
    For now, the best we can do is to treat NMIs like SMIs and they
    are not accounted for.
    
    This patch changes nmi_enter to not call __irq_enter and to do
    the preempt-count and tracing calls directly.
    
    Signed-off-by: Steven Rostedt <srostedt@redhat.com>

diff --git a/include/linux/hardirq.h b/include/linux/hardirq.h
index 9841221..faa1cf8 100644
--- a/include/linux/hardirq.h
+++ b/include/linux/hardirq.h
@@ -175,24 +175,24 @@ extern void irq_enter(void);
  */
 extern void irq_exit(void);
 
-#define nmi_enter()				\
-	do {					\
-		ftrace_nmi_enter();		\
-		BUG_ON(in_nmi());		\
-		add_preempt_count(NMI_OFFSET);	\
-		lockdep_off();			\
-		rcu_nmi_enter();		\
-		__irq_enter();			\
+#define nmi_enter()						\
+	do {							\
+		ftrace_nmi_enter();				\
+		BUG_ON(in_nmi());				\
+		add_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
+		lockdep_off();					\
+		rcu_nmi_enter();				\
+		trace_hardirq_enter();				\
 	} while (0)
 
-#define nmi_exit()				\
-	do {					\
-		__irq_exit();			\
-		rcu_nmi_exit();			\
-		lockdep_on();			\
-		BUG_ON(!in_nmi());		\
-		sub_preempt_count(NMI_OFFSET);	\
-		ftrace_nmi_exit();		\
+#define nmi_exit()						\
+	do {							\
+		trace_hardirq_exit();				\
+		rcu_nmi_exit();					\
+		lockdep_on();					\
+		BUG_ON(!in_nmi());				\
+		sub_preempt_count(NMI_OFFSET + HARDIRQ_OFFSET);	\
+		ftrace_nmi_exit();				\
 	} while (0)
 
 #endif /* LINUX_HARDIRQ_H */

