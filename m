Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbXJOQrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbXJOQrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2007 12:47:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757951AbXJOQq6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Oct 2007 12:46:58 -0400
Received: from il.qumranet.com ([82.166.9.18]:58788 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755291AbXJOQq5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2007 12:46:57 -0400
Message-ID: <47139959.7090900@qumranet.com>
Date: Mon, 15 Oct 2007 18:46:17 +0200
From: Avi Kivity <avi@qumranet.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Laurent Vivier <Laurent.Vivier@bull.net>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND 2][PATCH 4/4] Modify KVM to update guest time	accounting.
References: <46E550EF.5080209@bull.net> <20071015093800.GA22818@elte.hu> <47133732.2090809@qumranet.com> <20071015095125.GB28367@elte.hu> <47133ABD.8050608@qumranet.com> <471346B0.8050102@bull.net> <47134BCE.1080306@qumranet.com> <4713510D.2050208@bull.net> <471357E4.90904@qumranet.com> <47135D1B.1060004@bull.net>
In-Reply-To: <47135D1B.1060004@bull.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Laurent Vivier wrote:
> Avi Kivity wrote:
>   
>> Laurent Vivier wrote:
>>
>>  
>>
>>     
>>>> But if we didn't get an interrupt in that time?
>>>>
>>>> We can clear it a bit later, after local_irq_enable() in
>>>> __vcpu_run(). However we need a nop instruction first because "sti"
>>>> keeps interrupts
>>>> disabled for one more instruction.
>>>>     
>>>>         
>>> IMHO, I think it is better to let kvm_guest_exit() empty (you can
>>> remove it, if
>>> you want):
>>>
>>> 1st case:
>>> - unset PF_VCPU in kvm_guest_exit(), all the tick is always for system
>>> time.
>>> Guest time is always 0.
>>>
>>> 1st case and half:
>>>
>>> - like 1st case but we move kvm_guest_exit() as you propose and the
>>> reason of
>>> the interrupt is the tick interrupt. The tick is for guest time only.
>>> I think
>>> the probability is very low.
>>>   
>>>       
>> If the guest is executing for 10% of the time, the probability is
>> exactly 10%, no?
>>     
>
> I think you know that better than me.
>
> But is there homogeneity in probability ?
>   

It's exactly the same issue as with systime and usertime.  The interrupt 
samples the program counter at various points at a fairly low frequency 
(milliseconds) while syscalls last a few dozens of microseconds.  
Probability makes it average out correctly in the end.

[Ingo, what about dyntick?  suppose you have just one process that calls 
read() from /dev/zero repeatedly.  There'd be very few (or no) 
interrupts -- what happens to accounting accuracy?]

> I mean, if the guest has a lot I/O, it is interrupted by them and the
> probability to be interrupted by a tick is lower than the time passed in the VCPU ?
>   

Suppose the time to service the I/O is exactly equal to the amount 
running in guest mode.   Then the probability of the interrupt happening 
in guest mode is equal to it happening outside guest mode and you'd get 
50% guest, 50% system/user, which is what you want.


>   
>>> 2nd case:
>>> - don't unset PF_VCPU in kvm_guest_exit(), all the tick is for guest
>>> time.
>>>   
>>>       
>> But then even execution in ->handle_exit() is accounted as guest time,
>> which is wrong.
>>     
>
> System time and User time are wrong too as the tick is accounted to the side
> where it appears, even if CPU has executed code from the other side in a
> sub-part of the tick. It's not a good argument.
>   

It's at least consistent... the same errors for everyone, so it averages 
out in the end.

-- 
error compiling committee.c: too many arguments to function

