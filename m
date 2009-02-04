Return-Path: <linux-kernel-owner+w=401wt.eu-S1760346AbZBDS5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760346AbZBDS5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 13:57:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761125AbZBDStW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 13:49:22 -0500
Received: from kroah.org ([198.145.64.141]:60942 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758990AbZBDStP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 13:49:15 -0500
Date: Wed, 4 Feb 2009 10:46:18 -0800
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
       alan@lxorguk.ukuu.org.uk, Tejun Heo <tj@kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 15/41] sata_nv: rename nv_nf2_hardreset()
Message-ID: <20090204184618.GP25246@kroah.com>
References: <20090204184029.881610776@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="sata_nv-rename-nv_nf2_hardreset.patch"
In-Reply-To: <20090204184539.GA25246@kroah.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit e8caa3c70e94d867ca2efe9e53fd388b52d6d0c8 upstream.

nv_nf2_hardreset() will be used by other flavors too.  Rename it to
nv_noclassify_hardreset().

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/sata_nv.c |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -305,10 +305,10 @@ static irqreturn_t nv_ck804_interrupt(in
 static int nv_scr_read(struct ata_port *ap, unsigned int sc_reg, u32 *val);
 static int nv_scr_write(struct ata_port *ap, unsigned int sc_reg, u32 val);
 
+static int nv_noclassify_hardreset(struct ata_link *link, unsigned int *class,
+				   unsigned long deadline);
 static void nv_nf2_freeze(struct ata_port *ap);
 static void nv_nf2_thaw(struct ata_port *ap);
-static int nv_nf2_hardreset(struct ata_link *link, unsigned int *class,
-			    unsigned long deadline);
 static void nv_ck804_freeze(struct ata_port *ap);
 static void nv_ck804_thaw(struct ata_port *ap);
 static int nv_adma_slave_config(struct scsi_device *sdev);
@@ -432,7 +432,7 @@ static struct ata_port_operations nv_nf2
 	.inherits		= &nv_common_ops,
 	.freeze			= nv_nf2_freeze,
 	.thaw			= nv_nf2_thaw,
-	.hardreset		= nv_nf2_hardreset,
+	.hardreset		= nv_noclassify_hardreset,
 };
 
 /* CK804 finally gets hardreset right */
@@ -1530,6 +1530,17 @@ static int nv_scr_write(struct ata_port 
 	return 0;
 }
 
+static int nv_noclassify_hardreset(struct ata_link *link, unsigned int *class,
+				   unsigned long deadline)
+{
+	bool online;
+	int rc;
+
+	rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
+				 &online, NULL);
+	return online ? -EAGAIN : rc;
+}
+
 static void nv_nf2_freeze(struct ata_port *ap)
 {
 	void __iomem *scr_addr = ap->host->ports[0]->ioaddr.scr_addr;
@@ -1554,17 +1565,6 @@ static void nv_nf2_thaw(struct ata_port 
 	iowrite8(mask, scr_addr + NV_INT_ENABLE);
 }
 
-static int nv_nf2_hardreset(struct ata_link *link, unsigned int *class,
-			    unsigned long deadline)
-{
-	bool online;
-	int rc;
-
-	rc = sata_link_hardreset(link, sata_deb_timing_hotplug, deadline,
-				 &online, NULL);
-	return online ? -EAGAIN : rc;
-}
-
 static void nv_ck804_freeze(struct ata_port *ap)
 {
 	void __iomem *mmio_base = ap->host->iomap[NV_MMIO_BAR];

