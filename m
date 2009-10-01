Return-Path: <linux-kernel-owner+w=401wt.eu-S1755800AbZJAIBP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbZJAIBP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:01:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755739AbZJAIBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:01:15 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:12069 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755694AbZJAIBO convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;5:1>);
	Thu, 1 Oct 2009 04:01:14 -0400
Message-Id: <4AC47DED0200007800017743@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 01 Oct 2009 09:01:17 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <ketuzsezr@darnok.org>, <pjones@redhat.com>
Cc: "Jeremy Fitzhardinge" <Jeremy.Fitzhardinge@citrix.com>,
       "Martin Wilck" <Martin.Wilck@fujitsu-siemens.com>,
       <linux-kernel@vger.kernel.org>
Subject: [PATCH] iSCSI/iBFT: use proper address translation
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In virtual environments (namely, Xen Dom0) virt <-> phys and
virt <-> isa-bus translations cannot be freely interchanged. When
looking at memory below 1M, the latter translations should always
be used.

iscsi_ibft_find.c part from: Martin Wilck <martin.wilck@ts.fujitsu.com>.

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>

---
 drivers/firmware/iscsi_ibft.c      |    2 +-
 drivers/firmware/iscsi_ibft_find.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

--- linux-2.6.32-rc1/drivers/firmware/iscsi_ibft.c	2009-06-10 05:05:27.000000000 +0200
+++ 2.6.32-rc1-ibft-addr-xlat/drivers/firmware/iscsi_ibft.c	2009-09-24 12:14:48.000000000 +0200
@@ -939,7 +939,7 @@ static int __init ibft_init(void)
 
 	if (ibft_addr) {
 		printk(KERN_INFO "iBFT detected at 0x%llx.\n",
-		       (u64)virt_to_phys((void *)ibft_addr));
+		       (u64)isa_virt_to_bus(ibft_addr));
 
 		rc = ibft_check_device();
 		if (rc)
--- linux-2.6.32-rc1/drivers/firmware/iscsi_ibft_find.c	2008-10-10 00:13:53.000000000 +0200
+++ 2.6.32-rc1-ibft-addr-xlat/drivers/firmware/iscsi_ibft_find.c	2009-09-24 09:52:18.000000000 +0200
@@ -65,10 +65,10 @@ void __init reserve_ibft_region(void)
 		 * so skip that area */
 		if (pos == VGA_MEM)
 			pos += VGA_SIZE;
-		virt = phys_to_virt(pos);
+		virt = isa_bus_to_virt(pos);
 		if (memcmp(virt, IBFT_SIGN, IBFT_SIGN_LEN) == 0) {
 			unsigned long *addr =
-			    (unsigned long *)phys_to_virt(pos + 4);
+			    (unsigned long *)isa_bus_to_virt(pos + 4);
 			len = *addr;
 			/* if the length of the table extends past 1M,
 			 * the table cannot be valid. */



