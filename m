Return-Path: <linux-kernel-owner+w=401wt.eu-S1755548AbZJ0Acf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbZJ0Acf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Oct 2009 20:32:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755350AbZJ0Acf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Oct 2009 20:32:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38309 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbZJ0Ace (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Oct 2009 20:32:34 -0400
Message-ID: <4AE63FA3.8040208@us.ibm.com>
Date: Mon, 26 Oct 2009 17:32:35 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
References: <4AE63E3D.8030903@us.ibm.com>
In-Reply-To: <4AE63E3D.8030903@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
>  From 9ea67856951c87a03a5177e1382d836622642521 Mon Sep 17 00:00:00 2001
> From: Darren Hart <dvhltc@us.ibm.com>
> Date: Mon, 26 Oct 2009 17:15:54 -0700
> Subject: [PATCH] RFC: futex: make futex_lock_pi interruptible
> 

The following C test case demonstrates how this patch could be used to
implement interruptible locking. There is an awful lot of debug code and
some other relics of a hacked together test in there now, but if anyone
wanted to test the futex changes, this will do the trick.


/******************************************************************************
 *
 *   Copyright © International Business Machines  Corp., 2009
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
 *      mutexint.c
 *
 * DESCRIPTION
 *      Provide an interruptible PI-aware locking construct.
 *
 * AUTHOR
 *      Darren Hart <dvhltc@us.ibm.com>
 *
 * HISTORY
 *      2009-Oct-26: Initial version by Darren Hart <dvhltc@us.ibm.com>
 *
 *****************************************************************************/

#include <pthread.h>
#include <stdio.h>
#include <signal.h>
#include <syscall.h>
#include <sys/types.h>
#include <linux/futex.h>
#include <errno.h>

/*
 * The futex() call has been removed from the include/futex.h header, implement
 * our own version.
 */
//#define SYS_futex 202
#define FUTEX_PRIVATE 128
#define FUTEX_INTERRUPTIBLE 512
#define futex(uaddr, op, val, timeout, uaddr2, val3) \
	syscall(SYS_futex, uaddr, op, val, timeout, uaddr2, val3)

#define futex_lock_pi(uaddr, val, timeout) \
	futex(uaddr, FUTEX_LOCK_PI|FUTEX_INTERRUPTIBLE|FUTEX_PRIVATE, \
	      val, timeout, NULL, 0)

#define futex_unlock_pi(uaddr, val) \
	futex(uaddr, FUTEX_UNLOCK_PI|FUTEX_PRIVATE, val, NULL, NULL, 0)

#define gettid() syscall(SYS_gettid)

#define SIGMUTEXINT SIGRTMIN

/*
 * Implement cmpxchg using gcc atomic builtins.
 * http://gcc.gnu.org/onlinedocs/gcc-4.1.0/gcc/Atomic-Builtins.html
 */
static inline int cmpxchg(volatile int32_t *addr, int32_t old, int32_t new)
{
	return __sync_val_compare_and_swap(addr, old, new);
}

struct mutexint {
	volatile int32_t lock_val;
};

struct mutexint_attr {
	/* placeholder for future expansion */
	u_int32_t flags;
};

void sigmutexint_handler(int signo)
{
	printf("handled cancel signal: %d\n", signo);
}

int mutexint_init(struct mutexint *mutex, struct mutexint_attr *attr)
{
	mutex->lock_val = 0;
	/* future: process attr->flags */
	return 0;
}

int mutexint_lock(struct mutexint *mutex)
{
	int32_t val;
	int ret = 0;
	pid_t tid = gettid();
	printf("%s: initial lock_val: 0x%x\n", __FUNCTION__, mutex->lock_val);
	if ((val = cmpxchg(&mutex->lock_val, 0, tid)) != 0) {
		printf("\tfirst cmpxchg old_val: 0x%x lock_val: 0x%x\n", val, mutex->lock_val);
		do {
			printf("\tdo cmpxchg old_val: 0x%x\n", val);
			if ((val & FUTEX_WAITERS) || 
				(val = cmpxchg(&mutex->lock_val, val, val | FUTEX_WAITERS))) {
				printf("\tinner cmpxchg old_val: 0x%x lock_val: 0x%x\n", val, mutex->lock_val);
				printf("\tcalling futex_lock_pi:\n");
				printf("\top: 0x%x\n", FUTEX_LOCK_PI | FUTEX_PRIVATE | FUTEX_INTERRUPTIBLE);
				printf("\t&lock_val: %p\n", &mutex->lock_val);
				ret = futex_lock_pi(&mutex->lock_val, val, NULL);
				if (ret == -1) {
					ret = -errno;
					printf("futex_lock_pi returned -1, errno is %d\n", ret);
				}
				/*
				 * If -EINTR is returned, the lock may no longer
				 * have owners, but we have no good way to detect that.
				 */
				printf("\tfutex_lock_pi returned. ret=%d lock_val=0x%x\n",
				       ret, mutex->lock_val);
				if (ret != -EWOULDBLOCK)
					break;
			}
		} while ((val = cmpxchg(&mutex->lock_val, 0, tid)) != 0);
	}

	/* 
	 * Catch the case where futex_lock_pi() returns EWOULDBLOCK, but the
	 * while conditional acquires the lock atomically and reset ret.
	 */
	if ((val & ~FUTEX_WAITERS) == tid)
		ret = 0;

	printf("%s: returning: %d\n", __FUNCTION__, ret);
	return ret;
}

int mutexint_unlock(struct mutexint *mutex)
{
	int32_t val;
	int ret = 0;
	pid_t tid = gettid();
	if ((val = cmpxchg(&mutex->lock_val, tid, 0)) != 0) {
		ret = futex_unlock_pi(&mutex->lock_val, val);
	}
	return ret;
}

int mutexint_interrupt(pthread_t pthread, struct mutexint *mutex)
{
	/* 
	 * FIXME: return -EINVAL if the pthread is blocked on a different
	 * thread ?
	 */
	return pthread_kill(pthread, SIGMUTEXINT);
}

int mutexint_prepare()
{
	struct sigaction sa;
	sa.sa_handler = sigmutexint_handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	if (sigaction(SIGMUTEXINT, &sa, NULL)) {
		perror("sigaction");
		return 1;
	}
	return 0;
}

/* unit test */
#define UNIT_TEST 1
#ifdef UNIT_TEST

struct mutexint mutex;

void *child_thread(void *arg)
{
	int ret;
	mutexint_prepare();

	printf("\tchild acquiring the mutex (will block)\n");
	ret = mutexint_lock(&mutex);
	printf("\tchild returned %d\n", ret);

	*(int *)arg = ret;
	return NULL;
}

int main(int argc, char *argv[])
{
	struct mutexint_attr m_attr;
	pthread_t child;
	int child_ret;
	int ret = 0;

	/* prepare the mutex, ensuring we use PROCESS_PRIVATE */
	mutexint_init(&mutex, &m_attr);

	printf("\nTesting canceled mutex lock scenario.\n");
	printf("\tmain() acquiring the mutex\n");
	mutexint_lock(&mutex);
	/* prepare and start the child thread */
	ret = pthread_create(&child, NULL, child_thread, &child_ret);
	if (ret) {
		perror("Failed to create pthread");
		return ret;
	}

	/* ensure the child has blocked on the lock */
	sleep(3);

	/* cancel the child thread blocking on the mutex */
	printf("\tmain() canceling the child\n");
	ret = mutexint_interrupt(child, &mutex);
	printf("\tmain() pthread_kill returned %d\n", ret);
	
	pthread_join(child, NULL);

	printf("Result: %s\n", child_ret == -EINTR ? "PASS" : "FAIL");
	return ret;
}
#endif

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
