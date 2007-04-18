Return-Path: <linux-kernel-owner+w=401wt.eu-S1422786AbXDRKHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbXDRKHa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 06:07:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422790AbXDRKHa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 06:07:30 -0400
Received: from mx0.karneval.cz ([81.27.192.123]:14750 "EHLO av1.karneval.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422786AbXDRKH1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 06:07:27 -0400
Message-id: <480828832650218324@karneval.cz>
In-reply-to: <2428225437641930190@karneval.cz>
Subject: [PATCH 9/11] Char: cyclades, tty_register_device separately for each device
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Wed, 18 Apr 2007 12:07:25 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

cyclades, tty_register_device separately for each device

Do not register all tty devices at the init time, delay it for the time
until some device is found.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit ad4f792b92f8e6350a62b61442bb6812969bfd73
tree de126dc99bbafbb15d3fc7c96211e9648f4de354
parent 8c76c370ee1c1efa31f64807162c15922fae1e3a
author Jiri Slaby <jirislaby@gmail.com> Thu, 05 Apr 2007 17:44:51 +0200
committer Jiri Slaby <jirislaby@gmail.com> Tue, 10 Apr 2007 10:48:07 +0200

 drivers/char/cyclades.c |   20 +++++++++++++++++++-
 1 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 22f8ec4..0c2c120 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -4841,6 +4841,9 @@ static int __init cy_detect_isa(void)
 			cy_isa_irq);
 		printk("%d channels starting from port %d.\n",
 			cy_isa_nchan, cy_next_channel);
+		for (j = cy_next_channel;
+				j < cy_next_channel + cy_isa_nchan; j++)
+			tty_register_device(cy_serial_driver, j, NULL);
 		cy_next_channel += cy_isa_nchan;
 	}
 	return nboard;
@@ -4948,6 +4951,8 @@ static int __devinit cy_init_Ze(unsigned long cy_pci_phys0,
 
 	printk("%d channels starting from port %d.\n",
 		cy_pci_nchan, cy_next_channel);
+	for (j = cy_next_channel; j < cy_next_channel + cy_pci_nchan; j++)
+		tty_register_device(cy_serial_driver, j, &pdev->dev);
 	cy_next_channel += cy_pci_nchan;
 
 	return 0;
@@ -5115,6 +5120,9 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 			(int)cy_pci_irq);
 		printk("%d channels starting from port %d.\n",
 			cy_pci_nchan, cy_next_channel);
+		for (j = cy_next_channel;
+				j < cy_next_channel + cy_pci_nchan; j++)
+			tty_register_device(cy_serial_driver, j, &pdev->dev);
 
 		cy_next_channel += cy_pci_nchan;
 	} else if (device_id == PCI_DEVICE_ID_CYCLOM_Z_Lo) {
@@ -5282,6 +5290,9 @@ static int __devinit cy_pci_probe(struct pci_dev *pdev,
 
 		printk("%d channels starting from port %d.\n",
 				cy_pci_nchan, cy_next_channel);
+		for (j = cy_next_channel;
+				j < cy_next_channel + cy_pci_nchan; j++)
+			tty_register_device(cy_serial_driver, j, &pdev->dev);
 		cy_next_channel += cy_pci_nchan;
 	}
 
@@ -5346,6 +5357,9 @@ static void __devexit cy_pci_release(struct pci_dev *pdev)
 		cy_port[i].line = -1;
 		cy_port[i].magic = -1;
 	}
+	for (i = cinfo->first_line; i < cinfo->first_line +
+			cinfo->nports; i++)
+		tty_unregister_device(cy_serial_driver, i);
 #endif
 }
 
@@ -5479,7 +5493,7 @@ static int __init cy_init(void)
 	cy_serial_driver->init_termios = tty_std_termios;
 	cy_serial_driver->init_termios.c_cflag =
 	    B9600 | CS8 | CREAD | HUPCL | CLOCAL;
-	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW;
+	cy_serial_driver->flags = TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV;
 	tty_set_operations(cy_serial_driver, &cy_ops);
 
 	retval = tty_register_driver(cy_serial_driver);
@@ -5555,6 +5569,10 @@ static void __exit cy_cleanup_module(void)
 #endif /* CONFIG_CYZ_INTR */
 				)
 				free_irq(cy_card[i].irq, &cy_card[i]);
+			for (e1 = cy_card[i].first_line;
+					e1 < cy_card[i].first_line +
+					cy_card[i].nports; e1++)
+				tty_unregister_device(cy_serial_driver, e1);
 		}
 	}
 } /* cy_cleanup_module */
