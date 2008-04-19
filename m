Return-Path: <linux-kernel-owner+w=401wt.eu-S1761735AbYDSWLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761735AbYDSWLW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Apr 2008 18:11:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751494AbYDSWLN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Apr 2008 18:11:13 -0400
Received: from gw.goop.org ([64.81.55.164]:48255 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbYDSWLN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Apr 2008 18:11:13 -0400
Message-ID: <480A6DD4.8050702@goop.org>
Date: Sun, 20 Apr 2008 08:10:28 +1000
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080407)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andi Kleen <andi@firstfloor.org>, mingo@elte.hu, akpm@osdl.org,
       "H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] x86 NMI-safe INT3 and Page Fault (v7)
References: <20080417164116.GB23351@Krystal> <48087217.50305@goop.org> <20080419212937.GA2831@Krystal>
In-Reply-To: <20080419212937.GA2831@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Jeremy Fitzhardinge (jeremy@goop.org) wrote:
>   
>> Mathieu Desnoyers wrote:
>>     
>>> +/*
>>> + * Only returns from a trap or exception to a NMI context 
>>> (intra-privilege
>>> + * level near return) to the same SS and CS segments. Should be used
>>> + * upon trap or exception return when nested over a NMI context so no 
>>> iret is
>>> + * issued. It takes care of modifying the eflags, rsp and returning to 
>>> the
>>> + * previous function.
>>> + *
>>> + * The stack, at that point, looks like :
>>> + *
>>> + * 0(rsp)  RIP
>>> + * 8(rsp)  CS
>>> + * 16(rsp) EFLAGS
>>> + * 24(rsp) RSP
>>> + * 32(rsp) SS
>>> + *
>>> + * Upon execution :
>>> + * Copy EIP to the top of the return stack
>>> + * Update top of return stack address
>>> + * Pop eflags into the eflags register
>>> + * Make the return stack current
>>> + * Near return (popping the return address from the return stack)
>>> + */
>>> +#define INTERRUPT_RETURN_NMI_SAFE	pushq %rax;		\
>>> +					mov %rsp, %rax;		\
>>> +					mov 24+8(%rax), %rsp;	\
>>> +					pushq 0+8(%rax);	\
>>> +					pushq 16+8(%rax);	\
>>> +					movq (%rax), %rax;	\
>>> +					popfq;			\
>>> +					ret;
>>>   
>>>       
>> I got this right first go?  I must be getting good at this...
>>
>>     
>
> Yes, it looked good to me at least :)
>
>   
>> Anyway, trailing ';', and perhaps use a consistent form for mov (either 
>> movq or mov in all three instances).
>>
>>     
>
> Ok, fixed. Here is the update.
>
> The last issue standing would be the paravirt code. Any ideas about how
> it's best to do it ? It would be good to be able to get the nmi-safe
> version on bare metal, patched with a standard iret emulation in
> paravirt code.
>   

#ifdef CONFIG_PARAVIRT
#define NMI_RETURN   paravirt_nmi_return

/* elsewhere */
    .nmi_return = native_iret_nmi_return;
#else
#define NMI_RETURN   NMI_SAFE_NMI_RETURN
#endif

?

    J
