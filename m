Return-Path: <linux-kernel-owner+w=401wt.eu-S1757095AbZBSJae@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095AbZBSJae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 04:30:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZBSJaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 04:30:21 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64800 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753993AbZBSJaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 04:30:18 -0500
Message-ID: <499D2654.4060903@cn.fujitsu.com>
Date: Thu, 19 Feb 2009 17:28:52 +0800
From: Shan Wei <shanwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>, jmoyer@redhat.com
CC: linux-kernel@vger.kernel.org
Subject: Re: CFQ is worse than other IO schedulers in some cases
References: <499BA413.2010705@cn.fujitsu.com> <20090218113704.GW30821@kernel.dk>
In-Reply-To: <20090218113704.GW30821@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe said:
> On Wed, Feb 18 2009, Shan Wei wrote:
>> I found that CFQ's performance is worse than other IO scheduer in some cases
>> I confirmed its phenomenon when I executed dump command and sysbench on 2.6.28.
>>
>>
>> In dump(version:dump-0.4b41-2.fc6), I confirmed 
>> the speed under CFQ is slower than other IO schedulers.
>>
>>
>> The Test Result(dump):
>>    UNIT:Mb/sec
>>     _______________________
>>     |   IO       |        | 
>>     | scheduler  |  Speed |
>>     +------------|--------|
>>     |cfq         | 24.310 |  
>>     |noop        | 36.885 |  
>>     |anticipatory| 34.956 |  
>>     |deadline    | 36.758 |  
>>     +----------------------
>>
>>
>> Steps to reproduce(dump):
>>   #dump -0uf /dev/null /dev/sda6
> 
> The dump issue is a known one, it has to do with how dump uses seperate
> processes to interleave IO to the 'same' location. Jeff Moyer posted a
> fix for that some time ago, you can also find references to the
> discussion and progress right here on lkml. For reference, patch is
> included.
> 

Thanks for your reply.

The Jeff's patch can solve this problem.
And cfq & anticipatory perform well than before.

On 2.6.29-rc5, the test result:
     _______________________
     |   IO       |        | 
     | scheduler  |  Speed |
     +------------|--------|
     |cfq         | 37.055 |  
     |noop        | 36.522 |  
     |anticipatory| 37.236 |  
     |deadline    | 36.522 |  
     +----------------------

The device to be dumped is sda9.
[root@RHEL ~]# df /dev/sda9 -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/sda9              32G   15G   16G  50% /share


>> In sysbench(version:sysbench-0.4.10), I confirmed followings.
>>   - CFQ's performance is worse than other IO schedulers when only multiple
>>     threads test.
>>     (There is no difference under single thread test.)
>>   - It is worse than other IO scheduler when
>>     I used read mode. (No regression in write mode).
>>   - There is no difference among other IO schedulers. (e.g noop deadline)
>>
>>
>> The Test Result(sysbench):
>>    UNIT:Mb/sec
>>     __________________________________________________
>>     |   IO       |      thread  number               |  
>>     | scheduler  |-----------------------------------|
>>     |            |  1   |  3    |  5   |   7  |   9  |
>>     +------------|------|-------|------|------|------|
>>     |cfq         | 77.8 |  32.4 | 43.3 | 55.8 | 58.5 | 
>>     |noop        | 78.2 |  79.0 | 78.2 | 77.2 | 77.0 |
>>     |anticipatory| 78.2 |  78.6 | 78.4 | 77.8 | 78.1 |
>>     |deadline    | 76.9 |  78.4 | 77.0 | 78.4 | 77.9 |
>>     +------------------------------------------------+
> 
> What kind of storage hardware did you use?
> 

The hard disk type is SAS. 

[root@NUT io-test]# lspci -nn
00:1f.2 IDE interface [0101]: Intel Corporation 631xESB/632xESB/3100 Chipset SATA IDE Controller [8086:2680] (rev 09)
03:00.0 SCSI storage controller [0100]: LSI Logic / Symbios Logic SAS1064ET PCI-Express Fusion-MPT SAS [1000:0056] (rev 04)


