Return-Path: <linux-kernel-owner+w=401wt.eu-S1758710AbYDUApG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758710AbYDUApG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Apr 2008 20:45:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751681AbYDUAoz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Apr 2008 20:44:55 -0400
Received: from wx-out-0506.google.com ([66.249.82.234]:18131 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686AbYDUAoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Apr 2008 20:44:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wroupY/c52NhmhKX8YUoNk4QqodJZYM4GvrT7qViu/2w8Y2o86+S6Bw0JTYn5tlf8vFMXGKXOOsZ19uzXyGpUYEzP2+O18hRwERgWG+5LcSf0YZ5LMv9kaA8A7Xy6fag+QEht+E7RQQAkQYBZGkYMw1g5raNQ2P7oeCtnIYFswg=
Message-ID: <ba7d8f720804201744m10cfa1b7n1a37b9d7c52b3622@mail.gmail.com>
Date: Sun, 20 Apr 2008 20:44:52 -0400
From: "Dan Upton" <upton.dan.linux@gmail.com>
To: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
Subject: Re: migration thread and active_load_balance
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <b647ffbd0804201426r3bb55daw2899f6045b78fa51@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
	 <b647ffbd0804201426r3bb55daw2899f6045b78fa51@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 20, 2008 at 5:26 PM, Dmitry Adamushko
<dmitry.adamushko@gmail.com> wrote:
>
> On 20/04/2008, Dan Upton <upton.dan.linux@gmail.com> wrote:
>  > Back again with more questions about the scheduler, as I've spent two
>  >  or three days trying to debug on my own and I'm just not getting
>  >  anywhere.
>  >
>  >  Basically, I'm trying to add a new active balancing mechanism.  I made
>  >  out a diagram of how migration_thread  calls active_load_balance and
>  >  so on, and I use a flag (set by writing to a file in sysfs) to
>  >  determine whether to use the standard iterator for the CFS runqueue or
>  >  a different iterator I wrote.  The new iterator seems to work fine, as
>  >  I've been using it (again, with a flag) to replace the regular
>  >  iterator when it's called from schedule by idle_balance.  I basically
>  >  tried adding an extra conditional in migration_thread that sets up
>  >  some state and then calls active_load_balance, but I was getting
>  >  deadlocks.  I'm not really sure why, since all I've really changed is
>  >  add a few variables to struct rq and struct cfs_rq.
>  >
>  >  I tried only doing my state setup and restore in that conditional,
>  >  without actually calling active_load_balance, which has given me an
>  >  even more frustrating result--the kernel does not deadlock, but it
>  >  does seem to crash in such a manner as to require a hard reset of the
>  >  machine.  (For instance, at one point I got an "invalid page state in
>  >  process 'init'" message from the kernel; if I try to reboot from Gnome
>  >  though it hangs.)  I don't understand this at all, since as far as I
>  >  can tell I'm using thread-local variables and really all I'm doing
>  >  right now is assignments to them.  Unless, of course the struct rq
>  >  (from rq = cpu_rq(cpu);) could be being manipulated elsewhere, leading
>  >  to some sort of race condition...
>  >
>
>  can you post your modifications? I'd be much more easy to see what you
>  are doing...
>
>  thanks in advance.
>

OK, here we go-- I've pretty much copied and pasted it over directly,
which includes all of my comments and ruminations.

The new iterator:

static struct task_struct *__load_balance_therm_iterator(struct cfs_rq
*cfs_rq, struct rb_node *curr){
        // local info
        int indexctr = 0, retindex=0;
        struct task_struct *p_tmp, *p_ret;
        struct rb_node *iter=curr;
        int lowest_temp = cfs_rq->last_therm_balance_temp;
        int last_index = cfs_rq->last_therm_balance_index;

        if(!curr)
                return NULL;

        // if last_therm_balance_index is -1, then this is being called from
        // load_balance_start_therm, so we can just look through the whole
        // runqueue to find something cooler without worrying about whether
        // we've already tried it
        if(last_index == -1){
                while(iter){
                        p_tmp = rb_entry(iter, struct task_struct, se.run_node);
                        if(p_tmp->lasttemp < lowest_temp){
                                p_ret = p_tmp;
                                lowest_temp = p_tmp->lasttemp;
                                retindex = indexctr;
                        }
                        iter = rb_next(iter);
                        indexctr++;
                }
        }
        // otherwise, we want to look for
        // - a process of equal temperature further down the queue
        // - the next-lowest temperature
        else{
                int second_lowest_temp=100; // see below

                // so first we look through for the next entry with
the same temperature
                // the comments on __load_balance_iterator suggest
dequeues can happen despite
                // the lock being held, but i'm assuming queueing
can't happen, so we don't have
                // to worry about new, lower-temperatured processes
magically appearing.  this
                // assumption simplifies the search for next-coolest tasks.
                while(iter){
                        p_tmp = rb_entry(iter, struct task_struct, se.run_node);
                        if( (p_tmp->lasttemp <= lowest_temp) &&
indexctr > last_index){
                                // we're just looking for the next one
down the line,
                                // and it looks like we've found it,
so we update cf_rq stats
                                // and return from here
                                cfs_rq->last_therm_balance_temp =
p_tmp->lasttemp;
                                cfs_rq->last_therm_balance_index = indexctr;
                                return p_tmp;
                        }else if(p_tmp->lasttemp > lowest_temp &&
p_tmp < second_lowest_temp){
                                second_lowest_temp = p_tmp->lasttemp;
                        }
                        indexctr++;
                        iter = rb_next(iter);
                }
                // if we get here, it means we wandered off the end of
the runqueue without finding
                // anything else with the same lowest temperature.
however, we know now what the
                // second lowest temperature of the runqueue is
(second_lowest_temp as calculated above),
                // so we can just look for the first task with that
temp (or, again, lower, in case something
                // would change out from underneath us).

                // this makes use of the above assumption that tasks
can only be dequeued but not enqueued
                iter = curr; // reset the iterator
                indexctr=0;
                while(iter){
                        p_tmp = rb_entry(iter, struct task_struct, se.run_node);
                        if(p_tmp->lasttemp == second_lowest_temp){
                                // we found something, so let's update
the stats and return it
                                cfs_rq->last_therm_balance_temp =
p_tmp->lasttemp;
                                cfs_rq->last_therm_balance_index = indexctr;
                                return p_tmp;
                        }
                        indexctr++;
                        iter = rb_next(iter);
                }
        }

        // update stats in case we come back here
        cfs_rq->last_therm_balance_temp = lowest_temp;
        cfs_rq->last_therm_balance_index = retindex;
        return p_ret;

}

static struct task_struct *load_balance_start_therm(void *arg){
        struct cfs_rq *cfs_rq = arg;
        cfs_rq->last_therm_balance_index = -1;
        cfs_rq->last_therm_balance_temp = 100;
        return __load_balance_therm_iterator(cfs_rq, first_fair(cfs_rq));
}

static struct task_struct *load_balance_next_therm(void *arg){
        struct cfs_rq *cfs_rq = arg;
        return __load_balance_therm_iterator(cfs_rq, first_fair(cfs_rq));
}


The migration thread:

static int migration_thread(void *data)
{
        int cpu = (long)data;
        struct rq *rq;
        static int dbgflag=1;
        int save_ab = 0, save_push=0;
        int coolest = !cpu;
        int crash_likely=0;

        rq = cpu_rq(cpu);
        BUG_ON(rq->migration_thread != current);

        set_current_state(TASK_INTERRUPTIBLE);
        while (!kthread_should_stop()) {
                struct migration_req *req;
                struct list_head *head;

                spin_lock_irq(&rq->lock);

                if (cpu_is_offline(cpu)) {
                        spin_unlock_irq(&rq->lock);
                        goto wait_to_die;
                }

                // other stuff here too, like checking the cpu temp
                if(sched_thermal == 3){

                        coolest = find_coolest_cpu(NULL);
                        if(coolest != cpu){ // if there's somewhere
cooler to push stuff
                                rq->from_active_balance=1;
                                save_ab = rq->active_balance;
                                save_push = rq->push_cpu;
                                rq->push_cpu = coolest;

                                //active_load_balance(rq, cpu);
                                rq->from_active_balance=0;
                                rq->active_balance = save_ab;
                                rq->push_cpu = save_push;
                                crash_likely=1;
                        }
                }
                // is it possible this could undo any work we just
did? or maybe we could
                // cause a bug if this was going to be called because
it was the busiest proc,
                // and now it isn't?
                if (rq->active_balance) {
                        active_load_balance(rq, cpu);
                        rq->active_balance = 0;

                }

                head = &rq->migration_queue;


                if (list_empty(head)) {
                        spin_unlock_irq(&rq->lock);
                        schedule();
                        set_current_state(TASK_INTERRUPTIBLE);
                        continue;
                }
                req = list_entry(head->next, struct migration_req, list);
                list_del_init(head->next);


                spin_unlock(&rq->lock);
                __migrate_task(req->task, cpu, req->dest_cpu);
                local_irq_enable();

                complete(&req->done);
        }
        __set_current_state(TASK_RUNNING);
        return 0;

wait_to_die:
        /* Wait for kthread_stop */
        set_current_state(TASK_INTERRUPTIBLE);
        while (!kthread_should_stop()) {
                schedule();
                set_current_state(TASK_INTERRUPTIBLE);
        }
        __set_current_state(TASK_RUNNING);
        return 0;
}

The function find_coolest_cpu(NULL) basically duplicates the
functionality of the coretemp driver to poll all of the cores' thermal
sensors to find which one is the coolest. The other change I made is
in move_one_task_fair, which checks if(sched_thermal==3 &&
busiest->from_active_balance==1) to decide whether to use the new
iterator.  When it crashes, this is what I get:

kernel BUG at kernel/sched.c:2103
invalid opcode: 0000 [1] SMP
CPU 0
Modules linked in:
Pid: 3, comm: migration/0 Not tained 2.6.24.3 #135
RIP: 0010:[<ffffffff80228d77>] double_rq_lock+0x14/0x4d

stack:
migration_thread+0x3db/0x3af
migration_thread+0x0/0x3af
kthread+0x3d/0x63
child_rip_0xa/0x12
kthread+0x0/0x63
child_rip+0x0/0x12

The basic functionality of this is supposed to be that if
sched_thermal==3 (and eventually, if the core is above a certain
temperature), we look for the coolest core and try to push stuff off
onto it.

If you can suggest what's causing my crash that'd be great; if it
looks like I'm approaching the implementation all wrong, I'd be happy
for any pointers along those lines too.

-dan
