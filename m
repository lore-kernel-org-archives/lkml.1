Return-Path: <linux-kernel-owner+w=401wt.eu-S1753642AbZKDAaF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753642AbZKDAaF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 19:30:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbZKDAaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 19:30:05 -0500
Received: from mail.bluehost.com ([74.220.195.75]:40775 "HELO
	mail.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751800AbZKDAaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 19:30:04 -0500
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Nov 2009 19:30:04 EST
Message-ID: <4AF0C97F.7000603@bluehost.com>
Date: Tue, 03 Nov 2009 17:23:27 -0700
From: Spencer Candland <spencer@bluehost.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: utime/stime decreasing on thread exit
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am seeing a problem with utime/stime decreasing on thread exit in a
multi-threaded process.  I have been able to track this regression down
to the "process wide cpu clocks/timers" changes introduces in
2.6.29-rc5, specifically when I revert the following commits I know
longer see decreasing utime/stime values:

4da94d49b2ecb0a26e716a8811c3ecc542c2a65d
3fccfd67df79c6351a156eb25a7a514e5f39c4d9
7d8e23df69820e6be42bcc41d441f4860e8c76f7
4cd4c1b40d40447fb5e7ba80746c6d7ba91d7a53
32bd671d6cbeda60dc73be77fa2b9037d9a9bfa0

I poked around a little, but I am afraid I have to admit that I am not
familiar enough with how this works to resolve this or suggest a fix.

I have verified this in happening in kernels 2.6.29-rc5 - 2.6.32-rc6, I
have been testing this on x86 vanilla kernels, but have also verified it
on several x86 2.6.29+ distro kernels (fedora and ubuntu).

I first noticed this on a production environment running Apache with the
worker MPM, however while tracking this down I put together a simple
program that has been reliable in showing me utime decreasing, hopefully
it will be helpful in demonstrating the issue:

#include <stdio.h>
#include <pthread.h>
#include <sys/times.h>

#define NUM_THREADS 500

struct tms start;
int oldutime;

void *pound (void *threadid)
{
  struct tms end;
  int utime;
  int c;
  for (c = 0; c < 10000000; c++);
  times(&end);
  utime = ((int)end.tms_utime - (int)start.tms_utime);
  if (oldutime > utime) {
    printf("utime decreased, was %d, now %d!\n", oldutime, utime);
  }
  oldutime = utime;
  pthread_exit(NULL);
}


int main()
{
  pthread_t th[NUM_THREADS];
  long i;
  times(&start);
  for (i = 0; i < NUM_THREADS; i++) {
    pthread_create (&th[i], NULL, pound, (void *)i);
  }
  pthread_exit(NULL);
  return 0;
}

Output:

# ./decrease_utime
utime decreased, was 1288, now 1287!
utime decreased, was 1294, now 1293!
utime decreased, was 1296, now 1295!
utime decreased, was 1297, now 1296!
utime decreased, was 1298, now 1297!
utime decreased, was 1299, now 1298!

Please let me know if you need any additional information.

Thank you,
Spencer Candland
