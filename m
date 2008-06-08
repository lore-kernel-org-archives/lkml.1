Return-Path: <linux-kernel-owner+w=401wt.eu-S1757879AbYFHWH0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757879AbYFHWH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 18:07:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756597AbYFHWHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 18:07:15 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:5874 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbYFHWHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 18:07:14 -0400
Date: Sun, 08 Jun 2008 16:09:14 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sched_yield() on 2.6.25
In-reply-to: <fa.5iKTy3xTJkKWZLGio+GIHXi3+0o@ifi.uio.no>
To: "Jakub W. Jozwicki" <jozwicki@aster.pl>
Cc: linux-kernel@vger.kernel.org
Message-id: <484C588A.9090800@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
References: <fa.5iKTy3xTJkKWZLGio+GIHXi3+0o@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub W. Jozwicki wrote:
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

...

> Is this behavior expected?

The behavior of sched_yield with SCHED_OTHER processes has changed 
several times with Linux over the years, since its behavior is not 
defined by standards, so it's really "whatever the scheduler feels like 
doing". The behavior is only defined with realtime scheduling 
(SCHED_FIFO or SCHED_OTHER).

Generally, it's a mistake to assume specific timing behavior from 
sched_yied for SCHED_OTHER processes.
