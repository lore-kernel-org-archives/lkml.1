Return-Path: <linux-kernel-owner+w=401wt.eu-S1753902AbZBIJ2h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753902AbZBIJ2h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 04:28:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752017AbZBIJ23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 04:28:29 -0500
Received: from smtp.wellnetcz.com ([212.24.148.102]:36150 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751985AbZBIJ23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 04:28:29 -0500
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] parport: parport_serial, don't bind netmos ibm 0299
Date: Mon,  9 Feb 2009 10:28:14 +0100
Message-Id: <1234171694-27160-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew, one more netmos 9835 patch, I though parport_serial binds only
SERIAL_OTHER pci subclass devices which was apparently wrong assumption.
Please apply.

--

Since netmos 9835 with subids 0x1014(IBM):0x0299 is now bound with
serial/8250_pci, because it has no parallel ports and subdevice
id isn't in the expected form, return -ENODEV from probe function.

This is performed in netmos preinit_hook.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 drivers/parport/parport_serial.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/parport/parport_serial.c b/drivers/parport/parport_serial.c
index 101ed49..032db81 100644
--- a/drivers/parport/parport_serial.c
+++ b/drivers/parport/parport_serial.c
@@ -64,6 +64,11 @@ struct parport_pc_pci {
 
 static int __devinit netmos_parallel_init(struct pci_dev *dev, struct parport_pc_pci *card, int autoirq, int autodma)
 {
+	/* the rule described below doesn't hold for this device */
+	if (dev->device == PCI_DEVICE_ID_NETMOS_9835 &&
+			dev->subsystem_vendor == PCI_VENDOR_ID_IBM &&
+			dev->subsystem_device == 0x0299)
+		return -ENODEV;
 	/*
 	 * Netmos uses the subdevice ID to indicate the number of parallel
 	 * and serial ports.  The form is 0x00PS, where <P> is the number of
-- 
1.6.1.2

