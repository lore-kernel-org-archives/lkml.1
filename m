Return-Path: <linux-kernel-owner+w=401wt.eu-S1756820AbZAMXKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756820AbZAMXKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbZAMXKT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:10:19 -0500
Received: from gw.goop.org ([64.81.55.164]:40588 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753721AbZAMXKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:10:17 -0500
Message-ID: <496D1F54.7070104@goop.org>
Date: Tue, 13 Jan 2009 15:10:12 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jiri Kosina <jkosina@suse.cz>, Jeremy Fitzhardinge <jeremy@xensource.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: remove byte locks
References: <alpine.LNX.1.10.0901121247430.5377@jikos.suse.cz> <20090112120743.GC24266@elte.hu> <alpine.LNX.1.10.0901121334510.5377@jikos.suse.cz> <20090112124401.GA31939@elte.hu>
In-Reply-To: <20090112124401.GA31939@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Jiri Kosina <jkosina@suse.cz> wrote:
>
>   
>> On Mon, 12 Jan 2009, Ingo Molnar wrote:
>>
>>     
>>>> Remove byte locks implementation, which was introduced by Jeremy in 
>>>> 8efcbab6 ("paravirt: introduce a "lock-byte" spinlock implementation"), 
>>>> but turned out to be dead code that is not used by any in-kernel 
>>>> virtualization guest (Xen uses its own variant of spinlocks implementation 
>>>> and KVM is not planning to move to byte locks).
>>>>
>>>> Signed-off-by: Jiri Kosina <jkosina@suse.cz>
>>>> ---
>>>>  arch/x86/include/asm/paravirt.h      |    2 -
>>>>  arch/x86/include/asm/spinlock.h      |   66 +--------------------------------
>>>>  arch/x86/kernel/paravirt-spinlocks.c |   10 -----
>>>>  3 files changed, 2 insertions(+), 76 deletions(-)
>>>>         
>>> didnt you send a patch in this lkml thread:
>>>
>>>   Subject: Re: Is 386 processor still supported?
>>>       
>>> that makes use of byte-locks on i386 ?
>>>       
>> I did, but that patch was bogus, as we indeed don't support smp on M386.
>>
>> This is totally independent -- it just removes dead code (byte locks) that 
>> has no in-tree user at all.
>>
>>     
>>> But i guess we should solve M386 and M486 by only allowing it on !SMP, 
>>> hence spinlock support is moot there, right?
>>>       
>> Agreed. But that's a different issue.
>>     
>
> ok. Jeremy, can we apply Jiri's patch or do you still have plans with that 
> code?

My intention for that code was always that it be a simplest-possible 
reference implementation for the spinlock pvops, and perhaps a basis for 
a more specialized version (the Xen version is based on byte locks, for 
example). 

The code is "dead" in the sense that it has no users, but it also 
results in no generated code, and should be easy to maintain if the 
spinlock API is changed (as it is a canary to show that the other 
implementations will need changing too).  In particular, the "paravirt 
spinlock" mechanism relies on all implementations using the same static 
initializer, and I wanted there to be an obvious second implementation 
so that if someone decided to change the ticketlock initializer, they'd 
be forced to consider what happens with the bytelock initializer (and by 
extension, any other implementation).

It's also useful as a baseline for benchmarking.

    J
