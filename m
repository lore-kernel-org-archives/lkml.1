Return-Path: <linux-kernel-owner+w=401wt.eu-S1753692AbZHLPmu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753692AbZHLPmu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:42:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752670AbZHLPmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:42:49 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:42918 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241AbZHLPms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:42:48 -0400
Message-Id: <20090812153529.716542680@chello.nl>
User-Agent: quilt/0.46-1
Date: Wed, 12 Aug 2009 17:35:29 +0200
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       stephane eranian <eranian@googlemail.com>
Cc: Corey J Ashford <cjashfor@us.ibm.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] perf_counter: fix the group mess
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


With these two patches the below proglet gives:

# ./test
EVNT: 0xffffffff811c0f4c scale: nan ID: 37 CNT: 1006180 ID: 38 CNT: 1010230 ID: 39 CNT: 1010332 ID: 40 CNT: 1010420

I can't seem to catch the SIGIO thing, but at least all the counters report
more or less the same value.  Also, that scale stuff doesn't seem to quite work
yet.. I'll be poking at that too.



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

	for (i = 0; i < 1000000000; i++) {
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
	printf("signal\n"); // not signal safe
	fflush(stdout);

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

