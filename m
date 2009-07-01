Return-Path: <linux-kernel-owner+w=401wt.eu-S1753828AbZGAEtD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753828AbZGAEtD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 00:49:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZGAEs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 00:48:58 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:51116 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbZGAEs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 00:48:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=wdHwtMBYD5FwqiNrQnMq1d45QLFLOIj8IJoaPimwONJe/gUcqF+GAauYLca3gzWmp5
         KhrDYFn2rhmTRT7KUZbzsOXhHCqz8k9bqdJRyR3pzlN3tWuKQkIIabEYW2SGyvjFACtU
         SZrkLf1g2DuMFG/Q1NO90B7qSGDN3e1wm7Mhc=
Date: Wed, 1 Jul 2009 12:51:02 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Hui Zhu <teawater@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, viro@zeniv.linux.org.uk, dhowells@redhat.com
Subject: Re: [PATCH] Fix the multithread program core thread message error
Message-ID: <20090701045102.GA6076@cr0.nay.redhat.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com> <20090701005437.GA5856@cr0.nay.redhat.com> <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 11:27:41AM +0800, Hui Zhu wrote:
>Hi Amerigo,
>
>Thanks for your reply.
>
>On Wed, Jul 1, 2009 at 08:54, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>>
>> Hi, Hui.
>>
>> On Tue, Jun 30, 2009 at 05:12:31PM +0800, Hui Zhu wrote:
>>>Fix the multithread program core thread message error.
>>>The thread message of core file is generated in
>>>elf_dump_thread_status.  The register values is set by
>>>elf_core_copy_task_regs in this function.
>>>static inline int elf_core_copy_task_regs(struct task_struct *t,
>>>                                          elf_gregset_t* elfregs)
>>>{
>>>
>>>       return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>>>       return 0;
>>>}
>>>If a arch doesn't define ELF_CORE_COPY_TASK_REGS, This function will do
>>>nothing.  Then the core file will not have the register message of
>>>thread.
>>>So add elf_core_copy_regs to set regiser values if
>>>ELF_CORE_COPY_TASK_REGS doesn't define.
>>
>>
>> You forgot your Signed-off-by line. :)
>
>Signed-off-by: Hui Zhu <hui.zhu@windriver.com>
>
>>
>> Hmmm, this patch looks sane for me. But could you please
>> send us your test program? i.e. how did you test this?
>>
>
>I test this issue in a arm board.  My test code is:

Thanks!

Hmm, this only affects the arch which neither has
CORE_DUMP_USE_REGSET nor ELF_CORE_COPY_TASK_REGS,
arm is one of them, but x86 not...

Could you please resend this patch with your
favourite Signed-off-by and also put the reproduce
steps below into your change log?

P.S. Add some Cc's for more reviews, don't drop
them when you resend your patch.


>#include <stdio.h>
>#include <pthread.h>
>#include <assert.h>
>
>void td1(void * i)
>{
>	while (1)
>	{
>		printf ("1\n");
>		sleep (1);
>	}
>
>	return;
>}
>
>void td2(void * i)
>{
>	while (1)
>	{
>		printf ("2\n");
>		sleep (1);
>	}
>
>	return;
>}
>
>int
>main(int argc,char *argv[],char *envp[])
>{
>	pthread_t	t1,t2;
>
>	pthread_create(&t1, NULL, (void*)td1, NULL);
>	pthread_create(&t2, NULL, (void*)td2, NULL);
>
>	sleep (10);
>
>	assert(0);
>
>	return (0);
>}
>
>The follow is how to reproduce this issue:
>arm-xxx-gcc -g -lpthread 1.c -o 1
>copy 1.c and 1 to a arm board.
>Goto this board.
>ulimit -c 1800000
>./1
># ./1
>1
>2
>1
>...
>...
>1
>1: 1.c:37: main: Assertion `0' failed.
>Aborted (core dumped)
>Then you can get a core file.
>gdb 1 core.xxx
>
>Without the patch:
>(gdb) info threads
>  3 process 909  0x00000000 in ?? ()
>  2 process 908  0x00000000 in ?? ()
>* 1 process 907  0x4a6e2238 in raise () from /lib/libc.so.6
>You can found that the pc of 909 and 908 is 0x00000000.
>
>With the patch:
>(gdb) info threads
>  3 process 885  0x4a749974 in nanosleep () from /lib/libc.so.6
>  2 process 884  0x4a749974 in nanosleep () from /lib/libc.so.6
>* 1 process 883  0x4a6e2238 in raise () from /lib/libc.so.6
>The pc of 885 and 884 is right.
>
>
>Thanks,
>Hui
