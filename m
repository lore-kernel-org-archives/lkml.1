Return-Path: <linux-kernel-owner+w=401wt.eu-S1759582AbYENKv2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759582AbYENKv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 06:51:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755144AbYENKvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 06:51:20 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60096 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbYENKvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 06:51:19 -0400
Message-ID: <482AC3E4.2050200@firstfloor.org>
Date: Wed, 14 May 2008 12:50:12 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Segher Boessenkool <segher@kernel.crashing.org>,
       Robert Hancock <hancockr@shaw.ca>,
       Christian Kujau <lists@nerdbynature.de>,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCH] common implementation of iterative div/mod
References: <fa.QTbvQYXhEm5VNP5dvkl5JG7NHYQ@ifi.uio.no>	<481DF3D8.3010108@shaw.ca>	<a6dd201e0149f8dbdf10a7a194673833@kernel.crashing.org>	<48217674.8080903@goop.org>	<48231959.4050406@goop.org> <20080513234627.30476c20.akpm@linux-foundation.org> <482A95BB.1000001@goop.org> <482AA3BD.1030600@firstfloor.org> <482AB6FC.7020202@goop.org>
In-Reply-To: <482AB6FC.7020202@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Andi Kleen wrote:
>> You would need to annotate it and have a separate object file for the
>> different sections. Also it would need to be compiled PIC.
>>
>> Inlining is better.
> 
> BTW, I'm seeing the memcpy() in __vdso_gettimeofday() not being inlined.

Hmm works here. What compiler do you use? Normally gcc should 
recognize the memcpy is just two constant stores and always inline even with -Os.

nm --dynamic arch/x86/vdso/vdso.so
0000000000000000 A LINUX_2.6
ffffffffff7007e0 T __vdso_clock_gettime
ffffffffff700820 T __vdso_getcpu
ffffffffff700750 T __vdso_gettimeofday
ffffffffff7007e0 W clock_gettime
ffffffffff700820 W getcpu
ffffffffff700750 W gettimeofday

Anyways if your compiler or config cannot get that right it would need
to switch to __inline_memcpy(), but that would be slower or explicit
copying field by field.

If it's a common problem we could also implement a build time check,
but normally such problems should be already caught in code review.

-Andi

