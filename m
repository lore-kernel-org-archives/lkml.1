Return-Path: <linux-kernel-owner+w=401wt.eu-S1756716AbXJHSI3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716AbXJHSI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2007 14:08:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754534AbXJHSIA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Oct 2007 14:08:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:51681 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbXJHSH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2007 14:07:58 -0400
Date: Mon, 8 Oct 2007 11:06:04 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: [patch 01/12] scsi_transport_spi: fix domain validation failure
	from incorrect width setting
Message-ID: <20071008180604.GB7627@kroah.com>
References: <20071008180406.052382073@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="scsi_transport_spi-fix-domain-validation-failure-from-incorrect-width-setting.patch"
In-Reply-To: <20071008180551.GA7627@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: James Bottomley <James.Bottomley@SteelEye.com>

commit 2302827c95fe0f441025acd5133e532d2eef322b from upstream

Domain Validation in the SPI transport class is failing on boxes with
damaged cables (and failing to the extent that the box hangs).  The
problem is that the first test it does is a cable integrity test for
wide transfers and if this fails, it turns the wide bit off.  The
problem is that the next set of tests it does turns wide back on
again, with the result that it runs through the entirety of DV with a
known bad setting and then hangs the system.

The attached patch fixes the problem by physically nailing the wide
setting to what it deduces it should be for the whole of Domain
Validation.

Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/scsi/scsi_transport_spi.c |   28 ++++++++++++++++++++++------
 1 file changed, 22 insertions(+), 6 deletions(-)

--- a/drivers/scsi/scsi_transport_spi.c
+++ b/drivers/scsi/scsi_transport_spi.c
@@ -787,10 +787,12 @@ spi_dv_device_internal(struct scsi_devic
 	struct scsi_target *starget = sdev->sdev_target;
 	struct Scsi_Host *shost = sdev->host;
 	int len = sdev->inquiry_len;
+	int min_period = spi_min_period(starget);
+	int max_width = spi_max_width(starget);
 	/* first set us up for narrow async */
 	DV_SET(offset, 0);
 	DV_SET(width, 0);
-	
+
 	if (spi_dv_device_compare_inquiry(sdev, buffer, buffer, DV_LOOPS)
 	    != SPI_COMPARE_SUCCESS) {
 		starget_printk(KERN_ERR, starget, "Domain Validation Initial Inquiry Failed\n");
@@ -798,9 +800,13 @@ spi_dv_device_internal(struct scsi_devic
 		return;
 	}
 
+	if (!scsi_device_wide(sdev)) {
+		spi_max_width(starget) = 0;
+		max_width = 0;
+	}
+
 	/* test width */
-	if (i->f->set_width && spi_max_width(starget) &&
-	    scsi_device_wide(sdev)) {
+	if (i->f->set_width && max_width) {
 		i->f->set_width(starget, 1);
 
 		if (spi_dv_device_compare_inquiry(sdev, buffer,
@@ -809,6 +815,11 @@ spi_dv_device_internal(struct scsi_devic
 		    != SPI_COMPARE_SUCCESS) {
 			starget_printk(KERN_ERR, starget, "Wide Transfers Fail\n");
 			i->f->set_width(starget, 0);
+			/* Make sure we don't force wide back on by asking
+			 * for a transfer period that requires it */
+			max_width = 0;
+			if (min_period < 10)
+				min_period = 10;
 		}
 	}
 
@@ -828,7 +839,8 @@ spi_dv_device_internal(struct scsi_devic
 
 	/* now set up to the maximum */
 	DV_SET(offset, spi_max_offset(starget));
-	DV_SET(period, spi_min_period(starget));
+	DV_SET(period, min_period);
+
 	/* try QAS requests; this should be harmless to set if the
 	 * target supports it */
 	if (scsi_device_qas(sdev)) {
@@ -837,14 +849,14 @@ spi_dv_device_internal(struct scsi_devic
 		DV_SET(qas, 0);
 	}
 
-	if (scsi_device_ius(sdev) && spi_min_period(starget) < 9) {
+	if (scsi_device_ius(sdev) && min_period < 9) {
 		/* This u320 (or u640). Set IU transfers */
 		DV_SET(iu, 1);
 		/* Then set the optional parameters */
 		DV_SET(rd_strm, 1);
 		DV_SET(wr_flow, 1);
 		DV_SET(rti, 1);
-		if (spi_min_period(starget) == 8)
+		if (min_period == 8)
 			DV_SET(pcomp_en, 1);
 	} else {
 		DV_SET(iu, 0);
@@ -862,6 +874,10 @@ spi_dv_device_internal(struct scsi_devic
 	} else {
 		DV_SET(dt, 1);
 	}
+	/* set width last because it will pull all the other
+	 * parameters down to required values */
+	DV_SET(width, max_width);
+
 	/* Do the read only INQUIRY tests */
 	spi_dv_retrain(sdev, buffer, buffer + sdev->inquiry_len,
 		       spi_dv_device_compare_inquiry);

-- 
