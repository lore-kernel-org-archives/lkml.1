Return-Path: <linux-kernel-owner+w=401wt.eu-S1759751AbYHOQVT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759751AbYHOQVT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 12:21:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754711AbYHOQVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 12:21:11 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:31196 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753574AbYHOQVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 12:21:11 -0400
X-IronPort-AV: E=Sophos;i="4.32,216,1217822400"; 
   d="scan'208";a="16056973"
Message-ID: <48A5ACFA.7040906@citrix.com>
Date: Fri, 15 Aug 2008 17:21:14 +0100
From: Alex Nixon <alex.nixon@citrix.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] change init_gdt to update the gdt via write_gdt, rather than
 a direct write.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Aug 2008 16:21:05.0289 (UTC) FILETIME=[EAAE4790:01C8FEF2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Nixon <alex.nixon@citrix.com>
Date: Fri, 15 Aug 2008 11:21:56 +0100
Subject: [PATCH] change init_gdt to update the gdt via write_gdt, rather than a direct write.

By writing directly, a memory access violation can occur whilst hotplugging a CPU if the entry was previously marked read-only.

Signed-off-by: Alex Nixon <alex.nixon@citrix.com>
---
 arch/x86/kernel/smpcommon.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/smpcommon.c b/arch/x86/kernel/smpcommon.c
index 99941b3..29f8bf0 100644
--- a/arch/x86/kernel/smpcommon.c
+++ b/arch/x86/kernel/smpcommon.c
@@ -13,13 +13,13 @@ EXPORT_PER_CPU_SYMBOL(this_cpu_off);
    secondary which will soon come up. */
 __cpuinit void init_gdt(int cpu)
 {
-	struct desc_struct *gdt = get_cpu_gdt_table(cpu);
+	struct desc_struct gdt;
 
-	pack_descriptor(&gdt[GDT_ENTRY_PERCPU],
-			__per_cpu_offset[cpu], 0xFFFFF,
+	pack_descriptor(&gdt, __per_cpu_offset[cpu], 0xFFFFF,
 			0x2 | DESCTYPE_S, 0x8);
+	gdt.s = 1;
 
-	gdt[GDT_ENTRY_PERCPU].s = 1;
+	write_gdt_entry(get_cpu_gdt_table(cpu), GDT_ENTRY_PERCPU, &gdt, DESCTYPE_S);
 
 	per_cpu(this_cpu_off, cpu) = __per_cpu_offset[cpu];
 	per_cpu(cpu_number, cpu) = cpu;
-- 
1.5.4.3

