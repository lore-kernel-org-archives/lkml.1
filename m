Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbYBWXau@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbYBWXau (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:30:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757277AbYBWX1x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:27:53 -0500
Received: from smtp-out.google.com ([216.239.33.17]:5177 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbYBWX1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:27:49 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=tPdGXF67DG+UrjPEGpo6Oy6nOXJNMZv/XdxKsBbkF4llg63hNFG7sv0q5w9OPolw4
	UANPomOLJHnVSxOcPqXkA==
Message-Id: <20080223232618.282132000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:32 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 07/10] CGroup API files: Use cgroup map for memcontrol stats file
Content-Disposition: inline; filename=memcontrol_use_cgroup_map.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the seq_file boilerplate used to construct the memcontrol stats
map, and instead use the new map representation for cgroup control
files

Signed-off-by: Paul Menage <menage@google.com>

---
 mm/memcontrol.c |   30 ++++++------------------------
 1 file changed, 6 insertions(+), 24 deletions(-)

Index: cgroup-2.6.25-rc2-mm1/mm/memcontrol.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/mm/memcontrol.c
+++ cgroup-2.6.25-rc2-mm1/mm/memcontrol.c
@@ -971,9 +971,9 @@ static const struct mem_cgroup_stat_desc
 	[MEM_CGROUP_STAT_RSS] = { "rss", PAGE_SIZE, },
 };
 
-static int mem_control_stat_show(struct seq_file *m, void *arg)
+static int mem_control_stat_show(struct cgroup *cont, struct cftype *cft,
+				 struct cgroup_map_cb *cb)
 {
-	struct cgroup *cont = m->private;
 	struct mem_cgroup *mem_cont = mem_cgroup_from_cont(cont);
 	struct mem_cgroup_stat *stat = &mem_cont->stat;
 	int i;
@@ -983,8 +983,7 @@ static int mem_control_stat_show(struct 
 
 		val = mem_cgroup_read_stat(stat, i);
 		val *= mem_cgroup_stat_desc[i].unit;
-		seq_printf(m, "%s %lld\n", mem_cgroup_stat_desc[i].msg,
-				(long long)val);
+		cb->fill(cb, mem_cgroup_stat_desc[i].msg, val);
 	}
 	/* showing # of active pages */
 	{
@@ -994,29 +993,12 @@ static int mem_control_stat_show(struct 
 						MEM_CGROUP_ZSTAT_INACTIVE);
 		active = mem_cgroup_get_all_zonestat(mem_cont,
 						MEM_CGROUP_ZSTAT_ACTIVE);
-		seq_printf(m, "active %ld\n", (active) * PAGE_SIZE);
-		seq_printf(m, "inactive %ld\n", (inactive) * PAGE_SIZE);
+		cb->fill(cb, "active", (active) * PAGE_SIZE);
+		cb->fill(cb, "inactive", (inactive) * PAGE_SIZE);
 	}
 	return 0;
 }
 
-static const struct file_operations mem_control_stat_file_operations = {
-	.read = seq_read,
-	.llseek = seq_lseek,
-	.release = single_release,
-};
-
-static int mem_control_stat_open(struct inode *unused, struct file *file)
-{
-	/* XXX __d_cont */
-	struct cgroup *cont = file->f_dentry->d_parent->d_fsdata;
-
-	file->f_op = &mem_control_stat_file_operations;
-	return single_open(file, mem_control_stat_show, cont);
-}
-
-
-
 static struct cftype mem_cgroup_files[] = {
 	{
 		.name = "usage_in_bytes",
@@ -1041,7 +1023,7 @@ static struct cftype mem_cgroup_files[] 
 	},
 	{
 		.name = "stat",
-		.open = mem_control_stat_open,
+		.read_map = mem_control_stat_show,
 	},
 };
 

--
