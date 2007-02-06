Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXBFJfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXBFJfJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 04:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbXBFJfJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 04:35:09 -0500
Received: from nf-out-0910.google.com ([64.233.182.191]:50223 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935AbXBFJfG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 04:35:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent:from;
        b=EHt61FX5JjqWyv5GoBW6QepCMC6TJAYyTyZgyHlNrjt4/kJh831Tve9fMF2QdqCZSsdjUBua7mqNoaTVC27R8AmJKQDOZjUjKlUKe7tvav5JenUoxjX5eMfLollXSyxTxcJWsX1WW+lWGDlTiol1GVV818CsxN17lk++56FAMpg=
Date: Tue, 6 Feb 2007 11:34:54 +0200
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: jt@hpl.hp.com, linville@tuxdriver.com, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] wavelan: Use ARRAY_SIZE macro when appropriate
Message-ID: <20070206093454.GS3896@Ahmed>
References: <20070205165429.GD3896@Ahmed> <20070205170044.GM3896@Ahmed> <20070205201709.GB11055@martell.zuzino.mipt.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070205201709.GB11055@martell.zuzino.mipt.ru>
User-Agent: Mutt/1.5.11
From: "Ahmed S. Darwish" <darwish.07@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 05, 2007 at 11:17:09PM +0300, Alexey Dobriyan wrote:
> On Mon, Feb 05, 2007 at 07:00:44PM +0200, Ahmed S. Darwish wrote:
> > A trivial patch to use ARRAY_SIZE macro.
> 
> You're supposed to remove it ans use ARRAY_SIZE where old macro is used.
> 
> > --- a/drivers/net/wireless/wavelan.p.h
> > +++ b/drivers/net/wireless/wavelan.p.h
> > @@ -450,7 +450,7 @@ static const char	*version	= "wavelan.c : v24 (SMP + wireless extensions) 11/12/
> >  #define	WATCHDOG_JIFFIES	(512*HZ/100)
> >
> >  /* Macro to get the number of elements in an array */
> > -#define	NELS(a)				(sizeof(a) / sizeof(a[0]))
> > +#define	NELS(a)				ARRAY_SIZE(a)

Ooh, how dumb the original patch is :). Thanks, here's the modified patch.

A patch to use ARRAY_SIZE macro when appropriate.

Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
---
diff --git a/drivers/net/wireless/wavelan.c b/drivers/net/wireless/wavelan.c
index 24221e4..2aa3c76 100644
--- a/drivers/net/wireless/wavelan.c
+++ b/drivers/net/wireless/wavelan.c
@@ -28,7 +28,7 @@
  */
 static u8 wv_irq_to_psa(int irq)
 {
-	if (irq < 0 || irq >= NELS(irqvals))
+	if (irq < 0 || irq >= ARRAY_SIZE(irqvals))
 		return 0;
 
 	return irqvals[irq];
@@ -42,7 +42,7 @@ static int __init wv_psa_to_irq(u8 irqval)
 {
 	int irq;
 
-	for (irq = 0; irq < NELS(irqvals); irq++)
+	for (irq = 0; irq < ARRAY_SIZE(irqvals); irq++)
 		if (irqvals[irq] == irqval)
 			return irq;
 
@@ -1695,7 +1695,7 @@ static int wv_frequency_list(unsigned long ioaddr,	/* I/O port of the card */
 		/* Look in the table if the frequency is allowed */
 		if (table[9 - (freq / 16)] & (1 << (freq % 16))) {
 			/* Compute approximate channel number */
-			while ((c < NELS(channel_bands)) &&
+			while ((c < ARRAY_SIZE(channel_bands)) &&
 				(((channel_bands[c] >> 1) - 24) < freq)) 
 				c++;
 			list[i].i = c;	/* Set the list index */
@@ -4269,7 +4269,7 @@ struct net_device * __init wavelan_probe(int unit)
 		printk(KERN_DEBUG "%s: <-wavelan_probe()\n", dev->name);
 #endif
 	} else { /* Scan all possible addresses of the WaveLAN hardware. */
-		for (i = 0; i < NELS(iobase); i++) {
+		for (i = 0; i < ARRAY_SIZE(iobase); i++) {
 			dev->irq = def_irq;
 			if (wavelan_config(dev, iobase[i]) == 0) {
 #ifdef DEBUG_CALLBACK_TRACE
@@ -4280,7 +4280,7 @@ struct net_device * __init wavelan_probe(int unit)
 				break;
 			}
 		}
-		if (i == NELS(iobase))
+		if (i == ARRAY_SIZE(iobase))
 			r = -ENODEV;
 	}
 	if (r) 
@@ -4327,14 +4327,14 @@ int __init init_module(void)
 #endif
 
 		/* Copy the basic set of address to be probed. */
-		for (i = 0; i < NELS(iobase); i++)
+		for (i = 0; i < ARRAY_SIZE(iobase); i++)
 			io[i] = iobase[i];
 	}
 
 
 	/* Loop on all possible base addresses. */
 	i = -1;
-	while ((io[++i] != 0) && (i < NELS(io))) {
+	while ((io[++i] != 0) && (i < ARRAY_SIZE(io))) {
 		struct net_device *dev = alloc_etherdev(sizeof(net_local));
 		if (!dev)
 			break;
diff --git a/drivers/net/wireless/wavelan.p.h b/drivers/net/wireless/wavelan.p.h
index 72b646c..fe24281 100644
--- a/drivers/net/wireless/wavelan.p.h
+++ b/drivers/net/wireless/wavelan.p.h
@@ -449,9 +449,6 @@ static const char	*version	= "wavelan.c : v24 (SMP + wireless extensions) 11/12/
 /* Watchdog temporisation */
 #define	WATCHDOG_JIFFIES	(512*HZ/100)
 
-/* Macro to get the number of elements in an array */
-#define	NELS(a)				(sizeof(a) / sizeof(a[0]))
-
 /* ------------------------ PRIVATE IOCTL ------------------------ */
 
 #define SIOCSIPQTHR	SIOCIWFIRSTPRIV		/* Set quality threshold */

-- 
Ahmed S. Darwish
http://darwish-07.blogspot.com
