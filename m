Return-Path: <linux-kernel-owner+w=401wt.eu-S932619AbXGKOtb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932619AbXGKOtb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 10:49:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763646AbXGKOtU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 10:49:20 -0400
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:60319 "EHLO
	ecfrec.frec.bull.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763628AbXGKOtS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 10:49:18 -0400
Date: Wed, 11 Jul 2007 16:47:08 +0200
From: =?UTF-8?B?U8OpYmFzdGllbiBEdWd1w6k=?= <sebastien.dugue@bull.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linux RT Users <linux-rt-users@vger.kernel.org>,
       Darren Hart <dvhltc@us.ibm.com>, john stultz <johnstul@us.ibm.com>,
       Jean Pierre Dion <jean-pierre.dion@bull.net>,
       Gilles Carry <Gilles.Carry@ext.bull.net>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: [Patch RT] Fix CFS load balancing for RT tasks
Message-ID: <20070711164708.48907792@frecb000686.frec.bull.fr>
X-Mailer: Claws Mail 2.9.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
X-MIMETrack: Itemize by SMTP Server on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/07/2007 16:53:33,
	Serialize by Router on ECN002/FR/BULL(Release 5.0.12  |February 13, 2003) at
 11/07/2007 16:53:36,
	Serialize complete at 11/07/2007 16:53:36
Content-Type: multipart/mixed; boundary=MP_dTl6QWMgfSa6a.7Z4QWYBqy
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--MP_dTl6QWMgfSa6a.7Z4QWYBqy
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline


  Hi Ingo, all

  there seems to be something wrong with the way the CFS balances (or does =
not
balance) RT tasks. This was evidenced using the sched_football testcase
available from the RT wiki (http://rt.wiki.kernel.org/index.php/IBM_Test_Ca=
ses)
which I modified and attached to this mail.

  The testcase starts a number of threads which fall into 3 categories:

	1 referee thread: SCHED_FIFO, RT prio 5
	ncpus defensive threads: SCHED_FIFO, RT prio 4
	ncpus offensive threads: SCHED_FIFO, RT prio 3

	(ncpus being the number of CPUs)

  To make a long story short, the defensive threads should end up distribut=
ed
among all CPUs, but that's not the case. For example, on a dual HT Xeon box,
after task migration stabilizes we have the following running on the differ=
ent
CPUs:

  CPU 0: defense2
  CPU 1: referee offense2 offense3 offense4 defense3
  CPU 2: offense1
  CPU 3: defense1 defense4

which clearly show the imbalance between CPU 2 and CPU 3 where offense1
should not be allowed to run while the higher prio defense1 and defense4
are sharing the same CPU.

  The following patch fixes this by re-enabling the RT overload detection
for the CFS. It may not be the right solution, maybe it should be incorpora=
ted
into the other load balancing mechanisms. I did not digg deep enough yet
to make that call ;-)

  P.S. Thanks to Steven Rostedt for logdev which is proving invaluable in
       cases like this.

  S=C3=A9bastien.


------------------

  The RT overload mechanism of the O(1) scheduler has not been activated
in the new CFS.

  This patch fixes that by inserting calls to inc_rt_tasks() and dec_rt_tas=
ks()
in enqueue_task_rt() and dequeue_task_rt() respectively, which enables the
balance_rt_tasks() to be run in the rt_overload case.


Signed-off-by: S=C3=A9bastien Dugu=C3=A9 <sebastien.dugue@bull.net>

---
 kernel/sched_rt.c |    4 ++++
 1 file changed, 4 insertions(+)

Index: linux-2.6.21.5-rt20/kernel/sched_rt.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux-2.6.21.5-rt20.orig/kernel/sched_rt.c	2007-07-11 10:46:26.00000000=
0 +0200
+++ linux-2.6.21.5-rt20/kernel/sched_rt.c	2007-07-11 10:46:50.000000000 +02=
00
@@ -32,6 +32,8 @@ enqueue_task_rt(struct rq *rq, struct ta
=20
 	list_add_tail(&p->run_list, array->queue + p->prio);
 	__set_bit(p->prio, array->bitmap);
+
+	inc_rt_tasks(p, rq);
 }
=20
 /*
@@ -44,6 +46,8 @@ dequeue_task_rt(struct rq *rq, struct ta
=20
 	update_curr_rt(rq, now);
=20
+	dec_rt_tasks(p, rq);
+
 	list_del(&p->run_list);
 	if (list_empty(array->queue + p->prio))
 		__clear_bit(p->prio, array->bitmap);

--MP_dTl6QWMgfSa6a.7Z4QWYBqy
Content-Transfer-Encoding: 7bit
Content-Type: text/x-csrc; name=sched_football.c
Content-Disposition: attachment; filename=sched_football.c

/* Threaded Football - by John Stultz <johnstul@xxxxxxxxxx>
 *
 * This is a scheduler test that uses a football analogy.
 * The premise is that we want to make sure that lower priority threads
 * (the offensive team) do not preempt higher priority threads (the
 * defensive team). The offense is trying to increment the balls position,
 * while the defense is trying to block that from happening.
 * And the ref (highest priority thread) will blow the wistle if the
 * ball moves. Finally, we have crazy fans (higer prority) that try to
 * distract the defense by occasionally running onto the field.
 *
 * Steps:
 * - Create a fixed number of offense threads (lower priority)
 * - Create a fixed number of defense threads (higher priority)
 * - Create a referee thread (highest priority)
 * - Once everyone is on the field, the offense thread increments the value of
 *   'the_ball' and yields. The defense thread tries to block the ball by never
 *   letting the offense players get the CPU (it just does a sched_yield)
 * - The refree threads wakes up regularly to check if the game is over :)
 * - In the end, if the value of 'the_ball' is >0, the test is considered to
 *   have failed.
 *
 * PS: I really don't like football that much, it just seemed to fit.
 *
 * 2006-03-16 Reduced verbosity, non binary failure reporting, removal of
 * crazy_fans thread, added game_length argument by Darren Hart.
 */

