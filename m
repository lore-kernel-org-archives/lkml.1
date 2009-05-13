Return-Path: <linux-kernel-owner+w=401wt.eu-S1761424AbZEMUY6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761424AbZEMUY6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 16:24:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761224AbZEMUYo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 16:24:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46080 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761411AbZEMUYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 16:24:43 -0400
Message-ID: <4A0B2C27.5020101@zytor.com>
Date: Wed, 13 May 2009 13:23:03 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Subrata Modak <subrata@linux.vnet.ibm.com>,
       Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, x86@kernel.org,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, Andi Kleen <ak@linux.intel.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH] Fix Warnining in arch/x86/kernel/signal.c
References: <20090512155637.19380.9114.sendpatchset@subratamodak.linux.ibm.com> <4A0A2E57.7080709@ct.jp.nec.com> <1242205601.6325.15.camel@subratamodak.linux.ibm.com> <20090513135325.GA10434@elte.hu>
In-Reply-To: <20090513135325.GA10434@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>>>>  
>>>>  	if (!access_ok(VERIFY_READ, frame, sizeof(*frame)))
>>>>  		goto badframe;
>>>> -	if (__get_user(set.sig[0], &frame->sc.oldmask) || (_NSIG_WORDS > 1
>>>> -		&& __copy_from_user(&set.sig[1], &frame->extramask,
>>>> -				    sizeof(frame->extramask))))
>>>> +
>>>> +        if ( (__copy_from_user(&set.sig[1], &frame->extramask,
>>>> +                sizeof(frame->extramask)) && _NSIG_WORDS > 1) || 
>>>> +                __get_user(set.sig[0], &frame->sc.oldmask))
>>>>  		goto badframe;
>>> I'm not sure why this eliminates that warning.
>>> set.sig[0] may not be initialized too, if __copy_from_user() failed.
>> True, but only when either or both of __copy_from_user() and
>> (_NSIG_WORDS > 1) fails. But in all instances set.sig[1] gets
>> initialized.
>>
>>> I don't have enough time to look at this right now, sorry.
>>>
>>> Another question, __copy_from_user() will be called even if
>>> _NSIG_WORDS is less than 2, perhaps it never occurs.
>>> I think, to check _NSIG_WORDS > 1 before calling __copy_from_user()
>>> is better.
>> Fine. Let Ingo/Thomas/Peter decide whether they would like this fix or
>> drop it.
> 
> If you get the Acked-by from Hiroshi-san it looks good to me. He 
> modified this code last.
> 

This seriously looks wrong to me.  If _NSIG_WORDS == 1, then calling
__copy_from_user here is a serious error.

	-hpa

