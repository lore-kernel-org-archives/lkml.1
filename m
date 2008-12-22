Return-Path: <linux-kernel-owner+w=401wt.eu-S1753442AbYLVHPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442AbYLVHPW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 02:15:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752056AbYLVHPH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 02:15:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:48722 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYLVHPF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 02:15:05 -0500
Message-ID: <494F3E41.60304@kernel.org>
Date: Mon, 22 Dec 2008 16:14:09 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
CC: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
References: <494318F5.4060007@gawab.com> <494EFD79.7020008@kernel.org> <494F3AD2.3060201@gawab.com>
In-Reply-To: <494F3AD2.3060201@gawab.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------050403040100070507020408"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Mon, 22 Dec 2008 07:14:17 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050403040100070507020408
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

(cc'ing Mark)

Justin Madru wrote:
> Well, it's good to hear that you don't think my drive is failing (sure
> hope it's not failing!)

Yeap, it's your DVD drive.

> I posted the full dmesg in reply to Alan in
> http://lkml.org/lkml/2008/12/19/30.

Ah.. oops, missed the other messages.  Sorry.

> Also, more information about my computer can be found at:
> http://jdserver.homelinux.org/bugreports/
> If you need me to run anything else not found in the above links then
> let me know.

Ah.. strange.  The command protocol is ATAPI_PROT_NODATA and the drive
should be setting DRQ to receive CDB but it's not doing that.
Strange.  It could be that the drive is a little bit tardy with DRQ -
ie. setting DRQ after clearing BUSY and ata_piix is now successfully
hitting the small window for some reason.

Does the attached patch make any difference?

Thanks.

-- 
tejun

--------------050403040100070507020408
Content-Type: text/x-patch;
 name="DRQ-debug.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="DRQ-debug.patch"

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4b47394..0630ac3 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1120,6 +1120,20 @@ fsm_start:
 		 */
 		poll_next = (qc->tf.flags & ATA_TFLAG_POLLING);
 
+		{
+			int cnt = 0;
+
+			while (!(status & (ATA_DRQ | ATA_ERR | ATA_DF)) &&
+			       cnt < 100) {
+				status = ap->ops->sff_check_status(ap);
+				cnt++;
+			}
+
+			if (cnt)
+				ata_port_printk(ap, KERN_INFO, "XXX DRQ set after %d tries\n",
+						cnt);
+		}
+
 		/* check device status */
 		if (unlikely((status & ATA_DRQ) == 0)) {
 			/* handle BSY=0, DRQ=0 as error */

--------------050403040100070507020408--
