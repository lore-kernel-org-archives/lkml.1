Return-Path: <linux-kernel-owner+w=401wt.eu-S1757962AbYFJUuh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962AbYFJUuh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 16:50:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757606AbYFJUt5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 16:49:57 -0400
Received: from gv-out-0910.google.com ([216.239.58.191]:27835 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998AbYFJUty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 16:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:subject;
        b=S81GT6+3+ffi2QpgGNzHv5KmRtOWZuf8t+QhbReHqu3IGLFXfdIq6iK4ojigWQG/nt
         GAVTHPLGkiYkR+R7SnosSnlBxDzzRXi8KtTFaRovK8Bboi1i8iMikU4FWaCkeoFH7ZLh
         FoZJA8y02tsfOK7o++Mg0jtjzUgoNyehBHXiI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Tue, 10 Jun 2008 22:50:59 +0200
Message-Id: <20080610205059.18469.44856.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/14] cmd640: fix warm-plug support for the secondary interface
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Register secondary interface also when user requested not to probe devices.

While at it:

- remove write-only second_port_toggled variable

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/cmd640.c |   51 +++++++++++++++++++----------------------------
 1 file changed, 21 insertions(+), 30 deletions(-)

Index: b/drivers/ide/pci/cmd640.c
===================================================================
--- a/drivers/ide/pci/cmd640.c
+++ b/drivers/ide/pci/cmd640.c
@@ -687,9 +687,6 @@ static int cmd640x_init_one(unsigned lon
  */
 static int __init cmd640x_init(void)
 {
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-	int second_port_toggled = 0;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
 	int second_port_cmd640 = 0, rc;
 	const char *bus_type, *port2;
 	unsigned int index;
@@ -778,46 +775,40 @@ static int __init cmd640x_init(void)
 	put_cmd640_reg(CMDTIM, 0);
 	put_cmd640_reg(BRST, 0x40);
 
-	cmd_hwif1 = ide_find_port();
+	b = get_cmd640_reg(CNTRL);
 
 	/*
 	 * Try to enable the secondary interface, if not already enabled
 	 */
-	if (cmd_hwif1 &&
-	    cmd_hwif1->drives[0].noprobe && cmd_hwif1->drives[1].noprobe) {
-		port2 = "not probed";
+	if (secondary_port_responding()) {
+		if ((b & CNTRL_ENA_2ND)) {
+			second_port_cmd640 = 1;
+			port2 = "okay";
+		} else if (cmd640_vlb) {
+			second_port_cmd640 = 1;
+			port2 = "alive";
+		} else
+			port2 = "not cmd640";
 	} else {
-		b = get_cmd640_reg(CNTRL);
+		put_cmd640_reg(CNTRL, b ^ CNTRL_ENA_2ND); /* toggle the bit */
 		if (secondary_port_responding()) {
-			if ((b & CNTRL_ENA_2ND)) {
-				second_port_cmd640 = 1;
-				port2 = "okay";
-			} else if (cmd640_vlb) {
-				second_port_cmd640 = 1;
-				port2 = "alive";
-			} else
-				port2 = "not cmd640";
+			second_port_cmd640 = 1;
+			port2 = "enabled";
 		} else {
-			put_cmd640_reg(CNTRL, b ^ CNTRL_ENA_2ND); /* toggle the bit */
-			if (secondary_port_responding()) {
-				second_port_cmd640 = 1;
-#ifdef CONFIG_BLK_DEV_CMD640_ENHANCED
-				second_port_toggled = 1;
-#endif /* CONFIG_BLK_DEV_CMD640_ENHANCED */
-				port2 = "enabled";
-			} else {
-				put_cmd640_reg(CNTRL, b); /* restore original setting */
-				port2 = "not responding";
-			}
+			put_cmd640_reg(CNTRL, b); /* restore original setting */
+			port2 = "not responding";
 		}
 	}
 
 	/*
 	 * Initialize data for secondary cmd640 port, if enabled
 	 */
-	if (second_port_cmd640 && cmd_hwif1) {
-		ide_init_port_hw(cmd_hwif1, &hw[1]);
-		idx[1] = cmd_hwif1->index;
+	if (second_port_cmd640) {
+		cmd_hwif1 = ide_find_port();
+		if (cmd_hwif1) {
+			ide_init_port_hw(cmd_hwif1, &hw[1]);
+			idx[1] = cmd_hwif1->index;
+		}
 	}
 	printk(KERN_INFO "cmd640: %sserialized, secondary interface %s\n",
 			 second_port_cmd640 ? "" : "not ", port2);
