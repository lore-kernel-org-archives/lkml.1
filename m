Return-Path: <linux-kernel-owner+w=401wt.eu-S1763763AbZGABLg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763763AbZGABLg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 21:11:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761582AbZGAAfk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:35:40 -0400
Received: from kroah.org ([198.145.64.141]:60611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760913AbZGAAf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:35:28 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:24:39 2009
Message-Id: <20090701002439.494893968@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:24:13 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@linux.intel.com>
Subject: [patch 084/108] n_r3964: fix lock imbalance
References: <20090701002249.937782934@mini.kroah.org>
Content-Disposition: inline; filename=n_r3964-fix-lock-imbalance.patch
In-Reply-To: <20090701002838.GA7100@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jiri Slaby <jirislaby@gmail.com>

commit eca41044268887838fa122aa24475df8f23d614c upstream.

There is omitted BKunL in r3964_read.

Centralize the paths to one point with one unlock.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/n_r3964.c |   26 ++++++++++++++------------
 1 file changed, 14 insertions(+), 12 deletions(-)

--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1062,7 +1062,7 @@ static ssize_t r3964_read(struct tty_str
 	struct r3964_client_info *pClient;
 	struct r3964_message *pMsg;
 	struct r3964_client_message theMsg;
-	int count;
+	int ret;
 
 	TRACE_L("read()");
 
@@ -1074,8 +1074,8 @@ static ssize_t r3964_read(struct tty_str
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
@@ -1085,29 +1085,31 @@ static ssize_t r3964_read(struct tty_str
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


