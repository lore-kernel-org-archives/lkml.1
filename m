Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbYLAP1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbYLAP1E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 10:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbYLAP0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 10:26:53 -0500
Received: from ausmtp04.au.ibm.com ([202.81.18.152]:51484 "EHLO
	ausmtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbYLAP0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 10:26:51 -0500
Date: Mon, 1 Dec 2008 20:49:05 +0530
From: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       vatsa@in.ibm.com, bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH v2] sched: add uid information to sched_debug for
	CONFIG_USER_SCHED
Message-ID: <20081201151905.GA8448@linux.vnet.ibm.com>
Reply-To: arun@linux.vnet.ibm.com
Mail-Followup-To: Ingo Molnar <mingo@elte.hu>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	linux-kernel@vger.kernel.org, vatsa@in.ibm.com,
	bharata@linux.vnet.ibm.com, dhaval@linux.vnet.ibm.com
References: <20081201112954.GH20329@linux.vnet.ibm.com> <1228131416.7251.306.camel@twins> <20081201124452.GA21534@elte.hu> <20081201125628.GA25438@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20081201125628.GA25438@elte.hu>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Ingo Molnar <mingo@elte.hu> [2008-12-01 13:56:28]:

> 
> * Ingo Molnar <mingo@elte.hu> wrote:
> 
> > 
> > * Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > 
> > > On Mon, 2008-12-01 at 16:59 +0530, Arun R Bharadwaj wrote:
> > > > Hi,
> > > > 
> > > > This patch adds uid information in sched_debug for CONFIG_USER_SCHED
> > > 
> > > I'd much rather have people working at removing USER_SCHED,. but sure,
> > > the patch looks sane..
> > 
> > ok, i have applied it to tip/sched/core.
> 
> it doesnt build:
> 
>  kernel/sched_debug.c: In function 'print_cfs_rq':
>  kernel/sched_debug.c:165: error: 'struct cfs_rq' has no member named 'tg'
> 
> please send v2 patch.
> 
> Ingo

Hi Ingo,

I've posted v2 of the patch.
Had missed an '&& #if defined(CONFIG_FAIR_GROUP_SCHED)' last time
around.

--arun


This patch adds uid information in sched_debug for CONFIG_USER_SCHED

Signed-off-by: Arun R Bharadwaj <arun@linux.vnet.ibm.com>
---
 include/linux/sched.h |    1 +
 kernel/sched.c        |   10 ++++++++++
 kernel/sched_debug.c  |    6 +++++-
 kernel/user.c         |    2 ++
 4 files changed, 18 insertions(+), 1 deletion(-)

Index: git-2.6/kernel/sched_debug.c
===================================================================
--- git-2.6.orig/kernel/sched_debug.c
+++ git-2.6/kernel/sched_debug.c
@@ -131,10 +131,14 @@ void print_cfs_rq(struct seq_file *m, in
 		cgroup_path(cgroup, path, sizeof(path));
 
 	SEQ_printf(m, "\ncfs_rq[%d]:%s\n", cpu, path);
+#elif defined(CONFIG_USER_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
+	{
+		uid_t uid = cfs_rq->tg->uid;
+		SEQ_printf(m, "\ncfs_rq[%d] for UID: %u\n", cpu, uid);
+	}
 #else
 	SEQ_printf(m, "\ncfs_rq[%d]:\n", cpu);
 #endif
-
 	SEQ_printf(m, "  .%-30s: %Ld.%06ld\n", "exec_clock",
 			SPLIT_NS(cfs_rq->exec_clock));
 
Index: git-2.6/kernel/sched.c
===================================================================
--- git-2.6.orig/kernel/sched.c
+++ git-2.6/kernel/sched.c
@@ -261,6 +261,10 @@ struct task_group {
 	struct cgroup_subsys_state css;
 #endif
 
+#ifdef CONFIG_USER_SCHED
+	uid_t uid;
+#endif
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* schedulable entities of this group on each cpu */
 	struct sched_entity **se;
@@ -286,6 +290,12 @@ struct task_group {
 
 #ifdef CONFIG_USER_SCHED
 
+/* Helper function to pass uid information to create_sched_user() */
+void set_tg_uid(struct user_struct *user)
+{
+	user->tg->uid = user->uid;
+}
+
 /*
  * Root task group.
  * 	Every UID task group (including init_task_group aka UID-0) will
Index: git-2.6/kernel/user.c
===================================================================
--- git-2.6.orig/kernel/user.c
+++ git-2.6/kernel/user.c
@@ -101,6 +101,8 @@ static int sched_create_user(struct user
 	if (IS_ERR(up->tg))
 		rc = -ENOMEM;
 
+	set_tg_uid(up);
+
 	return rc;
 }
 
Index: git-2.6/include/linux/sched.h
===================================================================
--- git-2.6.orig/include/linux/sched.h
+++ git-2.6/include/linux/sched.h
@@ -2220,6 +2220,7 @@ extern void normalize_rt_tasks(void);
 extern struct task_group init_task_group;
 #ifdef CONFIG_USER_SCHED
 extern struct task_group root_task_group;
+extern void set_tg_uid(struct user_struct *user);
 #endif
 
 extern struct task_group *sched_create_group(struct task_group *parent);
