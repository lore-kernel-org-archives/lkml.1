Return-Path: <linux-kernel-owner+w=401wt.eu-S940306AbXHJSkh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S940306AbXHJSkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 14:40:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757883AbXHJSk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 14:40:29 -0400
Received: from smtp3.hushmail.com ([65.39.178.135]:62615 "EHLO
	smtp3.hushmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbXHJSk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 14:40:29 -0400
Date: Fri, 10 Aug 2007 14:40:26 -0400
To: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
       <kernel-janitors@vger.kernel.org>
Subject: [PATCH 3/4]  /drivers/net ioremap balancing/returncode check (myri_sbus.c)
Reply-to: postfail@hushmail.com
From: "Scott Thompson" <postfail@hushmail.com>
Content-type: text/plain; charset="UTF-8"
Message-Id: <20070810184026.B3276DA82B@mailserver7.hushmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

patchset against 2.6.23-rc2 for /drivers/net ioremap balancing / 
return check:

  corrects:
  --sbus_ioremap return unchecked.
  --ioremap function unchecked
  --function failure cases did not clean up ioremap'd values.
  lne390.c
   -- believe had incorrect/not ideal variable check on if for 
iounmap

this audit was only for files directly in drivers/net directory, 
not the full tree.

I split patches up by file changed as each file had different 
'owner' to ease accept/reject/revision process.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 13444da..fa624b3 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -1007,6 +1007,13 @@ static int __devinit myri_ether_init(struct 
sbus_dev *sdev)
 		mp->lanai =
 			sbus_ioremap(&sdev->resource[0], (512 * 1024),
 				     mp->eeprom.ramsz, "MyriCOM SRAM");
+
+
+		if (!mp->cregs || !mp->lregs || !mp->lanai ) {
+			printk("MyriCOM: Cannot map MyriCOM registers for cpuvers >= 
CPUVERS_4_0.\n");
+			goto err;
+		}
+		
 	}
 	DET(("Registers mapped: cregs[%p] lregs[%p] lanai[%p]\n",
 	     mp->cregs, mp->lregs, mp->lanai));
@@ -1108,6 +1115,16 @@ err_free_irq:
 err:
 	/* This will also free the co-allocated 'dev->priv' */
 	free_netdev(dev);
+
+	if (mp->regs)
+		sbus_iounmap(mp->regs, mp->reg_size);
+	if (mp->cregs)
+		sbus_iounmap(mp->cregs, PAGE_SIZE);
+	if (mp->lregs)
+		sbus_iounmap(mp->lregs, (256 * 1024));
+	if (mp->lanai)
+		sbus_iounmap(mp->lanai, (512 * 1024));
+
 	return -ENODEV;
 }
 




