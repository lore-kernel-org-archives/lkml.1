Return-Path: <linux-kernel-owner+w=401wt.eu-S1754008AbYIZHLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754008AbYIZHLz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 03:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751890AbYIZHLr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 03:11:47 -0400
Received: from qb-out-0506.google.com ([72.14.204.237]:47335 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbYIZHLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 03:11:46 -0400
Cc: Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Anirban Sinha <kernel@anirban.org>
Message-Id: <248103A6-04E3-4F60-BFE4-2D4D42A91F6E@anirban.org>
From: Anirban Sinha <kernel@anirban.org>
To: linux-kernel@vger.kernel.org
In-Reply-To: <816CA40C-41C0-4CCF-A75B-F67F1A2B0510@anirban.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [PATCH]: correction: add a new wait_event_interruptible_timeout_modify helper
Date: Fri, 26 Sep 2008 00:11:42 -0700
References: <A1326102-87D8-44AE-856F-A7E49D9E5538@anirban.org> <816CA40C-41C0-4CCF-A75B-F67F1A2B0510@anirban.org>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arrghh!!! my bad. corrected patch is pasted below:



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
+			timeout = ret;					\
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
