Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZEMCb0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZEMCb0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 22:31:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342AbZEMCbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 22:31:16 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:61551 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbZEMCbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 22:31:16 -0400
Message-ID: <4A0A2E57.7080709@ct.jp.nec.com>
Date: Wed, 13 May 2009 11:20:07 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: Subrata Modak <subrata@linux.vnet.ibm.com>
CC: x86@kernel.org, Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: Re: [PATCH] Fix Warnining in arch/x86/kernel/signal.c
References: <20090512155637.19380.9114.sendpatchset@subratamodak.linux.ibm.com>
In-Reply-To: <20090512155637.19380.9114.sendpatchset@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> Hi,
> 
>> On Tue, 2009-05-12 at 17:16 +0200, Andi Kleen wrote:
>> On Tue, May 12, 2009 at 05:16:14PM +0530, Subrata Modak wrote:
>>
>> Hi Subrata,
>>
>>> With gcc (GCC) 4.4.1 20090429 (prerelease), i get the following build warning:
>> Patch looks good (you can add a 
>> Reviewed-by: Andi Kleen <ak@linux.intel.com>)
>> But I don't maintain this code anymore. Please resend to x86@kernel.org
>> cc linux-kernel@vger.kernel.org for merge.
>>
>> Thanks,
>>
>> -Andi
> 
> 
> With gcc (GCC) 4.4.1 20090429 (prerelease), i get the following build warning:
> 
> CC      arch/x86/kernel/signal.o
> arch/x86/kernel/signal.c: In function ‘sys_sigreturn’:
> arch/x86/kernel/signal.c:573: warning: ‘set.sig[1]’ may be used uninitialized in this function
> 
> On investigation i found that this is because of the evaluation
> precedence of the expression below:
> 
> 569 unsigned long sys_sigreturn(struct pt_regs *regs)
> 570 {
> 571         struct sigframe __user *frame;
> 572         unsigned long ax;
> 573         sigset_t set;
> 574 
> 575         frame = (struct sigframe __user *)(regs->sp - 8);
> 576 
> 577         if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
> 578                 goto badframe;
> 579         if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
> 580                 && __copy_from_user(&set.sig[1], &frame->extramask,
> 581                                     sizeof(frame->extramask))))
> 
> The initialization for set.sig[1] may not occur if
> 	__get_user(set.sig[0], &frame->sc.oldmask)
> evalutes to true. So, the compiler is complaining.
> 
> I have devised a small patch for this which wanes away this warning
> without changing the conditional evaluation criteria. Let me know if
> you like this patch.
> 
> 582                 goto badframe;
> 583 
> 584         sigdelsetmask(&set, ~_BLOCKABLE);
> 585         spin_lock_irq(&current->sighand->siglock);
> 586         current->blocked = set;
> 587         recalc_sigpending();
> 588         spin_unlock_irq(&current->sighand->siglock);
> 589 
> 590         if (restore_sigcontext(regs, &frame->sc, &ax))
> 591                 goto badframe;
> 592         return ax;
> 593 
> 594 badframe:
> 595         signal_fault(regs, frame, "sigreturn");
> 596 
> 597         return 0;
> 598 }
> 
> Signed-Off-By: Subrata Modak <subrata@linux.vnet.ibm.com>
> Reviewed-by: Andi Kleen <ak@linux.intel.com>
> To: <x86@kernel.org>
> Cc: Linux Kernel <linux-kernel@vger.kernel.org>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Sachin P Sant <sachinp@linux.vnet.ibm.com>
> Subject: [PATCH] Fix Warnining in arch/x86/kernel/signal.c
> ---
> 
> --- a/arch/x86/kernel/signal.c	2009-05-12 10:59:24.000000000 +0530
> +++ b/arch/x86/kernel/signal.c	2009-05-12 16:57:32.000000000 +0530
> @@ -576,9 +576,10 @@ unsigned long sys_sigreturn(struct pt_re
>  
>  	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
>  		goto badframe;
> -	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
> -		&& __copy_from_user(&set.sig[1], &frame->extramask,
> -				    sizeof(frame->extramask))))
> +
> +        if ( (__copy_from_user(&set.sig[1], &frame->extramask,
> +                sizeof(frame->extramask)) && _NSIG_WORDS > 1) || 
> +                __get_user(set.sig[0], &frame->sc.oldmask))
>  		goto badframe;

I'm not sure why this eliminates that warning.
set.sig[0] may not be initialized too, if __copy_from_user() failed.
I don't have enough time to look at this right now, sorry.

Another question, __copy_from_user() will be called even if
_NSIG_WORDS is less than 2, perhaps it never occurs.
I think, to check _NSIG_WORDS > 1 before calling __copy_from_user()
is better.

Thanks,
Hiroshi

