Return-Path: <linux-kernel-owner+w=401wt.eu-S1759191AbZAWS1h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759191AbZAWS1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 13:27:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbZAWS13
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 13:27:29 -0500
Received: from mail-ew0-f20.google.com ([209.85.219.20]:63775 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753035AbZAWS13 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 13:27:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=QB623k8tw454E5Qfezzz0kfCzQa8Hz+rUleV27XHqOYjZ1oTLX00pbxu+4h9SYSS8g
         2Sk9Q+jmuS3jm1sBbbB66dDMc90qVLjsYrt66BWGseOT7o4zP2humqQigd2sV6eThogU
         ucUIr4fm8jQy/9SA/uEPPzHmiQpduIO7ZM+zU=
Message-ID: <497A0C0A.7080207@gmail.com>
Date: Fri, 23 Jan 2009 20:27:22 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: inline asm semantics: output constraint width smaller than input
References: <497A0500.3080706@gmail.com> <20090123181721.GA32545@elte.hu>
In-Reply-To: <20090123181721.GA32545@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-01-23 20:17, Ingo Molnar wrote:
> * Török Edwin <edwintorok@gmail.com> wrote:
>
>   
>> Hi,
>>
>> I am trying to build the kernel with LLVM 2.5 prerelease (using 
>> llvm-gcc-4.2 frontend), however I am running into some inline asm 
>> semantics issues, and after some discussion on LLVM bugzilla I would 
>> like to know if you would be accepting patches for this: 
>> http://llvm.org/bugs/show_bug.cgi?id=3373
>>
>> The problem is when "a" output constraint is used with a variable of 
>> smaller width than the "0" input constraint.
>>
>> Here are 2 examples:
>>
>> int __ret_pu; unsigned long __pu_val;
>> return   ({asm volatile("call __put_user_" "8" : "=a" (__ret_pu) :"0"
>>                           (__pu_val), "c"(addr) : "ebx"); __ret_pu;});
>>
>>
>> unsigned char return_code;      /* %al */         
>> unsigned long address;          /* %ebx */ 
>> unsigned long length;           /* %ecx */
>> unsigned long entry;            /* %edx */
>> unsigned long flags;
>> __asm__("lcall *(%%edi); cld"
>>                 : "=a" (return_code),
>>                   "=b" (address),
>>                   "=c" (length),
>>                   "=d" (entry)
>>                 : "0" (service),
>>                   "1" (0),
>>                   "D" (&bios32_indirect));
>>
>> There are 2 cases:
>> 1. output is wider than input
>> 2. output is narrower than input
>>
>> Case 2 seems to occur lots of times on 64-bit (due to sizeof(int) != 
>> sizeof(unsigned long)), and a few times on 32-bit as well.
>>
>> Would you accept patches that increase the portability of the inline asm 
>> statements? (essentially by adding casts for case 1, and introducing a 
>> temporary of correct width for case 2).
>>     
>
> i'd not mind it at all if the kernel could be built with other open-source 
> compilers too.
>
> Now in this case the patch you suggest might end up hurting the end result 
> so it's not an unconditional 'yes'. But ... how much it actually matters 
> depends on the circumstances.
>
> So could you please send a sample patch for some of most common inline 
> assembly statements that are affected by this, so that we can see:
>
>    1) how ugly the LLVM workarounds are
>   

Ok, I will prepare a patch for both cases.

>    2) how they affect the generated kernel image in practice
>
> My gut feeling is that it's going to be acceptable with a bit of thinking 
> (we might even do some wrappers to do this cleanly) - but i'd really like 
> to see it before giving you that judgement.
>
> Another question: does LLVM always warn about such input/output aliased 
> constraint width mismatch problems if they occur, or does it silently 
> corrupt the resulting instruction sequence?
>   

With current LLVM it gives an error message in the frontend and refuses
to compile those files.
With LLVM 2.4 unsatistifiable constraints used to lead to an assertion
failure in the backend during code generation, thus also refusing to
compile the file (assertions are enabled in a release build).
However due to changes in the code generator for LLVM 2.5, mismatching
widths for same registers are no longer accepted (I think it was
complicated to support that in the code generator), and they are now
rejected in the frontend instead of the backend.

Having said that, llvm-gcc is not yet able to compile the full Linux
kernel on its own [for example the boot code, due to asm(".code16gcc")],
but with LLVM 2.4 it was
possible to build "arch=UM", and "arch=X86" (by using gcc to build the
bootcode).
I'd like LLVM 2.5 to be able to build the kernel, so I'll file bugs for
llvm/kernel depending on where the problem is.

Best regards,
--Edwin
