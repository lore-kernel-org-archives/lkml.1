Return-Path: <linux-kernel-owner+w=401wt.eu-S1758573AbZBSSVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573AbZBSSVn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 13:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754821AbZBSSUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 13:20:21 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:47999 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754049AbZBSSUR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 13:20:17 -0500
Subject: [RFC][PATCH 4/5] breakout fdinfo sprintf() into its own function
To: Ingo Molnar <mingo@elte.hu>
Cc: containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>
From: Dave Hansen <dave@linux.vnet.ibm.com>
Date: Thu, 19 Feb 2009 10:20:11 -0800
References: <20090219182007.B4B47C1F@kernel>
In-Reply-To: <20090219182007.B4B47C1F@kernel>
Message-Id: <20090219182011.6CFB5483@kernel>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'll be adding to this in a moment and it is in a bad place
to do that cleanly now.

Also, increase the buffer size.  Most /proc files can
output up to a page, so use the same here.

Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
---

 linux-2.6.git-dave/fs/proc/base.c |   23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff -puN fs/proc/base.c~breakout-fdinfo fs/proc/base.c
--- linux-2.6.git/fs/proc/base.c~breakout-fdinfo	2009-02-19 10:17:25.000000000 -0800
+++ linux-2.6.git-dave/fs/proc/base.c	2009-02-19 10:17:25.000000000 -0800
@@ -1597,7 +1597,18 @@ out:
 	return ~0U;
 }
 
-#define PROC_FDINFO_MAX 64
+#define PROC_FDINFO_MAX PAGE_SIZE
+
+static void proc_fd_write_info(struct file *file, char *info)
+{
+	int max = PROC_FDINFO_MAX;
+	int p = 0;
+	if (!info)
+		return;
+
+	p += snprintf(info+p, max-p, "pos:\t%lli\n", (long long) file->f_pos);
+	p += snprintf(info+p, max-p, "flags:\t0%o\n", file->f_flags);
+}
 
 static int proc_fd_info(struct inode *inode, struct path *path, char *info)
 {
@@ -1622,12 +1633,7 @@ static int proc_fd_info(struct inode *in
 				*path = file->f_path;
 				path_get(&file->f_path);
 			}
-			if (info)
-				snprintf(info, PROC_FDINFO_MAX,
-					 "pos:\t%lli\n"
-					 "flags:\t0%o\n",
-					 (long long) file->f_pos,
-					 file->f_flags);
+			proc_fd_write_info(file, info);
 			spin_unlock(&files->file_lock);
 			put_files_struct(files);
 			return 0;
@@ -1831,10 +1837,11 @@ static int proc_readfd(struct file *filp
 static ssize_t proc_fdinfo_read(struct file *file, char __user *buf,
 				      size_t len, loff_t *ppos)
 {
-	char tmp[PROC_FDINFO_MAX];
+	char *tmp = kmalloc(PROC_FDINFO_MAX, GFP_KERNEL);
 	int err = proc_fd_info(file->f_path.dentry->d_inode, NULL, tmp);
 	if (!err)
 		err = simple_read_from_buffer(buf, len, ppos, tmp, strlen(tmp));
+	kfree(tmp);
 	return err;
 }
 
_
