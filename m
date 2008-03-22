Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbYCVOXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbYCVOXA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Mar 2008 10:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754893AbYCVOWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Mar 2008 10:22:52 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:13103 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754557AbYCVOWv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Mar 2008 10:22:51 -0400
Message-ID: <47E51637.8060102@colorfullife.com>
Date: Sat, 22 Mar 2008 15:22:47 +0100
From: Manfred Spraul <manfred@colorfullife.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Mike Galbraith <efault@gmx.de>
CC: paulmck@linux.vnet.ibm.com, Nadia Derbey <Nadia.Derbey@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Scalability requirements for sysv ipc
References: <47E382DB.70503@colorfullife.com> <47E3ADE3.4030304@bull.net> <47E3B924.3000304@colorfullife.com> <20080321141339.GB9618@linux.vnet.ibm.com> <47E3DD8C.4000904@colorfullife.com> <1206164608.3659.11.camel@marge.simson.net> <47E4DB06.3020003@colorfullife.com> <1206186832.4545.1.camel@marge.simson.net>
In-Reply-To: <1206186832.4545.1.camel@marge.simson.net>
Content-Type: multipart/mixed;
 boundary="------------070100020004070100040304"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070100020004070100040304
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Mike Galbraith wrote:
> Total: 4691827                                Total: 3942000
>   
Thanks. Unfortunately the test was buggy, it bound the tasks to the 
wrong cpu :-(
Could you run it again? Actually 1 cpu and 4 cpus are probably enough.

--
    Manfred

--------------070100020004070100040304
Content-Type: text/plain;
 name="pmsg.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pmsg.cpp"

/*
 * pmsg.cpp, parallel sysv msg pingpong
 *
 * Copyright (C) 1999, 2001, 2005, 2008 by Manfred Spraul.
 *	All rights reserved except the rights granted by the GPL.
 *
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL) version 2 or later.
 * $Header$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/msg.h>
#include <pthread.h>

//////////////////////////////////////////////////////////////////////////////

static enum {
	WAITING,
	RUNNING,
	STOPPED,
} volatile g_state = WAITING;

unsigned long long *g_results;
int *g_svmsg_ids;
pthread_t *g_threads;

struct taskinfo {
	int svmsg_id;
	int threadid;
	int cpuid;
	int sender;
};

#define DATASIZE	8

void* worker_thread(void *arg)
{
	struct taskinfo *ti = (struct taskinfo*)arg;
	unsigned long long rounds;
	int ret;
	struct {
		long mtype;
		char buffer[DATASIZE];
	} mbuf;

	{
		cpu_set_t cpus;
		CPU_ZERO(&cpus);
		CPU_SET(ti->cpuid, &cpus);

		ret = pthread_setaffinity_np(g_threads[ti->threadid], sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_setaffinity_np failed for thread %d with errno %d.\n",
					ti->threadid, errno);
		}

		ret = pthread_getaffinity_np(g_threads[ti->threadid], sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_getaffinity_np() failed for thread %d with errno %d.\n",
					ti->threadid, errno);
			fflush(stdout);
		} else {
			printf("thread %d: sysvmsg %8d type %d bound to %04lxh\n",ti->threadid,
					ti->svmsg_id, ti->sender, cpus.__bits[0]);
		}
		fflush(stdout);
	}

	rounds = 0;
	while(g_state == WAITING) {
#ifdef __i386__
		__asm__ __volatile__("pause": : :"memory");
#endif
	}

	if (ti->sender) {
		mbuf.mtype = ti->sender+1;
		ret = msgsnd(ti->svmsg_id, &mbuf, DATASIZE, 0);
		if (ret != 0) {
			printf("Initial send failed, errno %d.\n", errno);
			exit(1);
		}
	}
	while(g_state == RUNNING) {
		int target = 1+!ti->sender;

		ret = msgrcv(ti->svmsg_id, &mbuf, DATASIZE, target, 0);
		if (ret != DATASIZE) {
			if (errno == EIDRM)
				break;
			printf("Error on msgrcv, got %d, errno %d.\n", ret, errno);
			exit(1);
		}
		mbuf.mtype = ti->sender+1;
		ret = msgsnd(ti->svmsg_id, &mbuf, DATASIZE, 0);
		if (ret != 0) {
			if (errno == EIDRM)
				break;
			printf("send failed, errno %d.\n", errno);
			exit(1);
		}
		rounds++;
	}
	/* store result */
	g_results[ti->threadid] = rounds;

	pthread_exit(0);
	return NULL;
}

