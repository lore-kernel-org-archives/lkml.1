Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbYIDV30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbYIDV30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 17:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbYIDV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 17:29:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:9424 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754044AbYIDV3P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 17:29:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type;
        b=mISKLeSTAJMSUA84ou32ie4FI4zuk1aDJklGklxUkdd509h/sx9R+s7xaSglVy1S9L
         /ljs4LgIa2Pi/v83WNtweT0OBNp1aEtdL28L3uyU5yL/5ca1P6o+PHie5u4ntd8Z/zRJ
         hGrQ1DdaBwBuOIVxsMzkwHASUBrg/Q4A2xWRU=
Message-ID: <48C05296.8000909@gmail.com>
Date: Thu, 04 Sep 2008 17:26:46 -0400
From: Gregory Haskins <gregory.haskins@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Gregory Haskins <ghaskins@novell.com>, mingo@elte.hu, peterz@infradead.org,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
       npiggin@suse.de
Subject: Re: [TIP/SCHED/DEVEL PATCH v3 6/6] sched: create "pushable_tasks"
 list to limit pushing to one attempt
References: <20080904125029.23633.88210.stgit@dev.haskins.net> <20080904125530.23633.44703.stgit@dev.haskins.net> <alpine.DEB.1.10.0809041706050.3849@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.1.10.0809041706050.3849@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=CBD79AA1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5270EBD589415A22B25D0FD2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5270EBD589415A22B25D0FD2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Steven Rostedt wrote:
> On Thu, 4 Sep 2008, Gregory Haskins wrote:
>  =20
>> However, the current implementation suffers from a limitation in the
>> push logic.  Once overloaded, all tasks (other than current) on the
>> RQ are analyzed on every push operation, even if it was previously
>> unpushable (due to affinity, etc).  Whats more, the operation stops
>> at the first task that is unpushable and will not look at items
>> lower in the queue.  This causes two problems:
>>
>> 1) We can have the same tasks analyzed over and over again during each=

>>    push, which extends out the fast path in the scheduler for no
>>    gain.  Consider a RQ that has dozens of tasks that are bound to a
>>    core.  Each one of those tasks will be encountered and skipped
>>    for each push operation while they are queued.
>>
>> 2) There may be lower-priority tasks under the unpushable task that
>>    could have been successfully pushed, but will never be considered
>>    until either the unpushable task is cleared, or a pull operation
>>    succeeds.  The net result is a potential latency source for mid
>>    priority tasks.
>>    =20
>
> Yep, we knew of these limitations when we created it. It was a big
> TODO. Thanks for actually doing it. It is what? One year already?
>
> ;-)
>  =20

Yeah, agreed.  Sorry if it sounded like I was representing it as a new fi=
nd.

>  =20
>> This patch aims to rectify these two conditions by introducing a new
>> priority sorted list: "pushable_tasks".  A task is added to the list
>> each time a task is activated or preempted.  It is removed from the
>> list any time it is deactivated, made current, or fails to push.
>>
>> This works because a task only needs to be attempted to push once.
>> After an initial failure to push, the other cpus will eventually try t=
o
>> pull the task when the conditions are proper.  This also solves the
>> problem that we don't completely analyze all tasks due to encountering=

>> an unpushable tasks.  Now every task will have a push attempted (when
>> appropriate).
>>
>> This reduces latency both by shorting the critical section of the
>> rq->lock for certain workloads, and by making sure the algorithm
>> considers all eligible tasks in the system.
>>
>> Signed-off-by: Gregory Haskins <ghaskins@novell.com>
>> CC: Steven Rostedt <srostedt@redhat.com>
>> ---
>>
>>  include/linux/init_task.h |    1=20
>>  include/linux/sched.h     |    1=20
>>  kernel/sched.c            |    4 ++
>>  kernel/sched_rt.c         |  110 ++++++++++++++++++++++++++++++++++++=
+++++----
>>  4 files changed, 106 insertions(+), 10 deletions(-)
>>
>> diff --git a/include/linux/init_task.h b/include/linux/init_task.h
>> index 021d8e7..7f910f4 100644
>> --- a/include/linux/init_task.h
>> +++ b/include/linux/init_task.h
>> @@ -140,6 +140,7 @@ extern struct group_info init_groups;
>>  		.nr_cpus_allowed =3D NR_CPUS,				\
>>  	},								\
>>  	.tasks		=3D LIST_HEAD_INIT(tsk.tasks),			\
>> +	.pushable_tasks =3D PLIST_NODE_INIT(tsk.pushable_tasks, MAX_PRIO), \=

