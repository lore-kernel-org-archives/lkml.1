Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936336Ab0CMBMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 20:12:47 -0500
Received: from kroah.org ([198.145.64.141]:46651 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935335Ab0CMAao (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 19:30:44 -0500
X-Mailbox-Line: From gregkh@kvm.kroah.org Fri Mar 12 16:27:06 2010
Message-Id: <20100313002706.534349849@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Fri, 12 Mar 2010 16:25:48 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Chandru Siddalingappa <chandru@linux.vnet.ibm.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [015/145] PCI hotplug: ibmphp: read the length of ebda and map entire ebda region
In-Reply-To: <20100313002816.GA18903@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let me know.

----------------
From: Chandru <chandru@in.ibm.com>

commit b0fc889c4311835ae7d02f433154bc20cad9ee11 upstream.

ibmphp driver currently maps only 1KB of ebda memory area into kernel address
space during driver initialization. This causes kernel oops when the driver is
modprobe'd and it accesses memory beyond 1KB within ebda segment. The first
byte of ebda segment actually stores the length of the ebda region in
Kilobytes. Hence make use of the length parameter and map the entire ebda
region.

Signed-off-by: Chandru Siddalingappa <chandru@linux.vnet.ibm.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/hotplug/ibmphp_ebda.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/drivers/pci/hotplug/ibmphp_ebda.c
+++ b/drivers/pci/hotplug/ibmphp_ebda.c
@@ -245,7 +245,7 @@ static void __init print_ebda_hpc (void)
 
 int __init ibmphp_access_ebda (void)
 {
-	u8 format, num_ctlrs, rio_complete, hs_complete;
+	u8 format, num_ctlrs, rio_complete, hs_complete, ebda_sz;
 	u16 ebda_seg, num_entries, next_offset, offset, blk_id, sub_addr, re, rc_id, re_id, base;
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


