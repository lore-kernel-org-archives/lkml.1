Return-Path: <linux-kernel-owner+w=401wt.eu-S1755742AbZA2KNU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742AbZA2KNU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2009 05:13:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752860AbZA2KNL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Jan 2009 05:13:11 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:45790 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbZA2KNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2009 05:13:09 -0500
X-DKIM: Sendmail DKIM Filter v2.6.0 mail-in-02.arcor-online.net 7B3E13FE817
Subject: Re: [Bugme-new] [Bug 12562] New: High overhead while switching or
 synchronizing threads on different cores
From: Thomas Pilarski <thomas.pi@arcor.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Galbraith <efault@gmx.de>,
       Gregory Haskins <ghaskins@novell.com>, bugme-daemon@bugzilla.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <1233220048.7835.19.camel@twins>
References: <bug-12562-10286@http.bugzilla.kernel.org/>
	 <20090128125604.94ed3fe0.akpm@linux-foundation.org>
	 <1233181507.6988.14.camel@bugs-laptop>  <1233220048.7835.19.camel@twins>
Content-Type: multipart/mixed; boundary="=-VWRYRCmeokowUorT6R57"
Date: Thu, 29 Jan 2009 11:12:59 +0100
Message-Id: <1233223979.5294.41.camel@bugs-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VWRYRCmeokowUorT6R57
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

> > There is a regression, because of the improved cpu switching. The
> > problem exists in every kernel. 
> 
> This is a contradiction in terms - twice.
> 
> If it is a regression, then clearly things haven't improved.
> 
> If it is a regression, state clearly when it worked last. If it never
> worked, it cannot be a regression.

There is a improvement in load balancing for single threaded
applications. It's a regression for my problem. But the problem exists
in every kernel I have tested.

> > I takes a lot of time to switch between the threads, when they are
> > executed on different cores.
> > Perhaps of the big buffer size of 512KB?
> 
> Of course, pushing 512kb to another cpu means lots and lots of cache
> misses.

I have tried 2.6.15, 2.6.18 and 2.6.20 too, but same behavior as in
2.6.24.
With Windows I can get 64 message every second with a buffer size of 512
KB. It is reduced to 16 messages with a buffer size of 1MB. But I think
it not really comparable, because there is nearby no cpu consumption
with 512kB. Perhaps random() works different. By increasing the cpu
usage eight times in the producer, I can get 16msg/s and both cores are
used about ~50%. Doing the same with linux I get a throughput of
~2msg/s. 

If it is a caching issue, shouldn't it exists in Windows too?

Using a smaller buffer of 4KB, the test is executed on one core only. 
./schedulerissue 1 4096 8 2000
All threads finished: 2000 messages in 1.631 seconds / 1226.076 msg/s
real	0m1.635s
user	0m1.352s
sys	0m0.052s


But I want to use both cores to increase the performance. Adding a
second producer and a second consumer reduces the performance to 33%.
Both cores are used.
./schedulerissue 2 4096 8 2000
All threads finished: 1999 messages in 4.744 seconds / 421.379 msg/s
real	0m4.748s
user	0m3.280s
sys	0m5.852s

I have added a new version as there was a possible deadlock during
shut-down.

--=-VWRYRCmeokowUorT6R57
Content-Disposition: attachment; filename="ThreadSchedulingIssue.c"
Content-Type: text/x-csrc; name="ThreadSchedulingIssue.c"; charset="UTF-8"
Content-Transfer-Encoding: 8bit

#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <math.h>
#include <signal.h>
#include <unistd.h>
#include <time.h>

int CTHREADPAIRCOUNT;
int CBUFFER_SIZE;
int CBUFFER_COUNT;
int CMESSAGES_COUNT;

int todo_messages;

pthread_mutex_t producer_mutex;
pthread_cond_t producer_cond;

pthread_mutex_t consumer_mutex;
pthread_cond_t consumer_cond;

pthread_mutex_t result_mutex;
pthread_mutex_t todo_mutex;

int message_count = 0;
double start;
double end;

int terminate;
int terminate_producer;

double* buffers; //[CBUFFER_COUNT][CBUFFER_SIZE];

int freebuffer_count;
int freebuffer_pos;
double** free_buffers; //[CBUFFER_COUNT];

int filledbuffer_count;
int filledbuffer_pos;
double** filled_buffers; //[CBUFFER_COUNT];


/**
 * Return system uptime in µs
 */
double getSystemTime() {
	struct timespec tv;
	clock_gettime(CLOCK_MONOTONIC, &tv);
	return (double) (tv.tv_sec) * 1000000.0 + (double) (tv.tv_nsec) / 1000.0;
}

/**
 * Get free buffer and block thread if not buffer is available.
 */
double* getFreeBuffer() {
	pthread_mutex_lock(&producer_mutex);
	// If there is no free buffer to be filled, wait
	while (freebuffer_count == 0) {
		//printf("wait for free buffer\n");
		/** exit if all masages are finished **/
		if (terminate || terminate_producer) {
			pthread_mutex_unlock(&producer_mutex);
			return NULL;
		}
		pthread_cond_wait(&producer_cond, &producer_mutex);
	}
	usleep(1);
	double* result = free_buffers[freebuffer_pos];
	freebuffer_pos = (freebuffer_pos + 1) % CBUFFER_COUNT;
	freebuffer_count--;
	pthread_mutex_unlock(&producer_mutex);
	return result;
}

