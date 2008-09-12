Return-Path: <linux-kernel-owner+w=401wt.eu-S1758214AbYILWCF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758214AbYILWCF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2008 18:02:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753647AbYILWBy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Sep 2008 18:01:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:49644 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbYILWBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2008 18:01:53 -0400
Subject: [BUG -rt] Priority inversion deadlock caused by condvars
From: john stultz <johnstul@us.ibm.com>
To: Ulrich Windl <ulrich.windl@rz.uni-regensburg.de>,
       Thomas Gleixner <tglx@linutronix.de>, mingo <mingo@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>
Cc: Dinakar Guniguntala <dino@in.ibm.com>, Ankita Garg <ankita@in.ibm.com>,
       Darren Hart <dvhltc@us.ibm.com>, Sripathi Kodi <sripathi@in.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-DcHhbF28yW34kVFdjXUZ"
Date: Fri, 12 Sep 2008 15:01:35 -0700
Message-Id: <1221256895.6695.55.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DcHhbF28yW34kVFdjXUZ
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

	So we've been seeing application hangs with a very threaded (~8k
threads) realtime java test. After a fair amount of debugging we found
most of the SCHED_FIFO threads are blocked in futex_wait(). This raised
some alarm, since futex_wait isn't priority-inheritance aware.

After seeing what was going on, Dino came up with a possible deadlock
case in the pthread_cond_wait() code.

The problem, as I understand it, assuming there is only one cpu, is if a
low priority thread is going to call pthread_cond_wait(), it takes the
associated PI mutex, and calls the function. The glibc implementation
acquires the condvar's internal non-PI lock, releases the PI mutex and
tries to block on futex_wait().

However if a medium priority cpu hog, and a high priority start up while
the low priority thread holds the mutex, the low priority thread will be
boosted until it releases that mutex, but not long enough for it to
release the condvar's internal lock (since the internal lock is not
priority inherited). 

Then the high priority thread will aquire the mutex, and try to acquire
the condvar's internal lock (which is still held). However, since we
also have a medium prio cpu hog, it will block the low priority thread
from running, and thus block it from releasing the lock.

And then we're deadlocked.

Thomas mentioned this is a known problem, but I wanted to send this
example out so maybe others might become aware.

The attached test illustrates this hang as described above when bound to
a single cpu. I believe its correct, but these sorts of tests often have
their own bugs that create false positives, so please forgive me and let
me know if you see any problems. :)

Many thanks to Dino, Ankita and Sripathi for helping to sort out this
issue.

To run:
	./pthread_cond_hang               => will PASS (on SMP)
	taskset -c 0 ./pthread_cond_hang  => will HANG


thanks
-john

--=-DcHhbF28yW34kVFdjXUZ
Content-Disposition: attachment; filename=pthread_cond_hang.c
Content-Type: text/x-csrc; name=pthread_cond_hang.c; charset=UTF-8
Content-Transfer-Encoding: 7bit

/* Demonstrate a pthread_cond_wait priority inversion deadlock
 *
 *  To build: gcc -lrt -D_GNU_SOURCE  pthread_cond_hang.c -o pthread_cond_hang
 *
 *  To run: ./pthread_cond_hang => WILL PASS
 *          taskset -c 0 ./pthread_cond_hang => WILL HANG
 *
 */


#include <stdio.h>
#include <sched.h>
#include <pthread.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>

#define LOW_PRIO 30
#define MED_PRIO 50
#define HIGH_PRIO 70

pthread_cond_t race_var;
pthread_mutex_t race_mut;


pthread_cond_t sig1,sig2,sig3;
pthread_mutex_t m1,m2,m3;

void* low_thread(void* dummy)
{
	/*registration  block*/
	pthread_mutex_lock(&m1);
	pthread_cond_wait(&sig1, &m1);
	pthread_mutex_unlock(&m1);


	/*race block*/
	pthread_mutex_lock(&race_mut);

	/* Wake up high_thread */
	pthread_mutex_lock(&m2);
	pthread_cond_signal(&sig2);
	pthread_mutex_unlock(&m2);

	printf("low: waiting\n");
	pthread_cond_wait(&race_var, &race_mut);

	pthread_mutex_unlock(&race_mut);

}


