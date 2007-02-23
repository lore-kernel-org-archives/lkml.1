Return-Path: <linux-kernel-owner+w=401wt.eu-S1752125AbXBWBuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbXBWBuc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 20:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752126AbXBWBuc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 20:50:32 -0500
Received: from mga09.intel.com ([134.134.136.24]:22420 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbXBWBub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 20:50:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: i="4.14,208,1170662400"; 
   d="scan'208"; a="49745297:sNHT332553834"
From: =?iso-8859-1?q?I=F1aky_P=E9rez-Gonz=E1lez?= 
	<inaky.perez-gonzalez@intel.com>
To: linux-kernel@vger.kernel.org
Subject: RFC/patch: down_timeout_interruptible()
Date: Thu, 22 Feb 2007 17:54:30 -0800
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702221754.31165.inaky.perez-gonzalez@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi All

I was in a situation where I could really simplify many things by
using down_interruptible() with a timeout. I went around looking for
how could one be implemented and ran away from the asm code in arch/.

At the end I realized I could make a simple one by setting up a timer
that would 'fake' a sigpending situation (setting the task's TIF_SIGPENDING
bit) so that the __down_interruptible_failed() path would quit when 
the timer went off.

I gave it a quick try (must admit, not too tested) and it seems that
the setting of TIF_SIGPENDING without really having a signal queued
is not having easily visible ugly consequences.

Does anybody have suggestions on how to alternatively implement this?

Thanks,

-- Inaky


 include/asm-i386/semaphore.h |    3 ++
 lib/semaphore-sleepers.c     |   51 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+)

diff -r 9ed3c4dc013f include/asm-i386/semaphore.h
--- a/include/asm-i386/semaphore.h	Wed Feb 21 13:02:17 2007 -0800
+++ b/include/asm-i386/semaphore.h	Thu Feb 22 17:09:13 2007 -0800
@@ -88,6 +88,9 @@ fastcall int  __down_failed_interruptibl
 fastcall int  __down_failed_interruptible(void  /* params in registers */);
 fastcall int  __down_failed_trylock(void  /* params in registers */);
 fastcall void __up_wakeup(void /* special register calling convention */);
+/* FIXME: need to add to other header files */
+extern void down_timeout_interruptible(struct semaphore *);
+
 
 /*
  * This is ugly, but we want the default case to fall through.
diff -r 9ed3c4dc013f lib/semaphore-sleepers.c
--- a/lib/semaphore-sleepers.c	Wed Feb 21 13:02:17 2007 -0800
+++ b/lib/semaphore-sleepers.c	Thu Feb 22 16:52:54 2007 -0800
@@ -174,3 +174,54 @@ fastcall int __down_trylock(struct semap
 	spin_unlock_irqrestore(&sem->wait.lock, flags);
 	return 1;
 }
+
+
+struct dit_data 
+{
+	struct task_struct *task;
+	int result;
+};
+
+/**
+ * dit_kick_process - set a fake 'signal pending' and kick
+ *
+ * Helper for down_interruptible_timeout(). Sets the signal pending
+ * flag on the task that is waiting for a semaphore and kicks it. That
+ * tells the down_interruptible() code to quit waiting.
+ */
+static 
+void dit_kick_process(unsigned long _data)
+{
+	struct dit_data *data = (void *) _data;
+	set_tsk_thread_flag(data->task, TIF_SIGPENDING);
+	data->result = -ETIMEDOUT;
+	kick_process(data->task);
+}
+
+
+/*
+ * Interruptible try to acquire a semaphore.  If we obtained
+ * it, return zero.  If we were interrupted, returns -EINTR. If we
+ * timedout, we return -ETIMEDOUT;
+ *
+ * Note the ugly hack, using a helper timer and function to wake up
+ * the waiter. We need to distinguish, if we get an error, if it was
+ * because we were woken up (-ETIMEDOUT) or for other reason (-EINTR),
+ * hence the last if block.
+ */
+int down_interruptible_timeout(struct semaphore *sem, unsigned long to) 
+{
+	int result;
+	struct dit_data data = {
+		.task = get_current(), .result = 0 
+	};
+	DEFINE_TIMER(dit_timer, dit_kick_process, to, (unsigned long) &data);
+	add_timer(&dit_timer);
+	result = down_interruptible(sem);
+	del_timer(&dit_timer);
+	if (result < 0 && data.result < 0)
+		result = data.result;
+	return result;
+}
+
+
