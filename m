Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbZKBHqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbZKBHqz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Nov 2009 02:46:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753999AbZKBHqy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Nov 2009 02:46:54 -0500
Received: from mail-pz0-f188.google.com ([209.85.222.188]:40827 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973AbZKBHqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Nov 2009 02:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=tZTF97lC2EDH5/r7H4XgXAoL3DUsL6nifb1/o+sAB5OBdxMqoQqq0OpfmPcf3x0M7T
         gudys9ZfYxS1qOZpBAOLmKBfV7lxumT37jfv9olPPKQwjx+vmG07En4B9Biu6aQcOKQK
         ccxzUFpB1sdn6bOucaj+eZZJ2rxJ5M6nKwedc=
MIME-Version: 1.0
Date: Mon, 2 Nov 2009 15:46:57 +0800
Message-ID: <b741c2440911012346k7213befcida229606f10c0399@mail.gmail.com>
Subject: [PATCH 2/3] Fix the 'current css_set' problem in debug subsystem
From: Liu Aleaxander <aleaxander@gmail.com>
To: menage@google.com, lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 61c93b1a66e43d44820e9b8d22ef0bec80dfc814 Mon Sep 17 00:00:00 2001
From: Liu Aleaxander <Aleaxander@gmail.com>
Date: Mon, 2 Nov 2009 14:30:07 +0800
Subject: [PATCH 2/3] Fix the 'current css_set' problem in debug subsystem

In the current implementation, it always print the same information
no matter which group you are in. And this would be meaningless. So
we should make it print the information of the 'real' current one.

Well, I am not sure it's the current one, but I'm sure it's the first
one of that cgroup.

Signed-off-by: Liu Aleaxander <Aleaxander@gmail.com>
---
 include/linux/cgroup.h |    2 --
 kernel/cgroup.c        |   19 ++++++++++++-------
 2 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 4d63c5c..0008dee 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -389,8 +389,6 @@ int cgroup_add_files(struct cgroup *cgrp,
             const struct cftype cft[],
             int count);

-struct css_set* cgroup_first_css_set(const struct cgroup *cgrp);
-
 int cgroup_is_removed(const struct cgroup *cgrp);

 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 863089f..ddd4d33 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -340,7 +340,7 @@ static inline void put_css_set_taskexit(struct css_set *cg)
 /*
  * Get the first css_set of the cgroup 'cgrp'.
  */
-struct css_set* cgroup_first_css_set(const struct cgroup *cgrp)
+static struct css_set* cgroup_first_css_set(const struct cgroup *cgrp)
 {
        struct list_head *head = &cgrp->css_sets;
        struct cg_cgroup_link *link;
@@ -4093,17 +4093,22 @@ static u64 debug_taskcount_read(struct cgroup
*cont, struct cftype *cft)

 static u64 current_css_set_read(struct cgroup *cont, struct cftype *cft)
 {
-    return (u64)(unsigned long)current->cgroups;
+    return (u64)(long)cgroup_first_css_set(cont);
 }

 static u64 current_css_set_refcount_read(struct cgroup *cont,
                        struct cftype *cft)
 {
-    u64 count;
-
-    rcu_read_lock();
-    count = atomic_read(&current->cgroups->refcount);
-    rcu_read_unlock();
+    u64 count = 0;
+    struct css_set *cg;
+
+    cg = cgroup_first_css_set(cont);
+    if (cg) {
+        rcu_read_lock();
+        count = atomic_read(&cg->refcount);
+        rcu_read_unlock();
+    }
+
     return count;
 }

-- 
1.6.2.5



-- 
regards
Liu Aleaxander
