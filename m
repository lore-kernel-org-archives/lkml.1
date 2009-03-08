Return-Path: <linux-kernel-owner+w=401wt.eu-S1754197AbZCHUOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754197AbZCHUOT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 16:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753479AbZCHUOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 16:14:06 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:40518 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753315AbZCHUOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 16:14:03 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=J3CHVOscICNVWUCVB/NYmWBNDaWaoca5S6osU5NV0judKAGJgh58E0VEHNfQA5qyc/
         ve6aEMgWsi+NKOiO8MdsKLvVHM+IaNPXu6yTryTT0ypl5tE8VkclU3TJZRsr1EJlp7A3
         XvVgiEXkgYKO2CGhfLI92WuUB4sT5sEkuDxAM=
Subject: [PATCH] sata_nv: add a module parameter to enable async scanning
From: Andreas Robinson <andr345@gmail.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090308090102.2db82a5b@infradead.org>
References: <1234722028-8110-1-git-send-email-andr345@gmail.com>
	 <ac3eb2510902170353ia62a630nbe5cf059ca7d616e@mail.gmail.com>
	 <200902181528.29697.rusty@rustcorp.com.au>
	 <ac3eb2510902180115o4690a335n129e4df695540de0@mail.gmail.com>
	 <1234952753.10531.48.camel@andreas-laptop>
	 <cc43514a0902191637h5a9680c5id95f7d6c32cca472@mail.gmail.com>
	 <ac3eb2510902191755i391d4defnc5a514f4525ec6cf@mail.gmail.com>
	 <1235216636.7025.1023.camel@andreas-laptop>
	 <1236004353.10055.49.camel@andreas-laptop>
	 <20090302082003.1bb7bdc5@infradead.org>
	 <ac3eb2510903020829s7c876a96y7eb5568eeb9921fd@mail.gmail.com>
	 <20090302102703.50aaf724@infradead.org>
	 <1236192430.6785.111.camel@andreas-laptop>
	 <20090305161837.6ba80cc1@infradead.org>
	 <1236352543.6594.59.camel@andreas-laptop>
	 <20090306074548.36ed2f9f@infradead.org>
	 <1236509237.5645.151.camel@andreas-laptop>
	 <20090308090102.2db82a5b@infradead.org>
Content-Type: text/plain
Date: Sun, 08 Mar 2009 21:13:57 +0100
Message-Id: <1236543237.5783.16.camel@andreas-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 09:01 -0700, Arjan van de Ven wrote:
> One thing to mention is that fastinit for sata... I only did AHCI
> (because all my machines have that). Your machine looks like it has
> something different than AHCI, so maybe the sata controller can use
> some work ;-)
> (a sata driver needs to opt into parallel scanning via a flag)
> 
> SATA init tends to be one of the things that are fix time per drive;
> and so working on that first to at least ONLY get that is worth it,
> it's a huge chunk of time (more than half the total time in your
> bootchart)

Something like the patch below, mabye? :-)

Before: [    3.056308] Freeing unused kernel memory: 364k freed
After:  [    2.411417] Freeing unused kernel memory: 364k freed

The chipset is nforce2 (drivers/ata/sata_nv.c). I couldn't find
anything like the SSS flag documented in the code, and register
specs from nvidia are as rare as hen's teeth... So I only added
the module parameter to force parallel scans.

I named it parallel_scan instead of ignore_sss though, since
there might not be an SSS-flag to ignore.

/Andreas

>From a5b090856173782308c8f61de84085be9a9b73ba Mon Sep 17 00:00:00 2001
From: Andreas Robinson <andr345@gmail.com>
Date: Sun, 8 Mar 2009 20:44:16 +0100
Subject: [PATCH] sata_nv: add a module parameter to enable async scanning

This parameter (parallel_scan) forces the OS to scan for
disks asynchronously/in parallel, to reduce boot time.

It might cause problems (brown-outs, blown fuses) in
multi-drive systems, if the PSU is unable to handle several
drives spinning up simultaneously.

It ought to be safe in single-drive systems.

Signed-off-by: Andreas Robinson <andr345@gmail.com>
---
 drivers/ata/sata_nv.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/ata/sata_nv.c b/drivers/ata/sata_nv.c
index 55a8eed..e8aba2f 100644
--- a/drivers/ata/sata_nv.c
+++ b/drivers/ata/sata_nv.c
@@ -579,6 +579,7 @@ MODULE_VERSION(DRV_VERSION);
 
 static int adma_enabled;
 static int swncq_enabled = 1;
+static int parallel_scan = 0;
 
 static void nv_adma_register_mode(struct ata_port *ap)
 {
@@ -2427,6 +2428,9 @@ static int nv_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	} else if (type == SWNCQ)
 		nv_swncq_host_init(host);
 
+	if (parallel_scan)
+		host->flags |= ATA_HOST_PARALLEL_SCAN;
+
 	pci_set_master(pdev);
 	return ata_host_activate(host, pdev->irq, ipriv->irq_handler,
 				 IRQF_SHARED, ipriv->sht);
@@ -2526,4 +2530,6 @@ module_param_named(adma, adma_enabled, bool, 0444);
 MODULE_PARM_DESC(adma, "Enable use of ADMA (Default: true)");
 module_param_named(swncq, swncq_enabled, bool, 0444);
 MODULE_PARM_DESC(swncq, "Enable use of SWNCQ (Default: true)");
+module_param_named(parallel_scan, parallel_scan, bool, 0444);
+MODULE_PARM_DESC(parallel_scan, "Force parallel host scan (Default: false)");
 
-- 
1.5.6.3


