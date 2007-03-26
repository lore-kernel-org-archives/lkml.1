Return-Path: <linux-kernel-owner+w=401wt.eu-S1753689AbXCZSwg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753689AbXCZSwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2007 14:52:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXCZSwg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Mar 2007 14:52:36 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:38670 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753689AbXCZSwf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2007 14:52:35 -0400
Date: Mon, 26 Mar 2007 13:52:30 -0500
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: dev@openvz.org, "Eric W. Biederman" <ebiederm@xmission.com>,
       Badari Pulavarty <badari@us.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] ipcns [-mm]: fix !CONFIG_IPC_NS behavior
Message-ID: <20070326185230.GD11465@sergelap.austin.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Serge E. Hallyn" <serue@us.ibm.com>
Subject: [PATCH] ipcns [-mm]: fix !CONFIG_IPC_NS behavior

When CONFIG_IPC_NS=n, clone(CLONE_NEWIPC) claims success, but did not actually
clone a new IPC namespace.

Fix this to return -EINVAL so the caller knows his request was denied.

Signed-off-by: Serge E. Hallyn <serue@us.ibm.com>

---

 include/linux/ipc.h |   10 ++--------
 ipc/util.c          |    7 +++++++
 2 files changed, 9 insertions(+), 8 deletions(-)

f4a39c8d20b36d6eebdab0984d55e13ecb2cf446
diff --git a/include/linux/ipc.h b/include/linux/ipc.h
index ae484cd..d3072f8 100644
--- a/include/linux/ipc.h
+++ b/include/linux/ipc.h
@@ -96,16 +96,10 @@ extern struct ipc_namespace init_ipc_ns;
 #define INIT_IPC_NS(ns)
 #endif
 
-#ifdef CONFIG_IPC_NS
-extern void free_ipc_ns(struct kref *kref);
 extern struct ipc_namespace *copy_ipcs(unsigned long flags,
 		struct ipc_namespace *ns);
-#else
-static inline struct ipc_namespace *copy_ipcs(unsigned long flags,
-		struct ipc_namespace *ns)
-{
-	return ns;
-}
+#ifdef CONFIG_IPC_NS
+extern void free_ipc_ns(struct kref *kref);
 #endif
 
 static inline struct ipc_namespace *get_ipc_ns(struct ipc_namespace *ns)
diff --git a/ipc/util.c b/ipc/util.c
index 8f323b3..0ad5b1c 100644
--- a/ipc/util.c
+++ b/ipc/util.c
@@ -111,6 +111,13 @@ void free_ipc_ns(struct kref *kref)
 	shm_exit_ns(ns);
 	kfree(ns);
 }
+#else
+struct ipc_namespace *copy_ipcs(unsigned long flags, struct ipc_namespace *ns)
+{
+	if (flags & CLONE_NEWIPC)
+		return ERR_PTR(-EINVAL);
+	return ns;
+}
 #endif
 
 /**
-- 
1.1.6
