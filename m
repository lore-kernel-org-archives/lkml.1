Return-Path: <linux-kernel-owner+w=401wt.eu-S1757296AbYEGBIw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757296AbYEGBIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 21:08:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752532AbYEGBIm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 21:08:42 -0400
Received: from smtp-out.google.com ([216.239.33.17]:58542 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbYEGBIl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 21:08:41 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:user-agent:mime-version:to:cc:
	subject:content-type:content-transfer-encoding;
	b=hmb2Ga3G1008qUIgp0DxlYx//LKhGYN5loYBaYWUGhOZhVqszljy/ATWmeAM/F/RA
	7d9LPKrmd+E1QhkGILihg==
Message-ID: <48210101.1070205@google.com>
Date: Tue, 06 May 2008 18:08:17 -0700
From: Paul Menage <menage@google.com>
User-Agent: Thunderbird 1.5.0.14ubu (X11/20080306)
MIME-Version: 1.0
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Paul Jackson <pj@sgi.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: [PATCH] Fix cpuset sched_relax_domain_level control file
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix cpuset sched_relax_domain_level control file

Due to a merge conflict, the sched_relax_domain_level control file was
marked as being handled by cpuset_read/write_u64, but the code to handle it
was actually in cpuset_common_file_read/write.

Since the value being written/read is in fact a signed integer, it
should be treated as such; this patch adds cpuset_read/write_s64
functions, and uses them to handle the sched_relax_domain_level file.

With this patch, the sched_relax_domain_level can be read and written,
and the correct contents seen/updated.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/cpuset.c |   52 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 40 insertions(+), 12 deletions(-)

Index: cpusetfix-2.6.26-rc1/kernel/cpuset.c
===================================================================
--- cpusetfix-2.6.26-rc1.orig/kernel/cpuset.c
+++ cpusetfix-2.6.26-rc1/kernel/cpuset.c
@@ -1031,11 +1031,9 @@ int current_cpuset_is_being_rebound(void
 	return task_cs(current) == cpuset_being_rebound;
 }
 
-static int update_relax_domain_level(struct cpuset *cs, char *buf)
+static int update_relax_domain_level(struct cpuset *cs, s64 val)
 {
-	int val = simple_strtol(buf, NULL, 10);
-
-	if (val < 0)
+	if ((int)val < 0)
 		val = -1;
 
 	if (val != cs->relax_domain_level) {
@@ -1280,9 +1278,6 @@ static ssize_t cpuset_common_file_write(
 	case FILE_MEMLIST:
 		retval = update_nodemask(cs, buffer);
 		break;
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		retval = update_relax_domain_level(cs, buffer);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out2;
@@ -1348,6 +1343,30 @@ static int cpuset_write_u64(struct cgrou
 	return retval;
 }
 
+static int cpuset_write_s64(struct cgroup *cgrp, struct cftype *cft, s64 val)
+{
+	int retval = 0;
+	struct cpuset *cs = cgroup_cs(cgrp);
+	cpuset_filetype_t type = cft->private;
+
+	cgroup_lock();
+
+	if (cgroup_is_removed(cgrp)) {
+		cgroup_unlock();
+		return -ENODEV;
+	}
+	switch (type) {
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		retval = update_relax_domain_level(cs, val);
+		break;
+	default:
+		retval = -EINVAL;
+		break;
+	}
+	cgroup_unlock();
+	return retval;
+}
+
 /*
  * These ascii lists should be read in a single call, by using a user
  * buffer large enough to hold the entire map.  If read in smaller
@@ -1406,9 +1425,6 @@ static ssize_t cpuset_common_file_read(s
 	case FILE_MEMLIST:
 		s += cpuset_sprintf_memlist(s, cs);
 		break;
-	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
-		s += sprintf(s, "%d", cs->relax_domain_level);
-		break;
 	default:
 		retval = -EINVAL;
 		goto out;
@@ -1449,6 +1465,18 @@ static u64 cpuset_read_u64(struct cgroup
 	}
 }
 
+static s64 cpuset_read_s64(struct cgroup *cont, struct cftype *cft)
+{
+	struct cpuset *cs = cgroup_cs(cont);
+	cpuset_filetype_t type = cft->private;
+	switch (type) {
+	case FILE_SCHED_RELAX_DOMAIN_LEVEL:
+		return cs->relax_domain_level;
+	default:
+		BUG();
+	}
+}
+
 
 /*
  * for the common functions, 'private' gives the type of file
@@ -1499,8 +1527,8 @@ static struct cftype files[] = {
 
 	{
 		.name = "sched_relax_domain_level",
-		.read_u64 = cpuset_read_u64,
-		.write_u64 = cpuset_write_u64,
+		.read_s64 = cpuset_read_s64,
+		.write_s64 = cpuset_write_s64,
 		.private = FILE_SCHED_RELAX_DOMAIN_LEVEL,
 	},
 
