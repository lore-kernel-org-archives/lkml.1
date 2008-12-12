Return-Path: <linux-kernel-owner+w=401wt.eu-S1755882AbYLLVwp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882AbYLLVwp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2008 16:52:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755217AbYLLVvo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Dec 2008 16:51:44 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55946 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088AbYLLVvn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2008 16:51:43 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [RFC PATCH -v4 03/14] fsnotify: sys_execve and sys_uselib do not call
	into fsnotify
To: linux-kernel@vger.kernel.org
Cc: a.p.zijlstra@chello.nl, viro@ZenIV.linux.org.uk, hch@infradead.org,
       zbr@ioremap.net, akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk
Date: Fri, 12 Dec 2008 16:51:30 -0500
Message-ID: <20081212215130.27112.1396.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
References: <20081212213915.27112.57526.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_execve and sys_uselib do not call into fsnotify so inotify, dnotify,
and importantly to me fanotify do not see opens on things which are going
to be exectued.  Create a generic fsnotify hook for these paths.

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
index dec1afb..ffe787f 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -168,6 +168,13 @@ static inline void fsnotify_modify(struct file *file)
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
 static inline void fsnotify_open(struct file *file)

