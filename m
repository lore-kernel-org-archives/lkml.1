Return-Path: <linux-kernel-owner+w=401wt.eu-S1753430Ab0ALIVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab0ALIVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 03:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752638Ab0ALIVd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 03:21:33 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:43651 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752154Ab0ALIVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 03:21:33 -0500
Date: Tue, 12 Jan 2010 13:51:28 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       utrace-devel <utrace-devel@redhat.com>, Mark Wielaard <mjw@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Maneesh Soni <maneesh@in.ibm.com>, Jim Keniston <jkenisto@us.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 4/7] Uprobes Implementation
Message-ID: <20100112082128.GA22420@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20100111122521.22050.3654.sendpatchset@srikar.in.ibm.com>
 <20100111122553.22050.46895.sendpatchset@srikar.in.ibm.com>
 <20100112020155.GC10869@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20100112020155.GC10869@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul, 


> > +
> > +/*
> > + * Allocate a uprobe_task object for p and add it to uproc's list.
> > + * Called with p "got" and uproc->rwsem write-locked.  Called in one of
> > + * the following cases:
> > + * - before setting the first uprobe in p's process
> > + * - we're in uprobe_report_clone() and p is the newly added thread
> > + * Returns:
> > + * - pointer to new uprobe_task on success
> > + * - NULL if t dies before we can utrace_attach it
> > + * - negative errno otherwise
> > + */
> > +static struct uprobe_task *uprobe_add_task(struct pid *p,
> > +		struct uprobe_process *uproc)
> > +{
> > +	struct uprobe_task *utask;
> > +	struct utrace_engine *engine;
> > +	struct task_struct *t = pid_task(p, PIDTYPE_PID);
> 
> What keeps the task_struct referenced by "t" from disappearing at this
> point?

We have a ref-counted pid which is used for creation of the utrace
engine. If the task_struct disappears then utrace would refuse to create
an engine and we wouldnt proceed further.  We only use the task struct
and pid only when we have a successful utrace engine.  Once utrace
engine is created,utrace guarantees us that the task will remain till
Uprobes is notified of the death/exit.

> 
> > +
> > +	if (!t)
> > +		return NULL;
> > +	utask = kzalloc(sizeof *utask, GFP_USER);
> > +	if (unlikely(utask == NULL))
> > +		return ERR_PTR(-ENOMEM);
> > +
> > +	utask->pid = p;
> > +	utask->tsk = t;
> > +	utask->state = UPTASK_RUNNING;
> > +	utask->quiescing = false;
> > +	utask->uproc = uproc;
> > +	utask->active_probe = NULL;
> > +	utask->doomed = false;
> > +	INIT_LIST_HEAD(&utask->deferred_registrations);
> > +	INIT_LIST_HEAD(&utask->delayed_signals);
> > +	INIT_LIST_HEAD(&utask->list);
> > +	list_add_tail(&utask->list, &uproc->thread_list);
> > +	uprobe_hash_utask(utask);
> > +
> > +	engine = utrace_attach_pid(p, UTRACE_ATTACH_CREATE,
> > +						p_uprobe_utrace_ops, utask);
> > +	if (IS_ERR(engine)) {
> > +		long err = PTR_ERR(engine);
> > +		printk("uprobes: utrace_attach_task failed, returned %ld\n",
> > +									err);
> > +		uprobe_free_task(utask, 0);
> > +		if (err == -ESRCH)
> > +			return NULL;
> > +		return ERR_PTR(err);
> > +	}
> > +				goto dont_add;
> > +			list_for_each_entry(utask, &uproc->thread_list, list) {
> 
> Doesn't this need to be list_for_each_entry_rcu()?
> 
> Or do you have ->thread_list protected elsewise?

thread_list is protected by write lock for uproc->rwsem.

> 
> > +				if (utask->tsk == t)
> > +					/* Already added */
> > +					goto dont_add;
> > +			}
> > +			/* Found thread/task to add. */
> > +			pid = get_pid(task_pid(t));
> > +			break;
> > +dont_add:
> > +			t = next_thread(t);
> > +		} while (t != start);
> > +	}
> > +	rcu_read_unlock();
> 
> Now that we are outside of rcu_read_lock()'s protection, the task
> indicated by "pid" might disappear, and the value of "pid" might well
> be reused.  Is this really OK?

