Return-Path: <linux-kernel-owner+w=401wt.eu-S933088AbXIUWr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933088AbXIUWr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2007 18:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764114AbXIUWcq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Sep 2007 18:32:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:57101 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764049AbXIUWck (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2007 18:32:40 -0400
From: Andi Kleen <ak@suse.de>
References: <200709221231.836138000@suse.de>
In-Reply-To: <200709221231.836138000@suse.de>
To: suresh.b.siddha@intel.com, ak@suse.de, akpm@linux-foundation.org,
       patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [39/50] i386: fix 4 bit apicid assumption of mach-default
Message-Id: <20070921223239.5575F1479D@wotan.suse.de>
Date: Sat, 22 Sep 2007 00:32:39 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: "Siddha, Suresh B" <suresh.b.siddha@intel.com>

Fix get_apic_id() in mach-default, so that it uses 8 bits incase of xAPIC case
and 4 bits for legacy APIC case.

This fixes the i386 kernel assumption that apic id is less than 16 for xAPIC
platforms with 8 cpus or less and makes the kernel boot on such platforms.

Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
Signed-off-by: Andi Kleen <ak@suse.de>
Cc: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/asm-i386/mach-default/mach_apicdef.h |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

Index: linux/include/asm-i386/mach-default/mach_apicdef.h
===================================================================
--- linux.orig/include/asm-i386/mach-default/mach_apicdef.h
+++ linux/include/asm-i386/mach-default/mach_apicdef.h
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
