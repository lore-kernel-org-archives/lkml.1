Return-Path: <linux-kernel-owner+w=401wt.eu-S1762114AbXE1NaA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762114AbXE1NaA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:30:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755670AbXE1N3w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:29:52 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:35782 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753104AbXE1N3v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:29:51 -0400
Message-id: <1365159682097121268@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 6/8] Char: rtc, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <a.zummo@towertech.it>
Date: Mon, 28 May 2007 15:29:50 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

rtc, use wait_event_interruptible

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 62bd843054a7b2b2a3e3003a6b57b6359f199837
tree 7c6912d4ed42581ca46d384ab2467bfb9d9d9dbe
parent 2b7813d0f34703e0a4b18593a3186bdc7e719c06
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:58:54 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:58:54 +0200

 drivers/char/rtc.c |   40 +++++++++++++++-------------------------
 1 files changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 20380a2..787b520 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -353,33 +353,26 @@ static ssize_t rtc_read(struct file *file, char __user *buf,
 	if (count != sizeof(unsigned int) && count !=  sizeof(unsigned long))
 		return -EINVAL;
 
-	add_wait_queue(&rtc_wait, &wait);
-
-	do {
-		/* First make it right. Then make it fast. Putting this whole
-		 * block within the parentheses of a while would be too
-		 * confusing. And no, xchg() is not the answer. */
-
-		__set_current_state(TASK_INTERRUPTIBLE);
-		
-		spin_lock_irq (&rtc_lock);
-		data = rtc_irq_data;
-		rtc_irq_data = 0;
-		spin_unlock_irq (&rtc_lock);
-
-		if (data != 0)
-			break;
+	spin_lock_irq (&rtc_lock);
+	data = rtc_irq_data;
+	rtc_irq_data = 0;
+	spin_unlock_irq (&rtc_lock);
 
+	if (data == 0) {
 		if (file->f_flags & O_NONBLOCK) {
 			retval = -EAGAIN;
 			goto out;
 		}
-		if (signal_pending(current)) {
-			retval = -ERESTARTSYS;
+		retval = wait_event_interruptible(rtc_wait, ({
+			spin_lock_irq (&rtc_lock);
+			data = rtc_irq_data;
+			rtc_irq_data = 0;
+			spin_unlock_irq (&rtc_lock);
+			data;
+		}));
+		if (retval)
 			goto out;
-		}
-		schedule();
-	} while (1);
+	}
 
 	if (count == sizeof(unsigned int))
 		retval = put_user(data, (unsigned int __user *)buf) ?: sizeof(int);
@@ -387,10 +380,7 @@ static ssize_t rtc_read(struct file *file, char __user *buf,
 		retval = put_user(data, (unsigned long __user *)buf) ?: sizeof(long);
 	if (!retval)
 		retval = count;
- out:
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&rtc_wait, &wait);
-
+out:
 	return retval;
 #endif
 }
