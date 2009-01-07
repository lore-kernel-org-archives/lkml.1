Return-Path: <linux-kernel-owner+w=401wt.eu-S1755408AbZAGXPp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408AbZAGXPp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 18:15:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932200AbZAGXN2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 18:13:28 -0500
Received: from casper.infradead.org ([85.118.1.10]:46735 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760191AbZAGXN2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 18:13:28 -0500
Date: Wed, 7 Jan 2009 15:13:51 -0800
From: Arjan van de Ven <arjan@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org
Subject: [PATCH 4/7] fastboot: Make libata initialization even more async
Message-ID: <20090107151351.086f7af2@infradead.org>
In-Reply-To: <20090107151151.458333c1@infradead.org>
References: <20090107151151.458333c1@infradead.org>
Organization: Intel
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f29d3b23238e1955a8094e038c72546e99308e61 Mon Sep 17 00:00:00 2001
From: Arjan van de Ven <arjan@linux.intel.com>
Date: Mon, 5 Jan 2009 15:07:07 -0800
Subject: [PATCH] fastboot: Make libata initialization even more async

As suggested by Linus: Don't do the libata init in 2 separate
steps with a global sync inbetween, but do it as one async step,
with a local sync before registering the device.

This cuts the boottime on my machine with 2 sata controllers down
significantly, and it seems to work. Would be nice if the libata
folks take a good look at this patch though..

Signed-off-by: Arjan van de Ven <arjan@linux.intel.com>
---
 drivers/ata/libata-core.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 7d3ae6a..f178a45 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -5951,6 +5951,12 @@ static void async_port_probe(void *data, async_cookie_t cookie)
 			 */
 		}
 	}
+
+	/* in order to keep device order, we need to synchronize at this point */
+	async_synchronize_cookie(cookie);
+
+	ata_scsi_scan_host(ap, 1);
+
 }
 /**
  *	ata_host_register - register initialized ATA host
@@ -6033,15 +6039,7 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
 		struct ata_port *ap = host->ports[i];
 		async_schedule(async_port_probe, ap);
 	}
-	async_synchronize_full();
-	/* probes are done, now scan each port's disk(s) */
-	DPRINTK("host probe begin\n");
-	for (i = 0; i < host->n_ports; i++) {
-		struct ata_port *ap = host->ports[i];
-
-		ata_scsi_scan_host(ap, 1);
-	}
-	DPRINTK("host probe end\n");
+	DPRINTK("probe end\n");
 
 	return 0;
 }
-- 
1.6.0.6




-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
