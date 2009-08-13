Return-Path: <linux-kernel-owner+w=401wt.eu-S1754280AbZHMKsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754280AbZHMKsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Aug 2009 06:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZHMKsN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Aug 2009 06:48:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:47436 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753435AbZHMKsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Aug 2009 06:48:11 -0400
Message-Id: <20090813094752.433445710@chello.nl>
User-Agent: quilt/0.46-1
Date: Thu, 13 Aug 2009 11:47:52 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 0/4] perf_counter: Group reads and other patches
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So Ingo really wanted to not break the current read() ABI, which is possible
with a little bit more code. Hence here a second version.

The test proglet below gives:

# gcc -o test test.c; ./test
EVNT: 0x400851 scale: nan ID: 646 CNT: 1006656 ID: 647 CNT: 1011020 ID: 648 CNT: 1011120 ID: 649 CNT: 1011079
EVNT: 0x40084b scale: 1.000000 ID: 646 CNT: 2002513 ID: 647 CNT: 2009368 ID: 648 CNT: 2009756 ID: 649 CNT: 2010162
EVNT: 0x40084b scale: 1.000000 ID: 646 CNT: 3002611 ID: 647 CNT: 3013444 ID: 648 CNT: 3014276 ID: 649 CNT: 3015129
EVNT: 0x400858 scale: 1.000000 ID: 646 CNT: 4002528 ID: 647 CNT: 4017221 ID: 648 CNT: 4018497 ID: 649 CNT: 4019802
EVNT: 0x40084b scale: 1.000000 ID: 646 CNT: 5002324 ID: 647 CNT: 5020652 ID: 648 CNT: 5022372 ID: 649 CNT: 5024119
EVNT: 0x40084c scale: 1.000000 ID: 646 CNT: 6002555 ID: 647 CNT: 6024466 ID: 648 CNT: 6026635 ID: 649 CNT: 6028829

and an the regular perf stuff also still works:

# perf stat sleep 1

 Performance counter stats for 'sleep 1':

       4.164737  task-clock-msecs         #      0.004 CPUs
              1  context-switches         #      0.000 M/sec
              0  CPU-migrations           #      0.000 M/sec
            186  page-faults              #      0.045 M/sec
        4109598  cycles                   #    986.761 M/sec
        2573031  instructions             #      0.626 IPC
        1268929  cache-references         #    304.684 M/sec
          13059  cache-misses             #      3.136 M/sec


---
#include "perf.h"

#include <sys/types.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <unistd.h>
#include <signal.h>
#include <fcntl.h>
#include <errno.h>
#include <string.h>

void work(void)
{
	int i;

	for (i = 0; i < 1000000; i++) {
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
		asm("nop");
	}
}

unsigned long page_size;
int fd = -1, fd1 = 0;
pid_t me;
void *output;

void handle_sigio(int sig)
{
	ioctl(fd, PERF_COUNTER_IOC_REFRESH, 1);
}

static unsigned long mmap_read_head(void)
{
	struct perf_counter_mmap_page *pc = output;
	long head;

	head = pc->data_head;
	rmb();

	return head;
}

static void *mmap_read_base(void)
{
	return output + page_size;
}

struct event {
	struct perf_event_header header;

	u64 ip;
	u64 nr;
	u64 time_enabled;
	u64 time_running;
	struct {
		u64 val;
		u64 id;
	} cnt[0];
};

int main(int argc, char **argv)
{
	struct perf_counter_attr attr;
	unsigned long offset = 0, head;
	int err, i;

	page_size = sysconf(_SC_PAGE_SIZE);
	me = getpid();

	memset(&attr, 0, sizeof(attr));

	attr.type = PERF_TYPE_HARDWARE;
	attr.config = PERF_COUNT_HW_CPU_CYCLES;
	attr.sample_period = 1000000;
	attr.sample_type = PERF_SAMPLE_IP |
			   PERF_SAMPLE_READ;
	attr.read_format = PERF_FORMAT_TOTAL_TIME_RUNNING |
			   PERF_FORMAT_TOTAL_TIME_ENABLED |
			   PERF_FORMAT_ID |
			   PERF_FORMAT_GROUP;
	attr.disabled = 1;
	attr.wakeup_events = 1;

	fd  = sys_perf_counter_open(&attr, me, -1, fd, 0);
	if (fd <= 0) {
		perror("FAIL fd: ");
		exit(-1);
	}

	attr.sample_period = 0;
	attr.disabled = 0;

	for (i = 0; i < 3; i++) {
		fd1 = sys_perf_counter_open(&attr, me, -1, fd, 0);
		if (fd1 <= 0) {
			perror("FAIL fd1: ");
			exit(-1);
		}
	}

	signal(SIGIO, handle_sigio);
	err = fcntl(fd, F_SETOWN, me);
	if (err == -1) {
		perror("FAIL fcntl: ");
		exit(-1);
	}

	err = fcntl(fd, F_SETFL, fcntl(fd, F_GETFL, 0) | O_ASYNC);
	if (err == -1) {
		perror("FAIL fcntl2: ");
		exit(-1);
	}

	output = mmap(NULL, page_size * 3, PROT_READ, MAP_SHARED, fd, 0);
	if (output == ((void *)-1)) {
		perror("FAIL mmap:");
		exit(-1);
	}

	ioctl(fd, PERF_COUNTER_IOC_REFRESH, 1);

	work();

	ioctl(fd, PERF_COUNTER_IOC_DISABLE, 0);

	head = mmap_read_head();

	for (; offset < head; ) {
		struct event *evnt = mmap_read_base() + offset;

		offset += evnt->header.size;

		printf("EVNT: %p scale: %f ", (void *)evnt->ip,
				((double)evnt->time_running)/evnt->time_enabled
				);
		for (i = 0; i < evnt->nr; i++) {
			printf("ID: %Lu CNT: %Lu ", 
					evnt->cnt[i].id, evnt->cnt[i].val);
		}
		printf("\n");
	}

	return 0;
}

