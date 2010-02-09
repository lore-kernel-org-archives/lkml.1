Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319Ab0BITje (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 14:39:34 -0500
Received: from sca-es-mail-2.Sun.COM ([192.18.43.133]:54630 "EHLO
	sca-es-mail-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab0BITdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 14:33:49 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN
Date: Tue, 09 Feb 2010 11:32:31 -0800
From: Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 20/35] x86: add find_early_area_size
In-reply-to: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Message-id: <1265743966-17065-21-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
References: <1265743966-17065-1-git-send-email-yinghai@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

prepare to move bck find_e820_area_size back to e820.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/kernel/early_res.c |   45 ++++++++++++++++++++++++++++++------------
 1 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/arch/x86/kernel/early_res.c b/arch/x86/kernel/early_res.c
index 3ae0051..aba02f2 100644
--- a/arch/x86/kernel/early_res.c
+++ b/arch/x86/kernel/early_res.c
@@ -476,6 +476,29 @@ out:
 	return -1ULL;
 }
 
+u64 __init find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
+			 u64 *sizep, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	*sizep = ei_last - addr;
+	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
+		;
+	last = addr + *sizep;
+	if (last > ei_last)
+		goto out;
+
+	return addr;
+
+out:
+	return -1ULL;
+}
+
 /*
  * Find a free area with specified alignment in a specific range.
  */
@@ -513,24 +536,20 @@ u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
-		u64 addr, last;
-		u64 ei_last;
+		u64 addr;
+		u64 ei_start, ei_last;
 
 		if (ei->type != E820_RAM)
 			continue;
-		addr = round_up(ei->addr, align);
+
 		ei_last = ei->addr + ei->size;
-		if (addr < start)
-			addr = round_up(start, align);
-		if (addr >= ei_last)
-			continue;
-		*sizep = ei_last - addr;
-		while (bad_addr_size(&addr, sizep, align) &&
-			addr + *sizep <= ei_last)
-			;
-		last = addr + *sizep;
-		if (last > ei_last)
+		ei_start = ei->addr;
+		addr = find_early_area_size(ei_start, ei_last, start,
+					 sizep, align);
+
+		if (addr == -1ULL)
 			continue;
+
 		return addr;
 	}
 
-- 
1.6.4.2

