Return-Path: <linux-kernel-owner+w=401wt.eu-S1757945AbXKGILZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757945AbXKGILZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 03:11:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757787AbXKGILQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 03:11:16 -0500
Received: from pip10.gyao.ne.jp ([61.122.117.248]:30408 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757757AbXKGILP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 03:11:15 -0500
Date: Wed, 7 Nov 2007 17:10:52 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org, linuxsh-dev@lists.sourceforge.net
Subject: [PATCH 1/2] libata: Support PIO polling-only hosts.
Message-ID: <20071107081052.GA25913@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Jeff Garzik <jeff@garzik.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxsh-dev@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

By default ata_host_activate() expects a valid IRQ in order to
successfully register the host. This patch enables a special case
for registering polling-only hosts that either don't have IRQs
or have buggy IRQ generation (either in terms of handling or
sensing), which otherwise work fine.

Hosts that want to use polling mode can simply set ATA_FLAG_PIO_POLLING
and pass in a NULL IRQ handler or invalid (< 0) IRQ.

Signed-off-by: Paul Mundt <lethal@linux-sh.org>

---

 drivers/ata/libata-core.c |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index ec3ce12..a0cd6bb 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -7178,6 +7178,9 @@ int ata_host_register(struct ata_host *host, struct scsi_host_template *sht)
  *	request IRQ and register it.  This helper takes necessasry
  *	arguments and performs the three steps in one go.
  *
+ *	A NULL @irq_handler or invalid IRQ skips the IRQ registration
+ *	and expects the host to have set polling mode on the port.
+ *
  *	LOCKING:
  *	Inherited from calling layer (may sleep).
  *
@@ -7194,6 +7197,10 @@ int ata_host_activate(struct ata_host *host, int irq,
 	if (rc)
 		return rc;
 
+	/* Special case for polling mode */
+	if (!irq_handler || irq < 0)
+		return ata_host_register(host, sht);
+
 	rc = devm_request_irq(host->dev, irq, irq_handler, irq_flags,
 			      dev_driver_string(host->dev), host);
 	if (rc)