>>  	.ptraced	=3D LIST_HEAD_INIT(tsk.ptraced),			\
>>  	.ptrace_entry	=3D LIST_HEAD_INIT(tsk.ptrace_entry),		\
>>  	.real_parent	=3D &tsk,						\
>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>> index cf8cd8c..3480c8a 100644
>> --- a/include/linux/sched.h
>> +++ b/include/linux/sched.h
>> @@ -1078,6 +1078,7 @@ struct task_struct {
>>  #endif
>> =20
>>  	struct list_head tasks;
>> +	struct plist_node pushable_tasks;
>> =20
>>  	struct mm_struct *mm, *active_mm;
>> =20
>> diff --git a/kernel/sched.c b/kernel/sched.c
>> index ddc3877..dbb9e8c 100644
>> --- a/kernel/sched.c
>> +++ b/kernel/sched.c
>> @@ -447,6 +447,7 @@ struct rt_rq {
>>  #ifdef CONFIG_SMP
>>  	unsigned long rt_nr_migratory;
>>  	int overloaded;
>> +	struct plist_head pushable_tasks;
>>  #endif
>>  	int rt_throttled;
>>  	u64 rt_time;
>> @@ -2383,6 +2384,8 @@ void sched_fork(struct task_struct *p, int clone=
_flags)
>>  	/* Want to start with kernel preemption disabled. */
>>  	task_thread_info(p)->preempt_count =3D 1;
>>  #endif
>> +	plist_node_init(&p->pushable_tasks, MAX_PRIO);
>> +
>>  	put_cpu();
>>  }
>> =20
>> @@ -8009,6 +8012,7 @@ static void init_rt_rq(struct rt_rq *rt_rq, stru=
ct rq *rq)
>>  #ifdef CONFIG_SMP
>>  	rt_rq->rt_nr_migratory =3D 0;
>>  	rt_rq->overloaded =3D 0;
>> +	plist_head_init(&rq->rt.pushable_tasks, &rq->lock);
>>  #endif
>> =20
>>  	rt_rq->rt_time =3D 0;
>> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
>> index 277ccd2..b22d18a 100644
>> --- a/kernel/sched_rt.c
>> +++ b/kernel/sched_rt.c
>> @@ -49,6 +49,24 @@ static void update_rt_migration(struct rq *rq)
>>  		rq->rt.overloaded =3D 0;
>>  	}
>>  }
>> +
>> +static void enqueue_pushable_task(struct rq *rq, struct task_struct *=
p)
>> +{
>> +	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
>> +	plist_node_init(&p->pushable_tasks, p->prio);
>> +	plist_add(&p->pushable_tasks, &rq->rt.pushable_tasks);
>> +}
>> +
>> +static void dequeue_pushable_task(struct rq *rq, struct task_struct *=
p)
>> +{
>> +	plist_del(&p->pushable_tasks, &rq->rt.pushable_tasks);
>> +}
>> +
>> +#else
>> +
>> +#define enqueue_pushable_task(rq, p) do { } while (0)
>> +#define dequeue_pushable_task(rq, p) do { } while (0)
>> +
>>  #endif /* CONFIG_SMP */
>> =20
>>  static inline struct task_struct *rt_task_of(struct sched_rt_entity *=
rt_se)
>> @@ -669,6 +687,9 @@ static void enqueue_task_rt(struct rq *rq, struct =
task_struct *p, int wakeup)
>> =20
>>  	enqueue_rt_entity(rt_se);
>> =20
>> +	if (!task_current(rq, p) && p->rt.nr_cpus_allowed > 1)
>> +		enqueue_pushable_task(rq, p);
>> +
>>  	inc_cpu_load(rq, p->se.load.weight);
>>  }
>> =20
>> @@ -679,6 +700,8 @@ static void dequeue_task_rt(struct rq *rq, struct =
task_struct *p, int sleep)
>>  	update_curr_rt(rq);
>>  	dequeue_rt_entity(rt_se);
>> =20
>> +	dequeue_pushable_task(rq, p);
>> +
>>  	dec_cpu_load(rq, p->se.load.weight);
>>  }
>> =20
>> @@ -824,7 +847,7 @@ static struct sched_rt_entity *pick_next_rt_entity=
(struct rq *rq,
>>  	return next;
>>  }
>> =20
>> -static struct task_struct *pick_next_task_rt(struct rq *rq)
>> +static struct task_struct *_pick_next_task_rt(struct rq *rq)
>>  {
>>  	struct sched_rt_entity *rt_se;
>>  	struct task_struct *p;
>> @@ -846,6 +869,18 @@ static struct task_struct *pick_next_task_rt(stru=
ct rq *rq)
>> =20
>>  	p =3D rt_task_of(rt_se);
>>  	p->se.exec_start =3D rq->clock;
>> +
>> +	return p;
>> +}
>> +
>> +static struct task_struct *pick_next_task_rt(struct rq *rq)
>> +{
>> +	struct task_struct *p =3D _pick_next_task_rt(rq);
>> +
>> +	/* The running task is never eligible for pushing */
>> +	if (p)
>> +		dequeue_pushable_task(rq, p);
>> +
>>  	return p;
>>  }
>> =20
>> @@ -853,6 +888,13 @@ static void put_prev_task_rt(struct rq *rq, struc=
t task_struct *p)
>>  {
>>  	update_curr_rt(rq);
>>  	p->se.exec_start =3D 0;
>> +
>> +	/*
>> +	 * The previous task needs to be made eligible for pushing
>> +	 * if it is still active
>> +	 */
>> +	if (p->se.on_rq && p->rt.nr_cpus_allowed > 1)
>> +		enqueue_pushable_task(rq, p);
>>  }
>> =20
>>  #ifdef CONFIG_SMP
>> @@ -1031,6 +1073,28 @@ static struct rq *find_lock_lowest_rq(struct ta=
sk_struct *task, struct rq *rq)
>>  	return lowest_rq;
>>  }
>> =20
>> +static inline int has_pushable_tasks(struct rq *rq)
>> +{
>> +	return !plist_head_empty(&rq->rt.pushable_tasks);
>> +}
>> +
>> +static struct task_struct *pick_next_pushable_task(struct rq *rq)
>> +{
>> +	struct task_struct *p;
>> +
>> +	if (!has_pushable_tasks(rq))
>> +		return NULL;
>> +
>> +	p =3D plist_first_entry(&rq->rt.pushable_tasks,
>> +			      struct task_struct, pushable_tasks);
>> +
>> +	BUG_ON(rq->cpu !=3D task_cpu(p));
>> +	BUG_ON(task_current(rq, p));
>> +	BUG_ON(p->rt.nr_cpus_allowed <=3D 1);
>>    =20
>
> I have two new BUG_ONs for you. (This isn't a fast path)
>
> 	BUG_ON(!p->se.on_rq);
> 	BUG_ON(!rt_task(p));
>  =20

ack

>
>  =20
>> +
>> +	return p;
>> +}
>> +
>>  /*
>>   * If the current CPU has more than one RT task, see if the non
>>   * running task can migrate over to a CPU that is running a task
>> @@ -1040,13 +1104,12 @@ static int push_rt_task(struct rq *rq)
>>  {
>>  	struct task_struct *next_task;
>>  	struct rq *lowest_rq;
>> -	int ret =3D 0;
>>  	int paranoid =3D RT_MAX_TRIES;
>> =20
>>  	if (!rq->rt.overloaded)
>>  		return 0;
>> =20
>> -	next_task =3D pick_next_highest_task_rt(rq, -1);
>> +	next_task =3D pick_next_pushable_task(rq);
>>  	if (!next_task)
>>  		return 0;
>> =20
>> @@ -1078,12 +1141,19 @@ static int push_rt_task(struct rq *rq)
>>  		 * so it is possible that next_task has changed.
>>  		 * If it has, then try again.
>>  		 */
>> -		task =3D pick_next_highest_task_rt(rq, -1);
>> +		task =3D pick_next_pushable_task(rq);
>>  		if (unlikely(task !=3D next_task) && task && paranoid--) {
>>  			put_task_struct(next_task);
>>  			next_task =3D task;
>>  			goto retry;
>>  		}
>> +
>> +		/*
>> +		 * Once we have failed to push this task, we will not
>> +		 * try again, since the other cpus will pull from us
>> +		 * when they are ready
>> +		 */
>> +		dequeue_pushable_task(rq, next_task);
>>  		goto out;
>>  	}
>> =20
>> @@ -1095,11 +1165,10 @@ static int push_rt_task(struct rq *rq)
>> =20
>>  	double_unlock_balance(rq, lowest_rq);
>> =20
>> -	ret =3D 1;
>>  out:
>>  	put_task_struct(next_task);
>> =20
>> -	return ret;
>> +	return 1;
>>  }
>> =20
>>  /*
>> @@ -1128,7 +1197,7 @@ static int pull_rt_task(struct rq *this_rq)
>>  	if (likely(!rt_overloaded(this_rq)))
>>  		return 0;
>> =20
>> -	next =3D pick_next_task_rt(this_rq);
>> +	next =3D _pick_next_task_rt(this_rq);
>> =20
>>  	for_each_cpu_mask_nr(cpu, this_rq->rd->rto_mask) {
>>  		if (this_cpu =3D=3D cpu)
>> @@ -1145,7 +1214,7 @@ static int pull_rt_task(struct rq *this_rq)
>>  		if (double_lock_balance(this_rq, src_rq)) {
>>  			struct task_struct *old_next =3D next;
>> =20
>> -			next =3D pick_next_task_rt(this_rq);
>> +			next =3D _pick_next_task_rt(this_rq);
>>  			if (next !=3D old_next)
>>  				ret =3D 1;
>>  		}
>> @@ -1217,7 +1286,7 @@ static void pre_schedule_rt(struct rq *rq, struc=
t task_struct *prev)
>>   */
>>  static int needs_post_schedule_rt(struct rq *rq)
>>  {
>> -	return rq->rt.overloaded ? 1 : 0;
>> +	return has_pushable_tasks(rq);
>>  }
>> =20
>>  static void post_schedule_rt(struct rq *rq)
>> @@ -1240,7 +1309,7 @@ static void task_wake_up_rt(struct rq *rq, struc=
t task_struct *p)
>>  {
>>  	if (!task_running(rq, p) &&
>>  	    !test_tsk_need_resched(rq->curr) &&
>> -	    rq->rt.overloaded &&
>> +	    has_pushable_tasks(rq) &&
>>  	    p->rt.nr_cpus_allowed > 1)
>>  		push_rt_tasks(rq);
>>  }
>> @@ -1277,6 +1346,24 @@ static void set_cpus_allowed_rt(struct task_str=
uct *p,
>>  	if (p->se.on_rq && (weight !=3D p->rt.nr_cpus_allowed)) {
>>  		struct rq *rq =3D task_rq(p);
>> =20
>> +		if (!task_current(rq, p)) {
>> +			/*
>> +			 * Make sure we dequeue this task from the pushable list
>> +			 * before going further.  It will either remain off of
>> +			 * the list because we are no longer pushable, or it
>> +			 * will be requeued.
>> +			 */
>> +			if (p->rt.nr_cpus_allowed > 1)
>> +				dequeue_pushable_task(rq, p);
>> +
>> +			/*
>> +			 * Requeue if our weight is changing and still > 1
>> +			 */
>> +			if (weight > 1)
>> +				enqueue_pushable_task(rq, p);
>> +
>> +		}
>> +
>>  		if ((p->rt.nr_cpus_allowed <=3D 1) && (weight > 1)) {
>>  			rq->rt.rt_nr_migratory++;
>>  		} else if ((p->rt.nr_cpus_allowed > 1) && (weight <=3D 1)) {
>> @@ -1453,6 +1540,9 @@ static void set_curr_task_rt(struct rq *rq)
>>  	struct task_struct *p =3D rq->curr;
>> =20
>>  	p->se.exec_start =3D rq->clock;
>> +
>> +	/* The running task is never eligible for pushing */
>> +	dequeue_pushable_task(rq, p);
>>  }
>> =20
>>  static const struct sched_class rt_sched_class =3D {
>>
>>    =20
>
> OK, I like the patch, but I'm not 100% that it doesn't have bugs. I'll =
ACK=20
> it, but this definitely needs to be heavily tested, before going mainli=
ne.=20
> But for linux-tip, -mm, or linux-next, I think it is, on the surface,=20
> good to go (with the added BUG_ONs).
>
> I'll pull it into -rt as well.
>
> Acked-by: Steven Rostedt <srostedt@redhat.com>
>  =20

Thanks Steve, Ill spin a v4 with the fixes you requested and get it out
to you.

-Greg



--------------enig5270EBD589415A22B25D0FD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkjAUpYACgkQP5K2CMvXmqExjgCcC2NcgRvHtmB6IaMV6/Xyzk8E
kYgAn08krVooS3aIEJQF8V1dF8eocudX
=26Ic
-----END PGP SIGNATURE-----

--------------enig5270EBD589415A22B25D0FD2--
