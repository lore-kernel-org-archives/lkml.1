Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab0BXUjc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 15:39:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33288 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758070Ab0BXUjb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 15:39:31 -0500
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 3/3] dlm: Send lockspace name with uevents
Date: Wed, 24 Feb 2010 14:39:18 -0600
Message-Id: <1267043958-31082-4-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Whitehouse <swhiteho@redhat.com>

Although it is possible to get this information from the path,
its much easier to provide the lockspace as a seperate env
variable.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/lockspace.c |   14 +++++++++++++-
 1 files changed, 13 insertions(+), 1 deletions(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index c010ecf..26a8bd4 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -191,6 +191,18 @@ static int do_uevent(struct dlm_ls *ls, int in)
 	return error;
 }
 
+static int dlm_uevent(struct kset *kset, struct kobject *kobj,
+		      struct kobj_uevent_env *env)
+{
+	struct dlm_ls *ls = container_of(kobj, struct dlm_ls, ls_kobj);
+
+	add_uevent_var(env, "LOCKSPACE=%s", ls->ls_name);
+	return 0;
+}
+
+static struct kset_uevent_ops dlm_uevent_ops = {
+	.uevent = dlm_uevent,
+};
 
 int __init dlm_lockspace_init(void)
 {
@@ -199,7 +211,7 @@ int __init dlm_lockspace_init(void)
 	INIT_LIST_HEAD(&lslist);
 	spin_lock_init(&lslist_lock);
 
-	dlm_kset = kset_create_and_add("dlm", NULL, kernel_kobj);
+	dlm_kset = kset_create_and_add("dlm", &dlm_uevent_ops, kernel_kobj);
 	if (!dlm_kset) {
 		printk(KERN_WARNING "%s: can not create kset\n", __func__);
 		return -ENOMEM;
-- 
1.6.6

