Return-Path: <linux-kernel-owner+w=401wt.eu-S1756129AbXE2IEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129AbXE2IEI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 04:04:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752473AbXE2IDu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 04:03:50 -0400
Received: from smtp1.linux-foundation.org ([207.189.120.13]:51369 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764162AbXE2IDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 04:03:46 -0400
Date: Tue, 29 May 2007 01:03:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>
Subject: Re: [BUG] signal: multithread program returns with wrong errno on
 receiving SIGSTOP
Message-Id: <20070529010315.d6ed6456.akpm@linux-foundation.org>
In-Reply-To: <87lkf9brvj.wl%takeuchi_satoru@jp.fujitsu.com>
References: <87lkf9brvj.wl%takeuchi_satoru@jp.fujitsu.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 11:32:00 +0900 Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:

> Hi,
> 
> I found a bug on signal subsystem. If there is some multithread program
> and one of the thread is blocking on the system call, it returns with
> wrong errno on receiving SIGSTOP and following SIGCONT.
> 
> Arch dependency
> ===============
> 
> succeed to reproduce: i386, ia64
> Unknown:              any other arch
> 
> # I suspect that this problem occur on any arch...
> 
> How to reproduce
> ================
> 
> This process needs 2 terminals, term A and term B.
> 
> 1. issue the test program (attached on this mail) from term A.
> 
>    $ ./mt-wrong-errno
> 
> 2. send SIGSTOP to test program from term B.
> 
>    $ ps a
>    ...
>     9685 pts/3    Sl+    0:00 ./mt-wrong-errno
>     9688 pts/4    R+     0:00 ps a
>    $ kill -STOP 9685
> 
> 3. send SIGCONT to test program from term B.
> 
>    $ kill -CONT 9685
> 
> Expected Result
> ===============
> 
> `./mt-wrong-errno' restarts read syscall (and stop again by receiving
> SIGTTIN).
> 
> Actual Result
> =============
> 
> `./mt-wrong-errno' returns with wrong errno 512 means ERESTARTSYS.
> The comment on include/linux/errno.h says "this errno should never be
> seen by user program." So it's definitely a bug.
> 
>   output of term A
>   ----------------
> 
>     $ ./mt-wrong-errno
> 
>     [1]+  Stopped                 ./mt-wrong-errno
>     $ errno = 512
> 
>   output of term B
>   ----------------
> 
>     $ ps a
>     ...
>      9685 pts/3    Sl+    0:00 ./mt-wrong-errno
>      9688 pts/4    R+     0:00 ps a
>     $ kill -STOP 9685
>     $ kill -CONT 9685
> 
> 
> This problem can always reproduce, so it's no timing issue. I suspect
> that group_stop_count counting mechanism has something wrong and
> signal handling is canceled erroneously. 
> 
> Any hints or patch itself are welcome.
> 
> Thanks,
> 
> Satoru
> 
> -------------------------------------------------------------------------------
> /*
>  * mt-wrong-errno.c
>  * 
>  * Copyright 2007 Satoru Takeuchi <takeuchi_satoru@jp.futjisu.com>
>  *
>  * This software may be used and distributed according to the terms
>  * of the GNU General Public License, incorporated herein by reference.
>  * 
>  */
> 
> #include <sys/types.h>
> #include <pthread.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <err.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <errno.h>
> 
> void *thread_fn(void *arg)
> {
> 	char c;
> 	int ret;
> 
> 	ret = read(STDIN_FILENO, &c, 1);
> 	if (ret < 0)
> 		printf("errno = %d\n", errno);
> 
> 	return NULL;
> }
> 
> int main(int argc, char *argv[])
> {
> 	pthread_t t;
> 	
> 	if (pthread_create(&t, NULL, thread_fn, NULL))
> 		err(EXIT_FAILURE, "pthread_create() failed\n");
> 	
> 	if (pthread_join(t, NULL))
> 		warn("pthread_join() failed\n");
> }

What kernel versions is this occurring on?

