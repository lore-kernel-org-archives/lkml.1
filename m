Return-Path: <linux-kernel-owner+w=401wt.eu-S1757033AbZCFUCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033AbZCFUCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Mar 2009 15:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbZCFUCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Mar 2009 15:02:30 -0500
Received: from electric-eye.fr.zoreil.com ([213.41.134.224]:55679 "EHLO
	electric-eye.fr.zoreil.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750718AbZCFUC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Mar 2009 15:02:29 -0500
Date: Fri, 6 Mar 2009 21:05:15 +0100
From: Francois Romieu <romieu@fr.zoreil.com>
To: Tim Durack <tdurack@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       Ivan Vecera <ivecera@redhat.com>
Subject: Re: r8169 MAC problem
Message-ID: <20090306200515.GA26365@electric-eye.fr.zoreil.com>
References: <9e246b4d0903061127q7c82103dq88c5184765f3c17a@mail.gmail.com> <9e246b4d0903061129g7b66dc3bm8013b75be671ca33@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e246b4d0903061129g7b66dc3bm8013b75be671ca33@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please Cc: Ivan.

Tim Durack <tdurack@gmail.com> :
[...]
> Any ideas?

Damn me, I should have noticed that the delay was below spec :o(

Can you try the patch below on top of the current git kernel ?

diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
index b347340..dfd42db 100644
--- a/drivers/net/r8169.c
+++ b/drivers/net/r8169.c
@@ -1970,9 +1970,14 @@ static const struct net_device_ops rtl8169_netdev_ops = {
 };
 
 /* Delay between EEPROM clock transitions. Force out buffered PCI writes. */
-#define RTL_EEPROM_DELAY()	RTL_R8(Cfg9346)
 #define RTL_EEPROM_READ_CMD	6
 
+static void rtl_eeprom_delay(void __iomem *ioaddr)
+{
+	RTL_R8(Cfg9346);
+	ndelay(450);
+}
+
 /* read 16bit word stored in EEPROM. EEPROM is addressed by words. */
 static u16 rtl_eeprom_read(void __iomem *ioaddr, int addr)
 {
@@ -1992,7 +1997,7 @@ static u16 rtl_eeprom_read(void __iomem *ioaddr, int addr)
 
 	/* enter programming mode */
 	RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS);
-	RTL_EEPROM_DELAY();
+	rtl_eeprom_delay(ioaddr);
 
 	/* write command and requested address */
 	while (cmd_len--) {
@@ -2002,29 +2007,29 @@ static u16 rtl_eeprom_read(void __iomem *ioaddr, int addr)
 
 		/* write a bit */
 		RTL_W8(Cfg9346, x);
-		RTL_EEPROM_DELAY();
+		rtl_eeprom_delay(ioaddr);
 
 		/* raise clock */
 		RTL_W8(Cfg9346, x | Cfg9346_EESK);
-		RTL_EEPROM_DELAY();
+		rtl_eeprom_delay(ioaddr);
 	}
 
 	/* lower clock */
 	RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS);
-	RTL_EEPROM_DELAY();
+	rtl_eeprom_delay(ioaddr);
 
 	/* read back 16bit value */
 	for (i = 16; i > 0; i--) {
 		/* raise clock */
 		RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS | Cfg9346_EESK);
-		RTL_EEPROM_DELAY();
+		rtl_eeprom_delay(ioaddr);
 
 		result <<= 1;
 		result |= (RTL_R8(Cfg9346) & Cfg9346_EEDO) ? 1 : 0;
 
 		/* lower clock */
 		RTL_W8(Cfg9346, Cfg9346_Program | Cfg9346_EECS);
-		RTL_EEPROM_DELAY();
+		rtl_eeprom_delay(ioaddr);
 	}
 
 	RTL_W8(Cfg9346, Cfg9346_Program);
-- 
Ueimor
