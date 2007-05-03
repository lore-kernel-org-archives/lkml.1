Return-Path: <linux-kernel-owner+w=401wt.eu-S1161461AbXECRa1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161461AbXECRa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:30:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767527AbXECRa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:30:27 -0400
Received: from py-out-1112.google.com ([64.233.166.176]:31048 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161461AbXECRa0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:30:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:mail-followup-to:mime-version:content-type:content-disposition:user-agent;
        b=rjwqGhUcYozM0Wa82ctowcT20Eex/GZ65/FD6LBViCduJdkTSxnMuXybBCE/aNboh6doRtMRTisIUXNExfII7PjHyNryD7zU+r+5I872FLH8+Azei2b4nvPVDJ4Z7uAJ+D65/Brmx26vQQ+BjZOsGrae8oCHrcaKEhv5ppx9RW4=
Date: Fri, 4 May 2007 02:24:21 +0900
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Harald Welte <laforge@gnumonks.org>
Subject: [PATCH] cm4000_cs: use bitrev
Message-ID: <20070503172421.GB3491@APFDCB5C>
Mail-Followup-To: Akinobu Mita <akinobu.mita@gmail.com>,
	linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Cleanup using bitrev8 in cm4000_cs driver.

Cc: Harald Welte <laforge@gnumonks.org>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 drivers/char/pcmcia/Kconfig     |    1 +
 drivers/char/pcmcia/cm4000_cs.c |   35 ++++++-----------------------------
 2 files changed, 7 insertions(+), 29 deletions(-)

Index: 2.6-git/drivers/char/pcmcia/Kconfig
===================================================================
--- 2.6-git.orig/drivers/char/pcmcia/Kconfig
+++ 2.6-git/drivers/char/pcmcia/Kconfig
@@ -21,6 +21,7 @@ config SYNCLINK_CS
 config CARDMAN_4000
 	tristate "Omnikey Cardman 4000 support"
 	depends on PCMCIA
+	select BITREVERSE
 	help
 	  Enable support for the Omnikey Cardman 4000 PCMCIA Smartcard
 	  reader.
Index: 2.6-git/drivers/char/pcmcia/cm4000_cs.c
===================================================================
--- 2.6-git.orig/drivers/char/pcmcia/cm4000_cs.c
+++ 2.6-git/drivers/char/pcmcia/cm4000_cs.c
@@ -31,6 +31,7 @@
 #include <linux/init.h>
 #include <linux/fs.h>
 #include <linux/delay.h>
+#include <linux/bitrev.h>
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
@@ -194,41 +195,17 @@ static inline unsigned char xinb(unsigne
 }
 #endif
 
-#define	b_0000	15
-#define	b_0001	14
-#define	b_0010	13
-#define	b_0011	12
-#define	b_0100	11
-#define	b_0101	10
-#define	b_0110	9
-#define	b_0111	8
-#define	b_1000	7
-#define	b_1001	6
-#define	b_1010	5
-#define	b_1011	4
-#define	b_1100	3
-#define	b_1101	2
-#define	b_1110	1
-#define	b_1111	0
-
-static unsigned char irtab[16] = {
-	b_0000, b_1000, b_0100, b_1100,
-	b_0010, b_1010, b_0110, b_1110,
-	b_0001, b_1001, b_0101, b_1101,
-	b_0011, b_1011, b_0111, b_1111
-};
+static inline unsigned char invert_revert(unsigned char ch)
+{
+	return bitrev8(~ch);
+}
 
 static void str_invert_revert(unsigned char *b, int len)
 {
 	int i;
 
 	for (i = 0; i < len; i++)
-		b[i] = (irtab[b[i] & 0x0f] << 4) | irtab[b[i] >> 4];
-}
-
-static unsigned char invert_revert(unsigned char ch)
-{
-	return (irtab[ch & 0x0f] << 4) | irtab[ch >> 4];
+		b[i] = invert_revert(b[i]);
 }
 
 #define	ATRLENCK(dev,pos) \
