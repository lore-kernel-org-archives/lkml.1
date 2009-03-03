Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZCCAYa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZCCAYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 19:24:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757893AbZCCAX4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 19:23:56 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:39032 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbZCCAXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 19:23:54 -0500
Message-ID: <49AC7895.2020104@us.ibm.com>
Date: Mon, 02 Mar 2009 16:23:49 -0800
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Steven Rostedt <srostedt@redhat.com>,
       Sripathi Kodi <sripathik@in.ibm.com>,
       John Stultz <johnstul@linux.vnet.ibm.com>
Subject: [TIP][RFC 7/7] requeue pi testcase
References: <49AC73A9.4040804@us.ibm.com>
In-Reply-To: <49AC73A9.4040804@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following is a rough start at a test case to stress the
FUTEX_REQUEUE_PI system call, mimicking a pthread_cond_broadcast and
pthread_cond_signal style wakeup.  The signal style wakeup is where I've
been seeing the failed paging request.

To compile:
$ gcc -D_GNU_SOURCE  -lrt -lpthread  requeue_pi.c   -o requeue_pi


/******************************************************************************
 *
 *   Copyright © International Business Machines  Corp., 2006-2009
 *
 *   This program is free software;  you can redistribute it and/or modify
 *   it under the terms of the GNU General Public License as published by
 *   the Free Software Foundation; either version 2 of the License, or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY;  without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See
 *   the GNU General Public License for more details.
 *
 *   You should have received a copy of the GNU General Public License
 *   along with this program;  if not, write to the Free Software
 *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 * NAME
 *      requeue_pi.c
 *
 * DESCRIPTION
 *      This test excercises the futex syscall op codes needed for requeuing
 *      priority inheritance aware POSIX condition variables and mutexes.
 *
 * USAGE:
 *      test_requeue_pi
 *
 * AUTHORS
 *	Sripathi Kodi <sripathik@in.ibm.com>
 *      Darren Hart <dvhltc@us.ibm.com>
 *
 * HISTORY
 *      2008-Jan-13: Initial version by Sripathi Kodi <sripathik@in.ibm.com>
 *
 *****************************************************************************/

/* TODO
 * o add test for shared futexes
 * o add test for non CMP requeue call
 */

/* SYS_futex arguments vary meaning across op codes
 *
 * u32 __user *uaddr
 * 	user-space futex address
 *
 * int op
 * 	FUTEX_* op code
 *
 * u32 val
 * 	FUTEX_WAIT:            value of the futex prior to the syscall
 *	FUTEX_REQUEUE_PI:      number of threads to wake (nr_wake)
 *	FUTEX_WAIT_REQUEUE_PI: ?
 *
 * struct timespec __user *utime
 * 	FUTEX_WAIT:            struct timespec timeout
 *	FUTEX_REQUEUE_PI:      number of threads to requeue (nr_requeue)
 *	FUTEX_WAIT_REQUEUE_PI: struct timespec timeout
 *
 * u32 __user *uaddr2
 * 	FUTEX_WAIT:            not used (NULL)
 *	FUTEX_REQUEUE_PI:      user-space futex address of requeue target
 *	FUTEX_WAIT_REQUEUE_PI: user-space futex address of requeue target
 *
 * u32 val3)
 * 	FUTEX_WAIT:            not used (0) (set to bitset in kernel)
 *	FUTEX_REQUEUE_PI:      cmpval for uaddr 
 *			       (FIXME: maybe only for FUTEX_CMP_REQUEUE_PI ??)
 *	FUTEX_WAIT_REQUEUE_PI: not used (0) (set to bitset in kernel)
 */

#include <stdio.h>
#include <pthread.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>

#define FUTEX_WAIT_REQUEUE_PI 11
#define FUTEX_REQUEUE_PI      12
#define FUTEX_CMP_REQUEUE_PI  13

#ifndef SYS_futex
#define SYS_futex 202
#endif

#ifndef FUTEX_WAIT
#define FUTEX_WAIT 0
#define FUTEX_WAKE 1
#endif

#define THREAD_MAX 10
pthread_mutex_t mutex;
unsigned int wait_q;


int create_pi_mutex(pthread_mutex_t *mutex)
{
	int ret;
	pthread_mutexattr_t mutexattr;

	if ((ret = pthread_mutexattr_init(&mutexattr)) != 0) {
		printf("pthread_mutexattr_init: %s\n", strerror(ret));
		return -1;
	}
	if ((ret = pthread_mutexattr_setprotocol(&mutexattr, PTHREAD_PRIO_INHERIT)) != 0) {
		printf("pthread_mutexattr_setprotocol: %s\n", strerror(ret));
		pthread_mutexattr_destroy(&mutexattr);
		return -1;
	}
	if ((ret = pthread_mutex_init(mutex, &mutexattr)) != 0) {
		printf("pthread_mutex_init: %s\n", strerror(ret));
		pthread_mutexattr_destroy(&mutexattr);
		return -1;
	}
	return 0;
}

