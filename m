Return-Path: <linux-kernel-owner+w=401wt.eu-S1758439AbYG0BNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758439AbYG0BNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 21:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756902AbYG0BM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 21:12:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:16496 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757037AbYG0BM5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 21:12:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=hLLa9GvH4C3igzS5wjJOGIp84FeTTZqLqxSLsM9pMP5X/+5H7z37h5XbmS2ibdJ+Tn
         DXoo+k5Ssxp2/O8fFefpoqmeBwVMIJCF93ubb/quZv3o+1S1n+7ajn6AD3wOJdpER0BA
         Ndt9U6ZAYDPYgkBE4VmA3SWk4DiXvM6DvTtsQ=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] usb: don't hide bios bug warning
Date: Sat, 26 Jul 2008 18:12:15 -0700
User-Agent: KMail/1.9.9
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807261812.15836.yhlu.kernel@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


quirk_usb_disable_handoff will wait a while if there is BIOS bug.
let the end user know the reason for that.

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>

---
 drivers/usb/host/pci-quirks.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/usb/host/pci-quirks.c
===================================================================
--- linux-2.6.orig/drivers/usb/host/pci-quirks.c
+++ linux-2.6/drivers/usb/host/pci-quirks.c
@@ -190,7 +190,8 @@ static void __devinit quirk_usb_handoff_
 			msleep(10);
 		}
 		if (wait_time <= 0)
-			dev_warn(&pdev->dev, "OHCI: BIOS handoff failed"
+			dev_printk(KERN_WARNING, &pdev->dev,
+					"OHCI: BIOS handoff failed"
 					" (BIOS bug?) %08x\n",
 					readl(base + OHCI_CONTROL));
 
@@ -242,7 +243,8 @@ static void __devinit quirk_usb_disable_
 		switch (cap & 0xff) {
 		case 1:			/* BIOS/SMM/... handoff support */
 			if ((cap & EHCI_USBLEGSUP_BIOS)) {
-				dev_dbg(&pdev->dev, "EHCI: BIOS handoff\n");
+				dev_printk(KERN_DEBUG, &pdev->dev,
+						"EHCI: BIOS handoff\n");
 
 #if 0
 /* aleksey_gorelov@phoenix.com reports that some systems need SMI forced on,
@@ -283,7 +285,8 @@ static void __devinit quirk_usb_disable_
 				/* well, possibly buggy BIOS... try to shut
 				 * it down, and hope nothing goes too wrong
 				 */
-				dev_warn(&pdev->dev, "EHCI: BIOS handoff failed"
+				dev_printk(KERN_WARNING, &pdev->dev,
+						"EHCI: BIOS handoff failed"
 						" (BIOS bug?) %08x\n", cap);
 				pci_write_config_byte(pdev, offset + 2, 0);
 			}
