Return-Path: <linux-kernel-owner+w=401wt.eu-S1762083AbYEETVg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762083AbYEETVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 15:21:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752731AbYEETVZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 15:21:25 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:58061 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755916AbYEETVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 15:21:24 -0400
Message-ID: <481F5E2F.1030806@grupopie.com>
Date: Mon, 05 May 2008 20:21:19 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.14 (X11/20071210)
MIME-Version: 1.0
To: Sebastian Siewior <lkml@ml.breakpoint.cc>
CC: Greg Ungerer <gerg@snapgear.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, gerg@uclinux.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] m68knommu: add pretty back strace
References: <200805010216.m412GcUQ004101@goober> <481B6B3D.9060200@grupopie.com> <20080502211038.GB22631@Chamillionaire.breakpoint.cc>
In-Reply-To: <20080502211038.GB22631@Chamillionaire.breakpoint.cc>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Siewior wrote:
> * Paulo Marques | 2008-05-02 20:27:57 [+0100]:
> 
>> Greg Ungerer wrote:
>>> From: Sebastian Siewior <bigeasy@linutronix.de>
>>> With this patch and
>>>  CONFIG_FRAME_POINTER=y
>>>  CONFIG_KALLSYMS=y
>>> The backtrace shows resolved function names and their numeric
>>> address.
>> This is really not my area, but this patch reminds me of all the dwarf2 
>> unwinder on x86 that caused so many problems in the beginning...
>>
>>> [...]
>>> +#ifdef CONFIG_FRAME_POINTER
>>> +	printk(KERN_EMERG "Call Trace:\n");
>>> +
>>> +	last_stack = stack - 1;
>>> +	while (stack <= endstack && stack > last_stack) {
>>> +
>>> +		addr = *(stack + 1);
>>> +		printk(KERN_EMERG " [%08lx] ", addr);
>>> +		print_symbol(KERN_CONT "%s\n", addr);
>>> +
>>> +		last_stack = stack;
>>> +		stack = (unsigned long *)*stack;
>>>  	}
>>>  	printk("\n");
>>> +#else
>>> +	printk(KERN_EMERG "CONFIG_FRAME_POINTER disabled, no symbolic call 
>>> trace\n");
>> You could probably fall back to the old method in this case, no?
> The old method printed every value from stack which was in the text
> range (you didn't get modules AFAIK). This might be the caller as well a
> function pointer as argument as well something else. I tried to find to
> find a pattern without frame pointers but I had no luck. I thing the
> caller fixed the stack frame or something.
> Greg did not complain about removing it. If you or others want the old
> method in case of no frame pointers I can send a patch.

Having output garbled with "false positive" addresses, but that have the 
"true positives" in between is better than no output at all.

>> Also, if the stack is slightly corrupted on the top, the new method might 
>> just bail out without giving any indication about the path that lead there, 
>> when instead it could also fall back to the old method.
> You mean by slightly that the first caller ORed the address with
> something? 

Or more commonly, a buffer overflow... (or underflow, depending on how 
the stack grows)

> In that case we don't return safely. I don't know how I could
> find out the right time for a fallback (in case of slightly corrupted
> stack).

I was imagining you would get a page fault where you'd show a stack 
trace, but that's on a MMU processor. With no MMU I guess you don't get 
a chance to do that :(

As I said before, this is really not my area. I just remember that a 
very similar change in x86 was a real pain, and wanted to make sure that 
everyone here was aware of that.

-- 
Paulo Marques - www.grupopie.com

"Who is general Failure and why is he reading my disk?"
