Return-Path: <linux-kernel-owner+w=401wt.eu-S1755939AbZLCNie@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755939AbZLCNie (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 08:38:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754686AbZLCNid
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 08:38:33 -0500
Received: from poutre.nerim.net ([62.4.16.124]:57954 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754612AbZLCNid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 08:38:33 -0500
Date: Thu, 3 Dec 2009 14:38:36 +0100
From: Jean Delvare <khali@linux-fr.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Pat Gefre <pfg@sgi.com>
Subject: [PATCH 1/2] IOC3/IOC4: Various section fixes
Message-ID: <20091203143836.518384c6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several IOC3 and IOC4 drivers misuse the __devinit and __devexit
section markers. Use __init and __exit instead as appropriate, then
add __devinit and __devexit where they really belong for PCI drivers.

Also make ioc4_serial_init static.

Signed-off-by: Jean Delvare <khali@linux-fr.org>
Cc: Pat Gefre <pfg@sgi.com>
---
Note: I was not able to build-test these patches, please do.

Andrew, I've been trying to send this fix and the next one to the
relevant maintainer for the past 6 months but it did not get anywhere.
Could you please pick them? Thanks.

 drivers/misc/ioc4.c          |   16 ++++++++--------
 drivers/serial/ioc3_serial.c |    4 ++--
 drivers/serial/ioc4_serial.c |    4 ++--
 drivers/sn/ioc3.c            |   15 ++++++++-------
 4 files changed, 20 insertions(+), 19 deletions(-)

--- linux-2.6.30-rc8.orig/drivers/misc/ioc4.c	2009-06-04 11:41:00.000000000 +0200
+++ linux-2.6.30-rc8/drivers/misc/ioc4.c	2009-06-04 11:41:02.000000000 +0200
@@ -138,7 +138,7 @@ ioc4_unregister_submodule(struct ioc4_su
  * even though the following code utilizes external interrupt registers
  * to perform the speed calculation.
  */
-static void
+static void __devinit
 ioc4_clock_calibrate(struct ioc4_driver_data *idd)
 {
 	union ioc4_int_out int_out;
@@ -230,7 +230,7 @@ ioc4_clock_calibrate(struct ioc4_driver_
  * on the same PCI bus at slot number 3 to differentiate IO9 from IO10.
  * If neither is present, it's a PCI-RT.
  */
-static unsigned int
+static unsigned int __devinit
 ioc4_variant(struct ioc4_driver_data *idd)
 {
 	struct pci_dev *pdev = NULL;
@@ -269,7 +269,7 @@ ioc4_variant(struct ioc4_driver_data *id
 	return IOC4_VARIANT_PCI_RT;
 }
 
-static void
+static void __devinit
 ioc4_load_modules(struct work_struct *work)
 {
 	/* arg just has to be freed */
@@ -280,7 +280,7 @@ ioc4_load_modules(struct work_struct *wo
 }
 
 /* Adds a new instance of an IOC4 card */
-static int
+static int __devinit
 ioc4_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 {
 	struct ioc4_driver_data *idd;
@@ -425,7 +425,7 @@ out:
 }
 
 /* Removes a particular instance of an IOC4 card. */
-static void
+static void __devexit
 ioc4_remove(struct pci_dev *pdev)
 {
 	struct ioc4_submodule *is;
@@ -476,7 +476,7 @@ static struct pci_driver ioc4_driver = {
 	.name = "IOC4",
 	.id_table = ioc4_id_table,
 	.probe = ioc4_probe,
-	.remove = ioc4_remove,
+	.remove = __devexit_p(ioc4_remove),
 };
 
 MODULE_DEVICE_TABLE(pci, ioc4_id_table);
@@ -486,14 +486,14 @@ MODULE_DEVICE_TABLE(pci, ioc4_id_table);
  *********************/
 
 /* Module load */
-static int __devinit
+static int __init
 ioc4_init(void)
 {
 	return pci_register_driver(&ioc4_driver);
 }
 
 /* Module unload */
-static void __devexit
+static void __exit
 ioc4_exit(void)
 {
 	/* Ensure ioc4_load_modules() has completed before exiting */
--- linux-2.6.30-rc8.orig/drivers/serial/ioc3_serial.c	2009-06-04 11:41:00.000000000 +0200
+++ linux-2.6.30-rc8/drivers/serial/ioc3_serial.c	2009-06-04 11:41:02.000000000 +0200
@@ -2162,7 +2162,7 @@ static struct ioc3_submodule ioc3uart_op
 /**
  * ioc3_detect - module init called,
  */
-static int __devinit ioc3uart_init(void)
+static int __init ioc3uart_init(void)
 {
 	int ret;
 
@@ -2179,7 +2179,7 @@ static int __devinit ioc3uart_init(void)
 	return ret;
 }
 
-static void __devexit ioc3uart_exit(void)
+static void __exit ioc3uart_exit(void)
 {
 	ioc3_unregister_submodule(&ioc3uart_ops);
 	uart_unregister_driver(&ioc3_uart);
--- linux-2.6.30-rc8.orig/drivers/serial/ioc4_serial.c	2009-06-04 11:41:00.000000000 +0200
+++ linux-2.6.30-rc8/drivers/serial/ioc4_serial.c	2009-06-04 11:41:02.000000000 +0200
@@ -2904,7 +2904,7 @@ static struct ioc4_submodule ioc4_serial
 /**
  * ioc4_serial_init - module init
  */
-int ioc4_serial_init(void)
+static int __init ioc4_serial_init(void)
 {
 	int ret;
 
@@ -2926,7 +2926,7 @@ int ioc4_serial_init(void)
 	return ioc4_register_submodule(&ioc4_serial_submodule);
 }
 
-static void __devexit ioc4_serial_exit(void)
+static void __exit ioc4_serial_exit(void)
 {
 	ioc4_unregister_submodule(&ioc4_serial_submodule);
 	uart_unregister_driver(&ioc4_uart_rs232);
--- linux-2.6.30-rc8.orig/drivers/sn/ioc3.c	2009-06-04 11:41:00.000000000 +0200
+++ linux-2.6.30-rc8/drivers/sn/ioc3.c	2009-06-04 11:41:03.000000000 +0200
@@ -574,11 +574,11 @@ void ioc3_unregister_submodule(struct io
  * Device management *
  *********************/
 
-static char *
+static char * __devinitdata
 ioc3_class_names[]={"unknown", "IP27 BaseIO", "IP30 system", "MENET 1/2/3",
 			"MENET 4", "CADduo", "Altix Serial"};
 
-static int ioc3_class(struct ioc3_driver_data *idd)
+static int __devinit ioc3_class(struct ioc3_driver_data *idd)
 {
 	int res = IOC3_CLASS_NONE;
 	/* NIC-based logic */
@@ -601,7 +601,8 @@ static int ioc3_class(struct ioc3_driver
 	return res;
 }
 /* Adds a new instance of an IOC3 card */
-static int ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
+static int __devinit
+ioc3_probe(struct pci_dev *pdev, const struct pci_device_id *pci_id)
 {
 	struct ioc3_driver_data *idd;
 	uint32_t pcmd;
@@ -753,7 +754,7 @@ out:
 }
 
 /* Removes a particular instance of an IOC3 card. */
-static void ioc3_remove(struct pci_dev *pdev)
+static void __devexit ioc3_remove(struct pci_dev *pdev)
 {
 	int id;
 	struct ioc3_driver_data *idd;
@@ -805,7 +806,7 @@ static struct pci_driver ioc3_driver = {
 	.name = "IOC3",
 	.id_table = ioc3_id_table,
 	.probe = ioc3_probe,
-	.remove = ioc3_remove,
+	.remove = __devexit_p(ioc3_remove),
 };
 
 MODULE_DEVICE_TABLE(pci, ioc3_id_table);
@@ -815,7 +816,7 @@ MODULE_DEVICE_TABLE(pci, ioc3_id_table);
  *********************/
 
 /* Module load */
-static int __devinit ioc3_init(void)
+static int __init ioc3_init(void)
 {
 	if (ia64_platform_is("sn2"))
 		return pci_register_driver(&ioc3_driver);
@@ -823,7 +824,7 @@ static int __devinit ioc3_init(void)
 }
 
 /* Module unload */
-static void __devexit ioc3_exit(void)
+static void __exit ioc3_exit(void)
 {
 	pci_unregister_driver(&ioc3_driver);
 }


-- 
Jean Delvare
