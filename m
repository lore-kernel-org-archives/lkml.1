Return-Path: <linux-kernel-owner+w=401wt.eu-S1757277AbYCDACs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277AbYCDACs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 19:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752399AbYCDACg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 19:02:36 -0500
Received: from ug-out-1314.google.com ([66.249.92.172]:52577 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYCDACe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 19:02:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=anMNbCN+4ftqwHkJgnrkDaSWCXGkB09cPknMWa3XcOg8IXGGxPDxvl+5zYyK8X1KkStG/NZTEHY6Gh9DVMdh6KOBW36KHfnJ4qjSvbkEBzZOZCnvgbo4LLHyA2BsTnQsy/C+gwOYAN0PoOo/xsGrpNYxJ0dUk8mq84SfJ18T1Fc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Anders Eriksson <aeriksson@fastmail.fm>
Subject: Re: -rc3 regression (was Re: 2.6.25-rc2 + smartd = hang )
Date: Tue, 4 Mar 2008 01:16:42 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org,
       Linux IDE mailing list <linux-ide@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>
References: <20080222165122.8D2BB93C12F@tippex.mynet.homeunix.org> <20080227075346.9D55D93C5CF@tippex.mynet.homeunix.org> <20080228143854.6350093C855@tippex.mynet.homeunix.org>
In-Reply-To: <20080228143854.6350093C855@tippex.mynet.homeunix.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200803040116.42764.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Thursday 28 February 2008, Anders Eriksson wrote:
> 
> aeriksson@fastmail.fm said:
> > bzolnier@gmail.com said:
> >> Thanks.
> >> Unfortunately nothing seems wrong with the patch... :(
> >> I'll take a closer look when I have some more time...
> >> Bart 
> 
> > Just to make sure I didn't goofed up the bisection...
> 
> > I bisected between v2.6.24 and v2.6.25-rc2. In the midst of the bisection,
> > make install decided to call the new version 2.6.24-rc7-gXXXX. Is that ok? I
> > figured rc7+delta was before 24-final, hence outside the bisection? After
> > that event I got the normal series of good god bad good... So I figured we
> > were on the right track anyway...
> 
> > /A  
> 
> I can testify this regression is still present in 2.6.25-rc3

Thanks.

I tried to reproduce it here (PIIX4 controller w/ IC25N060ATMR04-0 disk)
but I couldn't so it must be something specific to your hardware/system
configuration.

| Feb 22 00:09:19 tippex hda: UDMA/33 mode selected
| Feb 22 00:09:19 tippex hda: drive_cmd: status=0x51 { DriveReady SeekComplete Error }
| Feb 22 00:09:19 tippex hda: drive_cmd: error=0x04 { DriveStatusError }
| Feb 22 00:09:19 tippex ide: failed opcode was: 0xef
| Feb 22 00:09:19 tippex hdb: UDMA/33 mode selected
| Feb 22 00:09:19 tippex hdd: UDMA/33 mode selected

Code for changing transfer modes hasn't been rewritten yet and is known to
be racy/buggy.  It could be that changes to the way special requests are
handled caused some races to trigger more likely.

[ libata doesn't support speed changes we should probably do the same for
  drivers/ide/ (it does all the tuning anyway nowadays) ]

Please try the included patch (at the end of this mail).

| Feb 22 00:11:07 tippex smartd[6349]: smartd version 5.37 [i686-pc-linux-gnu] Copyright (C) 2002-6 Bruce Allen
| Feb 22 00:11:07 tippex smartd[6349]: Home page is http://smartmontools.sourceforge.net/
| Feb 22 00:11:07 tippex smartd[6349]: Opened configuration file /etc/smartd.conf
| Feb 22 00:11:07 tippex smartd[6349]: Configuration file /etc/smartd.conf parsed.
| Feb 22 00:11:07 tippex smartd[6349]: Device: /dev/hdb, opened
| Feb 22 00:11:07 tippex smartd[6349]: Device: /dev/hdb, found in smartd database.
| Feb 22 00:11:07 tippex smartd[6349]: Device: /dev/hdb, enabled SMART Attribute Autosave.
| Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdb, enabled SMART Automatic Offline Testing.
| Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdb, is SMART capable. Adding to "monitor" list.
| Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, opened
| Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, found in smartd database.
| Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, enabled SMART Attribute Autosave.
| Feb 22 00:11:08 tippex smartd[6349]: Device: /dev/hdd, enabled SMART Automatic Offline Testing.
| Feb 22 00:11:09 tippex smartd[6349]: Device: /dev/hdd, is SMART capable. Adding to "monitor" list.
| Feb 22 00:11:09 tippex smartd[6349]: Monitoring 2 ATA and 0 SCSI devices
| Feb 22 00:11:09 tippex smartd[6349]: Device: /dev/hdb, initial Temperature is 28 Celsius
| Feb 22 00:11:09 tippex smartd[6349]: Device: /dev/hdd, initial Temperature is 43 Celsius
| Feb 22 00:11:09 tippex smartd[6351]: smartd has fork()ed into background mode. New PID=6351.
| Feb 22 00:11:09 tippex smartd[6351]: file /var/run/smartd.pid written containing PID 6351

If the patch doesn't help could you try removing smartd from system startup
and see if it could be run later from the command line?

Untested patch which may help in case that set_pio_mode() raced with
the queueing of the special request and block layer doesn't call
->request_fn_proc again if we were preempted previously (if PREEMPT=y).
---
 drivers/ide/ide-io.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

Index: b/drivers/ide/ide-io.c
===================================================================
--- a/drivers/ide/ide-io.c
+++ b/drivers/ide/ide-io.c
@@ -916,7 +916,11 @@ static ide_startstop_t start_request (id
 		printk(KERN_ERR "%s: drive not ready for command\n", drive->name);
 		return startstop;
 	}
-	if (!drive->special.all) {
+
+	if (drive->special.all)
+		startstop = do_special(drive);
+
+	if (!drive->special.all && startstop == ide_stopped) {
 		ide_driver_t *drv;
 
 		/*
@@ -944,7 +948,8 @@ static ide_startstop_t start_request (id
 		drv = *(ide_driver_t **)rq->rq_disk->private_data;
 		return drv->do_request(drive, rq, block);
 	}
-	return do_special(drive);
+
+	return startstop;
 kill_rq:
 	ide_kill_rq(drive, rq);
 	return ide_stopped;

