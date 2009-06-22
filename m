Return-Path: <linux-kernel-owner+w=401wt.eu-S1755802AbZFVQob@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755802AbZFVQob (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 12:44:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbZFVQoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 12:44:05 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37484 "EHLO
	t61.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754789AbZFVQoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 12:44:03 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 05/15] n_r3964: fix lock imbalance
To: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Date: Mon, 22 Jun 2009 18:42:03 +0100
Message-ID: <20090622174201.25341.92605.stgit@t61.ukuu.org.uk>
In-Reply-To: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
References: <20090622172929.25341.31151.stgit@t61.ukuu.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Slaby <jirislaby@gmail.com>

There is omitted BKunL in r3964_read.

Centralize the paths to one point with one unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Cc: stable@kernel.org
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

