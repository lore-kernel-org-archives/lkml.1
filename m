Return-Path: <linux-kernel-owner+w=401wt.eu-S1753869AbYJaHEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869AbYJaHEX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 03:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYJaHEN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 03:04:13 -0400
Received: from aun.it.uu.se ([130.238.12.36]:35741 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYJaHEM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 03:04:12 -0400
Date: Fri, 31 Oct 2008 08:03:55 +0100 (MET)
Message-Id: <200810310703.m9V73tAk019180@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: jgarzik@pobox.com
Subject: [PATCH 2.6.28-rc2] sata_promise: add ATA engine reset to reset ops
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Promise ATA engines need to be reset when errors occur.
That's currently done for errors detected by sata_promise itself,
but it's not done for errors like timeouts detected outside of
the low-level driver.

The effect of this omission is that a timeout tends to result
in a sequence of failed COMRESETs after which libata EH gives
up and disables the port. At that point the port's ATA engine
hangs and even reloading the driver will not resume it.

To fix this, make sata_promise override ->hardreset on SATA
ports with code which calls pdc_reset_port() on the port in
question before calling libata's hardreset. PATA ports don't
use ->hardreset, so for those we override ->softreset instead.

Signed-off-by: Mikael Pettersson <mikpe@it.uu.se>
---
Updated to add pdc_reset_port() to ->softreset not ->hardreset
on PATA ports. Patch title adjusted accordingly.

This should also go into the 2.6.27 and 2.6.26 stable branches.
In older branches libata EH is different and I'm seeing different
behaviour on timeouts, so I don't think this should go in as-is
in 2.6.25 and older.

 drivers/ata/sata_promise.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff -rupN linux-2.6.28-rc2/drivers/ata/sata_promise.c linux-2.6.28-rc2.sata_promise-proper-hardreset-v2/drivers/ata/sata_promise.c
--- linux-2.6.28-rc2/drivers/ata/sata_promise.c	2008-10-26 21:35:33.000000000 +0100
+++ linux-2.6.28-rc2.sata_promise-proper-hardreset-v2/drivers/ata/sata_promise.c	2008-10-31 00:27:40.000000000 +0100
@@ -153,6 +153,10 @@ static void pdc_freeze(struct ata_port *
 static void pdc_sata_freeze(struct ata_port *ap);
 static void pdc_thaw(struct ata_port *ap);
 static void pdc_sata_thaw(struct ata_port *ap);
+static int pdc_pata_softreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline);
+static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline);
 static void pdc_error_handler(struct ata_port *ap);
 static void pdc_post_internal_cmd(struct ata_queued_cmd *qc);
 static int pdc_pata_cable_detect(struct ata_port *ap);
@@ -186,6 +190,7 @@ static struct ata_port_operations pdc_sa
 	.scr_read		= pdc_sata_scr_read,
 	.scr_write		= pdc_sata_scr_write,
 	.port_start		= pdc_sata_port_start,
+	.hardreset		= pdc_sata_hardreset,
 };
 
 /* First-generation chips need a more restrictive ->check_atapi_dma op */
@@ -200,6 +205,7 @@ static struct ata_port_operations pdc_pa
 	.freeze			= pdc_freeze,
 	.thaw			= pdc_thaw,
 	.port_start		= pdc_common_port_start,
+	.softreset		= pdc_pata_softreset,
 };
 
 static const struct ata_port_info pdc_port_info[] = {
@@ -693,6 +699,20 @@ static void pdc_sata_thaw(struct ata_por
 	readl(host_mmio + hotplug_offset); /* flush */
 }
 
+static int pdc_pata_softreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return ata_sff_softreset(link, class, deadline);
+}
+
+static int pdc_sata_hardreset(struct ata_link *link, unsigned int *class,
+			      unsigned long deadline)
+{
+	pdc_reset_port(link->ap);
+	return sata_sff_hardreset(link, class, deadline);
+}
+
 static void pdc_error_handler(struct ata_port *ap)
 {
 	if (!(ap->pflags & ATA_PFLAG_FROZEN))
