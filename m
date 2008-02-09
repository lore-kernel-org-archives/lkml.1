Return-Path: <linux-kernel-owner+w=401wt.eu-S1753373AbYBIP0z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373AbYBIP0z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2008 10:26:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752632AbYBIP0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Feb 2008 10:26:43 -0500
Received: from py-out-1112.google.com ([64.233.166.181]:40913 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285AbYBIP0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2008 10:26:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=ZjwobNUKw4eyEAvcmepZffNIySHQrbr6Z2NM9iSd/pjHti85qcXvLm/ydiX6zpW8PqtuKCPb+d9lsnTmxG1MpxItr2EI5IdlY8sS6YKy7gu94XgQwf+m/k2MfVvqmtgoSD2HczoOs34aaMwZ7hV3+fD8hu8mw67x2MRuNG+i3xE=
Message-ID: <2f11576a0802090726pa17d91crc1067554100f715f@mail.gmail.com>
Date: Sun, 10 Feb 2008 00:26:41 +0900
From: "KOSAKI Motohiro" <kosaki.motohiro@jp.fujitsu.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/8][for -mm] mem_notify v6: ignore very small zone for prevent incorrect low mem notify
Cc: kosaki.motohiro@jp.fujitsu.com, "Marcelo Tosatti" <marcelo@kvack.org>,
       "Daniel Spang" <daniel.spang@gmail.com>,
       "Rik van Riel" <riel@redhat.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Alan Cox" <alan@lxorguk.ukuu.org.uk>, linux-fsdevel@vger.kernel.org,
       "Pavel Machek" <pavel@ucw.cz>, "Al Boldi" <a1426z@gawab.com>,
       "Jon Masters" <jonathan@jonmasters.org>, "Zan Lynx" <zlynx@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: f89851dcbd11e533
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
