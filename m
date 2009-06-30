Return-Path: <linux-kernel-owner+w=401wt.eu-S1757606AbZF3BmB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757606AbZF3BmB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jun 2009 21:42:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751727AbZF3Bly
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Jun 2009 21:41:54 -0400
Received: from hera.kernel.org ([140.211.167.34]:39152 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751486AbZF3Blx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jun 2009 21:41:53 -0400
Message-ID: <4A496D4B.3040608@kernel.org>
Date: Mon, 29 Jun 2009 18:41:31 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Mikael Pettersson <mikpe@it.uu.se>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se> <19013.29264.623540.275538@pilspetsen.it.uu.se> <4A45A5C1.5080701@zytor.com> <19013.59956.144640.331854@pilspetsen.it.uu.se> <20090629022911.GC20297@lackof.org> <4A484A8A.9020704@zytor.com> <19016.41349.636663.515540@pilspetsen.it.uu.se> <20090629112155.GJ5480@parisc-linux.org> <19016.44061.600652.676183@pilspetsen.it.uu.se> <4A490804.3040609@zytor.com> <4A494478.7020304@kernel.org> <4A494E3C.70304@kernel.org> <4A495C0D.2020807@zytor.com> <4A4966EF.6010809@kernel.org> <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Mon, 29 Jun 2009, Yinghai Lu wrote:
>> +		end = round_up(start, ram_alignment(start)) - 1;
>> +		if (start > (resource_size_t)end)
>>  			continue;
>> -		reserve_region_with_split(&iomem_resource, start,
>> -						  end - 1, "RAM buffer");
>> +		reserve_region_with_split(&iomem_resource, (resource_size_t)start,
>> +					  (resource_size_t)end, "RAM buffer");
> 
> Hmm. You shouldn't need the casts with reserve_region_with_split(), and 
> they just make things uglier.
> 
> Also, I wonder if we should do something like this instead
> 
> 	#define MAX_RESOURCE_SIZE ((resource_size_t)-1)
> 
> 	...
> 	end = round_up(start, ram_alignment(start)) - 1;
> 	if (end > MAX_RESOURCE_SIZE)
> 		end = MAX_RESOURCE_SIZE;
> 	if (start > end)
> 		continue;
> 
> Because otherwise we'll just be ignoring resources that cross the resource 
> size boundary, which sounds wrong.
> 
> We _could_ have a RAM resource that crosses the 4GB boundary, after all.
> 
> Yeah, it doesn't happen much in practice, because usually the 3G-4G range 
> is left for PCI mappings etc, so we might never hit this in practice, but 
> still, this sounds like a more correct thing to do.
> 
> It also avoids the cast. We simply cap the end to the max that 
> 'resource_size_t' can hold.

Mikael, please try this on your system, and send out /proc/iomem

Thanks

Yinghai

[PATCH] x86: add boundary check for 32bit res before expand e820 resource to alignment

fix hang with HIGHMEM_64G and 32bit resource.

according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/e820.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

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
@@ -1383,6 +1383,8 @@ static unsigned long ram_alignment(resou
 	return 32*1024*1024;
 }
 
+#define MAX_RESOURCE_SIZE ((resource_size_t)-1)
+
 void __init e820_reserve_resources_late(void)
 {
 	int i;
@@ -1400,17 +1402,19 @@ void __init e820_reserve_resources_late(
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
+		if (end > MAX_RESOURCE_SIZE)
+			end = MAX_RESOURCE_SIZE;
+		if (start > end)
 			continue;
-		reserve_region_with_split(&iomem_resource, start,
-						  end - 1, "RAM buffer");
+		reserve_region_with_split(&iomem_resource, start, end,
+					  "RAM buffer");
 	}
 }
 

