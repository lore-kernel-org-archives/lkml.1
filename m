Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbYEFEwh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbYEFEwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 00:52:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751142AbYEFEw1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 00:52:27 -0400
Received: from rex.securecomputing.com ([203.24.151.4]:33279 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750855AbYEFEw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 00:52:26 -0400
Message-ID: <481FE403.9080608@snapgear.com>
Date: Tue, 06 May 2008 14:52:19 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Paulo Marques <pmarques@grupopie.com>
CC: Sebastian Siewior <lkml@ml.breakpoint.cc>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: add pretty back strace
References: <200805010216.m412GcUQ004101@goober> <481B6B3D.9060200@grupopie.com> <20080502211038.GB22631@Chamillionaire.breakpoint.cc> <481F5E2F.1030806@grupopie.com>
In-Reply-To: <481F5E2F.1030806@grupopie.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paulo,

Paulo Marques wrote:
> Sebastian Siewior wrote:
>> * Paulo Marques | 2008-05-02 20:27:57 [+0100]:
>>
>>> Greg Ungerer wrote:
>>>> From: Sebastian Siewior <bigeasy@linutronix.de>
>>>> With this patch and
>>>>  CONFIG_FRAME_POINTER=y
>>>>  CONFIG_KALLSYMS=y
>>>> The backtrace shows resolved function names and their numeric
>>>> address.
>>> This is really not my area, but this patch reminds me of all the 
>>> dwarf2 unwinder on x86 that caused so many problems in the beginning...
>>>
>>>> [...]
>>>> +#ifdef CONFIG_FRAME_POINTER
>>>> +    printk(KERN_EMERG "Call Trace:\n");
>>>> +
>>>> +    last_stack = stack - 1;
>>>> +    while (stack <= endstack && stack > last_stack) {
>>>> +
>>>> +        addr = *(stack + 1);
>>>> +        printk(KERN_EMERG " [%08lx] ", addr);
>>>> +        print_symbol(KERN_CONT "%s\n", addr);
>>>> +
>>>> +        last_stack = stack;
>>>> +        stack = (unsigned long *)*stack;
>>>>      }
>>>>      printk("\n");
>>>> +#else
>>>> +    printk(KERN_EMERG "CONFIG_FRAME_POINTER disabled, no symbolic 
>>>> call trace\n");
>>> You could probably fall back to the old method in this case, no?
>> The old method printed every value from stack which was in the text
>> range (you didn't get modules AFAIK). This might be the caller as well a
>> function pointer as argument as well something else. I tried to find to
>> find a pattern without frame pointers but I had no luck. I thing the
>> caller fixed the stack frame or something.
>> Greg did not complain about removing it. If you or others want the old
>> method in case of no frame pointers I can send a patch.
> 
> Having output garbled with "false positive" addresses, but that have the 
> "true positives" in between is better than no output at all.

Yes that is a reasonable argument.

But you still get the full stack hex dump, so all the raw information
is there still. Just not in a decoded form. (I tended to use the raw
dump more often myself anyway).


>>> Also, if the stack is slightly corrupted on the top, the new method 
>>> might just bail out without giving any indication about the path that 
>>> lead there, when instead it could also fall back to the old method.
>> You mean by slightly that the first caller ORed the address with
>> something? 
> 
> Or more commonly, a buffer overflow... (or underflow, depending on how 
> the stack grows)
> 
>> In that case we don't return safely. I don't know how I could
>> find out the right time for a fallback (in case of slightly corrupted
>> stack).
> 
> I was imagining you would get a page fault where you'd show a stack 
> trace, but that's on a MMU processor. With no MMU I guess you don't get 
> a chance to do that :(
> 
> As I said before, this is really not my area. I just remember that a 
> very similar change in x86 was a real pain, and wanted to make sure that 
> everyone here was aware of that.

I would have no problem with the original full symbolic decode
being in as a fall back for the non FRAME_POINTER case.

Regards
Greg



------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
Secure Computing Corporation                PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
