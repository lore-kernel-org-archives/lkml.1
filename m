Return-Path: <linux-kernel-owner+w=401wt.eu-S1751378AbXBVFy1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751378AbXBVFy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Feb 2007 00:54:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751389AbXBVFyV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Feb 2007 00:54:21 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:52519 "EHLO
	pd2mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378AbXBVFyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Feb 2007 00:54:17 -0500
Date: Wed, 21 Feb 2007 23:53:03 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: complain on spurious completion notifiers
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>,
       Tejun Heo <htejun@gmail.com>
Message-id: <45DD2FBF.1040808@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Recently Tejun wrote a patch to ahci.c to make it raise a HSM violation
if the drive attempted to complete a tag that wasn't outstanding. We could
run into the same problem with sata_nv ADMA. This adds code to raise a HSM
violation error if the controller gives us a notifier tag that isn't
outstanding, since the drive may be issuing spurious completions.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.21-rc1edit/drivers/ata/sata_nv.c.prev	2007-02-21 22:17:31.000000000 -0600
+++ linux-2.6.21-rc1edit/drivers/ata/sata_nv.c	2007-02-21 22:22:14.000000000 -0600
@@ -740,6 +740,17 @@ static int nv_adma_check_cpb(struct ata_
 			DPRINTK("Completing qc from tag %d with err_mask %u\n",cpb_num,
 				qc->err_mask);
 			ata_qc_complete(qc);
+		} else {
+			struct ata_eh_info *ehi = &ap->eh_info;
+			/* Notifier bits set without a command may indicate the drive
+			   is misbehaving. Raise host state machine violation on this
+			   condition. */
+			ata_port_printk(ap, KERN_ERR, "notifier for tag %d with no command?\n",
+				cpb_num);
+			ehi->err_mask |= AC_ERR_HSM;
+			ehi->action |= ATA_EH_SOFTRESET;
+			ata_port_freeze(ap);
+			return 1;
 		}
 	}
 	return 0;