/**
 * Return free buffer and notify producer
 */
void returnFreeBuffer(double* buff) {
	pthread_mutex_lock(&producer_mutex);
	free_buffers[(freebuffer_pos + freebuffer_count) % CBUFFER_COUNT] = buff;
	freebuffer_count++;
	// Notify waiting producer
	//printf("added free buffer\n");
	pthread_cond_signal(&producer_cond);
	pthread_mutex_unlock(&producer_mutex);
}

/**
 * Add filled buffer and notify consumer
 */
void putFilledBuffer(double* buff) {
	pthread_mutex_lock(&consumer_mutex);
	filled_buffers[(filledbuffer_pos + filledbuffer_count) % CBUFFER_COUNT]
			= buff;
	filledbuffer_count++;
	// Notify waiting consumers
	//printf("added filled buffer\n");
	pthread_cond_signal(&consumer_cond);
	pthread_mutex_unlock(&consumer_mutex);
}

/**
 * Get filled buffer or wait until exists
 */
double* getFilledBuffer() {
	pthread_mutex_lock(&consumer_mutex);
	// If there is no filled buffer, wait until producer fills a new one
	while (filledbuffer_count == 0) {
		//printf("wait for filled buffer\n");
		/**
		 * exit if all massages are finished
		 * This can cause the loosing of some
		 * already produces data.
		 **/
		if (terminate || terminate_producer) {
			terminate = 1;
			pthread_mutex_unlock(&consumer_mutex);
			return NULL;
		}
		pthread_cond_wait(&consumer_cond, &consumer_mutex);
	}
	double* result = filled_buffers[filledbuffer_pos];
	filledbuffer_pos = (filledbuffer_pos + 1) % CBUFFER_COUNT;
	filledbuffer_count--;
	pthread_mutex_unlock(&consumer_mutex);
	return result;
}

/**
 * Producer thread. Filled buffer with random numbers and add to consumer list.
 */
void *thread_producer(void *arg) {
	while (!terminate && !terminate_producer) {
		int i;
		pthread_mutex_lock(&todo_mutex);
		if (todo_messages <= 0) {
			terminate_producer = 1;
			pthread_mutex_unlock(&todo_mutex);
			break;
		}
		todo_messages--;
		pthread_mutex_unlock(&todo_mutex);
		double* cbuff = getFreeBuffer();
		if (cbuff) {
			cbuff[0] = getSystemTime();
			for (i = 2; i < CBUFFER_SIZE; i++) {
				// Fill the buffer with random character 0 - 255
				cbuff[i] =
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
//				(double) random() / (double) RAND_MAX *
				(double) random() / (double) RAND_MAX;
			}

			cbuff[1] = getSystemTime();
			putFilledBuffer(cbuff);

		}
	}
	pthread_exit(NULL);
}

/**
 * Consumer thread. Get filled buffer. Make something and return to producer list.
 */
void *thread_consumer(void *arg) {
	while (!terminate) {
		int i;
		double* cbuff = getFilledBuffer();
		if (cbuff) {
			cbuff[2] = getSystemTime();
			for (i = 4; i < CBUFFER_SIZE - 1; i++) {
				// Fill the buffer with random character 0 - 255
				cbuff[i] *= (double) random() / (double) RAND_MAX;
			}
			cbuff[3] = getSystemTime();

			pthread_mutex_lock(&result_mutex);
			if ((message_count == 0) || (start > cbuff[0])) {
				start = cbuff[0];
			}
			if ((message_count == 0) || (end < cbuff[3])) {
				end = cbuff[3];
			}
			message_count++;
			pthread_mutex_unlock(&result_mutex);
			//		printf("Message runntime Calc:%1.3fms / Sendmessage: %1.3fms / Calc:%1.3fms\n",
			//				(cbuff[1] - cbuff[0])/1000.0,
			//				(cbuff[2] - cbuff[1])/1000.0,
			//				(cbuff[3] - cbuff[2])/1000.0
			//				);
			returnFreeBuffer(cbuff);
		}
	}
	pthread_exit(NULL);
}

/**
 * Set terminate flag on sig quit.
 */
void sig_quit(int a) {
	terminate = 1;
	printf("Terminate calculation\n");
	/*
	 *  Notify producers, a they can wait for
	 *  free buffers.
	 */
	pthread_cond_broadcast(&producer_cond);
}

/**
 * For testing purposes only.
 */
