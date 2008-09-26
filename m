Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYIZC5k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYIZC5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 22:57:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753372AbYIZC5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 22:57:31 -0400
Received: from ag-out-0708.google.com ([72.14.246.245]:62582 "EHLO
	ag-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096AbYIZC5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 22:57:30 -0400
Message-Id: <A1326102-87D8-44AE-856F-A7E49D9E5538@anirban.org>
From: Anirban Sinha <kernel@anirban.org>
To: linux-kernel@vger.kernel.org, mingo@elte.hu,
       Oleg Nesterov <oleg@tv-sign.ru>, torvalds@linux-foundation.org
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: [PATCH]: add a new wait_event_interruptible_timeout_modify helper
Date: Thu, 25 Sep 2008 19:57:25 -0700
Cc: kernel@anirban.org
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Index: 2.6-git/include/linux/wait.h
===================================================================
--- 2.6-git.orig/include/linux/wait.h	2008-06-20 21:21:11.000000000  
-0700
+++ 2.6-git/include/linux/wait.h	2008-09-25 19:41:37.000000000 -0700
@@ -335,6 +335,55 @@
  	__ret;								\
  })

+#define __wait_event_interruptible_timeout_modify(wq, condition, ret,  
timeout) \
+do {									\
+	DEFINE_WAIT(__wait);						\
+									\
+	for (;;) {							\
+		prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);	\
+		if (condition)						\
+			break;						\
+		if (!signal_pending(current)) {				\
+			ret = schedule_timeout(ret);			\
+			*(&timeout) = ret;				\
+			if (!ret)					\
+				break;					\
+			continue;					\
+		}							\
+		ret = -ERESTARTSYS;					\
+		break;							\
+	}								\
+	finish_wait(&wq, &__wait);					\
+} while (0)
+
+/**
+ * wait_event_interruptible_timeout_modify - sleep until a condition  
gets true or a timeout elapses.
+ * @wq: the waitqueue to wait on
+ * @condition: a C expression for the event to wait for
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the
+ * @condition evaluates to true or a signal is received.
+ * The @condition is checked each time the waitqueue @wq is woken up.
+ *
+ * wake_up() has to be called after changing any variable that could
+ * change the result of the wait condition.
+ *
+ * The function returns 0 if the @timeout elapsed, -ERESTARTSYS if it
+ * was interrupted by a signal, and the remaining jiffies otherwise
+ * if the condition evaluated to true before the timeout elapsed.
+ * It also modifies the @timeout value so that if the sleep is  
interrupted
+ * by a signal, the caller can call this helper again with the updated
+ * timeout.
+ */
+#define wait_event_interruptible_timeout_modify(wq, condition,  
timeout)	\
+({									\
+	long __ret = timeout;						\
+	if (!(condition))						\
+	  __wait_event_interruptible_timeout_modify(wq, condition, __ret,  
timeout); \
+	__ret;								\
+})
+
  #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
  do {									\
  	DEFINE_WAIT(__wait);						\

