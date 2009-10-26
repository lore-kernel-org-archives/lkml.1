Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbZJZChJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbZJZChJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 22:37:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZJZChJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 22:37:09 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35773 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754428AbZJZChH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 22:37:07 -0400
Message-ID: <4AE50B55.4070706@linux.vnet.ibm.com>
Date: Sun, 25 Oct 2009 19:37:09 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, paulus@au1.ibm.com
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: perf_events: zero time running and enabled, but non-zero count
References: <4AE20102.8010002@linux.vnet.ibm.com> <20091023193246.GA3139@elte.hu> <4AE21655.6040403@linux.vnet.ibm.com> <20091023205711.GB8356@elte.hu>
In-Reply-To: <20091023205711.GB8356@elte.hu>
Content-Type: multipart/mixed;
 boundary="------------050706010300080909060609"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050706010300080909060609
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit

On 10/23/2009 01:57 PM, Ingo Molnar wrote:
>
> * Corey Ashford<cjashfor@linux.vnet.ibm.com>  wrote:
>
>>> Btw., you might want to consider putting such testcases into a new
>>> 'perf test' kind of utility (under tools/perf/builtin-test.c) that
>>> does various tests such as reading a count and validating the
>>> time-running/time-enabled values - so that we can see any bugs
>>> directly.
>>
>> I'll see if I can put the test case in some sort of acceptable format
>> like that.  Maybe we can use this one test case as the starting point
>> for builtin-test.c.
>
> Yeah. Feel free to add just something minimal that solves your problem.
> Others will add their testcases too i'm sure, once the basic command is
> there.
>
> 	Ingo

Hi Ingo and Paul,

I followed the directions Ingo provided for getting the -tip tree and 
then attempted to build the perf tool that's in it and it doesn't build. 
  I'm getting this error on a Power5 box:

../../lib/find_next_bit.c: In function ‘ext2_swabp’:
../../lib/find_next_bit.c:168: warning: passing argument 1 of 
‘__swab64p’ from incompatible pointer type
make: *** [util/find_next_bit.o] Error 1

I looked at the code and it looks ok to me.  There's a cast from an 
"unsigned long *" to a "unsigned long long *", but those types should be 
of the same size (in -m64 mode), so I don't know why this is failing.

Some good news is that I have created a simple test case which 
demonstrates the bug, but I haven't formulated it in the builtin-test.c 
format yet, since I have been able to build perf.

If you toss the attached file into the perf source directory and compile 
it as follows:

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

gcc -DDO_DISABLE -m66 -o petb perf_events_time_bug.c -lrt

This will disable the event before reading it and then you will get the 
correct times.

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

--------------050706010300080909060609
Content-Type: text/plain;
 name="perf_events_time_bug.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perf_events_time_bug.c"

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

--------------050706010300080909060609--
