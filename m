Return-Path: <linux-kernel-owner+w=401wt.eu-S1760949AbXIQVQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760949AbXIQVQe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 17:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932130AbXIQVKt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 17:10:49 -0400
Received: from smtp-out.google.com ([216.239.45.13]:52400 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674AbXIQVKs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 17:10:48 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:references:user-agent:date:from:to:cc:
	subject:content-disposition;
	b=D77LVZcE5UY7k4+SiLg20Ls/XpAlKmOOx/3ReiM3LF9cRzlTGfHOYD6imDKNrwbyE
	iGPPD3j/ARxnfF/NLsk1g==
Message-Id: <20070917210430.339558000@menage.corp.google.com>
References: <20070917210307.116234000@menage.corp.google.com>
User-Agent: quilt/0.45-1
Date: Mon, 17 Sep 2007 14:03:33 -0700
From: Paul Menage <menage@google.com>
To: akpm@linuxfoundation.org, balbir@linux.vnet.ibm.com,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Pavel Emelianov <xemul@openvz.org>,
       David Rientjes <rientjes@google.com>,
       Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, pj@sgi.com,
       containers@lists.osdl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 26/33] memory controller task migration v7
Content-Disposition: inline; filename=memory-controller-task-migration-v7.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Balbir Singh <balbir@linux.vnet.ibm.com>
(container->cgroup renaming by Paul Menage <menage@google.com>)

Allow tasks to migrate from one cgroup to the other.  We migrate
mm_struct's mem_cgroup only when the thread group id migrates.
 
Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
Signed-off-by: Paul Menage <menage@google.com>
---

 mm/memcontrol.c |   35 +++++++++++++++++++++++++++++++++++
 1 files changed, 35 insertions(+)

diff -puN mm/memcontrol.c~memory-controller-task-migration-v7 mm/memcontrol.c
--- a/mm/memcontrol.c~memory-controller-task-migration-v7
+++ a/mm/memcontrol.c
@@ -326,11 +326,46 @@ static int mem_cgroup_populate(struct
 					ARRAY_SIZE(mem_cgroup_files));
 }
 
+static void mem_cgroup_move_task(struct cgroup_subsys *ss,
+				struct cgroup *cont,
+				struct cgroup *old_cont,
+				struct task_struct *p)
+{
+	struct mm_struct *mm;
+	struct mem_cgroup *mem, *old_mem;
+
+	mm = get_task_mm(p);
+	if (mm == NULL)
+		return;
+
+	mem = mem_cgroup_from_cont(cont);
+	old_mem = mem_cgroup_from_cont(old_cont);
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
+	rcu_assign_pointer(mm->mem_cgroup, mem);
+	css_put(&old_mem->css);
+
+out:
+	mmput(mm);
+	return;
+}
+
 struct cgroup_subsys mem_cgroup_subsys = {
 	.name = "memory",
 	.subsys_id = mem_cgroup_subsys_id,
 	.create = mem_cgroup_create,
 	.destroy = mem_cgroup_destroy,
 	.populate = mem_cgroup_populate,
+	.attach = mem_cgroup_move_task,
 	.early_init = 1,
 };
_

--
