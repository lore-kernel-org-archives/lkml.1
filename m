Return-Path: <linux-kernel-owner+w=401wt.eu-S1755449AbZEKPFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755449AbZEKPFf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 11:05:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753456AbZEKPFY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 11:05:24 -0400
Received: from mx2.redhat.com ([66.187.237.31]:54132 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753340AbZEKPFX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 11:05:23 -0400
Message-ID: <4A083E9D.2040003@redhat.com>
Date: Mon, 11 May 2009 18:05:01 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>, Mark Langsdorf <mark.langsdorf@amd.com>,
       Joerg Roedel <joerg.roedel@amd.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH][KVM][retry 1] Add support for Pause Filtering to AMD
 SVM
References: <200905050909.58583.mark.langsdorf@amd.com>	 <20090507135522.GJ4059@amd.com> <200905071000.14038.mark.langsdorf@amd.com>	 <4A02FECC.6060609@redhat.com> <20090511141503.GC6175@elte.hu>	 <4A083539.407@redhat.com> <1242052937.11251.275.camel@twins>
In-Reply-To: <1242052937.11251.275.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Mon, 2009-05-11 at 17:24 +0300, Avi Kivity wrote:
>
>   
>>> I.e. this is a somewhat poor solution as far as scheduling goes. But 
>>> i'm wondering what the CPU side does. Can REP-NOP really take 
>>> thousands of cycles? If yes, under what circumstances?
>>>   
>>>       
>> The guest is running rep-nop in a loop while trying to acquire a 
>> spinlock.  The hardware detects this (most likely, repeated rep-nop with 
>> the same rip) and exits.  We can program the loop count; obviously if 
>> we're spinning for only a short while it's better to keep spinning while 
>> hoping the lock will be released soon.
>>
>> The idea is to detect that the guest is not making forward progress and 
>> yield.  If I could tell the scheduler, you may charge me a couple of 
>> milliseconds, I promise not to sue, that would be ideal.  Other tasks 
>> can become eligible, hopefully the task holding the spinlock, and by the 
>> time we're scheduled back the long running task will have finished and 
>> released the lock.
>>
>> For newer Linux as a guest we're better off paravirtualizing this, so we 
>> can tell the host which vcpu holds the lock; in this case kvm will want 
>> to say, take a couple milliseconds off my account and transfer it to 
>> this task (so called directed yield).  However there's no reason to 
>> paravirtualize all cpu_relax() calls.
>>     
>
> So we're now officially giving up on (soft) realtime virtualization?
>
>   

Wouldn't realtime guests be in a realtime scheduling class?  That ought 
to ignore this time_yield() (or however it is eventually named).

-- 
error compiling committee.c: too many arguments to function

