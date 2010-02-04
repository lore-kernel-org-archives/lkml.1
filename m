Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896Ab0BDT5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 14:57:09 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:42545 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932788Ab0BDT5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 14:57:06 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Dmitri Vorobiev <dmitri.vorobiev@movial.fi>,
       Henrik Kretzschmar <henne@nachtwindheim.de>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Kay Sievers <kay.sievers@vrfy.org>, peter fuerst <post@pfrst.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Subject: [PATCH 2/9] platform-drivers: move probe to .devinit.text in drivers/scsi
Date: Thu,  4 Feb 2010 20:56:50 +0100
Message-Id: <1265313417-5568-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100203150850.GA28815@kroah.com>
References: <20100203150850.GA28815@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A pointer to a probe callback is passed to the core via
platform_driver_register and so the function must not disappear when the
.init sections are discarded.  Otherwise (if also having HOTPLUG=y)
unbinding and binding a device to the driver via sysfs will result in an
oops as does a device being registered late.

An alternative to this patch is using platform_driver_probe instead of
platform_driver_register plus removing the pointer to the probe function
from the struct platform_driver.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brownell <dbrownell@users.sourceforge.net>
Cc: Dmitri Vorobiev <dmitri.vorobiev@movial.fi>
Cc: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>
Cc: peter fuerst <post@pfrst.de>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
---
 drivers/scsi/sgiwd93.c    |    2 +-
 drivers/scsi/sni_53c710.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sgiwd93.c b/drivers/scsi/sgiwd93.c
index 0807b26..fef0e3c 100644
--- a/drivers/scsi/sgiwd93.c
+++ b/drivers/scsi/sgiwd93.c
@@ -226,7 +226,7 @@ static struct scsi_host_template sgiwd93_template = {
 	.use_clustering		= DISABLE_CLUSTERING,
 };
 
-static int __init sgiwd93_probe(struct platform_device *pdev)
+static int __devinit sgiwd93_probe(struct platform_device *pdev)
 {
 	struct sgiwd93_platform_data *pd = pdev->dev.platform_data;
 	unsigned char *wdregs = pd->wdregs;
diff --git a/drivers/scsi/sni_53c710.c b/drivers/scsi/sni_53c710.c
index 37b3359..56cf0bb 100644
--- a/drivers/scsi/sni_53c710.c
+++ b/drivers/scsi/sni_53c710.c
@@ -64,7 +64,7 @@ static struct scsi_host_template snirm710_template = {
 	.module		= THIS_MODULE,
 };
 
-static int __init snirm710_probe(struct platform_device *dev)
+static int __devinit snirm710_probe(struct platform_device *dev)
 {
 	unsigned long base;
 	struct NCR_700_Host_Parameters *hostdata;
-- 
1.6.6

