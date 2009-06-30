Return-Path: <linux-kernel-owner+w=401wt.eu-S1756626AbZF3Teb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756626AbZF3Teb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 15:34:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752939AbZF3TeY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 15:34:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:49261 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723AbZF3TeX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 15:34:23 -0400
Message-ID: <4A4A6888.30001@kernel.org>
Date: Tue, 30 Jun 2009 12:33:28 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mikael Pettersson <mikpe@it.uu.se>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org>	<19016.44061.600652.676183@pilspetsen.it.uu.se>	<4A490804.3040609@zytor.com>	<4A494478.7020304@kernel.org>	<4A494E3C.70304@kernel.org>	<4A495C0D.2020807@zytor.com>	<4A4966EF.6010809@kernel.org>	<alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>	<4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com>
In-Reply-To: <4A4A25B1.5010102@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Mikael Pettersson wrote:
>> Thanks, 2.6.31-rc1 vanilla (which didn't boot) plus this one does boot.
>> /proc/iomem now looks as follows:
>>
> 
> ... as it should.  So far so good, and this is a real problem.
> 
> However, there is something that really bothers me: *why does this help
> on Mikael's system, which is PAE and therefore has a 64-bit
> resource_size_t*?  This whole patch should be a no-op!  There is still
> something that doesn't make sense.
> 
> The use of "unsigned long" in ram_alignment() will overflow after 2^52
> bytes, but again, that's not the issue here, since the highest "start"
> value we have is (0x2 << 32).
> 
> By process of elimination, the culprit must be round_up(), which reveals
> that the macro definition of round_up() has a *very* sublte behavior
> with mixed types:
> 
> #define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
> 
> ram_alignment() returns unsigned long, which becomes (y).  This means
> that the mask word on the right hand of the & gets truncated to 32 bits
> *before* the masking happens -- since ((y) - 1) is still unsigned long,
> inverting it will not set bits [63..32] to on.
> 
> I think this macro is actively dangerous.  Better would be:
> 
> ({ __typeof__(x) __mask = (y)-1;  ((x)+__mask) & ~__mask; })
> 
> ... which is also multiple-inclusion-free at the cost of using gcc
> ({...}) constructs.
> 
> The deep irony in this is that in our particular case is perhaps that
> align_up(x,y)-1 is the same thing as x | (y-1) which would have avoided
> the problem...

agreed, that is why we change round_up to take u64.

wonder if we should kill round_up and use roundup instead.

in include/linux/kernel.h
#define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))

YH
