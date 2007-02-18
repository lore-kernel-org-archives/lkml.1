Return-Path: <linux-kernel-owner+w=401wt.eu-S933197AbXBRKpI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197AbXBRKpI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Feb 2007 05:45:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933198AbXBRKpH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Feb 2007 05:45:07 -0500
Received: from nf-out-0910.google.com ([64.233.182.188]:30487 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933197AbXBRKpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Feb 2007 05:45:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=FM23GrYvZ7JiPK8GzCV9hDvPnFjdeBsB5Zz5QOm5Pf/0FA8xvaHaicbKkqLG9lWIVholTgKprDc/HW6kX1b4i6dIo6xgfDxOQ2Hwsto7qrdxtTDZljdoMDlCWwS4QEDR/fNpZpyNkmSsODGbXX8StPg583lqDbmdAwY9TAaR23w=
Date: Sun, 18 Feb 2007 13:42:22 +0300
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Dan Aloni <da-x@monatomic.org>
Cc: Andi Kleen <ak@suse.de>, linux-kernel-list <linux-kernel@vger.kernel.org>
Subject: Re: e2b2rom_init_one():  Unable to register resource
Message-ID: <20070218104222.GC10865@cvg>
References: <20070217212918.GA26554@localdomain>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="sm4nu43k4a2Rpi4c"
Content-Disposition: inline
In-Reply-To: <20070217212918.GA26554@localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Feb 17, 2007 at 11:29:19PM +0200, Dan Aloni wrote:
| Hello,
| 
| I'm running the x86_64 arch of Linux 2.6.20 on a Supermicro X6DH8-XG2 
| board and I got this during boot:
| 
| [248660.950695] device id = 2440
| [248660.950699] device id = 2480
| [248660.950703] device id = 24c0
| [248660.950706] device id = 24d0
| [248660.950709] matched device = 24d0
| [248660.950712] matched device id 24d0
| [248660.950716] pci_read_config_byte : 4
| [248660.950723] esb2rom: esb2rom_init_one(): Unable to register resource 
| 0xffffffffffc00000-0xffffffff - kernel bug?
| [248660.950729] esb2rom: ioremap(ffffffffffc00000, 100400000) failed
| [248660.956859] retVal = -19
| 
| Looks like some kind of a 64-bit portability bug...
| 
| -- 
| Dan Aloni
| XIV LTD, http://www.xivstorage.com
| da-x (at) monatomic.org, dan (at) xiv.co.il
| -
| To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
| the body of a message to majordomo@vger.kernel.org
| More majordomo info at  http://vger.kernel.org/majordomo-info.html
| Please read the FAQ at  http://www.tux.org/lkml/
| 

Hi,

here is a patch attached to the mail. You may test it. Actually
I have no 64bit machine to test it and I'm worried about the
patch accuracy. So be carefull testing it. I sent a copy of the
message to Andi Kleen (who is a maintainer of X86-64 port) may be
we should wait for its answer ;)

		Cyrill


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="esb2rom.c.diff"

diff --git a/drivers/mtd/maps/esb2rom.c b/drivers/mtd/maps/esb2rom.c
index a9d808a..d63c060 100644
--- a/drivers/mtd/maps/esb2rom.c
+++ b/drivers/mtd/maps/esb2rom.c
@@ -214,6 +214,9 @@ static int __devinit esb2rom_init_one(struct pci_dev *pdev,
 
 	/* reserved  0x0020 and 0x0010 */
 	window->phys -= 0x400000UL;
+#ifdef CONFIG_64BIT
+	window->phys &= 0xffffffffUL;
+#endif
 	window->size = (0xffffffffUL - window->phys) + 1UL;
 
 	/* Enable writes through the rom window */

--sm4nu43k4a2Rpi4c--
