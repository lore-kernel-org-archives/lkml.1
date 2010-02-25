Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758924Ab0BYKMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Feb 2010 05:12:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:40855 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758908Ab0BYKMd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Feb 2010 05:12:33 -0500
Date: Thu, 25 Feb 2010 10:11:56 GMT
From: "tip-bot for Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com, hpa@zytor.com,
       mingo@redhat.com, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulmck@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
       mingo@elte.hu
In-Reply-To: <1266887105-1528-9-git-send-email-paulmck@linux.vnet.ibm.com>
References: <1266887105-1528-9-git-send-email-paulmck@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/rcu] vfs: Abstract rcu_dereference_check for files-fdtable use
Message-ID: <tip-af61b96b4f68f7ab25ebf34fed275fabf64f2edc@git.kernel.org>
Git-Commit-ID: af61b96b4f68f7ab25ebf34fed275fabf64f2edc
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 25 Feb 2010 10:11:56 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  af61b96b4f68f7ab25ebf34fed275fabf64f2edc
Gitweb:     http://git.kernel.org/tip/af61b96b4f68f7ab25ebf34fed275fabf64f2edc
Author:     Paul E. McKenney <paulmck@linux.vnet.ibm.com>
AuthorDate: Mon, 22 Feb 2010 17:04:53 -0800
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Thu, 25 Feb 2010 10:34:49 +0100

vfs: Abstract rcu_dereference_check for files-fdtable use

Create an rcu_dereference_check_fdtable() that encapsulates the
rcu_dereference_check() condition for fcheck_files() use.  This
has the beneficial side-effect of getting rid of a very long
line.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
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
LKML-Reference: <1266887105-1528-9-git-send-email-paulmck@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/fdtable.h |   11 +++++++----
 1 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/fdtable.h b/include/linux/fdtable.h
index 144412f..013dc52 100644
--- a/include/linux/fdtable.h
+++ b/include/linux/fdtable.h
@@ -57,11 +57,14 @@ struct files_struct {
 	struct file * fd_array[NR_OPEN_DEFAULT];
 };
 
-#define files_fdtable(files) \
-	(rcu_dereference_check((files)->fdt, \
+#define rcu_dereference_check_fdtable(files, fdtfd) \
+	(rcu_dereference_check((fdtfd), \
 			       rcu_read_lock_held() || \
 			       lockdep_is_held(&(files)->file_lock) || \
-			       atomic_read(&files->count) == 1))
+			       atomic_read(&(files)->count) == 1))
+
+#define files_fdtable(files) \
+		(rcu_dereference_check_fdtable((files), (files)->fdt))
 
 struct file_operations;
 struct vfsmount;
@@ -82,7 +85,7 @@ static inline struct file * fcheck_files(struct files_struct *files, unsigned in
 	struct fdtable *fdt = files_fdtable(files);
 
 	if (fd < fdt->max_fds)
-		file = rcu_dereference_check(fdt->fd[fd], rcu_read_lock_held() || lockdep_is_held(&files->file_lock) || atomic_read(&files->count) == 1);
+		file = rcu_dereference_check_fdtable(files, fdt->fd[fd]);
 	return file;
 }
 
