Return-Path: <linux-kernel-owner+w=401wt.eu-S1756343AbXFKEhQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756343AbXFKEhQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 00:37:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750742AbXFKEhG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 00:37:06 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:40134 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750726AbXFKEhE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 00:37:04 -0400
Date: Mon, 11 Jun 2007 13:35:43 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: mm: memory/cpu hotplug section mismatch.
Message-ID: <20070611043543.GA22910@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Sam Ravnborg <sam@ravnborg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

When building with memory hotplug enabled and cpu hotplug disabled, we
end up with the following section mismatch:

WARNING: mm/built-in.o(.text+0x4e58): Section mismatch: reference to
.init.text: (between 'free_area_init_node' and '__build_all_zonelists')

This happens as a result of:

	-> free_area_init_node()
	  -> free_area_init_core()
	    -> zone_pcp_init() <-- all __meminit up to this point
	      -> zone_batchsize() <-- marked as __cpuinit

This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
CONFIG_MEMORY_HOTPLUG=y unsets __meminit.

Changing zone_batchsize() to __init_refok fixes this.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bd8e335..5c312d6 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1968,7 +1968,7 @@ void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __cpuinit zone_batchsize(struct zone *zone)
+static int __init_refok zone_batchsize(struct zone *zone)
 {
 	int batch;
 
