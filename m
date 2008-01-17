Return-Path: <linux-kernel-owner+w=401wt.eu-S1755504AbYAQD1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504AbYAQD1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 22:27:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752522AbYAQD1G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 22:27:06 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41100 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755356AbYAQD1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 22:27:04 -0500
Date: Thu, 17 Jan 2008 12:26:58 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: =?ISO-2022-JP?B?IkRhbmllbCBTcBskQmlPGyhCZyI=?= 
	<daniel.spang@gmail.com>
Subject: Re: [RFC][PATCH 4/5] memory_pressure_notify() caller
Cc: kosaki.motohiro@jp.fujitsu.com, "Rik van Riel" <riel@redhat.com>,
       linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       "Marcelo Tosatti" <marcelo@kvack.org>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <cfd9edbf0801160303s53237b81yb9d5e374c16cd006@mail.gmail.com>
References: <20080116104536.11AE.KOSAKI.MOTOHIRO@jp.fujitsu.com> <cfd9edbf0801160303s53237b81yb9d5e374c16cd006@mail.gmail.com>
Message-Id: <20080117120112.11CE.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-2022-JP"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel

> > Thank you for good point out!
> > Could you please post your test program and reproduced method?
> 
> Sure:
> 
> 1. Fill almost all available memory with page cache in a system without swap.
> 2. Run attached alloc-test program.
> 3. Notification fires when page cache is reclaimed.

Unfortunately, I can't reproduce it.

my machine
	CPU:    Pentium4 2.8GHz with HT
	memory: 512M


1. I doubt ZONE_DMA, please shipment ignore zone_dma patch(below).
2. Could you please send your .config and /etc/sysctl.conf?
   I hope more reproduce challenge.

thanks.

- kosaki




Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>

---
 include/linux/mem_notify.h |    3 +++
 mm/page_alloc.c            |    6 +++++-
 2 files changed, 8 insertions(+), 1 deletion(-)

Index: linux-2.6.24-rc6-mm1-memnotify/include/linux/mem_notify.h
===================================================================
--- linux-2.6.24-rc6-mm1-memnotify.orig/include/linux/mem_notify.h
 2008-01-16 21:31:09.000000000 +0900
+++ linux-2.6.24-rc6-mm1-memnotify/include/linux/mem_notify.h
2008-01-16 21:34:24.000000000 +0900
@@ -22,6 +22,9 @@ static inline void memory_pressure_notif
        unsigned long target;
        unsigned long pages_high, pages_free, pages_reserve;

+       if (unlikely(zone->mem_notify_status == -1))
+               return;
+
        if (pressure) {
                target = atomic_long_read(&last_mem_notify) + MEM_NOTIFY_FREQ;
                if (likely(time_before(jiffies, target)))
Index: linux-2.6.24-rc6-mm1-memnotify/mm/page_alloc.c
===================================================================
--- linux-2.6.24-rc6-mm1-memnotify.orig/mm/page_alloc.c 2008-01-13
19:50:27.000000000 +0900
+++ linux-2.6.24-rc6-mm1-memnotify/mm/page_alloc.c      2008-01-16
21:41:58.000000000 +0900
@@ -3467,7 +3467,11 @@ static void __meminit free_area_init_cor
                zone->zone_pgdat = pgdat;

                zone->prev_priority = DEF_PRIORITY;
-               zone->mem_notify_status = 0;
+
+               if (zone->present_pages < (pgdat->node_present_pages / 10))
+                       zone->mem_notify_status = -1;
+               else
+                       zone->mem_notify_status = 0;

                zone_pcp_init(zone);
                INIT_LIST_HEAD(&zone->active_list);



