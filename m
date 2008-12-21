Return-Path: <linux-kernel-owner+w=401wt.eu-S1752544AbYLUHcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbYLUHcs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 02:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751213AbYLUHcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 02:32:39 -0500
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:47038 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750984AbYLUHcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 02:32:39 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=gWwv0Q2W1TLRwQiNcxr0a6uYCjQsR1eGaguvCjNOTQ/8KwdIUUK82RAtjmyMGtqeHO1+pn5CG1Twxkey/KpVEN2zp/E72irjORTukEeqcCTx2cfKiumTf8yOEbpWPLEGY3RvR08zDcb36cMObwsHsIaYQihHEQaCO8YOeSbG0TI=  ;
X-YMail-OSG: 09PKwboVM1l5xt_5gCAqmxwvtgQxLs9rBt_tWBQeMG79I2pz4vQ7ZOo_i8g1_OMYZQpdJrwzrjV3iC8z8f2IHLI9d7Sx0jnpTwLzvQKp3sNf_Qzpnufh86e9uX.NKMFxaCs.7KadiDH1AIHwyFyKYed0KPnU0MRaA4S.Hz.mqhhe0p79dQM.TQby09xYDx1_dw--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Andrew Morton <akpm@linux-foundation.org>,
       spi-devel-general@lists.sourceforge.net
Subject: [patch 2.6.28-rc9] spi: spi_write_then_read() regression fix
Date: Sat, 20 Dec 2008 23:32:35 -0800
User-Agent: KMail/1.9.10
Cc: lkml <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Vernon Sauder <vernoninhand@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812202332.36281.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Brownell <dbrownell@users.sourceforge.net>

The recent "simplify spi_write_then_read()" patch included a small
regression from the 2.6.27 behavior with its performance win.

All SPI transfers are full duplex, and are packaged as half duplex
by either discarding the data that's read ("write only"), or else
by writing zeroes ("read only").  That patch wasn't ensuring that
zeroes were getting written out during the "half duplex read" part
of the transaction; instead, old RX bits were getting sent.

The fix is trivial:  zero the buffer before using it.

Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
Cc: Vernon Sauder <vernoninhand@gmail.com>

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -677,11 +677,13 @@ int spi_write_then_read(struct spi_device *spi,
 
 	/* ... unless someone else is using the pre-allocated buffer */
 	if (!mutex_trylock(&lock)) {
-		local_buf = kmalloc(SPI_BUFSIZ, GFP_KERNEL);
+		local_buf = kzalloc(SPI_BUFSIZ, GFP_KERNEL);
 		if (!local_buf)
 			return -ENOMEM;
-	} else
+	} else {
 		local_buf = buf;
+		memset(local_buf, 0, x.len);
+	}
 
 	memcpy(local_buf, txbuf, n_tx);
 	x.tx_buf = local_buf;
