Return-Path: <linux-kernel-owner+w=401wt.eu-S1756589AbZHFTmU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756589AbZHFTmU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 15:42:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZHFTmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 15:42:19 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:33027 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756562AbZHFTmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 15:42:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-disposition
         :message-id:content-type:content-transfer-encoding;
        b=g2Bx7TyU/j5ze/Hx8O5Jux9AnO1CI7JSaOmjTvPwNd53yVPjhrvUA27acEtH0OqXZp
         FZqeh0kAGJxMmPY8rE+dKjPyEoqE/y+I9N22PjRdJ0wk8j+T1naZhMMlYXnmPISjCIV/
         u9DXe1vSb4QmWXyG+NJZtbyNfKoeI1t2wtIyo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Len Brown <len.brown@intel.com>
Subject: [PATCH] acpi: fix acpi_device_{install,remove}_notify_handler() for _HID-less devices
Date: Thu, 6 Aug 2009 21:41:52 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.31-rc5-next-20090806; KDE/4.2.4; i686; ; )
Cc: Lin Ming <ming.m.lin@intel.com>, Bob Moore <robert.moore@intel.com>,
       linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200908062141.52501.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] acpi: fix acpi_device_{install,remove}_notify_handler() for _HID-less devices

The buffer pointer returned by acpi_device_hid() should be considered
as valid IFF device->flags.hardware_id flag is set (== device supports
_HID method).

This is not a problem currently (cause we use static buffers) but after
commit ed444824932d2a563858d82ec1ea29b0aa775e91 ("ACPICA: Major update
for acpi_get_object_info external interface") ->pnp.hardware_id will
be NULL for ACPI video devices which don't support _HID method (i.e.
the one in Asus Eee 901 w/ BIOSes 1202 and the latest 2103) resulting
in an OOPS and non-working Xorg (as observed with Ubuntu 9.10 UNR).

ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
BUG: unable to handle kernel NULL pointer dereference at (null)
IP: [<c0302101>] strcmp+0x11/0x30
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/LNXSYSTM:00/modalias
Modules linked in: video(+) output eeepc_laptop(+)

Pid: 249, comm: modprobe Not tainted (2.6.31-rc5-next-20090806-eee #49) 901
EIP: 0060:[<c0302101>] EFLAGS: 00010296 CPU: 0
EIP is at strcmp+0x11/0x30
EAX: 00000000 EBX: f70ea000 ECX: 00000082 EDX: c063d4a5
ESI: 00000000 EDI: c063d4a5 EBP: f6a1be14 ESP: f6a1be0c
 DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
Process modprobe (pid: 249, ti=f6a1a000 task=f6a15300 task.ti=f6a1a000)
Stack:
 00000000 00000000 f6a1be30 c033073e f70ea1e4 f8051550 ffffffed f70ea1e4
<0> f8051618 f6a1be58 c0388ba9 f6a1be50 c03305bf f804fc2c 00000286 f6a1be58
<0> f70ea1e4 f8051618 f70ea218 f6a1be6c c0388d31 00000000 f6a1be78 f8051618
Call Trace:
 [<c033073e>] ? acpi_device_probe+0x9c/0x11e
 [<c0388ba9>] ? driver_probe_device+0x69/0x170
 [<c03305bf>] ? acpi_match_device_ids+0x52/0x76
 [<c0388d31>] ? __driver_attach+0x81/0x90
 [<c038844b>] ? bus_for_each_dev+0x5b/0x80
 [<c03305fd>] ? acpi_device_remove+0x0/0xa5
 [<c0388a59>] ? driver_attach+0x19/0x20
 [<c0388cb0>] ? __driver_attach+0x0/0x90
 [<c0387def>] ? bus_add_driver+0x1bf/0x280
 [<c03305fd>] ? acpi_device_remove+0x0/0xa5
 [<c0388fb5>] ? driver_register+0x75/0x160
 [<c021e5d3>] ? proc_mkdir_mode+0x33/0x50
 [<c0331c1a>] ? acpi_bus_register_driver+0x3a/0x3c
 [<f804f1ad>] ? acpi_video_register+0x36/0x61 [video]
 [<f805407a>] ? acpi_video_init+0x69/0x6b [video]
 [<f8054011>] ? acpi_video_init+0x0/0x6b [video]
 [<c010112b>] ? do_one_initcall+0x2b/0x160
 [<c019283f>] ? tracepoint_module_notify+0x2f/0x40
 [<c05216bd>] ? notifier_call_chain+0x2d/0x70
 [<c015bf4d>] ? __blocking_notifier_call_chain+0x4d/0x60
 [<c016e772>] ? sys_init_module+0xb2/0x1f0
 [<c010303c>] ? sysenter_do_call+0x12/0x28
Code: 8b 45 f0 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 08 89 34 24 89 c6 89 7c 24 04 89 d7 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 8b 34 24 8b 7c 
EIP: [<c0302101>] strcmp+0x11/0x30 SS:ESP 0068:f6a1be0c
CR2: 0000000000000000
---[ end trace 618b66b50ec5e42a ]---

Cc: Bob Moore <robert.moore@intel.com>
Cc: Lin Ming <ming.m.lin@intel.com>
Cc: Len Brown <len.brown@intel.com>
Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
This fixes a month long -next regression.

Len, could this (or an equivalent fix) go into 2.6.31 so we will
never see the regression upstream and -next will fix itself..?

 drivers/acpi/scan.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

Index: b/drivers/acpi/scan.c
===================================================================
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -375,13 +375,17 @@ static int acpi_device_install_notify_ha
 	acpi_status status;
 	char *hid;
 
-	hid = acpi_device_hid(device);
-	if (!strcmp(hid, ACPI_BUTTON_HID_POWERF))
+	if (device->flags.hardware_id)
+		hid = acpi_device_hid(device);
+	else
+		hid = NULL;
+
+	if (hid && !strcmp(hid, ACPI_BUTTON_HID_POWERF))
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
 						     acpi_device_notify_fixed,
 						     device);
-	else if (!strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
+	else if (hid && !strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
 		status =
 		    acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
 						     acpi_device_notify_fixed,
@@ -399,10 +403,17 @@ static int acpi_device_install_notify_ha
 
 static void acpi_device_remove_notify_handler(struct acpi_device *device)
 {
-	if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_POWERF))
+	char *hid;
+
+	if (device->flags.hardware_id)
+		hid = acpi_device_hid(device);
+	else
+		hid = NULL;
+
+	if (hid && !strcmp(hid, ACPI_BUTTON_HID_POWERF))
 		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
 						acpi_device_notify_fixed);
-	else if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_SLEEPF))
+	else if (hid && !strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
 		acpi_remove_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
 						acpi_device_notify_fixed);
 	else
