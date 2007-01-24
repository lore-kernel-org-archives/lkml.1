Return-Path: <linux-kernel-owner+w=401wt.eu-S965612AbXAXCJv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965612AbXAXCJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 21:09:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965615AbXAXCJv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 21:09:51 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:53015 "EHLO
	pd3mo3so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965612AbXAXCJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 21:09:50 -0500
Date: Tue, 23 Jan 2007 20:09:02 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: [PATCH 2.6.20] sata_nv: don't rely on NV_INT_DEV indication with ADMA
In-reply-to: <20070124003923.GA3093@atjola.homenet>
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Larry Walton <lwalton@real.com>, s0348365@sms.ed.ac.uk, pomac@vapor.com,
       chunkeey@web.de, Jeff Garzik <jeff@garzik.org>
Message-id: <45B6BFBE.5060709@shaw.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary=------------020208040709060709040908
References: <fa.1kBz5luWz8nR0lLqm1VD4hZZYdw@ifi.uio.no>
 <fa.QZxgjxcwtENaZNY24NMTlKBSgIM@ifi.uio.no>
 <fa.fkPTbUGmKc/1pt0eD6TE4d02n+Q@ifi.uio.no>
 <fa.6iQt5OtHZ3x5w8eYbLxwULhLTJ0@ifi.uio.no>
 <fa.1aqo3IxNGJClHcBVZNTagX6bL9o@ifi.uio.no>
 <fa.rI60BGlFbSyfLyumqmgiOfDqCI4@ifi.uio.no> <45B697D3.4070707@shaw.ca>
 <20070124003923.GA3093@atjola.homenet>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------020208040709060709040908
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

OK, here it is in full signed-off glory. Hopefully we can get this in 
for 2.6.20.

---

Several people reported issues with certain drive commands timing out on 
sata_nv controllers running in ADMA mode. The commands in question were 
non-DMA-mapped commands, usually FLUSH CACHE or FLUSH CACHE EXT.

 From experimentation it appears that the NV_INT_DEV indication isn't 
always set when a legitimate command completion interrupt is received on 
a legacy-mode command, at least not on these controllers in ADMA mode. 
When a command is pending on the port, force the flag on always in the 
irq_stat value before calling nv_host_intr so that the drive busy state 
is always checked by ata_host_intr.

This also fixes some questionable code in nv_host_intr which called 
ata_check_status when a command was pending and ata_host_intr returned 
"unhandled". If the device interrupted at just the wrong time this could 
cause interrupts to be lost.

Signed-off-by: Robert Hancock <hancockr@shaw.ca>


--------------020208040709060709040908
Content-Type: text/plain;
 name="sata_nv-force-int-dev-in-interrupt.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="sata_nv-force-int-dev-in-interrupt.patch"

--- linux-2.6.20-rc5/drivers/ata/sata_nv.c	2007-01-19 19:18:53.000000000 -0600
+++ linux-2.6.20-rc5debug/drivers/ata/sata_nv.c	2007-01-22 22:33:43.000000000 -0600
@@ -700,7 +700,6 @@ static void nv_adma_check_cpb(struct ata
 static int nv_host_intr(struct ata_port *ap, u8 irq_stat)
 {
 	struct ata_queued_cmd *qc = ata_qc_from_tag(ap, ap->active_tag);
-	int handled;
 
 	/* freeze if hotplugged */
 	if (unlikely(irq_stat & (NV_INT_ADDED | NV_INT_REMOVED))) {
@@ -719,13 +718,7 @@ static int nv_host_intr(struct ata_port 
 	}
 
 	/* handle interrupt */
-	handled = ata_host_intr(ap, qc);
-	if (unlikely(!handled)) {
-		/* spurious, clear it */
-		ata_check_status(ap);
-	}
-
-	return 1;
+	return ata_host_intr(ap, qc);
 }
 
 static irqreturn_t nv_adma_interrupt(int irq, void *dev_instance)
@@ -752,6 +745,11 @@ static irqreturn_t nv_adma_interrupt(int
 			if (pp->flags & NV_ADMA_PORT_REGISTER_MODE) {
 				u8 irq_stat = readb(host->mmio_base + NV_INT_STATUS_CK804)
 					>> (NV_INT_PORT_SHIFT * i);
+				if(ata_tag_valid(ap->active_tag))
+					/** NV_INT_DEV indication seems unreliable at times
+					    at least in ADMA mode. Force it on always when a
+					    command is active, to prevent losing interrupts. */
+					irq_stat |= NV_INT_DEV;
 				handled += nv_host_intr(ap, irq_stat);
 				continue;
 			}

--------------020208040709060709040908--

