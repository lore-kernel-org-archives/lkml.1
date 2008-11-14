Return-Path: <linux-kernel-owner+w=401wt.eu-S1754917AbYKNVzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917AbYKNVzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 16:55:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751505AbYKNVzq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 16:55:46 -0500
Received: from az33egw02.freescale.net ([192.88.158.103]:41595 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYKNVzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 16:55:46 -0500
Date: Fri, 14 Nov 2008 13:46:42 -0800 (PST)
From: Trent Piepho <tpiepho@freescale.com>
X-X-Sender: xyzzy@t2.domain.actdsltmp
To: Andrew Morton <akpm@linux-foundation.org>
cc: Trent Piepho <tpiepho@freescale.com>, djwong@us.ibm.com,
       khali@linux-fr.org, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org
Subject: Re: [lm-sensors] [PATCH 1/2] Create a DIV_ROUND_CLOSEST macro to do
 division with rounding
In-Reply-To: <20081111160854.3027c50d.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0811141334150.11673@t2.domain.actdsltmp>
References: <20081111010132.1730.76566.stgit@elm3a70.beaverton.ibm.com>
 <Pine.LNX.4.64.0811111459300.24267@t2.domain.actdsltmp>
 <20081111152007.ff508e26.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0811111539480.24267@t2.domain.actdsltmp>
 <20081111160854.3027c50d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2008, Andrew Morton wrote:
>>>>> +#define DIV_ROUND_CLOSEST(x, divisor)(			\
>>>>> +{							\
>>>>> +	typeof(divisor) __divisor = divisor;		\
>>>>> +	(((x) + ((__divisor) / 2)) / (__divisor));	\
>>>>> +}							\
>>>>> +)
>>>>
>>>> Maybe you can do away with the statement-expression extension?  I've seen
>>>> cases where it cases gcc to generate worse code.  It seems like it
>>>> shouldn't, but it does.  I know DIV_ROUND_CLOSEST (maybe DIV_ROUND_NEAR?)
>>>> uses divisor twice, but all the also divide macros do that too, so why does
>>>> this one need to be different?
>>>
>>> The others need fixing too.
>>
>> Is it worth generating worse code for these simple macros?
>
> Well that's an interesting question.
>
> The risks with the current code are
>
> a) It will introduce straightforward bugs, where pointers are
>   incremented twice, etc.
>
>   Hopefully these things will be apparent during testing and we'll
>   fix them up in the usual fashion.
>
> b) It will introduce subtle slowdowns due to needlessly executing
>   code more than once, as in the hugepage case which I identified.
>   These problems will hang around for long periods.
>
> So they're good reasons to fix the macros.  If these fixes cause the
> compiler to generate worse code then we should quantify and understand
> that.  Perhaps it is only certain compiler versions.  Perhaps we can
> find a test case (should be easy?) and send it over to the gcc guys to
> fix.  Perhaps we can find some C-level construct which prevents the
> compiler from going into stupid mode without reintroducing the existing
> problems.

My question was more along the lines of is it worth it to even have macros for
something as simple rounding up when dividing?

For an example of statement expression problems, I noticed something with
swab16(), addressed in commit 8e2c20023f34b652605a5fb7c68bb843d2b100a8

#define ___swab16(x) \
({ \
        __u16 __x = (x); \
        ((__u16)( \
                (((__u16)(__x) & (__u16)0x00ffU) << 8) | \
                (((__u16)(__x) & (__u16)0xff00U) >> 8) )); \
})

Produces this code:

             movzwl  %ax, %eax
             movl    %eax, %edx
             shrl    $8, %eax
             sall    $8, %edx
             orl     %eax, %edx

While this:

static __inline__ __attribute_const__ __u16 ___swab16(__u16 x)
{
        return x<<8 | x>>8;
}

Produces this code:

             rolw    $8, %ax

