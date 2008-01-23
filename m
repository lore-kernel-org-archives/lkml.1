Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbYAWS7Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbYAWS7Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 13:59:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752392AbYAWS7O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 13:59:14 -0500
Received: from bipbip.grupopie.com ([195.23.16.24]:41751 "EHLO
	bipbip.grupopie.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751571AbYAWS7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 13:59:13 -0500
Message-ID: <47978E7D.9060606@grupopie.com>
Date: Wed, 23 Jan 2008 18:59:09 +0000
From: Paulo Marques <pmarques@grupopie.com>
Organization: Grupo PIE
User-Agent: Thunderbird 1.5.0.12 (X11/20070509)
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       David Miller <davem@davemloft.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] POWERPC: use KSYM_NAME_LEN
References: <20080123173832.GA12877@cvg> <479786D4.9080601@grupopie.com> <20080123184343.GG12877@cvg>
In-Reply-To: <20080123184343.GG12877@cvg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cyrill Gorcunov wrote:
> [Paulo Marques - Wed, Jan 23, 2008 at 06:26:28PM +0000]
>> Cyrill Gorcunov wrote:
>>> [...]
>>>  	case 's':
>>> -		getstring(tmp, 64);
>>> +		getstring(tmp, sizeof(tmp));
>>>  		if (setjmp(bus_error_jmp) == 0) {
>>>  			catch_memory_errors = 1;
>>>  			sync();
> 
> just after that poin in the original code a call to kallsyms_lookup_name
> is done - so i think it could be an overflow (of course it depends
> on what *exactly* the name is being searched, and Paulo - I didn't
> managed to get *the whole picture* of what is going on in this
> code - so the thoughs were like: kallsyms_lookup_name could find
> a quite long name restricted by KSYM_NAME_LEN (dunno how it could
> happens - due to buggy code or due to memory corruption outside,
> it does not matter - the only matter - it *could* find that long
> name).

Ah, now I understand your confusion: kallsyms_lookup_name doesn't fill 
the name. It searches the name and returns the address. It is the 
_caller_ that fills the name, not kallsyms_lookup_name.

It is used for stuff like: "give me the address of function foo":
addr = kallsyms_lookup_name("foo");

> Anyway - it's just an attempt ;) we always could drop it far-far away ;)

I think that using KSYM_NAME_LEN would be a nice cleanup for xmon, but 
it is for the powerpc guys to decide if they want to do it. I just 
wanted to point the change in behavior so that it wouldn't go unnoticed.

For all we know, the stack may at that point be close to full and an 
extra 64 bytes may tip it over the edge.

>> This also introduces a change in behavior. It is still a nice cleanup, 
>> though. So, if the powerpc people feel they can spare an extra 64 bytes of 
>> stack here, I guess it's ok.
> 
> Thanks a lot for review Paulo!

No problem. I always keep an eye out for kallsyms related stuff.

-- 
Paulo Marques - www.grupopie.com

"There cannot be a crisis today; my schedule is already full."
