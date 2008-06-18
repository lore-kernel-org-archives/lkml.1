Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYFRI1z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYFRI1z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 04:27:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbYFRI1q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 04:27:46 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:16481 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751313AbYFRI1p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 04:27:45 -0400
Message-Id: <4858E330.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Wed, 18 Jun 2008 09:28:00 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: "Dave Airlie" <airlied@linux.ie>
Cc: <linux-kernel@vger.kernel.org>
Subject: agp: two-stage page destruction issue
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

besides it apparently being useful only in 2.6.24 (the changes in 2.6.25
really mean that it could be converted back to a single-stage mechanism),
I'm seeing an issue in Xen Dom0 kernels, which is caused by the calling
of gart_to_virt() in the second stage invocations of the destroy function.
I think that besides this being a real issue with Xen (where
unmap_page_from_agp() is not just a page table attribute change), this
also is invalid from a theoretical perspective: One should not assume that
gart_to_virt() is still valid after unmapping a page. So minimally (keeping
the 2-stage mechanism) a patch like the one below would be needed.

Jan

--- a/drivers/char/agp/backend.c
+++ b/drivers/char/agp/backend.c
@@ -188,10 +188,10 @@ static int agp_backend_initialize(struct
 
 err_out:
 	if (bridge->driver->needs_scratch_page) {
-		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
-						 AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
-						 AGP_PAGE_DESTROY_FREE);
+		void *va = gart_to_virt(bridge->scratch_page_real);
+
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
 	}
 	if (got_gatt)
 		bridge->driver->free_gatt_table(bridge);
@@ -215,10 +215,10 @@ static void agp_backend_cleanup(struct a
 
 	if (bridge->driver->agp_destroy_page &&
 	    bridge->driver->needs_scratch_page) {
-		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
-						 AGP_PAGE_DESTROY_UNMAP);
-		bridge->driver->agp_destroy_page(gart_to_virt(bridge->scratch_page_real),
-						 AGP_PAGE_DESTROY_FREE);
+		void *va = gart_to_virt(bridge->scratch_page_real);
+
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_UNMAP);
+		bridge->driver->agp_destroy_page(va, AGP_PAGE_DESTROY_FREE);
 	}
 }
 
--- a/drivers/char/agp/generic.c
+++ b/drivers/char/agp/generic.c
@@ -202,10 +202,13 @@ void agp_free_memory(struct agp_memory *
 	}
 	if (curr->page_count != 0) {
 		for (i = 0; i < curr->page_count; i++) {
-			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_UNMAP);
+			curr->memory[i] = (unsigned long)gart_to_virt(curr->memory[i]);
+			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
+							       AGP_PAGE_DESTROY_UNMAP);
 		}
 		for (i = 0; i < curr->page_count; i++) {
-			curr->bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[i]), AGP_PAGE_DESTROY_FREE);
+			curr->bridge->driver->agp_destroy_page((void *)curr->memory[i],
+							       AGP_PAGE_DESTROY_FREE);
 		}
 	}
 	agp_free_key(curr->key);
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -428,9 +428,11 @@ static void intel_i810_free_by_type(stru
 		if (curr->page_count == 4)
 			i8xx_destroy_pages(gart_to_virt(curr->memory[0]));
 		else {
-			agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
+			void *va = gart_to_virt(curr->memory[0]);
+
+			agp_bridge->driver->agp_destroy_page(va,
 							     AGP_PAGE_DESTROY_UNMAP);
-			agp_bridge->driver->agp_destroy_page(gart_to_virt(curr->memory[0]),
+			agp_bridge->driver->agp_destroy_page(va,
 							     AGP_PAGE_DESTROY_FREE);
 		}
 		agp_free_page_array(curr);


