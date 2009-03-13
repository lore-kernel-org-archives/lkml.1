Return-Path: <linux-kernel-owner+w=401wt.eu-S1757882AbZCMCgg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882AbZCMCgg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 22:36:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757758AbZCMCfl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 22:35:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:52518 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737AbZCMCfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 22:35:38 -0400
Date: Fri, 13 Mar 2009 02:34:19 GMT
From: Jan Beulich <jbeulich@novell.com>
To: linux-tip-commits@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jbeulich@novell.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <49B9171B.76E4.0078.0@novell.com>
References: <49B9171B.76E4.0078.0@novell.com>
Subject: [tip:x86/mm] x86: fix code paths used by update_mptable
Message-ID: <tip-5c0e6f035df983210e4d22213aed624ced502d3d@git.kernel.org>
Git-Commit-ID: 5c0e6f035df983210e4d22213aed624ced502d3d
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 13 Mar 2009 02:34:21 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5c0e6f035df983210e4d22213aed624ced502d3d
Gitweb:     http://git.kernel.org/tip/5c0e6f035df983210e4d22213aed624ced502d3d
Author:     Jan Beulich <jbeulich@novell.com>
AuthorDate: Thu, 12 Mar 2009 13:07:23 +0000
Commit:     Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 13 Mar 2009 02:37:19 +0100

x86: fix code paths used by update_mptable

Impact: fix crashes under Xen due to unrobust e820 code

find_e820_area_size() must return a properly distinguishable and
out-of-bounds value when it fails, and -1UL does not meet that
criteria on i386/PAE. Additionally, callers of the function must
check against that value.

early_reserve_e820() should be prepared for the region found to be
outside of the addressable range on 32-bits.

e820_update_range_map() should not blindly update e820, but should do
all it work on the map it got a pointer passed for (which in 50% of the
cases is &e820_saved). It must also not call e820_add_region(), as that
again acts on e820 unconditionally.

The issues were found when trying to make this option work in our Xen
kernel (i.e. where some of the silent assumptions made in the code
would not hold).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
LKML-Reference: <49B9171B.76E4.0078.0@novell.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>


---
 arch/x86/kernel/check.c |    2 +-
 arch/x86/kernel/e820.c  |   32 +++++++++++++++++++++++++-------
 2 files changed, 26 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/check.c b/arch/x86/kernel/check.c
index 2ac0ab7..b617b11 100644
--- a/arch/x86/kernel/check.c
+++ b/arch/x86/kernel/check.c
@@ -83,7 +83,7 @@ void __init setup_bios_corruption_check(void)
 		u64 size;
 		addr = find_e820_area_size(addr, &size, PAGE_SIZE);
 
-		if (addr == 0)
+		if (!(addr + 1))
 			break;
 
 		if ((addr + size) > corruption_check_size)
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 508bec1..3cf6681 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -421,7 +421,7 @@ static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
 					u64 size, unsigned old_type,
 					unsigned new_type)
 {
-	int i;
+	unsigned int i, x;
 	u64 real_updated_size = 0;
 
 	BUG_ON(old_type == new_type);
@@ -429,7 +429,7 @@ static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
 	if (size > (ULLONG_MAX - start))
 		size = ULLONG_MAX - start;
 
-	for (i = 0; i < e820.nr_map; i++) {
+	for (i = 0; i < e820x->nr_map; i++) {
 		struct e820entry *ei = &e820x->map[i];
 		u64 final_start, final_end;
 		if (ei->type != old_type)
@@ -446,14 +446,23 @@ static u64 __init e820_update_range_map(struct e820map *e820x, u64 start,
 		final_end = min(start + size, ei->addr + ei->size);
 		if (final_start >= final_end)
 			continue;
-		e820_add_region(final_start, final_end - final_start,
-					 new_type);
+
+		x = e820x->nr_map;
+		if (x == ARRAY_SIZE(e820x->map)) {
+			printk(KERN_ERR "Too many memory map entries!\n");
+			break;
+		}
+		e820x->map[x].addr = final_start;
+		e820x->map[x].size = final_end - final_start;
+		e820x->map[x].type = new_type;
+		e820x->nr_map++;
+
 		real_updated_size += final_end - final_start;
 
-		ei->size -= final_end - final_start;
 		if (ei->addr < final_start)
 			continue;
 		ei->addr = final_end;
+		ei->size -= final_end - final_start;
 	}
 	return real_updated_size;
 }
@@ -1020,8 +1029,8 @@ u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
 			continue;
 		return addr;
 	}
-	return -1UL;
 
+	return -1ULL;
 }
 
 /*
@@ -1034,13 +1043,22 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	u64 start;
 
 	start = startt;
-	while (size < sizet)
+	while (size < sizet && (start + 1))
 		start = find_e820_area_size(start, &size, align);
 
 	if (size < sizet)
 		return 0;
 
+#ifdef CONFIG_X86_32
+	if (start >= MAXMEM)
+		return 0;
+	if (start + size > MAXMEM)
+		size = MAXMEM - start;
+#endif
+
 	addr = round_down(start + size - sizet, align);
+	if (addr < start)
+		return 0;
 	e820_update_range(addr, sizet, E820_RAM, E820_RESERVED);
 	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
 	printk(KERN_INFO "update e820 for early_reserve_e820\n");
