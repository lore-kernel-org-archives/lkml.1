Return-Path: <linux-kernel-owner+w=401wt.eu-S1753228AbZKDGt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753228AbZKDGt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:49:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752696AbZKDGt4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:49:56 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57362 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623AbZKDGtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:49:55 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4AF123F5.50407@jp.fujitsu.com>
Date: Wed, 04 Nov 2009 15:49:25 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Spencer Candland <spencer@bluehost.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: utime/stime decreasing on thread exit
References: <4AF0C97F.7000603@bluehost.com>
In-Reply-To: <4AF0C97F.7000603@bluehost.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Spencer Candland wrote:
> I am seeing a problem with utime/stime decreasing on thread exit in a
> multi-threaded process.  I have been able to track this regression down
> to the "process wide cpu clocks/timers" changes introduces in
> 2.6.29-rc5, specifically when I revert the following commits I know
> longer see decreasing utime/stime values:
> 
> 4da94d49b2ecb0a26e716a8811c3ecc542c2a65d
> 3fccfd67df79c6351a156eb25a7a514e5f39c4d9
> 7d8e23df69820e6be42bcc41d441f4860e8c76f7
> 4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
> 32bd671d6cbeda60dc73be77fa2b9037d9a9bfa0
> 
> I poked around a little, but I am afraid I have to admit that I am not
> familiar enough with how this works to resolve this or suggest a fix.
> 
> I have verified this in happening in kernels 2.6.29-rc5 - 2.6.32-rc6, I
> have been testing this on x86 vanilla kernels, but have also verified it
> on several x86 2.6.29+ distro kernels (fedora and ubuntu).
> 
> I first noticed this on a production environment running Apache with the
> worker MPM, however while tracking this down I put together a simple
> program that has been reliable in showing me utime decreasing, hopefully
> it will be helpful in demonstrating the issue:
> 
> #include <stdio.h>
> #include <pthread.h>
> #include <sys/times.h>
> 
> #define NUM_THREADS 500
> 
> struct tms start;
> int oldutime;
> 
> void *pound (void *threadid)
> {
>   struct tms end;
>   int utime;
>   int c;
>   for (c = 0; c < 10000000; c++);
>   times(&end);
>   utime = ((int)end.tms_utime - (int)start.tms_utime);
>   if (oldutime > utime) {
>     printf("utime decreased, was %d, now %d!\n", oldutime, utime);
>   }
>   oldutime = utime;
>   pthread_exit(NULL);
> }
> 
> 
> int main()
> {
>   pthread_t th[NUM_THREADS];
>   long i;
>   times(&start);
>   for (i = 0; i < NUM_THREADS; i++) {
>     pthread_create (&th[i], NULL, pound, (void *)i);
>   }
>   pthread_exit(NULL);
>   return 0;
> }

This test program doesn't show the problem correctly, because the
oldutime can be modified by any of threads running simultaneously.

Thread 1:		Thread 2:

>   times(&end);

			>   times(&end);
			>   utime = ((int)end.tms_utime - (int)start.tms_utime);
			>   if (oldutime > utime) {
			>     printf("utime decreased, was %d, now %d!\n", oldutime, utime);
			>   }
			>   oldutime = utime;

>   utime = ((int)end.tms_utime - (int)start.tms_utime);
>   if (oldutime > utime) {
>     printf("utime decreased, was %d, now %d!\n", oldutime, utime);
>   }
>   oldutime = utime;

So I thought it is not a bug, but....

> 
> Output:
> 
> # ./decrease_utime
> utime decreased, was 1288, now 1287!
> utime decreased, was 1294, now 1293!
> utime decreased, was 1296, now 1295!
> utime decreased, was 1297, now 1296!
> utime decreased, was 1298, now 1297!
> utime decreased, was 1299, now 1298!
> 
> Please let me know if you need any additional information.
> 
> Thank you,
> Spencer Candland

I revised the test program but still I can see the problem.
So I agree that something wrong is actually there.

[seto@localhost work]$ cat test.c
#include <stdio.h>
#include <pthread.h>
#include <sys/times.h>

