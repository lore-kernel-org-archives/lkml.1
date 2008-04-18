Return-Path: <linux-kernel-owner+w=401wt.eu-S1759810AbYDRSRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759810AbYDRSRs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2008 14:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759540AbYDRSRj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Apr 2008 14:17:39 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754892AbYDRSRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2008 14:17:39 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] dlm: recover nodes that are removed and re-added
Date: Fri, 18 Apr 2008 13:12:46 -0500
Message-Id: <1208542368-13417-5-git-send-email-teigland@redhat.com>
X-Mailer: git-send-email 1.5.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a node is removed from a lockspace, and then added back before the
dlm is notified of the removal, the dlm will not detect the removal
and won't clear the old state from the node.  This is fixed by using a
list of added nodes so the membership recovery can detect when a newly
added node is already in the member list.

Signed-off-by: David Teigland <teigland@redhat.com>
---
 fs/dlm/config.c       |   48 +++++++++++++++++++++++++++++++++++++++---------
 fs/dlm/config.h       |    3 ++-
 fs/dlm/dlm_internal.h |    4 +++-
 fs/dlm/member.c       |   34 +++++++++++++++++++++++++++++-----
 fs/dlm/recoverd.c     |    1 +
 5 files changed, 74 insertions(+), 16 deletions(-)

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 7ceaea3..eac23bd 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -284,6 +284,7 @@ struct node {
 	struct list_head list; /* space->members */
 	int nodeid;
 	int weight;
+	int new;
 };
 
 static struct configfs_group_operations clusters_ops = {
@@ -565,6 +566,7 @@ static struct config_item *make_node(struct config_group *g, const char *name)
 	config_item_init_type_name(&nd->item, name, &node_type);
 	nd->nodeid = -1;
 	nd->weight = 1;  /* default weight of 1 if none is set */
+	nd->new = 1;     /* set to 0 once it's been read by dlm_nodeid_list() */
 
 	mutex_lock(&sp->members_lock);
 	list_add(&nd->list, &sp->members);
@@ -805,12 +807,13 @@ static void put_comm(struct comm *cm)
 }
 
 /* caller must free mem */
-int dlm_nodeid_list(char *lsname, int **ids_out)
+int dlm_nodeid_list(char *lsname, int **ids_out, int *ids_count_out,
+		    int **new_out, int *new_count_out)
 {
 	struct space *sp;
 	struct node *nd;
-	int i = 0, rv = 0;
-	int *ids;
+	int i = 0, rv = 0, ids_count = 0, new_count = 0;
+	int *ids, *new;
 
 	sp = get_space(lsname);
 	if (!sp)
@@ -818,23 +821,50 @@ int dlm_nodeid_list(char *lsname, int **ids_out)
 
 	mutex_lock(&sp->members_lock);
 	if (!sp->members_count) {
-		rv = 0;
+		rv = -EINVAL;
+		printk(KERN_ERR "dlm: zero members_count\n");
 		goto out;
 	}
 
-	ids = kcalloc(sp->members_count, sizeof(int), GFP_KERNEL);
+	ids_count = sp->members_count;
+
+	ids = kcalloc(ids_count, sizeof(int), GFP_KERNEL);
 	if (!ids) {
 		rv = -ENOMEM;
 		goto out;
 	}
 
-	rv = sp->members_count;
-	list_for_each_entry(nd, &sp->members, list)
+	list_for_each_entry(nd, &sp->members, list) {
 		ids[i++] = nd->nodeid;
+		if (nd->new)
+			new_count++;
+	}
+
+	if (ids_count != i)
+		printk(KERN_ERR "dlm: bad nodeid count %d %d\n", ids_count, i);
+
+	if (!new_count)
+		goto out_ids;
+
+	new = kcalloc(new_count, sizeof(int), GFP_KERNEL);
+	if (!new) {
+		kfree(ids);
+		rv = -ENOMEM;
+		goto out;
+	}
 
-	if (rv != i)
-		printk("bad nodeid count %d %d\n", rv, i);
+	i = 0;
+	list_for_each_entry(nd, &sp->members, list) {
+		if (nd->new) {
+			new[i++] = nd->nodeid;
+			nd->new = 0;
+		}
+	}
+	*new_count_out = new_count;
+	*new_out = new;
 
+ out_ids:
+	*ids_count_out = ids_count;
 	*ids_out = ids;
  out:
 	mutex_unlock(&sp->members_lock);
diff --git a/fs/dlm/config.h b/fs/dlm/config.h
index a3170fe..4f1d6fc 100644
--- a/fs/dlm/config.h
+++ b/fs/dlm/config.h
@@ -35,7 +35,8 @@ extern struct dlm_config_info dlm_config;
 int dlm_config_init(void);
 void dlm_config_exit(void);
 int dlm_node_weight(char *lsname, int nodeid);
-int dlm_nodeid_list(char *lsname, int **ids_out);
+int dlm_nodeid_list(char *lsname, int **ids_out, int *ids_count_out,
+		    int **new_out, int *new_count_out);
 int dlm_nodeid_to_addr(int nodeid, struct sockaddr_storage *addr);
 int dlm_addr_to_nodeid(struct sockaddr_storage *addr, int *nodeid);
 int dlm_our_nodeid(void);
diff --git a/fs/dlm/dlm_internal.h b/fs/dlm/dlm_internal.h
index d30ea8b..c70c8e5 100644
--- a/fs/dlm/dlm_internal.h
+++ b/fs/dlm/dlm_internal.h
@@ -133,8 +133,10 @@ struct dlm_member {
 
 struct dlm_recover {
 	struct list_head	list;
-	int			*nodeids;
+	int			*nodeids;   /* nodeids of all members */
 	int			node_count;
+	int			*new;       /* nodeids of new members */
+	int			new_count;
 	uint64_t		seq;
 };
 
diff --git a/fs/dlm/member.c b/fs/dlm/member.c
index fa17f5a..26133f0 100644
--- a/fs/dlm/member.c
+++ b/fs/dlm/member.c
@@ -210,6 +210,23 @@ int dlm_recover_members(struct dlm_ls *ls, struct dlm_recover *rv, int *neg_out)
 		}
 	}
 
