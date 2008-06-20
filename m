Return-Path: <linux-kernel-owner+w=401wt.eu-S1756273AbYFTUJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273AbYFTUJE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYFTUIy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:08:54 -0400
Received: from mail-wa4.bigfish.com ([216.32.181.114]:5478 "EHLO
	mail152-wa4-R.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751805AbYFTUIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:08:53 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Jun 2008 16:08:53 EDT
X-BigFish: VPS9(z34a4l1033izzz10d3izzz32i6bh43j)
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2S2MA-01-8Q0-01
Date: Fri, 20 Jun 2008 22:08:37 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 7/7] x86: pat.c final cleanup of loop body in
	reserve_memtype
Message-ID: <20080620200837.GI4105@alberich.amd.com>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 20:08:39.0556 (UTC) FILETIME=[6E201440:01C8D311]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   30 +++++++++++-------------------
 1 files changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 281ac64..a885a10 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -281,32 +281,24 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
 	list_for_each_entry(entry, &memtype_list, nd) {
-		if (entry->start >= end) {
+		if (end <= entry->start) {
 			where = entry->nd.prev;
 			break;
-		}
-
-		if (start <= entry->start && end >= entry->start) {
+		} else if (start <= entry->start) { /* end > entry->start */
 			err = chk_conflict(new, entry, new_type);
-			if (err) {
-				break;
+			if (!err) {
+				dprintk("Overlap at 0x%Lx-0x%Lx\n",
+					entry->start, entry->end);
+				where = entry->nd.prev;
 			}
-
-			dprintk("Overlap at 0x%Lx-0x%Lx\n",
-			       entry->start, entry->end);
-			where = entry->nd.prev;
 			break;
-		}
-
-		if (start < entry->end) {
+		} else if (start < entry->end) { /* start > entry->start */
 			err = chk_conflict(new, entry, new_type);
-			if (err) {
-				break;
+			if (!err) {
+				dprintk("Overlap at 0x%Lx-0x%Lx\n",
+					entry->start, entry->end);
+				where = &entry->nd;
 			}
-
-			dprintk("Overlap at 0x%Lx-0x%Lx\n",
-				 entry->start, entry->end);
-			where = &entry->nd;
 			break;
 		}
 	}
-- 
1.5.5.4



