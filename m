Return-Path: <linux-kernel-owner+w=401wt.eu-S1757442AbZAXTbW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757442AbZAXTbW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2009 14:31:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbZAXTbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Jan 2009 14:31:08 -0500
Received: from mail-out4.apple.com ([17.254.13.23]:52811 "EHLO
	mail-out4.apple.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752966AbZAXTbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2009 14:31:07 -0500
X-Greylist: delayed 466 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Jan 2009 14:31:07 EST
X-AuditID: 11807134-a4853bb000000ff0-c8-497b6aa77c57
Cc: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Message-Id: <9A54B928-B0FA-46E9-B963-E24C642F09DA@apple.com>
From: Chris Lattner <clattner@apple.com>
To: LLVM Developers Mailing List <llvmdev@cs.uiuc.edu>
In-Reply-To: <20090124172758.GA31699@elte.hu>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: [LLVMdev] inline asm semantics: output constraint width smaller than	input
Date: Sat, 24 Jan 2009 11:23:18 -0800
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu> <497A0C0A.7080207@gmail.com> <497B408C.20802@gmail.com> <20090124172758.GA31699@elte.hu>
X-Mailer: Apple Mail (2.929.2)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 24, 2009, at 9:27 AM, Ingo Molnar wrote:

>> #define __put_user_size(x, ptr, size, retval, errret)            \
>> diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
>> index f456860..12d27f8 100644
>> --- a/arch/x86/lib/delay.c
>> +++ b/arch/x86/lib/delay.c
>> @@ -112,7 +112,7 @@ EXPORT_SYMBOL(__delay);
>>
>> inline void __const_udelay(unsigned long xloops)
>> {
>> -    int d0;
>> +    unsigned long d0;
>>
>>     xloops *= 4;
>>     asm("mull %%edx"
>
> Is this all that you need (plus the 16-bit setup code tweaks) to get  
> LLVM
> to successfully build a 64-bit kernel image?
>
> If yes then this doesnt look all that bad or invasive at first sight  
> (if
> the put_user() workaround can be expressed in a cleaner way), but in  
> any
> case it would be nice to hear an LLVM person's opinion about roughly  
> when
> this is going to be solved in LLVM itself.

Hi Ingo,

We would like to support some more specific cases (e.g. when tying a  
pointer/int to a different size pointer/int) but we currently don't  
intend to support all cases (e.g. tying a FP value to int).  We are in  
this position because the semantics are very vague and hard to reason  
about (and change based on target endianness) and we had many subtle  
bugs in the corner cases.

Instead of having silent miscompiles, we decided to just reject all  
the "hard" cases and add them back one by one as there is demand.   
That way users could choose to modify their asms instead of having  
them be potentially silently miscompiled.

LLVM 2.5 is in its release process right now, so it will not have  
improvements in this area, but LLVM 2.6 certainly could.  If there is  
interest in building the kernel with 2.5, I think taking the patches  
would be worthwhile.  If that is hopeless anyway, waiting for the LLVM- 
side fixes should be fine.

-Chris
