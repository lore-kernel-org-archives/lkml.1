Return-Path: <linux-kernel-owner+w=401wt.eu-S934432AbZGQLJO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934432AbZGQLJO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 07:09:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934420AbZGQLJO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 07:09:14 -0400
Received: from mx2.redhat.com ([66.187.237.31]:56462 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934417AbZGQLJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 07:09:13 -0400
From: Xiaotian Feng <dfeng@redhat.com>
To: cl@linux-foundation.org, penberg@cs.helsinki.fi, mpm@selenic.com,
       linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Xiaotian Feng <dfeng@redhat.com>
Subject: [RFC PATCH] slub: release kobject if sysfs_create_group failed in sysfs_slab_add
Date: Fri, 17 Jul 2009 19:08:28 +0800
Message-Id: <1247828908-13921-1-git-send-email-dfeng@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In sysfs_slab_add, after kobject_init_and_add, kobject is inited and added.
Later, if sysfs_create_group fails, just simply return an error. This may
cause a memory leak. unlink and put the kobject if sysfs_create_group failed.

Signed-off-by: Xiaotian Feng <dfeng@redhat.com>
---
 mm/slub.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b9f1491..f910964 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4543,8 +4543,11 @@ static int sysfs_slab_add(struct kmem_cache *s)
 	}
 
 	err = sysfs_create_group(&s->kobj, &slab_attr_group);
-	if (err)
+	if (err) {
+		kobject_del(&s->kobj);
+		kobject_put(&s->kobj);
 		return err;
+	}
 	kobject_uevent(&s->kobj, KOBJ_ADD);
 	if (!unmergeable) {
 		/* Setup first alias */
-- 
1.6.2.5