int main(int argc, char *argv[]) {
	terminate = 0;
	terminate_producer = 0;
	if (signal(SIGINT, sig_quit) == SIG_ERR) {
		printf("Could not init quit signal\n");
		return -1;
	}

	if (argc < 5) {
		printf(
				"Need tree parameters. Number of thread pairs - message size in doubles - buffer count - overall messages - (show intermediate data intervall)\n");
		exit(-1);
	}

	int show_intermediate = 0;

	CTHREADPAIRCOUNT = atoi(argv[1]);
	CBUFFER_SIZE = atoi(argv[2]);
	CBUFFER_COUNT = atoi(argv[3]);
	CMESSAGES_COUNT = atoi(argv[4]);
	if (argc > 5) {
		show_intermediate = atoi(argv[5]);
	}

	if ((CTHREADPAIRCOUNT < 1) || (CTHREADPAIRCOUNT > 256)) {
		printf("Number of thread pairs is limited by 1-256\n");
		exit(-1);
	}
	if ((CBUFFER_SIZE < 8) || (CBUFFER_SIZE > 1048576)) {
		printf("Buffer size is limited by 8-1,048,576\n");
		exit(-1);
	}
	if ((CBUFFER_COUNT < 1) || (CBUFFER_COUNT
			> CTHREADPAIRCOUNT * 8)) {
		printf(
				"Number of buffers is limited by 1 and tread pairs * 8\n");
		exit(-1);
	}
	if ((CMESSAGES_COUNT < CTHREADPAIRCOUNT * 2) || (CBUFFER_COUNT
			> CTHREADPAIRCOUNT * 100)) {
		printf(
				"Number of messages is limited by thread pairs * 2 and tread pairs * 100\n");
		exit(-1);
	}
	if ((show_intermediate < 0) || (show_intermediate > 10)) {
		printf(	"Intermediate data interval must be in [0-10]\n");
		exit(-1);
	}

	buffers = malloc(CBUFFER_COUNT * CBUFFER_SIZE * sizeof(double));
	free_buffers = malloc(CBUFFER_COUNT * sizeof(double*));
	filled_buffers = malloc(CBUFFER_COUNT * sizeof(double*));

	todo_messages = CMESSAGES_COUNT;

	pthread_mutex_init(&consumer_mutex, NULL);
	pthread_cond_init(&consumer_cond, NULL);

	pthread_mutex_init(&producer_mutex, NULL);
	pthread_cond_init(&producer_cond, NULL);

	pthread_mutex_init(&result_mutex, NULL);
	pthread_mutex_init(&todo_mutex, NULL);

	int i;
	for (i = 0; i < CBUFFER_COUNT; i++) {
		free_buffers[i] = &(buffers[i * CBUFFER_SIZE]);
	}
	freebuffer_count = CBUFFER_COUNT;
	freebuffer_pos = 0;
	filledbuffer_count = 0;
	filledbuffer_pos = 0;

	pthread_t threads[CTHREADPAIRCOUNT * 2];

	for (i = 0; i < CTHREADPAIRCOUNT; i++) {
		if (pthread_create(&threads[i], NULL, thread_producer, NULL)) {
			printf("Could not create producer %d\n", i);
		}
		if (pthread_create(&threads[i + CTHREADPAIRCOUNT],
				NULL, thread_consumer, NULL)) {
			printf("Could not create consumer %d\n", i);
		}
	}

	double start_overall = -1;
	double end_overall = -1;
	int all_messages = 0;

	if (show_intermediate) {
		while (!terminate) {
			sleep(show_intermediate);
			pthread_mutex_lock(&result_mutex);
			printf("Messages %d - msg/s: %1.3f\n", message_count,
					((double) message_count) / ((end - start) / 1000000.0));
			if ((start_overall < 0) || (start_overall > start)) {
				start_overall = start;
			}
			if ((end_overall < 0) || (end_overall < end)) {
				end_overall = end;
			}
			//start = getSystemTime();
			all_messages += message_count;
			message_count = 0;
			pthread_mutex_unlock(&result_mutex);
		}
	}

	for (i = 0; i < CTHREADPAIRCOUNT; i++) {
		//printf("Wait for thread %d\n", i);
		pthread_join(threads[i], NULL);
	}


	terminate = 1;
	/**
	 * Notify consumers, as they can wait for
	 * data.
	 */
	pthread_cond_broadcast(&consumer_cond);

	for (i = CTHREADPAIRCOUNT; i < CTHREADPAIRCOUNT*2; i++) {
		//printf("Wait for thread %d\n", i);
		pthread_join(threads[i], NULL);
	}

	if (!show_intermediate) {
		start_overall = start;
		end_overall = end;
		all_messages = message_count;
	}
	printf(
			"All threads finished: %d messages in %1.3f seconds / %1.3f msg/s\n",
			all_messages, (end_overall - start_overall) / 1000000.0,
			(double) all_messages / ((end_overall - start_overall) / 1000000.0));

	pthread_mutex_destroy(&producer_mutex);
	pthread_cond_destroy(&producer_cond);

	pthread_mutex_destroy(&consumer_mutex);
	pthread_cond_destroy(&consumer_cond);

	pthread_mutex_destroy(&result_mutex);
	pthread_mutex_destroy(&todo_mutex);

	free(buffers);
	free(free_buffers);
	free(filled_buffers);

	return EXIT_SUCCESS;
}

--=-VWRYRCmeokowUorT6R57--

