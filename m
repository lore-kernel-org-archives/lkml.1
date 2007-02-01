Return-Path: <linux-kernel-owner+w=401wt.eu-S1422907AbXBAO5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422907AbXBAO5p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Feb 2007 09:57:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422909AbXBAO5p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Feb 2007 09:57:45 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:2036 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422907AbXBAO5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Feb 2007 09:57:45 -0500
Date: Thu, 1 Feb 2007 18:04:34 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: akpm@osdl.org
Cc: pasky@suse.cz, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [RFC] Allow access to /proc/$PID/fd after setuid()
Message-ID: <20070201150434.GA6023@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

/proc/$PID/fd has r-x------ permissions, so if process does setuid(), it
will not be able to access /proc/*/fd/. This breaks fstatat() emulation
in glibc.

open("foo", O_RDONLY|O_DIRECTORY)       = 4
setuid32(65534)                         = 0
stat64("/proc/self/fd/4/bar", 0xbfafb298) = -1 EACCES (Permission denied)

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 fs/proc/base.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1413,11 +1413,27 @@ static struct file_operations proc_fd_op
 	.readdir	= proc_readfd,
 };
 
+static int proc_fd_permission(struct inode *inode, int mask, struct nameidata *nd)
+{
+	struct task_struct *tsk;
+	int rv;
+
+	rv = generic_permission(inode, mask, NULL);
+	if (rv == 0)
+		return 0;
+	tsk = get_proc_task(inode);
+	if (tsk == current)
+		rv = 0;
+	put_task_struct(tsk);
+	return rv;
+}
+
 /*
  * proc directories can do almost nothing..
  */
 static struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
+	.permission	= proc_fd_permission,
 	.setattr	= proc_setattr,
 };
 

