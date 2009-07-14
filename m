Return-Path: <linux-kernel-owner+w=401wt.eu-S1755729AbZGNQ42@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729AbZGNQ42 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 12:56:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755185AbZGNQ42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 12:56:28 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:65090 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755163AbZGNQ41 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 12:56:27 -0400
Message-ID: <4A5CB8B4.7050108@monstr.eu>
Date: Tue, 14 Jul 2009 18:56:20 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.18 (X11/20081120)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux Kernel list <linux-kernel@vger.kernel.org>,
       LTP <ltp-list@lists.sourceforge.net>
Subject: Re: access_ok macor
References: <4A5C8068.6020203@monstr.eu> <200907141652.59049.arnd@arndb.de> <4A5CAEFF.9080206@monstr.eu> <200907141843.05629.arnd@arndb.de>
In-Reply-To: <200907141843.05629.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> On Tuesday 14 July 2009, Michal Simek wrote:
>> Arnd Bergmann wrote:
> 
>>>>  r29=00000000, r30=00000000, r31=CE9759A4, rPC=C000123C
>>>>  msr=800045AE, ear=00000001, esr=000000B2, fsr=000080D0
>>>> Segmentation fault
>>>>
>>> I guess then you should check if 0xc000123c is in your
>>> exception table, or why it is not.
>> on that address is load instruction for unaligned exception because addr is odd number
>> that's why is called unaligned exception handler and from this function
>> is called load instruction which failed. :-(
>>
>> Currently this make more sense why that tests failed. If that pointers are
>> even number exception is not taken and exception sure don't have fixup for it because
>> this is generic code. :-(
>>
>> That's the problem because we are looking for regs->pc but this point to unaligned exception
>> handler.
> 
> Ok, that makes a lot of sense.
> 
> The solution then is to handle fixups from the unaligned exception handler
> if you come from the kernel. That should fix the three text cases.
> 
> I don't fully understand your exception handling there, but I think you
> also need to add code checking for __range_ok() to your unaligned handler,
> to prevent malicious user space code from accessing the kernel through
> unaligned pointers.

when the code tried to read/write from unaligned address (and in cpu is turn on unaligned exception)
then is caused unaligned exception and asm code assemble/return value which is on that unaligned
address. (Assemble it that read/write every byte separately). That will be harder to prevent all
this cases because unaligned exception is in generic code.
What do you mean add __range_ok? Range checking is ok. The problem is when in case get_user kernel
try to load unaligned addr - unaligned exception is perform and try to load that value separately.
If that page is not there, page fault handler is called and not find it, it is performed search
from exception table and that address is not there of course - because address in pc is generic
unaligned code. I think that handling this needs more code.
Maybe if the address with from unaligned exception handler (there are some address which can caused
it) and find out which aligned address is there and find out proper fixup for it.
I think that this could work.

What do you think?

Michal



> 
> 	Arnd <><


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
