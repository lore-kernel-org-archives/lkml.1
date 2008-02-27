Return-Path: <linux-kernel-owner+w=401wt.eu-S1758541AbYB0Nt3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758541AbYB0Nt3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 08:49:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbYB0NtV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 08:49:21 -0500
Received: from sacred.ru ([62.205.161.221]:51539 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbYB0NtV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:49:21 -0500
Message-ID: <47C56A40.4080506@openvz.org>
Date: Wed, 27 Feb 2008 16:48:48 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/3] Sysctl: merge equal proc_sys_read and proc_sys_write
References: <47C569DE.9060208@openvz.org>
In-Reply-To: <47C569DE.9060208@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Wed, 27 Feb 2008 16:48:39 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These ->read and ->write callbacks act in a very similar way, so
merge these paths to reduce the number of places to patch later
and shrink the .text size (a bit).

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
---
 fs/proc/proc_sysctl.c |   50 ++++++++++--------------------------------------
 1 files changed, 11 insertions(+), 39 deletions(-)

diff --git a/fs/proc/proc_sysctl.c b/fs/proc/proc_sysctl.c
index 614c34b..5e31585 100644
--- a/fs/proc/proc_sysctl.c
+++ b/fs/proc/proc_sysctl.c
@@ -165,8 +165,8 @@ out:
 	return err;
 }
 
-static ssize_t proc_sys_read(struct file *filp, char __user *buf,
-				size_t count, loff_t *ppos)
+static ssize_t proc_sys_call_handler(struct file *filp, void __user *buf,
+		size_t count, loff_t *ppos, int write)
 {
 	struct dentry *dentry = filp->f_dentry;
 	struct ctl_table_header *head;
@@ -190,12 +190,12 @@ static ssize_t proc_sys_read(struct file *filp, char __user *buf,
 	 * and won't be until we finish.
 	 */
 	error = -EPERM;
-	if (sysctl_perm(table, MAY_READ))
+	if (sysctl_perm(table, write ? MAY_WRITE : MAY_READ))
 		goto out;
 
 	/* careful: calling conventions are nasty here */
 	res = count;
-	error = table->proc_handler(table, 0, filp, buf, &res, ppos);
+	error = table->proc_handler(table, write, filp, buf, &res, ppos);
 	if (!error)
 		error = res;
 out:
@@ -204,44 +204,16 @@ out:
 	return error;
 }
 
-static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
+static ssize_t proc_sys_read(struct file *filp, char __user *buf,
 				size_t count, loff_t *ppos)
 {
-	struct dentry *dentry = filp->f_dentry;
-	struct ctl_table_header *head;
-	struct ctl_table *table;
-	ssize_t error;
-	size_t res;
-
-	table = do_proc_sys_lookup(dentry->d_parent, &dentry->d_name, &head);
-	/* Has the sysctl entry disappeared on us? */
-	error = -ENOENT;
-	if (!table)
-		goto out;
-
-	/* Has the sysctl entry been replaced by a directory? */
-	error = -EISDIR;
-	if (!table->proc_handler)
-		goto out;
-
-	/*
-	 * At this point we know that the sysctl was not unregistered
-	 * and won't be until we finish.
-	 */
-	error = -EPERM;
-	if (sysctl_perm(table, MAY_WRITE))
-		goto out;
-
-	/* careful: calling conventions are nasty here */
-	res = count;
-	error = table->proc_handler(table, 1, filp, (char __user *)buf,
-				    &res, ppos);
-	if (!error)
-		error = res;
-out:
-	sysctl_head_finish(head);
+	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 0);
+}
 
-	return error;
+static ssize_t proc_sys_write(struct file *filp, const char __user *buf,
+				size_t count, loff_t *ppos)
+{
+	return proc_sys_call_handler(filp, (void __user *)buf, count, ppos, 1);
 }
 
 
-- 
1.5.3.4

