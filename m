Return-Path: <linux-kernel-owner+w=401wt.eu-S1756906AbYBKAfe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbYBKAfe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 19:35:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754640AbYBKAfY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 19:35:24 -0500
Received: from smtp-out04.alice-dsl.net ([88.44.63.6]:20006 "EHLO
	smtp-out04.alice-dsl.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbYBKAfX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 19:35:23 -0500
Date: Mon, 11 Feb 2008 01:35:20 +0100
From: Andi Kleen <andi@firstfloor.org>
To: torvalds@osdl.org, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] Prevent IDE boot ops on NUMA system in mainline
Message-ID: <20080211003520.GA32082@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
X-OriginalArrivalTime: 11 Feb 2008 00:28:59.0492 (UTC) FILETIME=[1837EA40:01C86C45]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Without this patch a Opteron test system here oopses at boot with currentg git. 

Calling to_pci_dev() on a NULL pointer gives a negative value so the following NULL 
pointer check never triggers and then an illegal address is referenced. Check the 
unadjusted original device pointer for NULL instead.

Signed-off-by: Andi Kleen <ak@suse.de>

Index: linux/include/linux/ide.h
===================================================================
--- linux.orig/include/linux/ide.h
+++ linux/include/linux/ide.h
@@ -1294,7 +1294,7 @@ static inline void ide_dump_identify(u8 
 static inline int hwif_to_node(ide_hwif_t *hwif)
 {
 	struct pci_dev *dev = to_pci_dev(hwif->dev);
-	return dev ? pcibus_to_node(dev->bus) : -1;
+	return hwif->dev ? pcibus_to_node(dev->bus) : -1;
 }
 
 static inline ide_drive_t *ide_get_paired_drive(ide_drive_t *drive)
