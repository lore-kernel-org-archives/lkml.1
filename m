Return-Path: <linux-kernel-owner+w=401wt.eu-S1757065AbYGaPqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757065AbYGaPqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 11:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751658AbYGaPqE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 11:46:04 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:37779 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094AbYGaPqD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 11:46:03 -0400
Message-Id: <4891FA82.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Thu, 31 Jul 2008 16:46:42 +0100
From: "Jan Beulich" <jbeulich@novell.com>
To: <linux-kernel@vger.kernel.org>
Cc: "Ingo Molnar" <mingo@elte.hu>, <dbaryshkov@gmail.com>,
       <James.Bottomley@HansenPartnership.com>
Subject: [PATCH] fix order calculation in
	dma_mark_declared_memory_occupied()
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_order() takes byte-sized input, not a page-granular one.

Irrespective of this fix I'm inclined to believe that this doesn't work
right anyway - bitmap_allocate_region() has an implicit assumption of
'pos' being suitable for 'order', which this function doesn't seem to
enforce (and since it's being called with a byte-granular value there's
no reason to believe that the callers would make sure device_addr is
passed accordingly - it's also not documented that way).

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: James E.J. Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Dmitry Baryshkov <dbaryshkov@gmail.com>

---
 kernel/dma-coherent.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- linux-2.6.27-rc1/kernel/dma-coherent.c	2008-07-31 17:08:36.000000000 +0200
+++ 2.6.27-rc1-dma-mark-declared/kernel/dma-coherent.c	2008-07-31 14:35:59.000000000 +0200
@@ -77,15 +77,14 @@ void *dma_mark_declared_memory_occupied(
 {
 	struct dma_coherent_mem *mem = dev->dma_mem;
 	int pos, err;
-	int pages = (size + (device_addr & ~PAGE_MASK) + PAGE_SIZE - 1);
 
-	pages >>= PAGE_SHIFT;
+	size += device_addr & ~PAGE_MASK;
 
 	if (!mem)
 		return ERR_PTR(-EINVAL);
 
 	pos = (device_addr - mem->device_base) >> PAGE_SHIFT;
-	err = bitmap_allocate_region(mem->bitmap, pos, get_order(pages));
+	err = bitmap_allocate_region(mem->bitmap, pos, get_order(size));
 	if (err != 0)
 		return ERR_PTR(err);
 	return mem->virt_base + (pos << PAGE_SHIFT);



