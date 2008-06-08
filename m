Return-Path: <linux-kernel-owner+w=401wt.eu-S1764192AbYFHLe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764192AbYFHLe3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jun 2008 07:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759479AbYFHLeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Jun 2008 07:34:22 -0400
Received: from mail0.aster.pl ([212.76.33.39]:17045 "EHLO mail0.aster.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759447AbYFHLeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jun 2008 07:34:21 -0400
X-Greylist: delayed 1362 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Jun 2008 07:34:20 EDT
From: "Jakub W. Jozwicki" <jozwicki@aster.pl>
To: linux-kernel@vger.kernel.org
Subject: sched_yield() on 2.6.25
Date: Sun, 8 Jun 2008 13:34:10 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806081334.10875.jozwicki@aster.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I observe strange behavior of sched_yield() on 2.6.25 (strange comparing to 
2.6.24). Here is the code (available at 
http://systest.googlecode.com/files/systest20080119.tgz):

------------------------------------------------------
timer_t timer;
sig_atomic_t cnt = 0;
long long sum = 0;
long times[21], min, max;
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
struct timespec ts = { 0, 0 };
pthread_t last_th = 0;

void *th_proc(void* p) {
    int n = SIZE(times) -1;
    pthread_t th;
        
    while(1) {    
	pthread_mutex_lock(&mutex);
	th = pthread_self();
	if (pthread_equal(th,last_th)) {
	    pthread_mutex_unlock(&mutex);
	    sched_yield();
	    continue;
	}
	rt_timer_stop(&ts);
	last_th = th;
	if (cnt>=1) {
	    times[cnt-1] = ts_sum(&ts);
	    if (cnt <= n) {
		sum += times[cnt-1];
		box(times[cnt-1],min,max);
		#define uint unsigned int
		printf("[%u] Thread switching time: %ldns\n",(uint)th, times[cnt-1]);
	    }
	    else {
		printf("[%u] Thread switching time (not counted): %ldns\n",(uint)th, 
times[cnt-1]);
	    }
	    cnt--;
	}
        ....
-----------------------------------------------------
and here are the results:

Setting cpu mask to 1

-- SYSTEM INFO -------------------

localhost: Linux 2.6.24-rt4 #8 SMP PREEMPT RT Mon Jan 21 18:45:00 CET 2008

Setting priority SCHED_OTHER to 0 (normal process) for 20802
[3084102544] Thread switching time (not counted): 10709015ns
[3075709840] Thread switching time: 35468301ns
[3084102544] Thread switching time: 2793ns
[3075709840] Thread switching time 30725ns
[3084102544] Thread switching time: 10405ns
[3075709840] Thread switching time: 2724ns
[3084102544] Thread switching time: 2654ns
[3075709840] Thread switching time: 2653ns
[3084102544] Thread switching time: 3352ns
[3075709840] Thread switching time: 2583ns
[3084102544] Thread switching time: 2514ns
[3075709840] Thread switching time: 2514ns
[3084102544] Thread switching time: 2584ns
[3075709840] Thread switching time: 2584ns
[3084102544] Thread switching time: 2584ns
[3075709840] Thread switching time: 2584ns
[3084102544] Thread switching time: 2584ns
[3075709840] Thread switching time: 2584ns
[3084102544] Thread switching time: 2583ns
[3075709840] Thread switching time: 2584ns
[3084102544] Thread switching time: 2583ns
[3084102544] n=20, min=2514, max=35468301, avg=1777723, stddev=7729151
Setting priority SHED_FIFO to 99 (range is 1-99) for 20802
[3084102544] Thread switching time (not counted): 31004ns
[3075709840] Thread switching time: 2444ns
[3084102544] Thread switching time: 2305ns
[3075709840] Thread switching time: 2305ns
[3084102544] Thread switching time: 2374ns
[3075709840] Thread switching time: 2374ns
[3084102544] Thread switching time: 2374ns
[3075709840] Thread switching time: 2375ns
[3084102544] Thread switching time: 2305ns
[3075709840] Thread switching time: 2374ns
[3084102544] Thread switching time: 2305ns
[3075709840] Thread switching time: 2375ns
[3084102544] Thread switching time: 2305ns
[3075709840] Thread switching time: 2305ns
[3084102544] Thread switching time: 2305ns
[3075709840] Thread switching time: 2305ns
[3084102544] Thread switching time: 2304ns
[3075709840] Thread switching time: 2304ns
[3084102544] Thread switching time: 2374ns
[3075709840] Thread switching time: 2374ns
[3084102544] Thread switching time: 2304ns
[3084102544] n=20, min=2304, max=2444, avg=2339, stddev=41

--------------------------------------------------------------------------

Ustawianie maski procesorow na 1

-- SYSTEM INFO -------------------

hackett: Linux 2.6.25.4-rt6 #5 SMP PREEMPT RT Sun Jun 8 12:40:15 CEST 2008

Ustawianie priorytetu dla SCHED_OTHER na 0 (zwykly proces) dla 20511
[3085323152] Czas przelaczania watku (pomijany): 9286166ns
[3076930448] Czas przelaczania watku: 38678449ns
[3085323152] Czas przelaczania watku: 1181784ns
[3076930448] Czas przelaczania watku: 284114ns
[3085323152] Czas przelaczania watku: 2894642ns
[3076930448] Czas przelaczania watku: 975962ns
[3085323152] Czas przelaczania watku: 2010730ns
[3076930448] Czas przelaczania watku: 980292ns
[3085323152] Czas przelaczania watku: 2004934ns
[3076930448] Czas przelaczania watku: 983994ns
[3085323152] Czas przelaczania watku: 2009682ns
[3076930448] Czas przelaczania watku: 984343ns
[3085323152] Czas przelaczania watku: 2013036ns
[3076930448] Czas przelaczania watku: 979035ns
[3085323152] Czas przelaczania watku: 2013664ns
[3076930448] Czas przelaczania watku: 973727ns
[3085323152] Czas przelaczania watku: 1688204ns
[3076930448] Czas przelaczania watku: 309397ns
[3085323152] Czas przelaczania watku: 985181ns
[3076930448] Czas przelaczania watku: 997822ns
[3085323152] Czas przelaczania watku: 996495ns
[3085323152] n=20, min=284114, max=38678449, avg=3197274, stddev=8164859
Ustawianie priorytetu dla SHED_FIFO na 99 (zakres 1-99) dla 20511
[3085323152] Czas przelaczania watku (pomijany): 39740ns
[3076930448] Czas przelaczania watku: 2723ns
[3085323152] Czas przelaczania watku: 2444ns
[3076930448] Czas przelaczania watku: 2445ns
[3085323152] Czas przelaczania watku: 2444ns
[3076930448] Czas przelaczania watku: 2445ns
[3085323152] Czas przelaczania watku: 2444ns
[3076930448] Czas przelaczania watku: 2445ns
[3085323152] Czas przelaczania watku: 2375ns
[3076930448] Czas przelaczania watku: 2445ns
[3085323152] Czas przelaczania watku: 2375ns
[3076930448] Czas przelaczania watku: 2375ns
[3085323152] Czas przelaczania watku: 2444ns
[3076930448] Czas przelaczania watku: 2374ns
[3085323152] Czas przelaczania watku: 2375ns
[3076930448] Czas przelaczania watku: 2375ns
[3085323152] Czas przelaczania watku: 2445ns
[3076930448] Czas przelaczania watku: 2444ns
[3085323152] Czas przelaczania watku: 2375ns
[3076930448] Czas przelaczania watku: 2374ns
[3085323152] Czas przelaczania watku: 2445ns
[3085323152] n=20, min=2374, max=2723, avg=2430, stddev=75

Is this behavior expected?

Regards,
Jakub

