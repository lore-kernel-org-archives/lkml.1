Return-Path: <linux-kernel-owner+w=401wt.eu-S1755394AbZJAI50@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755394AbZJAI50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 04:57:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754361AbZJAI5Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 04:57:25 -0400
Received: from mail-pz0-f187.google.com ([209.85.222.187]:56809 "EHLO
	mail-pz0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755139AbZJAI5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 04:57:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=iGJx+C0i2BWbgzTKVtBdGnHa9UXBe+sxRZ0RhX/9roD6Nd/R3z6vyjEF8x7gLI4ttw
         PYgHkanjPsLoUAoOGfLbLOn2kujlpVLaNqqnS7luVW5AVtbiYR3EnfU6c2H0caj84JcI
         j14aipB++g/KkBsSnlKpElzKvIIc/HM5tKCGU=
Date: Thu, 1 Oct 2009 16:49:24 +0800
From: Dave Young <hidave.darkstar@gmail.com>
To: mb@bu3sch.de, linville@tuxdriver.com
Cc: bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: b43: fix wldev use after free
Message-ID: <20091001084924.GA4170@darkstar>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

when rmmod b43, I got following bug message

[  100.121798] BUG: unable to handle kernel paging request at 2f4066fa
[  100.123338] IP: [<f9e9dd57>] b43_unregister_led+0x6/0x1c [b43]
[  100.123338] *pde = 00000000 
[  100.123338] Oops: 0000 [#1] SMP 
[  100.123338] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:0c:00.0/ssb0:0/firmware/ssb0:0/loading
[  100.123338] Modules linked in: reiserfs kvm_intel kvm snd_hda_codec_intelhdmi firewire_ohci snd_hda_codec_idt firewire_core b43(-) snd_hda_intel mac80211 snd_hda_codec crc_itu_t cfg80211 snd_hwdep ohci1394 snd_pcm dell_laptop wmi ieee1394 rfkill snd_timer snd_page_alloc
[  100.123338] 
[  100.123338] Pid: 1931, comm: rmmod Not tainted (2.6.31-mm1 #2) Latitude E5400                  
[  100.123338] EIP: 0060:[<f9e9dd57>] EFLAGS: 00010246 CPU: 0
[  100.123338] EIP is at b43_unregister_led+0x6/0x1c [b43]
[  100.123338] EAX: 2f4066fa EBX: 2f4066fa ECX: 00000006 EDX: 00000246
[  100.123338] ESI: f6a59000 EDI: f72030a8 EBP: f6373ec8 ESP: f6373ec4
[  100.123338]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[  100.123338] Process rmmod (pid: 1931, ti=f6372000 task=f66e0000 task.ti=f6372000)
[  100.123338] Stack:
[  100.123338]  2f406576 f6373ed4 f9e9dd7f f674cda0 f6373ee8 f9e8816e f72030a8 f9ea4b18
[  100.123338] <0> f9ea4b18 f6373ef4 c04bbd57 f7297000 f6373f04 c03f2563 f7297000 f7297034
[  100.123338] <0> f6373f18 c03f2609 f9ea4b18 00000000 c07742fc f6373f2c c03f1aac 00000000
[  100.123338] Call Trace:
[  100.123338]  [<f9e9dd7f>] ? b43_leds_unregister+0x12/0x36 [b43]
[  100.123338]  [<f9e8816e>] ? b43_remove+0x79/0x87 [b43]
[  100.123338]  [<c04bbd57>] ? ssb_device_remove+0x1d/0x29
[  100.123338]  [<c03f2563>] ? __device_release_driver+0x59/0x98
[  100.123338]  [<c03f2609>] ? driver_detach+0x67/0x85
[  100.123338]  [<c03f1aac>] ? bus_remove_driver+0x63/0x7f
[  100.123338]  [<c03f2a04>] ? driver_unregister+0x4d/0x54
[  100.123338]  [<c04bb828>] ? ssb_driver_unregister+0xb/0xd
[  100.123338]  [<f9e9f876>] ? b43_exit+0xd/0x19 [b43]
[  100.123338]  [<c025124b>] ? sys_delete_module+0x17c/0x1e0
[  100.123338]  [<c054c654>] ? do_page_fault+0x29d/0x2a5
[  100.123338]  [<c02032d6>] ? restore_all_notrace+0x0/0x18
[  100.123338]  [<c054c3b7>] ? do_page_fault+0x0/0x2a5
[  100.123338]  [<c020329d>] ? syscall_call+0x7/0xb
[  100.123338] Code: 0f b6 93 d8 03 00 00 e8 16 ff ff ff 0f b6 8b 39 03 00 00 89 f0 0f b6 93 38 03 00 00 e8 01 ff ff ff 5b 5e 5d c3 55 89 e5 53 89 c3 <83> 38 00 74 0e 8d 40 04 e8 de cc 60 c6 c7 03 00 00 00 00 5b 5d 
[  100.123338] EIP: [<f9e9dd57>] b43_unregister_led+0x6/0x1c [b43] SS:ESP 0068:f6373ec4
[  100.123338] CR2: 000000002f4066fa
[  100.953375] ---[ end trace d100c06b1451fbd8 ]---

in b43_remove, b43_one_core_detach free the wldev,
thus following callback which reference wldev will oops.

fix it by call b43_leds_unregister before b43_one_core_detach
if it is the last one in wl->devlist


Signed-off-by: Dave Young <hidave.darkstar@gmail.com>
---
drivers/net/wireless/b43/main.c |    4 +++-
1 file changed, 3 insertions(+), 1 deletion(-)

--- linux-2.6.31.orig/drivers/net/wireless/b43/main.c	2009-10-01 16:17:00.000000000 +0800
+++ linux-2.6.31/drivers/net/wireless/b43/main.c	2009-10-01 16:37:41.000000000 +0800
@@ -4993,11 +4993,13 @@ static void b43_remove(struct ssb_device
 		ieee80211_unregister_hw(wl->hw);
 	}
 
+	if (list_is_last(&wldev->list, &wl->devlist))
+		b43_leds_unregister(wldev);
+
 	b43_one_core_detach(dev);
 
 	if (list_empty(&wl->devlist)) {
 		b43_rng_exit(wl);
-		b43_leds_unregister(wldev);
 		/* Last core on the chip unregistered.
 		 * We can destroy common struct b43_wl.
 		 */
