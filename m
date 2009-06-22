Return-Path: <linux-kernel-owner+w=401wt.eu-S1756550AbZFVSZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756550AbZFVSZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 14:25:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752702AbZFVSYw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 14:24:52 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60006 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752644AbZFVSYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 14:24:51 -0400
Date: Mon, 22 Jun 2009 13:24:51 -0500
From: Dimitri Sivanich <sivanich@sgi.com>
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: cl@linux-foundation.org, kosaki.motohiro@jp.fujitsu.com, mel@csn.ul.ie,
       nickpiggin@yahoo.com.au, stable@kernel.org
Subject: [PATCH] Fix handling of pagesets for downed cpus
Message-ID: <20090622182451.GA15682@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After downing/upping a cpu, an attempt to set
/proc/sys/vm/percpu_pagelist_fraction results in an oops in
percpu_pagelist_fraction_sysctl_handler().

If a processor is downed then we need to set the pageset pointer back to the
boot pageset.

Updates of the high water marks should not access pagesets of unpopulated zones
(those pointer go to the boot pagesets which would be no longer functional if
their size would be increased beyond zero).

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

---

This patch should go into the -stable tree as well.

 mm/page_alloc.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/mm/page_alloc.c
===================================================================
--- linux.orig/mm/page_alloc.c	2009-06-22 13:06:50.000000000 -0500
+++ linux/mm/page_alloc.c	2009-06-22 13:08:09.000000000 -0500
@@ -3026,7 +3026,7 @@ bad:
 		if (dzone == zone)
 			break;
 		kfree(zone_pcp(dzone, cpu));
-		zone_pcp(dzone, cpu) = NULL;
+		zone_pcp(dzone, cpu) = &boot_pageset[cpu];
 	}
 	return -ENOMEM;
 }
@@ -3041,7 +3041,7 @@ static inline void free_zone_pagesets(in
 		/* Free per_cpu_pageset if it is slab allocated */
 		if (pset != &boot_pageset[cpu])
 			kfree(pset);
-		zone_pcp(zone, cpu) = NULL;
+		zone_pcp(zone, cpu) = &boot_pageset[cpu];
 	}
 }
 
@@ -4659,7 +4659,7 @@ int percpu_pagelist_fraction_sysctl_hand
 	ret = proc_dointvec_minmax(table, write, file, buffer, length, ppos);
 	if (!write || (ret == -EINVAL))
 		return ret;
-	for_each_zone(zone) {
+	for_each_populated_zone(zone) {
 		for_each_online_cpu(cpu) {
 			unsigned long  high;
 			high = zone->present_pages / percpu_pagelist_fraction;
