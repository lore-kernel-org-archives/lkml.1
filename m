Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbXIZBVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbXIZBVU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 21:21:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751758AbXIZBVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 21:21:07 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45148 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbXIZBVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 21:21:05 -0400
Message-ID: <46F9B3FE.1060905@garzik.org>
Date: Tue, 25 Sep 2007 21:21:02 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "Berck E. Nash" <flyboy@gmail.com>
CC: "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.23-rc7-mm1 AHCI ATA errors -- won't boot
References: <46F7FBCB.4030803@gmail.com> <46F8665A.4000206@garzik.org> <46F9617F.1010508@gmail.com>
In-Reply-To: <46F9617F.1010508@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------090505030804070906090101"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------090505030804070906090101
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Berck E. Nash wrote:
> Jeff Garzik wrote:
>> Once the blame has been squared fixed upon me :) you can use git-bisect
>> to locate the precise change that broke your setup.
> 
> Okay, here's the problem:
> 
> 268fe6f9f15551be9abedd44a237392675d529d5 is first bad commit
> commit 268fe6f9f15551be9abedd44a237392675d529d5
> Author: Jeff Garzik <jeff@garzik.org>
> Date:   Fri Sep 21 07:09:36 2007 -0400
> 
>     [libata] SCSI: simple TEST UNIT READY simulation
> 
>     It's trivial to ping the device, and that's a much more sane behavior
>     than no-op.
> 
>     Signed-off-by: Jeff Garzik <jeff@garzik.org>
> 
> :040000 040000 44d34cdad073bd623545b8239aca9a113652c6d0
> df6d21f7ce56a4e796f8f856c1f647b0395ab4df M      drivers

Does the attached patch change behavior at all?  You should be able to 
apply it on top of libata-dev.git#upstream or -mm.

If there are still problems, an updated dmesg (w/ the attached patch) 
and output from enabling ATA_DEBUG (include/linux/libata.h) would be 
very helpful.

Thanks!

	Jeff



--------------090505030804070906090101
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3882c72..c9838f1 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2800,7 +2800,9 @@ static inline ata_xlat_func_t ata_get_xlat_func(struct ata_device *dev, u8 cmd)
 		return ata_scsi_start_stop_xlat;
 
 	case TEST_UNIT_READY:
-		return ata_scsi_tur_xlat;
+		if (ata_id_has_pm(dev->id))
+			return ata_scsi_tur_xlat;
+		return NULL;
 	}
 
 	return NULL;
@@ -3021,6 +3023,7 @@ void ata_scsi_simulate(struct ata_device *dev, struct scsi_cmnd *cmd,
 		case REZERO_UNIT:
 		case SEEK_6:
 		case SEEK_10:
+		case TEST_UNIT_READY:		/* only for !PM devices */
 			ata_scsi_rbuf_fill(&args, ata_scsiop_noop);
 			break;
 

--------------090505030804070906090101--
