Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZIUTVl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZIUTVl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 15:21:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753454AbZIUTVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 15:21:37 -0400
Received: from perninha.conectiva.com.br ([200.140.247.100]:33915 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461AbZIUTVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 15:21:34 -0400
X-Greylist: delayed 1678 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2009 15:21:34 EDT
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Organization: Mandriva
To: linux-kernel@vger.kernel.org
Subject: rtc_cmos oops in cmos_rtc_ioctl
Date: Mon, 21 Sep 2009 15:53:38 -0300
User-Agent: KMail/1.12.1 (Linux/2.6.31-desktop-2mnb; KDE/4.3.1; i686; ; )
Cc: David Brownell <david-b@pacbell.net>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       rtc-linux@googlegroups.com
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200909211553.38409.herton@mandriva.com.br>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Currently there is a problem with rtc_cmos. On one machine, I can make it oops
if I induce it to boot slowly, for example if I enable serial console in it with
"console=ttyS0,9600 console=tty0 ignore_loglevel". Then I get following trace:

rtc_cmos 00:03: RTC can wake from S4
rtc_cmos 00:03: rtc core: registered rtc_cmos as rtc0
input: PC Speaker as /devices/platform/pcspkr/input/input3
BUG: unable to handle kernel NULL pointer dereference at 00000008
IP: [<f89f1b70>] cmos_rtc_ioctl+0x30/0xd0 [rtc_cmos]
*pde = 00000000 
Oops: 0000 [#1] SMP 
last sysfs file: /sys/devices/pnp0/00:03/rtc/rtc0/dev
Modules linked in: pcspkr sr_mod(+) rtc_cmos(+) r8169 thermal button soundcore snd_page_alloc mii processor usbcore ata_generic ide_pci_generic ide_gd_mod ide_core pata_acpi ahci ata_piix libata sd_mod scsi_mod crc_t10dif ext3 jbd i915 drm i2c_algo_bit i2c_core video output

Pid: 532, comm: hwclock Not tainted (2.6.31-desktop-2mnb #1) System Product Name
EIP: 0060:[<f89f1b70>] EFLAGS: 00010246 CPU: 0
EIP is at cmos_rtc_ioctl+0x30/0xd0 [rtc_cmos]
EAX: fffffdfd EBX: 00000000 ECX: 00000003 EDX: 00007004
ESI: f89f1b40 EDI: 00007004 EBP: f613beb4 ESP: f613bea4
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Process hwclock (pid: 532, ti=f613a000 task=f66a0c70 task.ti=f613a000)
Stack:
 f613beb4 e6fff99b f6516c00 f89f1b40 f613bf2c c039c96b f89f2b20 00000000
<0> f6516cd8 f613bf20 00000000 00000000 ffffff9c f6fe4000 00008000 00000000
<0> 00000000 f609ac00 f666cc40 f6459780 f6a31d48 c2bec380 df61c025 00000000
Call Trace:
 [<f89f1b40>] ? cmos_rtc_ioctl+0x0/0xd0 [rtc_cmos]
 [<c039c96b>] ? rtc_dev_ioctl+0x18b/0x480
 [<c039cc88>] ? rtc_dev_release+0x28/0x70
 [<c0202e12>] ? __fput+0xf2/0x200
 [<c0202f47>] ? fput+0x27/0x40
 [<c01fea87>] ? filp_close+0x57/0xa0
 [<c01feb3e>] ? sys_close+0x6e/0xc0
 [<c010407b>] ? sysenter_do_call+0x12/0x28
Code: 10 89 5d f8 89 75 fc 0f 1f 44 00 00 65 8b 0d 14 00 00 00 89 4d f4 31 c9 8d 8a ff 8f ff ff 83 f9 03 8b 58 4c b8 fd fd ff ff 77 50 <8b> 4b 08 66 b8 ea ff 85 c9 7e 45 b8 2c e9 6c c0 89 55 f0 e8 68 
EIP: [<f89f1b70>] cmos_rtc_ioctl+0x30/0xd0 [rtc_cmos] SS:ESP 0068:f613bea4
CR2: 0000000000000008
---[ end trace add67abfa3790852 ]---
rtc0: alarms up to one month, y3k, 114 bytes nvram, hpet irqs

The problem here is the rtc char device being created early and acessible before
rtc_cmos does dev_set_drvdata(dev, &cmos_rtc), so dev_get_drvdata in
cmos_rtc_ioctl can return null, like in this example where hwclock is run right
after char device creation that triggers the udev rule:
ACTION=="add", SUBSYSTEM=="rtc", RUN+="/sbin/hwclock --hctosys --rtc=/dev/%k"
And makes the oops possible, in this case hwclock looks to open and close the
device fast enough.

Not all machines reproduce it consistently this when using serial console (I
tried other two just by curiosity), but in a bug report where I asked for a
serial console dump the trace I got had also the similar oops, but on a bit
older kernel (2.6.29).

The fix is to just call dev_set_drvdata before device creation (before
rtc_device_register), like following patch:

diff --git a/drivers/rtc/rtc-cmos.c b/drivers/rtc/rtc-cmos.c
index f7a4701..071f9ed 100644
--- a/drivers/rtc/rtc-cmos.c
+++ b/drivers/rtc/rtc-cmos.c
@@ -723,6 +723,8 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 		}
 	}
 
+	dev_set_drvdata(dev, &cmos_rtc);
+
 	cmos_rtc.rtc = rtc_device_register(driver_name, dev,
 				&cmos_rtc_ops, THIS_MODULE);
 	if (IS_ERR(cmos_rtc.rtc)) {
@@ -731,7 +733,6 @@ cmos_do_probe(struct device *dev, struct resource *ports, int rtc_irq)
 	}
 
 	cmos_rtc.dev = dev;
-	dev_set_drvdata(dev, &cmos_rtc);
 	rename_region(ports, dev_name(&cmos_rtc.rtc->dev));
 
 	spin_lock_irq(&rtc_lock);


But I saw another issue: looks it could be possible that as cmos_rtc_ioctl
(ioctl) can be run before rtc_device_register returns, the following call chain
could happen in current code:
cmos_rtc_ioctl->cmos_irq_{en,dis}able->cmos_checkintr->rtc_update_irq
rtc_update_irq uses cmos->rtc, which is set only at return of
rtc_device_register, and here we may have another problem... is it
possible?

--
[]'s
Herton
