Return-Path: <linux-kernel-owner+w=401wt.eu-S1757432AbYHSXXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432AbYHSXXu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 19:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHSXWl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 19:22:41 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:52588 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753480AbYHSXWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 19:22:40 -0400
Message-Id: <20080819232234.999956217@us.ibm.com>
References: <20080819232232.432973784@us.ibm.com>
User-Agent: quilt/0.46-1
Date: Tue, 19 Aug 2008 16:22:37 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Paul Menage <menage@google.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
Subject: [PATCH 5/6] Container Freezer: Rename check_if_frozen()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

check_if_frozen() sounds like it should return something when in fact it's just
updating the freezer state.

Signed-off-by: Matt Helsley <matthltc@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 kernel/cgroup_freezer.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

Index: linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
===================================================================
--- linux-2.6.27-rc1-mm1.orig/kernel/cgroup_freezer.c
+++ linux-2.6.27-rc1-mm1/kernel/cgroup_freezer.c
@@ -201,8 +201,8 @@ static void freezer_fork(struct cgroup_s
 /*
  * caller must hold freezer->lock
  */
-static void check_if_frozen(struct cgroup *cgroup,
-			     struct freezer *freezer)
+static void update_freezer_state(struct cgroup *cgroup,
+				 struct freezer *freezer)
 {
 	struct cgroup_iter it;
 	struct task_struct *task;
@@ -222,6 +222,10 @@ static void check_if_frozen(struct cgrou
 	 */
 	if (nfrozen == ntotal)
 		freezer->state = CGROUP_FROZEN;
+	else if (nfrozen > 0)
+		freezer->state = CGROUP_FREEZING;
+	else
+		freezer->state = CGROUP_THAWED;
 	cgroup_iter_end(cgroup, &it);
 }
 
@@ -240,7 +244,7 @@ static int freezer_read(struct cgroup *c
 	if (state == CGROUP_FREEZING) {
 		/* We change from FREEZING to FROZEN lazily if the cgroup was
 		 * only partially frozen when we exitted write. */
-		check_if_frozen(cgroup, freezer);
+		update_freezer_state(cgroup, freezer);
 		state = freezer->state;
 	}
 	spin_unlock_irq(&freezer->lock);
@@ -301,7 +305,7 @@ static int freezer_change_state(struct c
 
 	freezer = cgroup_freezer(cgroup);
 	spin_lock_irq(&freezer->lock);
-	check_if_frozen(cgroup, freezer); /* may update freezer->state */
+	update_freezer_state(cgroup, freezer);
 	if (goal_state == freezer->state)
 		goto out;
 	switch (freezer->state) {

-- 
