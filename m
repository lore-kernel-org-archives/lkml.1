Return-Path: <linux-kernel-owner+w=401wt.eu-S1757268AbYFTUE0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757268AbYFTUE0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2008 16:04:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbYFTUES
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jun 2008 16:04:18 -0400
Received: from outbound-va3.frontbridge.com ([216.32.180.16]:21252 "EHLO
	VA3EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbYFTUER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2008 16:04:17 -0400
X-BigFish: VPS9(z34a4l1033izzz10d3izzz32i6bh43j61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0K2S2EM-02-ZHI-01
Date: Fri, 20 Jun 2008 22:04:02 +0200
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh B Siddha <suresh.b.siddha@intel.com>
Subject: [PATCH 4/7] x86: pat.c consolidate error/debug messages in
	reserve_memtype
Message-ID: <20080620200402.GF4105@alberich.amd.com>
References: <20080620195503.GB4105@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20080620195503.GB4105@alberich.amd.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-OriginalArrivalTime: 20 Jun 2008 20:04:05.0202 (UTC) FILETIME=[CA98FB20:01C8D310]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


... and move last debug message out of locked section.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/mm/pat.c |   51 +++++++++++----------------------------------------
 1 files changed, 11 insertions(+), 40 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index c996a36..1118288 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -269,12 +269,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			}
 
 			if (actual_type != entry->type) {
-				printk(
-		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
-					current->comm, current->pid,
-					start, end,
-					cattr_name(actual_type),
-					cattr_name(entry->type));
 				err = -EBUSY;
 				break;
 			}
@@ -290,12 +284,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 				}
 
 				if (actual_type != entry->type) {
-					printk(
-		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
-						current->comm, current->pid,
-						start, end,
-						cattr_name(actual_type),
-						cattr_name(entry->type));
 					err = -EBUSY;
 					break;
 				}
@@ -321,12 +309,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 			}
 
 			if (actual_type != entry->type) {
-				printk(
-		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
-					current->comm, current->pid,
-					start, end,
-					cattr_name(actual_type),
-					cattr_name(entry->type));
 				err = -EBUSY;
 				break;
 			}
@@ -342,12 +324,6 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 				}
 
 				if (actual_type != entry->type) {
-					printk(
-		KERN_INFO "%s:%d conflicting memory types %Lx-%Lx %s<->%s\n",
-						current->comm, current->pid,
-						start, end,
-						cattr_name(actual_type),
-						cattr_name(entry->type));
 					err = -EBUSY;
 					break;
 				}
@@ -367,10 +343,12 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 	}
 
 	if (err) {
-		printk(KERN_INFO
-	"reserve_memtype failed 0x%Lx-0x%Lx, track %s, req %s\n",
-			start, end, cattr_name(new->type),
-			cattr_name(req_type));
+		printk(KERN_INFO "%s:%d conflicting memory types "
+		       "%Lx-%Lx %s<->%s\n", current->comm, current->pid, start,
+		       end, cattr_name(new->type), cattr_name(entry->type));
+		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
+		       "track %s, req %s\n",
+		       start, end, cattr_name(new->type), cattr_name(req_type));
 		kfree(new);
 		spin_unlock(&memtype_lock);
 		return err;
@@ -382,19 +360,12 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 		dprintk("New Entry\n");
 	}
 
-	if (new_type) {
-		dprintk(
-	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
-			start, end, cattr_name(actual_type),
-			cattr_name(req_type), cattr_name(*new_type));
-	} else {
-		dprintk(
-	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s\n",
-			start, end, cattr_name(actual_type),
-			cattr_name(req_type));
-	}
-
 	spin_unlock(&memtype_lock);
+
+	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
+		start, end, cattr_name(new->type), cattr_name(req_type),
+		new_type ? cattr_name(*new_type) : "-");
+
 	return err;
 }
 
-- 
1.5.5.4



