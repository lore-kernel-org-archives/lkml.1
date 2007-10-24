Return-Path: <linux-kernel-owner+w=401wt.eu-S1763354AbXJXQju@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763354AbXJXQju (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:39:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759967AbXJXQZM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:25:12 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:60953 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759171AbXJXQZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:25:04 -0400
Date: Wed, 24 Oct 2007 18:25:34 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Paul Menage <menage@google.com>, Paul Jackson <pj@sgi.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] kernel/cgroup.c: remove dead code
Message-ID: <20071024162534.GZ30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch removes dead code spotted by the Coverity checker
(look at the "(nbytes >= PATH_MAX)" check).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 kernel/cgroup.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- linux-2.6/kernel/cgroup.c.old	2007-10-23 18:37:43.000000000 +0200
+++ linux-2.6/kernel/cgroup.c	2007-10-23 18:39:15.000000000 +0200
@@ -1320,90 +1320,88 @@ static ssize_t cgroup_common_file_write(
 
 	if (nbytes >= PATH_MAX)
 		return -E2BIG;
 
 	/* +1 for nul-terminator */
 	buffer = kmalloc(nbytes + 1, GFP_KERNEL);
 	if (buffer == NULL)
 		return -ENOMEM;
 
 	if (copy_from_user(buffer, userbuf, nbytes)) {
 		retval = -EFAULT;
 		goto out1;
 	}
 	buffer[nbytes] = 0;	/* nul-terminate */
 
 	mutex_lock(&cgroup_mutex);
 
 	if (cgroup_is_removed(cgrp)) {
 		retval = -ENODEV;
 		goto out2;
 	}
 
 	switch (type) {
 	case FILE_TASKLIST:
 		retval = attach_task_by_pid(cgrp, buffer);
 		break;
 	case FILE_NOTIFY_ON_RELEASE:
 		clear_bit(CGRP_RELEASABLE, &cgrp->flags);
 		if (simple_strtoul(buffer, NULL, 10) != 0)
 			set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 		else
 			clear_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
 		break;
 	case FILE_RELEASE_AGENT:
 	{
 		struct cgroupfs_root *root = cgrp->root;
 		/* Strip trailing newline */
 		if (nbytes && (buffer[nbytes-1] == '\n')) {
 			buffer[nbytes-1] = 0;
 		}
-		if (nbytes < sizeof(root->release_agent_path)) {
-			/* We never write anything other than '\0'
-			 * into the last char of release_agent_path,
-			 * so it always remains a NUL-terminated
-			 * string */
-			strncpy(root->release_agent_path, buffer, nbytes);
-			root->release_agent_path[nbytes] = 0;
-		} else {
-			retval = -ENOSPC;
-		}
+
+		/* We never write anything other than '\0'
+		 * into the last char of release_agent_path,
+		 * so it always remains a NUL-terminated
+		 * string */
+		strncpy(root->release_agent_path, buffer, nbytes);
+		root->release_agent_path[nbytes] = 0;
+
 		break;
 	}
 	default:
 		retval = -EINVAL;
 		goto out2;
 	}
 
 	if (retval == 0)
 		retval = nbytes;
 out2:
 	mutex_unlock(&cgroup_mutex);
 out1:
 	kfree(buffer);
 	return retval;
 }
 
 static ssize_t cgroup_file_write(struct file *file, const char __user *buf,
 						size_t nbytes, loff_t *ppos)
 {
 	struct cftype *cft = __d_cft(file->f_dentry);
 	struct cgroup *cgrp = __d_cgrp(file->f_dentry->d_parent);
 
 	if (!cft)
 		return -ENODEV;
 	if (cft->write)
 		return cft->write(cgrp, cft, file, buf, nbytes, ppos);
 	if (cft->write_uint)
 		return cgroup_write_uint(cgrp, cft, file, buf, nbytes, ppos);
 	return -EINVAL;
 }
 
 static ssize_t cgroup_read_uint(struct cgroup *cgrp, struct cftype *cft,
 				   struct file *file,
 				   char __user *buf, size_t nbytes,
 				   loff_t *ppos)
 {
 	char tmp[64];
 	u64 val = cft->read_uint(cgrp, cft);
 	int len = sprintf(tmp, "%llu\n", (unsigned long long) val);
 

