Return-Path: <linux-kernel-owner+w=401wt.eu-S1161408AbXEAKLl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161408AbXEAKLl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 06:11:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161664AbXEAKLk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 06:11:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:49677 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161408AbXEAKLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 06:11:38 -0400
Subject: [GFS2] Red Hat bz 228540: owner references [11/34]
From: Steven Whitehouse <swhiteho@redhat.com>
To: cluster-devel@redhat.com
Cc: linux-kernel@vger.kernel.org, Robert Peterson <rpeterso@redhat.com>
In-Reply-To: <1178013376.5462.127.camel@quoit.chygwyn.com>
References: <1178013376.5462.127.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
	3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 ITE
Date: Tue, 01 May 2007 11:07:03 +0100
Message-Id: <1178014023.5462.148.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 04b933f27bc8e7f3f6423020cec58a4eab3bb7a7 Mon Sep 17 00:00:00 2001
From: Robert Peterson <rpeterso@redhat.com>
Date: Fri, 23 Mar 2007 17:05:15 -0500
Subject: [PATCH] [GFS2] Red Hat bz 228540: owner references

In Testing the previously posted and accepted patch for
https://bugzilla.redhat.com/bugzilla/show_bug.cgi?id=228540
I uncovered some gfs2 badness.  It turns out that the current
gfs2 code saves off a process pointer when glocks is taken
in both the glock and glock holder structures.  Those
structures will persist in memory long after the process has
ended; pointers to poisoned memory.

This problem isn't caused by the 228540 fix; the new capability
introduced by the fix just uncovered the problem.

I wrote this patch that avoids saving process pointers
and instead saves off the process pid.  Rather than
referencing the bad pointers, it now does process lookups.
There is special code that makes the output nicer for
printing holder information for processes that have ended.

This patch also adds a stub for the new "sprint_symbol"
function that exists in Andrew Morton's -mm patch set, but
won't go into the base kernel until 2.6.22, since it adds
functionality but doesn't fix a bug.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index b8aa816..d2e3094 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -25,6 +25,8 @@
 #include <asm/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/debugfs.h>
+#include <linux/module.h>
+#include <linux/kallsyms.h>
 
 #include "gfs2.h"
 #include "incore.h"
@@ -54,6 +56,7 @@ struct glock_iter {
 typedef void (*glock_examiner) (struct gfs2_glock * gl);
 
 static int gfs2_dump_lockstate(struct gfs2_sbd *sdp);
+static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl);
 static void gfs2_glock_xmote_th(struct gfs2_glock *gl, struct gfs2_holder *gh);
 static void gfs2_glock_drop_th(struct gfs2_glock *gl);
 static DECLARE_RWSEM(gfs2_umount_flush_sem);
@@ -64,6 +67,7 @@ static struct dentry *gfs2_root;
 #define GFS2_GL_HASH_MASK       (GFS2_GL_HASH_SIZE - 1)
 
 static struct gfs2_gl_hash_bucket gl_hash_table[GFS2_GL_HASH_SIZE];
