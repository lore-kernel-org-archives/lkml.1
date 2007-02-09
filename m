Return-Path: <linux-kernel-owner+w=401wt.eu-S1946502AbXBIPDX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946502AbXBIPDX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 10:03:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946505AbXBIPDX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 10:03:23 -0500
Received: from mailhub.sw.ru ([195.214.233.200]:28889 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946502AbXBIPDV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 10:03:21 -0500
Date: Fri, 9 Feb 2007 18:09:51 +0300
From: Alexey Dobriyan <adobriyan@openvz.org>
To: akpm@osdl.org
Cc: pasky@suse.cz, linux-kernel@vger.kernel.org, devel@openvz.org,
       oleg@tv-sign.ru
Subject: [PATCH v3] Allow access to /proc/$PID/fd after setuid()
Message-ID: <20070209150951.GA6026@localhost.sw.ru>
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

Comments and suggestions from Andrew Morton and Oleg Nesterov.

Signed-off-by: Alexey Dobriyan <adobriyan@openvz.org>
---

 fs/proc/base.c |   18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1414,10 +1414,28 @@ static struct file_operations proc_fd_op
 };
 
 /*
+ * /proc/pid/fd needs a special permission handler so that a process can still
+ * access /proc/self/fd after it has executed a setuid().
+ */
+static int proc_fd_permission(struct inode *inode, int mask,
+				struct nameidata *nd)
+{
+	int rv;
+
+	rv = generic_permission(inode, mask, NULL);
+	if (rv == 0)
+		return 0;
+	if (task_pid(current) == proc_pid(inode))
+		rv = 0;
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
 

