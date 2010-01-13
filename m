Return-Path: <linux-kernel-owner+w=401wt.eu-S1755345Ab0AMOtf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab0AMOtf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 09:49:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755370Ab0AMOtf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 09:49:35 -0500
Received: from mail-pw0-f42.google.com ([209.85.160.42]:44601 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299Ab0AMOtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 09:49:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:x-operating-system:user-agent;
        b=XN6EfA4uYDQzf21dkg6abwBdytu8tPug1astEoQBOUPijJsPE2OakpXXsoLzIJ9yH1
         tAQwqY2H1hkXBWv2sVVmIDPU40fKe/3uOcTaXSio8tO7V3dX7FVNf7SRlSfUz6sRskjK
         +Rhngnnvte20sYiiaPAszs3XHdFBxuDR4K12I=
Date: Wed, 13 Jan 2010 22:49:17 +0800
From: Li Hong <lihong.hi@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Subject: [PATCH 1/3] mm: page_alloc.c Remove duplicate call to
 trace_mm_page_free_direct
Message-ID: <20100113144917.GA11934@xhl>
Mail-Followup-To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux xhl 2.6.31-14-generic 
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function 'trace_mm_page_free_direct' is called in function '__free_pages'.
But it is called again in 'free_hot_page' if order == 0 and produce duplicate
records in trace file for mm_page_free_direct event. As below:

K-PID    CPU#    TIMESTAMP  FUNCTION
  gnome-terminal-1567  [000]  4415.246466: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
  gnome-terminal-1567  [000]  4415.246468: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
  gnome-terminal-1567  [000]  4415.246506: mm_page_alloc: page=ffffea0003db9f40 pfn=1155800 order=0 migratetype=0 gfp_flags=GFP_KERNEL
  gnome-terminal-1567  [000]  4415.255557: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0
  gnome-terminal-1567  [000]  4415.255557: mm_page_free_direct: page=ffffea0003db9f40 pfn=1155800 order=0

This patch removes the first call and add a call to 'trace_mm_page_free_direct'
in '__free_pages_ok'.

Signed-off-by: Li Hong <lihong.hi@gmail.com>
---
 mm/page_alloc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 4e9f5cc..24344cd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -582,6 +582,7 @@ static void __free_pages_ok(struct page *page, unsigned int order)
        int bad = 0;
        int wasMlocked = __TestClearPageMlocked(page);
 
+       trace_mm_page_free_direct(page, order);
        kmemcheck_free_shadow(page, order);
 
        for (i = 0 ; i < (1 << order) ; ++i)
@@ -2012,7 +2013,6 @@ void __pagevec_free(struct pagevec *pvec)
 void __free_pages(struct page *page, unsigned int order)
 {
        if (put_page_testzero(page)) {
-               trace_mm_page_free_direct(page, order);
                if (order == 0)
                        free_hot_page(page);
                else
-- 
1.6.3.3

