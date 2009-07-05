Return-Path: <linux-kernel-owner+w=401wt.eu-S1754699AbZGEWLY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbZGEWLY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 18:11:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753164AbZGEWLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 18:11:16 -0400
Received: from orion.ambsoft.pl ([212.109.144.130]:39826 "EHLO
	orion.ambsoft.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbZGEWLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 18:11:16 -0400
Date: Mon, 6 Jul 2009 00:11:14 +0200
From: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
To: Eugene Kapun <abacabadabacaba@gmail.com>
Cc: maxk@qualcomm.com, linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
       Herbert Xu <herbert@gondor.apana.org.au>
Subject: Re: PROBLEM: tun/tap crashes if open() /dev/net/tun and then poll()
 it.
Message-ID: <20090706001114.2d4517be@mako-desktop>
In-Reply-To: <4A4F1480.70203@gmail.com>
References: <4A4F1480.70203@gmail.com>
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 04 Jul 2009 12:36:16 +0400
Eugene Kapun <abacabadabacaba@gmail.com> wrote:

> This small program causes kernel oops:
> 
> #include <fcntl.h>
> #include <poll.h>
> 
> int main() {
>     int fd;
>     struct pollfd pfd;
>     fd = open("/dev/net/tun", O_RDWR);
>     pfd.fd = fd;
>     pfd.events = POLLIN | POLLOUT;
>     poll(&pfd, 1, 0);
> }

Hi,

	Can you try this patch?

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 11a0ba4..c599327 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -486,12 +486,14 @@ static unsigned int tun_chr_poll(struct file *file, poll_table * wait)
 {
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = __tun_get(tfile);
-	struct sock *sk = tun->sk;
+	struct sock *sk;
 	unsigned int mask = 0;
 
 	if (!tun)
 		return POLLERR;
 
+	sk = tun->sk;
+
 	DBG(KERN_INFO "%s: tun_chr_poll\n", tun->dev->name);
 
 	poll_wait(file, &tun->socket.wait, wait);



> Software versions:
> Gnu C                  4.4.0
> Gnu make               3.81
> binutils               2.19.51.20090622
> util-linux             2.15.1-rc1
> mount                  support
> module-init-tools      3.8
> e2fsprogs              1.41.5
> reiserfsprogs          3.6.21
> pcmciautils            014
> Linux C Library        2.9
> Dynamic linker (ldd)   2.9
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.15
> Sh-utils               7.4
> wireless-tools         29
> Modules Loaded         tun ppp_async option usb_storage binfmt_misc
> ppdev kqemu sbp2 lp parport snd_hda_codec_realtek joydev snd_hda_intel
> snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4 snd_seq_dummy
> snd_seq_oss ecb snd_seq_midi snd_rawmidi ath5k snd_seq_midi_event
> snd_seq snd_timer snd_seq_device pcmcia mac80211 nsc_ircc ath psmouse
> snd sdhci_pci sdhci acer_wmi yenta_socket rsrc_nonstatic uvcvideo
> tifm_7xx1 tifm_core serio_raw soundcore iTCO_wdt iTCO_vendor_support
> irda led_class pcmcia_core videodev v4l1_compat v4l2_compat_ioctl32
> cfg80211 pcspkr snd_page_alloc crc_ccitt ohci1394 ieee1394 tg3 usbhid
> fbcon tileblit font bitblit softcursor i915 drm i2c_algo_bit video
> output intel_agp
> 
> dmesg output:
> [14610.772456] BUG: unable to handle kernel NULL pointer dereference at
> 0000000000000080
> [14610.772464] IP: [<ffffffffa0455b63>] tun_chr_poll+0x33/0xf0 [tun]
> [14610.772473] PGD 2885f067 PUD 2bd8f067 PMD 0
> [14610.772477] Oops: 0000 [#4] SMP
> [14610.772480] last sysfs file:
> /sys/devices/LNXSYSTM:00/device:00/PNP0A08:00/device:29/PNP0C09:00/PNP0C0A:00/power_supply/BAT0/voltage_now
> [14610.772484] CPU 0
> [14610.772486] Modules linked in: tun ppp_async option usb_storage
> binfmt_misc ppdev kqemu sbp2 lp parport snd_hda_codec_realtek joydev
> snd_hda_intel snd_hda_codec snd_pcm_oss snd_mixer_oss snd_pcm arc4
> snd_seq_dummy snd_seq_oss ecb snd_seq_midi snd_rawmidi ath5k
> snd_seq_midi_event snd_seq snd_timer snd_seq_device pcmcia mac80211
> nsc_ircc ath psmouse snd sdhci_pci sdhci acer_wmi yenta_socket
> rsrc_nonstatic uvcvideo tifm_7xx1 tifm_core serio_raw soundcore iTCO_wdt
> iTCO_vendor_support irda led_class pcmcia_core videodev v4l1_compat
> v4l2_compat_ioctl32 cfg80211 pcspkr snd_page_alloc crc_ccitt ohci1394
> ieee1394 tg3 usbhid fbcon tileblit font bitblit softcursor i915 drm
> i2c_algo_bit video output intel_agp
> [14610.772532] Pid: 7896, comm: tun-crash Tainted: G      D   
> 2.6.31-rc1-git10-generic-vanilla #1 Extensa 5220                  
> [14610.772534] RIP: 0010:[<ffffffffa0455b63>]  [<ffffffffa0455b63>]
> tun_chr_poll+0x33/0xf0 [tun]
> [14610.772539] RSP: 0018:ffff88002bdbdb08  EFLAGS: 00010246
> [14610.772541] RAX: 0000000000000000 RBX: 0000000000000000 RCX:
> ffff88002bdbdb88
> [14610.772544] RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> ffff88007add0fe0
> [14610.772546] RBP: ffff88002bdbdb28 R08: 00007feea2ddb2e0 R09:
> 00007feea2def160
> [14610.772548] R10: 00007fffc0c0a150 R11: 0000000000000246 R12:
> ffff88002bdf8000
> [14610.772550] R13: 0000000000000000 R14: ffff88002bdf8000 R15:
> 0000000000000000
> [14610.772553] FS:  00007feea2fdf6f0(0000) GS:ffff88000199d000(0000)
> knlGS:0000000000000000
> [14610.772555] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [14610.772557] CR2: 0000000000000080 CR3: 000000002bdf7000 CR4:
> 00000000000006b0
> [14610.772560] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [14610.772562] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
> 0000000000000400
> [14610.772565] Process tun-crash (pid: 7896, threadinfo
> ffff88002bdbc000, task ffff880028838000)
> [14610.772566] Stack:
> [14610.772568]  ffff88002bdbdf04 ffff88002bdbde0c ffff88002bdbde04
> ffff88002bdf8000
> [14610.772572] <0> ffff88002bdbdf38 ffffffff8111eef5 ffff88002bdbdb58
> 01ffffff810ccaf2
> [14610.772575] <0> 00007fffc0c0a3d0 0000000000000000 ffff88002bdbdb88
> 00000001810e221d
> [14610.772580] Call Trace:
> [14610.772587]  [<ffffffff8111eef5>] do_sys_poll+0x235/0x510
> [14610.772591]  [<ffffffff8111eaf0>] ? __pollwait+0x0/0xf0
> [14610.772596]  [<ffffffff81504b49>] ? _spin_lock+0x9/0x10
> [14610.772598]  [<ffffffff81504b49>] ? _spin_lock+0x9/0x10
> [14610.772601]  [<ffffffff811219de>] ? __d_lookup+0x12e/0x150
> [14610.772605]  [<ffffffffa0455862>] ? tun_chr_open+0x32/0xe0 [tun]
> [14610.772609]  [<ffffffffa0455862>] ? tun_chr_open+0x32/0xe0 [tun]
> [14610.772612]  [<ffffffff81504dcd>] ? unlock_kernel+0x2d/0x40
> [14610.772617]  [<ffffffff812e351b>] ? misc_open+0x1bb/0x200
> [14610.772622]  [<ffffffff811118da>] ? chrdev_open+0xfa/0x1b0
> [14610.772626]  [<ffffffff810cb849>] ? find_get_page+0x19/0xa0
> [14610.772629]  [<ffffffff810cd831>] ? filemap_fault+0xb1/0x450
> [14610.772632]  [<ffffffff810ccaf2>] ? unlock_page+0x22/0x30
> [14610.772636]  [<ffffffff810e4ce9>] ? __do_fault+0x419/0x4e0
> [14610.772639]  [<ffffffff810e8d12>] ? handle_mm_fault+0x1b2/0x950
> [14610.772643]  [<ffffffff811271bb>] ? mntput_no_expire+0x2b/0x100
> [14610.772647]  [<ffffffff81030389>] ? default_spin_lock_flags+0x9/0x10
> [14610.772651]  [<ffffffff81260f9a>] ? __up_read+0x9a/0xc0
> [14610.772656]  [<ffffffff81073199>] ? up_read+0x9/0x10
> [14610.772659]  [<ffffffff8111f3b7>] sys_poll+0x77/0x110
> [14610.772663]  [<ffffffff81011ec2>] system_call_fastpath+0x16/0x1b
> [14610.772665] Code: 48 89 1c 24 4c 89 64 24 08 49 89 fc 4c 89 6c 24 10
> 4c 89 74 24 18 48 89 f3 48 8b bf a0 00 00 00 e8 73 f6 ff ff 48 85 db 49
> 89 c5 <4c> 8b b0 80 00 00 00 0f 85 98 00 00 00 49 8d 45 18 49 39 45 18
> [14610.772694] RIP  [<ffffffffa0455b63>] tun_chr_poll+0x33/0xf0 [tun]
> [14610.772698]  RSP <ffff88002bdbdb08>
> [14610.772699] CR2: 0000000000000080
> [14610.772702] ---[ end trace 9813be85d2509042 ]---
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
