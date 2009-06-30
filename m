Return-Path: <linux-kernel-owner+w=401wt.eu-S1754908AbZF3A0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbZF3A0x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 20:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbZF3A0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 20:26:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41218 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753039AbZF3A0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 20:26:44 -0400
Message-ID: <4A495ABC.1090306@zytor.com>
Date: Mon, 29 Jun 2009 17:22:20 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org>
In-Reply-To: <4A494478.7020304@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
>>>
>> OK.  This is starting to make sense.  I suspect this is a similar issue
>> as 3b0fde0fac19c180317eb0601b3504083f4b9bf5 addresses, which is that the
>> e820 code assumes -- and I don't see any exception to that in
>> 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90 -- that iomem_resource covers
>> the entire 64-bit address space that e820 knows.  I wonder what happens
>> with "interestingly shaped" memory above 4 GB if resource_size_t is 32
>> bits with that code.
>>
>> In terms of address space assignment, an alternate implementation of the
>> address space cap is to mark it reserved; that would unfortunately
>> result in an ugly turd at the end of /proc/iomem, but that can be
>> addressed if need be, too.
> 
> always enable 64bit resource for 32bit too?
> 

That would address the problem if combined with the "alternative
implementation" that I described below, but I'm not sure how well it
would go over, especially since the 32-bit x86 world is increasingly
getting concentrated on the very-resource-starved end of the computing
spectrum.

The bottom-line problem is the same: e820, and the e820 allocator, can
describe address space that lies outside our real range of possible
address space.  What to do with that is easy -- it should simply be
ignored -- but it does lead to oddball sequencing issues.  In that
sense, reserving a chunk of address space at the end is cleaner, but
that doesn't address the issue of what happens with a 32-bit
resource_size_t.

Unfortunately, my attempts at reproducing the problem locally has failed
so far.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

