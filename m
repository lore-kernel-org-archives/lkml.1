Return-Path: <linux-kernel-owner+w=401wt.eu-S1759976AbZF2Xav@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759976AbZF2Xav (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 19:30:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbZF2Xak
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 19:30:40 -0400
Received: from hera.kernel.org ([140.211.167.34]:44846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759912AbZF2Xaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 19:30:39 -0400
Message-ID: <4A494E3C.70304@kernel.org>
Date: Mon, 29 Jun 2009 16:29:00 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>
CC: Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org>
In-Reply-To: <4A494478.7020304@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yinghai Lu wrote:
> H. Peter Anvin wrote:
>> [Add Cc: Yinghai]
>>
>> Mikael Pettersson wrote:
>>>  > >  > 
>>>  > >  > OK, this seems more than a wee bit strange, to say the least.  We
>>>  > >  > shouldn't be reserving the entire address space; this is legitimate I/O
>>>  > >  > space.
>>>  > >  > 
>>>  > >  > However, the reservation suddenly being improper for the root resource
>>>  > >  > would definitely make things unhappy...
>>>  > > 
>>>  > > Reverting the two e820 changes in 2.6.31-rc1,
>>>  > > 5d423ccd7ba4285f1084e91b26805e1d0ae978ed and then
>>>  > > 45fbe3ee01b8e463b28c2751b5dcc0cbdc142d90,
>>>  > > but keeping the iomem_resource.end cap change, makes 2.6.31-rc1
>>>  > > work on my HIGHMEM64G machine.
>>>  > > 
>>>  > > Seems the e820 and the iomem_resource.end changes are Ok in
>>>  > > isolation but break when combined.
>>>  > 
>>>  > With the e820 change reverted, what does /proc/iomem look like?
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

Mikael, can you try following patch on your system?

---
 arch/x86/kernel/e820.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1400,8 +1400,8 @@ void __init e820_reserve_resources_late(
 	 * avoid stolen RAM:
 	 */
 	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *entry = &e820_saved.map[i];
-		resource_size_t start, end;
+		struct e820entry *entry = &e820.map[i];
+		u64 start, end;
 
 		if (entry->type != E820_RAM)
 			continue;
@@ -1409,8 +1409,10 @@ void __init e820_reserve_resources_late(
 		end = round_up(start, ram_alignment(start));
 		if (start == end)
 			continue;
-		reserve_region_with_split(&iomem_resource, start,
-						  end - 1, "RAM buffer");
+		if (end != (resource_size_t)end)
+			continue;
+		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
+					  (resource_size_t)(end - 1), "RAM buffer");
 	}
 }
 