int create_rt_thread(pthread_t *pth, void*(*func)(void*), void *arg, int policy, int prio)
{
	int ret;
	struct sched_param schedp;
	pthread_attr_t attr;
	
	pthread_attr_init(&attr);
	memset(&schedp, 0, sizeof(schedp));

	if ((ret = pthread_attr_setinheritsched(&attr, PTHREAD_EXPLICIT_SCHED)) != 0) {
		printf("pthread_attr_setinheritsched: %s\n", strerror(ret));
		return -1;
	}

	if ((ret = pthread_attr_setschedpolicy(&attr, policy)) != 0) {
		printf("pthread_attr_setschedpolicy: %s\n", strerror(ret));
		return -1;
	}

	schedp.sched_priority = prio;
	if ((ret = pthread_attr_setschedparam(&attr, &schedp)) != 0) {
		printf("pthread_attr_setschedparam: %s\n", strerror(ret));
		return -1;
	}

	if ((ret = pthread_create(pth, &attr, func, arg)) != 0) {
		printf("pthread_create: %s\n", strerror(ret));
		return -1;
	}
	return 0;
}


void *waiterfn(void *threadnum)
{
	unsigned int old_val;
	int ret;

	printf("Waiter %ld: running\n", (long)threadnum);
	/* Each thread sleeps for a different amount of time
	 * This is to avoid races, because we don't lock the
	 * external mutex here */
	usleep(1000 * (long)threadnum);

	/* FIXME: need to hold the mutex prior to waiting right?... sort of... */

	printf("Waiter %ld: calling FUTEX_WAIT_REQUEUE_PI\n", (long)threadnum);
	/* cond_wait */
	old_val = wait_q;
	if (ret = syscall(SYS_futex, &wait_q, FUTEX_WAIT_REQUEUE_PI, old_val,
			  NULL, &(mutex.__data.__lock), 0)) {
		perror("waiterfn:");
	}
	pthread_mutex_unlock(&mutex);

	printf("Waiter %ld: returned from FUTEX_WAIT_REQUEUE_PI with %d\n", (long)threadnum, ret);
	return (void*)(long)ret;
}

void *broadcast_wakerfn(void *arg)
{
	unsigned int old_val;
	int nr_wake = 1;
	int nr_requeue = INT_MAX;
	int ret = 0;
	sleep(1); /* FIXME: need a real sync mechanism - barrier maybe? */
	printf("Waker: Calling broadcast\n");

	pthread_mutex_lock(&mutex);
	/* cond_broadcast */
	old_val = wait_q;
	ret = syscall(SYS_futex, &wait_q, FUTEX_CMP_REQUEUE_PI, nr_wake,
		      nr_requeue, &(mutex.__data.__lock), old_val);
	pthread_mutex_unlock(&mutex);

	printf("Waker: exiting\n");
	return (void *)(long)ret;;
}

void *signal_wakerfn(void *arg)
{
	unsigned int old_val;
	int nr_wake = 1;
	int nr_requeue = 0;
	int i;
	int ret = 0;
	sleep(2);
	for (i = 0; i < THREAD_MAX; i++) {
		pthread_mutex_lock(&mutex);
		printf("Waker: Calling signal\n");
		/* cond_signal */
		old_val = wait_q;
		ret = syscall(SYS_futex, &wait_q, FUTEX_CMP_REQUEUE_PI, nr_wake,
			      nr_requeue, &(mutex.__data.__lock), old_val);
		pthread_mutex_unlock(&mutex);
		sleep(1); /* eliminate once the waiter takes/drops the lock */
	}

	printf("Waker: exiting\n");
	return (void *)(long)ret;
}
	
/* Create a PI mutex  and a condvar*/
/* Make 10 threads wait on the condvar */
/* Make a thread call broadcast on it */
int main()
{
	pthread_t waiter[10];
	pthread_t waker;	
	long i, ret;

	if ((ret = create_pi_mutex(&mutex)) != 0) {
		printf("Creating pi mutex failed\n");
		exit(1);
	}

	/* pthread_cond_broadcast type test */
	printf("\npthread_cond_broadcast style wakeup.\n");
	for (i=0; i<THREAD_MAX; i++) {
		if (ret = create_rt_thread(&waiter[i], waiterfn, (void *)i, SCHED_FIFO, 1)) {
			printf("Creating thread failed\n");
			exit(1);
		}
	}
	if (ret = create_rt_thread(&waker, broadcast_wakerfn, NULL, SCHED_FIFO, 1)) {
		printf("Creating thread failed\n");
		exit(1);
	}

	/* Wait for threads to finish */
	for (i=0; i<THREAD_MAX; i++) {
		pthread_join(waiter[i], NULL);
	}
	pthread_join(waker, NULL);

	/* pthread_cond_signal type test */
	printf("\npthread_cond_signal style wakeup.\n");
	for (i=0; i<THREAD_MAX; i++) {
		if (ret = create_rt_thread(&waiter[i], waiterfn, (void *)i, SCHED_FIFO, 1)) {
			printf("Creating thread failed\n");
			exit(1);
		}
	}
	if (ret = create_rt_thread(&waker, signal_wakerfn, NULL, SCHED_FIFO, 1)) {
		printf("Creating thread failed\n");
		exit(1);
	}

	/* Wait for threads to finish */
	for (i=0; i<THREAD_MAX; i++) {
		pthread_join(waiter[i], NULL);
	}
	pthread_join(waker, NULL);
}

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
