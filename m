Return-Path: <linux-kernel-owner+w=401wt.eu-S1753416AbXCZRvB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416AbXCZRvB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 13:51:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753396AbXCZRvB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 13:51:01 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:58964 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416AbXCZRu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 13:50:59 -0400
Date: Mon, 26 Mar 2007 12:50:55 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: dev@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Badari Pulavarty <badari@us.ibm.com>, Andrew Morton <akpm@osdl.org>
Subject: [PATCH] ipcns: fix !CONFIG_IPC_NS behavior
Message-ID: <20070326175055.GA11465@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

fyi, dummy copy_ipcs() needed to move bc we need CLONE_NEWIPC
definition, but #including sched.h breaks...

Andrew, I'll send a separate version for mm since return type
changed as with utsname.

thanks,
-serge

From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] ipcns: fix !CONFIG_IPC_NS behavior

When CONFIG_IPC_NS=n, clone(CLONE_NEWIPC) claims success, but did not actually
clone a new IPC namespace.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/ipc.h |    7 +------
 ipc/util.c          |    7 +++++++
 2 files changed, 8 insertions(+), 6 deletions(-)

9c4d6f67b6bf1a0e509ae2e52ffb721dc9bb2fe1
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index 636094c..5c05c88 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -96,15 +96,10 @@ extern struct ipc_namespace init_ipc_ns;
 #define INIT_IPC_NS(ns)
 #endif
 
+extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 #ifdef CONFIG_IPC_NS
 extern void free_ipc_ns(struct kref *kref);
-extern int copy_ipcs(unsigned long flags, struct task_struct *tsk);
 extern int unshare_ipcs(unsigned long flags, struct ipc_namespace **ns);
-#else
-static inline int copy_ipcs(unsigned long flags, struct task_struct *tsk)
-{
-	return 0;
-}
 #endif
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
diff --git a/ipc/util.c b/ipc/util.c
index 08a6479..0b65238 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -144,6 +144,13 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 }
+#else
+int copy_ipcs(unsigned long flags, struct task_struct *tsk)
+{
+	if (flags & CLONE_NEWIPC)
+		return -EINVAL;
+	return 0;
+}
 #endif
 
 /**
-- 
1.1.6
