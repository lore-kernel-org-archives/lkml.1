Return-Path: <linux-kernel-owner+w=401wt.eu-S1754396AbYKYRXx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754396AbYKYRXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 12:23:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752629AbYKYRV7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 12:21:59 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53952 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbYKYRV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 12:21:58 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v3 3/8] fsnotify: sys_execve and sys_uselib do not call into
	fsnotify
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, arjan@infradead.org, hch@infradead.org,
       a.p.zijlstra@chello.nl
Date: Tue, 25 Nov 2008 12:21:07 -0500
Message-ID: <20081125172107.17115.98087.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
References: <20081125171714.17115.82625.stgit@paris.rdu.redhat.com>
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
index 4e834f1..8f56995 100644
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

