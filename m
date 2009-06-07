Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZFGRpn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZFGRpn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 13:45:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbZFGRpg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 13:45:36 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51961 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZFGRpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 13:45:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=LsKlSWjx4pNj0YxYuaYAP2i3yZIHuTD1MofYvNlnHbBfeFnNP6ADhSqP4cGUpfy5e9
         rDWBVKOEYcpOU3ScQVshWxNHz6ui72cB4Ucrjbd6KK5p991gOCjMGWWz6LYdQupR1rEG
         VHz69bQbXiLgwXVbJ+91c+hM/FI1Lc+jD2S/c=
Date: Sun, 7 Jun 2009 19:45:33 +0200
From: Borislav Petkov <petkovbb@googlemail.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: Borislav Petkov <petkovbb@googlemail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ide-tape: fix proc warning
Message-ID: <20090607174533.GA15551@liondog.tnic>
Mail-Followup-To: Borislav Petkov <petkovbb@gmail.com>,
	Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
	Borislav Petkov <petkovbb@googlemail.com>,
	linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20090607092054.GA26408@liondog.tnic> <200906071528.05185.bzolnier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <200906071528.05185.bzolnier@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sun, Jun 07, 2009 at 03:28:04PM +0200, Bartlomiej Zolnierkiewicz wrote:
> > because it tries to free its proc entry in drive_release_dev()
> > in the call chain resulting from ide_tape_put() but it chokes on
> > /proc/ide/ide[01]/hd?/name which is added during driver registration and
> > should go only at driver removal time.
> > 
> > Add/remove those proc entries everytime the device is accessed.
> 
> This looks more like broken ide-tape refcounting for chrdev interface
> than mismatch of /proc entries registration time (especially since other
> device drivers are not having the above problem)..

This sounds more like it, I was wondering why that
/proc/ide/ide[01]/hd?/name attribute was disappearing.

> Please see ide_tape_chrdev_get() -- it misses ide_device_get() call
> [present in ide_tape_get()] which can result in premature release of
> IDE device during ide_tape_put() call.

By the way, why are we using two devs for the reference counting:
drive->gendev over ide_device_get() and fall back to {tape,cd,idkp}->dev
in get_device(). Isn't one enough?

Anyways, here's the fixed version, tested with my Seagate STT8000A,
works fine.

--
From: Borislav Petkov <petkovbb@gmail.com>
Date: Sun, 7 Jun 2009 19:35:56 +0200
Subject: [PATCH] ide-tape: fix proc warning

ide_tape_chrdev_get() was missing an ide_device_get() refcount increment
which lead to the following warning:

[  278.147906] ------------[ cut here ]------------
[  278.152685] WARNING: at fs/proc/generic.c:847 remove_proc_entry+0x199/0x1b8()
[  278.160070] Hardware name: P4I45PE    1.00
[  278.160076] remove_proc_entry: removing non-empty directory 'ide0/hdb', leaking at least 'name'
[  278.160080] Modules linked in: rtc intel_agp pcspkr thermal processor thermal_sys parport_pc parport agpgart button
[  278.160100] Pid: 2312, comm: mt Not tainted 2.6.30-rc2 #3
[  278.160105] Call Trace:
[  278.160117]  [<c012141d>] warn_slowpath+0x71/0xa0
[  278.160126]  [<c035f219>] ? _spin_unlock_irqrestore+0x29/0x2c
[  278.160132]  [<c011c686>] ? try_to_wake_up+0x1b6/0x1c0
[  278.160141]  [<c011c69b>] ? default_wake_function+0xb/0xd
[  278.160149]  [<c0177ead>] ? pollwake+0x4a/0x55
[  278.160156]  [<c035f240>] ? _spin_unlock+0x24/0x26
[  278.160163]  [<c0165d38>] ? add_partial+0x44/0x49
[  278.160169]  [<c01669e8>] ? __slab_free+0xba/0x29c
[  278.160177]  [<c01a13d8>] ? sysfs_delete_inode+0x0/0x3c
[  278.160184]  [<c019ca92>] remove_proc_entry+0x199/0x1b8
[  278.160191]  [<c01a297e>] ? remove_dir+0x27/0x2e
[  278.160199]  [<c025f3ab>] ide_proc_unregister_device+0x40/0x4c
[  278.160207]  [<c02599cd>] drive_release_dev+0x14/0x47
[  278.160214]  [<c0250538>] device_release+0x35/0x5a
[  278.160221]  [<c01f8bed>] kobject_release+0x40/0x50
[  278.160226]  [<c01f8bad>] ? kobject_release+0x0/0x50
[  278.160232]  [<c01f96ac>] kref_put+0x3c/0x4a
[  278.160238]  [<c01f8b29>] kobject_put+0x37/0x3c
[  278.160243]  [<c025020c>] put_device+0xf/0x11
[  278.160249]  [<c025789f>] ide_device_put+0x2d/0x30
[  278.160255]  [<c02658da>] ide_tape_put+0x24/0x32
[  278.160261]  [<c0266e0c>] idetape_chrdev_release+0x17f/0x18e
[  278.160269]  [<c016c4f5>] __fput+0xca/0x175
[  278.160275]  [<c016c5b9>] fput+0x19/0x1b
[  278.160280]  [<c0169d19>] filp_close+0x51/0x5b
[  278.160286]  [<c0169d96>] sys_close+0x73/0xad
[  278.160293]  [<c0102a61>] syscall_call+0x7/0xb
[  278.160298] ---[ end trace f16d907ea1f89336 ]---

