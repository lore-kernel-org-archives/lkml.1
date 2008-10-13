Return-Path: <linux-kernel-owner+w=401wt.eu-S1758435AbYJMUWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758435AbYJMUWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 16:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755410AbYJMUWJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 16:22:09 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:38583 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189AbYJMUWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 16:22:08 -0400
Message-ID: <48F3ADEF.1080905@austin.ibm.com>
Date: Mon, 13 Oct 2008 15:22:07 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080925)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Badari Pulavarty <pbadari@us.ibm.com>
Subject: [PATCH] release memory regions in PAGES_PER_SECTION chunks
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During hotplug memory remove, memory regions should be released
on a PAGES_PER_SECTION size chunks.  This mirrors the code in
add_memory where resources are requested on a PAGES_PER_SECTION size.

Attempting to release the entire memory region fails because there is
not a single resource for the total number of pages being removed.
Instead the resources for the pages are split in PAGES_PER_SECTION
size chunks as requested during memory add.

Signed-off-by: Nathan Fontenot <nfont@austin.ibm.com>
Signed-off-by: Badari Pulavarty <pbadari@us.ibm.com>

---

Index: linux-2.6/mm/memory_hotplug.c
===================================================================
--- linux-2.6.orig/mm/memory_hotplug.c	2008-10-13 12:00:46.000000000 -0500
+++ linux-2.6/mm/memory_hotplug.c	2008-10-13 14:29:31.000000000 -0500
@@ -323,11 +323,11 @@
 	BUG_ON(phys_start_pfn & ~PAGE_SECTION_MASK);
 	BUG_ON(nr_pages % PAGES_PER_SECTION);
 
-	release_mem_region(phys_start_pfn << PAGE_SHIFT, nr_pages * PAGE_SIZE);
-
 	sections_to_remove = nr_pages / PAGES_PER_SECTION;
 	for (i = 0; i < sections_to_remove; i++) {
 		unsigned long pfn = phys_start_pfn + i*PAGES_PER_SECTION;
+		release_mem_region(pfn << PAGE_SHIFT,
+				   PAGES_PER_SECTION << PAGE_SHIFT);
 		ret = __remove_section(zone, __pfn_to_section(pfn));
 		if (ret)
 			break;
