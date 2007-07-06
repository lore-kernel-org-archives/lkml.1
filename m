Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbXGFFWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbXGFFWy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757805AbXGFFWg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:22:36 -0400
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:46218 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756418AbXGFFWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:22:35 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelianov <xemul@openvz.org>
Cc: Linux Containers <containers@lists.osdl.org>,
       Paul Menage <menage@google.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Linux MM Mailing List <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Eric W Biederman <ebiederm@xmission.com>
Date: Thu, 05 Jul 2007 22:21:55 -0700
Message-Id: <20070706052155.11677.41872.sendpatchset@balbir-laptop>
In-Reply-To: <20070706052029.11677.16964.sendpatchset@balbir-laptop>
References: <20070706052029.11677.16964.sendpatchset@balbir-laptop>
Subject: [-mm PATCH 5/8] Memory controller task migration (v2)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Allow tasks to migrate from one container to the other. We migrate
mm_struct's mem_container only when the thread group id migrates.


Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff -puN mm/memcontrol.c~mem-control-task-migration mm/memcontrol.c
--- linux-2.6.22-rc6/mm/memcontrol.c~mem-control-task-migration	2007-07-05 13:45:18.000000000 -0700
+++ linux-2.6.22-rc6-balbir/mm/memcontrol.c	2007-07-05 13:45:18.000000000 -0700
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
