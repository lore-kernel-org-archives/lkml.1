Return-Path: <linux-kernel-owner+w=401wt.eu-S1757234AbZDGTle@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757234AbZDGTle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 15:41:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756252AbZDGTlW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 15:41:22 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:55161 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755254AbZDGTlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 15:41:21 -0400
Message-ID: <49DBAC42.4040003@garzik.org>
Date: Tue, 07 Apr 2009 15:40:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Arjan van de Ven <arjan@infradead.org>, Mark Lord <lkml@rtr.ca>,
       Theodore Tso <tytso@mit.edu>, Jens Axboe <jens.axboe@oracle.com>,
       Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
       Linux IDE mailing list <linux-ide@vger.kernel.org>
Subject: [PATCH libata: add SSD detection hueristic; move SSD setup to ata_dev_configure
 (was Re: [GIT PULL] Ext3 latency fixes)
References: <alpine.LFD.2.00.0904031150190.4015@localhost.localdomain> <alpine.LFD.2.00.0904031329410.7007@localhost.localdomain> <20090404135719.GA9812@mit.edu> <20090404151649.GE5178@kernel.dk> <alpine.LFD.2.00.0904040854470.3915@localhost.localdomain> <20090404173412.GF5178@kernel.dk> <alpine.LFD.2.00.0904041039230.3915@localhost.localdomain> <20090404180108.GH5178@kernel.dk> <20090404232222.GA7480@mit.edu> <20090404163349.20df1208@infradead.org> <20090405001005.GA7553@mit.edu> <alpine.LFD.2.00.0904050927580.4023@localhost.localdomain> <49D8E71F.6000703@rtr.ca> <49D91B31.90300@garzik.org> <20090405164831.7ad01c20@infradead.org> <49D99775.9030104@garzik.org> <alpine.LFD.2.00.0904071107500.27889@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.0904071107500.27889@localhost.localdomain>
Content-Type: multipart/mixed;
 boundary="------------040402060904010309020104"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------040402060904010309020104
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Linus Torvalds wrote:
> 
> On Mon, 6 Apr 2009, Jeff Garzik wrote:
> 
>> Arjan van de Ven wrote:
>>> On Sun, 05 Apr 2009 16:57:21 -0400
>>> Jeff Garzik <jeff@garzik.org> wrote:
>>>> We set it in libata-scsi.c:ata_scsi_dev_config() based on
>>>> ata_id_is_ssd()
>>>>
>>>> That hueristic probably assumes Intel SSDs or something :/
>>> you mean the "rpm" set to '1' ?
>>> I was pretty sure that that was industry standard...
>> A -new- industry standard.  You can certainly create a compliant SSD while
>> only conforming to ATA-7, for example.  Some older IDE flash devices pretend
>> they are normal hard drives in almost every respect, too.
> 
> Something like this might be a good idea. 
> 
> I've seen several SSD's that do _not_ do that whole RPM == 1 thing, but 
> they have "SSD" in their names. 
> 
> I forget how the ID is stored (I have this memory of it being big-endian 
> 16-bit words or something crazy like that?), but aside from fixing up that 
> kind of crazyness, maybe something like this is worth it?
> 
> And making it non-inline, of course. And maybe it should use 'strstr()' 
> instead of checking whether the name ends in 'SSD'. You get the idea..

ata_id_string() or ata_id_c_string() is what you want.

But yeah, we see what you're trying to illustrate.

For internal reasons, it is better to detect and set up SSD details in 
ata_dev_configure(), where we detect and configure other ATA details.

I've attached an example patch, compiled-tested only.

If we wanted to get more fancy, we could extend the strn_pattern_cmp() 
function in libata to accept wildcard '*' prefixes, as well as suffixes. 
  That would make it easy to auto-configure future ATA devices based on 
the product id (such as "G.SKILL 128GB SSD").

	Jeff



--------------040402060904010309020104
Content-Type: text/plain;
 name="patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="patch"

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index e7ea77c..3043a61 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2411,6 +2411,8 @@ int ata_dev_configure(struct ata_device *dev)
 
 	/* ATA-specific feature tests */
 	if (dev->class == ATA_DEV_ATA) {
+		char *model_suffix;
+
 		if (ata_id_is_cfa(id)) {
 			if (id[162] & 1) /* CPRM may make this media unusable */
 				ata_dev_printk(dev, KERN_WARNING,
@@ -2438,6 +2440,13 @@ int ata_dev_configure(struct ata_device *dev)
 					dev->multi_count = cnt;
 		}
 
+		if (strlen(modelbuf) <= 3)
+			model_suffix = modelbuf;
+		else
+			model_suffix = modelbuf + (strlen(modelbuf) - 3);
+		if (ata_id_is_ssd(id) || !strcmp(model_suffix, "SSD"))
+			dev->flags |= ATA_DFLAG_NONROT;
+
 		if (ata_id_has_lba(id)) {
 			const char *lba_desc;
 			char ncq_desc[20];
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index b9747fa..e597a4f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -1097,7 +1097,7 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
 
 		blk_queue_dma_drain(q, atapi_drain_needed, buf, ATAPI_MAX_DRAIN);
 	} else {
-		if (ata_id_is_ssd(dev->id))
+		if (dev->flags & ATA_DFLAG_NONROT)
 			queue_flag_set_unlocked(QUEUE_FLAG_NONROT,
 						sdev->request_queue);
 
diff --git a/include/linux/libata.h b/include/linux/libata.h
index b450a26..a0fdbf0 100644
--- a/include/linux/libata.h
+++ b/include/linux/libata.h
@@ -147,6 +147,7 @@ enum {
 	ATA_DFLAG_SLEEPING	= (1 << 15), /* device is sleeping */
 	ATA_DFLAG_DUBIOUS_XFER	= (1 << 16), /* data transfer not verified */
 	ATA_DFLAG_NO_UNLOAD	= (1 << 17), /* device doesn't support unload */
+	ATA_DFLAG_NONROT	= (1 << 18), /* is non-rotational media, SSD */
 	ATA_DFLAG_INIT_MASK	= (1 << 24) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 24),

--------------040402060904010309020104--
