Return-Path: <linux-kernel-owner+w=401wt.eu-S1759541AbXKAJYy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759541AbXKAJYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 05:24:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755690AbXKAJYq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 05:24:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:11265 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753376AbXKAJYp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 05:24:45 -0400
Date: Thu, 1 Nov 2007 10:21:55 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: linux-kernel@vger.kernel.org
Cc: jeff@garzik.org, kristen.c.accardi@intel.com, linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071101092155.GB5037@kernel.dk>
References: <20071031201308.GK11514@kernel.dk> <20071101084145.GA5037@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071101084145.GA5037@kernel.dk>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01 2007, Jens Axboe wrote:
> On Wed, Oct 31 2007, Jens Axboe wrote:
> > Hi,
> > 
> > My x60 stopped suspending about two days ago. It just freezes after
> > printing
> > 
> > Suspending console(s)
> > 
> > where it would normally turn everything off and the 'moon' light would
> > go on. Posting this message in case somebody else knows what is up, if
> > not I'll do a bisect on it tomorrow.
> 
> Did the bisect, it points to this commit:
> 
> 1556594f913fa81d008cecfe46d7211c919a853 is first bad commit
> commit 31556594f913fa81d008cecfe46d7211c919a853
> Author: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> Date:   Thu Oct 25 01:33:26 2007 -0400
> 
>     [libata] AHCI: add hw link power management support
> 
> Booting any kernel after this commit fails suspending to ram, it just
> sits there forever.

Reverting just the default AHCI flags makes it work again. IOW, with the
below patch I can suspend properly with current -git.

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ed9b407..77f7631 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -190,8 +190,7 @@ enum {
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-					  ATA_FLAG_IPM,
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
 };
 

-- 
Jens Axboe

