Return-Path: <linux-kernel-owner+w=401wt.eu-S1760141AbXJDJe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760141AbXJDJe1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 05:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759679AbXJDJSm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 05:18:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58822 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757237AbXJDJSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 05:18:34 -0400
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Bob Peterson <rpeterso@redhat.com>,
       Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 44/51] [GFS2] GFS2: chmod hung - fix race in thread creation
Date: Thu,  4 Oct 2007 09:49:37 +0100
Message-Id: <1191487870444-git-send-email-swhiteho@redhat.com>
X-Mailer: git-send-email 1.5.1.2
In-Reply-To: <11914878683674-git-send-email-swhiteho@redhat.com>
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
 <1191487864951-git-send-email-swhiteho@redhat.com>
 <11914878661743-git-send-email-swhiteho@redhat.com>
 <11914878683674-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Peterson <rpeterso@redhat.com>

The problem boiled down to a race between the gdlm_init_threads()
function initializing thread1 and its setting of blist = 1.
Essentially, "if (current == ls->thread1)" was checked by the thread
before the thread creator set ls->thread1.

Since thread1 is the only thread who is allowed to work on the
blocking queue, and since neither thread thought it was thread1, no one
was working on the queue.  So everything just sat.

This patch reuses the ls->async_lock spin_lock to fix the race,
and it fixes the problem.  I've done more than 2000 iterations of the
loop that was recreating the failure and it seems to work.

Signed-off-by: Bob Peterson <rpeterso@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

--

diff --git a/fs/gfs2/locking/dlm/thread.c b/fs/gfs2/locking/dlm/thread.c
index 1aca51e..bd938f0 100644
--- a/fs/gfs2/locking/dlm/thread.c
+++ b/fs/gfs2/locking/dlm/thread.c
@@ -268,20 +268,16 @@ static inline int check_drop(struct gdlm_ls *ls)
 	return 0;
 }
 
-static int gdlm_thread(void *data)
+static int gdlm_thread(void *data, int blist)
 {
 	struct gdlm_ls *ls = (struct gdlm_ls *) data;
 	struct gdlm_lock *lp = NULL;
-	int blist = 0;
 	uint8_t complete, blocking, submit, drop;
 	DECLARE_WAITQUEUE(wait, current);
 
 	/* Only thread1 is allowed to do blocking callbacks since gfs
 	   may wait for a completion callback within a blocking cb. */
 
-	if (current == ls->thread1)
-		blist = 1;
-
 	while (!kthread_should_stop()) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		add_wait_queue(&ls->thread_wait, &wait);
@@ -333,12 +329,22 @@ static int gdlm_thread(void *data)
 	return 0;
 }
 
+static int gdlm_thread1(void *data)
+{
+	return gdlm_thread(data, 1);
+}
+
+static int gdlm_thread2(void *data)
+{
+	return gdlm_thread(data, 0);
+}
+
 int gdlm_init_threads(struct gdlm_ls *ls)
 {
 	struct task_struct *p;
 	int error;
 
-	p = kthread_run(gdlm_thread, ls, "lock_dlm1");
+	p = kthread_run(gdlm_thread1, ls, "lock_dlm1");
 	error = IS_ERR(p);
 	if (error) {
 		log_error("can't start lock_dlm1 thread %d", error);
@@ -346,7 +352,7 @@ int gdlm_init_threads(struct gdlm_ls *ls)
 	}
 	ls->thread1 = p;
 
-	p = kthread_run(gdlm_thread, ls, "lock_dlm2");
+	p = kthread_run(gdlm_thread2, ls, "lock_dlm2");
 	error = IS_ERR(p);
 	if (error) {
 		log_error("can't start lock_dlm2 thread %d", error);
-- 
1.5.1.2

