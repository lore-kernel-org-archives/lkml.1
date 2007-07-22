Return-Path: <linux-kernel-owner+w=401wt.eu-S1762332AbXGVSrb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762332AbXGVSrb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 14:47:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758652AbXGVSrY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 14:47:24 -0400
Received: from static-141-230-6-89.ipcom.comunitel.net ([89.6.230.141]:37178
	"EHLO traven.no-ip.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758627AbXGVSrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 14:47:23 -0400
Date: Sun, 22 Jul 2007 20:49:13 +0200
From: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 1/5] kernel/exit.c: Use list_for_each_entry(_safe) instead of list_for_each(_safe)
Message-ID: <20070722184913.GG27415@traven>
Mail-Followup-To: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>,
	torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
References: <20070722184202.GF27415@traven>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070722184202.GF27415@traven>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

kernel/exit.c: Convert list_for_each(_safe) to
list_for_each_entry(_safe) in forget_original_parent(), exit_notify()
and do_wait()

Signed-off-by: Matthias Kaehlcke <matthias.kaehlcke@gmail.com>

--

diff --git a/kernel/exit.c b/kernel/exit.c
index ca6a11b..ac84684 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -680,8 +680,7 @@ reparent_thread(struct task_struct *p, struct task_struct *father, int traced)
 static void
 forget_original_parent(struct task_struct *father, struct list_head *to_release)
 {
-	struct task_struct *p, *reaper = father;
-	struct list_head *_p, *_n;
+	struct task_struct *p, *n, *reaper = father;
 
 	do {
 		reaper = next_thread(reaper);
@@ -699,9 +698,8 @@ forget_original_parent(struct task_struct *father, struct list_head *to_release)
 	 *
 	 * Search them and reparent children.
 	 */
-	list_for_each_safe(_p, _n, &father->children) {
+	list_for_each_entry_safe(p, n, &father->children, sibling) {
 		int ptrace;
-		p = list_entry(_p, struct task_struct, sibling);
 
 		ptrace = p->ptrace;
 
@@ -729,8 +727,7 @@ forget_original_parent(struct task_struct *father, struct list_head *to_release)
 		if (unlikely(ptrace && p->exit_state == EXIT_ZOMBIE && p->exit_signal == -1))
 			list_add(&p->ptrace_list, to_release);
 	}
-	list_for_each_safe(_p, _n, &father->ptrace_children) {
-		p = list_entry(_p, struct task_struct, ptrace_list);
+	list_for_each_entry_safe(p, n, &father->ptrace_children, ptrace_list) {
 		choose_new_parent(p, reaper);
 		reparent_thread(p, father, 1);
 	}
@@ -1502,12 +1499,9 @@ repeat:
 	tsk = current;
 	do {
 		struct task_struct *p;
-		struct list_head *_p;
 		int ret;
 
-		list_for_each(_p,&tsk->children) {
-			p = list_entry(_p, struct task_struct, sibling);
-
+		list_for_each_entry(p, &tsk->children, sibling) {
 			ret = eligible_child(pid, options, p);
 			if (!ret)
 				continue;
@@ -1589,9 +1583,8 @@ check_continued:
 			}
 		}
 		if (!flag) {
-			list_for_each(_p, &tsk->ptrace_children) {
-				p = list_entry(_p, struct task_struct,
-						ptrace_list);
+			list_for_each_entry(p, &tsk->ptrace_children,
+					    ptrace_list) {
 				if (!eligible_child(pid, options, p))
 					continue;
 				flag = 1;

-- 
Matthias Kaehlcke
Linux Application Developer
Barcelona

             If liberty means anything at all, it means the
           right to tell people what they do not want to hear
                            (George Orwell)
                                                                 .''`.
    using free software / Debian GNU/Linux | http://debian.org  : :'  :
                                                                `. `'`
gpg --keyserver pgp.mit.edu --recv-keys 47D8E5D4                  `-
