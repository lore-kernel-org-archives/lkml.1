Return-Path: <linux-kernel-owner+w=401wt.eu-S1763182AbXE1RYe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763182AbXE1RYe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 13:24:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbXE1RY0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 13:24:26 -0400
Received: from cavan.codon.org.uk ([217.147.92.49]:46810 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758002AbXE1RYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 13:24:25 -0400
Date: Mon, 28 May 2007 18:24:18 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: David Brownell <david-b@pacbell.net>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20070528172418.GA2076@srcf.ucam.org>
References: <20070527190351.GA21387@srcf.ucam.org> <20070527233911.GA23491@srcf.ucam.org> <20070528003822.GA23759@srcf.ucam.org> <200705271844.54589.david-b@pacbell.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200705271844.54589.david-b@pacbell.net>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
Subject: [PATCH] RTC: Use fallback IRQ if PNP tables don't provide one
X-SA-Exim-Version: 4.2.1 (built Tue, 20 Jun 2006 01:35:45 +0000)
X-SA-Exim-Scanned: Yes (on vavatch.codon.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matthew Garrett <mjg59@srcf.ucam.org>

Intel Macs (and possibly other machines) provide a PNP entry for the 
RTC, but provide no IRQ. As a result the rtc-cmos driver doesn't allow 
wakeup alarms. If the RTC is located at the legacy ioport range, assume 
that it's on IRQ 8 unless the tables say otherwise.

Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

---

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index 6085261..e24ea82 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -641,9 +641,16 @@ cmos_pnp_probe(struct pnp_dev *pnp, const struct pnp_device_id *id)
 	 * drivers can't provide shutdown() methods to disable IRQs.
 	 * Or better yet, fix PNP to allow those methods...
 	 */
-	return cmos_do_probe(&pnp->dev,
-			&pnp->res.port_resource[0],
-			pnp->res.irq_resource[0].start);
+	if (pnp_port_start(pnp,0) == 0x70 && !pnp_irq_valid(pnp,0))
+		/* Some machines contain a PNP entry for the RTC, but
+		 * don't define the IRQ. It should always be safe to
+		 * hardcode it in these cases
+		 */
+		return cmos_do_probe(&pnp->dev, &pnp->res.port_resource[0], 8);
+	else
+		return cmos_do_probe(&pnp->dev,
+				     &pnp->res.port_resource[0],
+				     pnp->res.irq_resource[0].start);
 }
 
 static void __exit cmos_pnp_remove(struct pnp_dev *pnp)

-- 
Matthew Garrett | mjg59@srcf.ucam.org
