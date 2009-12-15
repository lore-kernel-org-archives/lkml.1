Return-Path: <linux-kernel-owner+w=401wt.eu-S932628AbZLORSJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932628AbZLORSJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 12:18:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754636AbZLORSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 12:18:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:55049 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759624AbZLORSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 12:18:07 -0500
Subject: On cgroup, cpuset and rcu and a patch.
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Menage <menage@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Dec 2009 18:17:59 +0100
Message-ID: <1260897479.8023.603.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I'm wanting to use cpuset_cpus_allowed_locked() from within a scheduler
path (to break affinity in some rare cases), this however precludes that
I hold any mutex.

>From what I can see, its perfectly safe to use guarantee_online_cpus()
without holding any mutex, or even task_lock(), as long as I hold the
RCU read-lock, since cgroups are RCU-freed and task_cs() includes the
appropriate rcu_dereference(), and cgroup_attach_task() includes the
matching rcu_assign_pointer() call.

Or is there still any merit to the cpuset comments and am I missing some
detail -- which then ought to get fixed?

Also, while looking over the cgroup code, I found the below...

---
Subject: cgroup: fix RCU assumptions

The code relies on RCU read-lock to iterate the task list, but fails to
actually take it.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/cgroup.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux-2.6/kernel/cgroup.c
===================================================================
--- linux-2.6.orig/kernel/cgroup.c
+++ linux-2.6/kernel/cgroup.c
@@ -2127,6 +2127,7 @@ static void cgroup_enable_task_cg_lists(
 	struct task_struct *p, *g;
 	write_lock(&css_set_lock);
 	use_task_css_set_links = 1;
+	rcu_read_lock();
 	do_each_thread(g, p) {
 		task_lock(p);
 		/*
@@ -2138,6 +2139,7 @@ static void cgroup_enable_task_cg_lists(
 			list_add(&p->cg_list, &p->cgroups->tasks);
 		task_unlock(p);
 	} while_each_thread(g, p);
+	rcu_read_unlock();
 	write_unlock(&css_set_lock);
 }
 


