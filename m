Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928Ab0BQUaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 15:30:23 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:37058 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab0BQUaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 15:30:14 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 09/18] vfs: abstract rcu_dereference_check for files-fdtable use
Date: Wed, 17 Feb 2010 12:29:35 -0800
Message-Id: <1266438584-29173-9-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100217202924.GA29007@linux.vnet.ibm.com>
References: <20100217202924.GA29007@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Create an rcu_dereference_check_fdtable() that encapsulates the
rcu_dereference_check() condition for fcheck_files() use.  This has
the beneficial side-effect of getting rid of a very long line.

Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
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
 
-- 
1.6.6

