Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023Ab0AILmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023Ab0AILmb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jan 2010 06:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752773Ab0AILma
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Jan 2010 06:42:30 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:38070 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab0AILma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jan 2010 06:42:30 -0500
From: Chandru <chandru@in.ibm.com>
Organization: ibm
To: linux-kernel@vger.kernel.org
Subject: [PATCH] ibmphp : read the length of ebda and map entire ebda region
Date: Sat, 9 Jan 2010 17:12:25 +0530
User-Agent: KMail/1.11.2 (Linux/2.6.30.9-90.fc11.x86_64; KDE/4.2.2; x86_64; ; )
Cc: gregkh@suse.de, Andrew Morton <akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201001091712.25655.chandru@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ibmphp driver currently maps only 1KB of ebda memory area into kernel address 
space during driver initialization. This causes kernel oops when the driver is 
modprobe'd and it accesses memory area beyond 1KB within ebda segment. The first 
byte of ebda segment actually stores the length of the ebda region in 
Kilobytes. Hence make use of the length parameter and map the entire ebda 
region.


Signed-off-by: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
---

 drivers/pci/hotplug/ibmphp_ebda.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- linux-2.6.33-rc2/drivers/pci/hotplug/ibmphp_ebda.c.orig	2010-01-09 
15:23:54.000000000 +0530
+++ linux-2.6.33-rc2/drivers/pci/hotplug/ibmphp_ebda.c	2010-01-09 
17:01:06.000000000 +0530
@@ -245,7 +245,7 @@ static void __init print_ebda_hpc (void)
 
 int __init ibmphp_access_ebda (void)
 {
-	u8 format, num_ctlrs, rio_complete, hs_complete;
+	u8 format, num_ctlrs, rio_complete, hs_complete, ebda_sz;
 	u16 ebda_seg, num_entries, next_offset, offset, blk_id, sub_addr, re, rc_id, 
re_id, base;
 	int rc = 0;
 
@@ -260,7 +260,14 @@ int __init ibmphp_access_ebda (void)
 	iounmap (io_mem);
 	debug ("returned ebda segment: %x\n", ebda_seg);
 	
-	io_mem = ioremap(ebda_seg<<4, 1024);
+	io_mem = ioremap(ebda_seg<<4, 1);
+	ebda_sz = readb(io_mem);
+	iounmap(io_mem);
+	debug("ebda size: %d(KiB)\n", ebda_sz);
+	if (ebda_sz == 0)
+		return -ENOMEM;
+
+	io_mem = ioremap(ebda_seg<<4, (ebda_sz * 1024));
 	if (!io_mem )
 		return -ENOMEM;
 	next_offset = 0x180;


