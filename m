Return-Path: <linux-kernel-owner+w=401wt.eu-S1755728AbZCGSKN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755728AbZCGSKN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Mar 2009 13:10:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755759AbZCGSJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Mar 2009 13:09:53 -0500
Received: from support.balabit.hu ([195.70.41.86]:38900 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755840AbZCGSJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Mar 2009 13:09:51 -0500
X-Greylist: delayed 1316 seconds by postgrey-1.27 at vger.kernel.org; Sat, 07 Mar 2009 13:09:51 EST
Subject: scheduler oddity [bug?]
From: Balazs Scheidler <bazsi@balabit.hu>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="=-c/AQgO0oYPKDMDhA3rhT"
Date: Sat, 07 Mar 2009 18:47:49 +0100
Message-Id: <1236448069.16726.21.camel@bzorp.balabit>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-c/AQgO0oYPKDMDhA3rhT
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,

I'm experiencing an odd behaviour from the Linux scheduler. I have an
application that feeds data to another process using a pipe. Both
processes use a fair amount of CPU time apart from writing to/reading
from this pipe.

The machine I'm running on  is an Opteron Quad-Core CPU:
model name	: Quad-Core AMD Opteron(tm) Processor 2347 HE
stepping	: 3

What I see is that only one of the cores is used, the other three is
idling without doing any work. If I explicitly set the CPU affinity of
the processes to use distinct CPUs the performance goes up
significantly. (e.g. it starts to use the other cores and the load
scales linearly).

I've tried to reproduce the problem by writing a small test program,
which you can find attached. The program creates two processes, one
feeds the other using a pipe and each does a series of memset() calls to
simulate CPU load. I've also added capability to the program to set its
own CPU affinity. The results (the more the better):

Without enabling CPU affinity:
$ ./a.out
Check: 0 loops/sec, sum: 1 
Check: 12 loops/sec, sum: 13 
Check: 41 loops/sec, sum: 54 
Check: 41 loops/sec, sum: 95 
Check: 41 loops/sec, sum: 136 
Check: 41 loops/sec, sum: 177 
Check: 41 loops/sec, sum: 218 
Check: 40 loops/sec, sum: 258 
Check: 41 loops/sec, sum: 299 
Check: 41 loops/sec, sum: 340 
Check: 41 loops/sec, sum: 381 
Check: 41 loops/sec, sum: 422 
Check: 41 loops/sec, sum: 463 
Check: 41 loops/sec, sum: 504 
Check: 41 loops/sec, sum: 545 
Check: 40 loops/sec, sum: 585 
Check: 41 loops/sec, sum: 626 
Check: 41 loops/sec, sum: 667 
Check: 41 loops/sec, sum: 708 
Check: 41 loops/sec, sum: 749 
Check: 41 loops/sec, sum: 790 
Check: 41 loops/sec, sum: 831 
Final: 39 loops/sec, sum: 831


With CPU affinity:
# ./a.out 1
Check: 0 loops/sec, sum: 1 
Check: 41 loops/sec, sum: 42 
Check: 49 loops/sec, sum: 91 
Check: 49 loops/sec, sum: 140 
Check: 49 loops/sec, sum: 189 
Check: 49 loops/sec, sum: 238 
Check: 49 loops/sec, sum: 287 
Check: 50 loops/sec, sum: 337 
Check: 49 loops/sec, sum: 386 
Check: 49 loops/sec, sum: 435 
Check: 49 loops/sec, sum: 484 
Check: 49 loops/sec, sum: 533 
Check: 49 loops/sec, sum: 582 
Check: 49 loops/sec, sum: 631 
Check: 49 loops/sec, sum: 680 
Check: 49 loops/sec, sum: 729 
Check: 49 loops/sec, sum: 778 
Check: 49 loops/sec, sum: 827 
Check: 49 loops/sec, sum: 876 
Check: 49 loops/sec, sum: 925 
Check: 50 loops/sec, sum: 975 
Check: 49 loops/sec, sum: 1024 
Final: 48 loops/sec, sum: 1024

The difference is about 20%, which is about the same work performed by
the slave process. If the two processes race for the same CPU this 20%
of performance is lost.

I've tested this on 3 computers and each showed the same symptoms:
 * quad core Opteron, running Ubuntu kernel 2.6.27-13.29
 * Core 2 Duo, running Ubuntu kernel 2.6.27-11.27
 * Dual Core Opteron, Debian backports.org kernel 2.6.26-13~bpo40+1

Is this a bug, or a feature?

-- 
Bazsi

--=-c/AQgO0oYPKDMDhA3rhT
Content-Disposition: attachment; filename="pipetest.c"
Content-Type: text/x-csrc; name="pipetest.c"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

/*
 * This is a test program to reproduce a scheduling oddity I have found.
 *
 * (c) Balazs Scheidler
 *
 * Pass any argument to the program to set the CPU affinity.
 */
#define _GNU_SOURCE

#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/time.h>
#include <time.h>
#include <sched.h>
              
/* diff in millisecs */
long
tv_diff(struct timeval *t1, struct timeval *t2)
{
  long long diff = (t2->tv_sec - t1->tv_sec) * 1e9 + (t2->tv_usec - t1->tv_usec);
  
  return diff /  1e6;
}

int 
reader(int fd)
{
  char buf[4096];
  int i;
  
  while (read(fd, buf, sizeof(buf)) > 0)
    {
      for (i = 0; i < 20000; i++)
        memset(buf, 'A'+i, sizeof(buf));
    }
  return 0;
}

int 
writer(int fd)
{
  char buf[4096];
  int i;
  int counter, prev_counter;
  struct timeval start, end, prev, now;
  long diff;
  
  memset(buf, 'A', sizeof(buf));
  
  counter = 0;
  prev_counter = 0;
  gettimeofday(&start, NULL);
  
  /* feed the other process with data while doing something that spins the CPU */
  while (write(fd, buf, sizeof(buf)) > 0)
    {
      for (i = 0; i < 100000; i++)
        memset(buf, 'A'+i, sizeof(buf));
        
      /* the rest of the loop is only to measure performance */
      counter++;
      gettimeofday(&now, NULL);
      if (now.tv_sec != prev.tv_sec)
        {
          diff = tv_diff(&prev, &now);
          printf("Check: %ld loops/sec, sum: %d \n", ((counter - prev_counter) * 1000) / diff, counter);
          prev_counter = counter;
        }
      if (now.tv_sec - start.tv_sec > 20)
        break;
      prev = now;
    }
  gettimeofday(&end, NULL);
  diff = tv_diff(&start, &end);
  printf("Final: %ld loops/sec, sum: %d\n", (counter*1000) / diff, counter);
  return 0;
}

int 
main(int argc, char *argv)
{
  int fds[2];
  cpu_set_t s;
  int set_affinity = 0;

  CPU_ZERO(&s);
  
  if (argc > 1)
    set_affinity = 1;
  
  pipe(fds);
  
  if (fork() == 0)
    {
      if (set_affinity)
        {
          CPU_SET(0, &s);
          sched_setaffinity(getpid(), sizeof(s), &s);
        }
      close(fds[1]);
      reader(fds[0]);
      return 0;
    }
  if (set_affinity)
    {
      CPU_SET(1, &s);
      sched_setaffinity(getpid(), sizeof(s), &s);
    }
  close(fds[0]);
  writer(fds[1]);
}

--=-c/AQgO0oYPKDMDhA3rhT--


