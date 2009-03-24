Return-Path: <linux-kernel-owner+w=401wt.eu-S1754355AbZCXVQZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754355AbZCXVQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 17:16:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752861AbZCXVN1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 17:13:27 -0400
Received: from an-out-0708.google.com ([209.85.132.244]:13159 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004AbZCXVNW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 17:13:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=s+B0pk84nUGPe0UjkvLvImYVQaozdJigXk8wJfYOrVSQDF1BFBtWl4zd1bfH4f58tz
         c4rU4IXdOwapiheNKbtggNvi1leizWoHizjhkuPuXcaL4MJVeu/K7IcXAy4O+pHUSPCv
         jADFVf6vyWKXUULlRWUGbGF5EWHhhQ4a/Wr2o=
From: stoyboyker@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Stoyan Gaydarov <stoyboyker@gmail.com>, wim@iguana.be
Subject: [PATCH 08/13] [watchdog] changed ioctls to unlocked
Date: Tue, 24 Mar 2009 16:12:43 -0500
Message-Id: <1237929168-15341-9-git-send-email-stoyboyker@gmail.com>
X-Mailer: git-send-email 1.6.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stoyan Gaydarov <stoyboyker@gmail.com>

Signed-off-by: Stoyan Gaydarov <stoyboyker@gmail.com>
---
 drivers/watchdog/riowd.c |   37 +++++++++++++++++++++++++++----------
 1 files changed, 27 insertions(+), 10 deletions(-)

diff --git a/drivers/watchdog/riowd.c b/drivers/watchdog/riowd.c
index 09cb183..44058c1 100644
--- a/drivers/watchdog/riowd.c
+++ b/drivers/watchdog/riowd.c
@@ -86,9 +86,10 @@ static int riowd_release(struct inode *inode, struct file *filp)
 	return 0;
 }
 
-static int riowd_ioctl(struct inode *inode, struct file *filp,
-		       unsigned int cmd, unsigned long arg)
+static long riowd_ioctl(struct file *filp, unsigned int cmd,
+		       unsigned long arg)
 {
+	lock_kernel();
 	static struct watchdog_info info = {
 		.options		= WDIOF_SETTIMEOUT,
 		.firmware_version	= 1,
@@ -101,14 +102,18 @@ static int riowd_ioctl(struct inode *inode, struct file *filp,
 
 	switch (cmd) {
 	case WDIOC_GETSUPPORT:
-		if (copy_to_user(argp, &info, sizeof(info)))
+		if (copy_to_user(argp, &info, sizeof(info))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 		break;
 
 	case WDIOC_GETSTATUS:
 	case WDIOC_GETBOOTSTATUS:
-		if (put_user(0, (int __user *)argp))
+		if (put_user(0, (int __user *)argp)) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 		break;
 
 	case WDIOC_KEEPALIVE:
@@ -116,34 +121,46 @@ static int riowd_ioctl(struct inode *inode, struct file *filp,
 		break;
 
 	case WDIOC_SETOPTIONS:
-		if (copy_from_user(&options, argp, sizeof(options)))
+		if (copy_from_user(&options, argp, sizeof(options))) {
+			unlock_kernel();
 			return -EFAULT;
+		}
 
 		if (options & WDIOS_DISABLECARD)
 			riowd_writereg(p, 0, WDTO_INDEX);
 		else if (options & WDIOS_ENABLECARD)
 			riowd_writereg(p, riowd_timeout, WDTO_INDEX);
-		else
+		else {
+			unlock_kernel();
 			return -EINVAL;
+		}
 
 		break;
 
 	case WDIOC_SETTIMEOUT:
-		if (get_user(new_margin, (int __user *)argp))
+		if (get_user(new_margin, (int __user *)argp)) {
+			unlock_kernel();
 			return -EFAULT;
-		if ((new_margin < 60) || (new_margin > (255 * 60)))
+		}
+		if ((new_margin < 60) || (new_margin > (255 * 60))) {
+			unlock_kernel();
 			return -EINVAL;
+		}
 		riowd_timeout = (new_margin + 59) / 60;
 		riowd_writereg(p, riowd_timeout, WDTO_INDEX);
 		/* Fall */
 
 	case WDIOC_GETTIMEOUT:
-		return put_user(riowd_timeout * 60, (int __user *)argp);
+		long ret = put_user(riowd_timeout * 60, (int __user *)argp);
+		unlock_kernel();
+		return ret;
 
 	default:
+		unlock_kernel();
 		return -EINVAL;
 	};
 
+	unlock_kernel();
 	return 0;
 }
 
@@ -162,7 +179,7 @@ static ssize_t riowd_write(struct file *file, const char __user *buf, size_t cou
 static const struct file_operations riowd_fops = {
 	.owner =	THIS_MODULE,
 	.llseek =	no_llseek,
-	.ioctl =	riowd_ioctl,
+	.unlocked_ioctl =	riowd_ioctl,
 	.open =		riowd_open,
 	.write =	riowd_write,
 	.release =	riowd_release,
-- 
1.6.2

