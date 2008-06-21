Return-Path: <linux-kernel-owner+w=401wt.eu-S1758661AbYFUAA0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661AbYFUAA0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 20:00:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756601AbYFUAAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 20:00:12 -0400
Received: from an-out-0708.google.com ([209.85.132.249]:6863 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979AbYFUAAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 20:00:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FmBbrHxHqPos7/X5WD12UCAX/hhhoxS/jvfNmjJdDdy/zC2F9tvhgTw8jFyKQZ025p
         Azo1BDnYEFesX7eHyIWr5TFHrkijHxvOV5qjcKyacRbiuGtOcmlAfUhAIt6lVqz1ukAp
         Mxwatj6Iy/+ykmPujmalp0EA30C1YABRxNTr8=
Message-ID: <485C4484.3080706@gmail.com>
Date: Fri, 20 Jun 2008 21:00:04 -0300
From: Kevin Winchester <kjwinchester@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Yinghai Lu <yhlu.kernel@gmail.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Pavel Machek <pavel@ucw.cz>
Subject: Re: Bisecting tip/auto-x86-next?
References: <485AFC9B.7090502@gmail.com> <20080620101722.GD17692@elte.hu> <d1af83620806200437p7c3817d8i381a99f92f47fd4f@mail.gmail.com> <20080620153626.GE17373@elte.hu>
In-Reply-To: <20080620153626.GE17373@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin Winchester <kjwinchester@gmail.com> wrote:
> 
>>> hm, could you send me the config that triggered this?
>> I will do so tonight when I am home again.  It is a UP AMD64 box with 
>> a VIA chipset, if that helps.
>>
>>> btw., you can probably ignore this one safely. Also please tell me 
>>> at which commit ID you were at when you triggered this warning.
>> Good to know - I will get the commit ID tonight as well, although 
>> wouldn't following the same bisection sequence that I did give you the 
>> same bisection point?  I guess that would assume that linus/master and 
>> auto-x86-next haven't changed much since last night, which might not 
>> be correct.
> 
> yeah, you'd probably not hit that warning with the x86/gart bisection 
> sequence. (Assuming the bug is introduced in that branch - so you should 
> first check whether pure x86/gart kernel triggers the problem too.)
> 
> If you still have the commit ID around then please send it - if you 
> dont, no problem, it's no big issue. I wanted to check how wide the 
> bisection window is where the warning triggers.
> 

I'm sorry - I accidentally checkout out x86/gart to test it before 
grabbing the commit ID.

I went ahead with the bisection and found:



8c9fd91a0dc503f085169d44f4360be025f75224 is first bad commit
commit 8c9fd91a0dc503f085169d44f4360be025f75224
Author: Yinghai Lu <yhlu.kernel@gmail.com>
Date:   Sun Apr 13 18:42:31 2008 -0700

     x86: checking aperture size order

     some systems are using 32M for gart and agp when memory is less 
than 4G.
     Kernel will reject and try to allcate another 64M that is not needed,
     and we will waste 64M of perfectly good RAM.

     this patch adds a workaround by checking aper_base/order between NB and
     agp bridge. If they are the same, and memory size is less than 4G, it
     will allow it.

     Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
     Signed-off-by: Ingo Molnar <mingo@elte.hu>
     Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

:040000 040000 848d6e4045a14d01fc0a794d4350d8a84f3ceff6 
4a10a52b41309060cd5dc1bf0c322f6d43b2477b M      arch
:040000 040000 aa1cee87b1f5b1b30ed03ce6164ad7f404fef2a3 
f9ce0aaa1f7d4fdc7bdc5a43285495db53a6f531 M      drivers


as the first bad commit.  I do not have time to look at the patch right 
now, but in case anyone else does, I figured I would post it.

Thanks,

-- 
Kevin Winchester
