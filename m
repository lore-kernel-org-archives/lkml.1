Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbYBGA2N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbYBGA2N (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 19:28:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932677AbYBGAAA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 19:00:00 -0500
Received: from ns1.suse.de ([195.135.220.2]:46608 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932668AbYBFX77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 18:59:59 -0500
Date: Wed, 6 Feb 2008 15:54:20 -0800
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
       Tomasz Chmielewski <mangoo@wpkg.org>, Mark Lord <liml@rtr.ca>,
       Tejun Heo <htejun@gmail.com>, Jeff Garzik <jeff@garzik.org>
Subject: [patch 65/73] libata: port and host should be stopped before
	hardware resources are released
Message-ID: <20080206235420.GN13121@suse.de>
References: <20080206234302.769849277@mini.kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename="libata-port-and-host-should-be-stopped-before-hardware-resources-are-released.patch"
In-Reply-To: <20080206235015.GA13121@suse.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.23-stable review patch.  If anyone has any objections, please let us know.
------------------
From: Tejun Heo <htejun@gmail.com>

This is backport of 32ebbc0c0d5d18c0135b55d1eb0029f48c54aff0 and fixes
oops on driver module unload.

Port / host stop calls used to be made from ata_host_release() which
is called after all hardware resources acquired after host allocation
are released.  This is wrong as port and host stop routines often
access the hardware.

Add separate devres for port / host stop which is invoked right after
IRQ is released but with all other hardware resources intact.  The
devres is added iff ->host_stop and/or ->port_stop exist.

This problem has been spotted by Mark Lord.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Mark Lord <liml@rtr.ca>
Signed-off-by: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/ata/libata-core.c |   52 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 13 deletions(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -6121,19 +6121,6 @@ static void ata_host_release(struct devi
 		if (!ap)
 			continue;
 
-		if ((host->flags & ATA_HOST_STARTED) && ap->ops->port_stop)
-			ap->ops->port_stop(ap);
-	}
-
-	if ((host->flags & ATA_HOST_STARTED) && host->ops->host_stop)
-		host->ops->host_stop(host);
-
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		if (!ap)
-			continue;
-
 		if (ap->scsi_host)
 			scsi_host_put(ap->scsi_host);
 
@@ -6258,6 +6245,24 @@ struct ata_host *ata_host_alloc_pinfo(st
 	return host;
 }
 
+static void ata_host_stop(struct device *gendev, void *res)
+{
+	struct ata_host *host = dev_get_drvdata(gendev);
+	int i;
+
+	WARN_ON(!(host->flags & ATA_HOST_STARTED));
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
+		if (ap->ops->port_stop)
+			ap->ops->port_stop(ap);
+	}
+
+	if (host->ops->host_stop)
+		host->ops->host_stop(host);
+}
+
 /**
  *	ata_host_start - start and freeze ports of an ATA host
  *	@host: ATA host to start ports for
@@ -6276,6 +6281,8 @@ struct ata_host *ata_host_alloc_pinfo(st
  */
 int ata_host_start(struct ata_host *host)
 {
+	int have_stop = 0;
+	void *start_dr = NULL;
 	int i, rc;
 
 	if (host->flags & ATA_HOST_STARTED)
@@ -6287,6 +6294,22 @@ int ata_host_start(struct ata_host *host
 		if (!host->ops && !ata_port_is_dummy(ap))
 			host->ops = ap->ops;
 
+		if (ap->ops->port_stop)
+			have_stop = 1;
+	}
+
+	if (host->ops->host_stop)
+		have_stop = 1;
+
+	if (have_stop) {
+		start_dr = devres_alloc(ata_host_stop, 0, GFP_KERNEL);
+		if (!start_dr)
+			return -ENOMEM;
+	}
+
+	for (i = 0; i < host->n_ports; i++) {
+		struct ata_port *ap = host->ports[i];
+
 		if (ap->ops->port_start) {
 			rc = ap->ops->port_start(ap);
 			if (rc) {
@@ -6299,6 +6322,8 @@ int ata_host_start(struct ata_host *host
 		ata_eh_freeze_port(ap);
 	}
 
+	if (start_dr)
+		devres_add(host->dev, start_dr);
 	host->flags |= ATA_HOST_STARTED;
 	return 0;
 
@@ -6309,6 +6334,7 @@ int ata_host_start(struct ata_host *host
 		if (ap->ops->port_stop)
 			ap->ops->port_stop(ap);
 	}
+	devres_free(start_dr);
 	return rc;
 }
 

-- 
