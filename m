Return-Path: <linux-kernel-owner+w=401wt.eu-S1751777AbYCJMEH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777AbYCJMEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2008 08:04:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYCJMD4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Mar 2008 08:03:56 -0400
Received: from wx-out-0506.google.com ([66.249.82.231]:12003 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750948AbYCJMDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2008 08:03:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type;
        b=dKQNC9vYK7D7ciJAcL1E/9Pmq/h87n11BRTxm8oXvnGWK/dyZRcz96yGYIcc10eGA6o7u1ZTFabLrIAXQICXNZ4pmzgX3awe3WktN4Q4L4gid7CDVAgWjT1JjBlSV4V5HlGNxp1Uu9iR4LZ9nrpsxCWFp+pRm2ASm/JHNHKFyPk=
Message-ID: <47D523A1.7070808@gmail.com>
Date: Mon, 10 Mar 2008 21:03:45 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Andrey Borzenkov <arvidjaar@mail.ru>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [Regression] 2.6.25-rc4-git3: Handling of audio CDs broken on
 pata_ali
References: <200803082246.47987.rjw@sisk.pl> <20080309073824.902DC82CF2E@smtp04.mtu.ru> <200803100012.27520.rjw@sisk.pl> <47D4E64F.5070106@gmail.com> <47D4E78A.10507@gmail.com>
In-Reply-To: <47D4E78A.10507@gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: multipart/mixed;
 boundary="------------000709060004000605070303"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000709060004000605070303
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Tejun Heo wrote:
> Tejun Heo wrote:
>> Rafael J. Wysocki wrote:
>>>>> where ata1 is:
>>>>>
>>>>> scsi0 : pata_ali
>>>>> scsi1 : pata_ali
>>>> Oh, is it only with audio CDs? I am unable to use DVD on pata_ali in DMA at
>>>> all. Have you tried to disable ATAPI DMA (libata.dma=1)?
>>> Data CDs seem to work fine here.
>> * Does booting into runlevel 1, putting in an audio cd and running
>> cdparanoia give the same result?
>>
>> * Does setting module parameter libata.force to "1.00:pio4" make any
>> difference?
> 
> Oh, never mind.  I have a hunch.  I'll report back in a while.
> 

Does the attached patch fix the problem?

-- 
tejun

--------------000709060004000605070303
Content-Type: text/x-patch;
 name="use-cmd_type-in-atapi-dma-check.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="use-cmd_type-in-atapi-dma-check.patch"

 drivers/ata/pata_ali.c    |    2 +-
 drivers/ata/pata_it821x.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_ali.c b/drivers/ata/pata_ali.c
index 7e68edf..8786455 100644
--- a/drivers/ata/pata_ali.c
+++ b/drivers/ata/pata_ali.c
@@ -295,7 +295,7 @@ static void ali_lock_sectors(struct ata_device *adev)
 static int ali_check_atapi_dma(struct ata_queued_cmd *qc)
 {
 	/* If its not a media command, its not worth it */
-	if (qc->nbytes < 2048)
+	if (atapi_cmd_type(qc->cdb[0]) == ATAPI_MISC)
 		return -EOPNOTSUPP;
 	return 0;
 }
diff --git a/drivers/ata/pata_it821x.c b/drivers/ata/pata_it821x.c
index 109ddd4..f751749 100644
--- a/drivers/ata/pata_it821x.c
+++ b/drivers/ata/pata_it821x.c
@@ -564,7 +564,7 @@ static int it821x_check_atapi_dma(struct ata_queued_cmd *qc)
 	struct it821x_dev *itdev = ap->private_data;
 
 	/* Only use dma for transfers to/from the media. */
-	if (qc->nbytes < 2048)
+	if (atapi_cmd_type(qc->cdb[0]) == ATAPI_MISC)
 		return -EOPNOTSUPP;
 
 	/* No ATAPI DMA in smart mode */

--------------000709060004000605070303--
