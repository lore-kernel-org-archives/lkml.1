Return-Path: <linux-kernel-owner+w=401wt.eu-S1754316AbYIQLHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316AbYIQLHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 07:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754247AbYIQLGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 07:06:07 -0400
Received: from qb-out-0506.google.com ([72.14.204.228]:29149 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754195AbYIQLGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 07:06:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=opMixdxOIULh0qbr5PPQd02HENLuvbeEc7wADSfZGBsBauSROl65jS/AYCpiWuLbmA
         D6EMgQdb1pPD6s8U3Kc8mTIq1WI1ER6XlwlGxkJSATri5KM0+EyZCVlUfKoNi7xgT4Dm
         vTd2jrEslhlJWGkJJcNiT3nAWrb1SagB3uxZQ=
From: Andrea Righi <righi.andrea@gmail.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>, Paul Menage <menage@google.com>
Cc: agk@sourceware.org, akpm@linux-foundation.org, axboe@kernel.dk,
       baramsori72@gmail.com, Carl Henrik Lunde <chlunde@ping.uio.no>,
       dave@linux.vnet.ibm.com, Divyesh Shah <dpshah@google.com>,
       eric.rannaud@gmail.com, fernando@oss.ntt.co.jp,
       Hirokazu Takahashi <taka@valinux.co.jp>, Li Zefan <lizf@cn.fujitsu.com>,
       Marco Innocenti <m.innocenti@cineca.it>, matt@bluehost.com,
       ngupta@google.com, randy.dunlap@oracle.com, roberto@unbit.it,
       Ryo Tsuruta <ryov@valinux.co.jp>,
       Satoshi UCHIDA <s-uchida@ap.jp.nec.com>, subrata@linux.vnet.ibm.com,
       yoshikawa.takuya@oss.ntt.co.jp, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Andrea Righi <righi.andrea@gmail.com>
Subject: [PATCH -mm 4/6] memcg: interface to charge the right cgroup of asynchronous i/o activity
Date: Wed, 17 Sep 2008 13:05:26 +0200
Message-Id: <1221649528-8519-5-git-send-email-righi.andrea@gmail.com>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement get_cgroup_from_page() / put_cgroup_from_page() in the cgroup memory
controller used to retrieve the owner of a page during writes in submit_bio()
processed asynchronously by kernel threads (i.e. pdflush).

Signed-off-by: Andrea Righi <righi.andrea@gmail.com>
---
 include/linux/memcontrol.h |    3 +++
 mm/memcontrol.c            |   26 ++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ee1b2fc..92dfd40 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -50,6 +50,9 @@ int task_in_mem_cgroup(struct task_struct *task, const struct mem_cgroup *mem);
 
 extern struct mem_cgroup *mem_cgroup_from_task(struct task_struct *p);
 
+extern struct cgroup *get_cgroup_from_page(struct page *page);
+extern void put_cgroup_from_page(struct page *page);
+
 #define mm_match_cgroup(mm, cgroup)	\
 	((cgroup) == mem_cgroup_from_task((mm)->owner))
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2979d22..5321b8b 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -279,6 +279,32 @@ static void unlock_page_cgroup(struct page *page)
 	bit_spin_unlock(PAGE_CGROUP_LOCK_BIT, &page->page_cgroup);
 }
 
+struct cgroup *get_cgroup_from_page(struct page *page)
+{
+	struct page_cgroup *pc;
+	struct cgroup *cgrp = NULL;
+
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
+	if (pc) {
+		css_get(&pc->mem_cgroup->css);
+		cgrp = pc->mem_cgroup->css.cgroup;
+	}
+	unlock_page_cgroup(page);
+	return cgrp;
+}
+
+void put_cgroup_from_page(struct page *page)
+{
+	struct page_cgroup *pc;
+
+	lock_page_cgroup(page);
+	pc = page_get_page_cgroup(page);
+	if (pc)
+		css_put(&pc->mem_cgroup->css);
+	unlock_page_cgroup(page);
+}
+
 static void __mem_cgroup_remove_list(struct mem_cgroup_per_zone *mz,
 			struct page_cgroup *pc)
 {
-- 
1.5.4.3

