Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZKJTrp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZKJTrp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:47:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757920AbZKJTro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:47:44 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:41278 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757876AbZKJTrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:47:43 -0500
Message-ID: <4AF9C356.3030703@linux.vnet.ibm.com>
Date: Tue, 10 Nov 2009 11:47:34 -0800
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>
Subject: perf: repost of bug report regarding PERF_TOTAL_TIME_RUINNING and
 PERF_TOTAL_TIME_ENABLED
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Since my first post on this subject (on 10/25/2009) was buried fairly deep in a 
thread and may have been missed, I'm posting it again in a new thread:

I have created a simple test case which demonstrates a bug regarding the reading 
a group of counters (via PERF_FORMAT_GROUP) which have the total time enabled 
and total time running fields enabled (via PERF_TOTAL_TIME_RUNNING, 
PERF_TOTAL_TIME_ENABLED).  If I create a group as above with a single event in 
it, enable, give the CPU some work to do, then read the counter (via read()) 
without first disabling the counters, the total time running and total time 
enabled values are zero.

If you toss the test case below into the perf source directory and compile it as 
follows:

gcc -m64 -o petb perf_events_time_bug.c -lrt

it will show the error:
% ./petb
[0] = 1
[1] = 0 <- time enabled
[2] = 0 <- time running
[3] = 4559d1f8
[4] = 1
test failed!

perf_events_time_bug.c -lrt

If you compile it with:

gcc -DDO_DISABLE -m64 -o petb perf_events_time_bug.c -lrt

This will disable the event before reading it and then you will get the correct 
times.

% ./petb
[0] = 1
[1] = 2a50c1c8 <- time enabled
[2] = 2a50c1c8 <- time running
[3] = 460dea97
[4] = 2
test passed!

-- 
Regards,

- Corey

Corey Ashford
Software Engineer
IBM Linux Technology Center, Linux Toolchain
Beaverton, OR
cjashfor@us.ibm.com



#include "perf.h"
#include <assert.h>
#include <errno.h>
#include <math.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/ioctl.h>
#include <time.h>
#include "perf.h"

static double dummy3(double x, int iters);

long long get_real_usec(void)
{
	struct timespec ts;
	clock_gettime(CLOCK_REALTIME, &ts);
	return ((long long) ts.tv_sec * 1000000) + ((long long) ts.tv_nsec
			/ 1000);
}

#define NUM_FLOPS 20000000

int main(int argc, char **argv)
{
	struct perf_event_attr event_attr;
	int iters = NUM_FLOPS;
	double x = 1.1, y;
	long long t1, t2;

	t2 = 1000000; /* Target: 1,000,000 usec */

	/* Measure one run */
	t1 = get_real_usec();
	y = dummy3(x, iters);
	t1 = get_real_usec() - t1;

	if (t2 > t1) /* Scale up execution time to match t2 */
		iters = iters * (int) (t2 / t1);

	x = 1.0;

	memset(&event_attr, 0, sizeof(struct perf_event_attr));
	event_attr.read_format = PERF_FORMAT_GROUP | PERF_FORMAT_ID
			| PERF_FORMAT_TOTAL_TIME_RUNNING
			| PERF_FORMAT_TOTAL_TIME_ENABLED;
	event_attr.disabled = 1;
	event_attr.type = PERF_TYPE_HARDWARE;
	event_attr.config = PERF_COUNT_HW_CPU_CYCLES;

	/* count this thread, make this the group leader */
	int fd = sys_perf_event_open(&event_attr, 0, -1, -1, 0);
	if (fd == -1) {
		printf("sys_perf_event_open failed: %s\n", strerror(errno));
		exit(1);
	}

	int ret = ioctl(fd, PERF_EVENT_IOC_ENABLE, NULL);
	if (ret == -1) {
		printf("enable failed: %s\n", strerror(errno));
		exit(1);
	}
	y = dummy3(x, iters);
#ifdef DO_DISABLE
	ret = ioctl(fd, PERF_EVENT_IOC_DISABLE, NULL);
	if (ret == -1) {
		printf("disable failed: %s\n", strerror(errno));
		exit (1);
	}
#endif

	uint64_t buffer[5];
	int cnt;
	cnt = read(fd, buffer, sizeof(buffer));
	if (cnt == -1) {
		printf("read failed: %s\n", strerror(errno));
	}
	int i;
	for (i = 0; i < 5; i++) {
		printf("[%d] = %llx\n", i, buffer[i]);
	}

#define TIME_ENABLED_IDX 1
#define TIME_RUNNING_IDX 2

	if (!buffer[TIME_ENABLED_IDX] || !buffer[TIME_RUNNING_IDX]) {
		printf("test failed!\n");
		exit(1);
	} else {
		printf("test passed!\n");
		exit(0);
	}
}

static double dummy3(double x, int iters)
{
	int i;
	double w, y, z, a, b, c, d, e, f, g, h;
	double one;
	one = 1.0;
	w = x;
	y = x;
	z = x;
	a = x;
	b = x;
	c = x;
	d = x;
	e = x;
	f = x;
	g = x;
	h = x;
	for (i = 1; i <= iters; i++) {
		w = w * 1.000000000001 + one;
		y = y * 1.000000000002 + one;
		z = z * 1.000000000003 + one;
		a = a * 1.000000000004 + one;
		b = b * 1.000000000005 + one;
		c = c * 0.999999999999 + one;
		d = d * 0.999999999998 + one;
		e = e * 0.999999999997 + one;
		f = f * 0.999999999996 + one;
		g = h * 0.999999999995 + one;
		h = h * 1.000000000006 + one;
	}
	return 2.0 * (a + b + c + d + e + f + w + x + y + z + g + h);
}


