Return-Path: <linux-kernel-owner+w=401wt.eu-S1754089AbXDMQwU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089AbXDMQwU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 12:52:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbXDMQwU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 12:52:20 -0400
Received: from mail.darkstartechnologies.net ([83.142.224.43]:51847 "EHLO
	mail.dst-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754089AbXDMQwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 12:52:20 -0400
From: Witold Krecicki <wpk@dst-labs.com>
Organization: SCMP
To: linux-kernel@vger.kernel.org
Subject: Oddness with reading /proc/net/tcp
Date: Fri, 13 Apr 2007 18:46:16 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704131846.16358.wpk@dst-labs.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Reading data from /proc/net/tcp is slower with progress of reading data, 
tested on system with >200k active connections.

Sample code:
#include <stdio.h>
#include <sys/time.h>
#include <unistd.h>

int main(int argc, char ** argv)
{
  struct timeval starttime, endtime;
  FILE * fd;
  char buf[1024*1024*4];
  int pk;
  fd=fopen("/proc/net/tcp","r");
  gettimeofday(&starttime,0);
  pk=0;
  while (!feof(fd) && pk<10000)
    {
      fread(buf, 1, 1024, fd);
      pk++;
      if (pk%512==0)
      {
        gettimeofday(&endtime,0);
        printf("%d %ld\n",pk, (endtime.tv_usec-starttime.tv_usec) 
+1000000*(endtime.tv_sec - starttime.tv_sec));
        gettimeofday(&starttime,0);
      }
    }
  fclose(fd);
  return 0;
}

Result:
$ time ./a.out
512 231781
1024 1057159
1536 1726530
2048 2474851
2560 3236269
3072 3856587
3584 3438862
4096 3108675
4608 3500559
5120 4090534
5632 4612594
6144 5135624
6656 5266945
7168 5491547
7680 6355916
8192 6661789
8704 7095428
9216 7565589
9728 7982981

real    1m27.347s
user    0m0.024s
sys     1m27.309s

