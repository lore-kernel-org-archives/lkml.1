Return-Path: <linux-kernel-owner+w=401wt.eu-S1756490AbYGaKUT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756490AbYGaKUT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 06:20:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbYGaKUH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 06:20:07 -0400
Received: from main.gmane.org ([80.91.229.2]:50877 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYGaKUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 06:20:05 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Halesh <halesh.s@india.com>
Subject: mlock() return value issue in kernel 2.6.23.17
Date: Thu, 31 Jul 2008 10:15:10 +0000 (UTC)
Message-ID: <loom.20080731T100441-892@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: main.gmane.org
User-Agent: Loom/3.14 (http://gmane.org/)
X-Loom-IP: 125.17.166.34 (Opera/9.50 (Windows NT 5.1; U; en))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi all,

Please find the below testcase provide to test mlock.

Test Case :
===========================

#include <sys/resource.h>
#include <stdio.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <errno.h>
#include <stdlib.h>

int main(void)
{
  int fd,ret, i = 0;
  char *addr, *addr1 = NULL;
  unsigned int page_size;
  struct rlimit rlim;

  if (0 != geteuid()) 
  {
   printf("Execute this pgm as root\n");
   exit(1);
  }

  /* create a file */
  if ((fd = open("mmap_test.c",O_RDWR|O_CREAT,0755)) == -1)
  {
   printf("cant create test file\n");
   exit(1);
  }

  page_size = sysconf(_SC_PAGE_SIZE);

  /* set the MEMLOCK limit */
  rlim.rlim_cur = 2000;
  rlim.rlim_max = 2000;

  if ((ret = setrlimit(RLIMIT_MEMLOCK,&rlim)) != 0)
  {
   printf("Cant change limit values\n");
   exit(1);
  }

  addr = 0;
  while (1)
  {
  /* map a page into memory each time*/ 
  if ((addr = (char *) mmap(addr,page_size, PROT_READ |     
PROT_WRITE,MAP_SHARED,fd,0)) == MAP_FAILED) 
  {
   printf("cant do mmap on file\n");
   exit(1);
  }

  if (0 == i)
    addr1 = addr;
  i++;
  errno = 0;	
  /* lock the mapped memory pagewise*/
  if ((ret = mlock((char *)addr, 1500)) == -1) 
  {
   printf("errno value is %d\n", errno);
   printf("cant lock maped region\n");
   exit(1);
  }
  addr = addr + page_size;
 }
}
======================================================


This testcase results with mlock failure with errno 14 that is EFAULT, but this 
has been no where reported that mlock will give EFAULT, When i tested the same 
on older kernel like 2.6.18, I got the correct result i.e errno 12 (ENOMEM).


I think in source code mlock(2),  setting errno ENOMEM has been missed in 
do_mlock() , on mlock_fixup() failure.

Let me know if my understanding is wrong!

Thanks,
Halesh


