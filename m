Return-Path: <linux-kernel-owner+w=401wt.eu-S1761227AbYBLQWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761227AbYBLQWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 11:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYBLQWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 11:22:11 -0500
Received: from mail.windriver.com ([147.11.1.11]:42113 "EHLO mail.wrs.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754843AbYBLQWK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 11:22:10 -0500
Message-ID: <47B1C76F.6070908@windriver.com>
Date: Tue, 12 Feb 2008 10:21:03 -0600
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20071022)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Frank Ch. Eigler" <fche@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [git pull] kgdb-light -v10
References: <20080211162141.GA31434@elte.hu> <20080211171039.GA20446@one.firstfloor.org> <20080211230335.GA16102@elte.hu> <20080212100327.GA30873@one.firstfloor.org> <20080212112747.GA1569@elte.hu> <20080212121903.GA419@one.firstfloor.org> <20080212123839.GA15360@elte.hu> <47B19F67.5050105@windriver.com> <20080212143949.GA2258@one.firstfloor.org> <47B1AEC3.2080402@windriver.com> <20080212153612.GA2944@one.firstfloor.org>
In-Reply-To: <20080212153612.GA2944@one.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Feb 2008 16:20:40.0822 (UTC) FILETIME=[35AD2960:01C86D93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
>> Basically when you reach this chunk of code it is before the hand off
>> to the source debugger.  We cannot continue because there was a
>> breakpoint in a part of the system kgdb was using while doing its
>> normal work.  The reality is that KGDB is not self contained.  It
>> relies on some external I/O methods, atomic page fault handling and
>> some other pieces.  If you take an exception there, the kgdb integrity
>> check absolutely needs to fail.
>>     
>
> Don't you just need a simple recursion counter for this? 
>
> I cannot think of a reliable simple way to check for this using the instruction
> pointer. The only way would be to use explicit annotations for all
> possible code similar to what kprobes does (__kprobes), but that would be 
> hugely intrusive all over the tree.
>
> With the recursion counter the only problem would be someone 
> setting a break point on the early notifier code itself that contains
> a recursion check, but that would be only a few lines of code
> so the risk of someone setting a break point exactly there would
> be low.
>   

It is more than a simple recursion check (which is already in the code)
because there are some conditions we can recover from.  I'd rather not
crash the system out if it can be recovered.

kgdb_reenter_check() has the "simple" recursion check with the
exception_level variable.

It also has several special checks against the breakpoint situation I
described before as well as trying to remove all the breakpoints.  
Ultimately if all those checks fails, it results in panic, because at
the end of the day that is all you can do if you re-enter the debugger
from the debugger (IE: you are toast).

I don't see any reason to change the code there unless it can be further
improved some way.  We want to fail loudly and verbosely when this kind
of thing happens so we can determine if it was the end user that caused
the problem or if there is a real defect.

Jason.
