Return-Path: <linux-kernel-owner+w=401wt.eu-S1756388AbZHGAzm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388AbZHGAzm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 20:55:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754527AbZHGAzm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 20:55:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:57214 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752686AbZHGAzl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 20:55:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,337,1246863600"; 
   d="scan'208";a="539282205"
Subject: Re: [PATCH] acpi: fix
 acpi_device_{install,remove}_notify_handler() for _HID-less devices
From: Lin Ming <ming.m.lin@intel.com>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: "Brown, Len" <len.brown@intel.com>,
       "Moore, Robert" <robert.moore@intel.com>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <200908062141.52501.bzolnier@gmail.com>
References: <200908062141.52501.bzolnier@gmail.com>
Content-Type: text/plain
Date: Fri, 07 Aug 2009 08:53:53 +0800
Message-Id: <1249606433.7301.23.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 (2.24.1-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 03:41 +0800, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] acpi: fix acpi_device_{install,remove}_notify_handler() for _HID-less devices

Hi,

The patch in -mm tree titled
"acpi-fix-null-bug-for-hid-uid-string-2.patch"
has fixed this regression.
Would you please give it a try?

The patch attached below.

Subject: acpi: fix NULL bug for HID/UID string
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>

acpi_device->pnp.hardware_id and unique_id are now allocated pointers,
replacing the previous arrays.  acpi_device_install_notify_handler()
oopsed on the NULL hid when probing the video device, and perhaps other
uses are vulnerable too.  So initialize those pointers to empty strings
when there is no hid or uid.  Also, free hardware_id and unique_id when
when acpi_device is going to be freed.

Signed-off-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/acpi/scan.c |   20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff -puN drivers/acpi/scan.c~acpi-fix-null-bug-for-hid-uid-string-2 drivers/acpi/scan.c
--- a/drivers/acpi/scan.c~acpi-fix-null-bug-for-hid-uid-string-2
+++ a/drivers/acpi/scan.c
@@ -309,6 +309,10 @@ static void acpi_device_release(struct d
 	struct acpi_device *acpi_dev = to_acpi_device(dev);
 
 	kfree(acpi_dev->pnp.cid_list);
+	if (acpi_dev->flags.hardware_id)
+		kfree(acpi_dev->pnp.hardware_id);
+	if (acpi_dev->flags.unique_id)
+		kfree(acpi_dev->pnp.unique_id);
 	kfree(acpi_dev);
 }
 
@@ -1132,8 +1136,9 @@ static void acpi_device_set_id(struct ac
 			strcpy(device->pnp.hardware_id, hid);
 			device->flags.hardware_id = 1;
 		}
