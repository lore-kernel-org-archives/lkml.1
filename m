Return-Path: <linux-kernel-owner+w=401wt.eu-S1760425AbXJDL4c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760425AbXJDL4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2007 07:56:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756471AbXJDL4X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Oct 2007 07:56:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60366 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756631AbXJDL4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2007 07:56:21 -0400
Message-ID: <4704D4DE.8010805@cn.fujitsu.com>
Date: Thu, 04 Oct 2007 20:56:14 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Mikael Pettersson <mikpe@it.uu.se>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] signal(i386): alternative signal stack wraparound
 occurs
References: <200710031346.l93DkWbE028800@harpo.it.uu.se> <20071003232509.929160f1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20071003232509.929160f1.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

KAMEZAWA Hiroyuki wrote::
> On Wed, 3 Oct 2007 15:46:32 +0200 (MEST)
> Mikael Pettersson <mikpe@it.uu.se> wrote:
>> The proposed kernel signal delivery patch only handles the case
>> where the /sigframe/ ends up overlapping the end of the altstack.
>> If the sigframe remains within the altstack boundaries but the
>> user-space signal handler adds an /ordinary stack frame/ that
>> moves SP beyond the altstack limit, then the kernel patch solves
>> nothing and recursive signals will cause altstack wraparound.
>>
>> On the other hand, the user-space technique of making the lowest
>> page(s) in the altstack inaccessible handles both cases of overflow.
>>
> Hmm, okay. Then, this fix is not enough. I see.
> I'll consider how to eduacate users.

Excuse me. What will Mr.Kamezawa educate users? How to use sigaltstack?

Following is about using mmap/mprotect. In the previous mail(just now), I have said the same 
thing.Now I say it again in detailed.

Mikael has told us user'd better to use mmap/mprotect. So I tried to use mmap/mprotect in my test code.

I want to mprotect() the place from mid to low, and hope it stop the overflow.
high
|
|	enable to access
|
mid
|
|	disable to access
|
low
I hope the kernel catch it when the esp beyond the boundaries(mid) in user-space.

But the altstack wraparound still occurs.
begin = 0xb7fec000
end   = 0xb7fee000
esp = 0xb7fedce0
1
esp = 0xb7fed9e0
2
esp = 0xb7fed6e0
3
esp = 0xb7fedce0  <- wraparound
4
...

Fortunately, when I reuse the patch, wraparound disappeared. Even if I activate the code *1(please 
refer to the following test code).
So I think we need the patch, in the same time,we advice the user it's better to use mmap/mprotect.

-----------------------------------------------------------
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

//	int i[1000];	//*1
	
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
	if (pagesize == -1)
		die("sysconf");

	addr = mmap(NULL, pagesize * 2, PROT_READ | PROT_WRITE | PROT_EXEC,
		    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (addr == MAP_FAILED)
		die("mmap");
	
	printf("begin = 0x%08lx\n", addr);
	printf("end   = 0x%08lx\n", addr + pagesize * 2);
	
	if (mprotect(addr, pagesize, PROT_NONE) == -1)
		die("mprotect");

	stack.ss_sp = addr + pagesize;
	stack.ss_flags = 0;
	stack.ss_size = pagesize;
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
-----------------------------------------------------------

Any suggestion?

Thanks
Shi Weihua

> 
> Thanks,
> -Kame
> 
> 
> 

