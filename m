Return-Path: <linux-kernel-owner+w=401wt.eu-S1760363AbXGWPXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760363AbXGWPXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 11:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759658AbXGWPXa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 11:23:30 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:59274 "EHLO
	localhost.localdomain" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759646AbXGWPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 11:23:29 -0400
Message-Id: <20070723152129.036573829@mvista.com>
User-Agent: quilt/0.46-1
Date: Mon, 23 Jul 2007 08:21:29 -0700
From: Daniel Walker <dwalker@mvista.com>
To: mingo@elte.hu
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org
Subject: [PATCH] release quicklist before free_page
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Resolves,

BUG: sleeping function called from invalid context cc1(29651) at kernel/rtmutex.c:636
in_atomic():1 [00000001], irqs_disabled():0
 [<c0119f50>] __might_sleep+0xf3/0xf9
 [<c031600e>] __rt_spin_lock+0x21/0x3c
 [<c014102c>] get_zone_pcp+0x20/0x29
 [<c0141a40>] free_hot_cold_page+0xdc/0x167
 [<c013a3f4>] add_preempt_count+0x12/0xcc
 [<c0110d92>] pgd_dtor+0x0/0x1
 [<c015d865>] quicklist_trim+0xb7/0xe3
 [<c0111025>] check_pgt_cache+0x19/0x1c
 [<c0148df5>] free_pgtables+0x54/0x12c
 [<c013a3f4>] add_preempt_count+0x12/0xcc
 [<c014e5be>] unmap_region+0xeb/0x13b


It looks like the quicklist isn't used after a few variables are evaluated.
So no need to keep preemption disabled over the whole function.

Signed-Off-By: Daniel Walker <dwalker@mvista.com>

---
 mm/quicklist.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: linux-2.6.22.1/mm/quicklist.c
===================================================================
--- linux-2.6.22.1.orig/mm/quicklist.c
+++ linux-2.6.22.1/mm/quicklist.c
@@ -55,6 +55,7 @@ void quicklist_trim(int nr, void (*dtor)
 	q = &get_cpu_var(quicklist)[nr];
 	if (q->nr_pages > min_pages) {
 		pages_to_free = min_pages_to_free(q, min_pages, max_free);
+		put_cpu_var(quicklist);
 
 		while (pages_to_free > 0) {
 			/*
@@ -68,8 +69,8 @@ void quicklist_trim(int nr, void (*dtor)
 			free_page((unsigned long)p);
 			pages_to_free--;
 		}
-	}
-	put_cpu_var(quicklist);
+	} else
+		put_cpu_var(quicklist);
 }
 
 unsigned long quicklist_total_size(void)
-- 

-- 
