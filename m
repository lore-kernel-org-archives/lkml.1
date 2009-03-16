Return-Path: <linux-kernel-owner+w=401wt.eu-S1752669AbZCPWDo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752669AbZCPWDo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 18:03:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751918AbZCPWDe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 18:03:34 -0400
Received: from gw.goop.org ([64.81.55.164]:40417 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750821AbZCPWDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 18:03:33 -0400
Message-ID: <49BECCB0.4010804@goop.org>
Date: Mon, 16 Mar 2009 15:03:28 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, akataria@vmware.com,
       the arch/x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: VMI broken on tip/master...
References: <1236966968.14680.15.camel@alok-dev1> <1237072800.8939.813.camel@laptop> <alpine.DEB.2.00.0903161200320.26431@gandalf.stny.rr.com>
In-Reply-To: <alpine.DEB.2.00.0903161200320.26431@gandalf.stny.rr.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt wrote:
> On Sun, 15 Mar 2009, Peter Zijlstra wrote:
>   
>> Looking at arch/x86/include/asm/paravirt.h (god I wish paravirt would go
>> away, not only does it screw over ctags, it also hurts my brain), it
>> appears its playing icky games with primitives like
>> raw_local_irq_disable():
>>
>> static inline void raw_local_irq_disable(void)
>> {
>>         asm volatile(paravirt_alt(PARAVIRT_CALL)
>>                      :
>>                      : paravirt_type(pv_irq_ops.irq_disable),
>>                        paravirt_clobber(CLBR_EAX)
>>                      : "memory", "eax", "cc");
>> }
>>
>> So what was supposed to be a simple op, now gets expanded into god knows
>> what, and might lead to tracer recursion or something.
>>     
>
> It should only blow up if a guest is using tracing, and the code to call
> the hypervisor is also being traced.
>
>   
>> Maybe a simple notrace annotation somewhere in that paravirt code is all
>> it takes, who knows.
>>
>> Steve, you've been known to work on virt stuff too, happen to have a
>> bright idea? :-)
>>     
>
> I have noticed that some paravirt ops calls (like this 
> raw_local_irq_disable) does not get inlined. It sometimes gets made into a 
> function.  This would cause raw_local_irq_disable to actually be traced!
>
> One answer is to use "always_inline" or I can dig out a patch that makes 
> inline also include "notrace".

Yes, these should probably be always_inline and notrace (just in case 
gcc gets it into its head that it might be a good idea to put mcount 
calls into inlined functions).

    J
