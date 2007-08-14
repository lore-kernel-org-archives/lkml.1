Return-Path: <linux-kernel-owner+w=401wt.eu-S934966AbXHNEpS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934966AbXHNEpS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 00:45:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762355AbXHNEow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 00:44:52 -0400
Received: from n6a.bullet.mail.re3.yahoo.com ([68.142.236.44]:39641 "HELO
	n6a.bullet.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751308AbXHNEov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 00:44:51 -0400
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 14605.18043.bm@rrr4.mail.re1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=LlKIiTkkfuunlZOJTZq23R2hdiM+4SuIf0VkMSgKp1VLAeABpIOcuU11m8g6pmxIEGLIbGcGYR/g1gN9sp4lFz/PrrWI+EkDOZDTUG6jrQtM+0clyUnV/tkCzoZ/4WwrqDqET7+uADA1CVDEmkIMIPACe8kAA2z8pzqrvEcmSTc=;
X-YMail-OSG: LEABnYEVM1md8hzJ2rwaz2zC8VqT7zzCpS.6Uvzwvme92LtfgWGF2btEcoQ2U_SbemH.A4dGA9DPjFLHjXlxGDha
Date: Mon, 13 Aug 2007 21:44:49 -0700 (PDT)
From: Scott Thompson <postfailathushmaildotcom@yahoo.com>
Reply-To: postfail@hushmail.com
Subject: [PATCH 2/3] /drivers/net myri_sbus.c ioremap balancing/returncode check (resend)
To: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       kernel-janitors@vger.kernel.org, postfail@hushmail.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <303513.3821.qm@web44906.mail.sp1.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

resending patchset against 2.6.23-rc3 for /drivers/net ioremap balancing / return check,
previous patchset contained wordwrap errors:

  corrects:
  --sbus_ioremap return unchecked.
  --ioremap function unchecked
  --function failure cases did not clean up ioremap'd values.
  lne390.c  -- believe had incorrect/not ideal variable check on if for iounmap

this audit was only for files directly in drivers/net directory, not the full tree.

Signed-off-by: Scott Thompson <postfail <at> hushmail.com>
----------------------------------------------------------
diff --git a/drivers/net/myri_sbus.c b/drivers/net/myri_sbus.c
index 13444da..138aabd 100644
--- a/drivers/net/myri_sbus.c
+++ b/drivers/net/myri_sbus.c
@@ -1007,6 +1007,13 @@ static int __devinit myri_ether_init(struct sbus_dev *sdev)
 		mp->lanai =
 			sbus_ioremap(&sdev->resource[0], (512 * 1024),
 				     mp->eeprom.ramsz, "MyriCOM SRAM");
+
+
+		if (!mp->cregs || !mp->lregs || !mp->lanai ) {
+			printk("MyriCOM: Cannot map registers for ioremap fail.\n");
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
 



       
____________________________________________________________________________________
Be a better Heartthrob. Get better relationship answers from someone who knows. Yahoo! Answers - Check it out. 
http://answers.yahoo.com/dir/?link=list&sid=396545433

