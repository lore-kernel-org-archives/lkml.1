Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754612Ab0BIW1X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 17:27:23 -0500
Received: from mail.gmx.net ([213.165.64.20]:52781 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754572Ab0BIW1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 17:27:20 -0500
X-Authenticated: #1045983
X-Provags-ID: V01U2FsdGVkX18qcnAL81wqnkeRMUs1IJ+BzMek8j/+Yzj5UYO6i0
	IvYZFQl1/l8qrg
Message-ID: <4B71E13C.2050905@gmx.de>
Date: Tue, 09 Feb 2010 23:27:08 +0100
From: Helge Deller <deller@gmx.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Michael Neuling <mikey@neuling.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Americo Wang <xiyou.wangcong@gmail.com>,
       Anton Blanchard <anton@samba.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Oleg Nesterov <oleg@redhat.com>, James Morris <jmorris@namei.org>,
       Ingo Molnar <mingo@elte.hu>, linux-fsdevel@vger.kernel.org,
       stable@kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Serge Hallyn <serue@us.ibm.com>,
       Paul Mackerras <paulus@samba.org>, benh@kernel.crashing.org,
       miltonm@bga.com, aeb@cwi.nl, linux-parisc@vger.kernel.org
Subject: Re: [PATCH] Restrict initial stack space expansion to rlimit
References: <20100208161014.7C6D.A69D9226@jp.fujitsu.com> <1273.1265695885@neuling.org> <20100209154141.03F0.A69D9226@jp.fujitsu.com> <11046.1265705967@neuling.org> <20100209132529.bfc455b7.akpm@linux-foundation.org> <10733.1265752289@neuling.org>
In-Reply-To: <10733.1265752289@neuling.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.45000000000000001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2010 10:51 PM, Michael Neuling wrote:
>>> I'd still like someone with a CONFIG_STACK_GROWSUP arch to test/ACK it
>>> as well.
>>
>> There's only one CONFIG_GROWSUP arch - parisc.
>> Could someone please test it on parisc?

I did.

> How about doing:
>    'ulimit -s 15; ls'
> before and after the patch is applied.  Before it's applied, 'ls' should
> be killed.  After the patch is applied, 'ls' should no longer be killed.
>
> I'm suggesting a stack limit of 15KB since it's small enough to trigger
> 20*PAGE_SIZE.  Also 15KB not a multiple of PAGE_SIZE, which is a trickier
> case to handle correctly with this code.
>
> 4K pages on parisc should be fine to test with.

Mikey, thanks for the suggested test plan.

I'm not sure if your patch does it correct for parisc/stack-grows-up-case.

I tested your patch on  a 4k pages kernel:
root@c3000:~# uname -a
Linux c3000 2.6.33-rc7-32bit #221 Tue Feb 9 23:17:06 CET 2010 parisc GNU/Linux

Without your patch:
root@c3000:~# ulimit -s 15; ls
Killed
-> correct.

With your patch:
root@c3000:~# ulimit -s 15; ls
Killed
_or_:
root@c3000:~# ulimit -s 15; ls
Segmentation fault
-> ??

Any idea?

Helge


>> From: Michael Neuling<mikey@neuling.org>
>>
>> When reserving stack space for a new process, make sure we're not
>> attempting to expand the stack by more than rlimit allows.
>>
>> This fixes a bug caused by b6a2fea39318e43fee84fa7b0b90d68bed92d2ba ("mm:
>> variable length argument support") and unmasked by
>> fc63cf237078c86214abcb2ee9926d8ad289da9b ("exec: setup_arg_pages() fails
>> to return errors").
>>
>> This bug means that when limiting the stack to less the 20*PAGE_SIZE (eg.
>> 80K on 4K pages or 'ulimit -s 79') all processes will be killed before
>> they start.  This is particularly bad with 64K pages, where a ulimit below
>> 1280K will kill every process.
>>
>> Signed-off-by: Michael Neuling<mikey@neuling.org>
>> Cc: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>> Cc: Americo Wang<xiyou.wangcong@gmail.com>
>> Cc: Anton Blanchard<anton@samba.org>
>> Cc: Oleg Nesterov<oleg@redhat.com>
>> Cc: James Morris<jmorris@namei.org>
>> Cc: Ingo Molnar<mingo@elte.hu>
>> Cc: Serge Hallyn<serue@us.ibm.com>
>> Cc: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>> Cc:<stable@kernel.org>
>>
>>   fs/exec.c |   21 +++++++++++++++++++--
>>   1 file changed, 19 insertions(+), 2 deletions(-)
>>
>> diff -puN fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit
>   fs/exec.c
>> --- a/fs/exec.c~fs-execc-restrict-initial-stack-space-expansion-to-rlimit
>> +++ a/fs/exec.c
>> @@ -571,6 +571,9 @@ int setup_arg_pages(struct linux_binprm
>>   	struct vm_area_struct *prev = NULL;
>>   	unsigned long vm_flags;
>>   	unsigned long stack_base;
>> +	unsigned long stack_size;
>> +	unsigned long stack_expand;
>> +	unsigned long rlim_stack;
>>
>>   #ifdef CONFIG_STACK_GROWSUP
>>   	/* Limit stack size to 1GB */
>> @@ -627,10 +630,24 @@ int setup_arg_pages(struct linux_binprm
>>   			goto out_unlock;
>>   	}
>>
>> +	stack_expand = EXTRA_STACK_VM_PAGES * PAGE_SIZE;
>> +	stack_size = vma->vm_end - vma->vm_start;
>> +	/*
>> +	 * Align this down to a page boundary as expand_stack
>> +	 * will align it up.
>> +	 */
>> +	rlim_stack = rlimit(RLIMIT_STACK)&  PAGE_MASK;
>> +	rlim_stack = min(rlim_stack, stack_size);
>>   #ifdef CONFIG_STACK_GROWSUP
>> -	stack_base = vma->vm_end + EXTRA_STACK_VM_PAGES * PAGE_SIZE;
>> +	if (stack_size + stack_expand>  rlim_stack)
>> +		stack_base = vma->vm_start + rlim_stack;
>> +	else
>> +		stack_base = vma->vm_end + stack_expand;
>>   #else
>> -	stack_base = vma->vm_start - EXTRA_STACK_VM_PAGES * PAGE_SIZE;
>> +	if (stack_size + stack_expand>  rlim_stack)
>> +		stack_base = vma->vm_end - rlim_stack;
>> +	else
>> +		stack_base = vma->vm_start - stack_expand;
>>   #endif
>>   	ret = expand_stack(vma, stack_base);
>>   	if (ret)
