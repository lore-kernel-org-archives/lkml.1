Return-Path: <linux-kernel-owner+w=401wt.eu-S1757452AbZDOAOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757452AbZDOAOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 20:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754556AbZDOAON
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 20:14:13 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:48162 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbZDOAOL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 20:14:11 -0400
Date: Tue, 14 Apr 2009 17:14:10 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jiri Pirko <jpirko@redhat.com>
Cc: linux-kernel@vger.kernel.org, dipankar@in.ibm.com, mingo@elte.hu
Subject: Re: [PATCH] rculist: use list_entry_rcu in places where it's
	appropriate
Message-ID: <20090415001410.GR6753@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090414181715.GA3634@psychotron.englab.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090414181715.GA3634@psychotron.englab.brq.redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 08:17:16PM +0200, Jiri Pirko wrote:
> Use previously introduced list_entry_rcu instead of list_entry + rcu_dereference
> combination.
> 
> Jirka

Looks good!

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> Signed-off-by: Jiri Pirko <jpirko@redhat.com>
> ---
>  include/linux/sched.h           |    8 +++++---
>  ipc/sem.c                       |    4 ++--
>  security/integrity/ima/ima_fs.c |    4 ++--
>  security/smack/smackfs.c        |    8 ++++----
>  4 files changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b4c38bc..886df41 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -77,6 +77,7 @@ struct sched_param {
>  #include <linux/proportions.h>
>  #include <linux/seccomp.h>
>  #include <linux/rcupdate.h>
> +#include <linux/rculist.h>
>  #include <linux/rtmutex.h>
> 
>  #include <linux/time.h>
> @@ -2010,7 +2011,8 @@ static inline unsigned long wait_task_inactive(struct task_struct *p,
>  }
>  #endif
> 
> -#define next_task(p)	list_entry(rcu_dereference((p)->tasks.next), struct task_struct, tasks)
> +#define next_task(p) \
> +	list_entry_rcu((p)->tasks.next, struct task_struct, tasks)
> 
>  #define for_each_process(p) \
>  	for (p = &init_task ; (p = next_task(p)) != &init_task ; )
> @@ -2049,8 +2051,8 @@ int same_thread_group(struct task_struct *p1, struct task_struct *p2)
> 
>  static inline struct task_struct *next_thread(const struct task_struct *p)
>  {
> -	return list_entry(rcu_dereference(p->thread_group.next),
> -			  struct task_struct, thread_group);
> +	return list_entry_rcu(p->thread_group.next,
> +			      struct task_struct, thread_group);
>  }
> 
>  static inline int thread_group_empty(struct task_struct *p)
> diff --git a/ipc/sem.c b/ipc/sem.c
> index 16a2189..87c2b64 100644
> --- a/ipc/sem.c
> +++ b/ipc/sem.c
> @@ -1290,8 +1290,8 @@ void exit_sem(struct task_struct *tsk)
>  		int i;
> 
>  		rcu_read_lock();
> -		un = list_entry(rcu_dereference(ulp->list_proc.next),
> -					struct sem_undo, list_proc);
> +		un = list_entry_rcu(ulp->list_proc.next,
> +				    struct sem_undo, list_proc);
>  		if (&un->list_proc == &ulp->list_proc)
>  			semid = -1;
>  		 else
> diff --git a/security/integrity/ima/ima_fs.c b/security/integrity/ima/ima_fs.c
> index ffbe259..510186f 100644
> --- a/security/integrity/ima/ima_fs.c
> +++ b/security/integrity/ima/ima_fs.c
> @@ -84,8 +84,8 @@ static void *ima_measurements_next(struct seq_file *m, void *v, loff_t *pos)
>  	 * against concurrent list-extension
>  	 */
>  	rcu_read_lock();
> -	qe = list_entry(rcu_dereference(qe->later.next),
> -			struct ima_queue_entry, later);
> +	qe = list_entry_rcu(qe->later.next,
> +			    struct ima_queue_entry, later);
>  	rcu_read_unlock();
>  	(*pos)++;
> 
> diff --git a/security/smack/smackfs.c b/security/smack/smackfs.c
> index e03a7e1..11d2cb1 100644
> --- a/security/smack/smackfs.c
> +++ b/security/smack/smackfs.c
> @@ -734,8 +734,8 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
>  		return;
>  	}
> 
> -	m = list_entry(rcu_dereference(smk_netlbladdr_list.next),
> -			 struct smk_netlbladdr, list);
> +	m = list_entry_rcu(smk_netlbladdr_list.next,
> +			   struct smk_netlbladdr, list);
> 
>  	/* the comparison '>' is a bit hacky, but works */
>  	if (new->smk_mask.s_addr > m->smk_mask.s_addr) {
> @@ -748,8 +748,8 @@ static void smk_netlbladdr_insert(struct smk_netlbladdr *new)
>  			list_add_rcu(&new->list, &m->list);
>  			return;
>  		}
> -		m_next = list_entry(rcu_dereference(m->list.next),
> -				 struct smk_netlbladdr, list);
> +		m_next = list_entry_rcu(m->list.next,
> +					struct smk_netlbladdr, list);
>  		if (new->smk_mask.s_addr > m_next->smk_mask.s_addr) {
>  			list_add_rcu(&new->list, &m->list);
>  			return;
> -- 
> 1.6.0.6
> 