Instead of trivially fixing it by adding the missing call,
ide_tape_chrdev_get() and ide_tape_get() were merged into one function
since both were almost identical. The only difference was that
ide_tape_chrdev_get() was accessing the ide-tape reference through the
idetape_devs[] array of minors instead of through the gendisk.

Accomodate that by adding two additional parameters to ide_tape_get() to
annotate the call site and invoke the proper behavior.

As a result, remove ide_tape_chrdev_get().

There should be no functional change resulting from this patch.

Signed-off-by: Borislav Petkov <petkovbb@gmail.com>
---
 drivers/ide/ide-tape.c |   35 +++++++++++++----------------------
 1 files changed, 13 insertions(+), 22 deletions(-)

diff --git a/drivers/ide/ide-tape.c b/drivers/ide/ide-tape.c
index 055f52e..51ea59e 100644
--- a/drivers/ide/ide-tape.c
+++ b/drivers/ide/ide-tape.c
@@ -240,18 +240,27 @@ static struct class *idetape_sysfs_class;
 
 static void ide_tape_release(struct device *);
 
-static struct ide_tape_obj *ide_tape_get(struct gendisk *disk)
+static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
+
+static struct ide_tape_obj *ide_tape_get(struct gendisk *disk, bool cdev,
+					 unsigned int i)
 {
 	struct ide_tape_obj *tape = NULL;
 
 	mutex_lock(&idetape_ref_mutex);
-	tape = ide_drv_g(disk, ide_tape_obj);
+
+	if (cdev)
+		tape = idetape_devs[i];
+	else
+		tape = ide_drv_g(disk, ide_tape_obj);
+
 	if (tape) {
 		if (ide_device_get(tape->drive))
 			tape = NULL;
 		else
 			get_device(&tape->dev);
 	}
+
 	mutex_unlock(&idetape_ref_mutex);
 	return tape;
 }
@@ -267,24 +276,6 @@ static void ide_tape_put(struct ide_tape_obj *tape)
 }
 
 /*
- * The variables below are used for the character device interface. Additional
- * state variables are defined in our ide_drive_t structure.
- */
-static struct ide_tape_obj *idetape_devs[MAX_HWIFS * MAX_DRIVES];
-
-static struct ide_tape_obj *ide_tape_chrdev_get(unsigned int i)
-{
-	struct ide_tape_obj *tape = NULL;
-
-	mutex_lock(&idetape_ref_mutex);
-	tape = idetape_devs[i];
-	if (tape)
-		get_device(&tape->dev);
-	mutex_unlock(&idetape_ref_mutex);
-	return tape;
-}
-
-/*
  * called on each failed packet command retry to analyze the request sense. We
  * currently do not utilize this information.
  */
@@ -1495,7 +1486,7 @@ static int idetape_chrdev_open(struct inode *inode, struct file *filp)
 		return -ENXIO;
 
 	lock_kernel();
-	tape = ide_tape_chrdev_get(i);
+	tape = ide_tape_get(NULL, true, i);
 	if (!tape) {
 		unlock_kernel();
 		return -ENXIO;
@@ -1916,7 +1907,7 @@ static const struct file_operations idetape_fops = {
 
 static int idetape_open(struct block_device *bdev, fmode_t mode)
 {
-	struct ide_tape_obj *tape = ide_tape_get(bdev->bd_disk);
+	struct ide_tape_obj *tape = ide_tape_get(bdev->bd_disk, false, 0);
 
 	if (!tape)
 		return -ENXIO;
-- 
1.6.3.1


-- 
Regards/Gruss,
    Boris.
