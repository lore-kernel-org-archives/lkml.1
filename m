Return-Path: <linux-kernel-owner+w=401wt.eu-S1755240AbYBWX1D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240AbYBWX1D (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 18:27:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751288AbYBWX0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 18:26:51 -0500
Received: from smtp-out.google.com ([216.239.45.13]:39425 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbYBWX0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 18:26:51 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=TTN+vqX82VVy4LiqUk1KhYK172GRXucaGlKMMFDsPeRfxnORv4si9owQLlH1nEIpQ
	hAn9Ab6Je1UZCJ3l4JLEQ==
Message-Id: <20080223232617.634408000@menage.corp.google.com>
References: <20080223224725.115590000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Sat, 23 Feb 2008 14:47:28 -0800
From: menage@google.com
To: akpm@linux-foundation.org, balbir@in.ibm.com, pj@sgi.com,
       Pavel Emelianov <xemul@openvz.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>
Cc: linux-kernel@vger.kernel.org, containers@lists.linux-foundation.org
Subject: [PATCH 03/10] CGroup API files: Use read_u64 in memory controller
Content-Disposition: inline; filename=memcontrol_use_res_counter_read_uint.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update the memory controller to use read_u64 for its
limit/usage/failcnt control files, calling the new
res_counter_read_u64() function.

Signed-off-by: Paul Menage <menage@google.com>

---
 mm/memcontrol.c |   15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

Index: cgroup-2.6.25-rc2-mm1/mm/memcontrol.c
===================================================================
--- cgroup-2.6.25-rc2-mm1.orig/mm/memcontrol.c
+++ cgroup-2.6.25-rc2-mm1/mm/memcontrol.c
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
+	return res_counter_read_u64(&mem_cgroup_from_cont(cont)->res,
+				    cft->private);
 }
 
 static ssize_t mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
@@ -1024,18 +1021,18 @@ static struct cftype mem_cgroup_files[] 
 	{
 		.name = "usage_in_bytes",
 		.private = RES_USAGE,
-		.read = mem_cgroup_read,
+		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "limit_in_bytes",
 		.private = RES_LIMIT,
 		.write = mem_cgroup_write,
-		.read = mem_cgroup_read,
+		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "failcnt",
 		.private = RES_FAILCNT,
-		.read = mem_cgroup_read,
+		.read_u64 = mem_cgroup_read,
 	},
 	{
 		.name = "force_empty",

--
