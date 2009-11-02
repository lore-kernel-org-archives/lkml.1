Return-Path: <linux-kernel-owner+w=401wt.eu-S1754055AbZKBHpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbZKBHpz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751971AbZKBHpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:45:54 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:58704 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753964AbZKBHpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:45:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=GzLX4+yGct7CgM7pkYsg5LQEBY7z5Lslrr86/RVHM7xcbURlW2MYIeC1aae1OOkfci
         s3s/tLiNrkSuRh930Pv+ep/7qKT5b4XKoC/dvuC73NZreiiPJHcMR05Mz5P8JXc4JnAF
         APP/kZ3qul7/VbCoaLna5s7BqHAaG0BSv3NP0=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 15:45:58 +0800
Message-ID: <b741c2440911012345j42122742o3f616798e43078bb@mail.gmail.com>
Subject: [PATCH 1/3] Add the cgroup_first_css_set function
From: Liu Aleaxander <aleaxander@gmail.com>
To: enage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c5279120ee5a4c7133ce1557fef0645da05467b0 Mon Sep 17 00:00:00 2001
From: Liu Aleaxander <Aleaxander@gmail.com>
Date: Mon, 2 Nov 2009 14:05:11 +0800
Subject: [PATCH 1/3] Add the cgroup_first_css_set function

It will return the first css_set of the specified cgroup if any as
the 'current' css_set used by the debug subsystem. Note: return NUll
is a normal case as there are no css_sets in that cgroup now.

And this would stop the debug subsystem from printing the *same*
content of debug.current_css_set and debug.current_css_set_refcount
even though in different directories, aka cgroups.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |   20 ++++++++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 0008dee..4d63c5c 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -389,6 +389,8 @@ int cgroup_add_files(struct cgroup *cgrp,
             const struct cftype cft[],
             int count);

+struct css_set* cgroup_first_css_set(const struct cgroup *cgrp);
+
 int cgroup_is_removed(const struct cgroup *cgrp);

 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0249f4b..863089f 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -338,6 +338,26 @@ static inline void put_css_set_taskexit(struct css_set *cg)
 }

 /*
+ * Get the first css_set of the cgroup 'cgrp'.
+ */
+struct css_set* cgroup_first_css_set(const struct cgroup *cgrp)
+{
+       struct list_head *head = &cgrp->css_sets;
+       struct cg_cgroup_link *link;
+
+       read_lock(&css_set_lock);
+       if (list_empty(head)) {
+               read_unlock(&css_set_lock);
+               return NULL;
+       }
+       link = list_first_entry(head, struct cg_cgroup_link, cgrp_link_list);
+       read_unlock(&css_set_lock);
+       BUG_ON(!link);
+
+       return link->cg;
+}
+
+/*
  * compare_css_sets - helper function for find_existing_css_set().
  * @cg: candidate css_set being tested
  * @old_cg: existing css_set for a task
-- 
1.6.2.5

-- 
regards
Liu Aleaxander
