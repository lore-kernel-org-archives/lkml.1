Return-Path: <linux-kernel-owner+w=401wt.eu-S1751810AbXFDAkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbXFDAkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2007 20:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750853AbXFDAj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jun 2007 20:39:57 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47931
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750773AbXFDAj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2007 20:39:56 -0400
Date: Sun, 03 Jun 2007 17:40:10 -0700 (PDT)
Message-Id: <20070603.174010.41894721.davem@davemloft.net>
To: mroos@linux.ee
Cc: linux-kernel@vger.kernel.org
Subject: Re: libata & no PCI: dma_[un]map_single undefined
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.SOC.4.64.0706032314590.20033@math>
References: <Pine.SOC.4.64.0706032314590.20033@math>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Sun, 3 Jun 2007 23:23:33 +0300 (EEST)

> I accidentally enabled libata config options on my Sun Ultra 1 (sparc64, 
> UP, no PCI, only SBUS):
> 
>   MODPOST 440 modules
> ERROR: "dma_unmap_sg" [drivers/ata/libata.ko] undefined!
> ERROR: "dma_map_sg" [drivers/ata/libata.ko] undefined!
> ERROR: "dma_unmap_single" [drivers/ata/libata.ko] undefined!
> ERROR: "dma_mapping_error" [drivers/ata/libata.ko] undefined!
> ERROR: "dma_map_single" [drivers/ata/libata.ko] undefined!
> 
> CONFIG_PCI=n
> CONFIG_ATA=m
> 
> This seems to be a valid configuration since libata can drive non-PCI 
> devices too?

It really makes no sense to allow this on Sparc, there are no
non-PCI Sparc ATA controllers.

Therefore I'll fix it like this:

commit 6274b5c63131c3110405db5d19e71af26cbbd375
Author: David S. Miller <davem@sunset.davemloft.net>
Date:   Sun Jun 3 17:39:56 2007 -0700

    [ATA]: Don't allow to enable this for SPARC64 without PCI.
    
    Based upon a report from Meelis Roos.
    
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index b4a8d60..7d893a6 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -8,6 +8,7 @@ menuconfig ATA
 	depends on BLOCK
 	depends on !(M32R || M68K) || BROKEN
 	depends on !SUN4 || BROKEN
+	depends on !(SPARC64 && !PCI)
 	select SCSI
 	---help---
 	  If you want to use a ATA hard disk, ATA tape drive, ATA CD-ROM or
