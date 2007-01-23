Return-Path: <linux-kernel-owner+w=401wt.eu-S932509AbXAWFFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbXAWFFn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jan 2007 00:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932410AbXAWFFn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jan 2007 00:05:43 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:28676 "EHLO
	pd5mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbXAWFFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jan 2007 00:05:42 -0500
Date: Mon, 22 Jan 2007 23:03:52 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: SATA exceptions with 2.6.20-rc5
In-reply-to: <20070123024412.GA16533@atjola.homenet>
To: =?ISO-8859-1?Q?Bj=F6rn_Steinbrink?= <B.Steinbrink@gmx.de>,
       Jeff Garzik <jeff@garzik.org>, Chr <chunkeey@web.de>,
       Alistair John Strachan <s0348365@sms.ed.ac.uk>,
       linux-kernel@vger.kernel.org, htejun@gmail.com, jens.axboe@oracle.com,
       lwalton@real.com, pomac@vapor.com
Message-id: <45B59738.3050704@shaw.ca>
MIME-version: 1.0
Content-type: multipart/mixed; boundary="Boundary_(ID_uk1mtNPRzFlUu2edB1tXdQ)"
References: <fa.ow4pXUncgdZmfLf3oyfrn1W+Bk0@ifi.uio.no>
 <fa.SoSeidhDuEr/K0kN+L4vW61Vpnc@ifi.uio.no>
 <fa.m8QbVQMhuOshKzTdlSjNjOhaNcc@ifi.uio.no>
 <fa.hDS02YCM8Tv1/STeTpJGEQD/49s@ifi.uio.no>
 <fa.eqBbU9XvtTizNMpuUjctnk8vuOI@ifi.uio.no>
 <fa.4QxeKMcmkoyhlL26AivZV6BFQJQ@ifi.uio.no> <45B563C6.5070505@shaw.ca>
 <20070123024412.GA16533@atjola.homenet>
User-Agent: Thunderbird 1.5.0.9 (Windows/20061207)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Boundary_(ID_uk1mtNPRzFlUu2edB1tXdQ)
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 8BIT

Björn Steinbrink wrote:
> Hm, I don't think it is unhappy about looking at NV_INT_STATUS_CK804.
> I'm running 2.6.20-rc5 with the INT_DEV check removed for 8 hours now
> without a single problem and that should still look at
> NV_INT_STATUS_CK804, right?
> I just noticed that my last email might not have been clear enough. The
> exceptions happened when I re-enabled the return statement in addition
> to the debug message. Without the INT_DEV check, it is completely fine
> AFAICT.

Indeed, it seems to be just the NV_INT_DEV check that is problematic. 
Here's a patch that's likely better to test, it forces the NV_INT_DEV 
flag on when a command is active, and also fixes that questionable code 
in nv_host_intr that I mentioned.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/


--Boundary_(ID_uk1mtNPRzFlUu2edB1tXdQ)
Content-type: text/plain; name=sata_nv-force-int-dev-in-interrupt.patch
Content-transfer-encoding: 7BIT
Content-disposition: inline; filename=sata_nv-force-int-dev-in-interrupt.patch

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

--Boundary_(ID_uk1mtNPRzFlUu2edB1tXdQ)--
