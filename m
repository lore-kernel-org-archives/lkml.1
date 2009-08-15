Return-Path: <linux-kernel-owner+w=401wt.eu-S1752966AbZHPAtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966AbZHPAtH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Aug 2009 20:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752234AbZHPAtG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Aug 2009 20:49:06 -0400
Received: from sing.entic.net ([208.64.63.147]:34171 "EHLO mail.q-ag.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750899AbZHPAtF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Aug 2009 20:49:05 -0400
Message-Id: <200908160048.n7G0mtO1023800@mail.q-ag.de>
From: Manfred Spraul <manfred@colorfullife.com>
To: linux-kernel@vger.kernel.org
Cc: npiggin@suse.de
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nadia Derbey <Nadia.Derbey@bull.net>
Cc: Pierre Peiffer <peifferp@gmail.com>
Date: Sat, 15 Aug 2009 23:57:12 +0200
Subject: [PATCH 0/4] ipc/sem.c: Alternative to Nick's patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following series of 4 patches are an alternative to Nick's 4th
patch. They are intended to be applied after the first 3 patches from
Nick.

The advantages are simple:
- Lower number of new code lines.
- Lower total code size increase.
- Lower runtime memory consumption.
- 4 simple patches with the individual changes, each one can be
  reviewed individually.
- Lower number of seperate codepaths.

The disadvantage is also clear:
My patch doesn't optimize wait-for-zero as good as Nick's patch.
For example:
* n wait-for-zero entries and one decrement by 2 to be woken up,
  semval at 1, an increment by 2 arrives:
    Nick's patch is O(1) and my patch is O(n).

Neither of us knows if anyone uses that scenario and there are other
codepaths that are O(n^2), too. Thus I don't think this is a big issue.

Below is the test app/benchmark app I used:
The present kernel breaks down if lots of tasks are sleeping on the same
semaphore array, with the patch, the breakdown disappears.

With my test app, the performance of Nick's and my patch are comparable.

--
	Manfred
----

/*
 * Copyright (C) 2009 by Manfred Spraul.
 * 
 * Redistribution of this file is permitted under the terms of the GNU 
 * General Public License (GPL)
 */

#include <sys/sem.h>
#include <sys/time.h>
#include <sys/wait.h>
#include <time.h>
#include <pthread.h>
#include <stdlib.h>
#include <stdio.h>
#include <errno.h>
#include <string.h>
#include <assert.h>
#include <signal.h>
#include <unistd.h>

#define TRUE	1
#define FALSE	0

union semun {
	int val;
	struct semid_ds *buf;
	unsigned short int *array;
	struct seminfo* __buf;
};

#define barrier()	__asm__ __volatile__("": : : "memory")

int g_loops;
int g_busy_in;
int g_busy_out;
int g_sem;
int g_completedsem;

static void thread_fnc(int id)
{
	int i;
	volatile int j;
	int res;
	struct sembuf sop[1];

	for (i=0;i<g_loops;i++) {

		sop[0].sem_num=id;
		sop[0].sem_op=-1;
		sop[0].sem_flg=0;
		res = semop(g_sem,sop,1);
		if(res==-1) {
			printf("semop -1 failed, errno %d.\n", errno);
			return;
		}
		for(j=0;j<g_busy_in;j++);
			barrier();
		sop[0].sem_num=id;
		sop[0].sem_op=1;
		sop[0].sem_flg=0;
		res = semop(g_sem,sop,1);
		if(res==-1) {
			printf("semop +1 failed, errno %d.\n", errno);
			return;
		}
		for(j=0;j<g_busy_out;j++);
			barrier();
	}

	sop[0].sem_num=g_completedsem;
	sop[0].sem_op=-1;
	sop[0].sem_flg=IPC_NOWAIT;
	res = semop(g_sem,sop,1);
	if(res==-1) {
		printf("semop -1 on completedsem returned %d, errno %d.\n", res, errno);
		return;
	}
	return;
}

int main(int argc,char** argv)
{
	int nsems;
	int tasks;
	int res;
	pid_t *pids;
	unsigned short *psems;
	struct timeval t_before, t_after;
	unsigned long long delta;
	union semun arg;
	int i;

	printf("osim <sems> <tasks> <loops> <busy-in> <busy-out>\n");
	if(argc != 6) {
		printf("Invalid parameters.\n");
		return 1;
	}
	nsems=atoi(argv[1]);
	tasks=atoi(argv[2]);
	g_loops=atoi(argv[3]);
	g_loops = (g_loops+tasks-1)/tasks;
	g_busy_in=atoi(argv[4]);
	g_busy_out=atoi(argv[5]);
	g_completedsem = nsems;

	res = semget(IPC_PRIVATE, nsems+1, 0777 | IPC_CREAT);
	if(res == -1) {
		printf(" create failed.\n");
		return 1;
	}
	g_sem = res;
	fflush(stdout);

	pids = malloc(sizeof(pid_t)*tasks);
	for (i=0;i<tasks;i++) {
		res = fork();
		if (res == 0) {
			thread_fnc(i%nsems);
			exit(0);
		} 
		if (res == -1) {
			printf("fork() failed, errno now %d.\n", errno);
			return 1;
		}
		pids[i] = res;
	}

	printf("osim: using a semaphore array with %d semaphores.\n", nsems);
	printf("osim: using %d tasks.\n", tasks);
	printf("osim: each thread loops %d times\n", g_loops);
	printf("osim: each thread busyloops %d loops outside and %d loops inside.\n", g_busy_out, g_busy_in);
	fflush(stdout);

	psems = malloc(sizeof(unsigned short)*nsems);
	for (i=0;i<nsems;i++)
		psems[i] = 1;
	psems[i] = tasks;

	{
		struct sembuf sop[1];

		gettimeofday(&t_before, NULL);
		arg.array = psems;
		semctl(g_sem, 0, SETALL, arg);

		sop[0].sem_num=g_completedsem;
		sop[0].sem_op=0;
		sop[0].sem_flg=0;
		res = semop(g_sem,sop,1);
		if(res==-1) {
			printf("semop 0 failed, errno %d.\n", errno);
			return;
		}
		gettimeofday(&t_after, NULL);
	}
	for (i=0;i<tasks;i++) {
		res = waitpid(pids[i], NULL, 0);
		if (res != pids[i]) {
			printf("waitpid() failed, errno now %d.\n", errno);
			return 1;
		}
	}

	delta = t_after.tv_sec - t_before.tv_sec;
	delta = delta*1000000L;
	delta += t_after.tv_usec - t_before.tv_usec;

	printf("total execution time: %Ld.%03Ld%03Ld seconds for %d loops\n",
		(delta/1000000),
		(delta/1000)%1000,
		(delta)%1000,
		tasks*g_loops);

	delta = delta*1000;
	delta = delta/(tasks*g_loops);

	printf("per loop execution time: %Ld.%03Ld usec\n",
		(delta/1000),
		(delta)%1000);

	res = semctl(g_sem, 1, IPC_RMID, arg);
	if(res == -1) {
		printf(" semctl failed.\n");
		return 1;
	}
	return 0;
}
