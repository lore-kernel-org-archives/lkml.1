Return-Path: <linux-kernel-owner+w=401wt.eu-S1756782AbYLPMmm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782AbYLPMmm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:42:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756094AbYLPMm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:42:28 -0500
Received: from smtp-out.google.com ([216.239.45.13]:2627 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047AbYLPMm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:42:27 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding;
	b=mOC4Yh27bUaPBQGU3AkgGuEmh3cQjuMKlDfXhMmkB2WcUMQyfavUaRgPhnpRzKAJy
	396Mr/C+cueDPLVLsi8mQ==
MIME-Version: 1.0
In-Reply-To: <6599ad830812160141v5ed5d453h36f825b069554e57@mail.gmail.com>
References: <494234B0.5@cn.fujitsu.com> <20081212100044.GB18152@elte.hu>
	 <4944754F.8050503@cn.fujitsu.com>
	 <1229258890.17130.9.camel@lappy.programming.kicks-ass.net>
	 <4945B200.7020207@cn.fujitsu.com> <1229328783.14605.11.camel@twins>
	 <49462890.1040002@cn.fujitsu.com> <1229337829.14605.41.camel@twins>
	 <6599ad830812160141v5ed5d453h36f825b069554e57@mail.gmail.com>
Date: Tue, 16 Dec 2008 04:42:23 -0800
Message-ID: <6599ad830812160442p349fac09u9627ac2b81f76905@mail.gmail.com>
Subject: Re: [PATCH] sched: fix another race when reading /proc/sched_debug
From: Paul Menage <menage@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 16, 2008 at 1:41 AM, Paul Menage <menage@google.com> wrote:
>
> It should be OK to rcu-free cgrp and have it still safe to call
> cgroup_path() on it - as long as we're confident that the dentry (and
> all its parents) won't be released until after the RCU section as
> well, since that's where we get the path elements from. And that does
> seem to be the case from looking at dcache.c
>
> It's certainly nicer than having two calls to synchronize_rcu() in
> quick succession in cgroup_diput().

How about something like this?

Paul

 include/linux/cgroup.h |    9 +++++++++
 kernel/cgroup.c        |   49 ++++++++++++++++++++++++++++---------------------
 2 files changed, 37 insertions(+), 21 deletions(-)

Index: cgroup-rcu-mmotm-2008-12-09/include/linux/cgroup.h
===================================================================
--- cgroup-rcu-mmotm-2008-12-09.orig/include/linux/cgroup.h
+++ cgroup-rcu-mmotm-2008-12-09/include/linux/cgroup.h
@@ -145,6 +145,9 @@ struct cgroup {
 	int pids_use_count;
 	/* Length of the current tasks_pids array */
 	int pids_length;
+
+	/* For RCU-protected deletion */
+	struct rcu_head rcu_head;
 };

 /* A css_set is a structure holding pointers to a set of
@@ -305,6 +308,12 @@ int cgroup_add_files(struct cgroup *cgrp

 int cgroup_is_removed(const struct cgroup *cgrp);

+/*
+ * cgroup_path() fills in a filesystem-like path for the given cgroup
+ * into "buf", up to "buflen" characters. Should be called with
+ * cgroup_mutex held, or else in an RCU section with an RCU-protected
+ * cgroup reference
+ */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen);

 int cgroup_task_count(const struct cgroup *cgrp);
Index: cgroup-rcu-mmotm-2008-12-09/kernel/cgroup.c
===================================================================
--- cgroup-rcu-mmotm-2008-12-09.orig/kernel/cgroup.c
+++ cgroup-rcu-mmotm-2008-12-09/kernel/cgroup.c
@@ -271,7 +271,7 @@ static void __put_css_set(struct css_set

 	rcu_read_lock();
 	for (i = 0; i < CGROUP_SUBSYS_COUNT; i++) {
-		struct cgroup *cgrp = cg->subsys[i]->cgroup;
+		struct cgroup *cgrp = rcu_dereference(cg->subsys[i]->cgroup);
 		if (atomic_dec_and_test(&cgrp->count) &&
 		    notify_on_release(cgrp)) {
 			if (taskexit)
@@ -595,6 +595,18 @@ static void cgroup_call_pre_destroy(stru
 	return;
 }

+static void __free_cgroup_rcu(struct rcu_head *obj)
+{
+	struct cgroup *cgrp = container_of(obj, struct cgroup, rcu_head);
+	/*
+	 * Drop the active superblock reference that we took when we
+	 * created the cgroup
+	 */
+	deactivate_super(cgrp->root->sb);
+
+	kfree(cgrp);
+}
+
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 {
 	/* is dentry a directory ? if so, kfree() associated cgroup */
@@ -602,13 +614,6 @@ static void cgroup_diput(struct dentry *
 		struct cgroup *cgrp = dentry->d_fsdata;
 		struct cgroup_subsys *ss;
 		BUG_ON(!(cgroup_is_removed(cgrp)));
-		/* It's possible for external users to be holding css
-		 * reference counts on a cgroup; css_put() needs to
-		 * be able to access the cgroup after decrementing
-		 * the reference count in order to know if it needs to
-		 * queue the cgroup to be handled by the release
-		 * agent */
-		synchronize_rcu();

 		mutex_lock(&cgroup_mutex);
 		/*
@@ -620,11 +625,7 @@ static void cgroup_diput(struct dentry *
 		cgrp->root->number_of_cgroups--;
 		mutex_unlock(&cgroup_mutex);

-		/* Drop the active superblock reference that we took when we
-		 * created the cgroup */
-		deactivate_super(cgrp->root->sb);
-
-		kfree(cgrp);
+		call_rcu(&cgrp->rcu_head, __free_cgroup_rcu);
 	}
 	iput(inode);
 }
@@ -1134,8 +1135,9 @@ static inline struct cftype *__d_cft(str
  * @buf: the buffer to write the path into
  * @buflen: the length of the buffer
  *
- * Called with cgroup_mutex held. Writes path of cgroup into buf.
- * Returns 0 on success, -errno on error.
+ * Called with cgroup_mutex held or else with an RCU-protected cgroup
+ * reference.  Writes path of cgroup into buf.  Returns 0 on success,
+ * -errno on error.
  */
 int cgroup_path(const struct cgroup *cgrp, char *buf, int buflen)
 {
@@ -2440,12 +2442,16 @@ static int cgroup_has_css_refs(struct cg
 		if (ss->root != cgrp->root)
 			continue;
 		css = cgrp->subsys[ss->subsys_id];
-		/* When called from check_for_release() it's possible
-		 * that by this point the cgroup has been removed
-		 * and the css deleted. But a false-positive doesn't
-		 * matter, since it can only happen if the cgroup
-		 * has been deleted and hence no longer needs the
-		 * release agent to be called anyway. */
+		/*
+		 * When called from check_for_release() it's possible
+		 * that by this point the cgroup has been removed and
+		 * the css deleted (since css objects are not
+		 * necessarily RCU-protected).  But a false-positive
+		 * doesn't matter, since it can only happen if the
+		 * cgroup (which *is* RCU-protected) has been removed
+		 * and hence no longer needs the release agent to be
+		 * called anyway.
+		 */
 		if (css && atomic_read(&css->refcnt))
 			return 1;
 	}
@@ -2487,6 +2493,7 @@ static int cgroup_rmdir(struct inode *un
 		return -EBUSY;
 	}

+	/* Synchronize with check_for_release() */
 	spin_lock(&release_list_lock);
 	set_bit(CGRP_REMOVED, &cgrp->flags);
 	if (!list_empty(&cgrp->release_list))
