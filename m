Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932931Ab0BQJwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 04:52:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067Ab0BQJv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 04:51:57 -0500
From: Steven Whitehouse <swhiteho@redhat.com>
To: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com,
       linux-kernel@vger.kernel.org
Cc: Steven Whitehouse <swhiteho@redhat.com>
Subject: [PATCH 1/2] dlm: Send lockspace name with uevents
Date: Wed, 17 Feb 2010 09:41:34 +0000
Message-Id: <1266399695-29885-2-git-send-email-swhiteho@redhat.com>
In-Reply-To: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
References: <1266399695-29885-1-git-send-email-swhiteho@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Although it is possible to get this information from the path,
its much easier to provide the lockspace as a seperate env
variable.

Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>
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
1.6.2.5

