Return-Path: <linux-kernel-owner+w=401wt.eu-S1761787AbYBLNcB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761787AbYBLNcB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 08:32:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757478AbYBLNbv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 08:31:51 -0500
Received: from mail.windriver.com ([147.11.1.11]:34896 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757413AbYBLNbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 08:31:50 -0500
Message-ID: <47B19F67.5050105@windriver.com>
Date: Tue, 12 Feb 2008 07:30:15 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
References: <20080211015321.GA27376@one.firstfloor.org> <y0mhcgf4ig1.fsf@ton.toronto.redhat.com> <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu>
In-Reply-To: <20080212123839.GA15360@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2008 13:29:51.0966 (UTC) FILETIME=[58E1D7E0:01C86D7B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Andi Kleen <andi@firstfloor.org> wrote:
>
>   
>>> i went for correctness and simplicity first. If a system is hung, 
>>> the debugging CPU might hang too at any time. A timeout on the other 
>>> hand introduces the possibility of a 'dead' CPU just coming back to 
>>> life after the 'timeout', corrupting debugger data. So for now the 
>>> rule is very simple.
>>>       
>> If all code is correct, it likely won't need a debugger. But if you 
>> write a debugger you can't assume that.
>>     
>
> i gave you very specific technological reasons for why we dont want to 
> do spinning for now: we dont _ever_ want to break a correctly working 
> system with kgdb.
>
> A valid counter-argument is _not_ to argue "but it would be nice to have 
> if the system is broken in X, Y and Z ways" (like you did), but to point 
> it out why the behavior we chose is wrong on a correctly working system.
>
> Yes, a buggy system might misbehave in various ways but my primary 
> interest is in keeping correctly working systems correct.
>
> And note that kgdb is not just a "debugger", it's a system inspection 
> tool. An intelligent, human-controlled printk. A kernel internals 
> learning tool. An extension to the kernel console concept. Yes, people 
> frequently use it for debugging too, but the other uses are actually 
> more important in the big picture than the debugging aspect.
>
>   

This is not a technical argument, but I am not a big fan of hard hanging
the system if you cannot sync all the CPUs. The original intent was to
at least provide a sync error message to the end user after some
reasonable time. Then allow someone to collect any data you can get and
you basically have to reboot. The reboot was never forced, but assumed
the end users of this knew what they were doing in the first place.

Certainly in a completely working system where you use kgdb only for
inspection this is not an issue, unless you use a breakpoint or single
step one of the smp_call functions. As we all know there are lots of
ways to crash a perfectly working system.

>   
>>> no, not all architectures have it. This is a weak alias that is 
>>> otherwise not linked into the kernel.
>>>       
>> Can't be very many because oprofile needs it and it works on most 
>> archs now. Anyways, the right thing is to just add it to the 
>> architectures that still miss it, not reimplement it in kgdb.
>>     
>
> it's not reimplemented - kgdb_arch_pc() does not directly map to 
> instruction_pointer().
>
>   

We might be best served to add a comment to explain the purpose of
kgdb_arch_pc() and put it in the optional implementation function
headers in include/linux/kgdb.h

On some archs certain exceptions do not report the address that the
exception occurred at when you call instruction_pointer(). This optional
function allows for an arch to perform a "fixup" to get the address the
exception actually occurred at.

Kgdb requires the actual exception address so a sanity check can be
performed to make sure kgdb did not hit an exception while in a chunk of
code kgdb requires for its functionality. If you hit one of these
conditions kgdb makes its best attempt to try to "patch the wound"
inflicted by shooting yourself but at least you get notified vs a silent
hang :-)

Jason.