+	/* Add an entry to ls_nodes_gone for members that were removed and
+	   then added again, so that previous state for these nodes will be
+	   cleared during recovery. */
+
+	for (i = 0; i < rv->new_count; i++) {
+		if (!dlm_is_member(ls, rv->new[i]))
+			continue;
+		log_debug(ls, "new nodeid %d is a re-added member", rv->new[i]);
+
+		memb = kzalloc(sizeof(struct dlm_member), GFP_KERNEL);
+		if (!memb)
+			return -ENOMEM;
+		memb->nodeid = rv->new[i];
+		list_add_tail(&memb->list, &ls->ls_nodes_gone);
+		neg++;
+	}
+
 	/* add new members to ls_nodes */
 
 	for (i = 0; i < rv->node_count; i++) {
@@ -314,15 +331,16 @@ int dlm_ls_stop(struct dlm_ls *ls)
 int dlm_ls_start(struct dlm_ls *ls)
 {
 	struct dlm_recover *rv = NULL, *rv_old;
-	int *ids = NULL;
-	int error, count;
+	int *ids = NULL, *new = NULL;
+	int error, ids_count = 0, new_count = 0;
 
 	rv = kzalloc(sizeof(struct dlm_recover), GFP_KERNEL);
 	if (!rv)
 		return -ENOMEM;
 
-	error = count = dlm_nodeid_list(ls->ls_name, &ids);
-	if (error <= 0)
+	error = dlm_nodeid_list(ls->ls_name, &ids, &ids_count,
+				&new, &new_count);
+	if (error < 0)
 		goto fail;
 
 	spin_lock(&ls->ls_recover_lock);
@@ -337,14 +355,19 @@ int dlm_ls_start(struct dlm_ls *ls)
 	}
 
 	rv->nodeids = ids;
-	rv->node_count = count;
+	rv->node_count = ids_count;
+	rv->new = new;
+	rv->new_count = new_count;
 	rv->seq = ++ls->ls_recover_seq;
 	rv_old = ls->ls_recover_args;
 	ls->ls_recover_args = rv;
 	spin_unlock(&ls->ls_recover_lock);
 
 	if (rv_old) {
+		log_error(ls, "unused recovery %llx %d",
+			  (unsigned long long)rv_old->seq, rv_old->node_count);
 		kfree(rv_old->nodeids);
+		kfree(rv_old->new);
 		kfree(rv_old);
 	}
 
@@ -354,6 +377,7 @@ int dlm_ls_start(struct dlm_ls *ls)
  fail:
 	kfree(rv);
 	kfree(ids);
+	kfree(new);
 	return error;
 }
 
diff --git a/fs/dlm/recoverd.c b/fs/dlm/recoverd.c
index 997f953..fd677c8 100644
--- a/fs/dlm/recoverd.c
+++ b/fs/dlm/recoverd.c
@@ -257,6 +257,7 @@ static void do_ls_recovery(struct dlm_ls *ls)
 	if (rv) {
 		ls_recover(ls, rv);
 		kfree(rv->nodeids);
+		kfree(rv->new);
 		kfree(rv);
 	}
 }
-- 
1.5.3.3

