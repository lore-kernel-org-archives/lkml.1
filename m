Return-Path: <linux-kernel-owner+w=401wt.eu-S1760673AbYKDXyV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbYKDXyV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 18:54:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757847AbYKDXkg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 18:40:36 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757097AbYKDXke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 18:40:34 -0500
Date: Tue, 4 Nov 2008 15:33:12 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Mikael Pettersson <mikpe@it.uu.se>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 45/57] sata_promise: add ATA engine reset to reset ops
Message-ID: <20081104233312.GT659@suse.de>
References: <20081104232144.186593464@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_promise-add-ata-engine-reset-to-reset-ops.patch"
In-Reply-To: <20081104233028.GA659@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------
From: Mikael Pettersson <mikpe@it.uu.se>

commit cadef677e4a9b9c1d069675043767df486782986 upstream

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
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_promise.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/ata/sata_promise.c
+++ b/drivers/ata/sata_promise.c
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
@@ -691,6 +697,20 @@ static void pdc_sata_thaw(struct ata_por
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

-- 
