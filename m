Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbYHGPdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbYHGPdT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751643AbYHGPdL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:33:11 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59814 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751388AbYHGPdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:33:10 -0400
Date: Thu, 7 Aug 2008 16:31:49 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Romano Giannetti <romanol@upcomillas.es>
cc: linux-kernel <linux-kernel@vger.kernel.org>,
       bugme-daemon@bugzilla.kernel.org, drzeus-mmc@drzeus.cx,
       "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug 11267] SD cards stopped working on my machine
In-Reply-To: <489B1066.1020909@upcomillas.es>
Message-ID: <Pine.LNX.4.64.0808071623210.559@blonde.site>
References: <489B1066.1020909@upcomillas.es>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Aug 2008, Romano Giannetti wrote:
> I just posted a regression bug on bugzilla:
> 
> 	http://bugzilla.kernel.org/show_bug.cgi?id=11267
> 
> the new kernel stopped to notice the fact that I introduce an SD card into the
> slot of the machine. It used to work perfectly in 2.6.26 (came back and
> tested, so it's not hardware).
> 
> In 2.6.26 I had on the dmesg:
> 
> [  131.145237] mmc0: new high speed SD card at address b368
> [  131.145295] PM: Adding info for mmc:mmc0:b368
> [  131.176370] mmcblk0: mmc0:b368 SD    2009600KiB (ro)
> [  131.176370] PM: Adding info for No Bus:mmcblk0
> [  131.176370]  mmcblk0: p1
> [  131.176434] PM: Adding info for No Bus:mmcblk0p1
> [  131.176434] PM: Adding info for No Bus:179:0
> 
> In 2.6.27-rc2 nothing happens. I have not a lot of time in my hands, so if
> it's possible at all I'd like to avoid a bisect (It's more than one hour per
> compile here...)

Please try yesterday's patch from the scsi-rc-fixes tree,
commit d211f052fa58a053639bc51501cb64421157d362
which fixed SD cards over USB storage for me:

[SCSI] sd: fix USB devices incorrectly reporting DIF support

Some USB devices set the protect bit in the INQUIRY data which
currently causes the DIF code in sd to assume (incorrectly) that they
support READ_CAPACITY(16).  Fix this (only for the time being) by
making sure we only believe the protect bit in the inquiry data if the
device claims conformance to SCSI-3 or above.

Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
---

diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 291d56a..80b2e93 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -6,6 +6,7 @@
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 #include <linux/blkdev.h>
+#include <scsi/scsi.h>
 #include <asm/atomic.h>
 
 struct request_queue;
@@ -426,7 +427,7 @@ static inline int scsi_device_enclosure(struct scsi_device *sdev)
 
 static inline int scsi_device_protection(struct scsi_device *sdev)
 {
-	return sdev->inquiry[5] & (1<<0);
+	return sdev->scsi_level > SCSI_2 && sdev->inquiry[5] & (1<<0);
 }
 
 #define MODULE_ALIAS_SCSI_DEVICE(type) \
