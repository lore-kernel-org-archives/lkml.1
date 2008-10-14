Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYJNUwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYJNUwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 16:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753125AbYJNUwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 16:52:11 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37721 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708AbYJNUwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 16:52:09 -0400
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH -v2 05/16] fanotify: make use of the new fsnotify_open_exec
	calls
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@ZenIV.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu
Date: Tue, 14 Oct 2008 16:51:56 -0400
Message-ID: <20081014205156.1057.12119.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
References: <20081014205009.1057.12041.stgit@paris.rdu.redhat.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This function sends fanotify events for opens which we know are being used
for exec.  These are basically just systecalls to sys_execve and sys_uselib

Signed-off-by: Eric Paris <eparis@redhat.com>
---

 include/linux/fanotify.h |    4 +++-
 include/linux/fsnotify.h |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/include/linux/fanotify.h b/include/linux/fanotify.h
index 7f1179e..c991bd9 100644
--- a/include/linux/fanotify.h
+++ b/include/linux/fanotify.h
@@ -14,13 +14,15 @@
 #define FAN_MODIFY		0x00000002	/* File was modified */
 #define FAN_CLOSE_NOWRITE	0x00000004	/* Unwrittable file closed */
 #define FAN_CLOSE_WRITE		0x00000008	/* Writtable file closed */
-#define FAN_OPEN		0x00000010	/* File was opened */
+#define FAN_OPEN_NOEXEC		0x00000010	/* File was opened */
+#define FAN_OPEN_EXEC		0x00000020	/* File was opened with the intention of being exec'ed */
 
 /* FIXME currently Q's have no limit.... */
 #define FAN_Q_OVERFLOW		0x80000000	/* Event queued overflowed */
 
 /* helper events */
 #define FAN_CLOSE		(FAN_CLOSE_WRITE | FAN_CLOSE_NOWRITE) /* close */
+#define FAN_OPEN		(FAN_OPEN_NOEXEC | FAN_OPEN_EXEC) /* open */
 
 /*
  * All of the events - we build the list by hand so that we can add flags in
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 6fc4160..ccee5ea 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -175,6 +175,7 @@ static inline void fsnotify_modify(struct file *file)
  */
 static inline void fsnotify_open_exec(struct file *file)
 {
+	fanotify(file, FAN_OPEN_EXEC);
 }
 
 /*
@@ -191,7 +192,7 @@ static inline void fsnotify_open(struct file *file)
 
 	inotify_dentry_parent_queue_event(dentry, mask, 0, dentry->d_name.name);
 	inotify_inode_queue_event(inode, mask, 0, NULL, NULL);
-	fanotify(file, FAN_OPEN);
+	fanotify(file, FAN_OPEN_NOEXEC);
 }
 
 /*

