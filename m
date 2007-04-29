Return-Path: <linux-kernel-owner+w=401wt.eu-S1031317AbXD2Tpe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031317AbXD2Tpe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 15:45:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031332AbXD2Tpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 15:45:34 -0400
Received: from www.osadl.org ([213.239.205.134]:57695 "EHLO mail.tglx.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1031320AbXD2TpA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 15:45:00 -0400
From: =?utf-8?q?Hans-J=C3=BCrgen_Koch?= <hjk@linutronix.de>
Organization: Linutronix
To: Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/3] UIO: Hilscher CIF card driver (with patch)
Date: Sun, 29 Apr 2007 21:44:32 +0200
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org, torvalds@osdl.org
References: <20070427224957.GA17967@kroah.com> <11777142633770-git-send-email-gregkh@suse.de> <11777142681853-git-send-email-gregkh@suse.de>
In-Reply-To: <11777142681853-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200704292144.32958.hjk@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag 28 April 2007 00:50 schrieb Greg Kroah-Hartman:

> +static int __devinit hilscher_pci_probe(struct pci_dev *dev,
> +					const struct pci_device_id *id)
> +{
> +	struct uio_info *info;
> +
> +	info = kzalloc(sizeof(struct uio_info), GFP_KERNEL);
> +	if (!info)
> +		return -ENOMEM;
> +
> +	if (pci_enable_device(dev))
> +		goto out_free;
> +
> +	if (pci_request_regions(dev, "hilscher"))
> +		goto out_disable;
> +
> +	info->mem[0].addr = pci_resource_start(dev, 0);
> +	if (!info->mem[0].addr)
> +		goto out_release;
> +	info->mem[0].internal_addr = ioremap_nocache(pci_resource_start(dev, 0),
> +						     pci_resource_len(dev, 0));
> +	if (!info->mem[0].internal_addr)
> +		goto out_release;

Alan Cox pointed out (offlist) that ioremap_nocache() is unneccessary here.
This patch replaces it with ioremap():

Thanks, Alan!

hjk

Index: linux-2.6.22-rc/drivers/uio/uio_cif.c
===================================================================
--- linux-2.6.22-rc.orig/drivers/uio/uio_cif.c	2007-04-29 21:34:45.000000000 +0200
+++ linux-2.6.22-rc/drivers/uio/uio_cif.c	2007-04-29 21:36:31.000000000 +0200
@@ -64,9 +64,8 @@
 	info->mem[0].addr = pci_resource_start(dev, 0);
 	if (!info->mem[0].addr)
 		goto out_release;
-	info->mem[0].internal_addr = ioremap_nocache(
-						pci_resource_start(dev, 0),
-						pci_resource_len(dev, 0) );
+	info->mem[0].internal_addr = ioremap(pci_resource_start(dev, 0),
+					     pci_resource_len(dev, 0) );
 	if (!info->mem[0].internal_addr)
 		goto out_release;
 
