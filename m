Return-Path: <linux-kernel-owner+w=401wt.eu-S1751871AbZGJBwS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbZGJBwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 21:52:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750732AbZGJBwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 21:52:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46218 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbZGJBwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 21:52:07 -0400
Date: Fri, 10 Jul 2009 03:48:23 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Howells <dhowells@redhat.com>, James Morris <jmorris@namei.org>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Roland McGrath <roland@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 -mm 1/2] rename is_single_threaded(task) to
	current_is_single_threaded(void)
Message-ID: <20090710014823.GB4723@redhat.com>
References: <20090709212847.GA10238@redhat.com> <20090710013322.GA27719@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090710013322.GA27719@infradead.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(on top of rework-fix-is_single_threaded.patch)

- is_single_threaded(task) is not safe unless task == current,
  we can't use task->signal or task->mm.

- it doesn't make sense unless task == current, the task can
  fork right after the check.

Rename it to current_is_single_threaded() and kill the argument.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: James Morris <jmorris@namei.org>
---

 include/linux/sched.h        |    2 +-
 lib/is_single_threaded.c     |    3 ++-
 security/selinux/hooks.c     |    2 +-
 security/keys/process_keys.c |    2 +-
 4 files changed, 5 insertions(+), 4 deletions(-)

--- WAIT/include/linux/sched.h~ISS_1_RENAME	2009-07-01 20:20:57.000000000 +0200
+++ WAIT/include/linux/sched.h	2009-07-09 22:14:21.000000000 +0200
@@ -2055,7 +2055,7 @@ static inline unsigned long wait_task_in
 #define for_each_process(p) \
 	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
 
-extern bool is_single_threaded(struct task_struct *);
+extern bool current_is_single_threaded(void);
 
 /*
  * Careful: do_each_thread/while_each_thread is a double loop so
--- WAIT/lib/is_single_threaded.c~ISS_1_RENAME	2009-07-09 19:43:27.000000000 +0200
+++ WAIT/lib/is_single_threaded.c	2009-07-09 22:16:29.000000000 +0200
@@ -15,8 +15,9 @@
 /*
  * Returns true if the task does not share ->mm with another thread/process.
  */
-bool is_single_threaded(struct task_struct *task)
+bool current_is_single_threaded(void)
 {
+	struct task_struct *task = current;
 	struct mm_struct *mm = task->mm;
 	struct task_struct *p, *t;
 	bool ret;
--- WAIT/security/selinux/hooks.c~ISS_1_RENAME	2009-07-03 11:15:08.000000000 +0200
+++ WAIT/security/selinux/hooks.c	2009-07-09 22:17:58.000000000 +0200
@@ -5182,7 +5182,7 @@ static int selinux_setprocattr(struct ta
 
 		/* Only allow single threaded processes to change context */
 		error = -EPERM;
-		if (!is_single_threaded(p)) {
+		if (!current_is_single_threaded()) {
 			error = security_bounded_transition(tsec->sid, sid);
 			if (error)
 				goto abort_change;
--- WAIT/security/keys/process_keys.c~ISS_1_RENAME	2009-04-06 00:03:42.000000000 +0200
+++ WAIT/security/keys/process_keys.c	2009-07-09 22:18:31.000000000 +0200
@@ -702,7 +702,7 @@ long join_session_keyring(const char *na
 	/* only permit this if there's a single thread in the thread group -
 	 * this avoids us having to adjust the creds on all threads and risking
 	 * ENOMEM */
-	if (!is_single_threaded(current))
+	if (!current_is_single_threaded())
 		return -EMLINK;
 
 	new = prepare_creds();