+static struct dentry *gfs2_root;
 
 /*
  * Despite what you might think, the numbers below are not arbitrary :-)
@@ -312,7 +316,7 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 	atomic_set(&gl->gl_ref, 1);
 	gl->gl_state = LM_ST_UNLOCKED;
 	gl->gl_hash = hash;
-	gl->gl_owner = NULL;
+	gl->gl_owner_pid = 0;
 	gl->gl_ip = 0;
 	gl->gl_ops = glops;
 	gl->gl_req_gh = NULL;
@@ -376,7 +380,7 @@ void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
 	INIT_LIST_HEAD(&gh->gh_list);
 	gh->gh_gl = gl;
 	gh->gh_ip = (unsigned long)__builtin_return_address(0);
-	gh->gh_owner = current;
+	gh->gh_owner_pid = current->pid;
 	gh->gh_state = state;
 	gh->gh_flags = flags;
 	gh->gh_error = 0;
@@ -601,7 +605,7 @@ static void gfs2_glmutex_lock(struct gfs2_glock *gl)
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
 		list_add_tail(&gh.gh_list, &gl->gl_waiters1);
 	} else {
-		gl->gl_owner = current;
+		gl->gl_owner_pid = current->pid;
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
 		clear_bit(HIF_WAIT, &gh.gh_iflags);
 		smp_mb();
@@ -628,7 +632,7 @@ static int gfs2_glmutex_trylock(struct gfs2_glock *gl)
 	if (test_and_set_bit(GLF_LOCK, &gl->gl_flags)) {
 		acquired = 0;
 	} else {
-		gl->gl_owner = current;
+		gl->gl_owner_pid = current->pid;
 		gl->gl_ip = (unsigned long)__builtin_return_address(0);
 	}
 	spin_unlock(&gl->gl_spin);
@@ -646,7 +650,7 @@ static void gfs2_glmutex_unlock(struct gfs2_glock *gl)
 {
 	spin_lock(&gl->gl_spin);
 	clear_bit(GLF_LOCK, &gl->gl_flags);
-	gl->gl_owner = NULL;
+	gl->gl_owner_pid = 0;
 	gl->gl_ip = 0;
 	run_queue(gl);
 	BUG_ON(!spin_is_locked(&gl->gl_spin));
@@ -999,12 +1003,12 @@ static int glock_wait_internal(struct gfs2_holder *gh)
 }
 
 static inline struct gfs2_holder *
-find_holder_by_owner(struct list_head *head, struct task_struct *owner)
+find_holder_by_owner(struct list_head *head, pid_t pid)
 {
 	struct gfs2_holder *gh;
 
 	list_for_each_entry(gh, head, gh_list) {
-		if (gh->gh_owner == owner)
+		if (gh->gh_owner_pid == pid)
 			return gh;
 	}
 
@@ -1036,24 +1040,24 @@ static void add_to_queue(struct gfs2_holder *gh)
 	struct gfs2_glock *gl = gh->gh_gl;
 	struct gfs2_holder *existing;
 
-	BUG_ON(!gh->gh_owner);
+	BUG_ON(!gh->gh_owner_pid);
 	if (test_and_set_bit(HIF_WAIT, &gh->gh_iflags))
 		BUG();
 
-	existing = find_holder_by_owner(&gl->gl_holders, gh->gh_owner);
+	existing = find_holder_by_owner(&gl->gl_holders, gh->gh_owner_pid);
 	if (existing) {
 		print_symbol(KERN_WARNING "original: %s\n", existing->gh_ip);
-		printk(KERN_INFO "pid : %d\n", existing->gh_owner->pid);
+		printk(KERN_INFO "pid : %d\n", existing->gh_owner_pid);
 		printk(KERN_INFO "lock type : %d lock state : %d\n",
 				existing->gh_gl->gl_name.ln_type, existing->gh_gl->gl_state);
 		print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
-		printk(KERN_INFO "pid : %d\n", gh->gh_owner->pid);
+		printk(KERN_INFO "pid : %d\n", gh->gh_owner_pid);
 		printk(KERN_INFO "lock type : %d lock state : %d\n",
 				gl->gl_name.ln_type, gl->gl_state);
 		BUG();
 	}
 
-	existing = find_holder_by_owner(&gl->gl_waiters3, gh->gh_owner);
+	existing = find_holder_by_owner(&gl->gl_waiters3, gh->gh_owner_pid);
 	if (existing) {
 		print_symbol(KERN_WARNING "original: %s\n", existing->gh_ip);
 		print_symbol(KERN_WARNING "new: %s\n", gh->gh_ip);
@@ -1756,6 +1760,22 @@ void gfs2_gl_hash_clear(struct gfs2_sbd *sdp, int wait)
  *  Diagnostic routines to help debug distributed deadlock
  */
 
