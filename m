Return-Path: <linux-kernel-owner+w=401wt.eu-S1755053AbXGDWX1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053AbXGDWX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 18:23:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759489AbXGDWWh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 18:22:37 -0400
Received: from ausmtp06.au.ibm.com ([202.81.18.155]:33705 "EHLO
	ausmtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543AbXGDWWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 18:22:35 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 04 Jul 2007 15:22:21 -0700
Message-Id: <20070704222221.17702.40032.sendpatchset@balbir-laptop>
In-Reply-To: <20070704222108.17702.40293.sendpatchset@balbir-laptop>
References: <20070704222108.17702.40293.sendpatchset@balbir-laptop>
Subject: [-mm PATCH 5/7] Memory controller task migration
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow tasks to migrate from one container to the other. We migrate
mm_struct's mem_container only when the thread group id migrates.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN mm/memcontrol.c~mem-control-task-migration mm/memcontrol.c
--- linux-2.6.22-rc6/mm/memcontrol.c~mem-control-task-migration	2007-07-04 15:05:29.000000000 -0700
+++ linux-2.6.22-rc6-balbir/mm/memcontrol.c	2007-07-04 15:05:29.000000000 -0700
@@ -302,11 +302,46 @@ err:
 	return rc;
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
 	.name = "mem_container",
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
