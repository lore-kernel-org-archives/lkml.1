Return-Path: <linux-kernel-owner+w=401wt.eu-S1761338AbXJDJdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761338AbXJDJdS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759641AbXJDJSi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:38 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759600AbXJDJS3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:29 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Abhijith Das <adas@redhat.com>, Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 41/51] [GFS2] flocks from same process trip kernel BUG at fs/gfs2/glock.c:1118!
Date: Thu,  4 Oct 2007 09:49:34 +0100
Message-Id: <1191487864951-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878632211-git-send-email-swhiteho@redhat.com>
References: <11914877842142-git-send-email-swhiteho@redhat.com>
 <11914877912880-git-send-email-swhiteho@redhat.com>
 <11914877934041-git-send-email-swhiteho@redhat.com>
 <11914877952291-git-send-email-swhiteho@redhat.com>
 <11914877971413-git-send-email-swhiteho@redhat.com>
 <11914877993073-git-send-email-swhiteho@redhat.com>
 <11914878002186-git-send-email-swhiteho@redhat.com>
 <1191487802255-git-send-email-swhiteho@redhat.com>
 <11914878043598-git-send-email-swhiteho@redhat.com>
 <11914878063121-git-send-email-swhiteho@redhat.com>
 <11914878081562-git-send-email-swhiteho@redhat.com>
 <11914878102813-git-send-email-swhiteho@redhat.com>
 <1191487812928-git-send-email-swhiteho@redhat.com>
 <11914878141625-git-send-email-swhiteho@redhat.com>
 <1191487815172-git-send-email-swhiteho@redhat.com>
 <11914878173677-git-send-email-swhiteho@redhat.com>
 <11914878191964-git-send-email-swhiteho@redhat.com>
 <11914878214113-git-send-email-swhiteho@redhat.com>
 <11914878231394-git-send-email-swhiteho@redhat.com>
 <11914878252873-git-send-email-swhiteho@redhat.com>
 <11914878271468-git-send-email-swhiteho@redhat.com>
 <11914878283252-git-send-email-swhiteho@redhat.com>
 <11914878304004-git-send-email-swhiteho@redhat.com>
 <11914878323899-git-send-email-swhiteho@redhat.com>
 <11914878342921-git-send-email-swhiteho@redhat.com>
 <11914878361239-git-send-email-swhiteho@redhat.com>
 <11914878383633-git-send-email-swhiteho@redhat.com>
 <11914878401428-git-send-email-swhiteho@redhat.com>
 <11914878422398-git-send-email-swhiteho@redhat.com>
 <1191487844772-git-send-email-swhiteho@redhat.com>
 <1191487846406-git-send-email-swhiteho@redhat.com>
 <11914878472056-git-send-email-swhiteho@redhat.com>
 <11914878492645-git-send-email-swhiteho@redhat.com>
 <11914878513555-git-send-email-swhiteho@redhat.com>
 <11914878521254-git-send-email-swhiteho@redhat.com>
 <119148785427-git-send-email-swhiteho@redhat.com>
 <11914878551328-git-send-email-swhiteho@redhat.com>
 <11914878571888-git-send-email-swhiteho@redhat.com>
 <11914878592314-git-send-email-swhiteho@redhat.com>
 <1191487861683-git-send-email-swhiteho@redhat.com>
 <11914878632211-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Abhijith Das <adas@redhat.com>

This patch adds a new flag to the gfs2_holder structure GL_FLOCK.
It is set on holders of glocks representing flocks. This flag is
checked in add_to_queue() and a process is permitted to queue more
than one holder onto a glock if it is set. This solves the issue
of a process not being able to do multiple flocks on the same file.
Through a single descriptor, a process can now promote and demote
flocks. Through multiple descriptors a process can now queue
multiple flocks on the same file. There's still the problem of
a process deadlocking itself (because gfs2 blocking locks are not
interruptible) by queueing incompatible deadlock.

Signed-off-by: Abhijith Das <adas@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index 931368a..d631cad 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1106,24 +1106,31 @@ static void add_to_queue(struct gfs2_holder *gh)
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
 		BUG();
 