#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <time.h>
#include <string.h>
#include <pthread.h>
#include <sched.h>
#include <errno.h>
#include <sys/syscall.h>
#include <unistd.h>
#include <sys/time.h>

#define gettid() syscall(__NR_gettid)

#define MAXTHREADS 256

#define DEF_GAME_LENGTH 5

/* Here's the position of the ball */
volatile int the_ball;

/* Game status */
volatile int game_started;
volatile int game_over;

/* Keep track of who's on the field */
volatile int offense_count;
volatile int defense_count;

/* simple mutex for our atomic increments */
pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;

#define min(x,y) (x < y ? x: y)


/* This is the defensive team. They're trying to block the offense */
void *thread_defense(void* arg)
{
	pthread_mutex_lock(&mutex);
	defense_count++;
	pthread_mutex_unlock(&mutex);

	printf("thread_defense (%ld) starting\n", gettid());

	/*keep the ball from being moved */
	while (!game_over) {
		sched_yield(); /* let other defenders run */
	}
	return NULL;
}


/* This is the offensive team. They're trying to move the ball */
void *thread_offense(void* arg)
{
	pthread_mutex_lock(&mutex);
	offense_count++;
	pthread_mutex_unlock(&mutex);

	printf("thread_offense (%ld) starting\n", gettid());

	while (!game_started)
		sched_yield();

	while (!game_over) {
		the_ball++; /* move the ball ahead one yard */
		sched_yield(); /* let other offensive players run */
	}
	return NULL;
}

void referee(int game_length)
{
	struct timeval start, now;

	printf("Game On (%d seconds)!\n", game_length);

	gettimeofday(&start, 0);
	now = start;
	the_ball = 0;
	game_started = 1;

	/* Watch the game */
	while ((now.tv_sec - start.tv_sec) < game_length) {
		sleep(1);
		gettimeofday(&now, 0);
	}
	/* Blow the whistle */
	printf("Game Over!\n");
	printf("Final ball position: %d\n", the_ball);
	game_over = 1;
}


void create_thread(pthread_t *thread, void*(*func)(void*), int prio)
{
	pthread_attr_t attr;
	struct sched_param param;

	param.sched_priority = sched_get_priority_min(SCHED_FIFO) + prio;

	pthread_attr_init(&attr);
	pthread_attr_setinheritsched (&attr, PTHREAD_EXPLICIT_SCHED);
	pthread_attr_setschedparam(&attr, &param);
	pthread_attr_setschedpolicy(&attr, SCHED_FIFO);

	if (pthread_create(thread, &attr, func, (void *)0)) {
		perror("pthread_create failed");
	}

	pthread_attr_destroy(&attr);
}

int main(int argc, char* argv[])
{
	struct sched_param param;
	int players_per_team, game_length;
	int priority,numcpus;
	int thread_count = 0;
	pthread_t thread_id[MAXTHREADS];
	int i;

	if (argc < 2 || argc > 3) {
		printf("Usage: %s players_per_team [game_length (seconds)]\n", argv[0]);
		numcpus = sysconf(_SC_NPROCESSORS_ONLN);
		printf("Using default values players_per_team= %d game_length= 10\n", numcpus);
		players_per_team = numcpus;
		game_length = 10;		
	}

	else {
		players_per_team = atoi(argv[1]);
		if (argc == 3)
			game_length = atoi(argv[2]);
		else
			game_length = DEF_GAME_LENGTH;
	}

	/* We're the ref, so set our priority right */
	param.sched_priority = sched_get_priority_min(SCHED_FIFO) + 4;
	sched_setscheduler(0, SCHED_FIFO, &param);
	printf("referee (%ld) started\n", gettid());

	/* Start the offense */
	priority = 2;
	printf("Starting %d offense threads at priority %d\n",
			players_per_team, priority);
	for (i = 0; i < players_per_team; i++)
		create_thread(&thread_id[thread_count++],
				thread_offense, priority);
	while (offense_count < players_per_team)
		usleep(100);

	/* Start the defense */
	priority = 3;
	printf("Starting %d defense threads at priority %d\n",
			players_per_team, priority);
	for (i = 0; i < players_per_team; i++)
		create_thread(&thread_id[thread_count++],
				thread_defense, priority);
	while (defense_count < players_per_team)
		usleep(100);

	/* Ok, everyone is on the field, bring out the ref */
	printf("Starting referee thread\n");
	referee(game_length);

	for (i = 0; i < thread_count; i++) {
		usleep(100);
		pthread_join(thread_id[i], 0);
	}

	if (the_ball)
		exit(1);
	return 0;
}


--MP_dTl6QWMgfSa6a.7Z4QWYBqy--
