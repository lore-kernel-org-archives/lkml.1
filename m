Return-Path: <linux-kernel-owner+w=401wt.eu-S1755540AbXH0N1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbXH0N1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 09:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752278AbXH0N1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 09:27:06 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:57436 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752AbXH0N1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 09:27:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=InqMIvmCTEKJGYQ6iPaq7+8uTZGu+WWroaF20XfDAZ+NqdhKGooAIdilAKrkH0243C+nM0qvdw9K6mah7K0tk94XuuTAI4s2a9emZMwKMxPpz38SVmXo/xDqqJfrVqu36zXvu0EUsL/kdoyP7zsY68Qnx7N3ZpkilBKOTuOadEw=
From: Denys Vlasenko <vda.linux@googlemail.com>
To: Fengguang Wu <wfg@mail.ustc.edu.cn>
Subject: Re: How to find out how many other processes share VM with $PID?
Date: Mon, 27 Aug 2007 14:26:50 +0100
User-Agent: KMail/1.9.1
Cc: linux-kernel@vger.kernel.org
References: <200708271256.31874.vda.linux@googlemail.com> <388216835.20155@ustc.edu.cn>
In-Reply-To: <388216835.20155@ustc.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708271426.50675.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 27 August 2007 13:13, Fengguang Wu wrote:
> Hi Denys,
>
> On Mon, Aug 27, 2007 at 12:56:31PM +0100, Denys Vlasenko wrote:
> > Hi,
> >
> > I was a bit frustrated by bad quality of memory usage info
> > from top and ps, and decided to write my own utility.
> >
> > One problem I don't know how to solve is how to avoid counting
> > twice (or more) memory used by processes which share VM
> > (by use of CLONE_VM flage to sys_clone).
> >
> > I know how to detect and correctly account for threads
> > (processes created with CLONE_THREAD), but how to detect non-threads
> > with shared VM?
>
> There is a nice LWN article on this issue:
>         ELC: How much memory are applications really using?
>         http://lwn.net/Articles/230975/
>
> Another helpful patch could be:
>         maps: PSS(proportional set size) accounting in smaps
>         http://lkml.org/lkml/2007/8/19/23

Thanks a lot, very useful pages indeed.

However they still don't explain how I can avoid counting memory
twice for /proc/PID1 and /proc/PID2 when PID2 is a child of PID1,
created with CLONE_VM.

The example: I allocate 1234k, dirty it, then clone with CLONE_VM.
I will seemingly have two processes, each using 1234k, _privately_
(i.e., pages are not shown as shared in smaps) -
which is technically correct, pages are not shared with other VMs,
but they ARE shared by means of these two processes having the same VM!

How userspace tools can figure out that these processes have shared VM?

IOW: do we need "VMsharecount: N" in addition to "Threads: N"
in /proc/PID/status?


$ gcc clonetest.c
$ ./a.out
parent 21143 (21143)
clone returned 21144
child 21144 (21144)
<sleeps 1000 seconds>

On another console:

$ cp /proc/21143/smaps /tmp/1
$ cp /proc/21144/smaps /tmp/2
$ diff -u /tmp/1 /tmp/2  <============ smaps are the same!
$ ls -l /tmp/1 /tmp/2
-r--r--r-- 1 vda eng 2869 Aug 27 14:17 /tmp/1
-r--r--r-- 1 vda eng 2869 Aug 27 14:17 /tmp/2

This is the 1234k of memset'ed malloc in /proc/*/smaps:

f7eae000-f7fe4000 rw-p f7eae000 00:00 0
Size:              1240 kB
Rss:               1240 kB
Shared_Clean:         0 kB
Shared_Dirty:         0 kB
Private_Clean:        0 kB
Private_Dirty:     1240 kB

See? Any memory tool will conclude that 21143 is using 1240k here and 21144
uses another 1240k. But it's the same 1240k!

clonetest.c
===========
#include <sched.h>
#include <sys/types.h>
#include <linux/unistd.h>
#include <errno.h>
#include <syscall.h>

// Run this proggie, cd into /proc and explore there
// while it runs, erm, sleeps.

/* Defeat glibc "pid caching" */
#define GETPID() ((int)syscall(SYS_getpid))
#define GETTID() ((int)syscall(SYS_gettid))

char stack[8*1024];

int f(void *arg)
{
        printf("child %d (%d)\n", GETPID(),  GETTID());
        sleep(1000);
        _exit(0);
}

int main()
{
        int n;
        memset(malloc(1234*1024), 1, 1234*1024);
        printf("parent %d (%d)\n", GETPID(), GETTID());
        // Create thread
        // Create a process with shared VM, but not a thread
        n = clone(f, stack + sizeof(stack)/2, CLONE_VM, 0);
        printf("clone returned %d\n", n);
        sleep(1000);
        _exit(0);
}


--
vda
