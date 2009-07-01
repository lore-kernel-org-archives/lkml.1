Return-Path: <linux-kernel-owner+w=401wt.eu-S1754035AbZGAIQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754035AbZGAIQb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 04:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753496AbZGAIQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 04:16:12 -0400
Received: from mail-pz0-f188.google.com ([209.85.222.188]:37465 "EHLO
	mail-pz0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbZGAIQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 04:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ux/QccfKqNNQL20TQjsr7FSNWa3ziY6AXC/psfFHHUPw+P5i2oSuXkZuGgw0ariMPl
         Z9CFnZg/YrCrTeTfVnDup1/18od3n9ZhZbPvqciqkGMDQgReJF63EAerB6TtppRRboaY
         Gj4ZxGj2e3F9HVAxL6e4DfCS6+lucwekrNgkY=
MIME-Version: 1.0
In-Reply-To: <20090701072027.GE6076@cr0.nay.redhat.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com>
	 <20090701005437.GA5856@cr0.nay.redhat.com>
	 <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com>
	 <20090701045102.GA6076@cr0.nay.redhat.com>
	 <daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com>
	 <20090701072027.GE6076@cr0.nay.redhat.com>
Date: Wed, 1 Jul 2009 16:16:11 +0800
Message-ID: <daef60380907010116h6b33d257u9cc22fc6b5138c09@mail.gmail.com>
Subject: Re: [PATCH] Fix the multithread program core thread message error
From: Hui Zhu <teawater@gmail.com>
To: Amerigo Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       viro@zeniv.linux.org.uk, dhowells@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>>       return ELF_CORE_COPY_TASK_REGS(t, elfregs);
>>+#else
>>+       elf_core_copy_regs(elfregs, task_pt_regs(t));
>> #endif
>>       return 0;
>> }
>
> Your email client eats tabs. :) Can you fix your email client
> or resend it with a tool like git send-email?
>
> Thanks.
>

Ah, sorry about it.  I think the tabs was lost when I copy this code
with wrong way.
I try this version with myself first.  It looks ok.  Please help me with it.

Thanks,
Hui

Fix the multithread program core thread message error.
This issue just affect arch with neither has CORE_DUMP_USE_REGSET
nor ELF_CORE_COPY_TASK_REGS, ARM is one of them.
The thread message of core file is generated in
elf_dump_thread_status.  The register values is set by
elf_core_copy_task_regs in this function.
If a arch doesn't define ELF_CORE_COPY_TASK_REGS, The function
elf_core_copy_task_regs will do nothing.  Then the core file will
not have the register message of thread.
So add elf_core_copy_regs to set regiser values if
ELF_CORE_COPY_TASK_REGS doesn't define.
The following is how to reproduce this issue:
cat 1.c
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

Signed-off-by: Hui Zhu <teawater@gmail.com>
---
 elfcore.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/elfcore.h b/include/linux/elfcore.h
index 7605c5e..03ec167 100644
--- a/include/linux/elfcore.h
+++ b/include/linux/elfcore.h
@@ -125,6 +125,8 @@ static inline int elf_core_copy_task_regs(struct
task_struct *t, elf_gregset_t*
 #ifdef ELF_CORE_COPY_TASK_REGS
 	
 	return ELF_CORE_COPY_TASK_REGS(t, elfregs);
+#else
+	elf_core_copy_regs(elfregs, task_pt_regs(t));
 #endif
 	return 0;
 }
