Return-Path: <linux-kernel-owner+w=401wt.eu-S932781AbXJMBFS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932781AbXJMBFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 21:05:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757971AbXJMBE7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 21:04:59 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57023 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758102AbXJMBE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 21:04:58 -0400
Date: Fri, 12 Oct 2007 18:03:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: viro@ftp.linux.org.uk, kamezawa.hiroyu@jp.fujitsu.com,
       linux-kernel@vger.kernel.org, sam@ravnborg.org, netdev@vger.kernel.org,
       Pavel Emelyanov <xemul@openvz.org>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       Oleg Nesterov <oleg@tv-sign.ru>, Paul Menage <menage@google.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.23-mm1 thread exit_group issue
Message-Id: <20071012180349.b4b4c2c3.akpm@linux-foundation.org>
In-Reply-To: <20071012194759.GA31733@Krystal>
References: <20071011213126.cf92efb7.akpm@linux-foundation.org>
	<20071012140328.f82af8e8.kamezawa.hiroyu@jp.fujitsu.com>
	<20071011234202.2f15bb76.akpm@linux-foundation.org>
	<20071012064658.GA8181@ftp.linux.org.uk>
	<20071012001325.ba02a6f0.akpm@linux-foundation.org>
	<20071012194759.GA31733@Krystal>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Oct 2007 15:47:59 -0400
Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca> wrote:

> Hi Andrew,
> 
> I noticed a regression between 2.6.23-rc8-mm2 and 2.6.23-mm1 (with your
> hotfixes). User space threads seems to receive a ERESTART_RESTARTBLOCK
> as soon as a thread does a pthread_join on them. The previous behavior
> was to wait for them to exit by taking a futex.
> 
> I provide a toy program that shows the problem. On 2.6.23-rc8-mm2, it
> loops forever (as it should). On 2.6.23-mm1, it exits after 10 seconds.
> 
> Any idea on what may cause this problem ?

Bisection shows that this problem is caused by these two patches:

pid-namespaces-allow-cloning-of-new-namespace.patch
pid-namespaces-allow-cloning-of-new-namespace-fix-check-for-return-value-of-create_pid_namespace.patch

> (I also provide complete ptrace -f of a correct and buggy run and my
> kernel config. Tests were done on i386.)
> 
> Mathieu
> 
> 
> /*
>  * Thread testing
>  *
>  * build with gcc -lpthread -o pthread pthread.c
>  *
>  * Mathieu Desnoyers
>  * License: GPL
>  */
> 
> #include <stdio.h>
> #include <pthread.h>
> #include <stdlib.h>
> #include <sys/types.h>
> #include <sys/wait.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <signal.h>
> 
> static int __thread test = 0;
> 
> /* signal handler */
> void handler(int signo)
> {
> 	printf("Sig handler : TID %lu, pid : %lu\n", pthread_self(), getpid());
> }
> 
> void *thr1(void *arg)
> {
> 	test = 1;
> 	
> 	while(1) {
> 		printf("thread 1, thread id : %lu, pid %lu, test %d\n",
> 				pthread_self(), getpid(), test);
> 		sleep(2);
> 	}
> 	return ((void*)1);
> 
> }
> 
> void *thr2(void *arg)
> {
> 	while(1) { 
> 		printf("thread 2, thread id : %lu, pid %lu, test %d\n",
> 				pthread_self(), getpid(), test);
> 		sleep(2);
> 	}
> 	return ((void*)2);
> }
> 
> int main()
> {
> 	int err;
> 	pthread_t tid1, tid2;
> 	void *tret;
> 	static struct sigaction act;
> 
> 	act.sa_handler = handler;
> 	sigemptyset(&(act.sa_mask));
> 	sigaddset(&(act.sa_mask), SIGUSR1);
> 	sigaction(SIGUSR1, &act, NULL);
> 
> 	err = pthread_create(&tid1, NULL, thr1, NULL);
> 	if (err != 0)
> 		exit(1);
> 
> 	err = pthread_create(&tid2, NULL, thr2, NULL);
> 	if (err != 0)
> 		exit(1);
> 
> 	sleep(10);
> 
> 	err = pthread_join(tid1, &tret);
> 	if (err != 0)
> 		exit(1);
> 
> 	err = pthread_join(tid2, &tret);
> 	if (err != 0)
> 		exit(1);
> 
> 	return 0;
> }
> 

