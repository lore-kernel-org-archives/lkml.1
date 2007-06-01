Return-Path: <linux-kernel-owner+w=401wt.eu-S1762204AbXFARan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762204AbXFARan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 13:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760890AbXFARah
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 13:30:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44251 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760073AbXFARag (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 13:30:36 -0400
Message-ID: <466057B1.9090309@redhat.com>
Date: Fri, 01 Jun 2007 13:30:25 -0400
From: Rik van Riel <riel@redhat.com>
Organization: Red Hat, Inc
User-Agent: Thunderbird 1.5.0.7 (X11/20061008)
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>
CC: andrew.vasquez@qlogic.com
Subject: [PATCH] quiet down swiotlb warnings
Content-Type: multipart/mixed;
 boundary="------------050103060900040607080908"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050103060900040607080908
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

It turns out that the qla2xxx driver sometimes fills up the iotlb
on purpose and throttles itself when pci_map_sg() fails.  In the
case of a driver that expects and handles pci_map_sg() failures,
we should not spam the user's console with swiotlb full messages.

If the user runs a driver that cannot handle the swiotlb filling
up, 5 warnings should be enough to leave a clue.

Signed-off-by: Rik van Riel <riel@redhat.com>

--------------050103060900040607080908
Content-Type: text/x-patch;
 name="2.6.21-swiotlb-quiet.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="2.6.21-swiotlb-quiet.patch"

--- linux-2.6.21.noarch/lib/swiotlb.c.quiet	2007-06-01 13:23:04.000000000 -0400
+++ linux-2.6.21.noarch/lib/swiotlb.c	2007-06-01 13:25:49.000000000 -0400
@@ -505,6 +505,7 @@ swiotlb_free_coherent(struct device *hwd
 static void
 swiotlb_full(struct device *dev, size_t size, int dir, int do_panic)
 {
+	static int warnings = 0;
 	/*
 	 * Ran out of IOMMU space for this operation. This is very bad.
 	 * Unfortunately the drivers cannot handle this operation properly.
@@ -512,8 +513,9 @@ swiotlb_full(struct device *dev, size_t 
 	 * When the mapping is small enough return a static buffer to limit
 	 * the damage, or panic when the transfer is too big.
 	 */
-	printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
-	       "device %s\n", size, dev ? dev->bus_id : "?");
+	if (++warnings < 5)
+		printk(KERN_ERR "DMA: Out of SW-IOMMU space for %zu bytes at "
+		       "device %s\n", size, dev ? dev->bus_id : "?");
 
 	if (size > io_tlb_overflow && do_panic) {
 		if (dir == DMA_FROM_DEVICE || dir == DMA_BIDIRECTIONAL)

--------------050103060900040607080908--
