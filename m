Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbYLWCYI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbYLWCYI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2008 21:24:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754477AbYLWCXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Dec 2008 21:23:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:48488 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754399AbYLWCXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2008 21:23:54 -0500
Message-ID: <49504B8C.8080907@kernel.org>
Date: Tue, 23 Dec 2008 11:23:08 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Justin Madru <jdm64@gawab.com>
CC: lkml <linux-kernel@vger.kernel.org>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-ide@vger.kernel.org,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jeff Garzik <jeff@garzik.org>
Subject: Re: [2.6.28-rc] Sata soft reset filling log
References: <494318F5.4060007@gawab.com> <494EFD79.7020008@kernel.org> <494F3AD2.3060201@gawab.com> <494F3E41.60304@kernel.org> <49500BE2.6050106@gawab.com>
In-Reply-To: <49500BE2.6050106@gawab.com>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/mixed;
 boundary="------------000309010502010406070806"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Tue, 23 Dec 2008 02:23:14 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000309010502010406070806
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hello,

Justin Madru wrote:
>> Ah.. strange.  The command protocol is ATAPI_PROT_NODATA and the drive
>> should be setting DRQ to receive CDB but it's not doing that.
>> Strange.  It could be that the drive is a little bit tardy with DRQ -
>> ie. setting DRQ after clearing BUSY and ata_piix is now successfully
>> hitting the small window for some reason.
>>
>> Does the attached patch make any difference?
>>
>> Thanks.
>>
>>   
> Ok, I applied your patch. Unfortunately, it didn't fix my problem.
> I now get a different, but similar message; not sure if it happens less
> frequently - still often though.

Aiee...

> What changes happened between .27 and .28 could've caused this?
> Anyways, below is what I get now (with your patch), including the
> frequency of occurrence.

I have no idea and I'm afraid we'll need a bisection here. :-( Can you
please try the attached patch?

Thanks.

-- 
tejun

--------------000309010502010406070806
Content-Type: text/x-patch;
 name="DRQ-debug-1.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="DRQ-debug-1.patch"

diff --git a/drivers/ata/libata-sff.c b/drivers/ata/libata-sff.c
index 4b47394..fcd7d08 100644
--- a/drivers/ata/libata-sff.c
+++ b/drivers/ata/libata-sff.c
@@ -1120,6 +1120,22 @@ fsm_start:
 		 */
 		poll_next = (qc->tf.flags & ATA_TFLAG_POLLING);
 
+		{
+			int cnt = 0;
+
+			while (!(status & (ATA_DRQ | ATA_ERR | ATA_DF)) &&
+			       cnt < 100) {
+				status = ap->ops->sff_check_status(ap);
+				cnt++;
+				udelay(10);
+			}
+
+			if (cnt)
+				ata_port_printk(ap, KERN_INFO,
+						"XXX status=%02x after %d tries\n",
+						status, cnt);
+		}
+
 		/* check device status */
 		if (unlikely((status & ATA_DRQ) == 0)) {
 			/* handle BSY=0, DRQ=0 as error */

--------------000309010502010406070806--
