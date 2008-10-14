Return-Path: <linux-kernel-owner+w=401wt.eu-S1755650AbYJNUyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650AbYJNUyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:54:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754880AbYJNUwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:52:32 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37761 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753168AbYJNUwZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:52:25 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 04/16] fsnotify: sys_execve and sys_uselib do not call
	into fsnotify
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:51:51 -0400
Message-ID: <20081014205151.1057.62029.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
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
index cecee50..3612805 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -50,6 +50,7 @@
 #include <linux/cn_proc.h>
 #include <linux/audit.h>
 #include <linux/tracehook.h>
+#include <linux/fsnotify.h>
 
 #include <asm/uaccess.h>
 #include <asm/mmu_context.h>
@@ -138,6 +139,8 @@ asmlinkage long sys_uselib(const char __user * library)
 	if (IS_ERR(file))
 		goto out;
 
+	fsnotify_open_exec(file);
+
 	error = -ENOEXEC;
 	if(file->f_op) {
 		struct linux_binfmt * fmt;
@@ -690,6 +693,8 @@ struct file *open_exec(const char *name)
 	if (IS_ERR(file))
 		return file;
 
+	fsnotify_open_exec(file);
+
 	err = deny_write_access(file);
 	if (err) {
 		fput(file);
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 50d8d8b..6fc4160 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -171,6 +171,13 @@ static inline void fsnotify_modify(struct file *file)
 }
 
 /*
+ * fsnotify_open_exec - file was opened by execve of uselib
+ */
+static inline void fsnotify_open_exec(struct file *file)
+{
+}
+
+/*
  * fsnotify_open - file was opened
  */
 static inline void fsnotify_open(struct file *file)

