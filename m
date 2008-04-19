Return-Path: <linux-kernel-owner+w=401wt.eu-S1759728AbYDSWkt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759728AbYDSWkt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:40:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752828AbYDSWkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:40:42 -0400
Received: from tomts13-srv.bellnexxia.net ([209.226.175.34]:41871 "EHLO
	tomts13-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752628AbYDSWkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:40:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: At0FAGMRCkhMROPA/2dsb2JhbACBYKhI
Date: Sat, 19 Apr 2008 18:40:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v7)
Message-ID: <20080419224039.GA4439@Krystal>
References: <20080417164116.GB23351@Krystal> <48087217.50305@goop.org> <20080419212937.GA2831@Krystal> <480A6DD4.8050702@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <480A6DD4.8050702@goop.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 18:38:13 up 50 days, 18:49,  5 users,  load average: 0.19, 0.25,
	0.20
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jeremy Fitzhardinge (jeremy@goop.org) wrote:
> Mathieu Desnoyers wrote:
>> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>>   
>>> Mathieu Desnoyers wrote:
>>>     
>>>> +/*
>>>> + * Only returns from a trap or exception to a NMI context 
>>>> (intra-privilege
>>>> + * level near return) to the same SS and CS segments. Should be used
>>>> + * upon trap or exception return when nested over a NMI context so no 
>>>> iret is
>>>> + * issued. It takes care of modifying the eflags, rsp and returning to 
>>>> the
>>>> + * previous function.
>>>> + *
>>>> + * The stack, at that point, looks like :
>>>> + *
>>>> + * 0(rsp)  RIP
>>>> + * 8(rsp)  CS
>>>> + * 16(rsp) EFLAGS
>>>> + * 24(rsp) RSP
>>>> + * 32(rsp) SS
>>>> + *
>>>> + * Upon execution :
>>>> + * Copy EIP to the top of the return stack
>>>> + * Update top of return stack address
>>>> + * Pop eflags into the eflags register
>>>> + * Make the return stack current
>>>> + * Near return (popping the return address from the return stack)
>>>> + */
>>>> +#define INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
>>>> +					mov %rsp, %rax;		\
>>>> +					mov 24+8(%rax), %rsp;	\
>>>> +					pushq 0+8(%rax);	\
>>>> +					pushq 16+8(%rax);	\
>>>> +					movq (%rax), %rax;	\
>>>> +					popfq;			\
>>>> +					ret;
>>>>         
>>> I got this right first go?  I must be getting good at this...
>>>
>>>     
>>
>> Yes, it looked good to me at least :)
>>
>>   
>>> Anyway, trailing ';', and perhaps use a consistent form for mov (either 
>>> movq or mov in all three instances).
>>>
>>>     
>>
>> Ok, fixed. Here is the update.
>>
>> The last issue standing would be the paravirt code. Any ideas about how
>> it's best to do it ? It would be good to be able to get the nmi-safe
>> version on bare metal, patched with a standard iret emulation in
>> paravirt code.
>>   
>
> #ifdef CONFIG_PARAVIRT
> #define NMI_RETURN   paravirt_nmi_return
>
> /* elsewhere */
>    .nmi_return = native_iret_nmi_return;
> #else
> #define NMI_RETURN   NMI_SAFE_NMI_RETURN
> #endif
>
> ?
>

Then I guess we would have to start dealing with faults caused by popf
if it happens to be run before the code patching is done ?

Mathieu

>    J

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
