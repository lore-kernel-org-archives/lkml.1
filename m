Return-Path: <linux-kernel-owner+w=401wt.eu-S1756023AbXJCIGi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023AbXJCIGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 04:06:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752562AbXJCIGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 04:06:25 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48627 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443AbXJCIGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 04:06:23 -0400
Message-ID: <47034D7D.5070504@cn.fujitsu.com>
Date: Wed, 03 Oct 2007 17:06:21 +0900
From: Shi Weihua <shiwh@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] signal: alternative signal stack wraparound occurs
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

If a process uses alternative signal stack by using sigaltstack(),
then that stack overflows and stack wraparound occurs.
Simple Explanation:
The accurate esp order is A,B,C,D,...
But now the esp points to A,B,C and A,B,C again.

When I tested sigaltstack() and try to kill a same signal SIGSEGV
to the current process,the previous phenomena occurs.
This problem can reproduce by the following code:

-------------------------------------------------------------------------------
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>

volatile int counter = 0;

#ifdef __i386__
void print_esp()
{
	unsigned long esp;
	__asm__ __volatile__("movl %%esp, %0":"=g"(esp));

	printf("esp = 0x%08lx\n", esp);
}
#endif

void segv_handler()
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
	char *s = malloc(SIGSTKSZ);
	stack_t stack;
	struct sigaction action;

	memset(s, 0, SIGSTKSZ);
	stack.ss_sp = s;
	stack.ss_flags = 0;
	stack.ss_size = SIGSTKSZ;
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

	if (!s)
		free(s);

	return 0;
}

-------------------------------------------------------------------------------

The result(for i386) is as follows:

-------------------------------------------------------------------------------
$ ./testpro
esp = 0x0804bcf0
1
esp = 0x0804b9f0
2
esp = 0x0804b6f0
3
esp = 0x0804b3f0
4
esp = 0x0804b0f0
5
esp = 0x0804adf0
6
esp = 0x0804aaf0
7
esp = 0x0804a7f0
8
esp = 0x0804a4f0
9
esp = 0x0804a1f0
10
esp = 0x08049ef0
11
esp = 0x0804bcf0
12		# <- wraparound occurs!
		# <- the 12nd output is same as 1st.
-------------------------------------------------------------------------------

The kernel doesn't stop the wraparound occuring, so I think this is a bug.

In my patches,some check code is added.
These code checks the signal frame is on alternative signal stack or not.
If signal frame isn't on the stack, an error process mechanism will be
awoken(e.g."goto give_sigsegv" ).

[PATCH 1/3] signal(i386): alternative signal stack wraparound occurs
[PATCH 2/3] signal(ia64): alternative signal stack wraparound occurs
[PATCH 3/3] signal(x86-64): alternative signal stack wraparound occurs

My patch resolved this wraparound's problem, but if I use the following patch
on the previous test code,the wraparound still occurs.

-------------------------------------------------------------------------------
--- testpro.c.orig	2007-09-26 11:11:45.000000000 +0900
+++ testpro.c	2007-09-26 11:12:46.000000000 +0900
@@ -21,6 +21,8 @@ void segv_handler()
  	print_esp();
  #endif

+	int i[1000];
+
  	int *c = NULL;
  	counter++;
  	printf("%d\n", counter);

-------------------------------------------------------------------------------

I think the "int i[1000];" make the signal frame not to be checked by the added
code in my patch.
But I don't know how to avoid it.
Do you have any idea?

Regards,
Shi Weihua

