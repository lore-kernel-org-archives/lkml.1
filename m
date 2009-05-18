Return-Path: <linux-kernel-owner+w=401wt.eu-S1755867AbZERDlq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867AbZERDlq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 May 2009 23:41:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755109AbZERDlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 May 2009 23:41:36 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:56682 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753621AbZERDlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 May 2009 23:41:36 -0400
Message-ID: <4A10D7CE.90005@ct.jp.nec.com>
Date: Mon, 18 May 2009 12:36:46 +0900
From: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
User-Agent: Thunderbird 2.0.0.21 (Windows/20090302)
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: "H. Peter Anvin" <hpa@zytor.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] Fix Warnining in arch/x86/kernel/signal.c
References: <20090514091247.32082.38639.sendpatchset@subratamodak.linux.ibm.com>	 <4A0CE250.9050703@ct.jp.nec.com> <1242382591.7224.40.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1242382591.7224.40.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
> On Fri, 2009-05-15 at 12:32 +0900, Hiroshi Shimamoto wrote:
>> Subrata Modak wrote:
>>> Hello Hiroshi-san,
>>>
>>> On Thu, 2009-05-14 at 09:24 +0900, Hiroshi Shimamoto wrote:
>>> H. Peter Anvin wrote:
>>>>> Ingo Molnar wrote:
>>>>>>>>>  
>>>>>>>>>         if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
>>>>>>>>>                 goto badframe;
>>>>>>>>> -       if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
>>>>>>>>> -               && __copy_from_user(&set.sig[1], &frame->extramask,
>>>>>>>>> -                                   sizeof(frame->extramask))))
>>>>>>>>> +
>>>>>>>>> +        if ( (__copy_from_user(&set.sig[1], &frame->extramask,
>>>>>>>>> +                sizeof(frame->extramask)) && _NSIG_WORDS > 1) || 
>>>>>>>>> +                __get_user(set.sig[0], &frame->sc.oldmask))
>>>>>>>>>                 goto badframe;
>>>>>>>> I'm not sure why this eliminates that warning.
>>>>>>>> set.sig[0] may not be initialized too, if __copy_from_user() failed.
>>>>>>> True, but only when either or both of __copy_from_user() and
>>>>>>> (_NSIG_WORDS > 1) fails. But in all instances set.sig[1] gets
>>>>>>> initialized.
>>>>>>>
>>>>>>>> I don't have enough time to look at this right now, sorry.
>>>>>>>>
>>>>>>>> Another question, __copy_from_user() will be called even if
>>>>>>>> _NSIG_WORDS is less than 2, perhaps it never occurs.
>>>>>>>> I think, to check _NSIG_WORDS > 1 before calling __copy_from_user()
>>>>>>>> is better.
>>>>>>> Fine. Let Ingo/Thomas/Peter decide whether they would like this fix or
>>>>>>> drop it.
>>>>>> If you get the Acked-by from Hiroshi-san it looks good to me. He 
>>>>>> modified this code last.
>>>>>>
>>>>> This seriously looks wrong to me.  If _NSIG_WORDS == 1, then calling
>>>>> __copy_from_user here is a serious error.
>>>> Right. If _NSIG_WORDS is 1, sigset_t set has only sig[0], writing to
>>>> set.sig[1] means stack corruption.
>>>>
>>>> Subrata, could you try like this?
>>>> if ((_NSIG_WORDS > 1 && __copy_from_user(&set.sig[1], ...) ||
>>>>       __get_user(set.sig[0], ...))
>>>>
>>>>
>>> How about now ? Thanks for pointing that out. My mistake ;-)
>> Hi Subrata, I have a question.
>> Have you tried to compile on x86_64 whether the compiler claims the
>> similar code in sys32_sigreturn() in arch/x86/ia32/ia32_signal.c?
> 
> Oops. No, the compiler does not complain here. It simply compiles fine. 
> 
> So, do you want to take a different view for the patch against
> arch/x86/kernel/signal.c, or, i would resend it with the following
> things fixed:

If you don't think this fix is urgent, could you please check whether
that warning is false positive on 32bit or gcc for 64bit has an issue
not to complain against ia32 part?

I think arch/x86/kernel/signal.c and arch/x86/ia32/ia32_signal.c should
have the same code.

Thanks,
Hiroshi
