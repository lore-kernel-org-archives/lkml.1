Return-Path: <linux-kernel-owner+w=401wt.eu-S1753576AbXFKVxO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbXFKVxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 17:53:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751730AbXFKVw6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 17:52:58 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40168 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388AbXFKVw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 17:52:58 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22-rc4-mm2: Resume from RAM on HPC nx6325 broken
Date: Mon, 11 Jun 2007 23:59:19 +0200
User-Agent: KMail/1.9.5
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Lee Trager <lt73@cs.drexel.edu>
References: <200706111649.00578.rjw@sisk.pl> <200706112203.30032.bzolnier@gmail.com>
In-Reply-To: <200706112203.30032.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200706112359.20028.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, 11 June 2007 22:03, Bartlomiej Zolnierkiewicz wrote:
> 
> Hi,
> 
> On Monday 11 June 2007, Rafael J. Wysocki wrote:
> > Hi,
> > 
> > Here's the result of the search for the second patch that breaks resuming
> > from RAM on HPC nx6325 (x86_64):
> > 
> > ide-ide-hpa-detect-from-resume.patch
> > 
> > The symptom is that after the resume there's no backlight and the screen
> > apparently doesn't work, 100% of the time, although apart from this the system
> > seems to be functional.
> 
> I find it hard to accept that IDE patch is to blame for that. ;)

But still (actually, I only don't know why it appeared to be functional :-)).

> > The box doesn't even have an IDE HDD, but the DVD is handled by the atiixp
> > driver.
> 
> If there are no IDE disks in the system there should be absolutely no
> change in the functionality.

Sorry, but the patch is buggy.  Fix appended, details in the changelog.

Greetings,
Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>

generic_ide_resume() should check if dev->driver is not NULL before applying
to_ide_driver() to it.  Fix that.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/ide/ide.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

Index: linux-2.6.22-rc4/drivers/ide/ide.c
===================================================================
--- linux-2.6.22-rc4.orig/drivers/ide/ide.c
+++ linux-2.6.22-rc4/drivers/ide/ide.c
@@ -1010,7 +1010,6 @@ static int generic_ide_resume(struct dev
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
-	ide_driver_t *drv = to_ide_driver(dev->driver);
 	struct request rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
@@ -1033,8 +1032,12 @@ static int generic_ide_resume(struct dev
 
 	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
 
-	if (err == 0 && drv && drv->resume)
-		drv->resume(drive);
+	if (err == 0 && dev->driver) {
+		ide_driver_t *drv = to_ide_driver(dev->driver);
+
+		if (drv->resume)
+			drv->resume(drive);
+	}
 
 	return err;
 }
