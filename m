Return-Path: <linux-kernel-owner+w=401wt.eu-S1752743AbYLSETw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752743AbYLSETw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2008 23:19:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752598AbYLSETH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Dec 2008 23:19:07 -0500
Received: from ti-out-0910.google.com ([209.85.142.187]:44365 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbYLSETG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2008 23:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KjPU49x6QTHqSzPnq1hKFsqPKmyF6hOwtfbXp8rWAoxBlZ+pRy1pD4emUBrUiuwBHs
         uQqkPku+Lob5fnWMhNOWuPUqx30JIOkhryRzLxZxtnI1ZhYHmsbKYfOdZUhPvI0jKpr4
         WIOn9XE9Iffmw2oryMwXjofrbHxnAlkLfyito=
From: crquan@gmail.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] dm-target: use pointer reference instead of making a copy
Date: Fri, 19 Dec 2008 12:19:44 +0800
Message-Id: <1229660385-17153-3-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1229660385-17153-2-git-send-email-crquan@gmail.com>
References: <1229660385-17153-1-git-send-email-crquan@gmail.com>
 <1229660385-17153-2-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

The tt_internal always use target_type read-only, so there's no need to
making a copy, just a pointer reference is good, this could save
 (sizeof(target_type) - sizeof(pointer)) bytes memory per target_type.

  -		ti->tt = *t;
  +		ti->tt = t;

Signed-off-by: Cheng Renquan <crquan@gmail.com>
---
 drivers/md/dm-target.c |   16 ++++++++--------
 1 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-target.c b/drivers/md/dm-target.c
index 018df35..a713c7f 100644
--- a/drivers/md/dm-target.c
+++ b/drivers/md/dm-target.c
@@ -15,7 +15,7 @@
 #define DM_MSG_PREFIX "target"
 
 struct tt_internal {
-	struct target_type tt;
+	struct target_type *tt;
 
 	struct list_head list;
 };
@@ -30,7 +30,7 @@ static inline struct tt_internal *__find_target_type(const char *name)
 	struct tt_internal *ti;
 
 	list_for_each_entry (ti, &_targets, list)
-		if (!strcmp(name, ti->tt.name))
+		if (!strcmp(name, ti->tt->name))
 			return ti;
 
 	return NULL;
@@ -43,7 +43,7 @@ static struct tt_internal *get_target_type(const char *name)
 	down_read(&_lock);
 
 	ti = __find_target_type(name);
-	if (ti && !try_module_get(ti->tt.module))
+	if (ti && !try_module_get(ti->tt->module))
 		ti = NULL;
 
 	up_read(&_lock);
@@ -64,7 +64,7 @@ struct target_type *dm_get_target_type(const char *name)
 		ti = get_target_type(name);
 	}
 
-	return ti ? &ti->tt : NULL;
+	return ti ? ti->tt : NULL;
 }
 
 void dm_put_target_type(struct target_type *t)
@@ -72,7 +72,7 @@ void dm_put_target_type(struct target_type *t)
 	struct tt_internal *ti = (struct tt_internal *) t;
 
 	down_read(&_lock);
-	module_put(ti->tt.module);
+	module_put(ti->tt->module);
 	up_read(&_lock);
 
 	return;
@@ -83,7 +83,7 @@ static struct tt_internal *alloc_target(struct target_type *t)
 	struct tt_internal *ti = kzalloc(sizeof(*ti), GFP_KERNEL);
 
 	if (ti)
-		ti->tt = *t;
+		ti->tt = t;
 
 	return ti;
 }
@@ -96,7 +96,7 @@ int dm_target_iterate(void (*iter_func)(struct target_type *tt,
 
 	down_read(&_lock);
 	list_for_each_entry (ti, &_targets, list)
-		iter_func(&ti->tt, param);
+		iter_func(ti->tt, param);
 	up_read(&_lock);
 
 	return 0;
@@ -132,7 +132,7 @@ int dm_unregister_target(struct target_type *t)
 		return -EINVAL;
 	}
 
-	if (ti->tt.module && module_refcount(ti->tt.module)) {
+	if (ti->tt->module && module_refcount(ti->tt->module)) {
 		up_write(&_lock);
 		return -ETXTBSY;
 	}
-- 
1.6.0.2.GIT

