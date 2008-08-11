Return-Path: <linux-kernel-owner+w=401wt.eu-S1755573AbYHKWgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755573AbYHKWgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 18:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYHKWge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 18:36:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:35793 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbYHKWgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 18:36:33 -0400
Date: Mon, 11 Aug 2008 15:36:41 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, linux-ide@vger.kernel.org
Subject: [patch 1/2] fastboot: Add a module parameter to skip probing of
 specific ports
Message-ID: <20080811153641.706726ec@infradead.org>
In-Reply-To: <20080811153542.61095e5c@infradead.org>
References: <20080811153542.61095e5c@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Kristen Accardi <kristen.c.accardi@intel.com>
Subject: [PATCH] libata: Add a module parameter to skip probing of specific ports

Port probing by libata can easily take 10% or more of the kernel boot
time (2%+ of total). For cases where one knows there is nothing
connected to certain ports (for example on netbooks) this is a waste
of boot time.

This patch adds a module parameter that allows the admin to specify
to skip ports (specified by a bitmask) and recoup this boot time.
This capability is potentially also useful to get systems to boot
for cases where port-probing on a certain ports causes crashes.

A follow-on patch will add the capability to use DMI identification
to automate this for certain known systems.

Signed-off-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/ata/libata-core.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 5ba96c5..831a8ca 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -148,6 +148,10 @@ static int ata_probe_timeout;
 module_param(ata_probe_timeout, int, 0444);
 MODULE_PARM_DESC(ata_probe_timeout, "Set ATA probing timeout (seconds)");
 
+static int libata_disable_ports;
+module_param_named(disable_ports, libata_disable_ports, int, 0444);
+MODULE_PARM_DESC(disable_ports, "Disable specified ports (as bitmask) at boot time");
+
 int libata_noacpi = 0;
 module_param_named(noacpi, libata_noacpi, int, 0444);
 MODULE_PARM_DESC(noacpi, "Disables the use of ACPI in probe/suspend/resume when set");
@@ -5651,6 +5655,13 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 	for (i = 0; i < host->n_ports; i++) {
 		struct ata_port *ap = host->ports[i];
 
+		/*
+		 * check if the port is specified as 'to disable' by either
+		 * a module parameter or a DMI match
+		 */
+		if (libata_disable_ports & (1 << ap->port_no))
+			continue;
+
 		/* probe */
 		if (ap->ops->error_handler) {
 			struct ata_eh_info *ehi = &ap->link.eh_info;
-- 
1.5.5.1

