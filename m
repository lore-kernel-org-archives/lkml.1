Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935607Ab0CMTgM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 14:36:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:38859 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935476Ab0CMTgJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 14:36:09 -0500
X-Authority-Analysis: v=1.0 c=1 a=e8g_rxFtlFIA:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=nFsLIzLyHDBlFbnoaNUA:9 a=u-2cL92-TPdDWCARUIEA:7 a=yOKDC7BEhPy-Dj7IpFwKXPlNrJIA:4 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10
X-Cloudmark-Score: 0
X-Originating-IP: 65.28.92.235
Date: Sat, 13 Mar 2010 13:36:05 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: torvalds@linux-foundation.org, ebiederm@xmission.com
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] thermal: Fix BUG from sysfs attributes change in commit
 a2db6842873c8e5a70652f278d469128cb52db70
Message-ID: <4b9be925.V1GDM6zOAFHGuyuW%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit a2db6842873c8e5a70652f278d469128cb52db70 changed the way that
sysfs attributes are handled. With lockdep checking enabled, the
following BUG comes from thermal_zone_bind_cooling_device:

BUG: key ffff880037469060 not in .data!
------------[ cut here ]------------
WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x236/0x5d0()
Hardware name: HP Pavilion dv2700 Notebook PC
Modules linked in: processor(+) ide_pci_generic amd74xx ide_core thermal
Pid: 621, comm: modprobe Not tainted 2.6.34-rc1-wl #318
Call Trace:
 [<ffffffff81046068>] warn_slowpath_common+0x78/0xb0
 [<ffffffff810460af>] warn_slowpath_null+0xf/0x20
 [<ffffffff810765e6>] lockdep_init_map+0x236/0x5d0
 [<ffffffff811633aa>] sysfs_add_file_mode+0x6a/0xc0
 [<ffffffff811ab0f0>] ? sprintf+0x40/0x50
 [<ffffffff8116340c>] sysfs_add_file+0xc/0x10
 [<ffffffff811634e1>] sysfs_create_file+0x21/0x30
 [<ffffffff81245d14>] device_create_file+0x14/0x20
 [<ffffffff8126b814>] thermal_zone_bind_cooling_device+0x1c4/0x310
 [<ffffffffa0000f09>] acpi_thermal_cooling_device_cb+0x98/0x18f [thermal]
 [<ffffffff8126ac50>] ? thermal_cooling_device_register+0x200/0x2f0
(Rest of dump snipped.)

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing/drivers/thermal/thermal_sys.c
===================================================================
--- wireless-testing.orig/drivers/thermal/thermal_sys.c
+++ wireless-testing/drivers/thermal/thermal_sys.c
@@ -728,6 +728,7 @@ int thermal_zone_bind_cooling_device(str
 	dev->attr.attr.name = dev->attr_name;
 	dev->attr.attr.mode = 0444;
 	dev->attr.show = thermal_cooling_device_trip_point_show;
+	sysfs_bin_attr_init(&dev->attr);
 	result = device_create_file(&tz->device, &dev->attr);
 	if (result)
 		goto remove_symbol_link;
