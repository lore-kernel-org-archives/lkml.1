Return-Path: <linux-kernel-owner+w=401wt.eu-S1757734AbZALUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757734AbZALUb1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2009 15:31:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755408AbZALUbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Jan 2009 15:31:16 -0500
Received: from mga01.intel.com ([192.55.52.88]:58477 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZALUbP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2009 15:31:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,254,1231142400"; 
   d="scan'208";a="421738589"
Date: Mon, 12 Jan 2009 12:31:14 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: linux-kernel@vger.kernel.org, venkatesh.pallipadi@intel.com,
       Daniel.Beschorner@facton.com, pageexec@freemail.hu, stable@kernel.org
Subject: [patch] x86: fix PTE corruption issue while mapping RAM using /dev/mem
Message-ID: <20090112203114.GA13157@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suresh Siddha <suresh.b.siddha@intel.com>
Subject: x86: fix PTE corruption issue while mapping RAM using /dev/mem 

Beschorner Daniel reported:
> hwinfo problem since 2.6.28, showing this in the oops:
> 	Corrupted page table at address 7fd04de3ec00

PaX Team reported a regression with this commit:

>	commit 9542ada803198e6eba29d3289abb39ea82047b92
>	Author: Suresh Siddha <suresh.b.siddha@intel.com>
>	Date:   Wed Sep 24 08:53:33 2008 -0700
>
>	    x86: track memtype for RAM in page struct

This commit breaks mapping any RAM page through /dev/mem, as the
reserve_memtype() was not initializing the return attribute type and as such
corrupting the PTE entry that was setup with the return attribute type.

Because of this bug, application mapping this RAM page through /dev/mem
will die with "Corrupted page table at address xxxx" message in the kernel
log and also the kernel identity mapping which maps the underlying RAM
page gets converted to UC.

Fix this by initializing the return attribute type before calling
reserve_ram_pages_type()

Reported-by: PaX Team <pageexec@freemail.hu>
Reported-and-tested-by: Beschorner Daniel <Daniel.Beschorner@facton.com>
Tested-and-Acked-by: PaX Team <pageexec@freemail.hu>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: <stable@kernel.org>
---

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 85cbd3c..d52ba1a 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -333,6 +333,9 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 					      req_type & _PAGE_CACHE_MASK);
 	}
 
+	if (new_type)
+		*new_type = actual_type;
+
 	is_range_ram = pagerange_is_ram(start, end);
 	if (is_range_ram == 1)
 		return reserve_ram_pages_type(start, end, req_type, new_type);
@@ -347,9 +350,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	new->end	= end;
 	new->type	= actual_type;
 
-	if (new_type)
-		*new_type = actual_type;
-
 	spin_lock(&memtype_lock);
 
 	if (cached_entry && start >= cached_start)
