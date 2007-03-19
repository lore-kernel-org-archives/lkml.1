Return-Path: <linux-kernel-owner+w=401wt.eu-S1030221AbXCSP2R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030221AbXCSP2R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 11:28:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030220AbXCSP2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 11:28:17 -0400
Received: from rnd-off.balt.net ([195.14.167.137]:17731 "EHLO barclay.balt.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030221AbXCSP2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 11:28:16 -0400
Subject: Kernel Oops in  pl2303_shutdown()
From: Zilvinas Valinskas <zilvinas@wilibox.com>
Reply-To: zilvinas@wilibox.com
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 19 Mar 2007 17:27:58 +0200
Message-Id: <1174318078.4601.77.camel@zv.wilibox.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, 

Before 2.6.21-rc4 (vanilla) serial was oopsing if I pull usb-serial
cable while minicom was running. Now it doesn't matter if minicom is
running or minicom closed, pulling serial cable results in such oops.


(gdb) l *pl2303_shutdown+0x45
0x1f95 is in pl2303_shutdown (include/linux/device.h:471).
466     #endif
467
468     static inline void *
469     dev_get_drvdata (struct device *dev)
470     {
471             return dev->driver_data;
472     }
473
474     static inline void
475     dev_set_drvdata (struct device *dev, void *data)

In drivers/usb/serial/pl2303.c file:
907         for (i = 0; i < serial->num_ports; ++i) {
908                 priv = usb_get_serial_port_data(serial->port[i]);
909                 if (priv) {
910                         pl2303_buf_free(priv->buf);
911                         kfree(priv);
912                         usb_set_serial_port_data(serial->port[i], NULL);
913                 }

It seems on line 908 'serial->port' is NULL here already ? Something has changed
in drivers/usb/serial/. 
 

ps.

Kernel is tainted because of fglrx.ko kernel module.  

Mar 18 23:55:21 zv kernel: [21529.080060] usb 3-1: USB disconnect, address 2
Mar 18 23:55:21 zv kernel: [21529.080064] usb 3-1: unregistering device
Mar 18 23:55:21 zv kernel: [21529.080068] usb 3-1: usb_disable_device nuking all URBs
Mar 18 23:55:21 zv kernel: [21529.080079] usb 3-1: unregistering interface 3-1:1.0
Mar 18 23:55:21 zv kernel: [21529.080141]  usbdev3.2_ep81: ep_device_release called for usbdev3.2_ep81
Mar 18 23:55:21 zv kernel: [21529.080177]  usbdev3.2_ep02: ep_device_release called for usbdev3.2_ep02
Mar 18 23:55:21 zv kernel: [21529.080210]  usbdev3.2_ep83: ep_device_release called for usbdev3.2_ep83
Mar 18 23:55:21 zv kernel: [21529.080284] pl2303 ttyUSB0: pl2303 converter now disconnected from ttyUSB0
Mar 18 23:55:21 zv kernel: [21529.080330] BUG: using smp_processor_id() in preemptible [00000001] code: khubd/224
Mar 18 23:55:21 zv kernel: [21529.080339] caller is oops_begin+0xb/0x80
Mar 18 23:55:21 zv kernel: [21529.080343] 
Mar 18 23:55:21 zv kernel: [21529.080344] Call Trace:
Mar 18 23:55:21 zv kernel: [21529.080358]  [<ffffffff80343b9e>] debug_smp_processor_id+0xae/0xc0
Mar 18 23:55:21 zv kernel: [21529.080365]  [<ffffffff8026c15b>] oops_begin+0xb/0x80
Mar 18 23:55:21 zv kernel: [21529.080373]  [<ffffffff8020ad04>] do_page_fault+0x6b4/0x860
Mar 18 23:55:21 zv kernel: [21529.080381]  [<ffffffff80249711>] sprintf+0x51/0x60
Mar 18 23:55:21 zv kernel: [21529.080392]  [<ffffffff8022ef53>] __wake_up+0x43/0x70
Mar 18 23:55:21 zv kernel: [21529.080402]  [<ffffffff802682a6>] _spin_unlock_irqrestore+0x16/0x40
Mar 18 23:55:21 zv kernel: [21529.080411]  [<ffffffff8025a15e>] netlink_broadcast+0x2ee/0x350
Mar 18 23:55:21 zv kernel: [21529.080423]  [<ffffffff802dbd31>] simple_unlink+0x61/0x80
Mar 18 23:55:21 zv kernel: [21529.080433]  [<ffffffff8026853d>] error_exit+0x0/0x84
Mar 18 23:55:21 zv kernel: [21529.080450]  [<ffffffff884919e0>] :usbserial:port_release+0x0/0x40
Mar 18 23:55:21 zv kernel: [21529.080461]  [<ffffffff8033fa80>] kobject_release+0x0/0x10
Mar 18 23:55:21 zv kernel: [21529.080473]  [<ffffffff8849df95>] :pl2303:pl2303_shutdown+0x45/0x90
Mar 18 23:55:21 zv kernel: [21529.080489]  [<ffffffff88491d47>] :usbserial:destroy_serial+0xb7/0x170
Mar 18 23:55:21 zv kernel: [21529.080501]  [<ffffffff88491c90>] :usbserial:destroy_serial+0x0/0x170
Mar 18 23:55:21 zv kernel: [21529.080508]  [<ffffffff802360e5>] kref_put+0x65/0x80
Mar 18 23:55:21 zv kernel: [21529.080521]  [<ffffffff88491b38>] :usbserial:usb_serial_disconnect+0x98/0xd0
Mar 18 23:55:21 zv kernel: [21529.080534]  [<ffffffff803e40fd>] usb_unbind_interface+0x6d/0xd0
Mar 18 23:55:21 zv kernel: [21529.080544]  [<ffffffff803b2e81>] __device_release_driver+0x91/0xc0
Mar 18 23:55:21 zv kernel: [21529.080552]  [<ffffffff803b3413>] device_release_driver+0x33/0x60
Mar 18 23:55:21 zv kernel: [21529.080561]  [<ffffffff803b26de>] bus_remove_device+0x6e/0x90
Mar 18 23:55:21 zv kernel: [21529.080569]  [<ffffffff803b0903>] device_del+0x163/0x1e0
Mar 18 23:55:21 zv kernel: [21529.080578]  [<ffffffff803e0e9f>] usb_disable_device+0xef/0x1c0
Mar 18 23:55:21 zv kernel: [21529.080588]  [<ffffffff803dc0e6>] usb_disconnect+0xe6/0x180
Mar 18 23:55:21 zv kernel: [21529.080598]  [<ffffffff803dd7a9>] hub_thread+0x629/0x1030
Mar 18 23:55:21 zv kernel: [21529.080606]  [<ffffffff802897bc>] task_rq_lock+0x4c/0x90
Mar 18 23:55:21 zv kernel: [21529.080613]  [<ffffffff8026b9e2>] __switch_to+0x42/0x2b0
Mar 18 23:55:21 zv kernel: [21529.080642]  [<ffffffff802682e5>] _spin_unlock_irq+0x15/0x40
Mar 18 23:55:21 zv kernel: [21529.080658]  [<ffffffff802a1290>] autoremove_wake_function+0x0/0x30
Mar 18 23:55:21 zv kernel: [21529.080670]  [<ffffffff803dd180>] hub_thread+0x0/0x1030
Mar 18 23:55:21 zv kernel: [21529.080676]  [<ffffffff802a10b0>] keventd_create_kthread+0x0/0x90
Mar 18 23:55:21 zv kernel: [21529.080683]  [<ffffffff80233639>] kthread+0xd9/0x120
Mar 18 23:55:21 zv kernel: [21529.080690]  [<ffffffff8029ca90>] __call_usermodehelper+0x0/0x80
Mar 18 23:55:21 zv kernel: [21529.080696]  [<ffffffff802282bf>] schedule_tail+0x3f/0xb0
Mar 18 23:55:21 zv kernel: [21529.080705]  [<ffffffff80261f68>] child_rip+0xa/0x12
Mar 18 23:55:21 zv kernel: [21529.080713]  [<ffffffff802a10b0>] keventd_create_kthread+0x0/0x90
Mar 18 23:55:21 zv kernel: [21529.080727]  [<ffffffff80233560>] kthread+0x0/0x120
Mar 18 23:55:21 zv kernel: [21529.080733]  [<ffffffff80261f5e>] child_rip+0x0/0x12
Mar 18 23:55:21 zv kernel: [21529.080739] 
Mar 18 23:55:21 zv kernel: [21529.080743] Unable to handle kernel NULL pointer dereference at 00000000000002d8 RIP: 
Mar 18 23:55:21 zv kernel: [21529.080750]  [<ffffffff8849df95>] :pl2303:pl2303_shutdown+0x45/0x90
Mar 18 23:55:21 zv kernel: [21529.080761] PGD 30c4a067 PUD 30c68067 PMD 0 
Mar 18 23:55:21 zv kernel: [21529.080767] Oops: 0000 [1] PREEMPT SMP 
Mar 18 23:55:21 zv kernel: [21529.080773] CPU 1 
Mar 18 23:55:21 zv kernel: [21529.080777] Modules linked in: hci_usb bluetooth tcp_htcp tcp_westwood tcp_veno tcp_vegas tcp_scalable tcp_lp tcp_highspeed pl2303 usbserial fglrx(P) nfs ipv6 nfsd exportfs lockd nfs_acl sunrpc ppdev lp deflate zlib_deflate twofish twofish_common camellia serpent blowfish des cbc ecb blkcipher aes xcbc sha256 sha1 crypto_null af_key piix ide_core dm_snapshot dm_mirror dm_mod sbp2 loop cpufreq_conservative cpufreq_stats acpi_cpufreq freq_table joydev tsdev snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm pcmcia snd_timer ipw3945 tpm_infineon sg snd tpm tpm_bios tifm_7xx1 tifm_core ohci1394 parport_pc parport ieee80211 ieee80211_crypt psmouse tg3 sr_mod iTCO_wdt iTCO_vendor_support ieee1394 intel_agp ehci_hcd uhci_hcd soundcore snd_page_alloc yenta_socket rsrc_nonstatic pcmcia_core serio_raw sdhci mmc_core pcspkr firmware_class cdrom evdev
Mar 18 23:55:21 zv kernel: [21529.080882] Pid: 224, comm: khubd Tainted: P       2.6.21-rc4 #1
Mar 18 23:55:21 zv kernel: [21529.080887] RIP: 0010:[<ffffffff8849df95>]  [<ffffffff8849df95>] :pl2303:pl2303_shutdown+0x45/0x90
Mar 18 23:55:21 zv kernel: [21529.080898] RSP: 0018:ffff81003f6e1c30  EFLAGS: 00010246
Mar 18 23:55:21 zv kernel: [21529.080903] RAX: 0000000000000000 RBX: ffff8100392404c0 RCX: ffffffff804825e0
Mar 18 23:55:21 zv kernel: [21529.080908] RDX: 0000000000000001 RSI: ffffffff8033fa80 RDI: ffff8100392404c0
Mar 18 23:55:21 zv kernel: [21529.080913] RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000001
Mar 18 23:55:21 zv kernel: [21529.080918] R10: 0000000000000000 R11: ffffffff884919e0 R12: ffff8100392404c0
Mar 18 23:55:21 zv kernel: [21529.080924] R13: ffff8100348cd820 R14: 00000000ffffffed R15: ffff81003b9929e0
Mar 18 23:55:21 zv kernel: [21529.080930] FS:  0000000000000000(0000) GS:ffff81003ff8a540(0000) knlGS:0000000000000000
Mar 18 23:55:21 zv kernel: [21529.080935] CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
Mar 18 23:55:21 zv kernel: [21529.080939] CR2: 00000000000002d8 CR3: 0000000030c29000 CR4: 00000000000006e0
Mar 18 23:55:21 zv kernel: [21529.080945] Process khubd (pid: 224, threadinfo ffff81003f6e0000, task ffff81003f4096f0)
Mar 18 23:55:21 zv kernel: [21529.080949] Stack:  ffff8100392404c0 0000000000000001 ffff8100392404c0 ffffffff88491d47
Mar 18 23:55:21 zv kernel: [21529.080960]  ffff81003b992800 ffff810039240520 ffffffff88491c90 ffffffff802360e5
Mar 18 23:55:21 zv kernel: [21529.080969]  ffff81002e15c400 ffff81002e15c400 0000000000000001 ffffffff88491b38
Mar 18 23:55:21 zv kernel: [21529.080977] Call Trace:
Mar 18 23:55:21 zv kernel: [21529.080990]  [<ffffffff88491d47>] :usbserial:destroy_serial+0xb7/0x170
Mar 18 23:55:21 zv kernel: [21529.081002]  [<ffffffff88491c90>] :usbserial:destroy_serial+0x0/0x170
Mar 18 23:55:21 zv kernel: [21529.081009]  [<ffffffff802360e5>] kref_put+0x65/0x80
Mar 18 23:55:21 zv kernel: [21529.081022]  [<ffffffff88491b38>] :usbserial:usb_serial_disconnect+0x98/0xd0
Mar 18 23:55:21 zv kernel: [21529.081033]  [<ffffffff803e40fd>] usb_unbind_interface+0x6d/0xd0
Mar 18 23:55:21 zv kernel: [21529.081042]  [<ffffffff803b2e81>] __device_release_driver+0x91/0xc0
Mar 18 23:55:21 zv kernel: [21529.081049]  [<ffffffff803b3413>] device_release_driver+0x33/0x60
Mar 18 23:55:21 zv kernel: [21529.081058]  [<ffffffff803b26de>] bus_remove_device+0x6e/0x90
Mar 18 23:55:21 zv kernel: [21529.081065]  [<ffffffff803b0903>] device_del+0x163/0x1e0
Mar 18 23:55:21 zv kernel: [21529.081074]  [<ffffffff803e0e9f>] usb_disable_device+0xef/0x1c0
Mar 18 23:55:21 zv kernel: [21529.081084]  [<ffffffff803dc0e6>] usb_disconnect+0xe6/0x180
Mar 18 23:55:21 zv kernel: [21529.081094]  [<ffffffff803dd7a9>] hub_thread+0x629/0x1030
Mar 18 23:55:21 zv kernel: [21529.081101]  [<ffffffff802897bc>] task_rq_lock+0x4c/0x90
Mar 18 23:55:21 zv kernel: [21529.081108]  [<ffffffff8026b9e2>] __switch_to+0x42/0x2b0
Mar 18 23:55:21 zv kernel: [21529.081117]  [<ffffffff802682e5>] _spin_unlock_irq+0x15/0x40
Mar 18 23:55:21 zv kernel: [21529.081131]  [<ffffffff802a1290>] autoremove_wake_function+0x0/0x30
Mar 18 23:55:21 zv kernel: [21529.081142]  [<ffffffff803dd180>] hub_thread+0x0/0x1030
Mar 18 23:55:21 zv kernel: [21529.081149]  [<ffffffff802a10b0>] keventd_create_kthread+0x0/0x90
Mar 18 23:55:21 zv kernel: [21529.081156]  [<ffffffff80233639>] kthread+0xd9/0x120
Mar 18 23:55:21 zv kernel: [21529.081163]  [<ffffffff8029ca90>] __call_usermodehelper+0x0/0x80
Mar 18 23:55:21 zv kernel: [21529.081168]  [<ffffffff802282bf>] schedule_tail+0x3f/0xb0
Mar 18 23:55:21 zv kernel: [21529.081177]  [<ffffffff80261f68>] child_rip+0xa/0x12
Mar 18 23:55:21 zv kernel: [21529.081185]  [<ffffffff802a10b0>] keventd_create_kthread+0x0/0x90
Mar 18 23:55:21 zv kernel: [21529.081199]  [<ffffffff80233560>] kthread+0x0/0x120
Mar 18 23:55:21 zv kernel: [21529.081206]  [<ffffffff80261f5e>] child_rip+0x0/0x12
Mar 18 23:55:21 zv kernel: [21529.081212] 
Mar 18 23:55:21 zv kernel: [21529.081214] 
Mar 18 23:55:21 zv kernel: [21529.081215] Code: 48 8b 98 d8 02 00 00 48 85 db 74 21 48 8b 7b 08 e8 a6 e6 ff 
Mar 18 23:55:21 zv kernel: [21529.081237] RIP  [<ffffffff8849df95>] :pl2303:pl2303_shutdown+0x45/0x90
Mar 18 23:55:21 zv kernel: [21529.081247]  RSP <ffff81003f6e1c30>
Mar 18 23:55:21 zv kernel: [21529.081250] CR2: 00000000000002d8
Mar 18 23:55:22 zv kernel: [21530.337923] usb usb3: suspend_rh (auto-stop)
M

