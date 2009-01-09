Return-Path: <linux-kernel-owner+w=401wt.eu-S932693AbZAIWgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693AbZAIWgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 17:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758870AbZAIWfX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 17:35:23 -0500
Received: from mga14.intel.com ([143.182.124.37]:63050 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932480AbZAIWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 17:35:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,241,1231142400"; 
   d="scan'208";a="98407199"
Date: Fri, 9 Jan 2009 14:35:20 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org,
       tvignaud@mandriva.com
Subject: [patch] x86, pat: fix reserve_memtype() for legacy 1MB range
Message-ID: <20090109223520.GC6472@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86, pat: fix reserve_memtype() for legacy 1MB range

Thierry Vignaud reported:
> http://bugzilla.kernel.org/show_bug.cgi?id=12372
>
> On P4 with an SiS motherboard (video card is a SiS 651)
> X server fails to start with error:
> xf86MapVidMem: Could not mmap framebuffer (0x00000000,0x2000) (Invalid
> argument)

Here X is trying to map first 8KB of memory using /dev/mem. Existing
code treats first 0-4KB of memory as non-RAM and 4KB-8KB as RAM. Recent
code changes don't allow to map memory with different attributes
at the same time.

Fix this by treating the first 1MB legacy region as special and always
track the attribute requests with in this region using linear linked
list (and don't bother if the range is RAM or non-RAM or mixed)

Reported-and-tested-by: Thierry Vignaud <tvignaud@mandriva.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: stable@kernel.org
---

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..c959a4d 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,11 +333,20 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return reserve_ram_pages_type(start, end, req_type, new_type);
-	else if (is_range_ram < 0)
-		return -EINVAL;
+	/*
+	 * For legacy reasons, some parts of the physical address range in the
+	 * legacy 1MB region is treated as non-RAM (even when listed as RAM in
+	 * the e820 tables).  So we will track the memory attributes of this
+	 * legacy 1MB region using the linear memtype_list always.
+	 */
+	if (end >= ISA_END_ADDRESS) {
+		is_range_ram = pagerange_is_ram(start, end);
+		if (is_range_ram == 1)
+			return reserve_ram_pages_type(start, end, req_type,
+						      new_type);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	new  = kmalloc(sizeof(struct memtype), GFP_KERNEL);
 	if (!new)
