Return-Path: <linux-kernel-owner+w=401wt.eu-S1762133AbYBOUv7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762133AbYBOUv7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 15:51:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753094AbYBOUvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 15:51:51 -0500
Received: from smtp-out.google.com ([216.239.33.17]:61695 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752698AbYBOUvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 15:51:50 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=PrXnD/uoP/eEZn+DPb2SrbbX9Qll/8WldueXqE8NxK1rrDNrEIo0rTf63qhlFQAoj
	8WosEDe+3a3s6aQpS52kg==
Message-Id: <20080215204821.433078000@menage.corp.google.com>
References: <20080215204418.535025000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Fri, 15 Feb 2008 12:44:23 -0800
From: Paul Menage <menage@google.com>
To: balbir@in.ibm.com, pj@sgi.com, Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       vatsa@linux.vnet.ibm.com, akpm@linux-foundation.org
Cc: containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 5/7] CGroup API: Use read_uint in memory controller
Content-Disposition: inline; filename=memcontrol_use_res_counter_read_uint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the memory controller to use read_uint for its
limit/usage/failcnt control files, calling the new
res_counter_read_uint() function. This allows the files to show up as
u64 rather than string in the cgroup.api file.

Signed-off-by: Paul Menage <menage@google.com>

---
 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: cgroupmap-2.6.24-mm1/mm/memcontrol.c
===================================================================
--- cgroupmap-2.6.24-mm1.orig/mm/memcontrol.c
+++ cgroupmap-2.6.24-mm1/mm/memcontrol.c
@@ -922,13 +922,10 @@ int mem_cgroup_write_strategy(char *buf,
 	return 0;
 }
 
-static ssize_t mem_cgroup_read(struct cgroup *cont,
-			struct cftype *cft, struct file *file,
-			char __user *userbuf, size_t nbytes, loff_t *ppos)
+static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
-	return res_counter_read(&mem_cgroup_from_cont(cont)->res,
-				cft->private, userbuf, nbytes, ppos,
-				NULL);
+	return res_counter_read_uint(&mem_cgroup_from_cont(cont)->res,
+				     cft->private);
 }
 
 static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
@@ -1006,18 +1003,18 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "usage_in_bytes",
 		.private = RES_USAGE,
-		.read = mem_cgroup_read,
+		.read_uint = mem_cgroup_read,
 	},
 	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
-		.read = mem_cgroup_read,
+		.read_uint = mem_cgroup_read,
 	},
 	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
-		.read = mem_cgroup_read,
+		.read_uint = mem_cgroup_read,
 	},
 	{
 		.name = "force_empty",

--
