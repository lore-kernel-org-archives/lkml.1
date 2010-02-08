Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484Ab0BHT1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 14:27:09 -0500
Received: from mail.openrapids.net ([64.15.138.104]:34883 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753172Ab0BHT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 14:27:07 -0500
X-Greylist: delayed 482 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Feb 2010 14:27:07 EST
Date: Mon, 8 Feb 2010 14:18:58 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com
Subject: lockdep rcu-preempt and synchronize_srcu() awareness
Message-ID: <20100208191858.GA16288@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 14:02:47 up 16 days, 21:40,  4 users,  load average: 1.02, 1.07,
	0.86
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I just though about the following deadlock scenario involving rcu preempt and
mutexes. I see that lockdep does not warn about it, and it actually triggers a
deadlock on my box. It might be worth addressing for TREE_PREEMPT_RCU configs.

CPU A:
    mutex_lock(&test_mutex);
    synchronize_rcu();
    mutex_unlock(&test_mutex);

CPU B:
    rcu_read_lock();
    mutex_lock(&test_mutex);
    mutex_unlock(&test_mutex);
    rcu_read_unlock();

But given that it's not legit to take a mutex from within a rcu read lock in
non-preemptible configs, I guess it's not much of a real-life problem, but I
think SRCU is also affected, because there is no lockdep annotation around
synchronize_srcu().

So I think it would be good to mark rcu_read_lock/unlock as not permitting
"might_sleep()" in non preemptable RCU configs, and having a look at lockdep
SRCU support might be worthwhile.

The following test module triggers the problem:


/* test-rcu-lockdep.c
 *
 * Test RCU-awareness of lockdep. Don't look at the interface, it's aweful.
 * run, in parallel:
 *
 * cat /proc/testa 
 * cat /proc/testb
 */

#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/proc_fs.h>
#include <linux/sched.h>
#include <linux/delay.h>

struct proc_dir_entry *pentrya = NULL;
struct proc_dir_entry *pentryb = NULL;

static DEFINE_MUTEX(test_mutex);

static int my_opena(struct inode *inode, struct file *file)
{
	mutex_lock(&test_mutex);
	synchronize_rcu();
	mutex_unlock(&test_mutex);

	return -EPERM;
}


static struct file_operations my_operationsa = {
	.open = my_opena,
};

static int my_openb(struct inode *inode, struct file *file)
{
	rcu_read_lock();
	mutex_lock(&test_mutex);
	ssleep(1);
	mutex_unlock(&test_mutex);
	rcu_read_unlock();


	return -EPERM;
}


static struct file_operations my_operationsb = {
	.open = my_openb,
};

int init_module(void)
{
	pentrya = create_proc_entry("testa", 0444, NULL);
	if (pentrya)
		pentrya->proc_fops = &my_operationsa;

	pentryb = create_proc_entry("testb", 0444, NULL);
	if (pentryb)
		pentryb->proc_fops = &my_operationsb;

	return 0;
}

void cleanup_module(void)
{
	remove_proc_entry("testa", NULL);
	remove_proc_entry("testb", NULL);
}

MODULE_LICENSE("GPL");
MODULE_AUTHOR("Mathieu Desnoyers");
MODULE_DESCRIPTION("lockdep rcu test");



Thanks,

Mathieu
