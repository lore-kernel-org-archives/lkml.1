Return-Path: <linux-kernel-owner+w=401wt.eu-S1755636AbZDZOiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636AbZDZOiy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Apr 2009 10:38:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754097AbZDZOin
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Apr 2009 10:38:43 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:58315 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbZDZOim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Apr 2009 10:38:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:reply-to:mail-followup-to
         :mime-version:content-type:content-disposition:user-agent;
        b=ni8Xru5vsHekxqn2krNGh7emsxGjunrJmgJxZXvwocLzUeMT3Ie2s6ULhwzpIoHfrM
         l2h3PnE7yuA2U1wejHHQ10q56n2y+EXlC+/pKit2NKqWChwsMyk6W6ek5JzioHYyttqi
         kCE/PFD1/9VwajuD4VE85CcjVUlAs4KFTMSKs=
Date: Sun, 26 Apr 2009 16:38:36 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] libata: fix suspend/resume for ATA SEMB devices
Message-ID: <20090426143836.GA3643@liondog.tnic>
Reply-To: petkovbb@gmail.com
Mail-Followup-To: petkovbb@gmail.com, Tejun Heo <htejun@gmail.com>,
	Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 26 Apr 2009 16:33:34 +0200
Subject: [PATCH] libata: fix suspend/resume for ATA SEMB devices

79b42babbac2a5a522b8e269fb2811b6e1063030 fixed identifying ATA devices
reporting 3c/c3 signature which belongs to SEMB devices now. However,
suspending the machine with such device (WDC WD2500AAJS-6 01.0) fails
with the following:

hda: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hda: UDMA/100 mode selected
hdb: host max PIO4 wanted PIO255(auto-tune) selected PIO4
hdb: UDMA/66 mode selected
sd 1:0:0:0: [sda] Starting disk
ata5: SATA link down (SStatus 0 SControl 300)
ata1: SATA link down (SStatus 0 SControl 300)
ata3: SATA link down (SStatus 0 SControl 300)
ata6: SATA link down (SStatus 0 SControl 300)
ata2: softreset failed (device not ready)
ata2: failed due to HW bug, retry pmp=0
ata4: softreset failed (device not ready)
ata4: failed due to HW bug, retry pmp=0
ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata2.00: class mismatch 1 != 7
ata2.00: revalidation failed (errno=-19)
ata2: limiting SATA link speed to 1.5 Gbps
ata4.00: configured for UDMA/133
ata2: softreset failed (device not ready)
ata2: failed due to HW bug, retry pmp=0
ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
ata2.00: class mismatch 1 != 7
ata2.00: revalidation failed (errno=-19)
ata2.00: disabled
sd 1:0:0:0: rejecting I/O to offline device
sd 1:0:0:0: [sda] START_STOP FAILED
sd 1:0:0:0: [sda] Result: hostbyte=0x01 driverbyte=0x00
PM: Device 1:0:0:0 failed to thaw: error 65536
sd 3:0:0:0: [sdb] Starting disk

due to a class mismatch in ata_dev_revalidate(). Fix it by adding the
ATA_DEV_SEMB device class to the check.

CC: Tejun Heo <htejun@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>
Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ata/libata-core.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 17c5d48..c924230 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -4091,7 +4091,9 @@ int ata_dev_revalidate(struct ata_device *dev, unsigned int new_class,
 
 	/* fail early if !ATA && !ATAPI to avoid issuing [P]IDENTIFY to PMP */
 	if (ata_class_enabled(new_class) &&
-	    new_class != ATA_DEV_ATA && new_class != ATA_DEV_ATAPI) {
+	    new_class != ATA_DEV_ATA &&
+	    new_class != ATA_DEV_ATAPI &&
+	    new_class != ATA_DEV_SEMB) {
 		ata_dev_printk(dev, KERN_INFO, "class mismatch %u != %u\n",
 			       dev->class, new_class);
 		rc = -ENODEV;
-- 
1.6.2.4

-- 
Regards/Gruss,
    Boris.
