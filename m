Return-Path: <linux-kernel-owner+w=401wt.eu-S1757577AbXFKTtg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757577AbXFKTtg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 15:49:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbXFKTt3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 15:49:29 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:33737 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754365AbXFKTt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 15:49:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-disposition:message-id:content-type:content-transfer-encoding;
        b=eKskn403qrBYfxdrMcRs9BU6bNkH5F59GT1zninHW2AhSwVa9wVsfrQfbFM341TbLA9R8i+7ixVGTOtKhWa+lxhEPxc5R/j2PvlRNF2VrSyfJfbiEea9PQ1QuaZFkVI5wiY+2yJ4viSCRJlC1vagIyWCSyz4slniwJrvfAaZvyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: 2.6.22-rc4-mm2: Resume from RAM on HPC nx6325 broken
Date: Mon, 11 Jun 2007 22:03:29 +0200
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
       Lee Trager <lt73@cs.drexel.edu>
References: <200706111649.00578.rjw@sisk.pl>
In-Reply-To: <200706111649.00578.rjw@sisk.pl>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200706112203.30032.bzolnier@gmail.com>
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Monday 11 June 2007, Rafael J. Wysocki wrote:
> Hi,
> 
> Here's the result of the search for the second patch that breaks resuming
> from RAM on HPC nx6325 (x86_64):
> 
> ide-ide-hpa-detect-from-resume.patch
> 
> The symptom is that after the resume there's no backlight and the screen
> apparently doesn't work, 100% of the time, although apart from this the system
> seems to be functional.

I find it hard to accept that IDE patch is to blame for that. ;)

> The box doesn't even have an IDE HDD, but the DVD is handled by the atiixp
> driver.

If there are no IDE disks in the system there should be absolutely no
change in the functionality.  Please also take a look at the patch (below)
- it adds support for device driver ->resume method and implements it only
for ide-disk driver.

Either bisection went wrong and this is not the "guilty" patch (could you
please check that applying just this patch to -rc4 breaks resume too?) or
something really weird is going on...

Bart

[PATCH] ide: HPA detect from resume

From: Lee Trager <lt73@cs.drexel.edu>

Currently when system which have HPA require HPA to be detected and
disabled upon resume from RAM or disk. The current IDE drivers do not do
this nor does libata (obviously it since it doesn't support HPA yet).

I have implemented this into the current IDE drivers and it has been
tested by many others since 7/15/2006 in bug number 6840:

	http://bugzilla.kernel.org/show_bug.cgi?id=6840

and it has been confirmed to work fine with no problems.

bart: added drv != NULL check to generic_ide_suspend()

From: Lee Trager <lt73@cs.drexel.edu>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

---
 drivers/ide/ide-disk.c |   12 ++++++++++++
 drivers/ide/ide.c      |    9 ++++++++-
 include/linux/ide.h    |    1 +
 3 files changed, 21 insertions(+), 1 deletion(-)

Index: b/drivers/ide/ide-disk.c
===================================================================
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -1037,6 +1037,17 @@ static void ide_disk_release(struct kref
 
 static int ide_disk_probe(ide_drive_t *drive);
 
+/*
+ * On HPA drives the capacity needs to be
+ * reinitilized on resume otherwise the disk
+ * can not be used and a hard reset is required
+ */
+static void ide_disk_resume(ide_drive_t *drive)
+{
+	if (idedisk_supports_hpa(drive->id))
+		init_idedisk_capacity(drive);
+}
+
 static void ide_device_shutdown(ide_drive_t *drive)
 {
 #ifdef	CONFIG_ALPHA
@@ -1071,6 +1082,7 @@ static ide_driver_t idedisk_driver = {
 	},
 	.probe			= ide_disk_probe,
 	.remove			= ide_disk_remove,
+	.resume			= ide_disk_resume,
 	.shutdown		= ide_device_shutdown,
 	.version		= IDEDISK_VERSION,
 	.media			= ide_disk,
Index: b/drivers/ide/ide.c
===================================================================
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -1010,9 +1010,11 @@ static int generic_ide_resume(struct dev
 {
 	ide_drive_t *drive = dev->driver_data;
 	ide_hwif_t *hwif = HWIF(drive);
+	ide_driver_t *drv = to_ide_driver(dev->driver);
 	struct request rq;
 	struct request_pm_state rqpm;
 	ide_task_t args;
+	int err;
 
 	/* Call ACPI _STM only once */
 	if (!(drive->dn % 2))
@@ -1029,7 +1031,12 @@ static int generic_ide_resume(struct dev
 	rqpm.pm_step = ide_pm_state_start_resume;
 	rqpm.pm_state = PM_EVENT_ON;
 
-	return ide_do_drive_cmd(drive, &rq, ide_head_wait);
+	err = ide_do_drive_cmd(drive, &rq, ide_head_wait);
+
+	if (err == 0 && drv && drv->resume)
+		drv->resume(drive);
+
+	return err;
 }
 
 int generic_ide_ioctl(ide_drive_t *drive, struct file *file, struct block_device *bdev,
Index: b/include/linux/ide.h
===================================================================
--- a/include/linux/ide.h
+++ b/include/linux/ide.h
@@ -1001,6 +1001,7 @@ struct ide_driver_s {
 	struct device_driver	gen_driver;
 	int		(*probe)(ide_drive_t *);
 	void		(*remove)(ide_drive_t *);
+	void		(*resume)(ide_drive_t *);
 	void		(*shutdown)(ide_drive_t *);
 #ifdef CONFIG_IDE_PROC_FS
 	ide_proc_entry_t	*proc;
