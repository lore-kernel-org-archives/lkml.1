Return-Path: <linux-kernel-owner+w=401wt.eu-S932504AbXK3NQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504AbXK3NQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 08:16:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756159AbXK3NQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 08:16:39 -0500
Received: from sacred.ru ([62.205.161.221]:54966 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757173AbXK3NQi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 08:16:38 -0500
Message-ID: <47500D2D.3050000@openvz.org>
Date: Fri, 30 Nov 2007 16:16:29 +0300
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       devel@openvz.org
Subject: [PATCH 6/7][MQUEUE] Move sysctl management code under ifdef CONFIG_SYSCTL
References: <475008F5.3000506@openvz.org>
In-Reply-To: <475008F5.3000506@openvz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 30 Nov 2007 16:16:27 +0300 (MSK)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This includes the tables, the mq_sysctl_table ctl header 
and calls to register/unregister.

Just like with the quota patch, I hope this is OK to
keep the ifdefs inside the __init function, rather
than making handlers and stubs outside it.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>

---

diff --git a/ipc/mqueue.c b/ipc/mqueue.c
index 7d1b8aa..9ff4abf 100644
--- a/ipc/mqueue.c
+++ b/ipc/mqueue.c
@@ -94,8 +94,6 @@ static unsigned int queues_max 	= DFLT_QUEUESMAX;
 static unsigned int msg_max 	= DFLT_MSGMAX;
 static unsigned int msgsize_max = DFLT_MSGSIZEMAX;
 
-static struct ctl_table_header * mq_sysctl_table;
-
 static inline struct mqueue_inode_info *MQUEUE_I(struct inode *inode)
 {
 	return container_of(inode, struct mqueue_inode_info, vfs_inode);
@@ -1201,6 +1199,7 @@ static int msg_max_limit_max = HARD_MSGMAX;
 static int msg_maxsize_limit_min = DFLT_MSGSIZEMAX;
 static int msg_maxsize_limit_max = INT_MAX;
 
+#ifdef CONFIG_SYSCTL
 static ctl_table mq_sysctls[] = {
 	{
 		.procname	= "queues_max",
@@ -1249,6 +1248,9 @@ static ctl_table mq_sysctl_root[] = {
 	{ .ctl_name = 0 }
 };
 
+static struct ctl_table_header *mq_sysctl_table;
+#endif
+
 static int __init init_mqueue_fs(void)
 {
 	int error;
@@ -1258,10 +1260,10 @@ static int __init init_mqueue_fs(void)
 				SLAB_HWCACHE_ALIGN, init_once);
 	if (mqueue_inode_cachep == NULL)
 		return -ENOMEM;
-
+#ifdef CONFIG_SYSCTL
 	/* ignore failues - they are not fatal */
 	mq_sysctl_table = register_sysctl_table(mq_sysctl_root);
-
+#endif
 	error = register_filesystem(&mqueue_fs_type);
 	if (error)
 		goto out_sysctl;
@@ -1280,8 +1282,10 @@ static int __init init_mqueue_fs(void)
 out_filesystem:
 	unregister_filesystem(&mqueue_fs_type);
 out_sysctl:
+#ifdef CONFIG_SYSCTL
 	if (mq_sysctl_table)
 		unregister_sysctl_table(mq_sysctl_table);
+#endif
 	kmem_cache_destroy(mqueue_inode_cachep);
 	return error;
 }
-- 
1.5.3.4


