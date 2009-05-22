Return-Path: <linux-kernel-owner+w=401wt.eu-S1757658AbZEVFA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757658AbZEVFA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 01:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753365AbZEVE4L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 00:56:11 -0400
Received: from fg-out-1718.google.com ([72.14.220.155]:3469 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZEVE4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 00:56:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gI6isz6KFr+8UpaTcuIcTruoIkVA1657z1DJ+0pmy48793QWZGdrNO10P44tcD4+hK
         JENFFQe+AeGYiqT8Xf/AMe2B2f3m/qVWoTktrQl5Qu/ST4PH/Culea8mVVDsux4/q/ef
         ehMHooliXuOQUrC9iNccAW/ANa0Kqlna9ehTc=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org,
       torvalds@linux-foundation.org, xemul@parallels.com,
       orenl@cs.columbia.edu, serue@us.ibm.com, dave@linux.vnet.ibm.com,
       mingo@elte.hu, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 19/38] C/R: multiple tasks
Date: Fri, 22 May 2009 08:55:13 +0400
Message-Id: <1242968132-1044-19-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
References: <1242968132-1044-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Restore task hierarchy wrt ->real_parent.

First thing soon-to-be-restored task does after birth is to find
->real_parent and glue itself to parent lists.

For this parent is dumped first and restored first, so that at the time
child starts restoration, parent is already up and running as task_struct,
and we get cheap loop-prevention check.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 include/linux/kstate-image.h  |    2 +
 kernel/kstate/kstate-object.c |    3 +-
 kernel/kstate/kstate-task.c   |   53 +++++++++++++++++++++++++++++++++++-----
 3 files changed, 50 insertions(+), 8 deletions(-)

diff --git a/include/linux/kstate-image.h b/include/linux/kstate-image.h
index ac3c81d..348f59f 100644
--- a/include/linux/kstate-image.h
+++ b/include/linux/kstate-image.h
@@ -60,6 +60,8 @@ struct kstate_object_header {
 struct kstate_image_task_struct {
 	struct kstate_object_header hdr;
 
+	kstate_ref_t	ref_real_parent;
+
 	kstate_ref_t	ref_mm;
 
 	__u8		comm[16];
diff --git a/kernel/kstate/kstate-object.c b/kernel/kstate/kstate-object.c
index f9f2f33..60ba70d 100644
--- a/kernel/kstate/kstate-object.c
+++ b/kernel/kstate/kstate-object.c
@@ -25,7 +25,8 @@ int kstate_collect_object(struct kstate_context *ctx, void *p, enum kstate_conte
 	obj->o_ref.pos = 0;	/* not yet dumped */
 	obj->o_ref.id = 0;	/* not yet assigned */
 	obj->o_obj = p;
-	list_add(&obj->o_list, &ctx->obj[type]);
+	/* task_struct collecting relies on "_tail" part. */
+	list_add_tail(&obj->o_list, &ctx->obj[type]);
 
 	switch (type) {
 	case KSTATE_CTX_FILE:
diff --git a/kernel/kstate/kstate-task.c b/kernel/kstate/kstate-task.c
index aec97c2..4f48c32 100644
--- a/kernel/kstate/kstate-task.c
+++ b/kernel/kstate/kstate-task.c
@@ -11,11 +11,6 @@
 static int check_task_struct(struct task_struct *tsk)
 {
 	read_lock_irq(&tasklist_lock);
-	if (!list_empty(&tsk->children)) {
-		read_unlock_irq(&tasklist_lock);
-		WARN_ON(1);
-		return -EINVAL;
-	}
 	if (!list_empty(&tsk->thread_group)) {
 		read_unlock_irq(&tasklist_lock);
 		WARN_ON(1);
@@ -74,8 +69,32 @@ static int collect_task_struct(struct kstate_context *ctx, struct task_struct *t
 
 int kstate_collect_all_task_struct(struct kstate_context *ctx)
 {
+	struct kstate_object *obj;
+	int rv;
+
 	/* Seed task list. */
-	return collect_task_struct(ctx, ctx->init_tsk);
+	rv = collect_task_struct(ctx, ctx->init_tsk);
+	if (rv < 0)
+		return rv;
+	/*
+	 * Children are added after parent as iteration goes on:
+	 * - parent is dumped before child, child knows position of parent's
+	 *   image and can reference it,
+	 * - task_struct restore is done in the same order: parent first.
+	 *   This is cheap loop prevention wrt "->real_parent": if real_parent
+	 *   reference can't be resolved at the time ->real_parent rewrite is
+	 *   done, image is malformed.
+	 */
+	for_each_kstate_object(ctx, obj, KSTATE_CTX_TASK_STRUCT) {
+		struct task_struct *tsk = obj->o_obj, *child;
+
+		list_for_each_entry(child, &tsk->children, sibling) {
+			rv = collect_task_struct(ctx, child);
+			if (rv < 0)
+				return rv;
+		}
+	}
+	return 0;
 }
 
 static int dump_task_struct(struct kstate_context *ctx, struct kstate_object *obj)
@@ -91,6 +110,13 @@ static int dump_task_struct(struct kstate_context *ctx, struct kstate_object *ob
 	if (!i)
 		return -ENOMEM;
 
+	tmp = find_kstate_obj_by_ptr(ctx, tsk->real_parent, KSTATE_CTX_TASK_STRUCT);
+	if (tmp)
+		i->ref_real_parent = tmp->o_ref;
+	else
+		/* Root of hierarchy to be checkpointed. */
+		i->ref_real_parent = KSTATE_REF_UNDEF;
+
 	tmp = find_kstate_obj_by_ptr(ctx, tsk->mm, KSTATE_CTX_MM_STRUCT);
 	i->ref_mm = tmp->o_ref;
 
@@ -206,7 +232,20 @@ static int task_struct_restorer(void *_tsk_ctx)
 	pr_debug("%s: ENTER tsk %p/%s\n", __func__, tsk, tsk->comm);
 
 	write_lock_irq(&tasklist_lock);
-	real_parent = ctx->init_tsk->nsproxy->pid_ns->child_reaper;
+	if (kstate_ref_undefined(&i->ref_real_parent))
+		real_parent = ctx->init_tsk->nsproxy->pid_ns->child_reaper;
+	else {
+		struct kstate_object *tmp;
+
+		/* Parent as task_struct should be restored already. */
+		tmp = find_kstate_obj_by_ref(ctx, &i->ref_real_parent, KSTATE_CTX_TASK_STRUCT);
+		if (!tmp) {
+			write_unlock_irq(&tasklist_lock);
+			rv = -EINVAL;
+			goto out;
+		}
+		real_parent = tmp->o_obj;
+	}
 	tsk->real_parent = tsk->parent = real_parent;
 	list_move_tail(&tsk->sibling, &tsk->real_parent->sibling);
 	write_unlock_irq(&tasklist_lock);
-- 
1.5.6.5

