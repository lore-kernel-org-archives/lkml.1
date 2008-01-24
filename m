Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYAXEZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYAXEZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2008 23:25:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbYAXEZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jan 2008 23:25:11 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35245 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868AbYAXEZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:25:09 -0500
Date: Thu, 24 Jan 2008 13:24:48 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [RFC][PATCH 7/8] mem_notify v5: ignore very small zone for prevent incorrect low mem notify.
Cc: kosaki.motohiro@jp.fujitsu.com, Marcelo Tosatti <marcelo@kvack.org>,
       Daniel Spang <daniel.spang@gmail.com>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080124130348.1760.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20080124132355.1775.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

on X86, ZONE_DMA is very very small.
it cause undesirable low mem notification.
It should ignored.

but on other some architecture, ZONE_DMA have 4GB.
4GB is large as it is not possible to ignored.

therefore, ignore or not is decided by zone size.

ChangeLog:
	v5: new


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/mem_notify.h |    3 +++
 mm/page_alloc.c            |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: b/include/linux/mem_notify.h
===================================================================
--- a/include/linux/mem_notify.h	2008-01-23 22:06:04.000000000 +0900
+++ b/include/linux/mem_notify.h	2008-01-23 22:08:02.000000000 +0900
@@ -22,6 +22,9 @@ static inline void memory_pressure_notif
 	unsigned long target;
 	unsigned long pages_high, pages_free, pages_reserve;
 
+	if (unlikely(zone->mem_notify_status == -1))
+		return;
+
 	if (pressure) {
 		target = atomic_long_read(&last_mem_notify) + MEM_NOTIFY_FREQ;
 		if (likely(time_before(jiffies, target)))
Index: b/mm/page_alloc.c
===================================================================
--- a/mm/page_alloc.c	2008-01-23 22:07:57.000000000 +0900
+++ b/mm/page_alloc.c	2008-01-23 22:08:02.000000000 +0900
@@ -3470,7 +3470,11 @@ static void __meminit free_area_init_cor
 		zone->zone_pgdat = pgdat;
 
 		zone->prev_priority = DEF_PRIORITY;
-		zone->mem_notify_status = 0;
+
+		if (zone->present_pages < (pgdat->node_present_pages / 10))
+			zone->mem_notify_status = -1;
+		else
+			zone->mem_notify_status = 0;
 
 		zone_pcp_init(zone);
 		INIT_LIST_HEAD(&zone->active_list);


