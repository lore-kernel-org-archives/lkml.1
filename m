Return-Path: <linux-kernel-owner+w=401wt.eu-S1031375AbXECReJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031375AbXECReJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:34:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031383AbXECReJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:34:09 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:34610 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031375AbXECReG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:34:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=JDZqgKUk+AIdIIxySTX6UUSnMQl5Tp61ZGiKlkcZIaio0zcOqxeMQQbMPMx+/TxDIn9s0wQ0/Ebgokn89HFcQbHE0JAgTbf3F0D9jq3yspevxEv7YYR+RrI1NTrDx4m3FUFhnD2r6aXCDu1eG9Sa73NmBQStb9e5ZADjkYekVeI=
Date: Fri, 4 May 2007 02:28:01 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Paul Jackson <pj@sgi.com>, Randy Dunlap <rdunlap@xenotime.net>
Subject: [PATCH] use simple_read_from_buffer in kernel/
Message-ID: <20070503172801.GA3563@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Paul Jackson <pj@sgi.com>,
	Randy Dunlap <rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup using simple_read_from_buffer() for /dev/cpuset/tasks
and /proc/config.gz.

Cc: Paul Jackson <pj@sgi.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 kernel/configs.c |   15 +++------------
 kernel/cpuset.c  |    7 +------
 2 files changed, 4 insertions(+), 18 deletions(-)

Index: 2.6-git/kernel/cpuset.c
===================================================================
--- 2.6-git.orig/kernel/cpuset.c
+++ 2.6-git/kernel/cpuset.c
@@ -1751,12 +1751,7 @@ static ssize_t cpuset_tasks_read(struct 
 {
 	struct ctr_struct *ctr = file->private_data;
 
-	if (*ppos + nbytes > ctr->bufsz)
-		nbytes = ctr->bufsz - *ppos;
-	if (copy_to_user(buf, ctr->buf + *ppos, nbytes))
-		return -EFAULT;
-	*ppos += nbytes;
-	return nbytes;
+	return simple_read_from_buffer(buf, nbytes, ppos, ctr->buf, ctr->bufsz);
 }
 
 static int cpuset_tasks_release(struct inode *unused_inode, struct file *file)
Index: 2.6-git/kernel/configs.c
===================================================================
--- 2.6-git.orig/kernel/configs.c
+++ 2.6-git/kernel/configs.c
@@ -61,18 +61,9 @@ static ssize_t
 ikconfig_read_current(struct file *file, char __user *buf,
 		      size_t len, loff_t * offset)
 {
-	loff_t pos = *offset;
-	ssize_t count;
-
-	if (pos >= kernel_config_data_size)
-		return 0;
-
-	count = min(len, (size_t)(kernel_config_data_size - pos));
-	if (copy_to_user(buf, kernel_config_data + MAGIC_SIZE + pos, count))
-		return -EFAULT;
-
-	*offset += count;
-	return count;
+	return simple_read_from_buffer(buf, len, offset,
+				       kernel_config_data + MAGIC_SIZE,
+				       kernel_config_data_size);
 }
 
 static const struct file_operations ikconfig_file_ops = {
