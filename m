Return-Path: <linux-kernel-owner+w=401wt.eu-S2992801AbXBIUOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992801AbXBIUOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 15:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992802AbXBIUOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 15:14:32 -0500
Received: from mail01.syd.optusnet.com.au ([211.29.132.182]:36915 "EHLO
	mail01.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992801AbXBIUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 15:14:32 -0500
From: Con Kolivas <kernel@kolivas.org>
To: Andrew Burgess <aab@cichlid.com>
Subject: Re: Swap prefetch merge plans
Date: Sat, 10 Feb 2007 07:12:52 +1100
User-Agent: KMail/1.9.5
Cc: ck@vds.kolivas.org, akpm@osdl.org, linux-kernel@vger.kernel.org
References: <200702091809.l19I9MgS025574@cichlid.com>
In-Reply-To: <200702091809.l19I9MgS025574@cichlid.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_EXNzF5okoHiL0Dh"
Message-Id: <200702100712.52819.kernel@kolivas.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_EXNzF5okoHiL0Dh
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Saturday 10 February 2007 05:09, Andrew Burgess wrote:
> >I'm stuck developing code I'm having trouble proving it helps. Normal
> > users find it helps and an artificial testcase shows it helps, but that
> > is not enough, since the normal users will be tainted in their opinion,
> > and the artificial testcase will always be artificial. My mistake of
> > developing novel code in areas that were unquantifiable has been my
> > undoing.
>
> Could you add some statistics gathering to measure
> cumulatively how long processes wait for swapin?  Then you
> could run with and without and maybe say "on average my
> system waits 4 minutes a day without swap prefetch and 2
> minutes with? Or if a simple sum doesn't work, some sort of
> graph? Then anyone could run and measure the benefit.
>
> Apologies if you've already thought of this...

It would depend entirely on the workload / how you use your machine and the 
balance of ram size vs hard drive speed vs swap size. The simple test app I 
used attached below used on a 1GB machine with a fairly modern hard drive 
saved:

Without:
Timed portion 6272175 microseconds
With:
Timed portion 523623 microseconds

This was with 700MB of what would be considered "application data". So if you 
had lots of firefox windows open, openoffice, email client etc open and then 
did something which caused a big swap load (I have this effect when printing 
an full page colour picture at high resolution), then the total time saved 
over clicking those applications back to life after some idle time (so you 
printed and walked away while it was printing) was about 5.5 seconds. 

So the total saved time over a day would depend on how often you hit swap, and 
how often you clicked things back to life. Of course if you never hit swap 
the code does basically nothing.


Note this app is a silly little thing that only worked on 32bit if I recall 
correctly but here it is.

build with 
gcc -o mallocall mallocall.c -W -Wall -lrt

then test without swap prefetch enabled, and then enable it and test again.

-- 
-ck

--Boundary-00=_EXNzF5okoHiL0Dh
Content-Type: text/x-csrc;
  charset="utf-8";
  name="mallocall.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
	filename="mallocall.c"

#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>
#include <time.h>

void fatal(const char *format, ...)
{
	va_list ap;

	if (format) {
		va_start(ap, format);
		vfprintf(stderr, format, ap);
		va_end(ap);
	}

	fprintf(stderr, "Fatal error - exiting\n");
	exit(1);
}

size_t get_ram(void)
{
        unsigned long ramsize;
	FILE *meminfo;
        char aux[256];

	if(!(meminfo = fopen("/proc/meminfo", "r")))
		fatal("fopen\n");

	while( !feof(meminfo) && !fscanf(meminfo, "MemTotal: %lu kB", &ramsize) )
		fgets(aux,sizeof(aux),meminfo);
	if (fclose(meminfo) == -1)
		fatal("fclose");
	return ramsize * 1000;
}

unsigned long get_usecs(struct timespec *myts)
{
	if (clock_gettime(CLOCK_REALTIME, myts))
		fatal("clock_gettime");
	return (myts->tv_sec * 1000000 + myts->tv_nsec / 1000 );
}

int main(void)
{
	unsigned long current_time, time_diff;
	struct timespec myts;
	char *buf1, *buf2, *buf3, *buf4;
	size_t size, full_size = get_ram();
	int sleep_seconds = 600;

	size = full_size * 7 / 10;
	printf("Starting first malloc of %d bytes\n", size);
	buf1 = malloc(size);
	if (buf1 == (char *)-1)
		fatal("Failed to malloc 1st buffer\n");
	memset(buf1, 0, size);
	printf("Completed first malloc and starting second malloc of %d bytes\n", full_size);

	buf2 = malloc(full_size);
	if (buf2 == (char *)-1)
		fatal("Failed to malloc 2nd buffer\n");
	memset(buf2, 0, full_size);
	buf4 = malloc(1);
	for (buf3 = buf2 + full_size; buf3 > buf2; buf3--)
		*buf4 = *buf3;
	free(buf2);
	printf("Completed second malloc and free\n");

	printf("Sleeping for %d seconds\n", sleep_seconds);
	sleep(sleep_seconds);

	printf("Important part - starting read of first malloc\n");
	time_diff = current_time = get_usecs(&myts);
	for (buf3 = buf1; buf3 < buf1 + size; buf3++)
		*buf4 = *buf3;
	current_time = get_usecs(&myts);
	free(buf4);
	free(buf1);
	printf("Completed read and freeing of first malloc\n");
	time_diff = current_time - time_diff;
	printf("Timed portion %lu microseconds\n",time_diff);

	return 0;
}

--Boundary-00=_EXNzF5okoHiL0Dh--
