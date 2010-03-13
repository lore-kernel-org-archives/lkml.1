Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758830Ab0CME1A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 23:27:00 -0500
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:57811 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758800Ab0CME07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 23:26:59 -0500
Message-ID: <4B9B1416.5020101@dcl.info.waseda.ac.jp>
Date: Sat, 13 Mar 2010 13:27:02 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
CC: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Ming Lei <tom.leiming@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: lock's trace events can improve mutex's performance in userspace?
References: <4B98BB50.1000002@cn.fujitsu.com>
In-Reply-To: <4B98BB50.1000002@cn.fujitsu.com>
Content-Type: multipart/mixed;
 boundary="------------060002060407020309000703"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060002060407020309000703
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 03/11/10 18:43, Xiao Guangrong wrote:
 > We found that if enable lock's trace events, the 'sysbench mutex'
 > benchmark program can run quicker.
 >
 > The simple program that is attached can reproduce it, the system info,
 > kernel config, and the script are also attached.
 >
 > The test step is below:
 >
 > # tar -zxvf test-mutex.tar.bz
 > # cd test-mutex
 > # make
 > # ./tscript.sh>&  log
 > # cat log | grep "real"
 > real    0m46.765s<  all trace events are disabled>
 > real    0m47.073s
 > real    0m47.402s
 > real    0m46.458s
 > real    0m47.433s
 > real    0m47.395s
 > real    0m47.010s
 > real    0m47.454s
 > real    0m47.044s
 > real    0m47.464s
 > real    0m39.245s<  enable lock's trace events>
 > real    0m40.822s
 > real    0m40.779s
 > real    0m40.549s
 > real    0m40.605s
 > real    0m40.923s
 > real    0m40.560s
 > real    0m41.050s
 > real    0m40.757s
 > real    0m40.715s
 >
 > [ "<  ...>" is my comments ]
 >
 >  From the result, we can see the program's runtime is less if enable
lock's
 > trace events.
 >
 > The conclusion is weird but i don't know why.

Hi Xiao,

It's hard to believe, but...

% sudo ./tscript.sh &> log
% grep real log
real    0m24.132s
real    0m23.535s
real    0m20.064s
real    0m16.636s <- enabled from here
real    0m16.435s
real    0m17.339s

I could reproduce your surprising result.
(I only execed your benchmark 3 times.)

I rewrote your mainc.c and checked contended count of each test like
this way,
		if (pthread_mutex_trylock(&mutex) == EBUSY) {
			pthread_mutex_lock(&mutex);
			atomic_inc(&contended);
		}
# I'll attach my new mainc.c

% cat log
Run mutex with trace events disabled...
contended:25191221

real    0m24.132s
user    0m17.149s
sys     1m18.933s
contended:25360563

real    0m23.535s
user    0m17.233s
sys     1m16.213s
contended:23813911

real    0m20.064s
user    0m15.561s
sys     1m4.332s
Run mutex with lockdep events enabled...
contended:11458318

real    0m16.636s
user    0m10.173s
sys     0m55.595s
contended:11881095

real    0m16.435s
user    0m10.273s
sys     0m54.911s
contended:11261650

real    0m17.339s
user    0m10.225s
sys     0m58.556s

It seems that num of contention decreased to about half.
I don't know why this happened and effect to performance of it,
but this result is worth to consider.

Thanks,
	Hitoshi

--------------060002060407020309000703
Content-Type: text/x-csrc;
 name="mainc.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="mainc.c"

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>

#include <errno.h>

#define THREADS_NUM	1000
#define MUTEX_LOCKS	300000

static pthread_mutex_t mutex;
static pthread_mutex_t thread_start_mutex;
static int dummy_count;

typedef struct {
	volatile int val;
} atomic_t;

atomic_t contended = { 0 };

static inline int
atomic_inc(atomic_t *addr)
{
	return __sync_add_and_fetch(&addr->val, 1);
}

static void *run_thread(void *arg)
{
	int i;

	pthread_mutex_lock(&thread_start_mutex);
 	pthread_mutex_unlock(&thread_start_mutex);

	for (i = 0; i < MUTEX_LOCKS; i++) {
		if (pthread_mutex_trylock(&mutex) == EBUSY) {
			pthread_mutex_lock(&mutex);
			atomic_inc(&contended);
		}
		dummy_count++;
		pthread_mutex_unlock(&mutex);
	}

	return NULL;
}

int main(int argc, char *argv[])
{
	pthread_t thread[THREADS_NUM];
	pthread_attr_t  thread_attr;
	int i;

	pthread_mutex_init(&mutex, NULL);
	pthread_mutex_init(&thread_start_mutex, NULL);
	pthread_attr_init(&thread_attr);
	pthread_attr_setstacksize(&thread_attr, 32*1024);

	pthread_mutex_lock(&thread_start_mutex);
	for (i = 0; i < THREADS_NUM; i++) {
		if (pthread_create(&thread[i], &thread_attr, run_thread, NULL) != 0) {
			printf("Thread[%d] create failed:", i);
			perror(NULL);
			exit(-1);
		}
    	}

	pthread_mutex_unlock(&thread_start_mutex);
	for (i = 0; i < THREADS_NUM; i++) {
		if (pthread_join(thread[i], NULL) != 0)
			printf("Thread #%d join failed.\n", i);
    	}
	pthread_mutex_destroy(&mutex);
	pthread_mutex_destroy(&thread_start_mutex);

	printf("contended:%d\n", contended.val);
	return 0;
}

--------------060002060407020309000703--
