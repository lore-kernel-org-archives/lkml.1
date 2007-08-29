Return-Path: <linux-kernel-owner+w=401wt.eu-S1758182AbXH2B3o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758182AbXH2B3o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 21:29:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754431AbXH2B3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 21:29:35 -0400
Received: from mga11.intel.com ([192.55.52.93]:18934 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753753AbXH2B3f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 21:29:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.19,319,1183359600"; 
   d="scan'208";a="122746674"
Date: Tue, 28 Aug 2007 18:29:34 -0700
From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
To: ak@suse.de, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [patch] i386, apic: fix 4 bit apicid assumption of mach-default
Message-ID: <20070829012934.GK1894@linux-os.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andi/Andrew,

Can you pick this up for your trees and if there are no issues, can you please
push it to mainline before .23 gets released.

We have seen a boot failure with fewer cpu sockets populated on a MP platform.
Similar problem can happen on a fully populated system, if # of cpus <= 8
and any of the apic id's is > 16

thanks,
suresh
---
Fix get_apic_id() in mach-default, so that it uses 8 bits incase of xAPIC case
and 4 bits for legacy APIC case.

This fixes the i386 kernel assumption that apic id is less than 16 for xAPIC
platforms with 8 cpus or less and makes the kernel boot on such platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
---

diff --git a/include/asm-i386/mach-default/mach_apicdef.h b/include/asm-i386/mach-default/mach_apicdef.h
index 7bcb350..ae98413 100644
--- a/include/asm-i386/mach-default/mach_apicdef.h
+++ b/include/asm-i386/mach-default/mach_apicdef.h
@@ -1,11 +1,17 @@
 #ifndef __ASM_MACH_APICDEF_H
 #define __ASM_MACH_APICDEF_H
 
+#include <asm/apic.h>
+
 #define		APIC_ID_MASK		(0xF<<24)
 
 static inline unsigned get_apic_id(unsigned long x) 
 { 
-	return (((x)>>24)&0xF);
+	unsigned int ver = GET_APIC_VERSION(apic_read(APIC_LVR));
+	if (APIC_XAPIC(ver))
+		return (((x)>>24)&0xFF);
+	else
+		return (((x)>>24)&0xF);
 } 
 
 #define		GET_APIC_ID(x)	get_apic_id(x)
