Return-Path: <linux-kernel-owner+w=401wt.eu-S1753653AbXHXPWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653AbXHXPWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 11:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbXHXPUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 11:20:53 -0400
Received: from E23SMTP03.au.ibm.com ([202.81.18.172]:46323 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbXHXPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 11:20:52 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.osdl.org>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Eric W Biederman <ebiederm@xmission.com>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Nick Piggin <npiggin@suse.de>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Dave Hansen <haveblue@us.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 24 Aug 2007 20:50:43 +0530
Message-Id: <20070824152043.16582.37727.sendpatchset@balbir-laptop>
In-Reply-To: <20070824151948.16582.34424.sendpatchset@balbir-laptop>
References: <20070824151948.16582.34424.sendpatchset@balbir-laptop>
Subject: [-mm PATCH 5/10] Memory controller task migration (v7)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow tasks to migrate from one container to the other. We migrate
mm_struct's mem_container only when the thread group id migrates.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN mm/memcontrol.c~mem-control-task-migration mm/memcontrol.c
--- linux-2.6.23-rc2-mm2/mm/memcontrol.c~mem-control-task-migration	2007-08-24 20:46:07.000000000 +0530
+++ linux-2.6.23-rc2-mm2-balbir/mm/memcontrol.c	2007-08-24 20:46:07.000000000 +0530
@@ -326,11 +326,46 @@ static int mem_container_populate(struct
 					ARRAY_SIZE(mem_container_files));
 }
 
+static void mem_container_move_task(struct container_subsys *ss,
+				struct container *cont,
+				struct container *old_cont,
+				struct task_struct *p)
+{
+	struct mm_struct *mm;
+	struct mem_container *mem, *old_mem;
+
+	mm = get_task_mm(p);
+	if (mm == NULL)
+		return;
+
+	mem = mem_container_from_cont(cont);
+	old_mem = mem_container_from_cont(old_cont);
+
+	if (mem == old_mem)
+		goto out;
+
+	/*
+	 * Only thread group leaders are allowed to migrate, the mm_struct is
+	 * in effect owned by the leader
+	 */
+	if (p->tgid != p->pid)
+		goto out;
+
+	css_get(&mem->css);
+	rcu_assign_pointer(mm->mem_container, mem);
+	css_put(&old_mem->css);
+
+out:
+	mmput(mm);
+	return;
+}
+
 struct container_subsys mem_container_subsys = {
 	.name = "memory",
 	.subsys_id = mem_container_subsys_id,
 	.create = mem_container_create,
 	.destroy = mem_container_destroy,
 	.populate = mem_container_populate,
+	.attach = mem_container_move_task,
 	.early_init = 1,
 };
_

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
