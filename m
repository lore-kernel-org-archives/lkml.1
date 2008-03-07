Return-Path: <linux-kernel-owner+w=401wt.eu-S1762218AbYCGI7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762218AbYCGI7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 03:59:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756767AbYCGI7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 03:59:31 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36809 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756468AbYCGI73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 03:59:29 -0500
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Paul Menage <menage@google.com>, Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Hugh Dickins <hugh@veritas.com>, Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>, lizf@cn.fujitsu.com,
       linux-kernel@vger.kernel.org, taka@valinux.co.jp, linux-mm@kvack.org,
       David Rientjes <rientjes@google.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 07 Mar 2008 14:27:35 +0530
Message-Id: <20080307085735.25567.314.sendpatchset@localhost.localdomain>
Subject: [PATCH] Add cgroup support for enabling controllers at boot time (v2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Paul Menage <menage@google.com>

Changelog v2

1. Add enabled support in /proc/cgroups
2. Add support for parsing of several controller names


The effects of cgroup_disable=foo are:

- foo isn't auto-mounted if you mount all cgroups in a single hierarchy
- foo isn't visible as an individually mountable subsystem

As a result there will only ever be one call to foo->create(), at init
time; all processes will stay in this group, and the group will never
be mounted on a visible hierarchy. Any additional effects (e.g. not
allocating metadata) are up to the foo subsystem.

This doesn't handle early_init subsystems (their "disabled" bit isn't
set be, but it could easily be extended to do so if any of the early_init
systems wanted it - I think it would just involve some nastier parameter
processing since it would occur before the command-line argument parser
had been run.

Signed-off-by: Paul Menage <menage@google.com>
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 Documentation/kernel-parameters.txt |    4 +++
 include/linux/cgroup.h              |    1 
 kernel/cgroup.c                     |   45 ++++++++++++++++++++++++++++++++----
 3 files changed, 45 insertions(+), 5 deletions(-)

diff -puN include/linux/cgroup.h~cgroup_disable include/linux/cgroup.h
--- linux-2.6.25-rc4/include/linux/cgroup.h~cgroup_disable	2008-03-07 14:26:16.000000000 +0530
+++ linux-2.6.25-rc4-balbir/include/linux/cgroup.h	2008-03-07 14:26:16.000000000 +0530
@@ -256,6 +256,7 @@ struct cgroup_subsys {
 	void (*bind)(struct cgroup_subsys *ss, struct cgroup *root);
 	int subsys_id;
 	int active;
+	int disabled;
 	int early_init;
 #define MAX_CGROUP_TYPE_NAMELEN 32
 	const char *name;
diff -puN kernel/cgroup.c~cgroup_disable kernel/cgroup.c
--- linux-2.6.25-rc4/kernel/cgroup.c~cgroup_disable	2008-03-07 14:26:16.000000000 +0530
+++ linux-2.6.25-rc4-balbir/kernel/cgroup.c	2008-03-07 14:26:16.000000000 +0530
@@ -782,7 +782,14 @@ static int parse_cgroupfs_options(char *
 		if (!*token)
 			return -EINVAL;
 		if (!strcmp(token, "all")) {
-			opts->subsys_bits = (1 << CGROUP_SUBSYS_COUNT) - 1;
+			/* Add all non-disabled subsystems */
+			int i;
+			opts->subsys_bits = 0;
+			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+				struct cgroup_subsys *ss = subsys[i];
+				if (!ss->disabled)
+					opts->subsys_bits |= 1ul << i;
+			}
 		} else if (!strcmp(token, "noprefix")) {
 			set_bit(ROOT_NOPREFIX, &opts->flags);
 		} else if (!strncmp(token, "release_agent=", 14)) {
@@ -800,7 +807,8 @@ static int parse_cgroupfs_options(char *
 			for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 				ss = subsys[i];
 				if (!strcmp(token, ss->name)) {
-					set_bit(i, &opts->subsys_bits);
+					if (!ss->disabled)
+						set_bit(i, &opts->subsys_bits);
 					break;
 				}
 			}
@@ -2600,13 +2608,13 @@ static int proc_cgroupstats_show(struct 
 {
 	int i;
 
-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\n");
+	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
 	mutex_lock(&cgroup_mutex);
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
 		struct cgroup_subsys *ss = subsys[i];
-		seq_printf(m, "%s\t%lu\t%d\n",
+		seq_printf(m, "%s\t%lu\t%d\t%d\n",
 			   ss->name, ss->root->subsys_bits,
-			   ss->root->number_of_cgroups);
+			   ss->root->number_of_cgroups, !ss->disabled);
 	}
 	mutex_unlock(&cgroup_mutex);
 	return 0;
@@ -3010,3 +3018,30 @@ static void cgroup_release_agent(struct 
 	spin_unlock(&release_list_lock);
 	mutex_unlock(&cgroup_mutex);
 }
+
+static int __init cgroup_disable(char *str)
+{
+	int i;
+
+	while (*str) {
+		for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
+			struct cgroup_subsys *ss = subsys[i];
+
+			if (!strncmp(str, ss->name, strlen(ss->name))) {
+				ss->disabled = 1;
+				printk(KERN_INFO "Disabling %s control group"
+					" subsystem\n", ss->name);
+				break;
+			}
+		}
+		/*
+		 * Find the next option if any
+		 */
+		while (*str && (*str != ','))
+			str++;
+		if (*str == ',')
+			str++;
+	}
+	return 1;
+}
+__setup("cgroup_disable=", cgroup_disable);
diff -puN Documentation/kernel-parameters.txt~cgroup_disable Documentation/kernel-parameters.txt
--- linux-2.6.25-rc4/Documentation/kernel-parameters.txt~cgroup_disable	2008-03-07 14:26:16.000000000 +0530
+++ linux-2.6.25-rc4-balbir/Documentation/kernel-parameters.txt	2008-03-07 14:26:16.000000000 +0530
@@ -383,6 +383,10 @@ and is between 256 and 4096 characters. 
 	ccw_timeout_log [S390]
 			See Documentation/s390/CommonIO for details.
 
+	cgroup_disable= [KNL] Disable a particular controller
+			Format: {name of the controller(s) to disable}
+				{Currently supported controllers - "memory"}
+
 	checkreqprot	[SELINUX] Set initial checkreqprot flag value.
 			Format: { "0" | "1" }
 			See security/selinux/Kconfig help text.
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
