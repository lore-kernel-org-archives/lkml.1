Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752530Ab0BHX27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 18:28:59 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:36133 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751700Ab0BHX26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 18:28:58 -0500
Date: Mon, 8 Feb 2010 15:28:55 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       mingo@elte.hu
Subject: Re: lockdep rcu-preempt and synchronize_srcu() awareness
Message-ID: <20100208232855.GJ6797@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100208191858.GA16288@Krystal> <20100208211729.GF6797@linux.vnet.ibm.com> <20100208215748.GA21527@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100208215748.GA21527@Krystal>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 08, 2010 at 04:57:48PM -0500, Mathieu Desnoyers wrote:
> * Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> > On Mon, Feb 08, 2010 at 02:18:58PM -0500, Mathieu Desnoyers wrote:
> > > Hi,
> > > 
> > > I just though about the following deadlock scenario involving rcu preempt and
> > > mutexes. I see that lockdep does not warn about it, and it actually triggers a
> > > deadlock on my box. It might be worth addressing for TREE_PREEMPT_RCU configs.
> > > 
> > > CPU A:
> > >     mutex_lock(&test_mutex);
> > >     synchronize_rcu();
> > >     mutex_unlock(&test_mutex);
> > > 
> > > CPU B:
> > >     rcu_read_lock();
> > >     mutex_lock(&test_mutex);
> > >     mutex_unlock(&test_mutex);
> > >     rcu_read_unlock();
> > > 
> > > But given that it's not legit to take a mutex from within a rcu read lock in
> > > non-preemptible configs, I guess it's not much of a real-life problem, but I
> > > think SRCU is also affected, because there is no lockdep annotation around
> > > synchronize_srcu().
> > 
> > Indeed, doing this with SRCU would result in deadlock, and it is quite
> > legal to acquire mutexes from within SRCU read-side critical sections.
> > And similar deadlocks can be constructed using pthread_mutex_lock() and
> > user-space RCU implementations.
> > 
> > The basic rule is "don't wait for a grace period to complete while in
> > the corresponding flavor of RCU read-side critical section".  Your point,
> > that it is possible to wait indirectly, is well taken.
> 
> Meanwhile, I'll add this to the Userspace RCU README:
> 
> Interaction with mutexes
> 
>         One must be careful to do not cause deadlocks due to interaction of
>         synchronize_rcu() and RCU read-side with mutexes. If synchronize_rcu()
>         is called with a mutex held, this mutex (or any mutex which has this
>         mutex in its dependency chain) should not be acquired from within a RCU
>         read-side critical section.

Looks good to me!

							Thanx, Paul

> Thanks,
> 
> Mathieu
> 
> > 
> > > So I think it would be good to mark rcu_read_lock/unlock as not permitting
> > > "might_sleep()" in non preemptable RCU configs, and having a look at lockdep
> > > SRCU support might be worthwhile.
> > 
> > Given the in-progress lockdep enhancements to RCU, the information is at
> > least present.  I can easily check for the direct case, but must defer
> > to Peter Z on the indirect case.
> > 
> > 							Thanx, Paul
> > 
> > > The following test module triggers the problem:
> > > 
> > > 
> > > /* test-rcu-lockdep.c
> > >  *
> > >  * Test RCU-awareness of lockdep. Don't look at the interface, it's aweful.
> > >  * run, in parallel:
> > >  *
> > >  * cat /proc/testa 
> > >  * cat /proc/testb
> > >  */
> > > 
> > > #include <linux/module.h>
> > > #include <linux/mutex.h>
> > > #include <linux/proc_fs.h>
> > > #include <linux/sched.h>
> > > #include <linux/delay.h>
> > > 
> > > struct proc_dir_entry *pentrya = NULL;
> > > struct proc_dir_entry *pentryb = NULL;
> > > 
> > > static DEFINE_MUTEX(test_mutex);
> > > 
> > > static int my_opena(struct inode *inode, struct file *file)
> > > {
> > > 	mutex_lock(&test_mutex);
> > > 	synchronize_rcu();
> > > 	mutex_unlock(&test_mutex);
> > > 
> > > 	return -EPERM;
> > > }
> > > 
> > > 
> > > static struct file_operations my_operationsa = {
> > > 	.open = my_opena,
> > > };
> > > 
> > > static int my_openb(struct inode *inode, struct file *file)
> > > {
> > > 	rcu_read_lock();
> > > 	mutex_lock(&test_mutex);
> > > 	ssleep(1);
> > > 	mutex_unlock(&test_mutex);
> > > 	rcu_read_unlock();
> > > 
> > > 
> > > 	return -EPERM;
> > > }
> > > 
> > > 
> > > static struct file_operations my_operationsb = {
> > > 	.open = my_openb,
> > > };
> > > 
> > > int init_module(void)
> > > {
> > > 	pentrya = create_proc_entry("testa", 0444, NULL);
> > > 	if (pentrya)
> > > 		pentrya->proc_fops = &my_operationsa;
> > > 
> > > 	pentryb = create_proc_entry("testb", 0444, NULL);
> > > 	if (pentryb)
> > > 		pentryb->proc_fops = &my_operationsb;
> > > 
> > > 	return 0;
> > > }
> > > 
> > > void cleanup_module(void)
> > > {
> > > 	remove_proc_entry("testa", NULL);
> > > 	remove_proc_entry("testb", NULL);
> > > }
> > > 
> > > MODULE_LICENSE("GPL");
> > > MODULE_AUTHOR("Mathieu Desnoyers");
> > > MODULE_DESCRIPTION("lockdep rcu test");
> > > 
> > > 
> > > 
> > > Thanks,
> > > 
> > > Mathieu
