Return-Path: <linux-kernel-owner+w=401wt.eu-S1760140AbXIUOVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760140AbXIUOVS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 10:21:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758636AbXIUOVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 10:21:10 -0400
Received: from bipbip.grupopie.com ([195.23.16.24]:47676 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750981AbXIUOVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 10:21:08 -0400
Message-ID: <46F3D351.2090506@grupopie.com>
Date: Fri, 21 Sep 2007 15:21:05 +0100
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: gilboad@gmail.com
CC: Satyam Sharma <satyam@infradead.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Reduce __print_symbol/sprint_symbol stack usage.
References: <1189856129.18191.11.camel@gilboa-home-dev.localdomain>	 <a781481a0709150602v6be754caw4fbe0f76c8db5beb@mail.gmail.com>	 <1189869329.18191.77.camel@gilboa-home-dev.localdomain>	 <1189879681.18191.93.camel@gilboa-home-dev.localdomain>	 <alpine.LFD.0.999.0709190610540.26241@enigma.security.iitk.ac.in>	 <46F1314B.8040105@grupopie.com> <1190378737.30016.15.camel@gilboa-home-dev.localdomain>
In-Reply-To: <1190378737.30016.15.camel@gilboa-home-dev.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Gilboa Davara wrote:
> Hello Paulo,

Hi, Gilboa

> [snip]
>> [...]
>> if we change the interface from "print_symbol(fmt, addr)" to 
>> "print_symbol(prefix, addr, int newline)" we can simply do:
>>
>> printk(prefix);
>> printk_symbol(addr);
>> if (newline)
>> 	printk("\n");
>>
>> where "printk_symbol" is a new function that does the same as 
>> sprint_symbol, but does "printk" instead of "sprintf".
>>
>> This should reduce immensely the stack usage of print_symbol without the 
>> need for locking.
> 
> I fully agree.
> ... Further more, multiple printk_symbols should be combined into a
> single, multi-line printk transaction. (To prevent debug printk's from
> trashing a BUG() dump_stack). 

Usually the developer can separate the output by hand in the unlikely 
case of simultaneous concurrent users of printk, so I don't think this 
is really a big problem.

>> Of course this requires changing _all_ callers of print_symbol to use 
>> the new interface, but these are less than 100 ;)
> 
> This is my first contribution to the Linux kernel. As such I rather
> start small, and work my way up slowly. (Read: solve the immediate stack
> over-run now, think about changing the symbol_display interface later)

Yes, but this is a sensitive area, so you can not just implement 
something now that can cause regressions, and just fix it later.

Kernel panics are quite rare and the information provided by the stack 
dump is _extremely_ precious.

Even more, risking deadlocks caused by something that should only be 
used to produce debug information is even worse.

>> Comments?
> 
> I do agree that the current interface needs work.
> 
> ... But as I said, I rather start slowly and on small scale. (Though I
> did find a rather problematic place to start at... ;))

Well, if we agree that this is the way to go, then the way to start 
slowly would be to submit a patch that makes both interfaces available 
for a while and changes the most stack-critical callers to the new 
interface.

Then slowly keep submitting patches to change other callers 
progressively until there are no more callers of the old interface. At 
that point we can just drop it entirely.

-- 
Paulo Marques - www.grupopie.com

"God is love. Love is blind. Ray Charles is blind. Ray Charles is God."
