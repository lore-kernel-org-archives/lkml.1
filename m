Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZIJI3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZIJI3j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 04:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755262AbZIJI3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 04:29:37 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:10850 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048AbZIJI3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 04:29:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=O+muENkMXxWT9YPWX7P+m2Rm0Vnmivs3CAq+8A+IzY08qq/sySGBFL5K3BCS0Nt7d4
         mtBbeRQ103wnVh0q9m0z76VyxB4db0g6M/pv8h7cJV2iGL7PiAMHs/2rhMSzYWTMfPiW
         Rd3DNJLmkBOzB1IagrPNakY8XhbBd0y0NcLvo=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Prasad <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       Jan Kiszka <jan.kiszka@siemens.com>, Jiri Slaby <jirislaby@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>, Avi Kivity <avi@redhat.com>,
       Paul Mackerras <paulus@samba.org>, Mike Galbraith <efault@gmx.de>,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: [PATCH 1/5] perf_counter: Add open/close pmu callbacks
Date: Thu, 10 Sep 2009 10:29:23 +0200
Message-Id: <1252571367-25876-2-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.6.2.3
In-Reply-To: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
References: <1252571367-25876-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the open() and close() callback to the pmu structure.
Open is called when a counter is initialized just after it's allocation
and close is called when the counter is about to be released.

These callbacks are useful for example when a pmu has to deal with
several registers and needs to maintain an internal list of counters
using them. Given such list, the pmu is able to check if the the number
of physical registers are still sufficient for the new created counter
and then accept or refuse this counter.

open() will return 0 in case of success or an error if we have not
enough registers for the given counter (or whatever error a pmu may
encounter).

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Prasad <prasad@linux.vnet.ibm.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Jiri Slaby <jirislaby@gmail.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Masami Hiramatsu <mhiramat@redhat.com>
---
 include/linux/perf_counter.h |    3 +++
 kernel/perf_counter.c        |   27 +++++++++++++++++++++------
 2 files changed, 24 insertions(+), 6 deletions(-)

diff --git a/include/linux/perf_counter.h b/include/linux/perf_counter.h
index 9ba1822..f557483 100644
--- a/include/linux/perf_counter.h
+++ b/include/linux/perf_counter.h
@@ -487,6 +487,8 @@ struct pmu {
 	void (*disable)			(struct perf_counter *counter);
 	void (*read)			(struct perf_counter *counter);
 	void (*unthrottle)		(struct perf_counter *counter);
+	int (*open)			(struct perf_counter *counter);
+	void (*close)			(struct perf_counter *counter);
 };
 
 /**
@@ -497,6 +499,7 @@ enum perf_counter_active_state {
 	PERF_COUNTER_STATE_OFF		= -1,
 	PERF_COUNTER_STATE_INACTIVE	=  0,
 	PERF_COUNTER_STATE_ACTIVE	=  1,
+	PERF_COUNTER_STATE_UNOPENED	=  2,
 };
 
 struct file;
diff --git a/kernel/perf_counter.c b/kernel/perf_counter.c
index d7cbc57..400ccf6 100644
--- a/kernel/perf_counter.c
+++ b/kernel/perf_counter.c
@@ -1675,6 +1675,10 @@ static void free_counter(struct perf_counter *counter)
 			atomic_dec(&nr_task_counters);
 	}
 
+	if (counter->pmu->close)
+		if (counter->state != PERF_COUNTER_STATE_UNOPENED)
+			counter->pmu->close(counter);
+
 	if (counter->destroy)
 		counter->destroy(counter);
 
@@ -4101,15 +4105,19 @@ done:
 	else if (IS_ERR(pmu))
 		err = PTR_ERR(pmu);
 
-	if (err) {
-		if (counter->ns)
-			put_pid_ns(counter->ns);
-		kfree(counter);
-		return ERR_PTR(err);
-	}
+	if (err)
+		goto fail;
 
 	counter->pmu = pmu;
 
+	if (pmu->open) {
+		err = pmu->open(counter);
+		if (err) {
+			counter->state = PERF_COUNTER_STATE_UNOPENED;
+			goto fail;
+		}
+	}
+
 	if (!counter->parent) {
 		atomic_inc(&nr_counters);
 		if (counter->attr.mmap)
@@ -4121,6 +4129,13 @@ done:
 	}
 
 	return counter;
+
+fail:
+	if (counter->ns)
+		put_pid_ns(counter->ns);
+	kfree(counter);
+
+	return ERR_PTR(err);
 }
 
 static int perf_copy_attr(struct perf_counter_attr __user *uattr,
-- 
1.6.2.3

