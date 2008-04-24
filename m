Return-Path: <linux-kernel-owner+w=401wt.eu-S1762331AbYDXSlp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762331AbYDXSlp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 14:41:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754013AbYDXSld
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 14:41:33 -0400
Received: from service1.sh.cvut.cz ([147.32.127.214]:34440 "EHLO
	service1.sh.cvut.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967AbYDXSlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 14:41:31 -0400
X-Spam-Score: -102.185
Message-ID: <4810D4A4.7050900@seznam.cz>
Date: Thu, 24 Apr 2008 20:42:44 +0200
From: Michal Simek <monstr@seznam.cz>
Reply-To: monstr@seznam.cz
User-Agent: Thunderbird 2.0.0.12 (Windows/20080213)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Will Newton <will.newton@gmail.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-arch@vger.kernel.org, git@xilinx.com,
       microblaze-uclinux@itee.uq.edu.au
Subject: Re: microblaze syscall list
References: <87a5b0800804220513t75690ceao938a288596b5ad0c@mail.gmail.com> <200804221515.28075.arnd@arndb.de> <480FA729.3000406@seznam.cz> <200804241311.09881.arnd@arndb.de>
In-Reply-To: <200804241311.09881.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

>> I would like to fix syscalls in Microblaze repo. Can you give me a hint how to
>> do it?
> 
> I think we need to do it on a case-by-case basis, best here on the
> linux-arch mailing list. I'm sure there are some controversial ones,
> but most should be pretty clear.
>  
>> I look at Blackfin arch and I compared files with microblaze. There are some
>> differences but not so much.
>> Can you tell me how to test it which syscall is necessary for platform.
>> I have never found any documentation about.
> 
> Hopefully we can get to this kind of documentation by the end of this
> discussion. scripts/checksyscalls.sh is some part of the documentation,
> and we can refine that.
:-)

> Maybe we can even have an asm-generic/unistd.h that defines all the
> still relevant syscalls, plus a per-architecture range that you can
> use for microblaze-specific calls in your own unistd.h.

That will be really useful. Good idea.

>> In my syscall_table.S (on some arch in entry.S) is one big jump table with
>> reference to syscalls. In unistd.h is definition.
>>
>> Is there any convention which syscalls are use for all archs and which are
>> architecture specific?
> 
> Not really. There are very few syscalls that are needed only on certain
> architectures. The more common case is that a syscall has been replaced
> by a more complex interface, and a new architecture only needs one of the
> two, while older architectures still need both.
> 
> Let me just comment on your syscall table as it is today:
> 
>> ENTRY(sys_call_table)
>> 	.long sys_restart_syscall	/* 0 - old "setup()" system call,
>> 					 * used for restarting */
> 
> The comment is irrelevant and misleading -- microblaze never had sys_setup.

I removed this comment.

>> 	.long sys_exit
>> 	.long sys_ni_syscall		/* was fork */
> 
> it might be useful to renumber your calls once all the irrelevant ones
> have been removed, so you can get rid of all the sys_ni_syscalls here.

I'll delete all sys_ni_syscall from syscall_table.S and I'll remove it from
unistd.h too. I hope I'll keep the same call numbers.

>> 	.long sys_read
>> 	.long sys_write
>> 	.long sys_open			/* 5 */
> 
> Since we have all the new sys_*at calls like openat, we don't really
> need the old versions any more. The kernel implementation of sys_open
> basically calls openat. You could do the same in libc instead.
> Don't know if that's worth it though, opinions?

I looked at it and there are the different arguments for open and openat
syscalls. Implementation is almost the same. I keep it now.

>> 	.long sys_close
>> 	.long sys_waitpid
> 
> waitpid and wait4 can be replaced with waitid

Can I keep number of syscall(unistd.h) and only add reference to waitid in
syscall_table? or just remove?

>> 	.long sys_creat
>> 	.long sys_link
>> 	.long sys_unlink		/* 10 */
>> 	.long sys_execve_wrapper
> 
> having an execve_wrapper instead of execve looks like a strange convention,
> though I guess you had a good reason for it, could you explain?
>
> This one looks architecture specific, so you may want to rename it
> microblaze_execve_wrapper instead of sys_execve_wrapper.

I looked at it and the same of style is used in arm
(arch/arm/kernel/entry-common.S) and some others arch. This wrapper only set one
parameter to correct pointer to stack.

I'll comment the rest later. I need time to look at it.

Thanks for your big help. I really appreciate this.

Michal
