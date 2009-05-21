Return-Path: <linux-kernel-owner+w=401wt.eu-S1753766AbZEUNXs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbZEUNXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 May 2009 09:23:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbZEUNXk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 May 2009 09:23:40 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:33247 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbZEUNXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 May 2009 09:23:39 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Thu, 21 May 2009 15:23:26 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] ieee1394: sbp2: change default /dev/disk/by-id naming policy
To: linux1394-devel@lists.sourceforge.net
cc: linux-hotplug@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <tkrat.b5a0ee969f9ff187@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the default value of the module parameter sbp2.long_ieee1394_id
from N to Y.  This aligns user-visible behaviour of sbp2 to that of the
newer firewire-sbp2 driver, notably how /dev/disk/by-id symlinks look.

Background:

With long_ieee1394_id=Y, the sbp2 driver will handle the sysfs attribute
/sys/bus/scsi/devices/.../ieee1394_id just like the newer firewire-sbp2
driver does:  It will create a slightly longer, fixed length ID with
values which entirely depend on the SBP-2 target only.  The sysfs
attribute is used by udev to maintain /dev/disk/by-id symlinks.

    Example symlinks with long_ieee1394_id=Y (new default):
    /dev/disk/by-id/ieee1394-0001041010004beb:00042c:0000
    /dev/disk/by-id/ieee1394-0001041010004beb:00042c:0000-part1

With long_ieee1394_id=N --- which was the default until now --- the
sysfs attribute will have the same form as in older kernels which had
the drawback that one component in it was not entirely target-dependent
but also specific to the implementation of ieee1394 core's nodemgr.
Hence only the long_ieee1394_id=Y format is available in the newer
alternative firewire-sbp2 driver.

    Example symlinks with long_ieee1394_id=N (now a legacy option):
    /dev/disk/by-id/ieee1394-0001041010004beb:0:0
    /dev/disk/by-id/ieee1394-0001041010004beb:0:0-part1

The second part of the ID (in the example: 0 with N and 00042c with Y)
may not be persistent with N in case of complex SBP-2 targets which run
other protocols besides SBP-2.  Therefore --- but even more so for best
support of parallel installation of sbp2 and firewire-sbp2 as a gradual
migration path to the new firewire driver stack --- switch the default
to Y.

Necessary changes in userland:

People who use /dev/disk/by-id/ieee1394* entries in their fstab have to
replace them by the new names.  Alternatively, if they do not plan to
migrate to firewire-sbp2 anytime soon, they can add

    options sbp2 long_ieee1394_id=N

to /etc/modprobe.conf or /etc/modprobe.d/whatever and keep using the old
symlink names.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/ieee1394/sbp2.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

Index: linux/drivers/ieee1394/sbp2.c
===================================================================
--- linux.orig/drivers/ieee1394/sbp2.c
+++ linux/drivers/ieee1394/sbp2.c
@@ -211,26 +211,27 @@ MODULE_PARM_DESC(workarounds, "Work arou
 
 /*
  * This influences the format of the sysfs attribute
  * /sys/bus/scsi/devices/.../ieee1394_id.
  *
- * The default format is like in older kernels:  %016Lx:%d:%d
+ * The legacy format is like in older kernel versions:  %016Lx:%d:%d
  * It contains the target's EUI-64, a number given to the logical unit by
  * the ieee1394 driver's nodemgr (starting at 0), and the LUN.
  *
  * The long format is:  %016Lx:%06x:%04x
  * It contains the target's EUI-64, the unit directory's directory_ID as per
  * IEEE 1212 clause 7.7.19, and the LUN.  This format comes closest to the
  * format of SBP(-3) target port and logical unit identifier as per SAM (SCSI
  * Architecture Model) rev.2 to 4 annex A.  Therefore and because it is
  * independent of the implementation of the ieee1394 nodemgr, the longer format
- * is recommended for future use.
+ * is recommended and the default since Linux 2.6.31.  It is also the only
+ * format implemented in the newer firewire-sbp2 driver.
  */
-static int sbp2_long_sysfs_ieee1394_id;
+static int sbp2_long_sysfs_ieee1394_id = 1;
 module_param_named(long_ieee1394_id, sbp2_long_sysfs_ieee1394_id, bool, 0644);
-MODULE_PARM_DESC(long_ieee1394_id, "8+3+2 bytes format of ieee1394_id in sysfs "
-		 "(default = backwards-compatible = N, SAM-conforming = Y)");
+MODULE_PARM_DESC(long_ieee1394_id, "format of ieee1394_id in sysfs (default = "
+		 "SAM-conforming 8+3+2 bytes = Y, legacy 8+?+? = N)");
 
 
 #define SBP2_INFO(fmt, args...)	HPSB_INFO("sbp2: "fmt, ## args)
 #define SBP2_ERR(fmt, args...)	HPSB_ERR("sbp2: "fmt, ## args)
 

-- 
Stefan Richter
-=====-==--= -=-= =-=-=
http://arcgraph.de/sr/

