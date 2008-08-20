Return-Path: <linux-kernel-owner+w=401wt.eu-S1752771AbYHTHoX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771AbYHTHoX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2008 03:44:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754666AbYHTHnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Aug 2008 03:43:52 -0400
Received: from hera.kernel.org ([140.211.167.34]:58318 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559AbYHTHnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2008 03:43:50 -0400
Message-ID: <48ABCAFE.3030508@kernel.org>
Date: Wed, 20 Aug 2008 16:42:54 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Manny Maxwell <mannymax@mannymax.net>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot Problems with 2.6.27-rc[23] on nVidia 680i
References: <6b2d1a5d2475e6be79d9ad459579f040.squirrel@www.mannymax.net>
In-Reply-To: <6b2d1a5d2475e6be79d9ad459579f040.squirrel@www.mannymax.net>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------060306060304010006000004"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Wed, 20 Aug 2008 07:43:30 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060306060304010006000004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Does the attached patch fix your problem?

-- 
tejun

--------------060306060304010006000004
Content-Type: text/x-patch;
 name="nv-nohrst.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="nv-nohrst.patch"

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -309,8 +309,6 @@ static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline);
 static int nv_adma_slave_config(struct scsi_device *sdev);
 static int nv_adma_check_atapi_dma(struct ata_queued_cmd *qc);
 static void nv_adma_qc_prep(struct ata_queued_cmd *qc);
@@ -407,7 +405,7 @@ static struct scsi_host_template nv_swncq_sht = {
 
 static struct ata_port_operations nv_generic_ops = {
 	.inherits		= &ata_bmdma_port_ops,
-	.hardreset		= nv_hardreset,
+	.hardreset		= ATA_OP_NULL,
 	.scr_read		= nv_scr_read,
 	.scr_write		= nv_scr_write,
 };
@@ -1588,21 +1586,6 @@ static void nv_mcp55_thaw(struct ata_port *ap)
 	ata_sff_thaw(ap);
 }
 
-static int nv_hardreset(struct ata_link *link, unsigned int *class,
-			unsigned long deadline)
-{
-	int rc;
-
-	/* SATA hardreset fails to retrieve proper device signature on
-	 * some controllers.  Request follow up SRST.  For more info,
-	 * see http://bugzilla.kernel.org/show_bug.cgi?id=3352
-	 */
-	rc = sata_sff_hardreset(link, class, deadline);
-	if (rc)
-		return rc;
-	return -EAGAIN;
-}
-
 static void nv_adma_error_handler(struct ata_port *ap)
 {
 	struct nv_adma_port_priv *pp = ap->private_data;

--------------060306060304010006000004--
