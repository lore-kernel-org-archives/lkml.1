Return-Path: <linux-kernel-owner+w=401wt.eu-S1755343AbYJJFjZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343AbYJJFjZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2008 01:39:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752225AbYJJFjQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Oct 2008 01:39:16 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:53326 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950AbYJJFjQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2008 01:39:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=n86/0CyEeeNgnXVkeMDtOrh4dGtgaJeA5l3bo0M1KKfqlqdCZxToFypsepXSuD3ZxA
         JlKC++ZrXspY+KpBIQ5KniXG/1Yq4gnv1nfjTDUBHZCmIKBO13c0cgLOnjdXDxxzNRHh
         N5tESEBEiJi8LSKMnbOayv8H9rLaqIYnme2mY=
Message-ID: <aa79d98a0810092239p32153776qd0cda47e54929545@mail.gmail.com>
Date: Fri, 10 Oct 2008 09:39:15 +0400
From: "Cyrill Gorcunov" <gorcunov@gmail.com>
To: "Pallipadi, Venkatesh" <venkatesh.pallipadi@intel.com>
Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081010002203.GA23238@linux-os.sc.intel.com>
	 <aa79d98a0810092138q1f27a94bhd544ca3637c02c4f@mail.gmail.com>
	 <7E82351C108FA840AB1866AC776AEC463782339F@orsmsx505.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2008 at 9:10 AM, Pallipadi, Venkatesh
<venkatesh.pallipadi@intel.com> wrote:
>
>
>>-----Original Message-----
>>From: Cyrill Gorcunov [mailto:gorcunov@gmail.com]
>>Sent: Thursday, October 09, 2008 9:38 PM
>>To: Pallipadi, Venkatesh
>>Cc: Ingo Molnar; Thomas Gleixner; H. Peter Anvin; linux-kernel
>>Subject: Re: [PATCH] Typo in x86 apic.c with DIVISOR setup
>>
>>On Fri, Oct 10, 2008 at 4:22 AM, Venki Pallipadi
>><venkatesh.pallipadi@intel.com> wrote:
>>>
>>> Fix a typo in x86 apic.c CONFG_X86_64 -> CONFIG_X86_64.
>>> The intention looks like was to have divisor of 1 on x86_64 kernel.
>>>
>>> Also, for DIVISOR value of 1 to work, APIC_TDR_DIV should also change
>>> depending on divide by 1 or divide by 16 is used.
>>>
>>> Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
>>>
>>> ---
>>>  arch/x86/kernel/apic.c |    6 ++++--
>>>  1 file changed, 4 insertions(+), 2 deletions(-)
>>>
>>> Index: tip/arch/x86/kernel/apic.c
>>> ===================================================================
>>> --- tip.orig/arch/x86/kernel/apic.c     2008-10-09
>>17:12:39.000000000 -0700
>>> +++ tip/arch/x86/kernel/apic.c  2008-10-09 17:13:29.000000000 -0700
>>> @@ -332,10 +332,12 @@ int lapic_get_maxlvt(void)
>>>  */
>>>
>>>  /* Clock divisor */
>>> -#ifdef CONFG_X86_64
>>> +#ifdef CONFIG_X86_64
>>>  #define APIC_DIVISOR 1
>>> +#define APIC_TDR_DIV APIC_TDR_DIV_1
>>>  #else
>>>  #define APIC_DIVISOR 16
>>> +#define APIC_TDR_DIV APIC_TDR_DIV_16
>>>  #endif
>>>
>>>  /*
>>> @@ -369,7 +371,7 @@ static void __setup_APIC_LVTT(unsigned i
>>>        tmp_value = apic_read(APIC_TDCR);
>>>        apic_write(APIC_TDCR,
>>>                (tmp_value & ~(APIC_TDR_DIV_1 |
>>APIC_TDR_DIV_TMBASE)) |
>>> -               APIC_TDR_DIV_16);
>>> +               APIC_TDR_DIV);
>>>
>>>        if (!oneshot)
>>>                apic_write(APIC_TMICT, clocks / APIC_DIVISOR);
>>>
>>
>>Hi Venki,
>>
>>you know I don't have code under my hands now to take a look on
>>(i'm in office now) -- but if I recall correctly it's not a typo :) By
>>writting (1) instead of (16) you make counter decrease faster by
>>16 times (if to compare with what we have now). So we could get
>>counter underflow before we've finish calibration. That is was the
>>original intension of this 16 divisor being used. Did you test this
>>patch?
>>
>
> Typo part I mentioned was this
>
>>> -#ifdef CONFG_X86_64
>>> +#ifdef CONFIG_X86_64
>
> Looks like intention was to use DIVISOR of 1 for x86_64 and divisor of
> 16 for 32 bit kernel. Once I changed that, there was still one place in
> 64 bit code that was assuming divisor of 16. The rest of the patch
> changes that part.
>
> Yes. Tested this patch on couple of systems here and worked fine.
>
> Thanks,
> Venki

Ah, it was CONFG who is guilty :) This is true indeed, thanks!

But here is not the same

       apic_write(APIC_TDCR,
               (tmp_value & ~(APIC_TDR_DIV_1 | APIC_TDR_DIV_TMBASE)) |
-               APIC_TDR_DIV_16);
+               APIC_TDR_DIV);

On x86_64 it will be 1 now but we've used 16 for a long time in purpose
to slowdown processor's bus CLKs from APIC point of view. So I don't think
it's good idea to change it now. If we start using divisor 1 today -- it would
work for some time 'till processor bus raised to the some speed when
we'll get counter underflow before calibration finished.

So could you please split the patch into two:
1) Plain CONFG typo fix (which is completely Ack'ed)
2) APIC divisor patch (which I'm not sure if we've to touch)

Thanks,
Cyrill
