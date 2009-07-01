Return-Path: <linux-kernel-owner+w=401wt.eu-S1763336AbZGAAqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763336AbZGAAqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 20:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761122AbZGAAdZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 20:33:25 -0400
Received: from kroah.org ([198.145.64.141]:59926 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761072AbZGAAdX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 20:33:23 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jun 30 17:15:54 2009
Message-Id: <20090701001553.976012658@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 30 Jun 2009 17:14:28 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Dimitri Sivanich <sivanich@sgi.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Nick Piggin <nickpiggin@yahoo.com.au>, Mel Gorman <mel@csn.ul.ie>
Subject: [patch 32/35] mm: fix handling of pagesets for downed cpus
References: <20090701001356.007288418@mini.kroah.org>
Content-Disposition: inline; filename=mm-fix-handling-of-pagesets-for-downed-cpus.patch
In-Reply-To: <20090701002825.GA6518@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.29-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Dimitri Sivanich <sivanich@sgi.com>

commit 364df0ebfbbb1330bfc6ca159f4d6020efc15a12 upstream.

After downing/upping a cpu, an attempt to set
/proc/sys/vm/percpu_pagelist_fraction results in an oops in
percpu_pagelist_fraction_sysctl_handler().

If a processor is downed then we need to set the pageset pointer back to
the boot pageset.

Updates of the high water marks should not access pagesets of unpopulated
zones (those pointer go to the boot pagesets which would be no longer
functional if their size would be increased beyond zero).

Signed-off-by: Dimitri Sivanich <sivanich@sgi.com>
Signed-off-by: Christoph Lameter <cl@linux-foundation.org>
Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 mm/page_alloc.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2804,7 +2804,7 @@ bad:
 		if (dzone == zone)
 			break;
 		kfree(zone_pcp(dzone, cpu));
-		zone_pcp(dzone, cpu) = NULL;
+		zone_pcp(dzone, cpu) = &boot_pageset[cpu];
 	}
 	return -ENOMEM;
 }
@@ -2819,7 +2819,7 @@ static inline void free_zone_pagesets(in
 		/* Free per_cpu_pageset if it is slab allocated */
 		if (pset != &boot_pageset[cpu])
 			kfree(pset);
-		zone_pcp(zone, cpu) = NULL;
+		zone_pcp(zone, cpu) = &boot_pageset[cpu];
 	}
 }
 
@@ -4494,6 +4494,8 @@ int percpu_pagelist_fraction_sysctl_hand
 	if (!write || (ret == -EINVAL))
 		return ret;
 	for_each_zone(zone) {
+		if (!populated_zone(zone))
+			continue;
 		for_each_online_cpu(cpu) {
 			unsigned long  high;
 			high = zone->present_pages / percpu_pagelist_fraction;


