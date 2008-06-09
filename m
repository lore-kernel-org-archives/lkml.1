Return-Path: <linux-kernel-owner+w=401wt.eu-S1761299AbYFIPFh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761299AbYFIPFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2008 11:05:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754242AbYFIPFW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jun 2008 11:05:22 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47368 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753932AbYFIPFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2008 11:05:20 -0400
Subject: Re: [Cbe-oss-dev] [regression/bisected] corrupt CD data after
	media change and delay
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: David Martin <tasio@hierro.tasio.net>, linux-scsi@vger.kernel.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Maarten Bressers <mbres@gentoo.org>, Daniel Drake <dsd@gentoo.org>,
       Cell Broadband Engine OSS Development 
	<cbe-oss-dev@ozlabs.org>
In-Reply-To: <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
References: <Pine.LNX.4.64.0806061458300.6228@vixen.sonytel.be>
	 <1212765202.16182.5.camel@localhost.localdomain>
	 <Pine.LNX.4.64.0806091443000.17741@vixen.sonytel.be>
	 <Pine.LNX.4.64.0806091546260.22138@vixen.sonytel.be>
Content-Type: text/plain
Date: Mon, 09 Jun 2008 10:05:16 -0500
Message-Id: <1213023916.3508.23.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-06-09 at 15:54 +0200, Geert Uytterhoeven wrote:
> I managed to reproduce it on my laptop (Core 2 Duo, SATA DVD-RAM, running
> Ubuntu 8.04 for amd64), by booting Debian's 2.6.25 kernel into recovery mode.
> So the problem is not PS3-specific.
> 
> Worse, I never got an updated /sys/block/sr0/size for the second CD, not even
> when mounting it ASAP (which is ca. 15-20 seconds after inserting it).  It
> always stayed at the value for the first CD.
> 
> Note that Debian's tar is `smart' and optimizes `tar cf /dev/null' by never
> reading the input files, so you have to e.g. pipe the resulting archive to
> `cat > /dev/null' or so.

Well, we have the taxonomy.  It's something to do with the media change
trigger.  Could you try getting the output of this patch and correlate
the prints with your success and failure cases?

Thanks,

James

---

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 7ee86d4..2b58772 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -212,6 +212,8 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 	if (retval || (scsi_sense_valid(sshdr) &&
 		       /* 0x3a is medium not present */
 		       sshdr->asc == 0x3a)) {
+		printk("+10+ the result = 0x%x, skip size update ", retval);
+		scsi_show_sense_hdr(&sshdr);
 		/* Media not present or unable to test, unit probably not
 		 * ready. This usually means there is no disc in the drive.
 		 * Mark as changed, and we will figure it out later once
@@ -232,7 +234,7 @@ static int sr_media_change(struct cdrom_device_info *cdi, int slot)
 		sr_cd_check(cdi);
 		get_sectorsize(cd);
 	}
-
+	printk("+11+ Return forcing update is %d\n", retval);
 out:
 	/* Notify userspace, that media has changed. */
 	if (retval != cd->previous_state)


