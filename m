Return-Path: <linux-kernel-owner+w=401wt.eu-S1758910AbXHNLWn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758910AbXHNLWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2007 07:22:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757159AbXHNLWe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Aug 2007 07:22:34 -0400
Received: from nf-out-0910.google.com ([64.233.182.185]:47406 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757076AbXHNLWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2007 07:22:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=TwacpbavxLm1qE2nq53thQTY68Dbz0gkPPXF6Be0wU5ghKtBiGKx5JWyIWAMUyiwCqrDzjsQ2Vap1N4ZmkjIaydoQLmgjBeBmZNhDfA9a0psHp7XEn6ppTx2JLAhSe0+AhIjmQ+ArZvfGKcyBL8vL7mnjjVof18Nw0VEr3IXu10=
Message-ID: <3d8471ca0708140422l79c53864g679bd36e308f8bc5@mail.gmail.com>
Date: Tue, 14 Aug 2007 13:22:29 +0200
From: "Guillaume Chazarain" <guichaz@yahoo.fr>
To: "Corentin Chary" <corentincj@iksaif.net>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix rmmod of asus_laptop
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: d26642df5d558948
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The asus laptop driver conditionnaly registers leds in asus_led_register()
depending on their availability, but unconditionnaly registers them all at
exit time or when the module fails to load. Unregistering not registered leds
result in the following Oops. So we should check before unregistering.

DEV: Unregistering device. ID = 'asus-laptop'
PM: Removing info for No Bus:asus-laptop
kobject_uevent_env
fill_kobj_path: path = '/class/backlight/asus-laptop'
kobject asus-laptop: cleaning up
DEV: Unregistering device. ID = '<NULL>'
BUG: unable to handle kernel NULL pointer dereference at virtual
address 00000064
 printing eip:
c026a9a3
*pde = 00000000
Oops: 0000 [#1]
PREEMPT
Modules linked in: radeon drm cpufreq_ondemand acpi_cpufreq freq_table
lm90 hwmon ipv6 binfmt_misc dm_mirror dm_mod snd_intel8x0
snd_intel8x0m snd_ac97_codec snd_seq_dummy ac97_bus snd_seq_oss
snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss hci_usb
snd_mixer_oss bluetooth snd_pcm ohci1394 snd_timer ieee1394 sr_mod snd
cdrom ipw2200 ieee80211 firewire_ohci asus_laptop rtc_cmos
firewire_core button video i2c_i801 rtc_core serio_raw soundcore irda
crc_ccitt crc_itu_t output ac ieee80211_crypt battery i2c_core
led_class sdhci mmc_core snd_page_alloc iTCO_wdt sg rtc_lib skge
ehci_hcd ohci_hcd uhci_hcd
CPU:    0
EIP:    0060:[<c026a9a3>]    Not tainted VLI
EFLAGS: 00210296   (2.6.23-rc3-patched #2)
EIP is at device_del+0xb/0x23a
eax: 00000000   ebx: 00000000   ecx: 00000033   edx: f7d0c7c0
esi: f88ab580   edi: 00000880   ebp: f594ef1c   esp: f594ef0c
ds: 007b   es: 007b   fs: 0000  gs: 0033  ss: 0068
Process rmmod (pid: 2552, ti=f594e000 task=f628e5b0 task.ti=f594e000)
Stack: c011fb2e 00000000 f88ab580 00000880 f594ef30 c026abf8 c03a85df 000000a4
       f88ab780 f594ef40 f8864218 f88ab780 00000000 f594ef48 f88a90f8 f594ef50
       f88a91c9 f594efb0 c013cee1 73757361 70616c5f 00706f74 c015c10a 00000004
Call Trace:
 [<c0107ee3>] show_trace_log_lvl+0x1a/0x2f
 [<c0107f95>] show_stack_log_lvl+0x9d/0xa5
 [<c010816a>] show_registers+0x1cd/0x2e3
 [<c010839d>] die+0x11d/0x218
 [<c032d2f9>] do_page_fault+0x511/0x5e9
 [<c032bae2>] error_code+0x6a/0x70
 [<c026abf8>] device_unregister+0x26/0x32
 [<f8864218>] led_classdev_unregister+0x58/0x94 [led_class]
 [<f88a90f8>] asus_led_exit+0x17/0x41 [asus_laptop]
 [<f88a91c9>] asus_laptop_exit+0xd/0x3f [asus_laptop]
 [<c013cee1>] sys_delete_module+0x17b/0x1a2
 [<c0106eae>] sysenter_past_esp+0x6b/0xa1
 =======================
Code: 8b 56 04 89 d8 e8 10 fb ff ff 85 ff 74 0d 8b 97 d0 00 00 00 89
d8 e8 9d ff ff ff 5b 5e 5f 5d c3 55 89 e5 57 56 53 89 c3 83 ec 04 <8b>
40 64 85 c0 89 45 f0 74 08 8d 43 10 e8 e0 ee 0b 00 8b 83 20
EIP: [<c026a9a3>] device_del+0xb/0x23a SS:ESP 0068:f594ef0c

Signed-off-by: Guillaume Chazarain <guichaz@yahoo.fr>
---

diff -r 1559df81a153 drivers/misc/asus-laptop.c
--- a/drivers/misc/asus-laptop.c	Mon Aug 13 05:00:33 2007 +0000
+++ b/drivers/misc/asus-laptop.c	Tue Aug 14 13:06:40 2007 +0200
@@ -1072,7 +1072,8 @@ static void asus_backlight_exit(void)
 }

 #define  ASUS_LED_UNREGISTER(object)				\
-	led_classdev_unregister(&object##_led)
+	if (object##_led.dev)					\
+		led_classdev_unregister(&object##_led)

 static void asus_led_exit(void)
 {

-- 
Guillaume