> ------
> 
> Hi,
> 
> dump performs poorly when run under the CFQ I/O scheduler.  The reason
> for this is that the dump command interleaves I/O between two (or
> three?) cooperating processes.  This is about the worst case scenario
> you can get for CFQ, as the I/O access pattern within each process is
> sequential.  Thus, CFQ will idle for a number of milliseconds waiting
> for the current process to issue more I/O before switching to the next.
> 
> Now, this behaviour can be changed with tuning.  However, if the dump
> command simply shared I/O contexts between cooperating processes, CFQ
> could make more intelligent decisions about I/O scheduling.
> 
> So, here are the numbers, running under 2.6.28-rc3.
> 
> deadline    82241 kB/s
> cfq	    34143 kB/s
> cfq-shared  82241 kB/s
> 
> cfq-shared denotes that the dump utility was patched with the attached
> patch to share I/O contexts.  As you can see, with a very little bit of
> code change, we can drastically increase the performance of dump under
> CFQ (which is the default I/O scheduler used in a number of
> distributions).
> 
> For more information on the underlying problems, you can refer to the
> following kernel discussion:
>   http://lkml.org/lkml/2008/11/9/133
> 
> Comments are appreciated.
> 

To Jeff:

 The patch can be used on Fedora10. But, on fedora8, the CLONE_IO is not 
included in the sched.h. So compile fail.

#make
/usr/local/etc/dumpdates\" -D_DUMP_VERSION=\"0.4b41\"     tape.c -o tape.o
tape.c: In function ‘fork_clone_io’:
tape.c:797: error: ‘CLONE_IO’ undeclared (first use in this function)
tape.c:797: error: (Each undeclared identifier is reported only once
tape.c:797: error: for each function it appears in.)
make[1]: *** [tape.o] Error 1

> Cheers,
> 
> Jeff
> 
> diff -up ./dump/tape.c.orig ./dump/tape.c
> --- ./dump/tape.c.orig	2005-08-20 17:00:48.000000000 -0400
> +++ ./dump/tape.c	2008-11-17 16:40:42.575792509 -0500
> @@ -187,6 +187,40 @@ static sigjmp_buf jmpbuf;	/* where to ju
>  static int gtperr = 0;
>  #endif
>  
> +/*
> + * Determine if we can use Linux' clone system call.  If so, call it
> + * with the CLONE_IO flag so that all processes will share the same I/O
> + * context, allowing the I/O schedulers to make better scheduling decisions.
> + */
> +#ifdef __linux__
> +#include <syscall.h>
> +
> +#ifndef SYS_clone
> +#define fork_clone_io fork
> +#else /* SYS_clone */
> +#include <linux/version.h>
> + 
> +/*
> + * Kernel 2.5.49 introduced two extra parameters to the clone system call.
> + * Neither is useful in our case, so this is easy to handle.
> + */
> +#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,49)
> +/* clone_flags, child_stack, parent_tidptr, child_tidptr */
> +#define CLONE_ARGS SIGCHLD|CLONE_IO, 0, NULL, NULL
> +#else
> +#define CLONE_ARGS SIGCHLD|CLONE_IO, 0
> +#endif /* LINUX_VERSION_CODE */
> +
> +#define _GNU_SOURCE[root@NUT
> +#include <sched.h>
> +#include <unistd.h>
> +#undef _GNU_SOURCE
> +pid_t fork_clone_io(void);
> +#endif /* SYS_clone */
> +#else /* __linux__ not defined */
> +#define fork_clone_io fork
> +#endif /* __linux__ */
> +
>  int
>  alloctape(void)
>  {
> @@ -755,6 +789,16 @@ rollforward(void)
>  #endif
>  }
>  
> +#ifdef __linux__
> +#ifdef SYS_clone
> +pid_t
> +fork_clone_io(void)
> +{
> +	return syscall(SYS_clone, CLONE_ARGS);
> +}
> +#endif
> +#endif
> +
>  /*
>   * We implement taking and restoring checkpoints on the tape level.
>   * When each tape is opened, a new process is created by forking; this
> @@ -801,7 +845,7 @@ restore_check_point:
>  	/*
>  	 *	All signals are inherited...
>  	 */
> -	childpid = fork();
> +	childpid = fork_clone_io();
>  	if (childpid < 0) {
>  		msg("Context save fork fails in parent %d\n", parentpid);
>  		Exit(X_ABORT);
> @@ -1017,7 +1061,7 @@ enslave(void)
>  		}
>  
>  		if (socketpair(AF_UNIX, SOCK_STREAM, 0, cmd) < 0 ||
> -		    (slaves[i].pid = fork()) < 0)
> +		    (slaves[i].pid = fork_clone_io()) < 0)
>  			quit("too many slaves, %d (recompile smaller): %s\n",
>  			    i, strerror(errno));
>  
> 


