Return-Path: <linux-kernel-owner+w=401wt.eu-S1753090AbZAZTNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753090AbZAZTNv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 14:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753293AbZAZTN3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 14:13:29 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:43314 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752914AbZAZTN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 14:13:27 -0500
Date: Mon, 26 Jan 2009 19:12:56 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Hugh Dickins <hugh@veritas.com>
Cc: Jeff Garzik <jgarzik@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc libata sff 32bit PIO regression
Message-ID: <20090126191256.04dfb6d3@lxorguk.ukuu.org.uk>
In-Reply-To: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
References: <Pine.LNX.4.64.0901211322010.15945@blonde.anvils>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.12; x86_64-redhat-linux-gnu)
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street,
 Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a
 Lloegr o'r rhif cofrestru 3798903
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And while we are at it fix the 32bit PIO handling for VLB for this case
too

pata_legacy: For VLB 32bit PIO don't try tricks with slop

From: Alan Cox <alan@lxorguk.ukuu.org.uk>

These devices are generally used with ATA anyway and it seems that some
ATAPI will need us to issue the right number of words. Therefore as we
can't switch mid burst on VLB devices we should only use 32bit I/O for
suitable block sizes.
---

 drivers/ata/pata_legacy.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)


diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index 6c1d778..e3bc1b4 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -283,9 +283,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 static unsigned int pdc_data_xfer_vlb(struct ata_device *dev,
 			unsigned char *buf, unsigned int buflen, int rw)
 {
-	if (ata_id_has_dword_io(dev->id)) {
+	int slop = buflen & 3;
+	/* 32bit I/O capable *and* we need to write a whole number of dwords */
+	if (ata_id_has_dword_io(dev->id) && (slop == 0 || slop == 3)) {
 		struct ata_port *ap = dev->link->ap;
-		int slop = buflen & 3;
 		unsigned long flags;
 
 		local_irq_save(flags);
@@ -735,7 +736,7 @@ static unsigned int vlb32_data_xfer(struct ata_device *adev, unsigned char *buf,
 	struct ata_port *ap = adev->link->ap;
 	int slop = buflen & 3;
 
-	if (ata_id_has_dword_io(adev->id)) {
+	if (ata_id_has_dword_io(adev->id) && (slop == 0 || slop == 3)) {
 		if (rw == WRITE)
 			iowrite32_rep(ap->ioaddr.data_addr, buf, buflen >> 2);
 		else
