Return-Path: <linux-kernel-owner+w=401wt.eu-S1759098AbYFQOJo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759098AbYFQOJo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 10:09:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757892AbYFQOJe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 10:09:34 -0400
Received: from ti-out-0910.google.com ([209.85.142.186]:42233 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757794AbYFQOJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 10:09:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type;
        b=CV+pANf9Vlw5xBaJBPq668cHBkL8gIMOP9tM/B2XYgiykTGcLrxQDaE5KP4pf6txjV
         QeEHmI4j1qtMOOzISSm7N9wEwoTkomZIGG1APiOywHEWYeGC+fL+Kfx9E/HYVaP021X2
         YbMjOE0vXjW6pqEsf+L5Ux6pbKixb2BI0LN9A=
Message-ID: <4857C590.6050002@gmail.com>
Date: Tue, 17 Jun 2008 23:09:20 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Komuro <komurojun-mbn@nifty.com>
CC: Jeff Garzik <jeff@garzik.org>,
       Dominik Brodowski <linux@dominikbrodowski.net>, jgarzik@redhat.com,
       linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-pcmcia <linux-pcmcia@lists.infradead.org>,
       Kristoffer Ericson <kristoffer.ericson@gmail.com>
Subject: Re: [KERNEL 2.6.26-rc4]  bugreport : pata_pcmcia with Sandisk Extreme
 III 8GB
References: <20080528225049.9a134e0d.Kristoffer.Ericson@Gmail.com>	<20080528222740.GB20893@isilmar.linta.de>	<20080530135728.be02d3dc.Kristoffer.Ericson@Gmail.com>	<20080607223716.7d142072.komurojun-mbn@nifty.com>	<20080611072029.GB28692@comet.dominikbrodowski.net>	<20080614120055.ad8fbee0.komurojun-mbn@nifty.com>	<48537149.4040102@garzik.org>	<20080614213612.96873c25.komurojun-mbn@nifty.com>	<4855D8E2.10409@gmail.com>	<20080616221145.e3b069b9.komurojun-mbn@nifty.com>	<485669A0.6000404@gmail.com> <20080617212345.c452d8c5.komurojun-mbn@nifty.com>
In-Reply-To: <20080617212345.c452d8c5.komurojun-mbn@nifty.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/mixed;
 boundary="------------000609080104070708000500"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000609080104070708000500
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Okay.  The exit is from CS_CHECK macro on GetNextTuple, missed that
macro. It means it failed to request IO resource somewhere.  Can you
please try the attached patch?  It will show us where it failed.

This part of code hasn't changed at all in pata_pcmcia && I don't really
understand the tuple business.  We need pcmcia people to pitch in.

Thanks.

-- 
tejun

--------------000609080104070708000500
Content-Type: text/x-patch;
 name="pata_pcmcia-debug-2.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="pata_pcmcia-debug-2.patch"

diff --git a/drivers/ata/pata_pcmcia.c b/drivers/ata/pata_pcmcia.c
index 3d39f9d..fafe525 100644
--- a/drivers/ata/pata_pcmcia.c
+++ b/drivers/ata/pata_pcmcia.c
@@ -176,9 +176,13 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 
 	struct ata_port_operations *ops = &pcmcia_port_ops;
 
+	dev_printk(KERN_INFO, &pdev->dev, "XXX ENTER\n");
+
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
-	if (info == NULL)
+	if (info == NULL) {
+		printk("XXX info alloc failed\n");
 		return -ENOMEM;
+	}
 
 	/* Glue stuff together. FIXME: We may be able to get rid of info with care */
 	info->pdev = pdev;
@@ -196,8 +200,10 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 	/* Allocate resoure probing structures */
 
 	stk = kzalloc(sizeof(*stk), GFP_KERNEL);
-	if (!stk)
+	if (!stk) {
+		printk("XXX stk alloc failed\n");
 		goto out1;
+	}
 
 	cfg = &stk->parse.cftable_entry;
 
@@ -224,18 +230,27 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 
 	/* Now munch the resources looking for a suitable set */
 	while (1) {
-		if (pcmcia_get_tuple_data(pdev, &tuple) != 0)
+		dev_printk(KERN_INFO, &pdev->dev, "XXX resource loop, pass=%d\n", pass);
+		if (pcmcia_get_tuple_data(pdev, &tuple) != 0) {
+			dev_printk(KERN_INFO, &pdev->dev, "XXX get_tuple_data failed\n");
 			goto next_entry;
-		if (pcmcia_parse_tuple(pdev, &tuple, &stk->parse) != 0)
+		}
+		if (pcmcia_parse_tuple(pdev, &tuple, &stk->parse) != 0) {
+			dev_printk(KERN_INFO, &pdev->dev, "XXX parse_tuple failed\n");
 			goto next_entry;
+		}
 		/* Check for matching Vcc, unless we're desperate */
 		if (!pass) {
 			if (cfg->vcc.present & (1 << CISTPL_POWER_VNOM)) {
-				if (stk->conf.Vcc != cfg->vcc.param[CISTPL_POWER_VNOM] / 10000)
+				if (stk->conf.Vcc != cfg->vcc.param[CISTPL_POWER_VNOM] / 10000) {
+					dev_printk(KERN_INFO, &pdev->dev, "XXX vcc0 fail\n");
 					goto next_entry;
+				}
 			} else if (stk->dflt.vcc.present & (1 << CISTPL_POWER_VNOM)) {
-				if (stk->conf.Vcc != stk->dflt.vcc.param[CISTPL_POWER_VNOM] / 10000)
+				if (stk->conf.Vcc != stk->dflt.vcc.param[CISTPL_POWER_VNOM] / 10000) {
+					dev_printk(KERN_INFO, &pdev->dev, "XXX vcc1 fail\n");
 					goto next_entry;
+				}
 			}
 		}
 
@@ -255,19 +270,27 @@ static int pcmcia_init_one(struct pcmcia_device *pdev)
 				pdev->io.NumPorts1 = 8;
 				pdev->io.BasePort2 = io->win[1].base;
 				pdev->io.NumPorts2 = (is_kme) ? 2 : 1;
-				if (pcmcia_request_io(pdev, &pdev->io) != 0)
+				if (pcmcia_request_io(pdev, &pdev->io) != 0) {
+					dev_printk(KERN_INFO, &pdev->dev, "XXX IO request failed 1 %x:%d %x:%d\n",
+						   pdev->io.BasePort1, pdev->io.NumPorts1, pdev->io.BasePort2, pdev->io.NumPorts2);
 					goto next_entry;
+				}
 				io_base = pdev->io.BasePort1;
 				ctl_base = pdev->io.BasePort2;
 			} else if ((io->nwin == 1) && (io->win[0].len >= 16)) {
 				pdev->io.NumPorts1 = io->win[0].len;
 				pdev->io.NumPorts2 = 0;
-				if (pcmcia_request_io(pdev, &pdev->io) != 0)
+				if (pcmcia_request_io(pdev, &pdev->io) != 0) {
+					dev_printk(KERN_INFO, &pdev->dev, "XXX IO request failed 2 %x:%d %x:%d\n",
+						   pdev->io.BasePort1, pdev->io.NumPorts1, pdev->io.BasePort2, pdev->io.NumPorts2);
 					goto next_entry;
+				}
 				io_base = pdev->io.BasePort1;
 				ctl_base = pdev->io.BasePort1 + 0x0e;
-			} else
+			} else {
+				dev_printk(KERN_INFO, &pdev->dev, "XXX hmmmm\n");
 				goto next_entry;
+			}
 			/* If we've got this far, we're done */
 			break;
 		}