void init_threads(int cpu, int cpus)
{
	int ret;
	struct taskinfo *ti1, *ti2;

	ti1 = new (struct taskinfo);
	ti2 = new (struct taskinfo);
	if (!ti1 || !ti2) {
		printf("Could not allocate task info\n");
		exit(1);
	}

	g_svmsg_ids[cpu] = msgget(IPC_PRIVATE,0777|IPC_CREAT);
	if(g_svmsg_ids[cpu] == -1) {
		printf(" message queue create failed.\n");
		exit(1);
	}

	g_results[cpu] = 0;
	g_results[cpu+cpus] = 0;

	ti1->svmsg_id = g_svmsg_ids[cpu];
	ti1->threadid = cpu;
	ti1->cpuid = cpu;
	ti1->sender = 1;
	ti2->svmsg_id = g_svmsg_ids[cpu];
	ti2->threadid = cpu+cpus;
	ti2->cpuid = cpu;
	ti2->sender = 0;

	ret = pthread_create(&g_threads[ti1->threadid], NULL, worker_thread, ti1);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
	ret = pthread_create(&g_threads[ti2->threadid], NULL, worker_thread, ti2);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
}

//////////////////////////////////////////////////////////////////////////////

int main(int argc, char **argv)
{
	int queues, timeout;
	unsigned long long totals;
	int i;

	printf("pmsg [nr queues] [timeout]\n");
	if (argc != 3) {
		printf(" Invalid parameters.\n");
		return 0;
	}
	queues = atoi(argv[1]);
	timeout = atoi(argv[2]);
	printf("Using %d queues/cpus (%d threads) for %d seconds.\n",
			queues, 2*queues, timeout);

	g_results = new unsigned long long[2*queues];
	g_svmsg_ids = new int[queues];
	g_threads = new pthread_t[2*queues];
	for (i=0;i<queues;i++) {
		init_threads(i, queues);
	}

	sleep(1);
	g_state = RUNNING;
	sleep(timeout);
	g_state = STOPPED;
	sleep(1);
	for (i=0;i<queues;i++) {
		int res;
		res = msgctl(g_svmsg_ids[i],IPC_RMID,NULL);
		if (res < 0) {
			printf("msgctl(IPC_RMID) failed for %d, errno%d.\n",
				g_svmsg_ids[i], errno);
		}
	}
	for (i=0;i<2*queues;i++)
		pthread_join(g_threads[i], NULL);

	printf("Result matrix:\n");
	totals = 0;
	for (i=0;i<queues;i++) {
		printf("  Thread %3d: %8lld     %3d: %8lld\n",
				i, g_results[i], i+queues, g_results[i+queues]);
		totals += g_results[i] + g_results[i+queues];
	}
	printf("Total: %lld\n", totals);
}

--------------070100020004070100040304
Content-Type: text/plain;
 name="psem.cpp"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="psem.cpp"

