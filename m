Return-Path: <linux-kernel-owner+w=401wt.eu-S1764781AbYETKxW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764781AbYETKxW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 06:53:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765060AbYETKwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 06:52:23 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:54025 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759885AbYETKwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 06:52:21 -0400
Date: Tue, 20 May 2008 12:51:45 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Dave Hansen <haveblue@us.ibm.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Yasunori Goto <y-goto@jp.fujitsu.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] memory hotplug: fix early allocation handling
Message-ID: <20080520105145.GA24526@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to add memory via add_memory() from within an initcall function
results in

bootmem alloc of 163840 bytes failed!
Kernel panic - not syncing: Out of memory

This is caused by zone_wait_table_init() which uses system_state to
decide if it should use the bootmem allocator or not.
When initcalls are handled the system_state is still SYSTEM_BOOTING
but the bootmem allocator doesn't work anymore. So the allocation
will fail.

To fix this use slab_is_available() instead as indicator like we do
it everywhere else.

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Dave Hansen <haveblue@us.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 mm/page_alloc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/page_alloc.c
===================================================================
--- linux-2.6.orig/mm/page_alloc.c
+++ linux-2.6/mm/page_alloc.c
@@ -2804,7 +2804,7 @@ int zone_wait_table_init(struct zone *zo
 	alloc_size = zone->wait_table_hash_nr_entries
 					* sizeof(wait_queue_head_t);
 
- 	if (system_state == SYSTEM_BOOTING) {
+ 	if (!slab_is_available()) {
 		zone->wait_table = (wait_queue_head_t *)
 			alloc_bootmem_node(pgdat, alloc_size);
 	} else {
