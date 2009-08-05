Return-Path: <linux-kernel-owner+w=401wt.eu-S933368AbZHELgN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368AbZHELgN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 07:36:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932900AbZHELgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 07:36:13 -0400
Received: from mx2.redhat.com ([66.187.237.31]:37085 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932508AbZHELgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 07:36:12 -0400
Message-ID: <4A796F27.9040003@redhat.com>
Date: Wed, 05 Aug 2009 19:38:15 +0800
From: Amerigo Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090719)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       Al Viro <viro@zeniv.linux.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [Patch 1/2] ia32: use generic sys_pipe()
References: <20090722091051.6621.15184.sendpatchset@localhost.localdomain> <20090804122432.GB4367@elte.hu>
In-Reply-To: <20090804122432.GB4367@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Amerigo Wang <amwang@redhat.com> wrote:
>
>   
>> As suggested by Al, it's better to use the generic sys_pipe() for 
>> ia32.
>>
>> Signed-off-by: WANG Cong <amwang@redhat.com>
>> Cc: Ingo Molnar <mingo@elte.hu>
>> Cc: Al Viro <viro@zeniv.linux.org.uk>
>> CC: Linus Torvalds <torvalds@linux-foundation.org>
>>     
>
>   
>> --- a/arch/x86/ia32/sys_ia32.c
>> +++ b/arch/x86/ia32/sys_ia32.c
>> @@ -189,20 +189,6 @@ asmlinkage long sys32_mprotect(unsigned long start, size_t len,
>>  	return sys_mprotect(start, len, prot);
>>  }
>>  
>> -asmlinkage long sys32_pipe(int __user *fd)
>> -{
>> -	int retval;
>> -	int fds[2];
>> -
>> -	retval = do_pipe_flags(fds, 0);
>> -	if (retval)
>> -		goto out;
>> -	if (copy_to_user(fd, fds, sizeof(fds)))
>> -		retval = -EFAULT;
>> -out:
>> -	return retval;
>> -}
>>     
>
> Please _ALWAYS_ mention the change in behavior in the changelog, 
> just in case someone ends up bisecting it. I only found out when i 
> reviewed the two syscalls out of caution.
>
> The syscall you remove kept stale fd's around in case of -EFAULT 
> from copy_to_user(). The generic version does an explicit close of 
> those files:
>
>                         sys_close(fd[0]);
>                         sys_close(fd[1]);
>                         error = -EFAULT;
>
> The generic version looks like the better choice to me but this 
> difference should be mentioned in the changelog nevertheless, just 
> in case some buggy app runs into this issue.
>   

Hi, yes, exactly.
Thank you! I will be careful next time.

