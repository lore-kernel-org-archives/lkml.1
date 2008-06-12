Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbYFLXya@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbYFLXya (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 19:54:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754642AbYFLXyT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 19:54:19 -0400
Received: from bohort.kerlabs.com ([62.160.40.57]:59177 "EHLO
	bohort.kerlabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYFLXyS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 19:54:18 -0400
Date: Fri, 13 Jun 2008 01:54:11 +0200
From: Louis Rilling <Louis.Rilling@kerlabs.com>
To: Joel Becker <Joel.Becker@oracle.com>
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: [RFC] configfs: module reference counting rules
Message-ID: <20080612235410.GC4012@localdomain>
Reply-To: Louis.Rilling@kerlabs.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_bohort-8576-1213314770-0001-2"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_bohort-8576-1213314770-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

I'm a bit confused by configfs module reference counting, and I feel
that it does not really protect against module unloading. If my feeling
is correct, I'd suggest to change module reference counting rules in
configfs, for instance like in the attached patch. If my feeling is
wrong, could someone shed some light?

Thanks

Louis

-- 
Dr Louis Rilling			Kerlabs - IRISA
Skype: louis.rilling			Campus Universitaire de Beaulieu
Phone: (+33|0) 2 99 84 71 52		Avenue du General Leclerc
Fax: (+33|0) 2 99 84 71 71		35042 Rennes CEDEX - France
http://www.kerlabs.com/

--=_bohort-8576-1213314770-0001-2
Content-Type: text/x-diff; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="configfs-fix-module-refcount.patch"

configfs: make module reference counting robust

Module references taken by configfs at mkdir() unfortunately do not ensure that
the module implementing an item will remain loaded before the item is released,
because
	1/ the reference is taken after having created the item, and
	2/ the reference is dropped when dropping the item, which may be before
	   the item's last reference count is dropped.
For instance this can lead to calling the release item operation when the module
implementing the function is already unloaded.

This patch changes module reference counting rules in configfs to ensure that
for each item appearing in configfs a module reference is held until the item is
released. For each item/group/default group created in make_item()/make_group(),
the subsystem is responsible for grabbing a reference on the matching modules.
configfs will drop that reference after having released the item/group/default
group.

Something similar might be needed for configfs_attribute as well.

Signed-off-by: Louis Rilling <Louis.Rilling@kerlabs.com>
---
 drivers/net/netconsole.c       |    1 +
 fs/configfs/dir.c              |   17 +++++++----------
 fs/configfs/item.c             |    5 +++++
 fs/dlm/config.c                |    7 +++++++
 fs/ocfs2/cluster/heartbeat.c   |    1 +
 fs/ocfs2/cluster/nodemanager.c |    5 +++++
 6 files changed, 26 insertions(+), 10 deletions(-)

Index: b/drivers/net/netconsole.c
===================================================================
--- a/drivers/net/netconsole.c	2008-06-13 01:24:55.000000000 +0200
+++ b/drivers/net/netconsole.c	2008-06-13 01:25:51.000000000 +0200
@@ -608,6 +608,7 @@ static struct config_item *make_netconso
 	memset(nt->np.remote_mac, 0xff, ETH_ALEN);
 
 	/* Initialize the config_item member */
+	__module_get(netconsole_target_type.ct_owner);
 	config_item_init_type_name(&nt->item, name, &netconsole_target_type);
 
 	/* Adding, but it is disabled */
Index: b/fs/configfs/dir.c
===================================================================
--- a/fs/configfs/dir.c	2008-06-13 00:41:49.000000000 +0200
+++ b/fs/configfs/dir.c	2008-06-13 01:26:13.000000000 +0200
@@ -1080,18 +1080,18 @@ static int configfs_mkdir(struct inode *
 		goto out_unlink;
 	}
 
+	/*
+	 * make_item()/make_group() should have grabbed a module reference for item
+	 * Let's check it but do not keep one module reference more. The
+	 * reference for item will be dropped after item is released.
+	 */
 	owner = type->ct_owner;
 	if (!try_module_get(owner)) {
+		printk(KERN_ERR "configfs: Ill-behaved subsystem: module reference count may be broken\n");
 		ret = -EINVAL;
 		goto out_unlink;
 	}
-
-	/*
-	 * I hate doing it this way, but if there is
-	 * an error,  module_put() probably should
-	 * happen after any cleanup.
-	 */
-	module_got = 1;
+	module_put(owner)
 
 	if (group)
 		ret = configfs_attach_group(parent_item, item, dentry);
@@ -1111,9 +1111,6 @@ out_unlink:
 		client_drop_item(parent_item, item);
 
 		mutex_unlock(&subsys->su_mutex);
-
-		if (module_got)
-			module_put(owner);
 	}
 
 out_put:
Index: b/fs/configfs/item.c
===================================================================
--- a/fs/configfs/item.c	2008-06-13 00:57:53.000000000 +0200
+++ b/fs/configfs/item.c	2008-06-13 00:59:42.000000000 +0200
@@ -153,13 +153,18 @@ static void config_item_cleanup(struct c
 	struct config_item_type * t = item->ci_type;
 	struct config_group * s = item->ci_group;
 	struct config_item * parent = item->ci_parent;
+	struct module *owner = NULL;
 
 	pr_debug("config_item %s: cleaning up\n",config_item_name(item));
 	if (item->ci_name != item->ci_namebuf)
 		kfree(item->ci_name);
 	item->ci_name = NULL;
+	if (t)
+		owner = t->ct_owner;
 	if (t && t->ct_item_ops && t->ct_item_ops->release)
 		t->ct_item_ops->release(item);
+	if (owner)
+		module_put(owner);
 	if (s)
 		config_group_put(s);
 	if (parent)
Index: b/fs/dlm/config.c
===================================================================
--- a/fs/dlm/config.c	2008-06-13 01:02:35.000000000 +0200
+++ b/fs/dlm/config.c	2008-06-13 01:21:33.000000000 +0200
@@ -408,6 +408,9 @@ static struct config_group *make_cluster
 	if (!cl || !gps || !sps || !cms)
 		goto fail;
 
+	__module_get(cluster_type.ct_owner);
+	__module_get(spaces_type.ct_owner);
+	__module_get(comms_type.ct_owner);
 	config_group_init_type_name(&cl->group, name, &cluster_type);
 	config_group_init_type_name(&sps->ss_group, "spaces", &spaces_type);
 	config_group_init_type_name(&cms->cs_group, "comms", &comms_type);
@@ -479,6 +482,8 @@ static struct config_group *make_space(s
 	if (!sp || !gps || !nds)
 		goto fail;
 
+	__module_get(space_type.ct_owner);
+	__module_get(nodes_type.ct_owner);
 	config_group_init_type_name(&sp->group, name, &space_type);
 	config_group_init_type_name(&nds->ns_group, "nodes", &nodes_type);
 
@@ -530,6 +535,7 @@ static struct config_item *make_comm(str
 	if (!cm)
 		return NULL;
 
+	__module_get(comm_type.ct_owner);
 	config_item_init_type_name(&cm->item, name, &comm_type);
 	cm->nodeid = -1;
 	cm->local = 0;
@@ -563,6 +569,7 @@ static struct config_item *make_node(str
 	if (!nd)
 		return NULL;
 
+	__module_get(node_type.ct_owner);
 	config_item_init_type_name(&nd->item, name, &node_type);
 	nd->nodeid = -1;
 	nd->weight = 1;  /* default weight of 1 if none is set */
Index: b/fs/ocfs2/cluster/heartbeat.c
===================================================================
--- a/fs/ocfs2/cluster/heartbeat.c	2008-06-13 01:23:34.000000000 +0200
+++ b/fs/ocfs2/cluster/heartbeat.c	2008-06-13 01:24:19.000000000 +0200
@@ -1499,6 +1499,7 @@ static struct config_item *o2hb_heartbea
 	if (reg == NULL)
 		goto out; /* ENOMEM */
 
+	__module_get(o2hb_region_type.ct_owner);
 	config_item_init_type_name(&reg->hr_item, name, &o2hb_region_type);
 
 	ret = &reg->hr_item;
Index: b/fs/ocfs2/cluster/nodemanager.c
===================================================================
--- a/fs/ocfs2/cluster/nodemanager.c	2008-06-13 01:09:29.000000000 +0200
+++ b/fs/ocfs2/cluster/nodemanager.c	2008-06-13 01:23:05.000000000 +0200
@@ -718,6 +718,7 @@ static struct config_item *o2nm_node_gro
 		goto out; /* ENOMEM */
 
 	strcpy(node->nd_name, name); /* use item.ci_namebuf instead? */
+	__module_get(o2nm_node_type.ct_owner);
 	config_item_init_type_name(&node->nd_item, name, &o2nm_node_type);
 	spin_lock_init(&node->nd_lock);
 
@@ -831,6 +832,10 @@ static struct config_group *o2nm_cluster
 	if (cluster == NULL || ns == NULL || o2hb_group == NULL || defs == NULL)
 		goto out;
 
+	if (!try_module_get(o2hb_group->cg_item.ci_type->ct_owner))
+		goto out;
+	__modult_get(o2nm_cluster_type.ct_owner);
+	__modult_get(o2nm_node_group_type.ct_owner);
 	config_group_init_type_name(&cluster->cl_group, name,
 				    &o2nm_cluster_type);
 	config_group_init_type_name(&ns->ns_group, "node",

--=_bohort-8576-1213314770-0001-2--