#define NUM_THREADS 500

void *pound (void *threadid)
{
  struct tms t1, t2;
  int c;
  for (c = 0; c < 10000000; c++);
  times(&t1);
  times(&t2);
  if (t1.tms_utime > t2.tms_utime) {
    printf("utime decreased, was %d, now %d! : (%d %d %d %d) (%d %d %d %d)\n",
                t1.tms_utime, t2.tms_utime,
                t1.tms_stime, t1.tms_utime, t1.tms_cstime, t1.tms_cutime,
                t2.tms_stime, t2.tms_utime, t2.tms_cstime, t2.tms_cutime);
  }
  pthread_exit(NULL);
}


int main()
{
  pthread_t th[NUM_THREADS];
  long i;
  for (i = 0; i < NUM_THREADS; i++) {
    pthread_create (&th[i], NULL, pound, (void *)i);
  }
  pthread_exit(NULL);
  return 0;
}

[seto@localhost work]$ ./a.out
utime decreased, was 1066, now 1063! : (102 1066 0 0) (102 1063 0 0)
utime decreased, was 1101, now 1099! : (114 1101 0 0) (114 1099 0 0)
utime decreased, was 1095, now 1093! : (146 1095 0 0) (146 1093 0 0)
utime decreased, was 1089, now 1086! : (166 1089 0 0) (166 1086 0 0)
utime decreased, was 1071, now 1069! : (212 1071 0 0) (212 1069 0 0)
utime decreased, was 1057, now 1054! : (274 1057 0 0) (274 1054 0 0)
utime decreased, was 1054, now 1049! : (79 1054 0 0) (303 1049 0 0)
utime decreased, was 1050, now 1048! : (313 1050 0 0) (313 1048 0 0)
utime decreased, was 1049, now 1046! : (319 1049 0 0) (319 1046 0 0)
utime decreased, was 1058, now 1038! : (83 1058 0 0) (369 1038 0 0)
utime decreased, was 1038, now 1036! : (378 1038 0 0) (378 1036 0 0)
utime decreased, was 1037, now 1035! : (384 1037 0 0) (384 1035 0 0)
utime decreased, was 1035, now 1034! : (385 1035 0 0) (386 1034 0 0)
utime decreased, was 1037, now 1035! : (385 1037 0 0) (385 1035 0 0)
utime decreased, was 1035, now 1032! : (389 1035 0 0) (390 1032 0 0)
utime decreased, was 1030, now 1028! : (402 1030 0 0) (402 1028 0 0)
utime decreased, was 1029, now 1026! : (405 1029 0 0) (405 1026 0 0)
utime decreased, was 1025, now 1024! : (409 1025 0 0) (410 1024 0 0)
utime decreased, was 1023, now 1021! : (420 1023 0 0) (420 1021 0 0)
utime decreased, was 1022, now 1020! : (423 1022 0 0) (423 1020 0 0)
utime decreased, was 1037, now 1017! : (372 1037 0 0) (432 1017 0 0)
utime decreased, was 1019, now 1017! : (431 1019 0 0) (432 1017 0 0)
utime decreased, was 1053, now 1015! : (79 1053 0 0) (434 1015 0 0)
utime decreased, was 1013, now 1011! : (446 1013 0 0) (446 1011 0 0)
utime decreased, was 1013, now 1010! : (448 1013 0 0) (448 1010 0 0)
utime decreased, was 1053, now 1009! : (79 1053 0 0) (451 1009 0 0)
[seto@localhost work]$ taskset 0x1 ./a.out
utime decreased, was 1025, now 1021! : (59 1025 0 0) (417 1021 0 0)
utime decreased, was 1023, now 1021! : (59 1023 0 0) (419 1021 0 0)
utime decreased, was 1027, now 1020! : (60 1027 0 0) (420 1020 0 0)
utime decreased, was 1068, now 1000! : (173 1068 0 0) (500 1000 0 0)


I'll check commits you pointed/reverted.


Thanks,
H.Seto

