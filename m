Return-Path: <linux-kernel-owner+w=401wt.eu-S1754377AbYCQXOt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377AbYCQXOt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 19:14:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752006AbYCQXOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 19:14:40 -0400
Received: from vena.lwn.net ([206.168.112.25]:49352 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407AbYCQXOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 19:14:40 -0400
To: linux-kernel@vger.kernel.org
Subject: [PATCH] de-semaphorize smackfs
cc: Casey Schaufler <casey@schaufler-ca.com>
From: Jonathan Corbet <corbet@lwn.net>
Date: Mon, 17 Mar 2008 17:14:40 -0600
Message-ID: <30338.1205795680@vena.lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While looking at the generic semaphore patch, I came to wonder what the
remaining semaphore users in the kernel were actually doing.  After a
quick grep for down_interruptible(), smackfs remained at the bottom of
my screen.  It seems like a straightforward mutex case - low-hanging
fruit.  So here's a conversion patch; compile-tested only, but what
could go wrong?

jon

Convert smackfs from a semaphore to a mutex

Signed-off-by: Jonathan Corbet <corbet@lwn.net>

diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
index afe7c9b..6e09cec 100644
--- a/security/smack/smackfs.c
+++ b/security/smack/smackfs.c
@@ -76,7 +76,7 @@ struct smk_list_entry *smack_list;
 /*
  * Disable concurrent writing open() operations
  */
-static struct semaphore smack_write_sem;
+static DEFINE_MUTEX(smack_write_mutex);
 
 /*
  * Values for parsing cipso rules
@@ -171,7 +171,7 @@ static int smk_open_load(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
 		return seq_open(file, &load_seq_ops);
 
-	if (down_interruptible(&smack_write_sem))
+	if (mutex_lock_interruptible(&smack_write_mutex))
 		return -ERESTARTSYS;
 
 	return 0;
@@ -192,7 +192,7 @@ static int smk_release_load(struct inode *inode, struct file *file)
 	if ((file->f_flags & O_ACCMODE) == O_RDONLY)
 		return seq_release(inode, file);
 
-	up(&smack_write_sem);
+	mutex_unlock(&smack_write_mutex);
 	return 0;
 }
 
@@ -1011,7 +1011,7 @@ static int __init init_smk_fs(void)
 		}
 	}
 
-	sema_init(&smack_write_sem, 1);
+	mutex_init(&smack_write_mutex);
 	smk_cipso_doi();
 	smk_unlbl_ambient(NULL);
 
