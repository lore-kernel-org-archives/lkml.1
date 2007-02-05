Return-Path: <linux-kernel-owner+w=401wt.eu-S932734AbXBEOR6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbXBEOR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 09:17:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932789AbXBEOR6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 09:17:58 -0500
Received: from mx1.redhat.com ([66.187.233.31]:46567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932734AbXBEOR5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 09:17:57 -0500
Subject: [DLM] expose dlm_config_info fields in configfs [20/54]
From: Steven Whitehouse <swhiteho@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Teigland <teigland@redhat.com>, cluster-devel@redhat.com
In-Reply-To: <1170684425.11001.267.camel@quoit.chygwyn.com>
References: <1170684425.11001.267.camel@quoit.chygwyn.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd
Date: Mon, 05 Feb 2007 14:25:58 +0000
Message-Id: <1170685558.11001.311.camel@quoit.chygwyn.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.2.2 (2.2.2-5) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 006dc1bd2748f0423cbc6edcd43376ed6717b5ab Mon Sep 17 00:00:00 2001
From: David Teigland <teigland@redhat.com>
Date: Tue, 9 Jan 2007 09:46:02 -0600
Subject: [PATCH] [DLM] expose dlm_config_info fields in configfs

Make the dlm_config_info values readable and writeable via configfs
entries.

Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Steven Whitehouse <swhiteho@redhat.com>

diff --git a/fs/dlm/config.c b/fs/dlm/config.c
index 7cf2020..8665c88 100644
--- a/fs/dlm/config.c
+++ b/fs/dlm/config.c
@@ -54,6 +54,11 @@ static struct config_item *make_node(struct config_group *, const char *);
 static void drop_node(struct config_group *, struct config_item *);
 static void release_node(struct config_item *);
 
+static ssize_t show_cluster(struct config_item *i, struct configfs_attribute *a,
+			    char *buf);
+static ssize_t store_cluster(struct config_item *i,
+			     struct configfs_attribute *a,
+			     const char *buf, size_t len);
 static ssize_t show_comm(struct config_item *i, struct configfs_attribute *a,
 			 char *buf);
 static ssize_t store_comm(struct config_item *i, struct configfs_attribute *a,
@@ -73,6 +78,101 @@ static ssize_t node_nodeid_write(struct node *nd, const char *buf, size_t len);
 static ssize_t node_weight_read(struct node *nd, char *buf);
 static ssize_t node_weight_write(struct node *nd, const char *buf, size_t len);
 
+struct cluster {
+	struct config_group group;
+	unsigned int cl_tcp_port;
+	unsigned int cl_buffer_size;
+	unsigned int cl_rsbtbl_size;
+	unsigned int cl_lkbtbl_size;
+	unsigned int cl_dirtbl_size;
+	unsigned int cl_recover_timer;
+	unsigned int cl_toss_secs;
+	unsigned int cl_scan_secs;
+	unsigned int cl_log_debug;
+};
+
+enum {
+	CLUSTER_ATTR_TCP_PORT = 0,
+	CLUSTER_ATTR_BUFFER_SIZE,
+	CLUSTER_ATTR_RSBTBL_SIZE,
+	CLUSTER_ATTR_LKBTBL_SIZE,
+	CLUSTER_ATTR_DIRTBL_SIZE,
+	CLUSTER_ATTR_RECOVER_TIMER,
+	CLUSTER_ATTR_TOSS_SECS,
+	CLUSTER_ATTR_SCAN_SECS,
+	CLUSTER_ATTR_LOG_DEBUG,
+};
+
+struct cluster_attribute {
+	struct configfs_attribute attr;
+	ssize_t (*show)(struct cluster *, char *);
+	ssize_t (*store)(struct cluster *, const char *, size_t);
+};
+
+static ssize_t cluster_set(struct cluster *cl, unsigned int *cl_field,
+			   unsigned int *info_field, int check_zero,
+			   const char *buf, size_t len)
+{
+	unsigned int x;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EACCES;
+
+	x = simple_strtoul(buf, NULL, 0);
+
+	if (check_zero && !x)
+		return -EINVAL;
+
+	*cl_field = x;
+	*info_field = x;
+
+	return len;
+}
+
+#define __CONFIGFS_ATTR(_name,_mode,_read,_write) {                           \
+	.attr   = { .ca_name = __stringify(_name),                            \
+		    .ca_mode = _mode,                                         \
+		    .ca_owner = THIS_MODULE },                                \
+	.show   = _read,                                                      \
+	.store  = _write,                                                     \
+}
+
+#define CLUSTER_ATTR(name, check_zero)                                        \
+static ssize_t name##_write(struct cluster *cl, const char *buf, size_t len)  \
+{                                                                             \
+	return cluster_set(cl, &cl->cl_##name, &dlm_config.ci_##name,         \
+			   check_zero, buf, len);                             \
+}                                                                             \
+static ssize_t name##_read(struct cluster *cl, char *buf)                     \
+{                                                                             \
+	return snprintf(buf, PAGE_SIZE, "%u\n", cl->cl_##name);               \
+}                                                                             \
+static struct cluster_attribute cluster_attr_##name =                         \
+__CONFIGFS_ATTR(name, 0644, name##_read, name##_write)
+
+CLUSTER_ATTR(tcp_port, 1);
+CLUSTER_ATTR(buffer_size, 1);
+CLUSTER_ATTR(rsbtbl_size, 1);
+CLUSTER_ATTR(lkbtbl_size, 1);
+CLUSTER_ATTR(dirtbl_size, 1);
+CLUSTER_ATTR(recover_timer, 1);
+CLUSTER_ATTR(toss_secs, 1);
+CLUSTER_ATTR(scan_secs, 1);
+CLUSTER_ATTR(log_debug, 0);
+
+static struct configfs_attribute *cluster_attrs[] = {
+	[CLUSTER_ATTR_TCP_PORT] = &cluster_attr_tcp_port.attr,
+	[CLUSTER_ATTR_BUFFER_SIZE] = &cluster_attr_buffer_size.attr,
+	[CLUSTER_ATTR_RSBTBL_SIZE] = &cluster_attr_rsbtbl_size.attr,
+	[CLUSTER_ATTR_LKBTBL_SIZE] = &cluster_attr_lkbtbl_size.attr,
+	[CLUSTER_ATTR_DIRTBL_SIZE] = &cluster_attr_dirtbl_size.attr,
+	[CLUSTER_ATTR_RECOVER_TIMER] = &cluster_attr_recover_timer.attr,
+	[CLUSTER_ATTR_TOSS_SECS] = &cluster_attr_toss_secs.attr,
+	[CLUSTER_ATTR_SCAN_SECS] = &cluster_attr_scan_secs.attr,
+	[CLUSTER_ATTR_LOG_DEBUG] = &cluster_attr_log_debug.attr,
+	NULL,
+};
+
 enum {
 	COMM_ATTR_NODEID = 0,
 	COMM_ATTR_LOCAL,
@@ -152,10 +252,6 @@ struct clusters {
 	struct configfs_subsystem subsys;
 };
 
-struct cluster {
-	struct config_group group;
-};
-
 struct spaces {
 	struct config_group ss_group;
 };
@@ -197,6 +293,8 @@ static struct configfs_group_operations clusters_ops = {
 
 static struct configfs_item_operations cluster_ops = {
 	.release = release_cluster,
+	.show_attribute = show_cluster,
+	.store_attribute = store_cluster,
 };
 
 static struct configfs_group_operations spaces_ops = {
@@ -237,6 +335,7 @@ static struct config_item_type clusters_type = {
 
 static struct config_item_type cluster_type = {
 	.ct_item_ops = &cluster_ops,
+	.ct_attrs = cluster_attrs,
 	.ct_owner = THIS_MODULE,
 };
 
@@ -317,6 +416,16 @@ static struct config_group *make_cluster(struct config_group *g,
 	cl->group.default_groups[1] = &cms->cs_group;
 	cl->group.default_groups[2] = NULL;
 
+	cl->cl_tcp_port = dlm_config.ci_tcp_port;
+	cl->cl_buffer_size = dlm_config.ci_buffer_size;
+	cl->cl_rsbtbl_size = dlm_config.ci_rsbtbl_size;
+	cl->cl_lkbtbl_size = dlm_config.ci_lkbtbl_size;
+	cl->cl_dirtbl_size = dlm_config.ci_dirtbl_size;
+	cl->cl_recover_timer = dlm_config.ci_recover_timer;
+	cl->cl_toss_secs = dlm_config.ci_toss_secs;
+	cl->cl_scan_secs = dlm_config.ci_scan_secs;
+	cl->cl_log_debug = dlm_config.ci_log_debug;
+
 	space_list = &sps->ss_group;
 	comm_list = &cms->cs_group;
 	return &cl->group;
@@ -509,6 +618,25 @@ void dlm_config_exit(void)
  * Functions for user space to read/write attributes
  */
 
+static ssize_t show_cluster(struct config_item *i, struct configfs_attribute *a,
+			    char *buf)
+{
+	struct cluster *cl = to_cluster(i);
+	struct cluster_attribute *cla =
+			container_of(a, struct cluster_attribute, attr);
+	return cla->show ? cla->show(cl, buf) : 0;
+}
+
+static ssize_t store_cluster(struct config_item *i,
+			     struct configfs_attribute *a,
+			     const char *buf, size_t len)
+{
+	struct cluster *cl = to_cluster(i);
+	struct cluster_attribute *cla =
+		container_of(a, struct cluster_attribute, attr);
+	return cla->store ? cla->store(cl, buf, len) : -EINVAL;
+}
+
 static ssize_t show_comm(struct config_item *i, struct configfs_attribute *a,
 			 char *buf)
 {
-- 
1.4.4.2



