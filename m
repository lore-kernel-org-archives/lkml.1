Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbZESPQR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbZESPQR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 11:16:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753237AbZESPQE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 11:16:04 -0400
Received: from fg-out-1718.google.com ([72.14.220.152]:25773 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753383AbZESPQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 11:16:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-disposition:message-id:content-type
         :content-transfer-encoding;
        b=tR99usE0I2gGTQnVA4yiYv0+IzaK+cKyBrnDAQEPhf+S1WTTSB8Pu7TuFsXWjYeE47
         Zz69XCdRufwXf4GlEWl8NUWmDtAFPC3Xlrvul0KBPs3XPFjtvFrmOacF9mzqCxK7kvtE
         ctfpE3AEjFHTDRoT+MjDtQW/s/TlttANyzMnc=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Subject: Re: PATA DMA problem leading to kernel panic on reading movie DVDs
Date: Tue, 19 May 2009 17:19:35 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.30-rc6-next-20090518-05332-g0707b5a; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
References: <20090517091224.GA8280@wanza.invalid> <200905172135.10136.bzolnier@gmail.com> <20090518191207.GA7531@wanza.invalid>
In-Reply-To: <20090518191207.GA7531@wanza.invalid>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200905191719.35543.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 May 2009 21:12:07 Martin Lottermoser wrote:
> Hi,
> 
> On Sun, May 17, 2009 at 09:35:09PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > Martin, this is one of ATAPI drives which support UDMA66 but have broken
> > cable detection.  Since 2.6.26 we have a special quirk for it ide (commit
> > 3ced5c49bd2d1f2c7f769e3a54385883de63a652) and subsequent one in libata
> > (commit e9f3340673c1da32041f2a282b166c72cd78632e).
> > 
> > In your system's case the cable detection doesn't seem to work properly
> > which in turn results in all kind of later problems.
> > 
> > It could be that the quirk itself needs to be revised (I wonder if it was
> > originally tested with 40-wires cable) or maybe we need some other cable
> > detection fix...
> > 
> > Please:
> > 
> > * send 'hdparm --Istdout /dev/hdc' output
> > 
> > * try 2.6.30-rc6 (maybe 2.6.29.3 oops has been fixed already and we just
> >   need to backport it)
> > 
> > also connecting the drive using 80-wires cable and getting another hdparm
> > output (+ seeing if it helps the other problems) would be very useful.
> 
> I've done that now as well. Test runs with Debian's 2.6.26 and with 2.6.30-rc6
> show no problems: no disabling of DMA, no kernel panic.
> 
> The hdparm output ("hdparm --Istdout") is the same for a 40-wire cable and an
> 80-wire cable (checked under 2.6.26).

Thanks, this verifies that this drive just lacks proper cable detection.

[ BTW I guess that UDMA66 was added later, after the hardware design was
  ready but it is official.  Please see product spec for "[E-IDE] SH-S202N"
  at http://www.samsungodd.com/:

        "Data transfer mode: ... Ultra DMA Mode 4 : 66.6MB/sec" ]

> This indicates that your hypothesis above that it's a cable detection problem
> is correct.
> 
> Just out of curiosity: is this a bug on the drive's side or in the kernel?

Both. :)  However the root cause is a "problematic" device not the kernel.

> Or in other words: if the output of "hdparm -I" shows the drive as attached
> to be able to support UDMA4, is this a statement passed through unmodified
> from the drive or is this a deduction made by the kernel? I ask because

It comes from the drive.

> under 2.6.22.9 and 2.6.23.14 I got a message that "host side 80-wire cable
> detection failed".

Your host controller correctly detected 40-wire cable and complained about
it since drive supports UDMA66.  In later kernels we added workaround for it
and trusted the drive side cable detection only...

> Should anyone find a fix to correct/circumvent this problem in the kernel,
> I'ld be willing to test it on my system; just send a patch file or tell me
> where to pick it up.

Here is the patch for 2.6.30-rc6 to fix operation with 40-wire cable, please
test it (we have also oops in the error-recovery issue to fix but I'll try to
reproduce it locally some time later and ping you when I'm done / need help).

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices

Since 2.6.26 we support UDMA66 on ATAPI devices requiring IVB quirk:

  commit 8588a2b732928b343233af9b1855705b8286bed4
  ("ide: add SH-S202J to ivb_list[]")

We also later added support for more such devices in:

  commit e97564f362a93f8c248246c19828895950341252
  ("ide: More TSST drives with broken cable detection")

and in:

  commit 3ced5c49bd2d1f2c7f769e3a54385883de63a652
  ("ide: add TSSTcorp CDDVDW SH-S202H to ivb_list[]")

It turns out that such devices lack cable detection altogether
(which in turn results in incorrect detection of 40-wire cables
by our current cable detection strategy) so always handle them
by trusting host-side cable detection only.

Reported-by: Martin Lottermoser <Martin.Lottermoser@t-online.de>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/ide-iops.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

Index: b/drivers/ide/ide-iops.c
===================================================================
--- a/drivers/ide/ide-iops.c
+++ b/drivers/ide/ide-iops.c
@@ -206,8 +206,6 @@ EXPORT_SYMBOL_GPL(ide_in_drive_list);
 
 /*
  * Early UDMA66 devices don't set bit14 to 1, only bit13 is valid.
- * We list them here and depend on the device side cable detection for them.
- *
  * Some optical devices with the buggy firmwares have the same problem.
  */
 static const struct drive_list_entry ivb_list[] = {
@@ -251,10 +249,25 @@ u8 eighty_ninty_three(ide_drive_t *drive
 	 * - force bit13 (80c cable present) check also for !ivb devices
 	 *   (unless the slave device is pre-ATA3)
 	 */
-	if ((id[ATA_ID_HW_CONFIG] & 0x4000) ||
-	    (ivb && (id[ATA_ID_HW_CONFIG] & 0x2000)))
+	if (id[ATA_ID_HW_CONFIG] & 0x4000)
 		return 1;
 
+	if (ivb) {
+		const char *model = (char *)&id[ATA_ID_PROD];
+
+		if (strcmp("TSSTcorp CDDVDW SH-S202", model) == 0) {
+			/*
+			 * These ATAPI devices always report 80c cable
+			 * so we have to depend on the host in this case.
+			 */
+			if (hwif->cbl == ATA_CBL_PATA80)
+				return 1;
+		} else {
+			/* Depend on the device side cable detection. */
+			if (id[ATA_ID_HW_CONFIG] & 0x2000)
+				return 1;
+		}
+	}
 no_80w:
 	if (drive->dev_flags & IDE_DFLAG_UDMA33_WARNED)
 		return 0;
