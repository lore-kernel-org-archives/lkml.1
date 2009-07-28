Return-Path: <linux-kernel-owner+w=401wt.eu-S1753339AbZG1Xte@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339AbZG1Xte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 19:49:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbZG1Xtd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 19:49:33 -0400
Received: from kroah.org ([198.145.64.141]:35611 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753262AbZG1Xtc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 19:49:32 -0400
X-Mailbox-Line: From gregkh@mini.kroah.org Tue Jul 28 16:41:51 2009
Message-Id: <20090728234151.459738282@mini.kroah.org>
User-Agent: quilt/0.48-1
Date: Tue, 28 Jul 2009 16:40:30 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [patch 01/71] SCSI: zalon: fix oops on attach failure
References: <20090728234029.868717854@mini.kroah.org>
Content-Disposition: inline; filename=scsi-zalon-fix-oops-on-attach-failure.patch
In-Reply-To: <20090728234756.GA11917@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.30-stable review patch.  If anyone has any objections, please let us know.

------------------

From: James Bottomley <James.Bottomley@HansenPartnership.com>

commit d3a263a8168f78874254ea9da9595cfb0f3e96d7 upstream.

I recently discovered on my zalon that if the attachment fails because
of a bus misconfiguration (I scrapped my HVD array, so the card is now
unterminated) then the system oopses.  The reason is that if
ncr_attach() returns NULL (signalling failure) that NULL is passed by
the goto failed straight into ncr_detach() which oopses.

The fix is just to return -ENODEV in this case.

Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/zalon.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/zalon.c
+++ b/drivers/scsi/zalon.c
@@ -134,7 +134,7 @@ zalon_probe(struct parisc_device *dev)
 
 	host = ncr_attach(&zalon7xx_template, unit, &device);
 	if (!host)
-		goto fail;
+		return -ENODEV;
 
 	if (request_irq(dev->irq, ncr53c8xx_intr, IRQF_SHARED, "zalon", host)) {
 	  dev_printk(KERN_ERR, &dev->dev, "irq problem with %d, detaching\n ",


