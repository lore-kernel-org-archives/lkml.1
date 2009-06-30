Return-Path: <linux-kernel-owner+w=401wt.eu-S1758404AbZF3BP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbZF3BP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752286AbZF3BPR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:15:17 -0400
Received: from hera.kernel.org ([140.211.167.34]:33892 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751680AbZF3BPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:15:16 -0400
Message-ID: <4A4966EF.6010809@kernel.org>
Date: Mon, 29 Jun 2009 18:14:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com>
In-Reply-To: <4A495C0D.2020807@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>>  			continue;
>> @@ -1409,8 +1409,10 @@ void __init e820_reserve_resources_late(
>>  		end = round_up(start, ram_alignment(start));
>>  		if (start == end)
>>  			continue;
>> -		reserve_region_with_split(&iomem_resource, start,
>> -						  end - 1, "RAM buffer");
>> +		if (end != (resource_size_t)end)
>> +			continue;
>> +		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
>> +					  (resource_size_t)(end - 1), "RAM buffer");
>>  	}
>>  }
>>  
> 
> That doesn't quite look right; for one thing it doesn't handle the
> (admittedly somewhat unlikely) case of end pointing to the end of the
> address space.
> 
> Something like:
> 
> 	if (start > (resource_size_t)end-1)
> 		continue;
> 
> ... should work better.
> 

ok this one?

---
 arch/x86/kernel/e820.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -1367,9 +1367,9 @@ void __init e820_reserve_resources(void)
 }
 
 /* How much should we pad RAM ending depending on where it is? */
-static unsigned long ram_alignment(resource_size_t pos)
+static u64 ram_alignment(u64 pos)
 {
-	unsigned long mb = pos >> 20;
+	u64 mb = pos >> 20;
 
 	/* To 64kB in the first megabyte */
 	if (!mb)
@@ -1400,17 +1400,17 @@ void __init e820_reserve_resources_late(
 	 * avoid stolen RAM:
 	 */
 	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *entry = &e820_saved.map[i];
-		resource_size_t start, end;
+		struct e820entry *entry = &e820.map[i];
+		u64 start, end;
 
 		if (entry->type != E820_RAM)
 			continue;
 		start = entry->addr + entry->size;
-		end = round_up(start, ram_alignment(start));
-		if (start == end)
+		end = round_up(start, ram_alignment(start)) - 1;
+		if (start > (resource_size_t)end)
 			continue;
-		reserve_region_with_split(&iomem_resource, start,
-						  end - 1, "RAM buffer");
+		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
+					  (resource_size_t)end, "RAM buffer");
 	}
 }
 
