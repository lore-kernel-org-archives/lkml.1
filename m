Return-Path: <linux-kernel-owner+w=401wt.eu-S1753592AbYCRMt6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592AbYCRMt6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2008 08:49:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752529AbYCRMtu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Mar 2008 08:49:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:36868 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYCRMtt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2008 08:49:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=I6+fyDTJPCaSlzWM73lETpXTvJm0iM+BSrOIlV5S3RTDlEzo/OcYWZu7qaOzsPovjsaIR7fi20Bz2ewq/cx+5xP2hdqzGE3MF8qwt4MMN5SvVYhzT996W+FTVBE9XGpTQV3cCLL8nO72hcXU9FbH08f3J4q3uQgGq6OjMXzuw3s=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: Linux 2.6.25-rc4
Date: Tue, 18 Mar 2008 14:03:36 +0100
User-Agent: KMail/1.9.9
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <jens.axboe@oracle.com>,
       Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LFD.1.00.0803042044460.12253@woody.linux-foundation.org> <alpine.LFD.1.00.0803171548480.3020@woody.linux-foundation.org> <20080318001831.575D093C911@tippex.mynet.homeunix.org>
In-Reply-To: <20080318001831.575D093C911@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803181403.37969.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 18 March 2008, Anders Eriksson wrote:
> 
> torvalds@linux-foundation.org said:
> > So try to see if you get to ide_error(), which is where Bartlomiejs latest
> > patch was in effect - but add a few printk's there to print out the 'stat'
> > variable etc to see if it actually triggers. And maybe a WARN_ON(1) to get
> > the trace.. 
> 
> Seems we don't. At least this addition didn't yield anything:
> 
> ide_startstop_t ide_error (ide_drive_t *drive, const char *msg, u8 stat)
> {
>         ide_hwif_t *hwif = drive->hwif;
>         struct request *rq = hwif->hwgroup->rq;
>         u8 err;
> 
>               printk("ide_error(msg=%s, stat=%i)\n",msg,stat);
>               WARN_ON(1);
>                if (rq && rq->cmd_type == REQ_TYPE_ATA_TASKFILE) {
> 

Could you also add printk() to task_in_intr()?

---
 drivers/ide/ide-taskfile.c |    2 ++
 1 file changed, 2 insertions(+)

Index: b/drivers/ide/ide-taskfile.c
===================================================================
--- a/drivers/ide/ide-taskfile.c
+++ b/drivers/ide/ide-taskfile.c
@@ -433,6 +433,8 @@ static ide_startstop_t task_in_intr(ide_
 
 	/* new way for dealing with premature shared PCI interrupts */
 	if (!OK_STAT(stat, DRQ_STAT, BAD_R_STAT)) {
+		printk(KERN_INFO "%s: %s: stat=%02x\n",
+				 __func__, drive->name, stat);
 		if (stat & (ERR_STAT | DRQ_STAT))
 			return task_error(drive, rq, __FUNCTION__, stat);
 		/* No data yet, so wait for another IRQ. */

