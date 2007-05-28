Return-Path: <linux-kernel-owner+w=401wt.eu-S1761730AbXE1N2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761730AbXE1N2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 09:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753879AbXE1N23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 09:28:29 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:42056 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753004AbXE1N22 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 09:28:28 -0400
Message-id: <24123155773117716452@wsc.cz>
In-reply-to: <12191294601255228079@wsc.cz>
Subject: [PATCH 4/8] Char: genrtc, use wait_event_interruptible
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <rz@linux-m68k.org>
Date: Mon, 28 May 2007 15:28:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

genrtc, use wait_event_interruptible

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit d45ae897fff813cf27d5d6ddfd92d19806831965
tree 8c985cb371c7d22c4ae939b27fe56705274452dc
parent 68362b19a0b8b05ce81b8d17743f2d0fceedb81b
author Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:26:32 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 26 May 2007 21:26:32 +0200

 drivers/char/genrtc.c |   22 +++++-----------------
 1 files changed, 5 insertions(+), 17 deletions(-)

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 9e1fc02..69f0a29 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -173,7 +173,6 @@ static void gen_rtc_interrupt(unsigned long arg)
 static ssize_t gen_rtc_read(struct file *file, char __user *buf,
 			size_t count, loff_t *ppos)
 {
-	DECLARE_WAITQUEUE(wait, current);
 	unsigned long data;
 	ssize_t retval;
 
@@ -183,18 +182,10 @@ static ssize_t gen_rtc_read(struct file *file, char __user *buf,
 	if (file->f_flags & O_NONBLOCK && !gen_rtc_irq_data)
 		return -EAGAIN;
 
-	add_wait_queue(&gen_rtc_wait, &wait);
-	retval = -ERESTARTSYS;
-
-	while (1) {
-		set_current_state(TASK_INTERRUPTIBLE);
-		data = xchg(&gen_rtc_irq_data, 0);
-		if (data)
-			break;
-		if (signal_pending(current))
-			goto out;
-		schedule();
-	}
+	retval = wait_event_interruptible(gen_rtc_wait,
+			(data = xchg(&gen_rtc_irq_data, 0)));
+	if (retval)
+		goto out;
 
 	/* first test allows optimizer to nuke this case for 32-bit machines */
 	if (sizeof (int) != sizeof (long) && count == sizeof (unsigned int)) {
@@ -206,10 +197,7 @@ static ssize_t gen_rtc_read(struct file *file, char __user *buf,
 		retval = put_user(data, (unsigned long __user *)buf) ?:
 			sizeof(unsigned long);
 	}
- out:
-	__set_current_state(TASK_RUNNING);
-	remove_wait_queue(&gen_rtc_wait, &wait);
-
+out:
 	return retval;
 }
 
