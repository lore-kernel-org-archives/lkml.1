Return-Path: <linux-kernel-owner+w=401wt.eu-S1759766AbXJDLCv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759766AbXJDLCv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:02:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755966AbXJDLCo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:02:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:39662 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755378AbXJDLCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:02:43 -0400
Message-ID: <4704C84C.3080804@cn.fujitsu.com>
Date: Thu, 04 Oct 2007 20:02:36 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <200710031220.l93CK75T028343@harpo.it.uu.se>
In-Reply-To: <200710031220.l93CK75T028343@harpo.it.uu.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote::
> On Wed, 03 Oct 2007 17:06:24 +0900, Shi Weihua wrote:
>> Fixing alternative signal stack wraparound.
>>
>> If a process uses alternative signal stack by using sigaltstack()
>> and that stack overflow, stack wraparound occurs.
>> This patch checks whether the signal frame is on the alternative
>> stack. If the frame is not on there, kill a signal SIGSEGV to the process forcedly
>> then the process will be terminated.
>>
>> This patch is for i386,version is 2.6.23-rc8.
>>
>> Signed-off-by: Shi Weihua <shiwh@cn.fujitsu.com>
>>
>> diff -pur linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c linux-2.6.23-rc8/arch/i386/kernel/signal.c
>> --- linux-2.6.23-rc8.orig/arch/i386/kernel/signal.c	2007-09-26 09:44:08.000000000 +0900
>> +++ linux-2.6.23-rc8/arch/i386/kernel/signal.c	2007-09-26 13:14:25.000000000 +0900
>> @@ -332,6 +332,10 @@ static int setup_frame(int sig, struct k
>>
>>   	frame = get_sigframe(ka, regs, sizeof(*frame));
>>
>> +	if ((ka->sa.sa_flags & SA_ONSTACK) &&
>> +		!sas_ss_flags((unsigned long)frame))
>> +		goto give_sigsegv;
>> +
>>   	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>>   		goto give_sigsegv;
>>
>> @@ -425,6 +429,10 @@ static int setup_rt_frame(int sig, struc
>>
>>   	frame = get_sigframe(ka, regs, sizeof(*frame));
>>
>> +	if ((ka->sa.sa_flags & SA_ONSTACK) &&
>> +		!sas_ss_flags((unsigned long)frame))
>> +		goto give_sigsegv;
>> +
>>   	if (!access_ok(VERIFY_WRITE, frame, sizeof(*frame)))
>>   		goto give_sigsegv;
> 
> Your patch description is a little terse. What you do is that
> after the kernel has decided where to put the signal frame,
> you add a check that the base of the frame still lies in the
> altstack range if altstack delivery is requested for the signal,
> and if it doesn't a hard error is forced.
> 
> The coding of that logic is fine.
> 
> What I don't agree with is the logic itself:
> - You only catch altstack overflow caused by the kernel pushing
>   a sigframe. You don't catch overflow caused by the user-space
>   signal handler pushing its own stack frame after the sigframe.
> - SUSv3 specifies the effect of altstack overflow as "undefined".
> - The overflow problem can be solved in user-space: allocate the
>   altstack with mmap(), then mprotect() the lowest page to prevent
>   accesses to it. Any overflow into it, by the kernel's signal
>   delivery code or by the user-space signal handler, will be caught.

mmap/mprotect can not avoid this kind of wraparound.
Please compile and run the following test code on i386.
The code want to allow process access from high to mid,and not from mid to low.
high
|
|
mid
|
|
low

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

#define die(msg) do { perror(msg); exit(EXIT_FAILURE); } while (0)
volatile int counter = 0;

#ifdef __i386__
void print_esp()
{
	unsigned long esp;
	__asm__ __volatile__("movl %%esp, %0":"=g"(esp));

	printf("esp = 0x%08lx\n", esp);
}
#endif

static void segv_handler()
{
#ifdef __i386__
	print_esp();
#endif

	int *c = NULL;
	counter++;
	printf("%d\n", counter);

	*c = 1;			// SEGV
}

int main()
{
	int *c = NULL;
	int pagesize;
	char *addr;
	stack_t stack;
	struct sigaction action;

	pagesize = sysconf(_SC_PAGE_SIZE);
	if (pagesize == -1) {
		die("sysconf");
		exit(EXIT_FAILURE);
	}

	addr = mmap(NULL, pagesize * 2, PROT_READ | PROT_WRITE | PROT_EXEC,
		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (addr == MAP_FAILED) {
		die("mmap");
		exit(EXIT_FAILURE);
	}
	printf("begin = 0x%08lx\n", addr);
	printf("end   = 0x%08lx\n", addr + pagesize * 2);
	
	if (mprotect(addr, pagesize, PROT_NONE) == -1) {
		die("mprotect");
		exit(EXIT_FAILURE);
	}

	stack.ss_sp = addr + pagesize;
	stack.ss_flags = 0;
	stack.ss_size = pagesize;	//SIGSTKSZ;
	int error = sigaltstack(&stack, NULL);
	if (error) {
		printf("Failed to use sigaltstack!\n");
		return -1;
	}

	memset(&action, 0, sizeof(action));
	action.sa_handler = segv_handler;
	action.sa_flags = SA_ONSTACK | SA_NODEFER;

	sigemptyset(&action.sa_mask);

	sigaction(SIGSEGV, &action, NULL);

	*c = 0;			//SEGV

	return 0;
}

Any suggestion?

Thanks
Shi Weihua

> 
> So this patch gets a NAK from me.
> 
> /Mikael
> 
> 
> 

