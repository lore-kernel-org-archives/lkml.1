Return-Path: <linux-kernel-owner+w=401wt.eu-S1755664AbYDQVSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755664AbYDQVSi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 17:18:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYDQVSa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 17:18:30 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41087 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751367AbYDQVS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 17:18:29 -0400
Date: Thu, 17 Apr 2008 14:17:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: sukadev@us.ibm.com
Cc: serue@us.ibm.com, ebiederm@xmission.com, hpa@zytor.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Factor out PTY index allocation
Message-Id: <20080417141725.7cd8e50e.akpm@linux-foundation.org>
In-Reply-To: <20080416221723.GB7112@us.ibm.com>
References: <20080416221723.GB7112@us.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Apr 2008 15:17:23 -0700
sukadev@us.ibm.com wrote:

> Factor out the code used to allocate/free a pts index into new interfaces,
> devpts_new_index() and devpts_kill_index().  This localizes the external
> data structures used in managing the pts indices.

err...

> -	mutex_lock(&allocated_ptys_lock);
> +	down(&allocated_ptys_lock);

Why the mutex-to-semaphore conversion?


--- a/fs/devpts/inode.c~devpts-factor-out-pty-index-allocation-fix
+++ a/fs/devpts/inode.c
@@ -17,6 +17,7 @@
 #include <linux/namei.h>
 #include <linux/mount.h>
 #include <linux/tty.h>
+#include <linux/mutex.h>
 #include <linux/idr.h>
 #include <linux/devpts_fs.h>
 #include <linux/parser.h>
@@ -29,7 +30,7 @@
 
 extern int pty_limit;			/* Config limit on Unix98 ptys */
 static DEFINE_IDR(allocated_ptys);
-static DECLARE_MUTEX(allocated_ptys_lock);
+static DEFINE_MUTEX(allocated_ptys_lock);
 
 static struct vfsmount *devpts_mnt;
 static struct dentry *devpts_root;
@@ -186,10 +187,10 @@ retry:
 		return -ENOMEM;
 	}
 
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_ret = idr_get_new(&allocated_ptys, NULL, &index);
 	if (idr_ret < 0) {
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		if (idr_ret == -EAGAIN)
 			goto retry;
 		return -EIO;
@@ -197,18 +198,18 @@ retry:
 
 	if (index >= pty_limit) {
 		idr_remove(&allocated_ptys, index);
-		up(&allocated_ptys_lock);
+		mutex_unlock(&allocated_ptys_lock);
 		return -EIO;
 	}
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 	return index;
 }
 
 void devpts_kill_index(int idx)
 {
-	down(&allocated_ptys_lock);
+	mutex_lock(&allocated_ptys_lock);
 	idr_remove(&allocated_ptys, idx);
-	up(&allocated_ptys_lock);
+	mutex_unlock(&allocated_ptys_lock);
 }
 
 int devpts_pty_new(struct tty_struct *tty)
_

