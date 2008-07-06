Return-Path: <linux-kernel-owner+w=401wt.eu-S1759434AbYGFRgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759434AbYGFRgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2008 13:36:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756245AbYGFRer
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jul 2008 13:34:47 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:13310 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204AbYGFReo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2008 13:34:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:date:from:to:cc:subject:content-disposition:message-id;
        b=nVsH0YXBvZ2WX9tAfnaGjLlTSLWY1tRcIAt+dSEBE60DY0C2bN9b4Fw/XT/teiXuBA
         QcZ55dXD1SnqZg/SdmsXHF3+R4twNkSYEjDiwxcjfRlHyvK2coiGSa7uAU0Ze2FNga8l
         Y4FPyFocqjULvc5RNMlJb3dDAgqXmmUW7fiog=
References: <20080706172010.559358957@bzolnier@gmail.com>
Date: Sun, 06 Jul 2008 19:20:15 +0200
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/50] ide: call ide_pci_setup_ports() before do_ide_setup_pci_device()
Content-Disposition: inline; filename=ide-call-ide_pci_setup_ports-before-do_ide_setup_pci_device.patch
Message-ID: <48710232.1ade660a.3458.6271@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Call ide_pci_setup_ports() before do_ide_setup_pci_device()
  in ide_setup_pci_device[s]().

While at it:

* Remove stale FIXMEs.

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/setup-pci.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

Index: b/drivers/ide/setup-pci.c
===================================================================
--- a/drivers/ide/setup-pci.c
+++ b/drivers/ide/setup-pci.c
@@ -533,14 +533,16 @@ int ide_setup_pci_device(struct pci_dev 
 	if (ret < 0)
 		goto out;
 
+	ide_pci_setup_ports(dev, d, 0, &hw[0], &hws[0]);
+
 	ret = do_ide_setup_pci_device(dev, d, 1);
+	if (ret < 0)
+		goto out;
 
-	if (ret >= 0) {
-		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(dev, d, ret, &hw[0], &hws[0]);
+	/* fixup IRQ */
+	hw[1].irq = hw[0].irq = ret;
 
-		ret = ide_host_add(d, hws, NULL);
-	}
+	ret = ide_host_add(d, hws, NULL);
 out:
 	return ret;
 }
@@ -558,6 +560,8 @@ int ide_setup_pci_devices(struct pci_dev
 		if (ret < 0)
 			goto out;
 
+		ide_pci_setup_ports(pdev[i], d, 0, &hw[i*2], &hws[i*2]);
+
 		ret = do_ide_setup_pci_device(pdev[i], d, !i);
 
 		/*
@@ -567,8 +571,8 @@ int ide_setup_pci_devices(struct pci_dev
 		if (ret < 0)
 			goto out;
 
-		/* FIXME: silent failure can happen */
-		ide_pci_setup_ports(pdev[i], d, ret, &hw[i*2], &hws[i*2]);
+		/* fixup IRQ */
+		hw[i*2 + 1].irq = hw[i*2].irq = ret;
 	}
 
 	ret = ide_host_add(d, hws, NULL);

-- 

