Return-Path: <linux-kernel-owner+w=401wt.eu-S1761475AbYCCXBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761475AbYCCXBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 18:01:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754710AbYCCXBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 18:01:21 -0500
Received: from gw.goop.org ([64.81.55.164]:51676 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754679AbYCCXBV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 18:01:21 -0500
Message-ID: <47CC8211.7090704@goop.org>
Date: Mon, 03 Mar 2008 14:56:17 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Segher Boessenkool <segher@kernel.crashing.org>
CC: hans.rosenfeld@amd.com, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: bisected boot regression post 2.6.25-rc3.. please revert
References: <20080301105646.2c8620d9@laptopd505.fenrus.org> <20080303074620.GC5934@elte.hu> <20080303091304.GA17911@elte.hu> <47CC2A3D.1000307@linux.intel.com> <20080303174009.GA19131@elte.hu> <47CC451A.2060501@linux.intel.com> <962471e5d2b8c88858dd5e0f50269751@kernel.crashing.org> <4ffd9be7b13d6300b888c146d6d040d5@kernel.crashing.org> <a9af8424f96a9118c6b097d9b2df79b2@kernel.crashing.org>
In-Reply-To: <a9af8424f96a9118c6b097d9b2df79b2@kernel.crashing.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Segher Boessenkool wrote:
>>> so (on 32-bit) ~_PAGE_PSE is ~0x80L is 0xffffff7f, which when cast to
>>> 64-bit is 0x00000000ffffff7f,
>>
>> Actually, it is signed, so this isn't true.  Comments about unsafeness
>> still apply.
>
> It turns out that PAGE_SIZE is unsigned.  So this gives us for
>
>     (~PAGE_MASK & ~_PAGE_USER & ~_PAGE_PSE & ~_PAGE_NX)
>
> the types UL, L, L, ULL resp.
>
> The associativity of & is left-to-right, so this in turn becomes
>
>     UL, L, ULL
>
>     UL, ULL
>
>     ULL
>
> and that cast from UL to ULL doesn't sign-extend. 

I went through and made a bunch of these flags signed so that they would 
sign-extend properly in 32 vs 64 bit.  We could make them 
unconditionally 64-bit, but I'm worried that will have unforeseen 
consequences too.

In this case, PAGE_MASK should probably be signed too, so the sign 
extension happens properly.

Alternatively, they could be cast to pteval_t and/or phys_addr_t so that 
they will have an inherent size which matches the pagetable format 
(using _AT() rather than _AC()).

    J
