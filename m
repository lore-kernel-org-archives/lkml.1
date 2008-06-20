Return-Path: <linux-kernel-owner+w=401wt.eu-S1758036AbYFTUGV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758036AbYFTUGV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:06:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755045AbYFTUGK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:06:10 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:12506 "EHLO
	mail187-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171AbYFTUGJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:06:09 -0400
X-BigFish: VPS9(z34a4l1033izzz10d3izzz32i6bh43j62h)
X-Spam-TCS-SCL: 1:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2S2H8-02-ZK5-01
Date: Fri, 20 Jun 2008 22:05:37 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 5/7] x86: pat.c consolidate list_add handling in
	reserve_memtype
Message-ID: <20080620200537.GG4105@alberich.amd.com>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 20:05:39.0784 (UTC) FILETIME=[02F90C80:01C8D311]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   21 ++++++++-------------
 1 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 1118288..49dcd96 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -198,6 +198,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 {
 	struct memtype *new, *entry;
 	unsigned long actual_type;
+	struct list_head *where;
 	int err = 0;
 
  	BUG_ON(start >= end); /* end is exclusive */
@@ -251,13 +252,12 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	spin_lock(&memtype_lock);
 
 	/* Search for existing mapping that overlaps the current range */
+	where = NULL;
 	list_for_each_entry(entry, &memtype_list, nd) {
 		struct memtype *saved_ptr;
 
 		if (entry->start >= end) {
-			dprintk("New Entry\n");
-			list_add(&new->nd, entry->nd.prev);
-			new = NULL;
+			where = entry->nd.prev;
 			break;
 		}
 
@@ -295,9 +295,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 			dprintk("Overlap at 0x%Lx-0x%Lx\n",
 			       saved_ptr->start, saved_ptr->end);
-			/* No conflict. Go ahead and add this new entry */
-			list_add(&new->nd, saved_ptr->nd.prev);
-			new = NULL;
+			where = saved_ptr->nd.prev;
 			break;
 		}
 
@@ -335,9 +333,7 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 			dprintk("Overlap at 0x%Lx-0x%Lx\n",
 				 saved_ptr->start, saved_ptr->end);
-			/* No conflict. Go ahead and add this new entry */
-			list_add(&new->nd, &saved_ptr->nd);
-			new = NULL;
+			where = &saved_ptr->nd;
 			break;
 		}
 	}
@@ -354,11 +350,10 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		return err;
 	}
 
-	if (new) {
-		/* No conflict. Not yet added to the list. Add to the tail */
+	if (where)
+		list_add(&new->nd, where);
+	else
 		list_add_tail(&new->nd, &memtype_list);
-		dprintk("New Entry\n");
-	}
 
 	spin_unlock(&memtype_lock);
 
-- 
1.5.5.4



