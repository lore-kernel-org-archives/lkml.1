Return-Path: <linux-kernel-owner+w=401wt.eu-S933311AbZJFV31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933311AbZJFV31 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 17:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933040AbZJFV31
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 17:29:27 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59873 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932730AbZJFV3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 17:29:25 -0400
Date: Tue, 6 Oct 2009 14:28:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: mb@bu3sch.de, linville@tuxdriver.com, bcm43xx-dev@lists.berlios.de,
       linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: b43: fix wldev use after free
Message-Id: <20091006142822.55d5120c.akpm@linux-foundation.org>
In-Reply-To: <20091001084924.GA4170@darkstar>
References: <20091001084924.GA4170@darkstar>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009 16:49:24 +0800
Dave Young <hidave.darkstar@gmail.com> wrote:

> when rmmod b43, I got following bug message
> 
> [  100.121798] BUG: unable to handle kernel paging request at 2f4066fa
> [  100.123338] IP: [<f9e9dd57>] b43_unregister_led+0x6/0x1c [b43]
> [  100.123338] *pde = 00000000 
> [  100.123338] Oops: 0000 [#1] SMP 
> [  100.123338] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/ssb0:0/firmware/ssb0:0/loading
> [  100.123338] Modules linked in: reiserfs kvm_intel kvm snd_hda_codec_intelhdmi firewire_ohci snd_hda_codec_idt firewire_core b43(-) snd_hda_intel mac80211 snd_hda_codec crc_itu_t cfg80211 snd_hwdep ohci1394 snd_pcm dell_laptop wmi ieee1394 rfkill snd_timer snd_page_alloc
> [  100.123338] 
> [  100.123338] Pid: 1931, comm: rmmod Not tainted (2.6.31-mm1 #2) Latitude E5400                  
> [  100.123338] EIP: 0060:[<f9e9dd57>] EFLAGS: 00010246 CPU: 0
> [  100.123338] EIP is at b43_unregister_led+0x6/0x1c [b43]
> [  100.123338] EAX: 2f4066fa EBX: 2f4066fa ECX: 00000006 EDX: 00000246
> [  100.123338] ESI: f6a59000 EDI: f72030a8 EBP: f6373ec8 ESP: f6373ec4
> [  100.123338]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [  100.123338] Process rmmod (pid: 1931, ti=f6372000 task=f66e0000 task.ti=f6372000)
> [  100.123338] Stack:
> [  100.123338]  2f406576 f6373ed4 f9e9dd7f f674cda0 f6373ee8 f9e8816e f72030a8 f9ea4b18
> [  100.123338] <0> f9ea4b18 f6373ef4 c04bbd57 f7297000 f6373f04 c03f2563 f7297000 f7297034
> [  100.123338] <0> f6373f18 c03f2609 f9ea4b18 00000000 c07742fc f6373f2c c03f1aac 00000000
> [  100.123338] Call Trace:
> [  100.123338]  [<f9e9dd7f>] ? b43_leds_unregister+0x12/0x36 [b43]
> [  100.123338]  [<f9e8816e>] ? b43_remove+0x79/0x87 [b43]
> [  100.123338]  [<c04bbd57>] ? ssb_device_remove+0x1d/0x29
> [  100.123338]  [<c03f2563>] ? __device_release_driver+0x59/0x98
> [  100.123338]  [<c03f2609>] ? driver_detach+0x67/0x85
> [  100.123338]  [<c03f1aac>] ? bus_remove_driver+0x63/0x7f
> [  100.123338]  [<c03f2a04>] ? driver_unregister+0x4d/0x54
> [  100.123338]  [<c04bb828>] ? ssb_driver_unregister+0xb/0xd
> [  100.123338]  [<f9e9f876>] ? b43_exit+0xd/0x19 [b43]
> [  100.123338]  [<c025124b>] ? sys_delete_module+0x17c/0x1e0
> [  100.123338]  [<c054c654>] ? do_page_fault+0x29d/0x2a5
> [  100.123338]  [<c02032d6>] ? restore_all_notrace+0x0/0x18
> [  100.123338]  [<c054c3b7>] ? do_page_fault+0x0/0x2a5
> [  100.123338]  [<c020329d>] ? syscall_call+0x7/0xb
> [  100.123338] Code: 0f b6 93 d8 03 00 00 e8 16 ff ff ff 0f b6 8b 39 03 00 00 89 f0 0f b6 93 38 03 00 00 e8 01 ff ff ff 5b 5e 5d c3 55 89 e5 53 89 c3 <83> 38 00 74 0e 8d 40 04 e8 de cc 60 c6 c7 03 00 00 00 00 5b 5d 
> [  100.123338] EIP: [<f9e9dd57>] b43_unregister_led+0x6/0x1c [b43] SS:ESP 0068:f6373ec4
> [  100.123338] CR2: 000000002f4066fa
> [  100.953375] ---[ end trace d100c06b1451fbd8 ]---
> 
> in b43_remove, b43_one_core_detach free the wldev,
> thus following callback which reference wldev will oops.
> 
> fix it by call b43_leds_unregister before b43_one_core_detach
> if it is the last one in wl->devlist
> 

It appears that a different fix was added to linux-next yesterday:


commit 15b1803a33016745c672b74b699aaf99cf8dc0d4
Author:     Michael Buesch <mb@bu3sch.de>
AuthorDate: Thu Oct 1 15:54:32 2009 +0200
Commit:     John W. Linville <linville@tuxdriver.com>
CommitDate: Mon Oct 5 17:03:16 2009 -0400

    b43: Don't use struct wldev after detach.
    
    Don't use struct wldev after detach. This fixes an oops on access.
    
    Signed-off-by: Michael Buesch <mb@bu3sch.de>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

diff --git a/drivers/net/wireless/b43/leds.c b/drivers/net/wireless/b43/leds.c
index fbe3d4f..1e8dba4 100644
--- a/drivers/net/wireless/b43/leds.c
+++ b/drivers/net/wireless/b43/leds.c
@@ -348,9 +348,9 @@ void b43_leds_register(struct b43_wldev *dev)
 	}
 }
 
