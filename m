Return-Path: <linux-kernel-owner+w=401wt.eu-S1758092AbYFTUHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758092AbYFTUHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:07:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752934AbYFTUHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:07:30 -0400
Received: from mail-sin.bigfish.com ([207.46.51.74]:12962 "EHLO
	mail186-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbYFTUH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:07:29 -0400
X-BigFish: VPS9(z34a4l1033izzz10d3izzz32i6bh43j64h)
X-Spam-TCS-SCL: 3:0
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0K2S2JT-01-8NH-01
Date: Fri, 20 Jun 2008 22:07:09 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 6/7] x86: pat.c introduce function to check for conflicts
	with existing memtypes
Message-ID: <20080620200709.GH4105@alberich.amd.com>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 20:07:11.0318 (UTC) FILETIME=[39880760:01C8D311]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... to strip down loop body in reserve_memtype.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   96 ++++++++++++++++++----------------------------------
 1 files changed, 33 insertions(+), 63 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 49dcd96..281ac64 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -178,6 +178,33 @@ static unsigned long pat_x_mtrr_type(u64 start, u64 end, unsigned long req_type)
 	return req_type;
 }
 
+static int chk_conflict(struct memtype *new, struct memtype *entry,
+			unsigned long *type)
+{
+	if (new->type != entry->type) {
+		if (type) {
+			new->type = entry->type;
+			*type = entry->type;
+		} else
+			goto conflict;
+	}
+
+	 /* check overlaps with more than one entry in the list */
+	list_for_each_entry_continue(entry, &memtype_list, nd) {
+		if (new->end <= entry->start)
+			break;
+		else if (new->type != entry->type)
+			goto conflict;
+	}
+	return 0;
+
+ conflict:
+	printk(KERN_INFO "%s:%d conflicting memory types "
+	       "%Lx-%Lx %s<->%s\n", current->comm, current->pid, new->start,
+	       new->end, cattr_name(new->type), cattr_name(entry->type));
+	return -EBUSY;
+}
+
 /*
  * req_type typically has one of the:
  * - _PAGE_CACHE_WB
@@ -254,94 +281,37 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	/* Search for existing mapping that overlaps the current range */
 	where = NULL;
 	list_for_each_entry(entry, &memtype_list, nd) {
-		struct memtype *saved_ptr;
-
 		if (entry->start >= end) {
 			where = entry->nd.prev;
 			break;
 		}
 
 		if (start <= entry->start && end >= entry->start) {
-			if (actual_type != entry->type && new_type) {
-				actual_type = entry->type;
-				*new_type = actual_type;
-				new->type = actual_type;
-			}
-
-			if (actual_type != entry->type) {
-				err = -EBUSY;
-				break;
-			}
-
-			saved_ptr = entry;
-			/*
-			 * Check to see whether the request overlaps more
-			 * than one entry in the list
-			 */
-			list_for_each_entry_continue(entry, &memtype_list, nd) {
-				if (end <= entry->start) {
-					break;
-				}
-
-				if (actual_type != entry->type) {
-					err = -EBUSY;
-					break;
-				}
-			}
-
+			err = chk_conflict(new, entry, new_type);
 			if (err) {
 				break;
 			}
 
 			dprintk("Overlap at 0x%Lx-0x%Lx\n",
-			       saved_ptr->start, saved_ptr->end);
-			where = saved_ptr->nd.prev;
+			       entry->start, entry->end);
+			where = entry->nd.prev;
 			break;
 		}
 
 		if (start < entry->end) {
-			if (actual_type != entry->type && new_type) {
-				actual_type = entry->type;
-				*new_type = actual_type;
-				new->type = actual_type;
-			}
-
-			if (actual_type != entry->type) {
-				err = -EBUSY;
-				break;
-			}
-
-			saved_ptr = entry;
-			/*
-			 * Check to see whether the request overlaps more
-			 * than one entry in the list
-			 */
-			list_for_each_entry_continue(entry, &memtype_list, nd) {
-				if (end <= entry->start) {
-					break;
-				}
-
-				if (actual_type != entry->type) {
-					err = -EBUSY;
-					break;
-				}
-			}
-
+			err = chk_conflict(new, entry, new_type);
 			if (err) {
 				break;
 			}
 
 			dprintk("Overlap at 0x%Lx-0x%Lx\n",
-				 saved_ptr->start, saved_ptr->end);
-			where = &saved_ptr->nd;
+				 entry->start, entry->end);
+			where = &entry->nd;
 			break;
 		}
 	}
 
 	if (err) {
-		printk(KERN_INFO "%s:%d conflicting memory types "
-		       "%Lx-%Lx %s<->%s\n", current->comm, current->pid, start,
-		       end, cattr_name(new->type), cattr_name(entry->type));
 		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
 		       "track %s, req %s\n",
 		       start, end, cattr_name(new->type), cattr_name(req_type));
-- 
1.5.5.4