We have a ref-counted pid; so pid should ideally not disappear.
And as I said earlier, once utrace engine gets created, we are sure that
the task struct lies till the engine gets detached. If an engine is not
created, we dont use the task struct or the pid. We piggyback on the
guarantee that utrace provides.

> 
> > +	return pid;
> > +}
> > +
> > +/*
> > + * Given a numeric thread ID, return a ref-counted struct pid for the
> > + * task-group-leader thread.
> > + */
> > +static struct pid *uprobe_get_tg_leader(pid_t p)
> > +{
> > +	struct pid *pid = NULL;
> > +
> > +	rcu_read_lock();
> > +	if (current->nsproxy)
> > +		pid = find_vpid(p);
> > +	if (pid) {
> > +		struct task_struct *t = pid_task(pid, PIDTYPE_PID);
> > +		if (t)
> > +			pid = task_tgid(t);
> > +		else
> > +			pid = NULL;
> > +	}
> > +	rcu_read_unlock();
> 
> What happens if the thread disappears at this point?  We are outside of
> rcu_read_lock() protection, so all the structures could potentially be
> freed up by other CPUs, especially if this CPU takes an interrupt or is
> preempted.
> 
> > +	return get_pid(pid);	/* null pid OK here */
> > +}


Same as above ; 

> > +/*
> > + * Signal callback:
> > + */
> > +static u32 uprobe_report_signal(u32 action,
> > +				struct utrace_engine *engine,
> > +				struct pt_regs *regs,
> > +				siginfo_t *info,
> > +				const struct k_sigaction *orig_ka,
> > +				struct k_sigaction *return_ka)
> > +{
> > +	struct uprobe_task *utask;
> > +	struct uprobe_process *uproc;
> > +	bool doomed;
> > +	enum utrace_resume_action report_action;
> > +
> > +	utask = (struct uprobe_task *)rcu_dereference(engine->data);
> 
> Are we really in an RCU read-side critical section here?

Yeah we dont need the rcu_deference here.

> 
> > +static u32 uprobe_report_quiesce(u32 action,
> > +				struct utrace_engine *engine,
> > +				unsigned long event)
> > +{
> > +	struct uprobe_task *utask;
> > +	struct uprobe_process *uproc;
> > +	bool done_quiescing = false;
> > +
> > +	utask = (struct uprobe_task *)rcu_dereference(engine->data);
> 
> Are we really in an RCU read-side critical section here?

Yeah we dont need the rcu_deference here also.

> 
> > +
> > +static u32 uprobe_exec_exit(struct utrace_engine *engine,
> > +				struct task_struct *tsk, int exit)
> > +{
> > +	struct uprobe_process *uproc;
> > +	struct uprobe_probept *ppt;
> > +	struct uprobe_task *utask;
> > +	bool utask_quiescing;
> > +
> > +	utask = (struct uprobe_task *)rcu_dereference(engine->data);
> 
> Are we really in an RCU read-side critical section here?

Yeah we dont need the rcu_deference here also.

> 
> > + *	- Provide option for child to inherit uprobes.
> > + */
> > +static u32 uprobe_report_clone(u32 action,
> > +				struct utrace_engine *engine,
> > +				unsigned long clone_flags,
> > +				struct task_struct *child)
> > +{
> > +	struct uprobe_process *uproc;
> > +	struct uprobe_task *ptask, *ctask;
> > +
> > +	ptask = (struct uprobe_task *)rcu_dereference(engine->data);
> 
> Are we really in an RCU read-side critical section here?

Yeah we dont need the rcu_deference here also.

--
Thanks and Regards
Srikar
