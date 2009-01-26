Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbZAZX0Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbZAZX0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 18:26:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751875AbZAZX0Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 18:26:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.158]:29094 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665AbZAZX0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 18:26:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iYqKcEVmHlG2zPC9CDxlUEji2ZrMCVaJHyuKBfM7mV65NPpxagm0N68QE8RkaXXF4/
         y2/z/o+Tqlq1iTKAWqZDd+Xv0sS5aDoggcTYQwxSk2VKAdLaG/Mxl3avNutDsie3pv/w
         yGrg+9+VNdUvWExeibZZBqgudaAr/yCGFMy6c=
Date: Tue, 27 Jan 2009 02:31:51 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jlayton@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] proc: do PDE usecounting even for ->read_proc,
	->write_proc
Message-ID: <20090126233151.GA7339@x200.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Not exactly tested but one should get the idea.



-----------------------------------------------
struct proc_dir_entry::owner is going to be removed. Now it's only necessary
to protect PDEs which are using ->read_proc, ->write_proc hooks.

However, ->owner assignments are racy and make it very easy for someone to switch
->owner on live PDE (as some subsystems do) without fixing refcounts and so on.

http://bugzilla.kernel.org/show_bug.cgi?id=12454

So, ->owner is on death row.

Proxy file operations exist already (proc_file_operations), just bump usecount
when necessary.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 fs/proc/generic.c  |   48 ++++++++++++++++++++++++++++++++++++++----------
 fs/proc/inode.c    |    2 +-
 fs/proc/internal.h |    1 +
 3 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/fs/proc/generic.c b/fs/proc/generic.c
index 5ee636a..65cc1ee 100644
--- a/fs/proc/generic.c
+++ b/fs/proc/generic.c
@@ -37,7 +37,7 @@ static int proc_match(int len, const char *name, struct proc_dir_entry *de)
 #define PROC_BLOCK_SIZE	(PAGE_SIZE - 1024)
 
 static ssize_t
-proc_file_read(struct file *file, char __user *buf, size_t nbytes,
+__proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 	       loff_t *ppos)
 {
 	struct inode * inode = file->f_path.dentry->d_inode;
@@ -183,19 +183,47 @@ proc_file_read(struct file *file, char __user *buf, size_t nbytes,
 }
 
 static ssize_t
+proc_file_read(struct file *file, char __user *buf, size_t nbytes,
+	       loff_t *ppos)
+{
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	ssize_t rv = -EIO;
+
+	spin_lock(&pde->pde_unload_lock);
+	if (!pde->proc_fops) {
+		spin_unlock(&pde->pde_unload_lock);
+		return rv;
+	}
+	pde->pde_users++;
+	spin_unlock(&pde->pde_unload_lock);
+
+	rv = __proc_file_read(file, buf, nbytes, ppos);
+
+	pde_users_dec(pde);
+	return rv;
+}
+
+static ssize_t
 proc_file_write(struct file *file, const char __user *buffer,
 		size_t count, loff_t *ppos)
 {
-	struct inode *inode = file->f_path.dentry->d_inode;
-	struct proc_dir_entry * dp;
-	
-	dp = PDE(inode);
-
-	if (!dp->write_proc)
-		return -EIO;
+	struct proc_dir_entry *pde = PDE(file->f_path.dentry->d_inode);
+	ssize_t rv = -EIO;
+
+	if (pde->write_proc) {
+		spin_lock(&pde->pde_unload_lock);
+		if (!pde->proc_fops) {
+			spin_unlock(&pde->pde_unload_lock);
+			return rv;
+		}
+		pde->pde_users++;
+		spin_unlock(&pde->pde_unload_lock);
 
-	/* FIXME: does this routine need ppos?  probably... */
-	return dp->write_proc(file, buffer, count, dp->data);
+		/* FIXME: does this routine need ppos?  probably... */
+		rv = pde->write_proc(file, buffer, count, pde->data);
+		pde_users_dec(pde);
+	}
+	return rv;
 }
 
 
diff --git a/fs/proc/inode.c b/fs/proc/inode.c
index 0bbb937..7a55346 100644
--- a/fs/proc/inode.c
+++ b/fs/proc/inode.c
@@ -127,7 +127,7 @@ static void __pde_users_dec(struct proc_dir_entry *pde)
 		complete(pde->pde_unload_completion);
 }
 
-static void pde_users_dec(struct proc_dir_entry *pde)
+void pde_users_dec(struct proc_dir_entry *pde)
 {
 	spin_lock(&pde->pde_unload_lock);
 	__pde_users_dec(pde);
diff --git a/fs/proc/internal.h b/fs/proc/internal.h
index ab62ede..5b890ba 100644
--- a/fs/proc/internal.h
+++ b/fs/proc/internal.h
@@ -102,5 +102,6 @@ struct pde_opener {
 	int (*release)(struct inode *, struct file *);
 	struct list_head lh;
 };
+void pde_users_dec(struct proc_dir_entry *pde);
 
 extern struct list_head proc_automounts;
-- 
1.5.6.5

