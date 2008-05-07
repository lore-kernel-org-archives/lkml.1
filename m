Return-Path: <linux-kernel-owner+w=401wt.eu-S1751497AbYEGJ3q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbYEGJ3q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 05:29:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbYEGJ3e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 05:29:34 -0400
Received: from gw.goop.org ([64.81.55.164]:58337 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751247AbYEGJ3d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 05:29:33 -0400
Message-ID: <48217674.8080903@goop.org>
Date: Wed, 07 May 2008 10:29:24 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: Robert Hancock <hancockr@shaw.ca>, Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: undefined reference to __udivdi3 (gcc-4.3)
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no> <481DF3D8.3010108@shaw.ca> <a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>
In-Reply-To: <a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>> I assume it's one or both of these loops in arch/x86/xen/time.c 
>> do_stolen_accounting() that are being optimized into a divide which 
>> generates a libgcc call:
>>
>>     while (stolen >= NS_PER_TICK) {
>>         ticks++;
>>         stolen -= NS_PER_TICK;
>>     }
>>
>> or
>>
>>     while (blocked >= NS_PER_TICK) {
>>         ticks++;
>>         blocked -= NS_PER_TICK;
>>     }
>
> That looks plausible.

Yep.  Probably both.

>> Not sure if that is a sustainable fix, though..
>
> It should be.  The asm() arg tells GCC that the asm() could modify
> "ns" in some way, so GCC cannot optimise away the loop, since it
> doesn't have the required info about the induction variable to do
> that. 

Yep, it's guaranteed to work.  But it's an ugly hack to work around an 
over-enthusiastic compiler, and so is an inherent maintainability burden.

I think the correct fix here is to introduce an iter_div_rem() function 
which contains this hack, so we can avoid scattering it all over the 
place.  I'll cook up a patch.

    J
