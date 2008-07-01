Return-Path: <linux-kernel-owner+w=401wt.eu-S1759536AbYGAUXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536AbYGAUXR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2008 16:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755934AbYGAUXB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jul 2008 16:23:01 -0400
Received: from gw.goop.org ([64.81.55.164]:38485 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755681AbYGAUXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2008 16:23:00 -0400
Message-ID: <486A921E.2070306@goop.org>
Date: Tue, 01 Jul 2008 13:22:54 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sean Young <sean@mess.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Rusty Russell <rusty@rustcorp.com.au>,
       linux-kernel@vger.kernel.org
Subject: Re: Regression: boot failure on AMD Elan TS-5500
References: <20080616121138.GA51097@atlantis.8hz.com> <200806162327.34912.rusty@rustcorp.com.au> <48566C88.6000702@goop.org> <20080616161944.GA53539@atlantis.8hz.com> <20080630214347.GA57988@atlantis.8hz.com> <4869558A.9020907@goop.org> <48695871.8000805@zytor.com> <48695F88.9080905@goop.org> <48696167.6050000@zytor.com> <20080701195942.GA76608@atlantis.8hz.com>
In-Reply-To: <20080701195942.GA76608@atlantis.8hz.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sean Young wrote:
> On Mon, Jun 30, 2008 at 03:42:47PM -0700, H. Peter Anvin wrote:
>   
>> Jeremy Fitzhardinge wrote:
>>     
>>> Maybe it really does require the far jump immediately after setting PE 
>>> in cr0...
>>>
>>> Hm, I don't remember this paragraph being in vol 3a, section 8.9.1 
>>> before.  Is it a recent addition?
>>>
>>>   Random failures can occur if other instructions exist between steps
>>>   3 and 4 above.  Failures will be readily seen in some situations,
>>>   such as when instructions that reference memory are inserted between
>>>   steps 3 and 4 while in system management mode.
>>>
>>>       
>> I don't remember that, either.
>>     
>
> Which document are we talking about? 
>   

*The* document ;)
http://www.intel.com/products/processor/manuals/ specifically, Volume 
3a: System Programming Guide, Part 1. 

Section 8.9.1 describes the steps needed to turn on protected mode 
correctly.  It says that you need to do a far jump or call immediately 
after turning on protected mode.  Linux has not done it immediately, and 
there has been a school of thought that this advice is a workaround for 
some obsolete CPU, and is not something we have to worry about now.

However, the paragraph I quoted was added since the previous release of 
the manual, and so presumably documents a current concern.  
Specifically, the mention of SMM is interesting, because I gather that 
embedded-class processors like the Elan are very SMM-dependent.

>> Sean: could you try the following patch?
>>
>> 	-hpa
>>     
>
>   
>> diff --git a/arch/x86/boot/pmjump.S b/arch/x86/boot/pmjump.S
>> index ab049d4..141b6e2 100644
>> --- a/arch/x86/boot/pmjump.S
>> +++ b/arch/x86/boot/pmjump.S
>> @@ -33,6 +33,8 @@ protected_mode_jump:
>>  	movw	%cs, %bx
>>  	shll	$4, %ebx
>>  	addl	%ebx, 2f
>> +	jmp	1f			# Short jump to serialize on 386/486
>> +1:
>>  
>>  	movw	$__BOOT_DS, %cx
>>  	movw	$__BOOT_TSS, %di
>> @@ -40,8 +42,6 @@ protected_mode_jump:
>>  	movl	%cr0, %edx
>>  	orb	$X86_CR0_PE, %dl	# Protected mode
>>  	movl	%edx, %cr0
>> -	jmp	1f			# Short jump to serialize on 386/486
>> -1:
>>  
>>  	# Transition to 32-bit mode
>>  	.byte	0x66, 0xea		# ljmpl opcode
>>     
>
> I'm afraid it doesn't work. Maybe I can find something in the AMD Elan
> documentation. Would a fence make sense?
>   

Not really, but if it fixes the bug it won't hurt anyone else (unless 
older processors treat it as an illegal instruction).

    J
