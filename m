Return-Path: <linux-kernel-owner+w=401wt.eu-S1758660AbXEUFl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758660AbXEUFl5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2007 01:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754964AbXEUFlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 May 2007 01:41:49 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:33815 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbXEUFlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2007 01:41:49 -0400
Date: Sun, 20 May 2007 22:46:04 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: "kernel coder" <lhrkernelcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: system call implementation for x86_64
Message-Id: <20070520224604.93506b6b.randy.dunlap@oracle.com>
In-Reply-To: <f69849430705190455m4d62835fx9aed5a17df69c805@mail.gmail.com>
References: <f69849430705190455m4d62835fx9aed5a17df69c805@mail.gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 May 2007 04:55:12 -0700 kernel coder wrote:

> hi,
> 
> I'm trying to implement a system call for x86_64. Mine processor is
> dual core opetron.There is very little material on web for
> implementing system calls for x86_64 processor for 2.6 series kernel.I
> tried to implement a new system call by observing the existing
> implementation but to no success.Following are files names and changes
> made.

Your example is very CPU-independent, i.e., not x86_64-specific,
so following examples of recently-added syscalls should be good enough.

I used your "patch" below (with a few small modifications) on
2.6.22-rc2 and it worked fine.

Linux unicorn 2.6.22-rc2 #2 SMP Sun May 20 22:22:36 PDT 2007 x86_64 x86_64 x86_64 GNU/Linux
...
[   98.369454] new system call


> //////////////////////////////////////////////////
> file-> include/asm-x86_64/unistd.h
> 
> #define __NR_newcall        273
> __SYSCALL(__NR_newcall, sys_newcall)
> 
> #define __NR_syscall_max __NR_newcall

syscall_max is no longer used.

> 
> //////////////////////////////////////////////////
> file-> include/linux/syscalls.h
> 
> asmlinkage unsigned long sys_newcall(char __user *buf);

not unsigned.

> 
> /////////////////////////////////////////////
> file--> fs/read_write.c
> 
> asmlinkage unsigned long sys_newcall(char __user * buf){

not unsigned.

> 
>      printk("new system call \n");
>      ret 0;

	return 0;

> }
> 
> EXPORT_SYMBOL_GPL(sys_write)

  EXPORT_SYMBOL_GPL(sys_newcall);

> Please let me know where i'm doing wrong .Following is program which
> is calling mine system call
> 
> 
> #include <stdlib.h>
> #include <stdio.h>
> #include <sys/unistd.h>

#include <unistd.h>

> #include <sys/syscall.h>
> 
>   long int ret;
>    int num = 243;
>   char  buffer=[20];

eh?  does not compile.

> 
> int main() {
> 
> 
>   asm ("syscall;"
>        : "=a" (ret)
>        : "0" (num),
>          "D" (buffer),
>       );

I just used the syscall() glibc interface instead of asm:

	ret = syscall(__NR_newcall);

>  return ret;
> }
> 
> When i call this ,nothing gets printed in file /var/log/messages.Am i
> missing something ?

Mostly typos...

> Actually i wana pass a pointer to kernel from user space.Later on data
> will be copied to that memory location .i am thinking of using
> copy_to_user for copying data.Buffer passed through system call will
> be used by kernel function as circular ring.And portions of this ring
> will get updated frequently even after system call has returned.
> 
> Is there any better way to do this?

Sounds mostly OK to me.
Where are the ring head, tail, size, etc. maintained?


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
