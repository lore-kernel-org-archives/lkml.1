Return-Path: <linux-kernel-owner+w=401wt.eu-S1754536AbZCLBsX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754536AbZCLBsX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 21:48:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754456AbZCLBrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 21:47:36 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:50184 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753356AbZCLBrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 21:47:32 -0400
Message-ID: <49B869BB.7030907@cn.fujitsu.com>
Date: Thu, 12 Mar 2009 09:47:39 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH] devcgroup: avoid using cgroup_lock
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is nothing special that has to be protected by cgroup_lock,
so introduce devcgroup_mtuex for it's own use.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 security/device_cgroup.c |   21 +++++++++++++--------
 1 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 3aacd0f..5fda7df 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -11,6 +11,7 @@
 #include <linux/uaccess.h>
 #include <linux/seq_file.h>
 #include <linux/rcupdate.h>
+#include <linux/mutex.h>
 
 #define ACC_MKNOD 1
 #define ACC_READ  2
@@ -21,9 +22,11 @@
 #define DEV_CHAR  2
 #define DEV_ALL   4  /* this represents all devices */
 
+static DEFINE_MUTEX(devcgroup_mutex);
+
 /*
  * whitelist locking rules:
- * hold cgroup_lock() for update/read.
+ * hold devcgroup_mutex for update/read.
  * hold rcu_read_lock() for read.
  */
 
@@ -67,7 +70,7 @@ static int devcgroup_can_attach(struct cgroup_subsys *ss,
 }
 
 /*
- * called under cgroup_lock()
+ * called under devcgroup_mutex
  */
 static int dev_whitelist_copy(struct list_head *dest, struct list_head *orig)
 {
@@ -92,7 +95,7 @@ free_and_exit:
 
 /* Stupid prototype - don't bother combining existing entries */
 /*
- * called under cgroup_lock()
+ * called under devcgroup_mutex
  */
 static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
@@ -130,7 +133,7 @@ static void whitelist_item_free(struct rcu_head *rcu)
 }
 
 /*
- * called under cgroup_lock()
+ * called under devcgroup_mutex
  */
 static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
 			struct dev_whitelist_item *wh)
@@ -185,8 +188,10 @@ static struct cgroup_subsys_state *devcgroup_create(struct cgroup_subsys *ss,
 		list_add(&wh->list, &dev_cgroup->whitelist);
 	} else {
 		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
+		mutex_lock(&devcgroup_mutex);
 		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
 				&parent_dev_cgroup->whitelist);
+		mutex_unlock(&devcgroup_mutex);
 		if (ret) {
 			kfree(dev_cgroup);
 			return ERR_PTR(ret);
@@ -273,7 +278,7 @@ static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
  * does the access granted to dev_cgroup c contain the access
  * requested in whitelist item refwh.
  * return 1 if yes, 0 if no.
- * call with c->lock held
+ * call with devcgroup_mutex held
  */
 static int may_access_whitelist(struct dev_cgroup *c,
 				       struct dev_whitelist_item *refwh)
@@ -426,11 +431,11 @@ static int devcgroup_access_write(struct cgroup *cgrp, struct cftype *cft,
 				  const char *buffer)
 {
 	int retval;
-	if (!cgroup_lock_live_group(cgrp))
-		return -ENODEV;
+
+	mutex_lock(&devcgroup_mutex);
 	retval = devcgroup_update_access(cgroup_to_devcgroup(cgrp),
 					 cft->private, buffer);
-	cgroup_unlock();
+	mutex_unlock(&devcgroup_mutex);
 	return retval;
 }
 
-- 
1.5.4.rc3
