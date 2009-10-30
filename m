Return-Path: <linux-kernel-owner+w=401wt.eu-S1756722AbZJ3Bps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756722AbZJ3Bps (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Oct 2009 21:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZJ3Bpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Oct 2009 21:45:47 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:54802 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753584AbZJ3Bpr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Oct 2009 21:45:47 -0400
Message-ID: <4AEA4547.30102@us.ibm.com>
Date: Thu, 29 Oct 2009 18:45:43 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: "lkml, " <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Dinakar Guniguntala <dino@in.ibm.com>,
       "Stultz, John" <johnstul@us.ibm.com>
Subject: Re: [PATCH] RFC: futex: make futex_lock_pi interruptible
References: <4AE63E3D.8030903@us.ibm.com> <4AE63FA3.8040208@us.ibm.com> <200910290939.32485.arnd@arndb.de> <4AEA3F15.2070900@us.ibm.com>
In-Reply-To: <4AEA3F15.2070900@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Hart wrote:
> Arnd Bergmann wrote:
>> On Tuesday 27 October 2009, Darren Hart wrote:
>>> The following C test case demonstrates how this patch could be used to
>>> implement interruptible locking. There is an awful lot of debug code and
>>> some other relics of a hacked together test in there now, but if anyone
>>> wanted to test the futex changes, this will do the trick.
>>>
>>
>> Your test program uses a signal handler to interrupt the mutex. If you
>> are using a signal handler already to implement a user space 
>> mutex_cancel,
>> why can't you just do a longjmp out of the signal handler rather than
>> modifying the kernel?
> 
> Interesting... so something like the following diff to the test case?
> 
> This works on an unmodfied kernel... although I certainly don't feel
> like I understand what it's doing well enough to recommend someone use
> this in conjunction with glibc pthread_mutexes and condvars. Seems like
> their internal state could suffer from this sort of thing. Hrm... and
> this warning in the man pages is worth heeding:
> 
>  setjmp() and sigsetjmp() make programs hard to understand and maintain.
>  If possible an alternative should be used.
> 
> However, if that is the only concern, it's certainly worth risking to
> avoid any further complication of the futex code (and glibc!). I'll take
> a stab at a pure pthread_mutex implementation and see if anything breaks.

This appears to work fine. Can anyone think of a reason why this is an unsafe
thing to do? I'll have to create a much more elaborate test case and review
the glibc code of course to make sure the glibc mutex state isn't compromised.
My original plan had been to patch glibc to handle the return of EINTR if the
mutex was tagged as PTHREAD_MUTEX_INTERRUPTIBLE_NP or something like that, this
approach appears to negate the need for such a thing - which is great.

Thoughts?

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
 *      pmutexint.c
 *
 * DESCRIPTION
 *      Use set/longjmp to interrupt a PI pthread_mutex.
 *
 * AUTHOR
 *      Darren Hart <dvhltc@us.ibm.com>
 *
 * HISTORY
 *      2009-Oct-29: Initial version by Darren Hart <dvhltc@us.ibm.com>
 *
 *****************************************************************************/

#define _GNU_SOURCE 1

#include <pthread.h>
#include <stdio.h>
#include <signal.h>
#include <syscall.h>
#include <sys/types.h>
#include <linux/futex.h>
#include <errno.h>
#include <string.h>
#include <setjmp.h>

#define SIGMUTEXINT SIGRTMIN

/* Need some kind of per-thread variable here */
jmp_buf env;
pthread_mutex_t mutex;

void sigmutexint_handler(int signo)
{
	printf("\thandled cancel signal: %d\n", signo);
	longjmp(env, 1);
}

void *child_thread(void *arg)
{
	int ret;
	struct sigaction sa;
	sa.sa_handler = sigmutexint_handler;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	if (sigaction(SIGMUTEXINT, &sa, NULL)) {
		perror("sigaction");
		ret = 1;
		goto out;
	}

	printf("\tchild acquiring the mutex (will block)\n");
	if (setjmp(env)) {
		ret = EINTR;
	} else {
		ret = pthread_mutex_lock(&mutex);
	}
	printf("\tchild returning: %s\n", strerror(ret));
 out:
	*(int *)arg = -ret;
	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_t child;
	pthread_mutexattr_t mattr;
	int child_ret;
	int ret = 0;

	pthread_mutexattr_init(&mattr);
	pthread_mutexattr_setprotocol(&mattr, PTHREAD_PRIO_INHERIT);
	pthread_mutex_init(&mutex, &mattr);

	printf("\nTesting canceled pthread_mutex lock scenario.\n");
	printf("\tmain() acquiring the mutex\n");
	pthread_mutex_lock(&mutex);

	/* prepare and start the child thread */
	ret = pthread_create(&child, NULL, child_thread, &child_ret);
	if (ret) {
		perror("Failed to create pthread");
		return ret;
	}

	/* ensure the child has blocked on the lock */
	sleep(1);

	/* cancel the child thread blocking on the mutex */
	printf("\tmain() canceling the child\n");
	ret = pthread_kill(child, SIGMUTEXINT);
	
	pthread_join(child, NULL);

	printf("Result: %s\n", child_ret == -EINTR ? "PASS" : "FAIL");
	return ret;
}

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team
