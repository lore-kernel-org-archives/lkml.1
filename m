Return-Path: <linux-kernel-owner+w=401wt.eu-S1752240AbYKLQLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbYKLQLl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 11:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbYKLQLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 11:11:11 -0500
Received: from mx2.redhat.com ([66.187.237.31]:47095 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178AbYKLQLJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 11:11:09 -0500
From: Eric Paris <eparis@redhat.com>
Subject: [PATCH =-v3 05/21] fanotify: make use of the new fsnotify_open_exec
	calls
To: linux-kernel@vger.kernel.org, malware-list@lists.printk.net
Cc: viro@zeniv.linux.org.uk, alan@lxorguk.ukuu.org.uk, arjan@infradead.org,
       greg@kroah.com, tytso@mit.edu, akpm@linux-foundation.org
Date: Wed, 12 Nov 2008 11:10:53 -0500
Message-ID: <20081112161053.25434.14023.stgit@paris.rdu.redhat.com>
In-Reply-To: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
References: <20081112161002.25434.82358.stgit@paris.rdu.redhat.com>
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
index bf53881..894f573 100644
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

