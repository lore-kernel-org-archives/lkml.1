Return-Path: <linux-kernel-owner+w=401wt.eu-S1760484AbXKAMEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760484AbXKAMEm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 08:04:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755543AbXKAMEd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 08:04:33 -0400
Received: from brick.kernel.dk ([87.55.233.238]:2115 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754472AbXKAMEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 08:04:32 -0400
Date: Thu, 1 Nov 2007 13:01:41 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-kernel@vger.kernel.org, kristen.c.accardi@intel.com,
       linux-ide@vger.kernel.org
Subject: Re: Suspend to ram regression (2.6.24-rc1-git)
Message-ID: <20071101120141.GF5037@kernel.dk>
References: <20071031201308.GK11514@kernel.dk> <20071101084145.GA5037@kernel.dk> <20071101092155.GB5037@kernel.dk> <4729B670.7090403@garzik.org> <20071101112419.GE5037@kernel.dk> <4729BEB5.5080504@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729BEB5.5080504@garzik.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 01 2007, Jeff Garzik wrote:
> Jens Axboe wrote:
>> On Thu, Nov 01 2007, Jeff Garzik wrote:
>>> Jens Axboe wrote:
>>>> Reverting just the default AHCI flags makes it work again. IOW, with the
>>>> below patch I can suspend properly with current -git.
>>>> diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
>>>> index ed9b407..77f7631 100644
>>>> --- a/drivers/ata/ahci.c
>>>> +++ b/drivers/ata/ahci.c
>>>> @@ -190,8 +190,7 @@ enum {
>>>>   	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
>>>>  					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
>>>> -					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
>>>> -					  ATA_FLAG_IPM,
>>>> +					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN,
>>>>  	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
>>>
>>> sounds like the easy thing to do, in light of this breakage, might be to 
>>> default it to off, add a module parameter turning it on by setting that 
>>> flag.
>> Wouldn't it be better to just get this bug fixed? IOW, is there a reason
>> for disabling ALPM if it's Bug Free?
>> I'd suggest committing the patch disabling IPM, then Kristen can debug
>> the thing in piece in quiet. Once confident it works with ahci again, we
>> can revert that commit.
>
> Right -- if you are going to commit a patch "disabling" it, it is best to 
> do so via a simple module option, which allows users to easily try the 
> feature in parallel with Intel's debugging.

OK, so you just want the option to be temporary? In that case I think a
config option is better, since you don't risk breaking peoples setups
later when removing the option. That can be quite annoying. Ala the
below.

diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
index ba63619..e276ab6 100644
--- a/drivers/ata/Kconfig
+++ b/drivers/ata/Kconfig
@@ -48,6 +48,14 @@ config SATA_AHCI
 
 	  If unsure, say N.
 
+config SATA_AHCI_IPM
+	bool "AHCI power management"
+	depends on EXPERIMENTAL && SATA_AHCI
+	help
+	  This option adds support for AHCI power management. It current
+	  breaks suspend on some laptops. This option is temporary and will
+	  go away once those issues are fully resolved.
+
 config SATA_SVW
 	tristate "ServerWorks Frodo / Apple K2 SATA support"
 	depends on PCI
diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index ed9b407..37266ce 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -190,8 +190,11 @@ enum {
 
 	AHCI_FLAG_COMMON		= ATA_FLAG_SATA | ATA_FLAG_NO_LEGACY |
 					  ATA_FLAG_MMIO | ATA_FLAG_PIO_DMA |
-					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN |
-					  ATA_FLAG_IPM,
+					  ATA_FLAG_ACPI_SATA | ATA_FLAG_AN
+#ifdef CONFIG_SATA_AHCI_IPM
+					  | ATA_FLAG_IPM
+#endif
+					,
 	AHCI_LFLAG_COMMON		= ATA_LFLAG_SKIP_D2H_BSY,
 };
 

-- 
Jens Axboe

