Return-Path: <linux-kernel-owner+w=401wt.eu-S1760892AbYFDMK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760892AbYFDMK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 08:10:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760338AbYFDMJ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 08:09:57 -0400
Received: from rv-out-0506.google.com ([209.85.198.225]:42730 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754541AbYFDMJh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 08:09:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:references:user-agent:date:from:to:subject
         :content-disposition;
        b=aLRGyDhmJHROY17V0rrq/FT5uDEJV+awDYE0iHy5jKGZR4HcmKmK9Od/kELp6zcSz8
         5ipUPfNgsHb2RWISJUBAQjTFZrrjSSm9iEXxrrU9pE893vLOf43Hxhhu2Gq1m6MbqLbv
         af2KvzVMu65IlgbB+1LkNgjtdSuTlwdfyqOSM=
Message-Id: <20080604115716.478694998@gmail.com>
References: <20080604115633.116832712@gmail.com>
User-Agent: quilt/0.46-1
Date: Wed, 04 Jun 2008 20:56:36 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [patch -v3 03/22] ipc: use simple_read_from_buffer
Content-Disposition: inline; filename=mqueue-use-simple-read-from-buffer.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also this patch kills unneccesary trailing NULL character.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
---
 ipc/mqueue.c |   25 +++++++------------------
 1 file changed, 7 insertions(+), 18 deletions(-)

Index: 2.6-git/ipc/mqueue.c
===================================================================
--- 2.6-git.orig/ipc/mqueue.c
+++ 2.6-git/ipc/mqueue.c
@@ -314,15 +314,11 @@ static int mqueue_unlink(struct inode *d
 *	through std routines)
 */
 static ssize_t mqueue_read_file(struct file *filp, char __user *u_data,
-				size_t count, loff_t * off)
+				size_t count, loff_t *off)
 {
 	struct mqueue_inode_info *info = MQUEUE_I(filp->f_path.dentry->d_inode);
 	char buffer[FILENT_SIZE];
-	size_t slen;
-	loff_t o;
-
-	if (!count)
-		return 0;
+	ssize_t ret;
 
 	spin_lock(&info->lock);
 	snprintf(buffer, sizeof(buffer),
@@ -335,21 +331,14 @@ static ssize_t mqueue_read_file(struct f
 			pid_vnr(info->notify_owner));
 	spin_unlock(&info->lock);
 	buffer[sizeof(buffer)-1] = '\0';
-	slen = strlen(buffer)+1;
-
-	o = *off;
-	if (o > slen)
-		return 0;
-
-	if (o + count > slen)
-		count = slen - o;
 
-	if (copy_to_user(u_data, buffer + o, count))
-		return -EFAULT;
+	ret = simple_read_from_buffer(u_data, count, off, buffer,
+				strlen(buffer));
+	if (ret <= 0)
+		return ret;
 
-	*off = o + count;
 	filp->f_path.dentry->d_inode->i_atime = filp->f_path.dentry->d_inode->i_ctime = CURRENT_TIME;
-	return count;
+	return ret;
 }
 
 static int mqueue_flush_file(struct file *filp, fl_owner_t id)

-- 
