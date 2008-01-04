Return-Path: <linux-kernel-owner+w=401wt.eu-S1754243AbYADHZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbYADHZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2008 02:25:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752814AbYADHY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jan 2008 02:24:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.157]:34241 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752769AbYADHY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2008 02:24:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type:content-disposition:user-agent;
        b=oZ88A7xr1cYOBHpyhlfgzORHaXAiSHlWkUZGktEHwP2BjLApJC7Q1rU+CbUeR43l9reZCc75GAahQ/rHSlUKDfLwwnNpeByOZwx9htfdQ/KKlqeW/twCMabF9uwzyl9htL2gQ5LDLAPqjTNqWEeYWAwYauYH8+4dH8S+0ug7fvE=
Date: Fri, 4 Jan 2008 15:28:26 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: jens.axboe@oracle.com
Cc: amir@boom.org.il, linux-kernel@vger.kernel.org
Subject: [PATCH][BUG 3879] add some check before scsi_cmd_ioctl
Message-ID: <20080104072826.GA3021@darkstar.te-china.tietoenator.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The behaviour of eject/lock_door ioctl is not consistent, so add some check before scsi_cmd_ioctl.

Signed-off-by: Dave Young <hidave.darkstar@gmail.com> 

---
drivers/cdrom/cdrom.c |   42 ++++++++++++++++++++++++++++++++++++------
1 file changed, 36 insertions(+), 6 deletions(-)

diff -upr linux/drivers/cdrom/cdrom.c linux.new/drivers/cdrom/cdrom.c
--- linux/drivers/cdrom/cdrom.c	2008-01-04 15:06:50.000000000 +0800
+++ linux.new/drivers/cdrom/cdrom.c	2008-01-04 15:05:06.000000000 +0800
@@ -2236,6 +2236,15 @@ static int cdrom_ioctl_multisession(stru
 	return 0;
 }
 
+static int cdrom_eject_check(struct cdrom_device_info *cdi)
+{
+	if (!CDROM_CAN(CDC_OPEN_TRAY))
+		return -ENOSYS;
+	if (cdi->use_count != 1 || keeplocked)
+		return -EBUSY;
+	return 0;
+}
+
 static int cdrom_ioctl_eject(struct cdrom_device_info *cdi)
 {
 	cdinfo(CD_DO_IOCTL, "entering CDROMEJECT\n");
@@ -2392,22 +2401,31 @@ static int cdrom_ioctl_reset(struct cdro
 	return cdi->ops->reset(cdi);
 }
 
-static int cdrom_ioctl_lock_door(struct cdrom_device_info *cdi,
+static int cdrom_lock_door_check(struct cdrom_device_info *cdi,
 		unsigned long arg)
 {
-	cdinfo(CD_DO_IOCTL, "%socking door.\n", arg ? "L" : "Unl");
-
 	if (!CDROM_CAN(CDC_LOCK))
 		return -EDRIVE_CANT_DO_THIS;
-
-	keeplocked = arg ? 1 : 0;
-
 	/*
 	 * Don't unlock the door on multiple opens by default, but allow
 	 * root to do so.
 	 */
 	if (cdi->use_count != 1 && !arg && !capable(CAP_SYS_ADMIN))
 		return -EBUSY;
+
+	return 0;
+}
+
+
+static int cdrom_ioctl_lock_door(struct cdrom_device_info *cdi,
+		unsigned long arg)
+{
+	cdinfo(CD_DO_IOCTL, "%socking door.\n", arg ? "L" : "Unl");
+
+	/*
+	 * cdrom_lock_door_check is done in cdrom_ioctl.
+	 */
+	keeplocked = arg ? 1 : 0;
 	return cdi->ops->lock_door(cdi, arg);
 }
 
@@ -2701,6 +2719,18 @@ int cdrom_ioctl(struct file * file, stru
 	int ret;
 	struct gendisk *disk = ip->i_bdev->bd_disk;
 
+	if (cmd == CDROMEJECT) {
+		ret = cdrom_eject_check(cdi);
+		if (ret)
+			return ret;
+	}
+
+	if (cmd == CDROM_LOCKDOOR) {
+		ret = cdrom_lock_door_check(cdi, arg);
+		if (ret)
+			return ret;
+	}
+
 	/*
 	 * Try the generic SCSI command ioctl's first.
 	 */
