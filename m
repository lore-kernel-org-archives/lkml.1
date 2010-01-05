Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754399Ab0AECEn (ORCPT <rfc822;list-kernel77@spinics.net>);
	Mon, 4 Jan 2010 21:04:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754293Ab0AECEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 21:04:20 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:40284 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162Ab0AECEQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 21:04:16 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH tip/core/rcu 6/8] vfs: apply lockdep-based checking to rcu_dereference() uses
Date: Mon,  4 Jan 2010 18:04:09 -0800
Message-Id: <12626570514009-git-send-email->
X-Mailer: git-send-email 1.5.2.5
In-Reply-To: <20100105020345.GA32114@linux.vnet.ibm.com>
References: <20100105020345.GA32114@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Add lockdep-ified RCU primitives to alloc_fd(), files_fdtable() and
fcheck_files().

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 fs/file.c               |    2 +-
 include/linux/fdtable.h |    7 +++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/file.c b/fs/file.c
index f313314..c506bc6 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -477,7 +477,7 @@ repeat:
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
 
-- 
1.5.2.5