-	} else
-		device->pnp.hardware_id = NULL;
+	}
+	if (!device->flags.hardware_id)
+		device->pnp.hardware_id = "";
 
 	if (uid) {
 		device->pnp.unique_id = ACPI_ALLOCATE_ZEROED(strlen (uid) + 1);
@@ -1141,8 +1146,9 @@ static void acpi_device_set_id(struct ac
 			strcpy(device->pnp.unique_id, uid);
 			device->flags.unique_id = 1;
 		}
-	} else
-		device->pnp.unique_id = NULL;
+	}
+	if (!device->flags.unique_id)
+		device->pnp.unique_id = "";
 
 	if (cid_list || cid_add) {
 		struct acpica_device_id_list *list;
@@ -1357,10 +1363,8 @@ acpi_add_single_object(struct acpi_devic
 end:
 	if (!result)
 		*child = device;
-	else {
-		kfree(device->pnp.cid_list);
-		kfree(device);
-	}
+	else
+		acpi_device_release(&device->dev);
 
 	return result;
 }


---
Thanks.
Lin Ming

> 
> The buffer pointer returned by acpi_device_hid() should be considered
> as valid IFF device->flags.hardware_id flag is set (== device supports
> _HID method).
> 
> This is not a problem currently (cause we use static buffers) but after
> commit ed444824932d2a563858d82ec1ea29b0aa775e91 ("ACPICA: Major update
> for acpi_get_object_info external interface") ->pnp.hardware_id will
> be NULL for ACPI video devices which don't support _HID method (i.e.
> the one in Asus Eee 901 w/ BIOSes 1202 and the latest 2103) resulting
> in an OOPS and non-working Xorg (as observed with Ubuntu 9.10 UNR).
> 
> ACPI: Video Device [VGA] (multi-head: yes  rom: no  post: no)
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<c0302101>] strcmp+0x11/0x30
> *pde = 00000000 
> Oops: 0000 [#1] SMP 
> last sysfs file: /sys/devices/LNXSYSTM:00/modalias
> Modules linked in: video(+) output eeepc_laptop(+)
> 
> Pid: 249, comm: modprobe Not tainted (2.6.31-rc5-next-20090806-eee #49) 901
> EIP: 0060:[<c0302101>] EFLAGS: 00010296 CPU: 0
> EIP is at strcmp+0x11/0x30
> EAX: 00000000 EBX: f70ea000 ECX: 00000082 EDX: c063d4a5
> ESI: 00000000 EDI: c063d4a5 EBP: f6a1be14 ESP: f6a1be0c
>  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> Process modprobe (pid: 249, ti=f6a1a000 task=f6a15300 task.ti=f6a1a000)
> Stack:
>  00000000 00000000 f6a1be30 c033073e f70ea1e4 f8051550 ffffffed f70ea1e4
> <0> f8051618 f6a1be58 c0388ba9 f6a1be50 c03305bf f804fc2c 00000286 f6a1be58
> <0> f70ea1e4 f8051618 f70ea218 f6a1be6c c0388d31 00000000 f6a1be78 f8051618
> Call Trace:
>  [<c033073e>] ? acpi_device_probe+0x9c/0x11e
>  [<c0388ba9>] ? driver_probe_device+0x69/0x170
>  [<c03305bf>] ? acpi_match_device_ids+0x52/0x76
>  [<c0388d31>] ? __driver_attach+0x81/0x90
>  [<c038844b>] ? bus_for_each_dev+0x5b/0x80
>  [<c03305fd>] ? acpi_device_remove+0x0/0xa5
>  [<c0388a59>] ? driver_attach+0x19/0x20
>  [<c0388cb0>] ? __driver_attach+0x0/0x90
>  [<c0387def>] ? bus_add_driver+0x1bf/0x280
>  [<c03305fd>] ? acpi_device_remove+0x0/0xa5
>  [<c0388fb5>] ? driver_register+0x75/0x160
>  [<c021e5d3>] ? proc_mkdir_mode+0x33/0x50
>  [<c0331c1a>] ? acpi_bus_register_driver+0x3a/0x3c
>  [<f804f1ad>] ? acpi_video_register+0x36/0x61 [video]
>  [<f805407a>] ? acpi_video_init+0x69/0x6b [video]
>  [<f8054011>] ? acpi_video_init+0x0/0x6b [video]
>  [<c010112b>] ? do_one_initcall+0x2b/0x160
>  [<c019283f>] ? tracepoint_module_notify+0x2f/0x40
>  [<c05216bd>] ? notifier_call_chain+0x2d/0x70
>  [<c015bf4d>] ? __blocking_notifier_call_chain+0x4d/0x60
>  [<c016e772>] ? sys_init_module+0xb2/0x1f0
>  [<c010303c>] ? sysenter_do_call+0x12/0x28
> Code: 8b 45 f0 8b 5d f4 8b 75 f8 8b 7d fc 89 ec 5d c3 8d 76 00 8d bc 27 00 00 00 00 55 89 e5 83 ec 08 89 34 24 89 c6 89 7c 24 04 89 d7 <ac> ae 75 08 84 c0 75 f8 31 c0 eb 04 19 c0 0c 01 8b 34 24 8b 7c 
> EIP: [<c0302101>] strcmp+0x11/0x30 SS:ESP 0068:f6a1be0c
> CR2: 0000000000000000
> ---[ end trace 618b66b50ec5e42a ]---
> 
> Cc: Bob Moore <robert.moore@intel.com>
> Cc: Lin Ming <ming.m.lin@intel.com>
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> This fixes a month long -next regression.
> 
> Len, could this (or an equivalent fix) go into 2.6.31 so we will
> never see the regression upstream and -next will fix itself..?
> 
>  drivers/acpi/scan.c |   21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> Index: b/drivers/acpi/scan.c
> ===================================================================
> --- a/drivers/acpi/scan.c
> +++ b/drivers/acpi/scan.c
> @@ -375,13 +375,17 @@ static int acpi_device_install_notify_ha
>  	acpi_status status;
>  	char *hid;
>  
> -	hid = acpi_device_hid(device);
> -	if (!strcmp(hid, ACPI_BUTTON_HID_POWERF))
> +	if (device->flags.hardware_id)
> +		hid = acpi_device_hid(device);
> +	else
> +		hid = NULL;
> +
> +	if (hid && !strcmp(hid, ACPI_BUTTON_HID_POWERF))
>  		status =
>  		    acpi_install_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
>  						     acpi_device_notify_fixed,
>  						     device);
> -	else if (!strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
> +	else if (hid && !strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
>  		status =
>  		    acpi_install_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
>  						     acpi_device_notify_fixed,
> @@ -399,10 +403,17 @@ static int acpi_device_install_notify_ha
>  
>  static void acpi_device_remove_notify_handler(struct acpi_device *device)
>  {
> -	if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_POWERF))
> +	char *hid;
> +
> +	if (device->flags.hardware_id)
> +		hid = acpi_device_hid(device);
> +	else
> +		hid = NULL;
> +
> +	if (hid && !strcmp(hid, ACPI_BUTTON_HID_POWERF))
>  		acpi_remove_fixed_event_handler(ACPI_EVENT_POWER_BUTTON,
>  						acpi_device_notify_fixed);
> -	else if (!strcmp(acpi_device_hid(device), ACPI_BUTTON_HID_SLEEPF))
> +	else if (hid && !strcmp(hid, ACPI_BUTTON_HID_SLEEPF))
>  		acpi_remove_fixed_event_handler(ACPI_EVENT_SLEEP_BUTTON,
>  						acpi_device_notify_fixed);
>  	else

