Return-Path: <linux-kernel-owner+w=401wt.eu-S1757591AbYHZMgy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591AbYHZMgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 08:36:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753851AbYHZMgq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 08:36:46 -0400
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:57105 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844AbYHZMgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 08:36:45 -0400
Message-ID: <48B3F81C.2010803@linux.vnet.ibm.com>
Date: Tue, 26 Aug 2008 14:33:32 +0200
From: Pierre Morel <pmorel@linux.vnet.ibm.com>
User-Agent: Thunderbird 1.5.0.9 (X11/20061206)
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@tv-sign.ru>, Roland McGrath <roland@redhat.com>,
       Heiko Carstens <heicars2@linux.vnet.ibm.com>,
       sameske@linux.vnet.ibm.com, Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [RFC] [Patch 1/1] [Self Ptrace] System call notification with
 self_ptrace
References: <48B26083.8080506@linux.vnet.ibm.com> <1219681992.20559.196.camel@nimitz>
In-Reply-To: <1219681992.20559.196.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Dave Hansen wrote:
> On Mon, 2008-08-25 at 09:34 +0200, Pierre Morel wrote:
>   
>> +       if ((current->ptrace & PT_SELF)
>> +               && (regs->orig_ax != __NR_rt_sigreturn)
>> +               && (regs->orig_ax != __NR_ptrace)) {
>> +               if (!entryexit) {
>> +               struct siginfo info;
>> +
>> +               memset(&info, 0, sizeof(struct siginfo));
>> +               info.si_signo = SIGSYS;
>> +               info.si_code = SYS_SYSCALL;
>> +               info.si_addr = (void *) regs->orig_ax;
>> +               send_sig_info(SIGSYS, &info, current);
>> +               }
>> +               return 1; /* Skip system call, deliver signal. */
>> +       }
>>     
>
> The indenting here looks messed up.
>   
You are right, I will rework the patch and send it again, it has a lot of
formating errors indeed.
> Also, there looks to be a pretty substantial amount of copy-and-paste
> code in those little if()s.  It's only going to get worse as we add more
> architectures.  If there's ever a little buglet in that bit of code, or
> we need to tweak it it some way, it'll be a bitch to fix.
>
> For instance, if you have a little arch-independent helper like this:
>
> static inline int is_self_ptracing(unsigned long syscall_reg)
> {
> 	if (!(current->ptrace & PT_SELF))
> 		return 0;
> 	if (syscall_reg == __NR_rt_sigreturn)
> 		return 0;
> 	if (syscall_reg == __NR_ptrace)
> 		return 0;
> 	return 1;
> }
>
> You can call it like this:
>
> 	if (is_self_ptracing(regs->gprs[2]))
> ...
> 	if (is_self_ptracing(regs->orig_ax))
> ...
> 	if (is_self_ptracing(regs->orig_rax))
>
> Something similar can probably be done for the siginfo construction.
>   
Yes, thank you it is a good tip.
> You should basically try and think of ways to abstract this stuff every
> single time you touch arch code.  
>
> Why don't you also mention why you really want this feature.  That's
> missing from the description. 
>   
Yes, you are right too, I will rework the patch description too.
> -- Dave
>
>   
Thanks for the comments, I rework the patch.

Pierre

-- 
=============
Pierre Morel
RTOS and Embedded Linux

