Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbZKKWj0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbZKKWj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:39:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932087AbZKKWjZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:39:25 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:45567 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbZKKWjX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:39:23 -0500
Date: Wed, 11 Nov 2009 14:39:43 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: mtk.manpages@googlemail.com, arnd@arndb.de,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, matthltc@suka.localdomain,
       "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
       linux-api@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com, Pavel Emelyanov <xemul@openvz.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [v12][PATCH 4/9] Add target_pids parameter to alloc_pid()
Message-ID: <20091111223943.GE24988@suka>
References: <20091111043440.GA9377@suka> <20091111044347.GD11393@suka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091111044347.GD11393@suka>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: LKML

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| 
| Subject: [v12][PATCH 4/9] Add target_pids parameter to alloc_pid()
| 
| This parameter is currently NULL, but will be used in a follow-on patch.
| 
| Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| Acked-by: Serge Hallyn <serue@us.ibm.com>
| Reviewed-by: Oren Laadan <orenl@cs.columbia.edu>
| ---
|  include/linux/pid.h |    2 +-
|  kernel/fork.c       |    3 ++-
|  kernel/pid.c        |    9 +++++++--
|  3 files changed, 10 insertions(+), 4 deletions(-)
| 
| diff --git a/include/linux/pid.h b/include/linux/pid.h
| index 49f1c2f..914185d 100644
| --- a/include/linux/pid.h
| +++ b/include/linux/pid.h
| @@ -119,7 +119,7 @@ extern struct pid *find_get_pid(int nr);
|  extern struct pid *find_ge_pid(int nr, struct pid_namespace *);
|  int next_pidmap(struct pid_namespace *pid_ns, int last);
| 
| -extern struct pid *alloc_pid(struct pid_namespace *ns);
| +extern struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids);
|  extern void free_pid(struct pid *pid);
| 
|  /*
| diff --git a/kernel/fork.c b/kernel/fork.c
| index 93626b2..3f1dddf 100644
| --- a/kernel/fork.c
| +++ b/kernel/fork.c
| @@ -980,6 +980,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
|  	int retval;
|  	struct task_struct *p;
|  	int cgroup_callbacks_done = 0;
| +	pid_t *target_pids = NULL;
| 
|  	if ((clone_flags & (CLONE_NEWNS|CLONE_FS)) == (CLONE_NEWNS|CLONE_FS))
|  		return ERR_PTR(-EINVAL);
| @@ -1156,7 +1157,7 @@ static struct task_struct *copy_process(unsigned long clone_flags,
|  		goto bad_fork_cleanup_io;
| 
|  	if (pid != &init_struct_pid) {
| -		pid = alloc_pid(p->nsproxy->pid_ns);
| +		pid = alloc_pid(p->nsproxy->pid_ns, target_pids);
|  		if (IS_ERR(pid)) {
|  			retval = PTR_ERR(pid);
|  			goto bad_fork_cleanup_io;
| diff --git a/kernel/pid.c b/kernel/pid.c
| index afef766..3ee52cd 100644
| --- a/kernel/pid.c
| +++ b/kernel/pid.c
| @@ -281,13 +281,14 @@ void free_pid(struct pid *pid)
|  	call_rcu(&pid->rcu, delayed_put_pid);
|  }
| 
| -struct pid *alloc_pid(struct pid_namespace *ns)
| +struct pid *alloc_pid(struct pid_namespace *ns, pid_t *target_pids)
|  {
|  	struct pid *pid;
|  	enum pid_type type;
|  	int i, nr;
|  	struct pid_namespace *tmp;
|  	struct upid *upid;
| +	pid_t tpid;
| 
|  	pid = kmem_cache_alloc(ns->pid_cachep, GFP_KERNEL);
|  	if (!pid) {
| @@ -297,7 +298,11 @@ struct pid *alloc_pid(struct pid_namespace *ns)
| 
|  	tmp = ns;
|  	for (i = ns->level; i >= 0; i--) {
| -		nr = alloc_pidmap(tmp);
| +		tpid = 0;
| +		if (target_pids)
| +			tpid = target_pids[i];
| +
| +		nr = set_pidmap(tmp, tpid);
|  		if (nr < 0)
|  			goto out_free;
| 
| -- 
| 1.6.0.4
| 
| _______________________________________________
| Containers mailing list
| Containers@lists.linux-foundation.org
| https://lists.linux-foundation.org/mailman/listinfo/containers
