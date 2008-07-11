Return-Path: <linux-kernel-owner+w=401wt.eu-S1755554AbYGKP57@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554AbYGKP57 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:57:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbYGKP5w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:57:52 -0400
Received: from sacred.ru ([62.205.161.221]:38032 "EHLO sacred.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752671AbYGKP5v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:57:51 -0400
Message-ID: <48777BC8.7040507@openvz.org>
Date: Fri, 11 Jul 2008 19:27:04 +0400
From: Pavel Emelyanov <xemul@openvz.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Serge Hallyn <serue@us.ibm.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] devcgroup: relax white-list protection down to RCU
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (sacred.ru [62.205.161.221]); Fri, 11 Jul 2008 19:29:27 +0400 (MSD)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently this list is protected with a simple spinlock, even
for reading from one. This is OK, but can be better.

Actually I want it to be better very much, since after replacing
the OpenVZ device permissions engine with the cgroup-based one
I noticed, that we set 12 default device permissions for each newly
created container (for /dev/null, full, terminals, ect devices),
and people sometimes have up to 20 perms more, so traversing the
~30-40 elements list under a spinlock doesn't seem very good.

Here's the RCU protection for white-list - dev_whitelist_item-s
are added and removed under the devcg->lock, but are looked up in
permissions checking under the rcu_read_lock.

Signed-off-by: Pavel Emelyanov <xemul@openvz.org>
Acked-by: Serge Hallyn <serue@us.ibm.com>

---

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 0bbd705..5d447a4 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -41,6 +41,7 @@ struct dev_whitelist_item {
 	short type;
 	short access;
 	struct list_head list;
+	struct rcu_head rcu;
 };
 
 struct dev_cgroup {
@@ -133,11 +134,19 @@ static int dev_whitelist_add(struct dev_cgroup *dev_cgroup,
 	}
 
 	if (whcopy != NULL)
-		list_add_tail(&whcopy->list, &dev_cgroup->whitelist);
+		list_add_tail_rcu(&whcopy->list, &dev_cgroup->whitelist);
 	spin_unlock(&dev_cgroup->lock);
 	return 0;
 }
 
+static void whitelist_item_free(struct rcu_head *rcu)
+{
+	struct dev_whitelist_item *item;
+
+	item = container_of(rcu, struct dev_whitelist_item, rcu);
+	kfree(item);
+}
+
 /*
  * called under cgroup_lock()
  * since the list is visible to other tasks, we need the spinlock also
@@ -161,8 +170,8 @@ static void dev_whitelist_rm(struct dev_cgroup *dev_cgroup,
 remove:
 		walk->access &= ~wh->access;
 		if (!walk->access) {
-			list_del(&walk->list);
-			kfree(walk);
+			list_del_rcu(&walk->list);
+			call_rcu(&walk->rcu, whitelist_item_free);
 		}
 	}
 	spin_unlock(&dev_cgroup->lock);
@@ -269,15 +278,15 @@ static int devcgroup_seq_read(struct cgroup *cgroup, struct cftype *cft,
 	struct dev_whitelist_item *wh;
 	char maj[MAJMINLEN], min[MAJMINLEN], acc[ACCLEN];
 
-	spin_lock(&devcgroup->lock);
-	list_for_each_entry(wh, &devcgroup->whitelist, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wh, &devcgroup->whitelist, list) {
 		set_access(acc, wh->access);
 		set_majmin(maj, wh->major);
 		set_majmin(min, wh->minor);
 		seq_printf(m, "%c %s:%s %s\n", type_to_char(wh->type),
 			   maj, min, acc);
 	}
-	spin_unlock(&devcgroup->lock);
+	rcu_read_unlock();
 
 	return 0;
 }
@@ -508,8 +517,8 @@ int devcgroup_inode_permission(struct inode *inode, int mask)
 	if (!dev_cgroup)
 		return 0;
 
-	spin_lock(&dev_cgroup->lock);
-	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
+	rcu_read_lock();
+	list_for_each_entry_rcu(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
 		if ((wh->type & DEV_BLOCK) && !S_ISBLK(inode->i_mode))
@@ -525,10 +534,10 @@ acc_check:
 			continue;
 		if ((mask & MAY_READ) && !(wh->access & ACC_READ))
 			continue;
-		spin_unlock(&dev_cgroup->lock);
+		rcu_read_unlock();
 		return 0;
 	}
-	spin_unlock(&dev_cgroup->lock);
+	rcu_read_unlock();
 
 	return -EPERM;
 }
@@ -543,7 +552,7 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 	if (!dev_cgroup)
 		return 0;
 
-	spin_lock(&dev_cgroup->lock);
+	rcu_read_lock();
 	list_for_each_entry(wh, &dev_cgroup->whitelist, list) {
 		if (wh->type & DEV_ALL)
 			goto acc_check;
@@ -558,9 +567,9 @@ int devcgroup_inode_mknod(int mode, dev_t dev)
 acc_check:
 		if (!(wh->access & ACC_MKNOD))
 			continue;
-		spin_unlock(&dev_cgroup->lock);
+		rcu_read_unlock();
 		return 0;
 	}
-	spin_unlock(&dev_cgroup->lock);
+	rcu_read_unlock();
 	return -EPERM;
 }
