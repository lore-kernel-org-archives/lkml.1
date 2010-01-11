Return-Path: <linux-kernel-owner+w=401wt.eu-S1754253Ab0AKV3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0AKV3d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 16:29:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753071Ab0AKV3a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 16:29:30 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:35373 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752530Ab0AKV1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 16:27:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=jzxfpnan9tdgKiboQm/A5b7PGlqT2egJBh0795RIPb0GM4+L4p+P0202tGpdJg88X5
         Upg90yF8LxHall7ryTeuTh5SKM5U1iKdCsfhSY9P+dlZ7SdOqEdQdCffiP+gjPeZipv7
         SQ+42xBLurUisQ607ERv0uJoxplwGi+NPro04=
From: John Kacur <jkacur@redhat.com>
To: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Subject: [PATCH 19/26] cgroups: Convert cgroups release_list_lock to raw_spinlock
Date: Mon, 11 Jan 2010 22:26:49 +0100
Message-Id: <1263245216-14754-20-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.6.5.2
In-Reply-To: <1263245216-14754-19-git-send-email-jkacur@redhat.com>
References: <1263245216-14754-1-git-send-email-jkacur@redhat.com>
 <1263245216-14754-2-git-send-email-jkacur@redhat.com>
 <1263245216-14754-3-git-send-email-jkacur@redhat.com>
 <1263245216-14754-4-git-send-email-jkacur@redhat.com>
 <1263245216-14754-5-git-send-email-jkacur@redhat.com>
 <1263245216-14754-6-git-send-email-jkacur@redhat.com>
 <1263245216-14754-7-git-send-email-jkacur@redhat.com>
 <1263245216-14754-8-git-send-email-jkacur@redhat.com>
 <1263245216-14754-9-git-send-email-jkacur@redhat.com>
 <1263245216-14754-10-git-send-email-jkacur@redhat.com>
 <1263245216-14754-11-git-send-email-jkacur@redhat.com>
 <1263245216-14754-12-git-send-email-jkacur@redhat.com>
 <1263245216-14754-13-git-send-email-jkacur@redhat.com>
 <1263245216-14754-14-git-send-email-jkacur@redhat.com>
 <1263245216-14754-15-git-send-email-jkacur@redhat.com>
 <1263245216-14754-16-git-send-email-jkacur@redhat.com>
 <1263245216-14754-17-git-send-email-jkacur@redhat.com>
 <1263245216-14754-18-git-send-email-jkacur@redhat.com>
 <1263245216-14754-19-git-send-email-jkacur@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert locks which cannot sleep in preempt-rt to raw_spinlocks

See also 58814bae5de64d5291b813ea0a52192e4fa714ad

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 kernel/cgroup.c |   18 +++++++++---------
 1 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0249f4b..32a80b2 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -204,7 +204,7 @@ list_for_each_entry(_root, &roots, root_list)
 /* the list of cgroups eligible for automatic release. Protected by
  * release_list_lock */
 static LIST_HEAD(release_list);
-static DEFINE_SPINLOCK(release_list_lock);
+static DEFINE_RAW_SPINLOCK(release_list_lock);
 static void cgroup_release_agent(struct work_struct *work);
 static DECLARE_WORK(release_agent_work, cgroup_release_agent);
 static void check_for_release(struct cgroup *cgrp);
@@ -3151,11 +3151,11 @@ again:
 	finish_wait(&cgroup_rmdir_waitq, &wait);
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	spin_lock(&release_list_lock);
+	raw_spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
 		list_del(&cgrp->release_list);
-	spin_unlock(&release_list_lock);
+	raw_spin_unlock(&release_list_lock);
 
 	cgroup_lock_hierarchy(cgrp->root);
 	/* delete this cgroup from parent->children */
@@ -3691,13 +3691,13 @@ static void check_for_release(struct cgroup *cgrp)
 		 * already queued for a userspace notification, queue
 		 * it now */
 		int need_schedule_work = 0;
-		spin_lock(&release_list_lock);
+		raw_spin_lock(&release_list_lock);
 		if (!cgroup_is_removed(cgrp) &&
 		    list_empty(&cgrp->release_list)) {
 			list_add(&cgrp->release_list, &release_list);
 			need_schedule_work = 1;
 		}
-		spin_unlock(&release_list_lock);
+		raw_spin_unlock(&release_list_lock);
 		if (need_schedule_work)
 			schedule_work(&release_agent_work);
 	}
@@ -3747,7 +3747,7 @@ static void cgroup_release_agent(struct work_struct *work)
 {
 	BUG_ON(work != &release_agent_work);
 	mutex_lock(&cgroup_mutex);
-	spin_lock(&release_list_lock);
+	raw_spin_lock(&release_list_lock);
 	while (!list_empty(&release_list)) {
 		char *argv[3], *envp[3];
 		int i;
@@ -3756,7 +3756,7 @@ static void cgroup_release_agent(struct work_struct *work)
 						    struct cgroup,
 						    release_list);
 		list_del_init(&cgrp->release_list);
-		spin_unlock(&release_list_lock);
+		raw_spin_unlock(&release_list_lock);
 		pathbuf = kmalloc(PAGE_SIZE, GFP_KERNEL);
 		if (!pathbuf)
 			goto continue_free;
@@ -3786,9 +3786,9 @@ static void cgroup_release_agent(struct work_struct *work)
  continue_free:
 		kfree(pathbuf);
 		kfree(agentbuf);
-		spin_lock(&release_list_lock);
+		raw_spin_lock(&release_list_lock);
 	}
-	spin_unlock(&release_list_lock);
+	raw_spin_unlock(&release_list_lock);
 	mutex_unlock(&cgroup_mutex);
 }
 
-- 
1.6.5.2