-	existing = find_holder_by_owner(&gl->gl_holders, gh->gh_owner_pid);
-	if (existing) {
-		print_symbol(KERN_WARNING "original: %s\n", existing->gh_ip);
-		printk(KERN_INFO "pid : %d\n", existing->gh_owner_pid);
-		printk(KERN_INFO "lock type : %d lock state : %d\n",
-				existing->gh_gl->gl_name.ln_type, existing->gh_gl->gl_state);
-		print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
-		printk(KERN_INFO "pid : %d\n", gh->gh_owner_pid);
-		printk(KERN_INFO "lock type : %d lock state : %d\n",
-				gl->gl_name.ln_type, gl->gl_state);
-		BUG();
-	}
-
-	existing = find_holder_by_owner(&gl->gl_waiters3, gh->gh_owner_pid);
-	if (existing) {
-		print_symbol(KERN_WARNING "original: %s\n", existing->gh_ip);
-		print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
-		BUG();
+	if (!(gh->gh_flags & GL_FLOCK)) {
+		existing = find_holder_by_owner(&gl->gl_holders, 
+						gh->gh_owner_pid);
+		if (existing) {
+			print_symbol(KERN_WARNING "original: %s\n", 
+				     existing->gh_ip);
+			printk(KERN_INFO "pid : %d\n", existing->gh_owner_pid);
+			printk(KERN_INFO "lock type : %d lock state : %d\n",
+			       existing->gh_gl->gl_name.ln_type, 
+			       existing->gh_gl->gl_state);
+			print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
+			printk(KERN_INFO "pid : %d\n", gh->gh_owner_pid);
+			printk(KERN_INFO "lock type : %d lock state : %d\n",
+			       gl->gl_name.ln_type, gl->gl_state);
+			BUG();
+		}
+		
+		existing = find_holder_by_owner(&gl->gl_waiters3, 
+						gh->gh_owner_pid);
+		if (existing) {
+			print_symbol(KERN_WARNING "original: %s\n", 
+				     existing->gh_ip);
+			print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
+			BUG();
+		}
 	}
 
 	if (gh->gh_flags & LM_FLAG_PRIORITY)
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index f7a8e62..b16f604 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -26,6 +26,7 @@
 #define GL_SKIP			0x00000100
 #define GL_ATIME		0x00000200
 #define GL_NOCACHE		0x00000400
+#define GL_FLOCK		0x00000800
 #define GL_NOCANCEL		0x00001000
 
 #define GLR_TRYFAILED		13
diff --git a/fs/gfs2/ops_file.c b/fs/gfs2/ops_file.c
index 94d76ac..46a9e10 100644
--- a/fs/gfs2/ops_file.c
+++ b/fs/gfs2/ops_file.c
@@ -571,7 +571,8 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 	int error = 0;
 
 	state = (fl->fl_type == F_WRLCK) ? LM_ST_EXCLUSIVE : LM_ST_SHARED;
-	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE;
+	flags = (IS_SETLKW(cmd) ? 0 : LM_FLAG_TRY) | GL_EXACT | GL_NOCACHE 
+		| GL_FLOCK;
 
 	mutex_lock(&fp->f_fl_mutex);
 
@@ -579,21 +580,19 @@ static int do_flock(struct file *file, int cmd, struct file_lock *fl)
 	if (gl) {
 		if (fl_gh->gh_state == state)
 			goto out;
-		gfs2_glock_hold(gl);
 		flock_lock_file_wait(file,
 				     &(struct file_lock){.fl_type = F_UNLCK});
-		gfs2_glock_dq_uninit(fl_gh);
+		gfs2_glock_dq_wait(fl_gh);
+		gfs2_holder_reinit(state, flags, fl_gh);
 	} else {
 		error = gfs2_glock_get(GFS2_SB(&ip->i_inode),
 				      ip->i_no_addr, &gfs2_flock_glops,
 				      CREATE, &gl);
 		if (error)
 			goto out;
+		gfs2_holder_init(gl, state, flags, fl_gh);
+		gfs2_glock_put(gl);
 	}
-
-	gfs2_holder_init(gl, state, flags, fl_gh);
-	gfs2_glock_put(gl);
-
 	error = gfs2_glock_nq(fl_gh);
 	if (error) {
 		gfs2_holder_uninit(fl_gh);
-- 
1.5.1.2

