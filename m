Return-Path: <linux-kernel-owner+w=401wt.eu-S965859AbXBTBAg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965859AbXBTBAg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 20:00:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965855AbXBTBAf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 20:00:35 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:10999 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965835AbXBTBAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 20:00:34 -0500
Date: Mon, 19 Feb 2007 18:42:30 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH] sata_nv: delay on switching between NCQ and non-NCQ commands
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-ide@vger.kernel.org,
       Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jeff@garzik.org>, Allen Martin <AMartin@nvidia.com>
Message-id: <45DA43F6.80201@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This patch appears to solve some problems with commands timing out in
cases where an NCQ command is immediately followed by a non-NCQ command
(or possibly vice versa). This is a rather ugly solution, but until we
know more about why this is needed, this is about all we can do.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>

--- linux-2.6.20-git6edit/drivers/ata/sata_nv.c.before_hacking	2007-02-15 18:19:13.000000000 -0600
+++ linux-2.6.20-git6edit/drivers/ata/sata_nv.c	2007-02-15 22:36:02.000000000 -0600
@@ -219,6 +219,7 @@
 	void __iomem *		gen_block;
 	void __iomem *		notifier_clear_block;
 	u8			flags;
+	int			last_issue_ncq;
 };
 
 struct nv_host_priv {
@@ -1260,6 +1261,7 @@
 {
 	struct nv_adma_port_priv *pp = qc->ap->private_data;
 	void __iomem *mmio = pp->ctl_block;
+	int curr_ncq = (qc->tf.protocol == ATA_PROT_NCQ);
 
 	VPRINTK("ENTER\n");
 
@@ -1274,6 +1276,14 @@
 	/* write append register, command tag in lower 8 bits
 	   and (number of cpbs to append -1) in top 8 bits */
 	wmb();
+
+	if(curr_ncq != pp->last_issue_ncq) {
+	   	/* Seems to need some delay before switching between NCQ and non-NCQ
+		   commands, else we get command timeouts and such. */
+		udelay(20);
+		pp->last_issue_ncq = curr_ncq;
+	}
+
 	writew(qc->tag, mmio + NV_ADMA_APPEND);
 
 	DPRINTK("Issued tag %u\n",qc->tag);

