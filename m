Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbYAPQw6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbYAPQw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 11:52:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751140AbYAPQwv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 11:52:51 -0500
Received: from smtp25.orange.fr ([193.252.22.23]:11168 "EHLO smtp25.orange.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750968AbYAPQwu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 11:52:50 -0500
X-ME-UUID: 20080116160613195.2FBEA70000AA@mwinf2503.orange.fr
Message-ID: <478E2B31.20308@til-technologies.fr>
Date: Wed, 16 Jan 2008 17:05:05 +0100
From: frederic RODO <f.rodo@til-technologies.fr>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: [PATCH] rtc-ds1307 : ds_1340 change init
X-Enigmail-Version: 0.95.6
OpenPGP: id=A61987DC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-MDHeloLookup-Result: pass smtp.helo=[172.16.90.43] (ip=172.16.90.43) (smtp.til-technologies.fr)
X-MDMailLookup-Result: pass smtp.mail=f.rodo@til-technologies.fr (ip=172.16.90.43) (smtp.til-technologies.fr)
X-Spam-Processed: smtp.til-technologies.fr, Wed, 16 Jan 2008 17:05:11 +0100
	(not processed: message from valid local sender)
X-Return-Path: prvs=19016a249a=f.rodo@til-technologies.fr
X-Envelope-From: f.rodo@til-technologies.fr
X-MDaemon-Deliver-To: linux-kernel@vger.kernel.org
X-Info: Locally scanned for viruses
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this patch change the initialization of ds1340 according to the FIXME.

It was tested on a arm custom board, this is the log when I plug the 
board without backup battery.

Linux version 2.6.24-rc7 (fredo@srv-devhard) (gcc version 3.4.6) #22 Tue 
Jan 15 19:45:16 CET 2008
.......
Kernel command line: debug
.......
atmel_spi atmel_spi.1: Atmel SPI Controller at 0xfffcc000 (irq 13)
i2c /dev entries driver
rtc-ds1307 0-0068: SET TIME!
rtc-ds1307 0-0068: rtc core: registered ds1340 as rtc0
i2c-gpio i2c-gpio: using pins 55 (SDA) and 56 (SCL)
.......

If you have any comments please CC me

bye.



Signed-off-by: Frederic RODO <f.rodo@til-technologies.fr>

diff --git a/drivers/rtc/rtc-ds1307.c b/drivers/rtc/rtc-ds1307.c
index bc1c7fe..3a86898 100644
--- a/drivers/rtc/rtc-ds1307.c
+++ b/drivers/rtc/rtc-ds1307.c
@@ -392,6 +392,33 @@ static int __devinit ds1307_probe(struct i2c_client 
*client)
  			dev_warn(&client->dev, "SET TIME!\n");
  		}
  		break;
+	case ds_1340:
+		/* Test nEOSC before OSF */
+		tmp = i2c_smbus_read_byte_data(client, DS1307_REG_SECS);
+		if (tmp < 0) {
+			pr_debug("read error %d\n", tmp);
+			err = -EIO;
+			goto exit_free;
+		}
+
+		/* oscillator off?  turn it on, so clock can tick. */
+		if (tmp & DS1340_BIT_nEOSC)
+			i2c_smbus_write_byte_data(client, DS1307_REG_SECS,
+				tmp & ~DS1340_BIT_nEOSC);
+
+		tmp = i2c_smbus_read_byte_data(client, DS1340_REG_FLAG);
+		if (tmp < 0) {
+			pr_debug("read error %d\n", tmp);
+			err = -EIO;
+			goto exit_free;
+		}
+
+		/* oscillator fault?  clear flag, and warn */
+		if (tmp & DS1340_BIT_OSF) {
+			i2c_smbus_write_byte_data(client, DS1340_REG_FLAG, 0);
+			dev_warn(&client->dev, "SET TIME!\n");
+		}
+		break;
  	default:
  		break;
  	}
@@ -412,11 +439,6 @@ read_rtc:
  	 */
  	tmp = ds1307->regs[DS1307_REG_SECS];
  	switch (ds1307->type) {
-	case ds_1340:
-		/* FIXME read register with DS1340_BIT_OSF, use that to
-		 * trigger the "set time" warning (*after* restarting the
-		 * oscillator!) instead of this weaker ds1307/m41t00 test.
-		 */
  	case ds_1307:
  	case m41t00:
  		/* clock halted?  turn it on, so clock can tick. */
@@ -442,6 +464,7 @@ read_rtc:
  		break;
  	case ds_1337:
  	case ds_1339:
+	case ds_1340:
  		break;
  	}



-------------------------------------------------------------------------
Les informations précédentes peuvent être confidentielles ou privilégiées.
Si vous n'êtes pas le destinataire prévu de ce mail, veuillez en notifier 
l'expéditeur en répondant à ce message puis supprimez-en toute trace 
de vos systèmes.

TIL Technologies
Parc du Golf, Bat 43
350 rue J.R Guilibert Gautier de la Lauzière 
13856 AIX EN PROVENCE
Tel. : +33 4 42 37 11 77
-------------------------------------------------------------------------


