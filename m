Return-Path: <linux-kernel-owner+w=401wt.eu-S2992723AbXCGXUB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992723AbXCGXUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 18:20:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992719AbXCGXUA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 18:20:00 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:48870 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992723AbXCGXT7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 18:19:59 -0500
Message-ID: <45EF4890.6020806@nortel.com>
Date: Wed, 07 Mar 2007 17:19:44 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla Thunderbird 1.0.2-6 (X11/20050513)
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: Robert Love <rml@novell.com>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@osdl.org>,
       Linux kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Con Kolivas <kernel@kolivas.org>
Subject: resend: KERNEL BUG: nice level should not affect SCHED_RR timeslice
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2007 23:19:48.0151 (UTC) FILETIME=[19608C70:01C7610F]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I still haven't seen any replies, so I'm resending with a few more 
people directly in the TO list.

The timeslice of a SCHED_RR process currently varies with nice level the 
same way that it does for SCHED_OTHER.  I've included a small app below 
that demonstrates the issue.  So while niceness doesn't affect the 
priority of a SCHED_RR task, it does impact how much cpu it gets 
relative to other SCHED_RR tasks.

SUSv3 indicates, "Any processes or threads using SCHED_FIFO or SCHED_RR 
shall be unaffected by a call to setpriority()."

In addition, the code in set_user_nice() has a comment that leads me to 
believe the current behaviour is accidental (although I think the "not" 
in the last line of the comment isn't meant to be there):

/*
  * The RT priorities are set via sched_setscheduler(), but we still
  * allow the 'normal' nice value to be set - but as expected
  * it wont have any effect on scheduling until the task is
  * not SCHED_NORMAL/SCHED_BATCH:
  */

It appears that the desired behaviour is to allow setting the nice level 
of a realtime task, but to not have it affect anything until (and 
unless) it drops that realtime status.  This seems reasonable, but 
doesn't match current behaviour.

Chris


#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sched.h>
#include <errno.h>
#include <string.h>
#include <sys/syscall.h>
#include <sys/time.h>
#include <sys/resource.h>

#define THRESHOLD_USEC 2000

unsigned long long stamp()
{
	struct timeval tv;
	gettimeofday(&tv, 0);
	return (unsigned long long) tv.tv_usec + ((unsigned long long) 
tv.tv_sec)*1000000;
}

void chewcpu(int cpu)
{
	unsigned long long thresh_ticks = THRESHOLD_USEC;
	unsigned long long cur,last;
	
	last = stamp();
	while(1) {
		cur = stamp();
		unsigned long long delta = cur-last;
		if (delta > thresh_ticks) {
			printf("pid %d, out for %llu ms\n", getpid(), delta/1000);
			cur = stamp();
		}
		last = cur;
	}
		
}


int main()
{
	int cpu;
         cpu_set_t cpumask;
         CPU_ZERO(&cpumask);
         CPU_SET(0, &cpumask);

	int kidpid = fork();	
	
	struct sched_param p;
	p.sched_priority = 1;
	sched_setscheduler(0, SCHED_RR, &p);

	struct timespec ts;
	
	if (kidpid) {
		setpriority(PRIO_PROCESS, 0, 19);
		printf("pid %d, prio of %d\n", getpid(), getpriority(PRIO_PROCESS, 0));
		sched_rr_get_interval(0, &ts);
		printf("pid %d, interval of %d nsec\n", getpid(), ts.tv_nsec);
	} else {
		setpriority(PRIO_PROCESS, 0, -19);
		printf("pid %d, prio of %d\n", getpid(), getpriority(PRIO_PROCESS, 0));
		sched_rr_get_interval(0, &ts);
		printf("pid %d, interval of %d nsec\n", getpid(), ts.tv_nsec);
	}
		
	int rc = syscall(__NR_sched_setaffinity, 0, sizeof(cpumask), &cpumask);
         if (rc < 0)
                 printf("unable to set affinity: %m\n");
	

	sleep(1);
	
	chewcpu(cpu);
	return 0;
}
