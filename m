Return-Path: <linux-kernel-owner+w=401wt.eu-S1753033AbXFNGOv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753033AbXFNGOv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 02:14:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751507AbXFNGOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 02:14:44 -0400
Received: from smtp.ocgnet.org ([64.20.243.3]:56964 "EHLO smtp.ocgnet.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbXFNGOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 02:14:43 -0400
Date: Thu, 14 Jun 2007 15:13:16 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: mm: Fix memory/cpu hotplug section mismatch and oops.
Message-ID: <20070614061316.GA22543@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

(This is a resend of the earlier patch, this issue still needs to be
fixed.)

When building with memory hotplug enabled and cpu hotplug disabled, we
end up with the following section mismatch:

WARNING: mm/built-in.o(.text+0x4e58): Section mismatch: reference to
.init.text: (between 'free_area_init_node' and '__build_all_zonelists')

This happens as a result of:

        -> free_area_init_node()
          -> free_area_init_core()
            -> zone_pcp_init() <-- all __meminit up to this point
              -> zone_batchsize() <-- marked as __cpuinit                     fo

This happens because CONFIG_HOTPLUG_CPU=n sets __cpuinit to __init, but
CONFIG_MEMORY_HOTPLUG=y unsets __meminit.

Changing zone_batchsize() to __devinit fixes this.

__devinit is the only thing that is common between CONFIG_HOTPLUG_CPU=y and
CONFIG_MEMORY_HOTPLUG=y. In the long run, perhaps this should be moved to
another section identifier completely. Without this, memory hot-add
of offline nodes (via hotadd_new_pgdat()) will oops if CPU hotplug is
not also enabled.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

--

 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index bd8e335..05ace44 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -1968,7 +1968,7 @@ void zone_init_free_lists(struct pglist_data *pgdat, struct zone *zone,
 	memmap_init_zone((size), (nid), (zone), (start_pfn), MEMMAP_EARLY)
 #endif
 
-static int __cpuinit zone_batchsize(struct zone *zone)
+static int __devinit zone_batchsize(struct zone *zone)
 {
 	int batch;
 