+static void gfs2_print_symbol(struct glock_iter *gi, const char *fmt,
+                              unsigned long address)
+{
+/* when sprint_symbol becomes available in the new kernel, replace this */
+/* function with:
+        char buffer[KSYM_SYMBOL_LEN];
+
+        sprint_symbol(buffer, address);
+        print_dbg(gi, fmt, buffer);
+*/
+        if (gi)
+                print_dbg(gi, fmt, address);
+        else
+                print_symbol(fmt, address);
+}
+
 /**
  * dump_holder - print information about a glock holder
  * @str: a string naming the type of holder
@@ -1768,10 +1788,18 @@ static int dump_holder(struct glock_iter *gi, char *str,
 		       struct gfs2_holder *gh)
 {
 	unsigned int x;
+	struct task_struct *gh_owner;
 
 	print_dbg(gi, "  %s\n", str);
-	print_dbg(gi, "    owner = %ld\n",
-		   (gh->gh_owner) ? (long)gh->gh_owner->pid : -1);
+	if (gh->gh_owner_pid) {
+		print_dbg(gi, "    owner = %ld ", (long)gh->gh_owner_pid);
+		gh_owner = find_task_by_pid(gh->gh_owner_pid);
+		if (gh_owner)
+			print_dbg(gi, "(%s)\n", gh_owner->comm);
+		else
+			print_dbg(gi, "(ended)\n");
+	} else
+		print_dbg(gi, "    owner = -1\n");
 	print_dbg(gi, "    gh_state = %u\n", gh->gh_state);
 	print_dbg(gi, "    gh_flags =");
 	for (x = 0; x < 32; x++)
@@ -1784,10 +1812,7 @@ static int dump_holder(struct glock_iter *gi, char *str,
 		if (test_bit(x, &gh->gh_iflags))
 			print_dbg(gi, " %u", x);
 	print_dbg(gi, " \n");
-	if (gi)
-		print_dbg(gi, "    initialized at: 0x%x\n", gh->gh_ip);
-	else
-		print_symbol(KERN_INFO "    initialized at: %s\n", gh->gh_ip);
+        gfs2_print_symbol(gi, "    initialized at: %s\n", gh->gh_ip);
 
 	return 0;
 }
@@ -1828,6 +1853,7 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 	struct gfs2_holder *gh;
 	unsigned int x;
 	int error = -ENOBUFS;
+	struct task_struct *gl_owner;
 
 	spin_lock(&gl->gl_spin);
 
@@ -1838,10 +1864,21 @@ static int dump_glock(struct glock_iter *gi, struct gfs2_glock *gl)
 		if (test_bit(x, &gl->gl_flags))
 			print_dbg(gi, " %u", x);
 	}
+	if (!test_bit(GLF_LOCK, &gl->gl_flags))
+		print_dbg(gi, " (unlocked)");
 	print_dbg(gi, " \n");
 	print_dbg(gi, "  gl_ref = %d\n", atomic_read(&gl->gl_ref));
 	print_dbg(gi, "  gl_state = %u\n", gl->gl_state);
-	print_dbg(gi, "  gl_owner = %s\n", gl->gl_owner->comm);
+	if (gl->gl_owner_pid) {
+		gl_owner = find_task_by_pid(gl->gl_owner_pid);
+		if (gl_owner)
+			print_dbg(gi, "  gl_owner = pid %d (%s)\n",
+				  gl->gl_owner_pid, gl_owner->comm);
+		else
+			print_dbg(gi, "  gl_owner = %d (ended)\n",
+				  gl->gl_owner_pid);
+	} else
+		print_dbg(gi, "  gl_owner = -1\n");
 	print_dbg(gi, "  gl_ip = %lu\n", gl->gl_ip);
 	print_dbg(gi, "  req_gh = %s\n", (gl->gl_req_gh) ? "yes" : "no");
 	print_dbg(gi, "  req_bh = %s\n", (gl->gl_req_bh) ? "yes" : "no");
diff --git a/fs/gfs2/glock.h b/fs/gfs2/glock.h
index 5e662ea..11477ca 100644
--- a/fs/gfs2/glock.h
+++ b/fs/gfs2/glock.h
@@ -38,7 +38,7 @@ static inline int gfs2_glock_is_locked_by_me(struct gfs2_glock *gl)
 	/* Look in glock's list of holders for one with current task as owner */
 	spin_lock(&gl->gl_spin);
 	list_for_each_entry(gh, &gl->gl_holders, gh_list) {
-		if (gh->gh_owner == current) {
+		if (gh->gh_owner_pid == current->pid) {
 			locked = 1;
 			break;
 		}
diff --git a/fs/gfs2/incore.h b/fs/gfs2/incore.h
index 9c12582..fdf0470 100644
--- a/fs/gfs2/incore.h
+++ b/fs/gfs2/incore.h
@@ -127,7 +127,7 @@ struct gfs2_holder {
 	struct list_head gh_list;
 
 	struct gfs2_glock *gh_gl;
-	struct task_struct *gh_owner;
+	pid_t gh_owner_pid;
 	unsigned int gh_state;
 	unsigned gh_flags;
 
@@ -155,7 +155,7 @@ struct gfs2_glock {
 	unsigned int gl_hash;
 	unsigned int gl_demote_state; /* state requested by remote node */
 	unsigned long gl_demote_time; /* time of first demote request */
-	struct task_struct *gl_owner;
+	pid_t gl_owner_pid;
 	unsigned long gl_ip;
 	struct list_head gl_holders;
 	struct list_head gl_waiters1;	/* HIF_MUTEX */
-- 
1.5.1.2



