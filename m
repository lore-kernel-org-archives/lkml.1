Return-Path: <linux-kernel-owner+w=401wt.eu-S1758990AbZGAD1u@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758990AbZGAD1u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 23:27:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752955AbZGAD1m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 23:27:42 -0400
Received: from wf-out-1314.google.com ([209.85.200.172]:59789 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752455AbZGAD1l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 23:27:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=P6F43Gwd05pFrww+wbYBkPAFMz2OPbr0MoPavv+O91KwjtGV3BLezaAGBSloWqEwSH
         FYcQEA1AmUbrRAXulK203QxX29/Jr12mxLKgj+ZUm2EFxn/p7D8afTstoTWGYWfgkijH
         +jrf0ETNnPqj1m1cferBXLd/npOT3nbyn07FM=
MIME-Version: 1.0
In-Reply-To: <20090701005437.GA5856@cr0.nay.redhat.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
	 <20090701005437.GA5856@cr0.nay.redhat.com>
Date: Wed, 1 Jul 2009 11:27:41 +0800
Message-ID: <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
Subject: Re: [PATCH] Fix the multithread program core thread message error
From: Hui Zhu <teawater@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Amerigo,

Thanks for your reply.

On Wed, Jul 1, 2009 at 08:54, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>
> Hi, Hui.
>
> On Tue, Jun 30, 2009 at 05:12:31PM +0800, Hui Zhu wrote:
>>Fix the multithread program core thread message error.
>>The thread message of core file is generated in
>>elf_dump_thread_status.  The register values is set by
>>elf_core_copy_task_regs in this function.
>>static inline int elf_core_copy_task_regs(struct task_struct *t,
>>                                          elf_gregset_t* elfregs)
>>{
>>
>>       return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>>       return 0;
>>}
>>If a arch doesn't define ELF_CORE_COPY_TASK_REGS, This function will do
>>nothing.  Then the core file will not have the register message of
>>thread.
>>So add elf_core_copy_regs to set regiser values if
>>ELF_CORE_COPY_TASK_REGS doesn't define.
>
>
> You forgot your Signed-off-by line. :)

Signed-off-by: Hui Zhu <hui.zhu@windriver.com>

>
> Hmmm, this patch looks sane for me. But could you please
> send us your test program? i.e. how did you test this?
>

I test this issue in a arm board.  My test code is:
#include <stdio.h>
#include <pthread.h>
#include <assert.h>

void td1(void * i)
{
	while (1)
	{
		printf ("1\n");
		sleep (1);
	}

	return;
}

void td2(void * i)
{
	while (1)
	{
		printf ("2\n");
		sleep (1);
	}

	return;
}

int
main(int argc,char *argv[],char *envp[])
{
	pthread_t	t1,t2;

	pthread_create(&t1, NULL, (void*)td1, NULL);
	pthread_create(&t2, NULL, (void*)td2, NULL);

	sleep (10);

	assert(0);

	return (0);
}

The follow is how to reproduce this issue:
arm-xxx-gcc -g -lpthread 1.c -o 1
copy 1.c and 1 to a arm board.
Goto this board.
ulimit -c 1800000
./1
# ./1
1
2
1
...
...
1
1: 1.c:37: main: Assertion `0' failed.
Aborted (core dumped)
Then you can get a core file.
gdb 1 core.xxx

Without the patch:
(gdb) info threads
  3 process 909  0x00000000 in ?? ()
  2 process 908  0x00000000 in ?? ()
* 1 process 907  0x4a6e2238 in raise () from /lib/libc.so.6
You can found that the pc of 909 and 908 is 0x00000000.

With the patch:
(gdb) info threads
  3 process 885  0x4a749974 in nanosleep () from /lib/libc.so.6
  2 process 884  0x4a749974 in nanosleep () from /lib/libc.so.6
* 1 process 883  0x4a6e2238 in raise () from /lib/libc.so.6
The pc of 885 and 884 is right.


Thanks,
Hui
