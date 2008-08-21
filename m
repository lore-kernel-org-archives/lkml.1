Return-Path: <linux-kernel-owner+w=401wt.eu-S1761276AbYHUXBW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761276AbYHUXBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 19:01:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756747AbYHUXBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 19:01:14 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:52605 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756012AbYHUXBN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 19:01:13 -0400
Message-ID: <48ADF3FC.7070002@keyaccess.nl>
Date: Fri, 22 Aug 2008 01:02:20 +0200
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Venki Pallipadi <venkatesh.pallipadi@intel.com>,
       Dave Airlie <airlied@gmail.com>, "Li, Shaohua" <shaohua.li@intel.com>,
       Yinghai Lu <yhlu.kernel@gmail.com>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Dave Jones <davej@codemonkey.org.uk>
Subject: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.
References: <20080819102633.GE6722@elte.hu> <48AAD680.7020508@keyaccess.nl> <20080819190757.GA17470@linux-os.sc.intel.com> <20080820100440.GE28492@elte.hu> <48ABF6DC.8070305@keyaccess.nl> <48AC29CA.1060203@keyaccess.nl> <20080820194127.GA10887@linux-os.sc.intel.com> <48AC8F69.4050201@keyaccess.nl> <21d7e9970808201446k3c1a6bc1naf04568a8ad06ed4@mail.gmail.com> <20080820221630.GA3598@linux-os.sc.intel.com> <20080821120626.GG5615@elte.hu> <48ADA2C2.8090905@keyaccess.nl>
In-Reply-To: <48ADA2C2.8090905@keyaccess.nl>
Content-Type: multipart/mixed;
 boundary="------------020800030800030605030105"
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020800030800030605030105
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

On 21-08-08 19:15, Rene Herman wrote:

> On 21-08-08 14:06, Ingo Molnar wrote:

>> Would be nice to test tip/master - it has both that patch included and 
>> the latest pageattr-array API (with enablement in AGP drivers) 
>> patchset, done by Shaohua Li, based on Dave's original patch.
> 
> That patch by itself doesn't help any -- the new set_memory_array_uc() 
> still calls reserve_memtype() for each single page in the array. To 
> help, it needs to coalesce adjacent entries, which is itself easy to do 
> were it not for the need to keep the list of reserved (base,end) pairs 
> around for free_memtype() time (and halfway fail time).

Actually, might as well simply reconstruct the memtype list at free time 
I guess. How is this for a coalescing version of the array functions?

NOTE: I am posting this because I'm going to bed but haven't stared 
comfortably long at this and might be buggy. Compiles, boots and 
provides me with:

root@7ixe4:~# wc -l /debug/x86/pat_memtype_list
53 /debug/x86/pat_memtype_list

otherwise (down from 16384+).

<snore>

Rene.

--------------020800030800030605030105
Content-Type: text/plain;
 name="0001-x86-have-set_memory_array_-uc-wb-coalesce-memtypes.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename*0="0001-x86-have-set_memory_array_-uc-wb-coalesce-memtypes.patc";
 filename*1="h"

>From b5dc6e481b38cf4e7792bcb9a8f5dd9aab0e5590 Mon Sep 17 00:00:00 2001
From: Rene Herman <rene.herman@gmail.com>
Date: Fri, 22 Aug 2008 00:56:00 +0200
Subject: [PATCH] x86: have set_memory_array_{uc,wb} coalesce memtypes.

---
 arch/x86/mm/pageattr.c |   38 ++++++++++++++++++++++++++++++++------
 1 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index d49e4db..a2a497a 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -942,21 +942,38 @@ EXPORT_SYMBOL(set_memory_uc);
 
 int set_memory_array_uc(unsigned long *addr, int addrinarray)
 {
+	unsigned long start;
+	unsigned long end;
 	int i;
 	/*
 	 * for now UC MINUS. see comments in ioremap_nocache()
 	 */
 	for (i = 0; i < addrinarray; i++) {
-		if (reserve_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE,
-			    _PAGE_CACHE_UC_MINUS, NULL))
+		start = __pa(addr[i]);
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		if (reserve_memtype(start, end, _PAGE_CACHE_UC_MINUS, NULL))
 			goto out;
 	}
 
 	return change_page_attr_set(addr, addrinarray,
 				    __pgprot(_PAGE_CACHE_UC_MINUS), 1);
 out:
-	while (--i >= 0)
-		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
+	for (i = 0; i < addrinarray; i++) {
+		unsigned long tmp = __pa(addr[i]);
+
+		if (tmp == start)
+			break;
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		free_memtype(tmp, end);
+	}
 	return -EINVAL;
 }
 EXPORT_SYMBOL(set_memory_array_uc);
@@ -997,9 +1014,18 @@ EXPORT_SYMBOL(set_memory_wb);
 int set_memory_array_wb(unsigned long *addr, int addrinarray)
 {
 	int i;
-	for (i = 0; i < addrinarray; i++)
-		free_memtype(__pa(addr[i]), __pa(addr[i]) + PAGE_SIZE);
 
+	for (i = 0; i < addrinarray; i++) {
+		unsigned long start = __pa(addr[i]);
+		unsigned long end;
+
+		for (end = start + PAGE_SIZE; i < addrinarray - 1; end += PAGE_SIZE) {
+			if (end != __pa(addr[i + 1]))
+				break;
+			i++;
+		}
+		free_memtype(start, end);
+	}
 	return change_page_attr_clear(addr, addrinarray,
 				      __pgprot(_PAGE_CACHE_MASK), 1);
 }
-- 
1.5.5


--------------020800030800030605030105--
