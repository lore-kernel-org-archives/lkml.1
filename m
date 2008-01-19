Return-Path: <linux-kernel-owner+w=401wt.eu-S932566AbYASQJU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932566AbYASQJU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 11:09:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761119AbYASQJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 11:09:10 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:5959 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758849AbYASQJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 11:09:09 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Ian Campbell <ijc@hellion.org.uk>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Date: Sat, 19 Jan 2008 16:08:56 +0000
Message-Id: <1200758937-22386-1-git-send-email-ijc@hellion.org.uk>
X-Mailer: git-send-email 1.5.3.8
X-SA-Exim-Connect-IP: 192.168.1.223
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: [PATCH] x86/voyager: Switch voyager memory detection to early_ioremap.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extracted from an earlier patch by Eric Biederman.

Signed-off-by: Ian Campbell <ijc@hellion.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 arch/x86/mach-voyager/voyager_basic.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/arch/x86/mach-voyager/voyager_basic.c b/arch/x86/mach-voyager/voyager_basic.c
index 6a949e4..ed41fd8 100644
--- a/arch/x86/mach-voyager/voyager_basic.c
+++ b/arch/x86/mach-voyager/voyager_basic.c
@@ -110,8 +110,9 @@ typedef struct ClickMap {
 	} Entry[CLICK_ENTRIES];
 } ClickMap_t;
 
-/* This routine is pretty much an awful hack to read the bios clickmap by
- * mapping it into page 0.  There are usually three regions in the map:
+/*
+ * This routine reads the bios clickmap.  There are usually three
+ * regions in the map:
  * 	Base Memory
  * 	Extended Memory
  *	zero length marker for end of map
@@ -125,7 +126,6 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
 	__u8 cmos[4];
 	ClickMap_t *map;
 	unsigned long map_addr;
-	unsigned long old;
 
 	if (region >= CLICK_ENTRIES) {
 		printk("Voyager: Illegal ClickMap region %d\n", region);
@@ -138,12 +138,8 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
 
 	map_addr = *(unsigned long *)cmos;
 
-	/* steal page 0 for this */
-	old = pg0[0];
-	pg0[0] = ((map_addr & PAGE_MASK) | _PAGE_RW | _PAGE_PRESENT);
-	local_flush_tlb();
-	/* now clear everything out but page 0 */
-	map = (ClickMap_t *) (map_addr & (~PAGE_MASK));
+	/* Setup a temporary mapping for the clickmap */
+	map = early_ioremap(map_addr, sizeof(*map));
 
 	/* zero length is the end of the clickmap */
 	if (map->Entry[region].Length != 0) {
@@ -152,9 +148,8 @@ int __init voyager_memory_detect(int region, __u32 * start, __u32 * length)
 		retval = 1;
 	}
 
-	/* replace the mapping */
-	pg0[0] = old;
-	local_flush_tlb();
+	/* undo the mapping */
+	early_iounmap(map, sizeof(*map));
 	return retval;
 }
 
-- 
1.5.3.8

