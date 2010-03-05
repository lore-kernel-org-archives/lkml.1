Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0CEXDe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:03:34 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52702 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755358Ab0CEXDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:03:32 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org
Subject: [PATCH tip/core/rcu 3/3] x86/mce: fix RCU lockdep splats
Date: Fri,  5 Mar 2010 15:03:27 -0800
Message-Id: <1267830207-9474-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100305230256.GA9410@linux.vnet.ibm.com>
References: <20100305230256.GA9410@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an rcu_dereference_check_mce() that checks for RCU-sched read
side and mce_read_mutex being held on update side.  Replace uses
of rcu_dereference() in arch/x86/kernel/cpu/mcheck/mce.c with this
new macro.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 arch/x86/kernel/cpu/mcheck/mce.c |   11 ++++++++---
 1 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/cpu/mcheck/mce.c b/arch/x86/kernel/cpu/mcheck/mce.c
index a8aacd4..4442e9e 100644
--- a/arch/x86/kernel/cpu/mcheck/mce.c
+++ b/arch/x86/kernel/cpu/mcheck/mce.c
@@ -46,6 +46,11 @@
 
 #include "mce-internal.h"
 
+#define rcu_dereference_check_mce(p) \
+	rcu_dereference_check((p), \
+			      rcu_read_lock_sched_held() || \
+			      lockdep_is_held(&mce_read_mutex))
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
@@ -158,7 +163,7 @@ void mce_log(struct mce *mce)
 	mce->finished = 0;
 	wmb();
 	for (;;) {
-		entry = rcu_dereference(mcelog.next);
+		entry = rcu_dereference_check_mce(mcelog.next);
 		for (;;) {
 			/*
 			 * When the buffer fills up discard new entries.
@@ -1500,7 +1505,7 @@ static ssize_t mce_read(struct file *filp, char __user *ubuf, size_t usize,
 		return -ENOMEM;
 
 	mutex_lock(&mce_read_mutex);
-	next = rcu_dereference(mcelog.next);
+	next = rcu_dereference_check_mce(mcelog.next);
 
 	/* Only supports full reads right now */
 	if (*off != 0 || usize < MCE_LOG_LEN*sizeof(struct mce)) {
@@ -1565,7 +1570,7 @@ timeout:
 static unsigned int mce_poll(struct file *file, poll_table *wait)
 {
 	poll_wait(file, &mce_wait, wait);
-	if (rcu_dereference(mcelog.next))
+	if (rcu_dereference_check_mce(mcelog.next))
 		return POLLIN | POLLRDNORM;
 	return 0;
 }
-- 
1.6.6

