Return-Path: <linux-kernel-owner+w=401wt.eu-S1756079AbYLOQo5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079AbYLOQo5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 11:44:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755430AbYLOQoS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 11:44:18 -0500
Received: from mx2.redhat.com ([66.187.237.31]:48623 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755351AbYLOQoR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 11:44:17 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH 2/3] fsnotify: sys_execve and sys_uselib do not call into
	fsnotify
To: linux-kernel@vger.kernel.org
Cc: hch@infradead.org, akpm@linux-foundation.org
Date: Mon, 15 Dec 2008 11:44:14 -0500
Message-ID: <20081215164414.2018.66642.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
References: <20081215164016.2018.4813.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_execve and sys_uselib do not call into fsnotify so inotify and dnotify do
not see opens on things which are going to be exectued.  This patch creates a
generic fsnotify hook for these operations

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 fs/exec.c                |    5 +++++
 include/linux/fsnotify.h |    7 +++++++
 2 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/fs/exec.c b/fs/exec.c
index ec5df9a..8a659a8 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -51,6 +51,7 @@
 #include <linux/audit.h>
 #include <linux/tracehook.h>
 #include <linux/kmod.h>
+#include <linux/fsnotify.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -135,6 +136,8 @@ asmlinkage long sys_uselib(const char __user * library)
 	if (IS_ERR(file))
 		goto out;
 
+	fsnotify_open_exec(file);
+
 	error = -ENOEXEC;
 	if(file->f_op) {
 		struct linux_binfmt * fmt;
@@ -687,6 +690,8 @@ struct file *open_exec(const char *name)
 	if (IS_ERR(file))
 		return file;
 
+	fsnotify_open_exec(file);
+
 	err = deny_write_access(file);
 	if (err) {
 		fput(file);
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 00fbd5b..88265dd 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -166,6 +166,13 @@ static inline void fsnotify_modify(struct dentry *dentry)
 }
 
 /*
+ * fsnotify_open_exec - file was opened by execve or uselib
+ */
+static inline void fsnotify_open_exec(struct file *file)
+{
+}
+
+/*
  * fsnotify_open - file was opened
  */
 static inline void fsnotify_open(struct dentry *dentry)

