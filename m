Return-Path: <linux-kernel-owner+w=401wt.eu-S1755319AbZAFSuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319AbZAFSuj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 13:50:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753153AbZAFSuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 13:50:19 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:54984 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923AbZAFSuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 13:50:16 -0500
Message-ID: <4963A7D9.2030604@oracle.com>
Date: Tue, 06 Jan 2009 10:50:01 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Casey Dahlin <cdahlin@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2] waitfd
References: <49639EB8.40204@redhat.com> <4963A392.1060104@oracle.com> <4963A6D9.9080206@redhat.com>
In-Reply-To: <4963A6D9.9080206@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt703.oracle.com [141.146.40.81]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4963A7DF.0062:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin wrote:
> Randy Dunlap wrote:
>> Casey Dahlin wrote:
>>  
>>> Linux now exposes signals, timers, and events via file descriptors
>>> through signalfd, timerfd, and eventfd. This means programmers can use a
>>> single select/[e]poll call to monitor all change in their program. This
>>> patch aims to expose child death via the same mechanism.
>>>
>>> waitfd provides a file descriptor out of which may be read a series of
>>> siginfo_t objects describing child death. A child process is reaped as
>>> soon as its information is read. This means child monitoring too can be
>>> performed with that same poll call.
>>>
>>> Patch is against v2.6.28
>>>
>>> --CJD
>>>
>>> diff --git a/arch/x86/include/asm/unistd_32.h
>>> b/arch/x86/include/asm/unistd_32.h
>>> index f2bba78..134d83c 100644
>>> --- a/arch/x86/include/asm/unistd_32.h
>>> +++ b/arch/x86/include/asm/unistd_32.h
>>> @@ -338,6 +338,7 @@
>>> #define __NR_dup3        330
>>> #define __NR_pipe2        331
>>> #define __NR_inotify_init1    332
>>> +#define __NR_waitfd        333
>>>
>>> #ifdef __KERNEL__
>>>
>>> diff --git a/arch/x86/include/asm/unistd_64.h
>>> b/arch/x86/include/asm/unistd_64.h
>>> index d2e415e..b28eb07 100644
>>> --- a/arch/x86/include/asm/unistd_64.h
>>> +++ b/arch/x86/include/asm/unistd_64.h
>>> @@ -653,6 +653,8 @@ __SYSCALL(__NR_dup3, sys_dup3)
>>> __SYSCALL(__NR_pipe2, sys_pipe2)
>>> #define __NR_inotify_init1            294
>>> __SYSCALL(__NR_inotify_init1, sys_inotify_init1)
>>> +#define __NR_waitfd                295
>>> +__SYSCALL(__NR_waitfd, sys_waitfd)
>>>
>>>     
>>
>> Only for x86??
>>
>>   
> 
> At the moment. I should have mentioned this earlier but I haven't made
> the syscall table entries for archs I don't test on. That will change
> once the rest of the change has settled out.


>>> diff --git a/fs/waitfd.c b/fs/waitfd.c
>>> new file mode 100644
>>> index 0000000..0155a83
>>> --- /dev/null
>>> +++ b/fs/waitfd.c
>>> @@ -0,0 +1,117 @@
>>> +/*
>>> + *  fs/waitfd.c
>>> + *
>>> + *  Copyright (C) 2008  Red Hat, Casey Dahlin <cdahlin@redhat.com>
>>> + *
>>> + *  Largely derived from fs/signalfd.c
>>> + */
>>> +
>>> +#include <linux/file.h>
>>> +#include <linux/poll.h>
>>> +#include <linux/init.h>
>>> +#include <linux/fs.h>
>>> +#include <linux/sched.h>
>>> +#include <linux/kernel.h>
>>> +#include <linux/signal.h>
>>> +#include <linux/list.h>
>>> +#include <linux/anon_inodes.h>
>>> +#include <linux/syscalls.h>
>>> +
>>> +long do_waitid(int which, pid_t upid,
>>> +           struct siginfo __user *infop, int options,
>>> +           struct rusage __user *ru);
>>> +
>>> +struct waitfd_ctx {
>>> +    int ops;
>>> +    int which;
>>> +    pid_t upid;
>>> +};
>>> +
>>>     
>>
>> Please use kernel coding style:  use tabs to indent, not
>> <lots-of-spaces>,
>> and struct members, functions, etc., are indented by one tab stop
>> minimum.
>>
>>   
> 
> Damnit. This is a mailer artifact. This is the first time thunderbird
> has eaten a patch on me. I'll look in to it.

OK.
You can see if Documentation/email-clients.txt helps you any.

>>> +}
>>> +
>>> +static const struct file_operations waitfd_fops = {
>>> +    .release    = waitfd_release,
>>> +    .poll        = waitfd_poll,
>>> +    .read        = waitfd_read,
>>> +};
>>> +
>>> +asmlinkage long sys_waitfd(int which, pid_t upid, int options, int
>>> unused)
>>> +{
>>> +    int ufd;
>>> +    struct waitfd_ctx *ctx;
>>> +
>>> +    /* Just to make sure we don't end up with a sys_waitfd4 */
>>> +    (void)unused;
>>> +
>>> +    if (options & ~(WNOHANG|WEXITED|WSTOPPED|WCONTINUED))
>>> +        return -EINVAL;
>>> +    if (!(options & (WEXITED|WSTOPPED|WCONTINUED)))
>>> +        return -EINVAL;
>>>     
>>
>> Use spaces around '|'.
>>
>>   
> 
> Those 4 lines are copied almost exactly from kernel/exit.c. Is there
> motivation to keep them consistent?

I would say no.

-- 
~Randy
