Return-Path: <linux-kernel-owner+w=401wt.eu-S1764864AbYCEIA1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764864AbYCEIA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 03:00:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757621AbYCEIAK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 03:00:10 -0500
Received: from smtp-out.google.com ([216.239.45.13]:7271 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756192AbYCEIAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 03:00:08 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=vfAHQeP7wVl+FuQf25FLzuYmm7BU3Xb2H1yplne0MsK48VQeBS915/8OSLgsQ7NwY
	fsG1UQyJ0kIQ/K0w4jUfA==
Message-Id: <20080305080000.270536000@menage.corp.google.com>
References: <20080305075237.608599000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Tue, 04 Mar 2008 23:52:38 -0800
From: menage@google.com
To: pj@sgi.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 1/2] Cpuset hardwall flag:  Switch cpusets to use the bulk cgroup_add_files() API
Content-Disposition: inline; filename=cpuset_add_files.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change tidies up the cpusets control file definitions, and
reduces the amount of boilerplate required to add/change control files
in the future.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cpuset.c |  149 +++++++++++++++++++++++++-------------------------------
 1 file changed, 68 insertions(+), 81 deletions(-)

Index: hardwall-2.6.25-rc3-mm1/kernel/cpuset.c
===================================================================
--- hardwall-2.6.25-rc3-mm1.orig/kernel/cpuset.c
+++ hardwall-2.6.25-rc3-mm1/kernel/cpuset.c
@@ -1397,46 +1397,69 @@ static u64 cpuset_read_u64(struct cgroup
  * for the common functions, 'private' gives the type of file
  */
 
-static struct cftype cft_cpus = {
-	.name = "cpus",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
-	.private = FILE_CPULIST,
-};
-
-static struct cftype cft_mems = {
-	.name = "mems",
-	.read = cpuset_common_file_read,
-	.write = cpuset_common_file_write,
-	.private = FILE_MEMLIST,
-};
-
-static struct cftype cft_cpu_exclusive = {
-	.name = "cpu_exclusive",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_CPU_EXCLUSIVE,
-};
-
-static struct cftype cft_mem_exclusive = {
-	.name = "mem_exclusive",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEM_EXCLUSIVE,
-};
-
-static struct cftype cft_sched_load_balance = {
-	.name = "sched_load_balance",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_SCHED_LOAD_BALANCE,
-};
-
-static struct cftype cft_memory_migrate = {
-	.name = "memory_migrate",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEMORY_MIGRATE,
+static struct cftype files[] = {
+	{
+		.name = "cpus",
+		.read = cpuset_common_file_read,
+		.write = cpuset_common_file_write,
+		.private = FILE_CPULIST,
+	},
+
+	{
+		.name = "mems",
+		.read = cpuset_common_file_read,
+		.write = cpuset_common_file_write,
+		.private = FILE_MEMLIST,
+	},
+
+	{
+		.name = "cpu_exclusive",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_CPU_EXCLUSIVE,
+	},
+
+	{
+		.name = "mem_exclusive",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEM_EXCLUSIVE,
+	},
+
+	{
+		.name = "sched_load_balance",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SCHED_LOAD_BALANCE,
+	},
+
+	{
+		.name = "memory_migrate",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEMORY_MIGRATE,
+	},
+
+	{
+		.name = "memory_pressure",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_MEMORY_PRESSURE,
+	},
+
+	{
+		.name = "memory_spread_page",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SPREAD_PAGE,
+	},
+
+	{
+		.name = "memory_spread_slab",
+		.read_u64 = cpuset_read_u64,
+		.write_u64 = cpuset_write_u64,
+		.private = FILE_SPREAD_SLAB,
+	},
 };
 
 static struct cftype cft_memory_pressure_enabled = {
@@ -1446,54 +1469,18 @@ static struct cftype cft_memory_pressure
 	.private = FILE_MEMORY_PRESSURE_ENABLED,
 };
 
-static struct cftype cft_memory_pressure = {
-	.name = "memory_pressure",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_MEMORY_PRESSURE,
-};
-
-static struct cftype cft_spread_page = {
-	.name = "memory_spread_page",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_SPREAD_PAGE,
-};
-
-static struct cftype cft_spread_slab = {
-	.name = "memory_spread_slab",
-	.read_u64 = cpuset_read_u64,
-	.write_u64 = cpuset_write_u64,
-	.private = FILE_SPREAD_SLAB,
-};
-
 static int cpuset_populate(struct cgroup_subsys *ss, struct cgroup *cont)
 {
 	int err;
 
-	if ((err = cgroup_add_file(cont, ss, &cft_cpus)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_mems)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_cpu_exclusive)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_mem_exclusive)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_memory_migrate)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_sched_load_balance)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_memory_pressure)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_spread_page)) < 0)
-		return err;
-	if ((err = cgroup_add_file(cont, ss, &cft_spread_slab)) < 0)
+	err = cgroup_add_files(cont, ss, files, ARRAY_SIZE(files));
+	if (err)
 		return err;
 	/* memory_pressure_enabled is in root cpuset only */
-	if (err == 0 && !cont->parent)
+	if (!cont->parent)
 		err = cgroup_add_file(cont, ss,
-					 &cft_memory_pressure_enabled);
-	return 0;
+				      &cft_memory_pressure_enabled);
+	return err;
 }
 
 /*

--
