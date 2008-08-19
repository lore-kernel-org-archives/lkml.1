Return-Path: <linux-kernel-owner+w=401wt.eu-S1754555AbYHSGbr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbYHSGbr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:31:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYHSGbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:31:39 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:56851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbYHSGbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:31:38 -0400
Message-ID: <48AA684B.7000704@cn.fujitsu.com>
Date: Tue, 19 Aug 2008 14:29:31 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.16 (Windows/20080708)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] cgroups: fix probable race with put_css_set[_taskexit] and
 find_css_set
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

put_css_set_taskexit may be called when find_css_set is called on
other cpu. And the race will occur:

put_css_set_taskexit side                    find_css_set side

                                        |
atomic_dec_and_test(&kref->refcount)    |
    /* kref->refcount = 0 */            |
....................................................................
                                        |  read_lock(&css_set_lock)
                                        |  find_existing_css_set
                                        |  get_css_set
                                        |  read_unlock(&css_set_lock);
....................................................................
__release_css_set                       |
....................................................................
                                        | /* use a released css_set */
                                        |


[put_css_set is the same. But in the current code, all put_css_set are
put into cgroup mutex critical region as the same as find_css_set.]


Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 13932ab..003912e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -241,7 +241,6 @@ static void unlink_css_set(struct css_set *cg)
 	struct cg_cgroup_link *link;
 	struct cg_cgroup_link *saved_link;
 
-	write_lock(&css_set_lock);
 	hlist_del(&cg->hlist);
 	css_set_count--;
 
@@ -251,8 +250,6 @@ static void unlink_css_set(struct css_set *cg)
 		list_del(&link->cgrp_link_list);
 		kfree(link);
 	}
-
-	write_unlock(&css_set_lock);
 }
 
 static void __release_css_set(struct kref *k, int taskexit)
@@ -260,7 +257,13 @@ static void __release_css_set(struct kref *k, int taskexit)
 	int i;
 	struct css_set *cg = container_of(k, struct css_set, ref);
 
+	write_lock(&css_set_lock);
+	if (atomic_read(&k->refcount) > 0) {
+		write_unlock(&css_set_lock);
+		return;
+	}
 	unlink_css_set(cg);
+	write_unlock(&css_set_lock);
 
 	rcu_read_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
@@ -410,6 +413,20 @@ static struct css_set *find_css_set(
 	 * the desired set */
 	read_lock(&css_set_lock);
 	res = find_existing_css_set(oldcg, cgrp, template);
+	/*
+	 * put_css_set[_taskexit]() may race with find_css_set(), in that
+	 * find_css_set() got the css_set after put_css_set() had released it.
+	 *
+	 * We should put the whole put_css_set[_taskexit]() into css_set_lock's
+	 * write_lock critical setion to avoid this race. But it will increase
+	 * overhead for do_exit().
+	 *
+	 * So we do not avoid this race but put it under control:
+	 * __release_css_set() will re-check the refcount
+	 * with css_set_lock held.
+	 *
+	 * This race may trigger the warnning in kref_get().
+	 */
 	if (res)
 		get_css_set(res);
 	read_unlock(&css_set_lock);

