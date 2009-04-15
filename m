Return-Path: <linux-kernel-owner+w=401wt.eu-S1756305AbZDODVY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305AbZDODVY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 23:21:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752428AbZDODVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 23:21:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59338 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751496AbZDODVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 23:21:13 -0400
Message-ID: <49E55218.1020208@cn.fujitsu.com>
Date: Wed, 15 Apr 2009 11:18:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] sched: Introduce APIs for waiting multi events
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Impact: make kernel has APIs for waiting multi events

Based on code in the RCU, the simple waiting-multi-events
algorithm may do not serve RCU only.

Introduce 5 APIs for waiting multi events

start scheduling events:  ref_completion_get_init()
schedule one event:       ref_completion_get()
end scheduling events:    ref_completion_put_init()

any event is finished:    ref_completion_put()

waiting scheduled events: ref_completion_wait()

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/include/linux/completion.h b/include/linux/completion.h
index 4a6b604..86c8236 100644
--- a/include/linux/completion.h
+++ b/include/linux/completion.h
@@ -8,6 +8,7 @@
  * See kernel/sched.c for details.
  */
 
+#include <asm/atomic.h>
 #include <linux/wait.h>
 
 /**
@@ -98,5 +99,44 @@ extern void complete_all(struct completion *);
  */
 #define INIT_COMPLETION(x)	((x).done = 0)
 
+/*
+ * wait all references are put, or wait multi events finished in other words
+ * ref_completion_get_init() called before the struct is used or reused.
+ * ref_completion_put_init() called after all ref_completion_get()s called.
+ * ref_completion_wait()     waiting until all ref_completion_put()s and
+ *                           the ref_completion_put_init() are called.
+ */
+struct ref_completion {
+	atomic_t ref;
+	struct completion wait;
+};
+
+static inline void ref_completion_get_init(struct ref_completion *rc)
+{
+	atomic_set(&rc->ref, 1);
+	init_completion(&rc->wait);
+}
+
+static inline void ref_completion_get(struct ref_completion *rc)
+{
+	atomic_inc(&rc->ref);
+}
+
+static inline void ref_completion_put(struct ref_completion *rc)
+{
+	if (atomic_dec_and_test(&rc->ref))
+		complete_all(&rc->wait);
+}
+
+static inline void ref_completion_put_init(struct ref_completion *rc)
+{
+	if (atomic_dec_and_test(&rc->ref))
+		complete_all(&rc->wait);
+}
+
+static inline void ref_completion_wait(struct ref_completion *rc)
+{
+	wait_for_completion(&rc->wait);
+}
 
 #endif


