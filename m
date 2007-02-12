Return-Path: <linux-kernel-owner+w=401wt.eu-S932940AbXBLAp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbXBLAp2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 19:45:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932883AbXBLAp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 19:45:27 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:58549 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932881AbXBLApO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 19:45:14 -0500
Date: Sun, 11 Feb 2007 18:34:44 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: add back some verbosity into ADMA error_handler
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@osdl.org>
Message-id: <45CFB624.9020201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Some debug output in the ADMA error_handler function was removed recently,
but it may be useful in certain cases, like NCQ commands timing out. Add it
back in, but make it a bit more intelligent so that it only prints if
command(s) are active and only prints the CPBs for those commands.
That way it won't spew at inappropriate times like suspend/resume.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git6/drivers/ata/sata_nv.c	2007-02-11 17:31:19.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_nv.c	2007-02-11 17:40:48.000000000 -0600
@@ -1442,6 +1442,26 @@ static void nv_adma_error_handler(struct
 		void __iomem *mmio = pp->ctl_block;
 		int i;
 		u16 tmp;
+		
+		if(ata_tag_valid(ap->active_tag) || ap->sactive) {
+			u32 notifier = readl(mmio + NV_ADMA_NOTIFIER);
+			u32 notifier_error = readl(mmio + NV_ADMA_NOTIFIER_ERROR);
+			u32 gen_ctl = readl(pp->gen_block + NV_ADMA_GEN_CTL);
+			u32 status = readw(mmio + NV_ADMA_STAT);
+
+			ata_port_printk(ap, KERN_ERR, "EH in ADMA mode, notifier 0x%X "
+				"notifier_error 0x%X gen_ctl 0x%X status 0x%X\n",
+				notifier, notifier_error, gen_ctl, status);
+
+			for( i=0;i<NV_ADMA_MAX_CPBS;i++) {
+				struct nv_adma_cpb *cpb = &pp->cpb[i];
+				if( (ata_tag_valid(ap->active_tag) && i == ap->active_tag) ||
+				    ap->sactive & (1 << i) )
+					ata_port_printk(ap, KERN_ERR,
+						"CPB %d: ctl_flags 0x%x, resp_flags 0x%x\n",
+						i, cpb->ctl_flags, cpb->resp_flags);
+			}
+		}
 
 		/* Push us back into port register mode for error handling. */
 		nv_adma_register_mode(ap);

