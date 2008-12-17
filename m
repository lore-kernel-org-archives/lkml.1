Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1760698AbYLQMiD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760698AbYLQMiD (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 17 Dec 2008 07:38:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbYLQM3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Dec 2008 07:29:38 -0500
Received: from mx2.redhat.com ([66.187.237.31]:53755 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020AbYLQM3c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2008 07:29:32 -0500
From: swhiteho@redhat.com
To: linux-kernel@vger.kernel.org, cluster-devel@redhat.com
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 23/24] GFS2: Send useful information with uevent messages
Date: Wed, 17 Dec 2008 11:30:22 +0000
Message-Id: <1229513423-19105-24-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1229513423-19105-23-git-send-email-swhiteho@redhat.com>
References: <1229513423-19105-1-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-2-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-3-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-4-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-5-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-6-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-7-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-8-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-9-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-10-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-11-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-12-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-13-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-14-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-15-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-16-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-17-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-18-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-19-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-20-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-21-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-22-git-send-email-swhiteho@redhat.com>
 <1229513423-19105-23-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

In order to distinguish between two differing uevent messages
and to avoid using the (racy) method of reading status from
sysfs in future, this adds some status information to our
uevent messages.

Btw, before anybody says "sysfs isn't racy", I'm aware of that,
but the way that GFS2 was using it (send an ambiugous uevent and
then expect the receiver to read sysfs to find out the status
of the reported operation) was.

The additional benefit of using the new interface is that it
should be possible for a node to recover multiple journals
at the same time, since there is no longer any confusion as
to which journal the status belongs to.

At some future stage, when all the userland programs have been
converted, I intend to remove the old interface.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/gfs2/locking/dlm/mount.c b/fs/gfs2/locking/dlm/mount.c
index 0c4cbe6..1aa7eb6 100644
--- a/fs/gfs2/locking/dlm/mount.c
+++ b/fs/gfs2/locking/dlm/mount.c
@@ -194,17 +194,25 @@ out:
 static void gdlm_recovery_done(void *lockspace, unsigned int jid,
                                unsigned int message)
 {
+	char env_jid[20];
+	char env_status[20];
+	char *envp[] = { env_jid, env_status, NULL };
 	struct gdlm_ls *ls = lockspace;
 	ls->recover_jid_done = jid;
 	ls->recover_jid_status = message;
-	kobject_uevent(&ls->kobj, KOBJ_CHANGE);
+	sprintf(env_jid, "JID=%d", jid);
+	sprintf(env_status, "RECOVERY=%s",
+		message == LM_RD_SUCCESS ? "Done" : "Failed");
+	kobject_uevent_env(&ls->kobj, KOBJ_CHANGE, envp);
 }
 
 static void gdlm_others_may_mount(void *lockspace)
 {
+	char *message = "FIRSTMOUNT=Done";
+	char *envp[] = { message, NULL };
 	struct gdlm_ls *ls = lockspace;
 	ls->first_done = 1;
-	kobject_uevent(&ls->kobj, KOBJ_CHANGE);
+	kobject_uevent_env(&ls->kobj, KOBJ_CHANGE, envp);
 }
 
 /* Userspace gets the offline uevent, blocks new gfs locks on
-- 
1.6.0.3

