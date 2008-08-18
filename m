Return-Path: <linux-kernel-owner+w=401wt.eu-S1757424AbYHRSp1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757424AbYHRSp1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:45:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbYHRSpM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:45:12 -0400
Received: from ns.suse.de ([195.135.220.2]:40937 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755449AbYHRSpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:45:10 -0400
Date: Mon, 18 Aug 2008 11:41:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, jejb@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [patch 01/60] mlock() fix return values
Message-ID: <20080818184107.GB29394@suse.de>
References: <20080818183230.966310219@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="mlock-fix-return-values.patch"
In-Reply-To: <20080818184035.GA29394@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.26-stable review patch.  If anyone has any objections, please let us know.

------------------
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

commit a477097d9c37c1cf289c7f0257dffcfa42d50197 upstream

Halesh says:

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

This testcase results in an mlock() failure with errno 14 that is EFAULT,
but it has nowhere been specified that mlock() will return EFAULT.  When I
tested the same on older kernels like 2.6.18, I got the correct result i.e
errno 12 (ENOMEM).

I think in source code mlock(2), setting errno ENOMEM has been missed in
do_mlock() , on mlock_fixup() failure.

SUSv3 requires the following behavior frmo mlock(2).

[ENOMEM]
    Some or all of the address range specified by the addr and
    len arguments does not correspond to valid mapped pages
    in the address space of the process.

[EAGAIN]
    Some or all of the memory identified by the operation could not
    be locked when the call was made.

This rule isn't so nice and slighly strange.  but many people think
POSIX/SUS compliance is important.

Reported-by: Halesh Sadashiv <halesh.sadashiv@ap.sony.com>
Tested-by: Halesh Sadashiv <halesh.sadashiv@ap.sony.com>
Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/memory.c |   16 +++++++++++++---
 mm/mlock.c  |    2 --
 2 files changed, 13 insertions(+), 5 deletions(-)

--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2748,16 +2748,26 @@ int make_pages_present(unsigned long add
 
 	vma = find_vma(current->mm, addr);
 	if (!vma)
-		return -1;
+		return -ENOMEM;
 	write = (vma->vm_flags & VM_WRITE) != 0;
 	BUG_ON(addr >= end);
 	BUG_ON(end > vma->vm_end);
 	len = DIV_ROUND_UP(end, PAGE_SIZE) - addr/PAGE_SIZE;
 	ret = get_user_pages(current, current->mm, addr,
 			len, write, 0, NULL, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		/*
+		   SUS require strange return value to mlock
+		    - invalid addr generate to ENOMEM.
+		    - out of memory should generate EAGAIN.
+		*/
+		if (ret == -EFAULT)
+			ret = -ENOMEM;
+		else if (ret == -ENOMEM)
+			ret = -EAGAIN;
 		return ret;
-	return ret == len ? 0 : -1;
+	}
+	return ret == len ? 0 : -ENOMEM;
 }
 
 #if !defined(__HAVE_ARCH_GATE_AREA)
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -78,8 +78,6 @@ success:
 
 	mm->locked_vm -= pages;
 out:
-	if (ret == -ENOMEM)
-		ret = -EAGAIN;
 	return ret;
 }
 

-- 
