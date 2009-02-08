Return-Path: <linux-kernel-owner+w=401wt.eu-S1755189AbZBHWRa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189AbZBHWRa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 17:17:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753671AbZBHWRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 17:17:21 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:52464 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648AbZBHWRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 17:17:20 -0500
X-Greylist: delayed 434 seconds by postgrey-1.27 at vger.kernel.org; Sun, 08 Feb 2009 17:17:20 EST
Date: Sun, 8 Feb 2009 16:09:56 -0600
From: David Fries <david@fries.net>
To: linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] ide.c 'clear' fix, ide=nodma documentation
Message-ID: <20090208220956.GA3278@spacedout.fries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Sun, 08 Feb 2009 16:09:59 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Fries <david@fries.net>

Documentation/kernel-parameters.txt
ide=nodma is no longer valid

drivers/ide/Kconfig
the module is ide-core.ko not ide

drivers/ide/ide.c
It took me a while to figure out what the arguments %d.%d:%d to nodma
module parameter ment, so I added a comment to each.
Added a comment to each of the sscanf lines to
There is a bug, if j is 0 it would previously clear all the other bits
except the current device, changed in three different places.
mask &= (1 << i)     should be     mask &= ~(1 << i)


Signed-off-by: David Fries <david@fries.net>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>

---
I pretty much wasted my Saturday on this.  This is an older VIA
vt82c586b (rev 41) IDE UDMA33 and I've seen disk corruption in the
past with dma enabled, I can't use hdparm because those settings don't
persist across hibernate and restore (that should be another bug
report).  ide=nodma was working on the last 2.6.24 kernel, and
kernel-parameters.txt still lists it.  I had to go through the change
logs to figure out what happened to ide=nodma, then ide.c to figure
out what replaced it and what %d.%d:%d means (so I documented it so
other would have an easier time), then figure out how to set a module
parameter on the kernel command line when Kconfig said the module name
was ide and ide.nodma=0.0 didn't work, it was ide-core.nodma=0.0.

Now instead of,
ide=nodma
I have the following.
ide-core.nodma=0.0 ide-core.nodma=0.1 ide-core.nodma=1.0 ide-core.nodma=1.1
Where else is hdc written 1.0 ?  Why doesn't it take ide-core.nodma=hdc ?

---
 Documentation/kernel-parameters.txt |    6 ++++--
 drivers/ide/Kconfig                 |    2 +-
 drivers/ide/ide.c                   |   11 ++++++++---
 3 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index d8362cf..1512f6d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -868,8 +868,10 @@ and is between 256 and 4096 characters. It is defined in the file
 	icn=		[HW,ISDN]
 			Format: <io>[,<membase>[,<icn_id>[,<icn_id2>]]]
 
-	ide=		[HW] (E)IDE subsystem
-			Format: ide=nodma or ide=doubler
+	ide-core.nodma=	[HW] (E)IDE subsystem
+			Format: =0.0 to prevent dma on hda, =0.1 hdb =1.0 hdc
+			.vlb_clock .pci_clock .noflush .noprobe .nowerr .cdrom
+			.chs .ignore_cable are additional options
 			See Documentation/ide/ide.txt.
 
 	idebus=		[HW] (E)IDE subsystem - VLB/PCI bus speed
diff --git a/drivers/ide/Kconfig b/drivers/ide/Kconfig
index 3dad229..e072903 100644
--- a/drivers/ide/Kconfig
+++ b/drivers/ide/Kconfig
@@ -46,7 +46,7 @@ menuconfig IDE
 	  SMART parameters from disk drives.
 
 	  To compile this driver as a module, choose M here: the
-	  module will be called ide.
+	  module will be called ide-core.ko.
 
 	  For further information, please read <file:Documentation/ide/ide.txt>.
 
diff --git a/drivers/ide/ide.c b/drivers/ide/ide.c
index 258805d..7d04e22 100644
--- a/drivers/ide/ide.c
+++ b/drivers/ide/ide.c
@@ -337,6 +337,7 @@ static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
 	int a, b, i, j = 1;
 	unsigned int *dev_param_mask = (unsigned int *)kp->arg;
 
+	/* controller . disk (0 or 1) [ : 1 (set) | 0 (clear) ] */
 	if (sscanf(s, "%d.%d:%d", &a, &b, &j) != 3 &&
 	    sscanf(s, "%d.%d", &a, &b) != 2)
 		return -EINVAL;
@@ -349,7 +350,7 @@ static int ide_set_dev_param_mask(const char *s, struct kernel_param *kp)
 	if (j)
 		*dev_param_mask |= (1 << i);
 	else
-		*dev_param_mask &= (1 << i);
+		*dev_param_mask &= ~(1 << i);
 
 	return 0;
 }
@@ -392,6 +393,8 @@ static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
 {
 	int a, b, c = 0, h = 0, s = 0, i, j = 1;
 
+	/* controller . disk (0 or 1) : Cylinders , Heads , Sectors */
+	/* controller . disk (0 or 1) : 1 (use CHS) | 0 (ignore CHS) */
 	if (sscanf(str, "%d.%d:%d,%d,%d", &a, &b, &c, &h, &s) != 5 &&
 	    sscanf(str, "%d.%d:%d", &a, &b, &j) != 3)
 		return -EINVAL;
@@ -407,7 +410,7 @@ static int ide_set_disk_chs(const char *str, struct kernel_param *kp)
 	if (j)
 		ide_disks |= (1 << i);
 	else
-		ide_disks &= (1 << i);
+		ide_disks &= ~(1 << i);
 
 	ide_disks_chs[i].cyl  = c;
 	ide_disks_chs[i].head = h;
@@ -469,6 +472,8 @@ static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
 {
 	int i, j = 1;
 
+	/* controller (ignore) */
+	/* controller : 1 (ignore) | 0 (use) */
 	if (sscanf(s, "%d:%d", &i, &j) != 2 && sscanf(s, "%d", &i) != 1)
 		return -EINVAL;
 
@@ -478,7 +483,7 @@ static int ide_set_ignore_cable(const char *s, struct kernel_param *kp)
 	if (j)
 		ide_ignore_cable |= (1 << i);
 	else
-		ide_ignore_cable &= (1 << i);
+		ide_ignore_cable &= ~(1 << i);
 
 	return 0;
 }
-- 
1.5.6.5

