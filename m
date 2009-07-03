Return-Path: <linux-kernel-owner+w=401wt.eu-S1757413AbZGCJq0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757413AbZGCJq0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 05:46:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753176AbZGCJqS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 05:46:18 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:15181 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751710AbZGCJqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 05:46:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=puXO406MGC3O5hFejTq2ofXfLAgRiYToM842nh0+wtYzg6ypolcFydzznwLOqGZhZq
         UhrC5QhYlTBWA4F1IFP1kEtkxD+kf93yqvyqr3QzYVV7rXrHylHn234oGjmJF8CV5fUG
         5EsMUzTItI3/LI+JwG/vDROvufmfzEhDf+Ddo=
Date: Fri, 3 Jul 2009 17:48:25 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Zhu <teawater@gmail.com>, xiyou.wangcong@gmail.com,
       linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
       dhowells@redhat.com, Russell King <rmk@arm.linux.org.uk>,
       linux-arm-kernel@lists.arm.linux.org.uk, stable@kernel.org
Subject: Re: [PATCH] Fix the multithread program core thread message error
Message-ID: <20090703094825.GJ5880@cr0.nay.redhat.com>
References: <daef60380906300212p2a461537p9730686084a9ef8d@mail.gmail.com> <20090701005437.GA5856@cr0.nay.redhat.com> <daef60380906302027i39097bd6wc336f44763cf32bc@mail.gmail.com> <20090701045102.GA6076@cr0.nay.redhat.com> <daef60380906302321n681b8092k32c468ae281f4fbb@mail.gmail.com> <20090701120519.d5b1ed78.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090701120519.d5b1ed78.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 01, 2009 at 12:05:19PM -0700, Andrew Morton wrote:
>On Wed, 1 Jul 2009 14:21:37 +0800
>Hui Zhu <teawater@gmail.com> wrote:
>
>> Thanks for your help, Amerigo.
>> 
>> Hui
>> 
>> Fix the multithread program core thread message error.
>> This issue just affect arch with neither has CORE_DUMP_USE_REGSET
>> nor ELF_CORE_COPY_TASK_REGS, ARM is one of them.
>> The thread message of core file is generated in
>> elf_dump_thread_status.  The register values is set by
>> elf_core_copy_task_regs in this function.
>> If a arch doesn't define ELF_CORE_COPY_TASK_REGS, The function
>> elf_core_copy_task_regs will do nothing.  Then the core file will
>> not have the register message of thread.
>> So add elf_core_copy_regs to set regiser values if
>> ELF_CORE_COPY_TASK_REGS doesn't define.
>> The following is how to reproduce this issue:
>>
>> ...
>>
>> Without the patch:
>> (gdb) info threads
>>  3 process 909  0x00000000 in ?? ()
>>  2 process 908  0x00000000 in ?? ()
>> * 1 process 907  0x4a6e2238 in raise () from /lib/libc.so.6
>> You can found that the pc of 909 and 908 is 0x00000000.
>> With the patch:
>> (gdb) info threads
>>  3 process 885  0x4a749974 in nanosleep () from /lib/libc.so.6
>>  2 process 884  0x4a749974 in nanosleep () from /lib/libc.so.6
>> * 1 process 883  0x4a6e2238 in raise () from /lib/libc.so.6
>> The pc of 885 and 884 is right.
>

Thanks for taking this.


>I'm trying to work out if we should backport this fix into earlier
>kernels (2.6.30.x, 2.6.29.x, etc).
>
>I'd have though that having gdb produce crap for all the threads would
>be fairly irritating to ARM developers and hence we should backport
>this.  But perhaps it doens't affect many people, dunno.
>
>What do poeple think?

This doesn't affect many platforms, only the platforms which has
_neither_ CORE_DUMP_USE_REGSET nor ELF_CORE_COPY_TASK_REGS.

I haven't checked all, just x86 and arm, x86 doesn't, arm does.


