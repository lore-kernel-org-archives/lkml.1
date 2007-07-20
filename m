Return-Path: <linux-kernel-owner+w=401wt.eu-S941162AbXGTQWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S941162AbXGTQWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2007 12:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935249AbXGTQWK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Jul 2007 12:22:10 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:43676 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935040AbXGTQWI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2007 12:22:08 -0400
Date: Fri, 20 Jul 2007 18:22:03 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: sdhci-devel@list.drzeus.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: SDHCI: mmc0: Unexpected interrupt 0x00008000.
Message-ID: <20070720182203.3f378d58@poseidon.drzeus.cx>
In-Reply-To: <469FB856.6030000@goop.org>
References: <469FB856.6030000@goop.org>
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.11.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-14382-1184948530-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-14382-1184948530-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thu, 19 Jul 2007 12:15:34 -0700
Jeremy Fitzhardinge <jeremy@goop.org> wrote:

> I'm getting this with current GIT kernels when I plug an SD card into
> the side of my machine.  It appears to see the filesystem OK anyway,
> but for some reason all the hal/gnome desktop stuff isn't seeing it.
> Was working last week.
> 

This appeared because we fixed another bug. Try the included patch.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-14382-1184948530-0001-2
Content-Type: text/x-patch; name="errmask.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=errmask.patch

commit 0668da722a0c48e8629d697fa354e23a02548093
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Fri Jul 20 18:20:36 2007 +0200

    sdhci: make sure to clear the error interrupt
    
    The controller has a bit indicating that one of the higher bits (the
    error bits) are set. A previous bug caused this bit to be masked, but
    since that bug has been fixed we have to clear it explicictly.
    
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/drivers/mmc/host/sdhci.c b/drivers/mmc/host/sdhci.c
index 10d15c3..4a24db0 100644
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -1024,6 +1024,8 @@ static irqreturn_t sdhci_irq(int irq, void *dev_id)
 
 	intmask &= ~(SDHCI_INT_CMD_MASK | SDHCI_INT_DATA_MASK);
 
+	intmask &= ~SDHCI_INT_ERROR;
+
 	if (intmask & SDHCI_INT_BUS_POWER) {
 		printk(KERN_ERR "%s: Card is consuming too much power!\n",
 			mmc_hostname(host->mmc));
diff --git a/drivers/mmc/host/sdhci.h b/drivers/mmc/host/sdhci.h
index 7400f4b..a6c8704 100644
--- a/drivers/mmc/host/sdhci.h
+++ b/drivers/mmc/host/sdhci.h
@@ -107,6 +107,7 @@
 #define  SDHCI_INT_CARD_INSERT	0x00000040
 #define  SDHCI_INT_CARD_REMOVE	0x00000080
 #define  SDHCI_INT_CARD_INT	0x00000100
+#define  SDHCI_INT_ERROR	0x00008000
 #define  SDHCI_INT_TIMEOUT	0x00010000
 #define  SDHCI_INT_CRC		0x00020000
 #define  SDHCI_INT_END_BIT	0x00040000

--=_hera.drzeus.cx-14382-1184948530-0001-2--
