Return-Path: <linux-kernel-owner+w=401wt.eu-S1758817AbZJENav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758817AbZJENav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 09:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZJENau
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 09:30:50 -0400
Received: from mci007.btnet.de ([194.172.160.7]:32866 "EHLO relay.btnet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZJENat convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 09:30:49 -0400
X-Greylist: delayed 566 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Oct 2009 09:30:49 EDT
Content-Class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: clock_nanosleep: cyclic POSIX thread freezes during time setting
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4325
Date: Mon, 5 Oct 2009 15:20:42 +0200
Message-ID: <40F775BBD072A346957E787B3D0DBE5F1C97AF@w2k3-46ex01.RITTER.LOCAL>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: clock_nanosleep: cyclic POSIX thread freezes during time setting
thread-index: AcpFvuuOQ0Vf2PEBRHyyCD+gUgDR6A==
From: "Mehlan, Markus" <Markus.Mehlan@ritter.info>
To: <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

I have the following problem on a MPC5200b customer board,
tested with linux-2.6.24.7-rt11 and 2.6.26.8-rt16.

I start the test application. Every 200ms I can see a new 
line on the console ("ping"). Then I set the time with "date
100509152009" a few times on
a second console. The effect is that the output on the first console
freezes and if I check
the time with "date", the time doesn't progress during the "freeze
time". After the 
"freeze time" the time makes a jump of several seconds.

In the real application the "ping" should reset the watchdog-timer. The
freezing causes
an elapsing of the watchdog-timer and finally a reboot.

Has someone an idea?

With friendly regards,
Markus Mehlan

---------------------------------------------
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <time.h>
#include <sys/time.h>
#include <pthread.h>
#include <sys/mman.h>

#define CTRL_TASK_PRIORITY		5
#define USEC_PER_SEC   1000000
#define NSEC_PER_SEC   1000000000


static void tsnorm(struct timespec *ts)
{
	while (ts->tv_nsec >= NSEC_PER_SEC)
	{
		ts->tv_nsec -= NSEC_PER_SEC;
		ts->tv_sec++;       
	}
}

void *PingTask()
{
	static unsigned long ulHwWdgTime = 0;			
	struct itimerspec timer;
	int i;
	unsigned long ulInterval = 1000; // = 1ms
	
	if(clock_gettime(CLOCK_MONOTONIC, &timer.it_value) < 0)
	{
		perror("TimerTask: clock_gettime() failed\n");
		//return -1;
	}
	
	timer.it_interval.tv_nsec = ulInterval % USEC_PER_SEC;
	timer.it_interval.tv_nsec *= 1000;
	timer.it_interval.tv_sec = ulInterval / USEC_PER_SEC;
	
	while(1) {
		// 1ms-Task
		timer.it_value.tv_sec += timer.it_interval.tv_sec;
		timer.it_value.tv_nsec += timer.it_interval.tv_nsec;
		tsnorm(&timer.it_value);
		
		if (ulHwWdgTime == 0)
		{
			ulHwWdgTime = 200; // 200ms		
			clock_gettime(CLOCK_MONOTONIC,
&timer2.it_value);
			printf("ping\n");
		}	
		ulHwWdgTime--;
		
		clock_nanosleep(CLOCK_MONOTONIC, TIMER_ABSTIME,
&timer.it_value, NULL);
	}	
}

int main(int argc, char **argv)
{
	pthread_attr_t attr;
	pthread_t	threadHandle;
	void *thread_result;
	struct sched_param sched_param;
	int res;
	unsigned char byPriority = CTRL_TASK_PRIORITY;
	  
	pthread_attr_init(&attr);
	pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_DETACHED);
	   
 	if (pthread_create(&threadHandle, &attr, PingTask, NULL) != 0)
    {	
    	printf("Fehler pthread_create\n");
    	if (fd_drv_wdg)	
    		close(fd_drv_wdg);
    	return -3;
    }
    
	sched_param.sched_priority =
max(0,sched_get_priority_max(SCHED_FIFO) - (int)byPriority);
	if ((res=pthread_setschedparam
((pthread_t)threadHandle,SCHED_FIFO,&sched_param)))
	{
		printf("SysTaskSetPriority->pthread_setschedparam()
failed:%s\n",strerror(res));
		if (fd_drv_wdg)	
			close(fd_drv_wdg);
		return -4;
	}
  	pthread_attr_destroy(&attr);
  	  	
  	printf("Ende\n");
  	getchar();
	
	if (fd_drv_wdg)				
		close(fd_drv_wdg);
	return 0;
}

Sitz der Gesellschaft: Oberhausen
Handelsregister Amtsgericht Duisburg HRB-Nr. 17168 UST ID-Nr. DE 814009849
Geschaftsfuehrer: Manfred A. Wagner und Dr. Uwe Baader