void* high_thread(void* dummy)
{

	/*registration  block*/
	pthread_mutex_lock(&m2);
	pthread_cond_wait(&sig2, &m2);
	pthread_mutex_unlock(&m2);

	/*race block*/
	pthread_mutex_lock(&race_mut);

	/*wake up medium_thread */
	pthread_mutex_lock(&m3);
	pthread_cond_signal(&sig3);
	pthread_mutex_unlock(&m3);

	printf("hi: waiting\n");
	pthread_cond_wait(&race_var, &race_mut);
	pthread_mutex_unlock(&race_mut);

}



void* medium_thread(void* dummy)
{
	/*registration block*/
	pthread_mutex_lock(&m3);
	pthread_cond_wait(&sig3, &m3);
	pthread_mutex_unlock(&m3);

	printf("med: spinning\n");	
	/*race block*/
	while(1)
		/*busy wait to block low threads*/;
}



int main(void)
{
	pthread_t lo_thread;
	pthread_t md_thread;
	pthread_t hi_thread;

	struct sched_param param;
	pthread_attr_t attr;
	pthread_mutexattr_t m_attr;

	pthread_attr_init(&attr);
        pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED);
        pthread_attr_setschedpolicy(&attr, SCHED_FIFO);

	pthread_cond_init(&sig1, NULL); 
	pthread_cond_init(&sig2, NULL);
	pthread_cond_init(&sig3, NULL);
	pthread_cond_init(&race_var, NULL);

	pthread_mutexattr_init(&m_attr);
	pthread_mutexattr_setprotocol(&m_attr, PTHREAD_PRIO_INHERIT);
	pthread_mutex_init(&m1, &m_attr);
	pthread_mutex_init(&m2, &m_attr);
	pthread_mutex_init(&m3, &m_attr);
	pthread_mutex_init(&race_mut, &m_attr);

	/* Set parent thread to FIFO */
	param.sched_priority = 90;
        sched_setscheduler(0, SCHED_FIFO, &param);

	/* start low prio thread */
	param.sched_priority = LOW_PRIO;
        pthread_attr_setschedparam(&attr, &param);
	pthread_create(&lo_thread, &attr, low_thread,(void*)NULL);

	/* start med prio thread */
	param.sched_priority = MED_PRIO;
        pthread_attr_setschedparam(&attr, &param);
	pthread_create(&md_thread, &attr, medium_thread,(void*)NULL);

	/* start high prio thread */
	param.sched_priority = HIGH_PRIO;
        pthread_attr_setschedparam(&attr, &param);
	pthread_create(&hi_thread, &attr, high_thread,(void*)NULL);

	/*let the threads startup */
	usleep(1000);

	/*wake up low thread */
	pthread_mutex_lock(&m1);
	pthread_cond_signal(&sig1);
	pthread_mutex_unlock(&m1);

	/*give some time to let the chain wakeups happen */
	sleep(1);

	/* Try to broadcast to high & low */
	pthread_mutex_lock(&race_mut);

	/* XXX - On hang, we'll never get here. This is 
	 * because the high thread holds the race_mut,
	 * but is blocked trying to aquire the race_var's
	 * internal lock, which is held by the low thread.
	 * Since the race_var's internal lock is
	 * not PI aware, the low thread is not boosted
	 * so it cannot run while the medium thread is
	 * spinning.
	 */
	pthread_cond_broadcast(&race_var);
	pthread_mutex_unlock(&race_mut);

	/* cleanup */
	pthread_join(lo_thread,(void**)NULL);
	pthread_join(hi_thread,(void**)NULL);
	/* med thread never dies, don't bother joining*/

	printf("Done!\n");
	exit(0);
	return 0;
}

--=-DcHhbF28yW34kVFdjXUZ--