/*
 * psem.cpp, parallel sysv sem pingpong
 *
 * Copyright (C) 1999, 2001, 2005, 2008 by Manfred Spraul.
 *	All rights reserved except the rights granted by the GPL.
 *
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL) version 2 or later.
 * $Header$
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <pthread.h>

//////////////////////////////////////////////////////////////////////////////

static enum {
	WAITING,
	RUNNING,
	STOPPED,
} volatile g_state = WAITING;

unsigned long long *g_results;
int *g_svsem_ids;
pthread_t *g_threads;

struct taskinfo {
	int svsem_id;
	int threadid;
	int cpuid;
	int sender;
};

#define DATASIZE	8

void* worker_thread(void *arg)
{
	struct taskinfo *ti = (struct taskinfo*)arg;
	unsigned long long rounds;
	int ret;

	{
		cpu_set_t cpus;
		CPU_ZERO(&cpus);
		CPU_SET(ti->cpuid, &cpus);

		ret = pthread_setaffinity_np(g_threads[ti->threadid], sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_setaffinity_np failed for thread %d with errno %d.\n",
					ti->threadid, errno);
		}

		ret = pthread_getaffinity_np(g_threads[ti->threadid], sizeof(cpus), &cpus);
		if (ret < 0) {
			printf("pthread_getaffinity_np() failed for thread %d with errno %d.\n",
					ti->threadid, errno);
			fflush(stdout);
		} else {
			printf("thread %d: sysvsem %8d type %d bound to %04lxh\n",ti->threadid,
					ti->svsem_id, ti->sender, cpus.__bits[0]);
		}
		fflush(stdout);
	}

	rounds = 0;
	while(g_state == WAITING) {
#ifdef __i386__
		__asm__ __volatile__("pause": : :"memory");
#endif
	}

	if (ti->sender) {
		struct sembuf sop[1];
		int res;

		/* 1) insert token */
		sop[0].sem_num=0;
		sop[0].sem_op=1;
		sop[0].sem_flg=0;
		res = semop(ti->svsem_id,sop,1);
	
		if (ret != 0) {
			printf("Initial semop failed, errno %d.\n", errno);
			exit(1);
		}
	}
	while(g_state == RUNNING) {
		struct sembuf sop[1];
		int res;

		/* 1) retrieve token */
		sop[0].sem_num=ti->sender;
		sop[0].sem_op=-1;
		sop[0].sem_flg=0;
		res = semop(ti->svsem_id,sop,1);
		if (ret != 0) {
			/* EIDRM can happen */
			if (errno == EIDRM)
				break;
			printf("main semop failed, errno %d.\n", errno);
			exit(1);
		}

		/* 2) reinsert token */
		sop[0].sem_num=1-ti->sender;
		sop[0].sem_op=1;
		sop[0].sem_flg=0;
		res = semop(ti->svsem_id,sop,1);
		if (ret != 0) {
			/* EIDRM can happen */
			if (errno == EIDRM)
				break;
			printf("main semop failed, errno %d.\n", errno);
			exit(1);
		}


		rounds++;
	}
	g_results[ti->threadid] = rounds;

	pthread_exit(0);
	return NULL;
}

void init_threads(int cpu, int cpus)
{
	int ret;
	struct taskinfo *ti1, *ti2;

	ti1 = new (struct taskinfo);
	ti2 = new (struct taskinfo);
	if (!ti1 || !ti2) {
		printf("Could not allocate task info\n");
		exit(1);
	}
	g_svsem_ids[cpu] = semget(IPC_PRIVATE,2,0777|IPC_CREAT);
	if(g_svsem_ids[cpu] == -1) {
		printf("sem array create failed.\n");
		exit(1);
	}

	g_results[cpu] = 0;
	g_results[cpu+cpus] = 0;

	ti1->svsem_id = g_svsem_ids[cpu];
	ti1->threadid = cpu;
	ti1->cpuid = cpu;
	ti1->sender = 1;
	ti2->svsem_id = g_svsem_ids[cpu];
	ti2->threadid = cpu+cpus;
	ti2->cpuid = cpu;
	ti2->sender = 0;

	ret = pthread_create(&g_threads[ti1->threadid], NULL, worker_thread, ti1);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
	ret = pthread_create(&g_threads[ti2->threadid], NULL, worker_thread, ti2);
	if (ret) {
		printf(" pthread_create failed with error code %d\n", ret);
		exit(1);
	}
}

//////////////////////////////////////////////////////////////////////////////

int main(int argc, char **argv)
{
	int queues, timeout;
	unsigned long long totals;
	int i;

	printf("psem [nr queues] [timeout]\n");
	if (argc != 3) {
		printf(" Invalid parameters.\n");
		return 0;
	}
	queues = atoi(argv[1]);
	timeout = atoi(argv[2]);
	printf("Using %d queues/cpus (%d threads) for %d seconds.\n",
			queues, 2*queues, timeout);

	g_results = new unsigned long long[2*queues];
	g_svsem_ids = new int[queues];
	g_threads = new pthread_t[2*queues];
	for (i=0;i<queues;i++) {
		init_threads(i, queues);
	}

	sleep(1);
	g_state = RUNNING;
	sleep(timeout);
	g_state = STOPPED;
	sleep(1);
	for (i=0;i<queues;i++) {
		int res;
		res = semctl(g_svsem_ids[i],1,IPC_RMID,NULL);
		if (res < 0) {
			printf("semctl(IPC_RMID) failed for %d, errno%d.\n",
				g_svsem_ids[i], errno);
		}
	}
	for (i=0;i<2*queues;i++)
		pthread_join(g_threads[i], NULL);

	printf("Result matrix:\n");
	totals = 0;
	for (i=0;i<queues;i++) {
		printf("  Thread %3d: %8lld     %3d: %8lld\n",
				i, g_results[i], i+queues, g_results[i+queues]);
		totals += g_results[i] + g_results[i+queues];
	}
	printf("Total: %lld\n", totals);
}

--------------070100020004070100040304--
