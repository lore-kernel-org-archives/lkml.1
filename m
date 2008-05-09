Return-Path: <linux-kernel-owner+w=401wt.eu-S1753311AbYEIGjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311AbYEIGjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2008 02:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750755AbYEIGjD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 May 2008 02:39:03 -0400
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:18425 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbYEIGjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2008 02:39:01 -0400
Date: Fri, 9 May 2008 08:38:56 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Christoph Lameter <clameter@sgi.com>,
       Gerald Schaefer <gerald.schaefer@de.ibm.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH] sparsemem vmemmap: initialize memmap.
Message-ID: <20080509063856.GC9840@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>

Trying to online a new memory section that was added via memory hotplug
results in lots of messages of pages in bad page state.
Reason is that the alloacted virtual memmap isn't initialized.
This is only an issue for memory sections that get added after boot
time since for all other memmaps the bootmem allocator was used which
returns only initialized memory.

I noticed this on s390 which has its private vmemmap_populate function
without using callbacks to the common code. But as far as I can see the
generic code has the same bug, so fix it just once.

Cc: Andy Whitcroft <apw@shadowen.org>
Cc: Christoph Lameter <clameter@sgi.com>
Cc: Gerald Schaefer <gerald.schaefer@de.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
---
 mm/sparse-vmemmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/mm/sparse-vmemmap.c
===================================================================
--- linux-2.6.orig/mm/sparse-vmemmap.c
+++ linux-2.6/mm/sparse-vmemmap.c
@@ -154,6 +154,6 @@ struct page * __meminit sparse_mem_map_p
 	int error = vmemmap_populate(map, PAGES_PER_SECTION, nid);
 	if (error)
 		return NULL;
-
+	memset(map, 0, PAGES_PER_SECTION * sizeof(struct page));
 	return map;
 }