-void b43_leds_unregister(struct b43_wldev *dev)
+void b43_leds_unregister(struct b43_wl *wl)
 {
-	struct b43_leds *leds = &dev->wl->leds;
+	struct b43_leds *leds = &wl->leds;
 
 	b43_unregister_led(&leds->led_tx);
 	b43_unregister_led(&leds->led_rx);
diff --git a/drivers/net/wireless/b43/leds.h b/drivers/net/wireless/b43/leds.h
index 9592e4c..4c56187 100644
--- a/drivers/net/wireless/b43/leds.h
+++ b/drivers/net/wireless/b43/leds.h
@@ -60,7 +60,7 @@ enum b43_led_behaviour {
 };
 
 void b43_leds_register(struct b43_wldev *dev);
-void b43_leds_unregister(struct b43_wldev *dev);
+void b43_leds_unregister(struct b43_wl *wl);
 void b43_leds_init(struct b43_wldev *dev);
 void b43_leds_exit(struct b43_wldev *dev);
 void b43_leds_stop(struct b43_wldev *dev);
@@ -76,7 +76,7 @@ struct b43_leds {
 static inline void b43_leds_register(struct b43_wldev *dev)
 {
 }
-static inline void b43_leds_unregister(struct b43_wldev *dev)
+static inline void b43_leds_unregister(struct b43_wl *wl)
 {
 }
 static inline void b43_leds_init(struct b43_wldev *dev)
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 9b907a3..130dcd5 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -4997,7 +4997,7 @@ static void b43_remove(struct ssb_device *dev)
 
 	if (list_empty(&wl->devlist)) {
 		b43_rng_exit(wl);
-		b43_leds_unregister(wldev);
+		b43_leds_unregister(wl);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */

