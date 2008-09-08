Return-Path: <linux-kernel-owner+w=401wt.eu-S1755256AbYIHSWr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755256AbYIHSWr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2008 14:22:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753618AbYIHSWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Sep 2008 14:22:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51713 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612AbYIHSWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2008 14:22:37 -0400
Message-ID: <48C56D60.7010405@zytor.com>
Date: Mon, 08 Sep 2008 11:22:24 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: x86 maintainers <x86@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] x86 fixes
References: <200809081752.m88Hq6tn005080@askone.hos.anvin.org> <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
In-Reply-To: <alpine.LFD.1.10.0809081056350.3117@nehalem.linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 8 Sep 2008, H. Peter Anvin wrote:
>>  
>>  config X86_GENERIC
>> -	bool "Generic x86 support"
>> +	bool "Generic x86 support" if EMBEDDED
> 
> Ok, so after having realized that this seems to be more about a bug with 
> gcc, I'm really not as convinced any more.
> 
> As far as I can tell, there are three issues:
> 
>  - "-mtune=core/core2/pentium4/.." is buggy in some gas/gcc versions on 
>    x86-32, and makes architectural choices.
> 
>    Any actual _released_ versions? Maybe it's just a current SVN issue?

binutils-2.18.50.0.6-5, which is the current version on Fedora 9, does this.

>    Workaround: don't use it. And yes, X86_GENERIC=y will do that, although 
>    quite frankly that seems to be dubious in itself. But quite frankly, 
>    it's a gcc bug, and we should see it as such.
> 
>    The better workaround may well be "-Wa,-mtune=generic" as you pointed 
>    out.
> 
>  - We do the CONFIG_P6_NOPL thing ourselves, and we should just stop 
>    doing that on 32-bit. There simply isn't a good enough reason to do so. 
>    I already posteed the Kconfig.cpu patch to just stop doing it.

As far as I can tell, -Wa,-mtune=generic *should* work.  It doesn't look 
to me as if cc1 will generate the long NOPs.  That one we can do 
unconditionally, of course.

>  - X86_GENERIC means _other_ things too, like doing a 128-bit cacheline 
>    just so that it won't suck horribly on P4's even if it's otherwise 
>    tuned for a good microarchitecture.
> 
> And they really do seem to be _separate_ issues. Do we really want to tie 
> these things together under X86_GENERIC? 

Well, the argument in favour would be that if you want a kernel that can 
cross between different microarchitectures, then you want the "don't 
suck horribly on any of them".  We can, of course, divide them down 
further, but is it useful?

The "ideal" way to do any of this would probably to have checkboxes for 
all the CPUs you want to support and then a drop-down box for the CPU to 
optimize for.  However, the combinatorics of that would be horrible, and 
it would be very unlikely we would avoid bugs.

	-hpa
