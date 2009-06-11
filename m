Return-Path: <linux-kernel-owner+w=401wt.eu-S1760370AbZFKIdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760370AbZFKIdV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 04:33:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755791AbZFKIdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 04:33:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:51501 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754500AbZFKIdJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 04:33:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,201,1243839600"; 
   d="c'?scan'208";a="420781504"
Subject: Re: Bug: fio traps into kernel without exiting because futex has a
	deadloop
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhltc@us.ibm.com>, Rusty Russell <rusty@rustcorp.com.au>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1244701128.6691.5.camel@laptop>
References: <1244689688.2560.268.camel@ymzhang>
	 <1244699756.6691.4.camel@laptop>  <1244701128.6691.5.camel@laptop>
Content-Type: multipart/mixed; boundary="=-ua7M3esfpWTJ1MpnUhOY"
Date: Thu, 11 Jun 2009 16:33:16 +0800
Message-Id: <1244709196.2560.287.camel@ymzhang>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ua7M3esfpWTJ1MpnUhOY
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Thu, 2009-06-11 at 08:18 +0200, Peter Zijlstra wrote:
> On Thu, 2009-06-11 at 07:55 +0200, Peter Zijlstra wrote:
> > On Thu, 2009-06-11 at 11:08 +0800, Zhang, Yanmin wrote:
> > > I investigate a fio hang issue. When I run fio multi-process
> > > testing on many disks, fio traps into kernel and doesn't exit
> > > (mostly hit once after runing sub test cases for ﻿hundreds of times).
> > > 
> > > Oprofile data shows kernel consumes time with some futex functions.
> > > Command kill couldn't kill the process and machine reboot also hangs.
> > > 
> > > Eventually, I locate the root cause as a bug of futex. Kernel enters
> > > a deadloop between 'retry' and 'goto retry' in function futex_wake_op.
> > > By unknown reason (might be an issue of fio or glibc), parameter uaddr2
> > > points to an area which is READONLY. So futex_atomic_op_inuser returns
> > > -EFAULT when trying to changing the data at uaddr2, but later get_user
> > > still succeeds becasue the area is READONLY. Then go back to retry.
> > > 
> > > I create a simple test case to trigger it, which just shmat an READONLY
> > > area for address uaddr2.
> > > 
> > > It could be used as a DOS attack.
> 
> /me has morning juice and notices he sent the wrong commit...
> 
> commit 64d1304a64477629cb16b75491a77bafe6f86963
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon May 18 21:20:10 2009 +0200
2.6.30 includes the new commit. I did a quick testing with my simple
test case and it traps into kernel without exiting.

The reason is I use flag FUTEX_PRIVATE_FLAG. So the fshared part in function
get_futex_key should be deleted. That might hurt performance.

Yanmin


--=-ua7M3esfpWTJ1MpnUhOY
Content-Disposition: attachment; filename=my_futex.c
Content-Type: text/x-csrc; name=my_futex.c; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

#include <stdio.h>
#include <stdlib.h>
#include <linux/futex.h>
#include <sys/time.h>
#define _GNU_SOURCE        /* or _BSD_SOURCE or _SVID_SOURCE */
#include <unistd.h>
#include <sys/syscall.h>   /* For SYS_xxx definitions */
#include <sys/types.h>
#include <sys/shm.h>
#include <sys/types.h>
#include <sys/mman.h>
#include <errno.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/wait.h>
#include <sys/utsname.h>


#define PAGE_SIZE	(4096)
int addr1=1;


int my_shmget(key_t key, int page_count, int *shmid, void **shmaddr)
{
	int     i, j, k;
	void    *start_addr = NULL;

	if ((*shmid =shmget(key, PAGE_SIZE*page_count, IPC_CREAT|0666 )) < 0) {
		perror("Failure:");
		return -1;
	}

	*shmaddr = shmat(*shmid, start_addr, SHM_RDONLY) ;
	if (*shmaddr == (void *) -1) {
		perror("shmget:Shared Memory Attach Failure:");
		shmctl(*shmid, IPC_RMID, NULL);
		return -1;
	}

	return 0;
}

int my_shmput(int shmid, void *shmaddr)
{
	if (shmdt((const void *)shmaddr) != 0) {
		perror("Detached Failure:");
		return -1;
	}
	if(shmctl(shmid, IPC_RMID, NULL) != 0) {
		perror("Remove shm id of htlb page failure!\n");
		return -1;
	}

	return 0;
}

int main()
{
	int * uaddr = &addr1, *uaddr2;
	void * lp;
	int ret;
	int shmid;
	void *shmaddr;

	if(my_shmget(10673861, 10, &shmid, &shmaddr))
		exit(0);

	uaddr2 = shmaddr;

	//uaddr2 = 0;

	ret = syscall(__NR_futex, uaddr, FUTEX_WAKE_OP|FUTEX_PRIVATE_FLAG, 1, NULL, uaddr2, 1);

	printf("ret=%d\n", ret);

	my_shmput(shmid, shmaddr);

	return 0;
}


--=-ua7M3esfpWTJ1MpnUhOY--

