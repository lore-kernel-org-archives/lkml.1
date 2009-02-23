Return-Path: <linux-kernel-owner+w=401wt.eu-S1752892AbZBWGQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752892AbZBWGQQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 01:16:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751525AbZBWGP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 01:15:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:37003 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbZBWGP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 01:15:59 -0500
Message-ID: <49A23EE0.8000102@kernel.org>
Date: Sun, 22 Feb 2009 22:14:56 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Kevin O'Connor" <kevin@koconnor.net>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Stefan Reinauer <stepan@coresystems.de>, linux-kernel@vger.kernel.org,
       coreboot@coreboot.org, Jaswinder Singh Rajput <jaswinder@infradead.org>
Subject: Re: MPTable can not be high-memory on Linux
References: <499DB40C.1060205@coresystems.de> <499DCE79.8020809@coresystems.de> <20090222152530.GA30576@morn.localdomain> <200902221806.55429.rjw@sisk.pl> <49A1C4AF.9000009@kernel.org> <20090222223226.GA3346@morn.localdomain> <20090222225847.GB1649@elte.hu>
In-Reply-To: <20090222225847.GB1649@elte.hu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> * Kevin O'Connor <kevin@koconnor.net> wrote:
> 
>> On Sun, Feb 22, 2009 at 01:33:35PM -0800, Yinghai Lu wrote:
>> [...]
>>>>>>  BIOS-e820: 0000000000090000 - 0000000000100000 (reserved)
>>>>>>  BIOS-e820: 0000000000100000 - 000000003f7f0000 (usable)
>>>>>>  BIOS-e820: 000000003f7f0000 - 0000000040000000 (reserved)
>> [...]
>>>>>> found SMP MP-table at [c00f9fc0] 000f9fc0
>> [...]
>>> that should work for a long time.
>>>
>>> 0xf9fc0 < 1M is quite < max_low_pfn, so wonder why bootmem could panic.
>> On this machine the mptable "floating" structure is at 
>> 0xf9fc0.  It points to the rest of the table which is in the 
>> 0x3f7f0000 area.
>>
>> Note, that this is on a Coreboot+SeaBIOS machine - so we can 
>> change the bios.  However, the mptable spec does allow for 
>> part of the table to be high memory.
> 
> yes, and i'd prefer if it worked fine even if it's that high.
> 

please check

[PATCH] x86: check physptr with max_low_pfn on 32bit

Impact: fix bug

coreboot aka LinuxBIOS try to put mptable on somewhere much high than
max_low_pfn, it cause panic

so need to check physptr with max_low_pfn * PAGE_SIZE.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/mpparse.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

Index: linux-2.6/arch/x86/kernel/mpparse.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/mpparse.c
+++ linux-2.6/arch/x86/kernel/mpparse.c
@@ -710,13 +710,22 @@ static int __init smp_scan_config(unsign
 				 * of physical memory; so that simply reserving
 				 * PAGE_SIZE from mpf->physptr yields BUG()
 				 * in reserve_bootmem.
+				 * also need to make sure physptr is below than
+				 * max_low_pfn
+				 * we don't need reserve the area above max_low_pfn
 				 */
 				unsigned long end = max_low_pfn * PAGE_SIZE;
-				if (mpf->physptr + size > end)
-					size = end - mpf->physptr;
-#endif
+
+				if (mpf->physptr < end) {
+					if (mpf->physptr + size > end)
+						size = end - mpf->physptr;
+					reserve_bootmem_generic(mpf->physptr, size,
+							BOOTMEM_DEFAULT);
+				}
+#else
 				reserve_bootmem_generic(mpf->physptr, size,
 						BOOTMEM_DEFAULT);
+#endif
 			}
 
 			return 1;
