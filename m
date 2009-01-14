Return-Path: <linux-kernel-owner+w=401wt.eu-S1754324AbZANSs5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324AbZANSs5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 13:48:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755965AbZANSsg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 13:48:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:14049 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943AbZANSsf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 13:48:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.37,263,1231142400"; 
   d="scan'208";a="657117350"
Date: Wed, 14 Jan 2009 10:48:34 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: mingo@elte.hu, hpa@zytor.com, tglx@linutronix.de
Cc: venkatesh.pallipadi@intel.com, linux-kernel@vger.kernel.org
Subject: [patch] x86, pat: fix free_memtype() for legacy 1MB range
Message-ID: <20090114184834.GC1290@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 0e95c190cf1b4adbf1fc67decff3f2bb20158ba8 in tip tree
is n't complete, as we left out adding similar logic to free_memtype().

Appended is the delta patch against tip.

thanks,
suresh
---

[patch] x86, pat: fix free_memtype() for legacy 1MB range

Starting this commit:

>	commit 0e95c190cf1b4adbf1fc67decff3f2bb20158ba8
>	Author: Suresh Siddha <suresh.b.siddha@intel.com>
>	Date:   Fri Jan 9 14:35:20 2009 -0800
>
>	    x86, pat: fix reserve_memtype() for legacy 1MB range

Attribute requests with in this 1MB region are tracked in reserve_memtype()
using linear linked list (and don't bother if the range is RAM or non-RAM or
mixed).

free_memtype() also needs to follow similar logic.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Cc: stable@kernel.org
---

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ec8cd49..3be3990 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -446,11 +446,19 @@ int free_memtype(u64 start, u64 end)
 	if (is_ISA_range(start, end - 1))
 		return 0;
 
-	is_range_ram = pagerange_is_ram(start, end);
-	if (is_range_ram == 1)
-		return free_ram_pages_type(start, end);
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
+			return free_ram_pages_type(start, end);
+		else if (is_range_ram < 0)
+			return -EINVAL;
+	}
 
 	spin_lock(&memtype_lock);
 	list_for_each_entry(entry, &memtype_list, nd) {
