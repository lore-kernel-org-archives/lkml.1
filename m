Return-Path: <linux-kernel-owner+w=401wt.eu-S1762718AbXHWN5z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762718AbXHWN5z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2007 09:57:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757462AbXHWN5s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Aug 2007 09:57:48 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527AbXHWN5r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2007 09:57:47 -0400
Date: Thu, 23 Aug 2007 09:57:38 -0400
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, akpm@linux-foundation.org,
       gbeshers@sgi.com
Cc: Prarit Bhargava <prarit@redhat.com>
Message-Id: <20070823135738.17726.76343.sendpatchset@prarit.boston.redhat.com>
Subject: [PATCH]: i386 Stop bogus nmi & softlockup warnings in show_mem
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When dumping memory via sysrq-m it is possible to take a bogus NMI watchdog
or softlockup watchdog because the dump can take a long time on big memory
systems.

Occasionally tickle the watchdog when doing the dump.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>

diff --git a/arch/i386/mm/pgtable.c b/arch/i386/mm/pgtable.c
index 01437c4..9754cb5 100644
--- a/arch/i386/mm/pgtable.c
+++ b/arch/i386/mm/pgtable.c
@@ -6,6 +6,7 @@
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/mm.h>
+#include <linux/nmi.h>
 #include <linux/swap.h>
 #include <linux/smp.h>
 #include <linux/highmem.h>
@@ -39,6 +40,8 @@ void show_mem(void)
 	for_each_online_pgdat(pgdat) {
 		pgdat_resize_lock(pgdat, &flags);
 		for (i = 0; i < pgdat->node_spanned_pages; ++i) {
+			if (unlikely(i % MAX_ORDER_NR_PAGES == 0))
+				touch_nmi_watchdog();
 			page = pgdat_page_nr(pgdat, i);
 			total++;
 			if (PageHighMem(page))