@@ -275,8 +298,10 @@ next_entry:
 		if (cfg->flags & CISTPL_CFTABLE_DEFAULT)
 			memcpy(&stk->dflt, cfg, sizeof(stk->dflt));
 		if (pass) {
+			dev_printk(KERN_INFO, &pdev->dev, "XXX pass=%d, doing GetNextTuple\n", pass);
 			CS_CHECK(GetNextTuple, pcmcia_get_next_tuple(pdev, &tuple));
 		} else if (pcmcia_get_next_tuple(pdev, &tuple) != 0) {
+			dev_printk(KERN_INFO, &pdev->dev, "XXX pass=%d, doing GetFirstTuple\n", pass);
 			CS_CHECK(GetFirstTuple, pcmcia_get_first_tuple(pdev, &tuple));
 			memset(&stk->dflt, 0, sizeof(stk->dflt));
 			pass++;
@@ -290,8 +315,11 @@ next_entry:
 	ret = -ENOMEM;
 	io_addr = devm_ioport_map(&pdev->dev, io_base, 8);
 	ctl_addr = devm_ioport_map(&pdev->dev, ctl_base, 1);
-	if (!io_addr || !ctl_addr)
+	if (!io_addr || !ctl_addr) {
+		printk("XXX ioport_map failed io_addr=%p ctl_addr=%p\n",
+		       io_addr, ctl_addr);
 		goto failed;
+	}
 
 	/* Success. Disable the IRQ nIEN line, do quirks */
 	iowrite8(0x02, ctl_addr);
@@ -311,8 +339,10 @@ next_entry:
 	 */
 	ret = -ENOMEM;
 	host = ata_host_alloc(&pdev->dev, n_ports);
-	if (!host)
+	if (!host) {
+		printk("XXX host alloc failed\n");
 		goto failed;
+	}
 
 	for (p = 0; p < n_ports; p++) {
 		ap = host->ports[p];
@@ -331,11 +361,14 @@ next_entry:
 	/* activate */
 	ret = ata_host_activate(host, pdev->irq.AssignedIRQ, ata_sff_interrupt,
 				IRQF_SHARED, &pcmcia_sht);
-	if (ret)
+	if (ret) {
+		printk("XXX host activate failed ret=%d\n", ret);
 		goto failed;
+	}
 
 	info->ndev = 1;
 	kfree(stk);
+	dev_printk(KERN_INFO, &pdev->dev, "XXX LEAVE 0\n");
 	return 0;
 
 cs_failed:
@@ -345,6 +378,7 @@ failed:
 	info->ndev = 0;
 	pcmcia_disable_device(pdev);
 out1:
+	dev_printk(KERN_INFO, &pdev->dev, "XXX LEAVE %d\n", ret);
 	kfree(info);
 	return ret;
 }

--------------000609080104070708000500--
