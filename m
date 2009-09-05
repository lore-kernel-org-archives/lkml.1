Return-Path: <linux-kernel-owner+w=401wt.eu-S1752799AbZIERmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799AbZIERmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 13:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752576AbZIERmH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 13:42:07 -0400
Received: from mail-pz0-f203.google.com ([209.85.222.203]:39709 "EHLO
	mail-pz0-f203.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbZIERmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 13:42:06 -0400
X-Greylist: delayed 1298 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 Sep 2009 13:42:05 EDT
Message-Id: <CC0E4F61-CD88-4683-B2F1-B50E10C51998@anirban.org>
From: Anirban Sinha <ani@anirban.org>
To: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v936)
Subject: re: question on sched-rt group allocation cap: sched_rt_runtime_us
Date: Sat, 5 Sep 2009 10:13:09 -0700
Cc: Anirban Sinha <ASinha@zeugmasystems.com>, Anirban Sinha <ani@anirban.org>
X-Mailer: Apple Mail (2.936)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again:

I am copying my test code here. I am really hoping to get some answers/ 
pointers. If there are whitespace/formatting issues in this mail,  
please let me know. I am using an alternate mailer.

Cheers,

Ani


/* Test code to experiment the CPU allocation cap for an FIFO RT thread
  * spinning on a tight loop. Yes, you read it right. RT thread on a
  * tight loop.
*/
#define _GNU_SOURCE

#include <sched.h>
#include <pthread.h>
#include <time.h>
#include <utmpx.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>
#include <assert.h>

unsigned long reg_count;

void *fifo_thread(void *arg)
{
     int core = (int) arg;
     int i, j;
     cpu_set_t cpuset;
     struct sched_param fifo_schedparam;
     int fifo_policy;
     unsigned long start, end;
     unsigned long fifo_count = 0;

     CPU_ZERO(&cpuset);
     CPU_SET(core, &cpuset);

     assert(sched_setaffinity(0, sizeof cpuset, &cpuset) == 0);

     /* RT priority 1 - lowest */
     fifo_schedparam.sched_priority = 1;
     assert(pthread_setschedparam(pthread_self(), SCHED_FIFO,  
&fifo_schedparam) == 0);
     start = reg_count;
     printf("start reg_count=%llu\n", start);

     for(i = 0; i < 5; i++) {
         for(j = 0; j < UINT_MAX/10; j++) {
	  fifo_count++;
         }
     }
     printf("\nRT thread has terminated\n");
     end = reg_count;
     printf("end reg_count=%llu\n", end);
     printf("delta reg count = %llu\n", end-start);
     printf("fifo count = %llu\n", fifo_count);
     printf("% = %f\n", ((float)(end-start)*100)/(float)fifo_count);

     return NULL;
}

void *reg_thread(void *arg)
{
     int core = (int) arg;
     int i, j;
     int new_nice;
     cpu_set_t cpuset;
     struct sched_param fifo_schedparam;
     int fifo_policy;
     /* let's renice it to highest priority level */
     new_nice = nice(-20);
     printf("new nice value for regular thread=%d\n", new_nice);
     printf("regular thread dispatch(%d)\n", core);

     CPU_ZERO(&cpuset);
     CPU_SET(core, &cpuset);

     assert(sched_setaffinity(0, sizeof cpuset, &cpuset) == 0);

     for(i = 0; i < 5; i++) {
       for(j = 0; j < UINT_MAX/10; j++) {
	reg_count++;
       }
     }
     printf("\nregular thread has terminated\n");

     return NULL;
}


int main(int argc, char *argv[])
{
     char *core_str = NULL;
     int core;
     pthread_t tid1, tid2;
     pthread_attr_t attr;

     if(argc != 2) {
         fprintf(stderr, "Usage: %s <core-ID>\n", argv[0]);
         return -1;
     }
     reg_count = 0;

     core = atoi(argv[1]);

     pthread_attr_init(&attr);
     assert(pthread_attr_setschedpolicy(&attr, SCHED_FIFO) == 0);
     assert(pthread_create(&tid1, &attr, fifo_thread, (void*)core) ==  
0);

     assert(pthread_attr_setschedpolicy(&attr, SCHED_OTHER) == 0);
     assert(pthread_create(&tid2, &attr, reg_thread, (void*)core) == 0);

     pthread_join(tid1, NULL);
     pthread_join(tid2, NULL);

     return 0;
}

-----

From: Anirban Sinha
Sent: Fri 9/4/2009 5:55 PM
To:
Subject: question on sched-rt group allocation cap: sched_rt_runtime_us

Hi Ingo and rest:

I have been playing around with the sched_rt_runtime_us cap that can  
be used to limit the amount of CPU time allocated towards scheduling  
rt group threads. I am using 2.6.26 with CONFIG_GROUP_SCHED disabled  
(we use only the root user in our embedded setup). I have no other CPU  
intensive workloads (RT or otherwise) running on my system. I have  
changed no other scheduling parameters from /proc.

I have written a small test program that:

(a) forks two threads, one SCHED_FIFO and one SCHED_OTHER (this thread  
is reniced to -20) and ties both of them to a specific core.
(b) runs both the threads in a tight loop (same number of iterations  
for both threads) until the SCHED_FIFO thread terminates.
(c) calculates the number of completed iterations of the regular  
SCHED_OTHER thread against the fixed number of iterations of the  
SCHED_FIFO thread. It then calculates a percentage based on that.

I am running the above workload against varying sched_rt_runtime_us  
values (200 ms to 700 ms) keeping the sched_rt_period_us constant at  
1000 ms. I have also experimented a little bit by decreasing the value  
of sched_rt_period_us (thus increasing the sched granularity) with no  
apparent change in behavior.

My observations are listed in tabular form. The numbers in the two  
columns are:

rt_runtime_us /
rt_period_us

     Vs

completed iterations of reg thr /
all iterations of RT thr (in %)


0.2   100 % (reg thread completed all its iterations).
0.3   73 %
0.4   45 %
0.5   17 %
0.6   0 % (reg thr completely throttled. Never ran)
0.7   0 %

This result kind of baffles me. Even when we cap the RT group to a  
fraction of 0.6 of overall CPU time, the rest 0.4 \should\ still be  
available for running regular threads. So my SCHED_OTHER \should\ make  
some progress as opposed to being completely throttled. Similarly,  
with any fraction less than 0.5, the SCHED_OTHER should complete  
before SCHED_FIFO.

I do not have an easy way to verify my results over the latest kernel  
(2.6.31). Was there any regressions in the scheduling subsystem in  
2.6.26? Can this behavior be explained? Do we need to tweak any other / 
proc parameters?

Cheers,

Ani


  
     
