Return-Path: <linux-kernel-owner+w=401wt.eu-S1752512AbXCDVub@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512AbXCDVub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 16:50:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752506AbXCDVua
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 16:50:30 -0500
Received: from keetweej.vanheusden.com ([213.84.46.114]:57358 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507AbXCDVu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 16:50:29 -0500
Date: Sun, 4 Mar 2007 22:47:50 +0100
From: Folkert van Heusden <folkert@vanheusden.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-hams@vger.kernel.org, sailer@ife.ee.ethz.ch, henk.termeer@gmail.com,
       udovdh@xs4all.nl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] baycom_ser_fdx: also allow i/o ports >= 0x1000 and
	enhanced failure logging
Message-ID: <20070304214726.GV10782@vanheusden.com>
References: <20070304213034.GU10782@vanheusden.com>
	<20070304224355.19308ec0@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070304224355.19308ec0@lxorguk.ukuu.org.uk>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Mon Mar  5 12:48:59 CET 2007
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > The baycom_ser_fdx driver did not allow i/o ports >= 0x1000. Now that
> > there are pci cards (with rs232 ports) which use for example 0xb800 this
> > limit should not exists.
> The IRQ test is also wrong for PCI systems the moment an APIC is present.
> NR_IRQS is the define to use.

Ok, changed:


Signed-off-by: Folkert van Heusden <folkert@vanheusden.com>

--- ./drivers/net/hamradio/baycom_ser_fdx.c.org 2007-03-04 22:24:47.000000000 +0100
+++ ./drivers/net/hamradio/baycom_ser_fdx.c     2007-03-04 22:42:51.000000000 +0100
@@ -413,11 +413,15 @@

        if (!dev || !bc)
                return -ENXIO;
-       if (!dev->base_addr || dev->base_addr > 0x1000-SER12_EXTENT ||
-           dev->irq < 2 || dev->irq > 15)
+       if (!dev->base_addr || dev->base_addr > 0xffff-SER12_EXTENT ||
+           dev->irq < 2 || dev->irq > NR_IRQS) {
+               printk(KERN_INFO "baycom_ser_fdx: invalid portnumber (max %u) or irq (2 <= irq <= %d)\n", 0xffff-SER12_EXTENT, NR_IRQS);
                return -ENXIO;
-       if (bc->baud < 300 || bc->baud > 4800)
+       }
+       if (bc->baud < 300 || bc->baud > 4800) {
+               printk(KERN_INFO "baycom_ser_fdx: invalid baudrate (300...4800)\n");
                return -EINVAL;
+       }
        if (!request_region(dev->base_addr, SER12_EXTENT, "baycom_ser_fdx")) {
                printk(KERN_WARNING "BAYCOM_SER_FSX: I/O port 0x%04lx busy \n",
                       dev->base_addr);


Folkert van Heusden

-- 
MultiTail är en flexibel redskap för att fälja logfilar, utför av
commandoer, filtrera, ge färg, sammanfoga, o.s.v. följa.
http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
