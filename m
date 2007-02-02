Return-Path: <linux-kernel-owner+w=401wt.eu-S1751981AbXBBLNu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981AbXBBLNu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Feb 2007 06:13:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933218AbXBBLNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Feb 2007 06:13:50 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:34320 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXBBLNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Feb 2007 06:13:49 -0500
Date: Fri, 2 Feb 2007 14:20:37 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: akpm@osdl.org
Cc: pasky@suse.cz, linux-kernel@vger.kernel.org, devel@openvz.org
Subject: [PATCH v2] Allow access to /proc/$PID/fd after setuid()
Message-ID: <20070202112037.GA6021@localhost.sw.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

crap, Pavel reminded that get_proc_task() can return NULL.
------------------------------------------------------------------------
/proc/$PID/fd has r-x------ permissions, so if process does setuid(), it
will not be able to access /proc/*/fd/. This breaks fstatat() emulation
in glibc.

open("foo", O_RDONLY|O_DIRECTORY)       = 4
setuid32(65534)                         = 0
stat64("/proc/self/fd/4/bar", 0xbfafb298) = -1 EACCES (Permission denied)

Comment from Andrew Morton.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 fs/proc/base.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1414,10 +1414,33 @@ static struct file_operations proc_fd_op
 };
 
 /*
+ * /proc/pid/fd needs a special permission handler so that a process can still
+ * access /proc/self/fd after it has executed a setuid().
+ */
+static int proc_fd_permission(struct inode *inode, int mask,
+				struct nameidata *nd)
+{
+	struct task_struct *tsk;
+	int rv;
+
+	rv = generic_permission(inode, mask, NULL);
+	if (rv == 0)
+		return 0;
+	tsk = get_proc_task(inode);
+	if (tsk) {
+		if (tsk == current)
+			rv = 0;
+		put_task_struct(tsk);
+	}
+	return rv;
+}
+
+/*
  * proc directories can do almost nothing..
  */
 static struct inode_operations proc_fd_inode_operations = {
 	.lookup		= proc_lookupfd,
+	.permission	= proc_fd_permission,
 	.setattr	= proc_setattr,
 };
 

