Return-Path: <linux-kernel-owner+w=401wt.eu-S1754666AbYDHLTq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754666AbYDHLTq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 07:19:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752303AbYDHLTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 07:19:19 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:4418 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893AbYDHLTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 07:19:18 -0400
From: "Denis V. Lunev" <den@openvz.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, "Denis V. Lunev" <den@openvz.org>
Subject: [PATCH 4/29] afs: use non-racy method for proc entries creation
Date: Tue,  8 Apr 2008 15:19:11 +0400
Message-Id: <1207653576-12640-4-git-send-email-den@openvz.org>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1207653508.7171.18.camel@iris.sw.ru>
References: <1207653508.7171.18.camel@iris.sw.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use proc_create()/proc_create_data() to make sure that ->proc_fops and
->data be setup before gluing PDE to main tree.

Signed-off-by: Denis V. Lunev <den@openvz.org>
CC: David Howells <dhowells@redhat.com>
---
 fs/afs/proc.c |   33 ++++++++++++++-------------------
 1 files changed, 14 insertions(+), 19 deletions(-)

diff --git a/fs/afs/proc.c b/fs/afs/proc.c
index 846c761..9f7d1ae 100644
--- a/fs/afs/proc.c
+++ b/fs/afs/proc.c
@@ -41,6 +41,7 @@ static const struct file_operations afs_proc_cells_fops = {
 	.write		= afs_proc_cells_write,
 	.llseek		= seq_lseek,
 	.release	= seq_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_rootcell_open(struct inode *inode, struct file *file);
@@ -56,7 +57,8 @@ static const struct file_operations afs_proc_rootcell_fops = {
 	.read		= afs_proc_rootcell_read,
 	.write		= afs_proc_rootcell_write,
 	.llseek		= no_llseek,
-	.release	= afs_proc_rootcell_release
+	.release	= afs_proc_rootcell_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_cell_volumes_open(struct inode *inode, struct file *file);
@@ -80,6 +82,7 @@ static const struct file_operations afs_proc_cell_volumes_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= afs_proc_cell_volumes_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_cell_vlservers_open(struct inode *inode,
@@ -104,6 +107,7 @@ static const struct file_operations afs_proc_cell_vlservers_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= afs_proc_cell_vlservers_release,
+	.owner		= THIS_MODULE,
 };
 
 static int afs_proc_cell_servers_open(struct inode *inode, struct file *file);
@@ -127,6 +131,7 @@ static const struct file_operations afs_proc_cell_servers_fops = {
 	.read		= seq_read,
 	.llseek		= seq_lseek,
 	.release	= afs_proc_cell_servers_release,
+	.owner		= THIS_MODULE,
 };
 
 /*
@@ -143,17 +148,13 @@ int afs_proc_init(void)
 		goto error_dir;
 	proc_afs->owner = THIS_MODULE;
 
-	p = create_proc_entry("cells", 0, proc_afs);
+	p = proc_create("cells", 0, proc_afs, &afs_proc_cells_fops);
 	if (!p)
 		goto error_cells;
-	p->proc_fops = &afs_proc_cells_fops;
-	p->owner = THIS_MODULE;
 
-	p = create_proc_entry("rootcell", 0, proc_afs);
+	p = proc_create("rootcell", 0, proc_afs, &afs_proc_rootcell_fops);
 	if (!p)
 		goto error_rootcell;
-	p->proc_fops = &afs_proc_rootcell_fops;
-	p->owner = THIS_MODULE;
 
 	_leave(" = 0");
 	return 0;
@@ -395,26 +396,20 @@ int afs_proc_cell_setup(struct afs_cell *cell)
 	if (!cell->proc_dir)
 		goto error_dir;
 
-	p = create_proc_entry("servers", 0, cell->proc_dir);
+	p = proc_create_data("servers", 0, cell->proc_dir,
+			     &afs_proc_cell_servers_fops, cell);
 	if (!p)
 		goto error_servers;
-	p->proc_fops = &afs_proc_cell_servers_fops;
-	p->owner = THIS_MODULE;
-	p->data = cell;
 
-	p = create_proc_entry("vlservers", 0, cell->proc_dir);
+	p = proc_create_data("vlservers", 0, cell->proc_dir,
+			     &afs_proc_cell_vlservers_fops, cell);
 	if (!p)
 		goto error_vlservers;
-	p->proc_fops = &afs_proc_cell_vlservers_fops;
-	p->owner = THIS_MODULE;
-	p->data = cell;
 
-	p = create_proc_entry("volumes", 0, cell->proc_dir);
+	p = proc_create_data("volumes", 0, cell->proc_dir,
+			     &afs_proc_cell_volumes_fops, cell);
 	if (!p)
 		goto error_volumes;
-	p->proc_fops = &afs_proc_cell_volumes_fops;
-	p->owner = THIS_MODULE;
-	p->data = cell;
 
 	_leave(" = 0");
 	return 0;
-- 
1.5.3.rc5

