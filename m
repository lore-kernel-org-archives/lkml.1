Return-Path: <linux-kernel-owner+w=401wt.eu-S1759545AbYFIJfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759545AbYFIJfi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 05:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758260AbYFIJf1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 05:35:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42919 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759441AbYFIJf1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 05:35:27 -0400
Date: Mon, 9 Jun 2008 02:35:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sched_yield() on 2.6.25
Message-Id: <20080609023518.4a7d9868.akpm@linux-foundation.org>
In-Reply-To: <200806081334.10875.jozwicki@aster.pl>
References: <200806081334.10875.jozwicki@aster.pl>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Jun 2008 13:34:10 +0200 "Jakub W. Jozwicki" <jozwicki@aster.pl> wrote:

> Hello,
> I observe strange behavior of sched_yield() on 2.6.25 (strange comparing to 
> 2.6.24). Here is the code (available at 
> http://systest.googlecode.com/files/systest20080119.tgz):
> 
> ------------------------------------------------------
> timer_t timer;
> sig_atomic_t cnt = 0;
> long long sum = 0;
> long times[21], min, max;
> pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
> struct timespec ts = { 0, 0 };
> pthread_t last_th = 0;
> 
> void *th_proc(void* p) {
>     int n = SIZE(times) -1;
>     pthread_t th;
>         
>     while(1) {    
> 	pthread_mutex_lock(&mutex);
> 	th = pthread_self();
> 	if (pthread_equal(th,last_th)) {
> 	    pthread_mutex_unlock(&mutex);
> 	    sched_yield();
> 	    continue;
> 	}
> 	rt_timer_stop(&ts);
> 	last_th = th;
> 	if (cnt>=1) {
> 	    times[cnt-1] = ts_sum(&ts);
> 	    if (cnt <= n) {
> 		sum += times[cnt-1];
> 		box(times[cnt-1],min,max);
> 		#define uint unsigned int
> 		printf("[%u] Thread switching time: %ldns\n",(uint)th, times[cnt-1]);
> 	    }
> 	    else {
> 		printf("[%u] Thread switching time (not counted): %ldns\n",(uint)th, 
> times[cnt-1]);
> 	    }
> 	    cnt--;
> 	}
>         ....
> -----------------------------------------------------
> and here are the results:
> 
> Setting cpu mask to 1
> 
> -- SYSTEM INFO -------------------
> 
> localhost: Linux 2.6.24-rt4 #8 SMP PREEMPT RT Mon Jan 21 18:45:00 CET 2008
> 
> Setting priority SCHED_OTHER to 0 (normal process) for 20802
> [3084102544] Thread switching time (not counted): 10709015ns
> [3075709840] Thread switching time: 35468301ns
> [3084102544] Thread switching time: 2793ns
> [3075709840] Thread switching time 30725ns
> [3084102544] Thread switching time: 10405ns
> [3075709840] Thread switching time: 2724ns
> [3084102544] Thread switching time: 2654ns
> [3075709840] Thread switching time: 2653ns
> [3084102544] Thread switching time: 3352ns
> [3075709840] Thread switching time: 2583ns
> [3084102544] Thread switching time: 2514ns
> [3075709840] Thread switching time: 2514ns

It would save us some time if you were to tell us what these results
mean, please.

