Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756354Ab0BMNER (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 08:04:17 -0500
Received: from ppp-157-177.adsl.restena.lu ([158.64.157.177]:32776 "EHLO
	bonbons.gotdns.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753Ab0BMNEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 08:04:01 -0500
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Sat, 13 Feb 2010 08:04:00 EST
Date: Sat, 13 Feb 2010 13:57:20 +0100
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oliver@neukum.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Marcel Holtmann <marcel@holtmann.org>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       <linux-usb@vger.kernel.org>, <linux-input@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: S2R resume crash in 2.6.33-rc7 - NULL pointer dereference in
 dev_get_drvdata() for usbhid
Message-ID: <20100213135720.603e5f64@neptune.home>
In-Reply-To: <Pine.LNX.4.44L0.1002081505220.1316-100000@iolanthe.rowland.org>
References: <20100208190649.0ceea556@neptune.home>
 <Pine.LNX.4.44L0.1002081505220.1316-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 February 2010 Alan Stern <stern@rowland.harvard.edu> wrote:
> Clearly something is setting usbhid->intf to NULL.  But I don't see
> any code that would do it.  You may have to resort to putting
> printk() statements at various strategic places to find out where it
> happens. You could start with the beginnings and ends of hid_suspend,
> hid_resume, and hid_reset_resume.  Maybe also usbhid_disconnect(),
> just in case.

I did add a few printk()s and WARN_ON()s to get a better idea of
why/when usbhid->intf is NULL and it is already since probe time of the
second interface anounced by the USB keyboard (hid.debug=1):

[    3.822393] usb 2-2.1: new full speed USB device using uhci_hcd and address 3
[    4.011388] usb 2-2.1: New USB device found, idVendor=058f, idProduct=9462
[    4.011502] usb 2-2.1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[    4.011639] usb 2-2.1: Product: Multimedia USB Keyboard
[    4.011733] usb 2-2.1: Manufacturer: Multimedia USB Keyboard
[    4.011826] usb 2-2.1: SerialNumber: Multimedia USB Keyboard
[    4.014514] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 0
[    4.037712] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: submitting ctrl urb: Set_Report wValue=0x0200 wIndex=0x0000 wLength=1
[    4.038160] input: Multimedia USB Keyboard Multimedia USB Keyboard as /devices/pci0000:00/0000:00:10.0/usb2/2-2/2-2.1/2-2.1:1.0/input/input4
[    4.038523] generic-usb 0003:058F:9462.0001: input: USB HID v1.10 Keyboard [Multimedia USB Keyboard Multimedia USB Keyboard] on usb-0000:00:10.0-2.1/input0
[    4.038901] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: HID probe called for ifnum 1
[    4.066881] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: usage index exceeded
[    4.066894] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: hid_add_usage failed
[    4.066905] /usr/src/linux-2.6-git/drivers/hid/hid-core.c: item 0 2 2 2 parsing failed
[    4.066931] /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c: parsing report descriptor failed
  >>>> following WARNING comes from WARN_ON() I added to usbhid_parse
  >>>> to know what the call stack is up to the failing report parsing
[    4.066941] ------------[ cut here ]------------
[    4.067065] WARNING: at /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c:891 usbhid_parse+0x1db/0x340()
[    4.067226] Hardware name: CX700+W697HG
[    4.067316] Modules linked in:
[    4.067463] Pid: 228, comm: khubd Not tainted 2.6.33-rc7-venus #6
[    4.067560] Call Trace:
[    4.067662]  [<c1330cdd>] ? printk+0x18/0x1b
[    4.067763]  [<c12855db>] ? usbhid_parse+0x1db/0x340
[    4.067873]  [<c10251ec>] warn_slowpath_common+0x6c/0xc0
[    4.067976]  [<c12855db>] ? usbhid_parse+0x1db/0x340
[    4.068080]  [<c1025255>] warn_slowpath_null+0x15/0x20
[    4.068183]  [<c12855db>] usbhid_parse+0x1db/0x340
[    4.068293]  [<c127ac85>] hid_device_probe+0x155/0x170
[    4.068396]  [<c11ec838>] driver_probe_device+0x68/0x160
[    4.068500]  [<c127a2a8>] ? hid_bus_match+0x88/0x160
[    4.068605]  [<c11ec9f1>] __device_attach+0x41/0x50
[    4.068707]  [<c11ebe53>] bus_for_each_drv+0x53/0x80
[    4.068810]  [<c11eca9b>] device_attach+0x6b/0x70
[    4.068911]  [<c11ec9b0>] ? __device_attach+0x0/0x50
[    4.069014]  [<c11ebc4f>] bus_probe_device+0x1f/0x40
[    4.069117]  [<c11ea557>] device_add+0x357/0x570
[    4.069224]  [<c117a693>] ? kvasprintf+0x43/0x60
[    4.069326]  [<c1172c52>] ? kobject_set_name_vargs+0x62/0x70
[    4.069432]  [<c127a76e>] hid_add_device+0x14e/0x1d0
[    4.069579]  [<c1286012>] usbhid_probe+0x202/0x360
[    4.069685]  [<c1230e8f>] usb_probe_interface+0xaf/0x1c0
[    4.069791]  [<c11ec742>] ? driver_sysfs_add+0x52/0x70
[    4.069895]  [<c11ec838>] driver_probe_device+0x68/0x160
[    4.070000]  [<c122fd90>] ? usb_device_match+0x50/0xb0
[    4.070135]  [<c11ec9f1>] __device_attach+0x41/0x50
[    4.070234]  [<c11ebe53>] bus_for_each_drv+0x53/0x80
[    4.070338]  [<c11eca9b>] device_attach+0x6b/0x70
[    4.070434]  [<c11ec9b0>] ? __device_attach+0x0/0x50
[    4.070530]  [<c11ebc4f>] bus_probe_device+0x1f/0x40
[    4.070626]  [<c11ea557>] device_add+0x357/0x570
[    4.070722]  [<c1234ccc>] ? usb_create_ep_devs+0x7c/0xb0
[    4.070821]  [<c122db03>] ? create_intf_ep_devs+0x43/0x70
[    4.070919]  [<c122f7e7>] usb_set_configuration+0x4a7/0x640
[    4.071019]  [<c1237ff9>] generic_probe+0x39/0xb0
[    4.071120]  [<c10c4352>] ? sysfs_create_link+0x12/0x20
[    4.071218]  [<c122fb5f>] usb_probe_device+0x1f/0x30
[    4.071314]  [<c11ec838>] driver_probe_device+0x68/0x160
[    4.071412]  [<c11ec9f1>] __device_attach+0x41/0x50
[    4.071508]  [<c11ebe53>] bus_for_each_drv+0x53/0x80
[    4.071605]  [<c11eca9b>] device_attach+0x6b/0x70
[    4.071700]  [<c11ec9b0>] ? __device_attach+0x0/0x50
[    4.071797]  [<c11ebc4f>] bus_probe_device+0x1f/0x40
[    4.071892]  [<c11ea557>] device_add+0x357/0x570
[    4.071987]  [<c1330cdd>] ? printk+0x18/0x1b
[    4.072081]  [<c12266ab>] ? show_string+0x4b/0x50
[    4.072177]  [<c12292d6>] usb_new_device+0x116/0x180
[    4.072274]  [<c122aadf>] hub_thread+0xdbf/0x11d0
[    4.072372]  [<c1021377>] ? dequeue_task_fair+0x27/0x1d0
[    4.072470]  [<c102106e>] ? set_next_entity+0x2e/0x70
[    4.072567]  [<c1021ef1>] ? finish_task_switch+0x31/0x80
[    4.072669]  [<c10374b0>] ? autoremove_wake_function+0x0/0x50
[    4.072767]  [<c1229d20>] ? hub_thread+0x0/0x11d0
[    4.072863]  [<c10370ec>] kthread+0x6c/0x80
[    4.072958]  [<c1037080>] ? kthread+0x0/0x80
[    4.073053]  [<c10030f6>] kernel_thread_helper+0x6/0x10
[    4.073146] ---[ end trace 74d7f471f706deb5 ]---
[    4.073256] generic-usb: probe of 0003:058F:9462.0002 failed with error -22
   >>>> This is the WARN_ON(usbhid->intf ==NULL) I added just before
   >>>> return 0 to usbhid_probe() to confirm that intf is already NULL
   >>>> since the very beginning for this HID device
[    4.073378] ------------[ cut here ]------------
[    4.073470] WARNING: at /usr/src/linux-2.6-git/drivers/hid/usbhid/hid-core.c:1166 usbhid_probe+0x2d9/0x360()
[    4.073606] Hardware name: CX700+W697HG
[    4.073694] Modules linked in:
[    4.073828] Pid: 228, comm: khubd Tainted: G        W  2.6.33-rc7-venus #6
[    4.073923] Call Trace:
[    4.074013]  [<c1330cdd>] ? printk+0x18/0x1b
[    4.074106]  [<c12860e9>] ? usbhid_probe+0x2d9/0x360
[    4.074203]  [<c10251ec>] warn_slowpath_common+0x6c/0xc0
[    4.074299]  [<c12860e9>] ? usbhid_probe+0x2d9/0x360
[    4.074397]  [<c1025255>] warn_slowpath_null+0x15/0x20
[    4.074493]  [<c12860e9>] usbhid_probe+0x2d9/0x360
[    4.074590]  [<c1230e8f>] usb_probe_interface+0xaf/0x1c0
[    4.074688]  [<c11ec742>] ? driver_sysfs_add+0x52/0x70
[    4.074785]  [<c11ec838>] driver_probe_device+0x68/0x160
[    4.074881]  [<c122fd90>] ? usb_device_match+0x50/0xb0
[    4.074979]  [<c11ec9f1>] __device_attach+0x41/0x50
[    4.075074]  [<c11ebe53>] bus_for_each_drv+0x53/0x80
[    4.075171]  [<c11eca9b>] device_attach+0x6b/0x70
[    4.075266]  [<c11ec9b0>] ? __device_attach+0x0/0x50
[    4.075363]  [<c11ebc4f>] bus_probe_device+0x1f/0x40
[    4.075458]  [<c11ea557>] device_add+0x357/0x570
[    4.075553]  [<c1234ccc>] ? usb_create_ep_devs+0x7c/0xb0
[    4.075650]  [<c122db03>] ? create_intf_ep_devs+0x43/0x70
[    4.075749]  [<c122f7e7>] usb_set_configuration+0x4a7/0x640
[    4.075847]  [<c1237ff9>] generic_probe+0x39/0xb0
[    4.075944]  [<c10c4352>] ? sysfs_create_link+0x12/0x20
[    4.076041]  [<c122fb5f>] usb_probe_device+0x1f/0x30
[    4.076138]  [<c11ec838>] driver_probe_device+0x68/0x160
[    4.076235]  [<c11ec9f1>] __device_attach+0x41/0x50
[    4.076331]  [<c11ebe53>] bus_for_each_drv+0x53/0x80
[    4.076428]  [<c11eca9b>] device_attach+0x6b/0x70
[    4.076523]  [<c11ec9b0>] ? __device_attach+0x0/0x50
[    4.076619]  [<c11ebc4f>] bus_probe_device+0x1f/0x40
[    4.076714]  [<c11ea557>] device_add+0x357/0x570
[    4.076809]  [<c1330cdd>] ? printk+0x18/0x1b
[    4.076902]  [<c12266ab>] ? show_string+0x4b/0x50
[    4.076997]  [<c12292d6>] usb_new_device+0x116/0x180
[    4.077094]  [<c122aadf>] hub_thread+0xdbf/0x11d0
[    4.077191]  [<c1021377>] ? dequeue_task_fair+0x27/0x1d0
[    4.077288]  [<c102106e>] ? set_next_entity+0x2e/0x70
[    4.077384]  [<c1021ef1>] ? finish_task_switch+0x31/0x80
[    4.077482]  [<c10374b0>] ? autoremove_wake_function+0x0/0x50
[    4.077579]  [<c1229d20>] ? hub_thread+0x0/0x11d0
[    4.077674]  [<c10370ec>] kthread+0x6c/0x80
[    4.077768]  [<c1037080>] ? kthread+0x0/0x80
[    4.077861]  [<c10030f6>] kernel_thread_helper+0x6/0x10
[    4.077954] ---[ end trace 74d7f471f706deb6 ]---
[    5.401011] udev: starting version 146
[    5.672965] Linux agpgart interface v0.103
[    5.776141] sd 0:0:0:0: Attached scsi generic sg0 type 0
[    5.776327] sd 1:0:1:0: Attached scsi generic sg1 type 0
[    5.968845] VIA Graphics Intergration Chipset framebuffer 2.4 initializing
[    6.145620] agpgart: Detected VIA CX700 chipset
[    6.155095] agpgart-via 0000:00:00.0: AGP aperture is 128M @ 0xd0000000

This lets me guess that hid_add_device() is doing something wrong
here when report parsing fails... (as that one is the only one which
could be doing the initialization of usbhid which does work for the
first interface announced by my keyboard)

Bruno
