Return-Path: <linux-kernel-owner+w=401wt.eu-S1759297AbXHBTLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297AbXHBTLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 15:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbXHBTLZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 15:11:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48056 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbXHBTLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 15:11:24 -0400
Message-ID: <46B22C25.2070601@zytor.com>
Date: Thu, 02 Aug 2007 15:10:29 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: Sergey Vlasov <vsu@altlinux.ru>
CC: Ulrich Kunitz <kune@deine-taler.de>, Chuck Ebbert <cebbert@redhat.com>,
       linux-kernel@vger.kernel.org, honza@jikos.cz, jkosina@suse.cz
Subject: Re: Is PIE randomization breaking klibc binaries?
References: <20070720211300.GA21644@deine-taler.de>	<46A131BF.4080404@zytor.com>	<46A6624E.60003@redhat.com>	<46A667BD.5080106@redhat.com>	<20070724220053.GA20531@deine-taler.de>	<46A68003.6060901@redhat.com>	<46A68118.9080902@zytor.com>	<20070725063243.GA25148@deine-taler.de> <20070802230219.97b7f7b5.vsu@altlinux.ru>
In-Reply-To: <20070802230219.97b7f7b5.vsu@altlinux.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Vlasov wrote:
>>
>> Program Header:
>>     LOAD off    0x0000000000000000 vaddr 0x0000000000200000 paddr 0x0000000000200000 align 2**21
>>          filesz 0x000000000001197e memsz 0x000000000001197e flags r-x
>>     LOAD off    0x0000000000011980 vaddr 0x0000000000411980 paddr 0x0000000000411980 align 2**21
> 
> Note that the vaddr here can overlap the binary which is linked starting
> at 0x400000.
> 
> This is the bug which I have found and fixed some time ago:
> 
> http://git.kernel.org/?p=libs/klibc/klibc.git;a=commit;h=10df6dfb13ffefe716f12136bbc667f18ff64744
> 
> The fix was included in klibc-1.4.35, but does not seem to be applied in
> your case (the alignment is still 2**21 - it should be 2**20) - so
> either you are using an old klibc, or the "-z max-page-size=0x100000"
> option does not take effect for some reason.
> 
> In my case the buggy klibc worked fine with a stock 2.6.18 kernel, but
> broke when the execshield patch was applied - and the commit 60bfba7e
> code comes from execshield, so it looks like the same problem.
> 
>>          filesz 0x0000000000000100 memsz 0x0000000000004288 flags rw-
>>    STACK off    0x0000000000000000 vaddr 0x0000000000000000 paddr 0x0000000000000000 align 2**3
>>          filesz 0x0000000000000000 memsz 0x0000000000000000 flags rwx
>>
>> Sections:
>> Idx Name          Size      VMA               LMA               File off  Algn
>>   0 .text         0000da94  0000000000200200  0000000000200200  00000200  2**2
>>                   CONTENTS, ALLOC, LOAD, READONLY, CODE
>>   1 .rodata       00003cde  000000000020dca0  000000000020dca0  0000dca0  2**5
>>                   CONTENTS, ALLOC, LOAD, READONLY, DATA
>>   2 .data         00000100  0000000000411980  0000000000411980  00011980  2**5
>>                   CONTENTS, ALLOC, LOAD, DATA
>>   3 .bss          00004188  0000000000411a80  0000000000411a80  00011a80  2**5
>>                   ALLOC
>>   4 .gnu_debuglink 0000002c  0000000000000000  0000000000000000  00011a80  2**0
>>                   CONTENTS, READONLY

Yup... it should probably be pointed out the reason the old kernel 
worked was nothing but pure dumb luck.  This was a GNU ld change which 
needed to be undone for klibc.  It's unfortunate that stock x86-64 
binaries leave as little of a null pointer range as they do, but that's 
life, unfortunately.  The other alternative is to map klibc just below 
the 2 GB point, which would also work, but the old way broke when the ld 
change went in.  As previously stated, klibc-1.4.35 or higher fixes this.

	-hpa
