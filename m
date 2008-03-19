Return-Path: <linux-kernel-owner+w=401wt.eu-S934259AbYCSUgq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934259AbYCSUgq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 16:36:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755190AbYCSTli
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:41:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:13575 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757788AbYCSTlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:41:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,520,1199692800"; 
   d="scan'208";a="536061940"
Message-Id: <20080319000101.007019000@intel.com>
References: <20080319000012.439150000@intel.com>
User-Agent: quilt/0.46-1
Date: Tue, 18 Mar 2008 17:00:25 -0700
From: venkatesh.pallipadi@intel.com
To: ak@muc.de, ebiederm@xmission.com, rdreier@cisco.com,
       torvalds@linux-foundation.org, gregkh@suse.de, airlied@skynet.ie,
       davej@redhat.com, mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
       akpm@linux-foundation.org, arjan@infradead.org, jesse.barnes@intel.com
Cc: linux-kernel@vger.kernel.org,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Suresh Siddha <suresh.b.siddha@intel.com>
Subject: [patch 13/13] x86: PAT Patch to add PAT related debug prints
Content-Disposition: inline; filename=debug_reserve_free_memtype.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds debug prints at critical code. Adds enough info in dmesg to allow us to
do effective first round of analysis of any issues that may result due to PAT
patch series.

Signed-off-by: Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>

Index: linux-2.6-x86.git/arch/x86/mm/pat.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/pat.c	2008-03-18 03:40:47.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/pat.c	2008-03-18 03:56:52.000000000 -0700
@@ -289,6 +289,7 @@
 		struct memtype *saved_ptr;
 
 		if (parse->start >= end) {
+			printk("New Entry\n");
 			list_add(&new_entry->nd, parse->nd.prev);
 			new_entry = NULL;
 			break;
@@ -338,6 +339,8 @@
 				break;
 			}
 
+			printk("Overlap at 0x%Lx-0x%Lx\n",
+			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, saved_ptr->nd.prev);
 			new_entry = NULL;
@@ -388,6 +391,8 @@
 				break;
 			}
 
+			printk("Overlap at 0x%Lx-0x%Lx\n",
+			       saved_ptr->start, saved_ptr->end);
 			/* No conflict. Go ahead and add this new entry */
 			list_add(&new_entry->nd, &saved_ptr->nd);
 			new_entry = NULL;
@@ -396,6 +401,10 @@
 	}
 
 	if (err) {
+		printk(
+	"reserve_memtype failed 0x%Lx-0x%Lx, track %s, req %s\n",
+			start, end, cattr_name(new_entry->type),
+			cattr_name(req_type));
 		kfree(new_entry);
 		spin_unlock(&memtype_lock);
 		return err;
@@ -404,6 +413,19 @@
 	if (new_entry) {
 		/* No conflict. Not yet added to the list. Add to the tail */
 		list_add_tail(&new_entry->nd, &memtype_list);
+		printk("New Entry\n");
+  	}
+
+	if (ret_type) {
+		printk(
+	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
+			start, end, cattr_name(actual_type),
+			cattr_name(req_type), cattr_name(*ret_type));
+	} else {
+		printk(
+	"reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s\n",
+			start, end, cattr_name(actual_type),
+			cattr_name(req_type));
 	}
 
 	spin_unlock(&memtype_lock);
@@ -440,6 +462,8 @@
 		printk(KERN_DEBUG "%s:%d freeing invalid memtype %Lx-%Lx\n",
 			current->comm, current->pid, start, end);
 	}
+
+	printk( "free_memtype request 0x%Lx-0x%Lx\n", start, end);
 	return err;
 }
 
Index: linux-2.6-x86.git/arch/x86/mm/ioremap.c
===================================================================
--- linux-2.6-x86.git.orig/arch/x86/mm/ioremap.c	2008-03-18 03:54:39.000000000 -0700
+++ linux-2.6-x86.git/arch/x86/mm/ioremap.c	2008-03-18 03:56:52.000000000 -0700
@@ -179,6 +179,10 @@
 		      new_prot_val == _PAGE_CACHE_WC)) ||
 		    (prot_val == _PAGE_CACHE_WC &&
 		     new_prot_val == _PAGE_CACHE_WB)) {
+			printk(
+		"ioremap error for 0x%lx-0x%lx, requested 0x%lx, got 0x%lx\n",
+				phys_addr, phys_addr + size,
+				prot_val, new_prot_val);
 			free_memtype(phys_addr, phys_addr + size);
 			return NULL;
 		}

-- 
