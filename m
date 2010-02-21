Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178Ab0BUOKh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 09:10:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:10303 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034Ab0BUOKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 09:10:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:mime-version
         :content-type:content-transfer-encoding;
        b=eotNPSwrfqFNl0tBaEQk3SGk1lYmHGwWlL+QCb81xmeWANfl1L+fYUzv8GWhDGVupw
         LwFLXwvgfdfgRuomWutHs+TCKPLkXagsjpTH8215BRkgdtEYfl1AQupZYtox0ejrnUf4
         jKb0D9EUKaqBwjRxsPk+NNR5Ir08hR1dVvlUE=
From: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       dri-devel@lists.sourceforge.net
Cc: =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>
Subject: [PATCH][RFC] time: add wait_interruptible_timeout macro to sleep (w. timeout) until wake_up
Date: Sun, 21 Feb 2010 15:10:22 +0100
Message-Id: <1266761422-2921-1-git-send-email-zajec5@gmail.com>
X-Mailer: git-send-email 1.6.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
---
We try to implement some PM in radeon KMS and we need to sync with VLBANK for
reclocking engine/memory. The easiest and cleanest way seems to be sleeping in
timer handler just before reclocking. Then our IRQ handler calls wake_up and we
continue reclocking.

As you see our sleeping is condition-less, we just wait for waking up queue.

We hope this waking will happen from IRQ handler, but for less-happy case we
also use some timeout (this will probably cause some single corruption, but
we can live with it).

Following macro is soemthing that seems to work fine for us, but instead
introducing this to radeon KMS only, I'd like to propose adding this to whole
wait.h. Do you this it's something we should place there? Can someone take this
patch for me? Or maybe you find this rather useless and we should keep this
marco locally?
---
 include/linux/wait.h |   25 +++++++++++++++++++++++++
 1 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/include/linux/wait.h b/include/linux/wait.h
index a48e16b..998475b 100644
--- a/include/linux/wait.h
+++ b/include/linux/wait.h
@@ -332,6 +332,31 @@ do {									\
 	__ret;								\
 })
 
+/**
+ * wait_interruptible_timeout - sleep until a waitqueue is woken up
+ * @wq: the waitqueue to wait on
+ * @timeout: timeout, in jiffies
+ *
+ * The process is put to sleep (TASK_INTERRUPTIBLE) until the waitqueue
+ * @wq is woken up. It can be done manually with wake_up or will happen
+ * if timeout elapses.
+ *
+ * The function returns 0 if the @timeout elapsed, remaining jiffies
+ * if workqueue was waken up earlier.
+ */
+#define wait_interruptible_timeout(wq, timeout)				\
+({									\
+	long __ret = timeout;						\
+									\
+	DEFINE_WAIT(__wait);						\
+	prepare_to_wait(&wq, &__wait, TASK_INTERRUPTIBLE);		\
+	if (!signal_pending(current))					\
+		__ret = schedule_timeout(__ret);			\
+	finish_wait(&wq, &__wait);					\
+									\
+	__ret;								\
+})
+
 #define __wait_event_interruptible_exclusive(wq, condition, ret)	\
 do {									\
 	DEFINE_WAIT(__wait);						\
-- 
1.6.4.2

