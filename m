Return-Path: <linux-kernel-owner+w=401wt.eu-S1759385AbZF3VvT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759385AbZF3VvT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 17:51:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbZF3VvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 17:51:04 -0400
Received: from hera.kernel.org ([140.211.167.34]:47921 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753839AbZF3VvC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 17:51:02 -0400
Message-ID: <4A4A88A2.7010509@kernel.org>
Date: Tue, 30 Jun 2009 14:50:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, Mikael Pettersson <mikpe@it.uu.se>,
       Matthew Wilcox <matthew@wil.cx>,
       Grant Grundler <grundler@parisc-linux.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pci@vger.kernel.org
Subject: Re: [BUG 2.6.31-rc1] HIGHMEM64G causes hang in PCI init on 32-bit
 x86
References: <200906261559.n5QFxJH8027336@pilspetsen.it.uu.se>	<19013.29264.623540.275538@pilspetsen.it.uu.se>	<4A45A5C1.5080701@zytor.com>	<19013.59956.144640.331854@pilspetsen.it.uu.se>	<20090629022911.GC20297@lackof.org>	<4A484A8A.9020704@zytor.com>	<19016.41349.636663.515540@pilspetsen.it.uu.se>	<20090629112155.GJ5480@parisc-linux.org>	<19016.44061.600652.676183@pilspetsen.it.uu.se>	<4A490804.3040609@zytor.com>	<4A494478.7020304@kernel.org>	<4A494E3C.70304@kernel.org>	<4A495C0D.2020807@zytor.com>	<4A4966EF.6010809@kernel.org>	<alpine.LFD.2.01.0906291820060.3605@localhost.localdomain>	<4A496D4B.3040608@kernel.org> <19017.53428.834539.389495@pilspetsen.it.uu.se> <4A4A25B1.5010102@zytor.com> <4A4A6888.30001@kernel.org> <4A4A6B1C.7030405@zytor.com> <4A4A701F.3050700@kernel.org> <4A4A81C9.9070008@zytor.com>
In-Reply-To: <4A4A81C9.9070008@zytor.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> Yinghai Lu wrote:
>> H. Peter Anvin wrote:
>>> Yinghai Lu wrote:
>>>> agreed, that is why we change round_up to take u64.
>>>>
>>> round_up() is a macro, it doesn't "take" anything per se...
>>>
>> i mean
>>  end = roundup(start, ram_alignment(start)) - 1;
>>
>> static u64 ram_alignment(u64 pos)
>>
>> and other calling to round_up
>>
> 
> This is fixing the wrong problem.  Fixing round_up is the right thing,
> not working around its brain damage.
> 

this one ? 

or you want to move round_up/down to include/linux/kernel.h?

[PATCH] x86: add boundary check for 32bit res before expand e820 resource to alignment -v3

fix hang with HIGHMEM_64G and 32bit resource.
according to hpa and Linus, use (resource_size_t)-1 to fend off big ranges.

analyized by hpa

v2: use roundup instead
v3: from HPA update round_up with __type_of__

Reported-and-tested-by: Mikael Pettersson <mikpe@it.uu.se>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/proto.h |    5 +++--
 arch/x86/kernel/e820.c       |   20 ++++++++++++--------
 2 files changed, 15 insertions(+), 10 deletions(-)

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
 
Index: linux-2.6/arch/x86/include/asm/proto.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/proto.h
+++ linux-2.6/arch/x86/include/asm/proto.h
@@ -22,7 +22,8 @@ extern int reboot_force;
 
 long do_arch_prctl(struct task_struct *task, int code, unsigned long addr);
 
-#define round_up(x, y) (((x) + (y) - 1) & ~((y) - 1))
-#define round_down(x, y) ((x) & ~((y) - 1))
+#define round_up(x, y) ({ __typeof__(x) __mask = (y)-1; \
+			 ((x)+__mask) & ~__mask; })
+#define round_down(x, y) ({ __typeof__(x) __mask = (y)-1; (x) & ~__mask; })
 
 #endif /* _ASM_X86_PROTO_H */
