Return-Path: <linux-kernel-owner+w=401wt.eu-S1760036AbZD1CBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760036AbZD1CBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Apr 2009 22:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756595AbZD1CBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Apr 2009 22:01:15 -0400
Received: from mail.deathmatch.net ([72.66.92.28]:3751 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932AbZD1CBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Apr 2009 22:01:14 -0400
Date: Mon, 27 Apr 2009 21:58:44 -0400
From: Bob Copeland <me@bobcopeland.com>
To: johannes@sipsolutions.net
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] appletouch: fix DMA to/from stack buffer
Message-ID: <20090428015844.GA16190@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_DMA_API_DEBUG spotted an instance of appletouch using
an array on the stack as a DMA buffer for certain hardware.
Change it to use a kmalloc()ed buffer instead.

This fixes the following error:

[   11.526270] uhci_hcd 0000:00:1d.0: DMA-API: device driver maps memory fromstack [addr=f1d33e2c]
[   11.526274] Modules linked in: appletouch(+) snd_seq_dummy snd_seq_oss snd_seq_midi_event usbhid arc4 ecb snd_seq snd_seq_device ath5k snd_pcm_oss snd_mixer_oss mac80211 sky2 ohci1394 bitrev ath ieee1394 snd_pcm ehci_hcd uhci_hcd crc32 sg joydev snd_timer cfg80211 snd thermal button processor snd_page_alloc ac battery applesmc sr_mod input_polldev cdrom evdev unix
[   11.526333] Pid: 2213, comm: modprobe Not tainted 2.6.30-rc3-wl #112
[   11.526337] Call Trace:
[   11.526344]  [<c012590f>] warn_slowpath+0x76/0xa5
[   11.526352]  [<c0107166>] ? sched_clock+0x3f/0x64
[   11.526360]  [<c014c98c>] ? __module_text_address+0x10/0x4d
[   11.526366]  [<c014cc54>] ? is_module_text_address+0x28/0x42
[   11.526373]  [<c013569e>] ? __kernel_text_address+0x5a/0x60
[   11.526379]  [<c010554b>] ? print_context_stack+0xc9/0xde
[   11.526387]  [<c0143ce7>] ? put_lock_stats+0xd/0x21
[   11.526393]  [<c0145589>] ? trace_hardirqs_on+0xb/0xd
[   11.526400]  [<c0356336>] ? _spin_unlock_irqrestore+0x47/0x5d
[   11.526406]  [<c0218914>] check_for_stack+0x58/0x7a
[   11.526413]  [<c0219bb1>] debug_dma_map_page+0xfe/0x119
[   11.526420]  [<c02a7d9e>] usb_hcd_submit_urb+0x228/0x9ce
[   11.526429]  [<c0143ce7>] ? put_lock_stats+0xd/0x21
[   11.526434]  [<c0143df6>] ? lock_release_holdtime+0xfb/0x103
[   11.526440]  [<c0356378>] ? _spin_unlock+0x2c/0x41
[   11.526446]  [<c01455b6>] ? debug_check_no_locks_freed+0x2b/0xff
[   11.526451]  [<c0145589>] ? trace_hardirqs_on+0xb/0xd
[   11.526457]  [<c014567e>] ? debug_check_no_locks_freed+0xf3/0xff
[   11.526463]  [<c0144192>] ? lockdep_init_map+0x81/0x3f5
[   11.526469]  [<c0145589>] ? trace_hardirqs_on+0xb/0xd
[   11.526476]  [<c02a89ee>] usb_submit_urb+0x1e6/0x202
[   11.526482]  [<c02a97fe>] usb_start_wait_urb+0x3d/0x9a
[   11.526489]  [<c02a9a74>] usb_control_msg+0x107/0x120
[   11.526499]  [<f9a67b45>] atp_geyser_init+0x3b/0x10f [appletouch]
[   11.526507]  [<f9a6719f>] ? atp_complete_geyser_3_4+0x0/0x47c [appletouch]
[   11.526514]  [<f9a67c36>] atp_handle_geyser+0x1d/0x37 [appletouch]
[   11.526522]  [<f9a67f18>] atp_probe+0x1b4/0x3b0 [appletouch]
[   11.526528]  [<c02ab10a>] usb_probe_interface+0xd0/0x110
[   11.526536]  [<c02733db>] driver_probe_device+0x85/0x111
[   11.526542]  [<c02734af>] __driver_attach+0x48/0x64
[   11.526548]  [<c0272d95>] bus_for_each_dev+0x42/0x6c
[   11.526554]  [<c027329c>] driver_attach+0x19/0x1b
[   11.526560]  [<c0273467>] ? __driver_attach+0x0/0x64
[   11.526566]  [<c02727a9>] bus_add_driver+0xf9/0x213
[   11.526571]  [<c02736f5>] driver_register+0x90/0xed
[   11.526577]  [<c0217d8d>] ? __spin_lock_init+0x24/0x4b
[   11.526582]  [<c02aaf32>] usb_register_driver+0x79/0xd6
[   11.526590]  [<f9a6c017>] atp_init+0x17/0x19 [appletouch]
[   11.526595]  [<c0101141>] do_one_initcall+0x4f/0x116
[   11.526602]  [<f9a6c000>] ? atp_init+0x0/0x19 [appletouch]
[   11.526610]  [<c013a9f4>] ? up_read+0x1b/0x2f
[   11.526616]  [<c013b298>] ? __blocking_notifier_call_chain+0x45/0x51
[   11.526624]  [<c014fa77>] sys_init_module+0x8e/0x196
[   11.526629]  [<c0102a88>] sysenter_do_call+0x12/0x36
[   11.526634] ---[ end trace 212ca97a23247c2a ]---
[   11.529720] appletouch: Geyser mode initialized.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/input/mouse/appletouch.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/input/mouse/appletouch.c b/drivers/input/mouse/appletouch.c
index 454b961..e0140fd 100644
--- a/drivers/input/mouse/appletouch.c
+++ b/drivers/input/mouse/appletouch.c
@@ -255,15 +255,22 @@ MODULE_PARM_DESC(debug, "Activate debugging output");
  */
 static int atp_geyser_init(struct usb_device *udev)
 {
-	char data[8];
+	char *data;
 	int size;
 	int i;
+	int ret;
+
+	data = kmalloc(8, GFP_KERNEL);
+	if (!data) {
+		err("Out of memory");
+		return -ENOMEM;
+	}
 
 	size = usb_control_msg(udev, usb_rcvctrlpipe(udev, 0),
 			ATP_GEYSER_MODE_READ_REQUEST_ID,
 			USB_DIR_IN | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			ATP_GEYSER_MODE_REQUEST_VALUE,
-			ATP_GEYSER_MODE_REQUEST_INDEX, &data, 8, 5000);
+			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
 		dprintk("atp_geyser_init: read error\n");
@@ -271,7 +278,8 @@ static int atp_geyser_init(struct usb_device *udev)
 			dprintk("appletouch[%d]: %d\n", i, data[i]);
 
 		err("Failed to read mode from device.");
-		return -EIO;
+		ret = -EIO;
+		goto out_free;
 	}
 
 	/* Apply the mode switch */
@@ -281,7 +289,7 @@ static int atp_geyser_init(struct usb_device *udev)
 			ATP_GEYSER_MODE_WRITE_REQUEST_ID,
 			USB_DIR_OUT | USB_TYPE_CLASS | USB_RECIP_INTERFACE,
 			ATP_GEYSER_MODE_REQUEST_VALUE,
-			ATP_GEYSER_MODE_REQUEST_INDEX, &data, 8, 5000);
+			ATP_GEYSER_MODE_REQUEST_INDEX, data, 8, 5000);
 
 	if (size != 8) {
 		dprintk("atp_geyser_init: write error\n");
@@ -289,9 +297,13 @@ static int atp_geyser_init(struct usb_device *udev)
 			dprintk("appletouch[%d]: %d\n", i, data[i]);
 
 		err("Failed to request geyser raw mode");
-		return -EIO;
+		ret = -EIO;
+		goto out_free;
 	}
-	return 0;
+	ret = 0;
+out_free:
+	kfree(data);
+	return ret;
 }
 
 /*
-- 
1.6.0.6

-- 
Bob Copeland %% www.bobcopeland.com

