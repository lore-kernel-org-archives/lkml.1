Return-Path: <linux-kernel-owner+w=401wt.eu-S1755925AbZFSVIx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925AbZFSVIx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 17:08:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752622AbZFSVIo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 17:08:44 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:44766 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbZFSVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 17:08:44 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: alan@lxorguk.ukuu.org.uk
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/3] Char: n_r3964, fix lock imbalance
Date: Fri, 19 Jun 2009 23:08:26 +0200
Message-Id: <1245445708-27256-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is omitted BKunL in r3964_read.

Centralize the paths to one point with one unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/char/n_r3964.c |   26 ++++++++++++++------------
 1 files changed, 14 insertions(+), 12 deletions(-)

diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index d2e93e3..2e99158 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1062,7 +1062,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 	struct r3964_client_info *pClient;
 	struct r3964_message *pMsg;
 	struct r3964_client_message theMsg;
-	int count;
+	int ret;
 
 	TRACE_L("read()");
 
@@ -1074,8 +1074,8 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 		if (pMsg == NULL) {
 			/* no messages available. */
 			if (file->f_flags & O_NONBLOCK) {
-				unlock_kernel();
-				return -EAGAIN;
+				ret = -EAGAIN;
+				goto unlock;
 			}
 			/* block until there is a message: */
 			wait_event_interruptible(pInfo->read_wait,
@@ -1085,29 +1085,31 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 		/* If we still haven't got a message, we must have been signalled */
 
 		if (!pMsg) {
-			unlock_kernel();
-			return -EINTR;
+			ret = -EINTR;
+			goto unlock;
 		}
 
 		/* deliver msg to client process: */
 		theMsg.msg_id = pMsg->msg_id;
 		theMsg.arg = pMsg->arg;
 		theMsg.error_code = pMsg->error_code;
-		count = sizeof(struct r3964_client_message);
+		ret = sizeof(struct r3964_client_message);
 
 		kfree(pMsg);
 		TRACE_M("r3964_read - msg kfree %p", pMsg);
 
-		if (copy_to_user(buf, &theMsg, count)) {
-			unlock_kernel();
-			return -EFAULT;
+		if (copy_to_user(buf, &theMsg, ret)) {
+			ret = -EFAULT;
+			goto unlock;
 		}
 
-		TRACE_PS("read - return %d", count);
-		return count;
+		TRACE_PS("read - return %d", ret);
+		goto unlock;
 	}
+	ret = -EPERM;
+unlock:
 	unlock_kernel();
-	return -EPERM;
+	return ret;
 }
 
 static ssize_t r3964_write(struct tty_struct *tty, struct file *file,
-- 
1.6.3.2

