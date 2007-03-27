Return-Path: <linux-kernel-owner+w=401wt.eu-S934162AbXC0Sbk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934162AbXC0Sbk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 14:31:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934161AbXC0Sbf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 14:31:35 -0400
Received: from [198.99.130.12] ([198.99.130.12]:45441 "EHLO
	saraswathi.solana.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S934159AbXC0SbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 14:31:06 -0400
Date: Tue, 27 Mar 2007 14:27:50 -0400
From: Jeff Dike <jdike@addtoit.com>
To: Andrew Morton <akpm@osdl.org>
Cc: Jason Lunz <lunz@falooley.org>, LKML <linux-kernel@vger.kernel.org>,
       uml-devel <user-mode-linux-devel@lists.sourceforge.net>
Subject: [PATCH 6/6] UML - Fix LVM crash
Message-ID: <20070327182750.GA8421@c2.user-mode-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Lunz <lunz@falooley.org>

Permit lvm to create logical volumes without crashing UML.

When device-mapper's DM_DEV_CREATE_CMD ioctl is called to create a new
device, dev_create()->dm_create()->alloc_dev()->
blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY) is called.

blk_queue_bounce_limit(BLK_BOUNCE_ANY) calls init_emergency_isa_pool()
if blk_max_pfn < blk_max_low_pfn. This is the case on UML, but
init_emergency_isa_pool() hits BUG_ON(!isa_page_pool) because there
doesn't seem to be a dma zone on UML for mempool_create() to allocate
from.

Most architectures seem to have max_low_pfn == max_pfn, but UML doesn't
because of the uml_reserved chunk it keeps for itself. From what I can
see, max_pfn and max_low_pfn don't get much use after the
bootmem-allocator stops being used anyway, except that they initialize
the block layer's blk_max_low_pfn/blk_max_pfn.

This ensures init_emergency_isa_pool() doesn't crash uml in this
situation by setting max_low_pfn == max_pfn in mem_init().

Signed-off-by: Jason Lunz <lunz@falooley.org>
Signed-off-by: Jeff Dike <jdike@linux.intel.com>
---
 arch/um/kernel/mem.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

Index: linux-2.6.21-mm/arch/um/kernel/mem.c
===================================================================
--- linux-2.6.21-mm.orig/arch/um/kernel/mem.c	2007-03-27 12:25:10.000000000 -0400
+++ linux-2.6.21-mm/arch/um/kernel/mem.c	2007-03-27 12:58:36.000000000 -0400
@@ -64,8 +64,6 @@ static void setup_highmem(unsigned long 
 
 void mem_init(void)
 {
-	max_low_pfn = (high_physmem - uml_physmem) >> PAGE_SHIFT;
-
 	/* clear the zero-page */
 	memset((void *) empty_zero_page, 0, PAGE_SIZE);
 
@@ -80,6 +78,7 @@ void mem_init(void)
 
 	/* this will put all low memory onto the freelists */
 	totalram_pages = free_all_bootmem();
+	max_low_pfn = totalram_pages;
 #ifdef CONFIG_HIGHMEM
 	totalhigh_pages = highmem >> PAGE_SHIFT;
 	totalram_pages += totalhigh_pages;
