Return-Path: <linux-kernel-owner+w=401wt.eu-S932413AbYCEK0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932413AbYCEK0j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 05:26:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764511AbYCEKZj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 05:25:39 -0500
Received: from smtp-out.google.com ([216.239.33.17]:35100 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764306AbYCEKZh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 05:25:37 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=Hk2mTcQUZHJ2e4daS0Oh2lUWb0qgtW6eVsKvI9gyRRZH4RaPXq8Fd+tHGIvMtDmV1
	RoLEvmpYyIqlKbqMiESJQ==
Message-Id: <20080305102513.610692000@menage.corp.google.com>
References: <20080305102025.677459000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Wed, 05 Mar 2008 02:20:27 -0800
From: menage@google.com
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 2/2] CGroups _s64 files: Use read_s64/write_s64 in CFS cgroup for rt_runtime file
Content-Disposition: inline; filename=cfs_use_readwrite_s64.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes some filesystem boilerplate from the CFS cgroup subsystem.

Signed-off-by: Paul Menage <menage@google.com>

---
 kernel/sched.c |   52 +++++++++-------------------------------------------
 1 file changed, 9 insertions(+), 43 deletions(-)

Index: read_s64-2.6.25-rc3-mm1/kernel/sched.c
===================================================================
--- read_s64-2.6.25-rc3-mm1.orig/kernel/sched.c
+++ read_s64-2.6.25-rc3-mm1/kernel/sched.c
@@ -8081,48 +8081,14 @@ static u64 cpu_shares_read_u64(struct cg
 
 #ifdef CONFIG_RT_GROUP_SCHED
 static int cpu_rt_runtime_write(struct cgroup *cgrp, struct cftype *cft,
-				struct file *file,
-				const char __user *userbuf,
-				size_t nbytes, loff_t *unused_ppos)
-{
-	char buffer[64];
-	int retval = 0;
-	s64 val;
-	char *end;
-
-	if (!nbytes)
-		return -EINVAL;
-	if (nbytes >= sizeof(buffer))
-		return -E2BIG;
-	if (copy_from_user(buffer, userbuf, nbytes))
-		return -EFAULT;
-
-	buffer[nbytes] = 0;     /* nul-terminate */
-
-	/* strip newline if necessary */
-	if (nbytes && (buffer[nbytes-1] == '\n'))
-		buffer[nbytes-1] = 0;
-	val = simple_strtoll(buffer, &end, 0);
-	if (*end)
-		return -EINVAL;
-
-	/* Pass to subsystem */
-	retval = sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
-	if (!retval)
-		retval = nbytes;
-	return retval;
-}
-
-static ssize_t cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft,
-				   struct file *file,
-				   char __user *buf, size_t nbytes,
-				   loff_t *ppos)
-{
-	char tmp[64];
-	long val = sched_group_rt_runtime(cgroup_tg(cgrp));
-	int len = sprintf(tmp, "%ld\n", val);
+				s64 val)
+{
+	return sched_group_set_rt_runtime(cgroup_tg(cgrp), val);
+}
 
-	return simple_read_from_buffer(buf, nbytes, ppos, tmp, len);
+static s64 cpu_rt_runtime_read(struct cgroup *cgrp, struct cftype *cft)
+{
+	return sched_group_rt_runtime(cgroup_tg(cgrp));
 }
 #endif
 
@@ -8137,8 +8103,8 @@ static struct cftype cpu_files[] = {
 #ifdef CONFIG_RT_GROUP_SCHED
 	{
 		.name = "rt_runtime_us",
-		.read = cpu_rt_runtime_read,
-		.write = cpu_rt_runtime_write,
+		.read_s64 = cpu_rt_runtime_read,
+		.write_s64 = cpu_rt_runtime_write,
 	},
 #endif
 };

--
