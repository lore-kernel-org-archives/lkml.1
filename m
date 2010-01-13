Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624Ab0AMKcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624Ab0AMKcq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 05:32:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755628Ab0AMKco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 05:32:44 -0500
Received: from hera.kernel.org ([140.211.167.34]:34372 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755485Ab0AMKcl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 05:32:41 -0500
Date: Wed, 13 Jan 2010 10:30:34 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, tglx@linutronix.de, viro@zeniv.linux.org.uk,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de,
       viro@zeniv.linux.org.uk, mingo@elte.hu
In-Reply-To: <12626570514009-git-send-email->
References: <12626570514009-git-send-email->
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] vfs: Apply lockdep-based checking to rcu_dereference() uses
Message-ID: <tip-9080561f06a244fdc3c644c2524d87e819c45232@git.kernel.org>
Git-Commit-ID: 9080561f06a244fdc3c644c2524d87e819c45232
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 13 Jan 2010 10:30:35 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9080561f06a244fdc3c644c2524d87e819c45232
Gitweb:     http://git.kernel.org/tip/9080561f06a244fdc3c644c2524d87e819c45232
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 4 Jan 2010 18:04:09 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 13 Jan 2010 09:42:36 +0100

vfs: Apply lockdep-based checking to rcu_dereference() uses

Add lockdep-ified RCU primitives to alloc_fd(), files_fdtable()
and fcheck_files().

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: laijs@cn.fujitsu.com
Cc: dipankar@in.ibm.com
Cc: mathieu.desnoyers@polymtl.ca
Cc: josh@joshtriplett.org
Cc: dvhltc@us.ibm.com
Cc: niv@us.ibm.com
Cc: peterz@infradead.org
Cc: rostedt@goodmis.org
Cc: Valdis.Kletnieks@vt.edu
Cc: dhowells@redhat.com
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
LKML-Reference: <12626570514009-git-send-email->
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 fs/file.c               |    2 +-
 include/linux/fdtable.h |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index 87e1290..38039af 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -478,7 +478,7 @@ repeat:
 	error = fd;
 #if 1
 	/* Sanity check */
-	if (rcu_dereference(fdt->fd[fd]) != NULL) {
+	if (rcu_dereference_raw(fdt->fd[fd]) != NULL) {
 		printk(KERN_WARNING "alloc_fd: slot %d not NULL!\n", fd);
 		rcu_assign_pointer(fdt->fd[fd], NULL);
 	}
diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index a2ec74b..e498a0c 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,7 +57,10 @@ struct files_struct {
 	struct file * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define files_fdtable(files) (rcu_dereference((files)->fdt))
+#define files_fdtable(files) \
+	(rcu_dereference_check((files)->fdt, \
+			       rcu_read_lock_held() || \
+			       lockdep_is_held(&(files)->file_lock)))
 
 struct file_operations;
 struct vfsmount;
@@ -78,7 +81,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference(fdt->fd[fd]);
+		file = rcu_dereference_check(fdt->fd[fd], rcu_read_lock_held() || lockdep_is_held(&files->file_lock));
 	return file;
 }
 
