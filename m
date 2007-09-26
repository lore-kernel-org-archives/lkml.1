Return-Path: <linux-kernel-owner+w=401wt.eu-S1761010AbXIZSZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010AbXIZSZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 14:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754319AbXIZSZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 14:25:40 -0400
Received: from earth.ketl.com ([64.94.143.172]:1442 "HELO ketl.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752585AbXIZSZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 14:25:40 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Sep 2007 14:25:40 EDT
Message-ID: <20070926174818.7769.qmail@ketl.com>
From: "Chris David" <cd@chrisdavid.com>
To: linux-kernel@vger.kernel.org
Subject: Proposed 2.6 Patch for AMD MIPS Alchemy au1550 I2C interface I2C
  interface
Date: Wed, 26 Sep 2007 10:48:18 -0700
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_0_7530_1190828898"; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
mail software cannot handle MIME-formatted messages.

--=_0_7530_1190828898
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hello, 

Please CC me on replies. 

I have made a trivial patch to fix a problem on the AMD MIPS Alchemy au1550
I2C interface.  The PSC (programmable serial controller) seem to 'hang' when 
I sent only an 'address' byte on the I2C bus.  The patch essentially uses  
the PSC_SMBSTAT register's TE (transmit FIFO empty) bit to check when the 
transmit FIFO is empty, instead of using the PSC_SMBEVNT register's TU  
(transmit underflow) bit.  Using the TE bit fixed the hang problem. 

I tested this on kernel 2.6.16, and confirmed the patch updates the 2.6.22
kernel correctly.  If someone else can test this, that would be great. 

Dan Malek is the author of the file in question.  I would be more than happy 
to provide any additional information about this patch to Dan or anyone 
else.  Please email me privately. 

I am a newbie, but I did read part of the FAQ, and used my best judgement.  
Kindly let me know if my communication could be improved.  And please CC me 
on replies. 

Thank you, 

 -Chris David 



--=_0_7530_1190828898
Content-Disposition: inline;
  filename="119_au1550_PSC_SMB_I2C_useTransmitEmpty.patch"
Content-Type: text/plain; charset="utf-8";
  name="119_au1550_PSC_SMB_I2C_useTransmitEmpty.patch"
Content-Transfer-Encoding: 7bit

diff -Naur linux-2.6.16-orig/drivers/i2c/busses/i2c-au1550.c linux-2.6.16/drivers/i2c/busses/i2c-au1550.c
--- linux-2.6.16-orig/drivers/i2c/busses/i2c-au1550.c	2007-09-26 08:38:45.000000000 -0700
+++ linux-2.6.16/drivers/i2c/busses/i2c-au1550.c	2007-09-26 08:43:43.000000000 -0700
@@ -61,17 +61,14 @@
 
 	sp = (volatile psc_smb_t *)(adap->psc_base);
 
-	/* Wait for Tx FIFO Underflow.
+	/* Wait for Tx Buffer Empty
 	*/
 	for (i = 0; i < adap->xfer_timeout; i++) {
-		stat = sp->psc_smbevnt;
+		stat = sp->psc_smbstat;
 		au_sync();
-		if ((stat & PSC_SMBEVNT_TU) != 0) {
-			/* Clear it.  */
-			sp->psc_smbevnt = PSC_SMBEVNT_TU;
-			au_sync();
+		if ((stat & PSC_SMBSTAT_TE) != 0)
 			return 0;
-		}
+
 		udelay(1);
 	}
 

--=_0_7530_1190828898--
