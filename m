Return-Path: <linux-kernel-owner+w=401wt.eu-S932066AbZGUUu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932066AbZGUUu1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:50:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755973AbZGUUu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:50:26 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:52221 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755951AbZGUUuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:50:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:content-disposition:message-id;
        b=sSzGlnClNTAZX1Gc6xtE0yI7KkM0oXAzVhieXG1UlTFOJ4Bye2ZgGYJ/LSxX95aQji
         7YhMNeJ6q07uxUMBrcOrsy/R95eOiK6HEPLX+n5lLVzMykqYDft6Mq85KOOinZIe5sgo
         U/g2ueKIzIBYzPI3trlBkJFYtmhiBvZTQzUMg=
From: Diego Calleja <diegocg@gmail.com>
To: Shaohua Li <shaohua.li@intel.com>
Subject: KMS oops on 945G system
Date: Tue, 21 Jul 2009 22:50:31 +0200
User-Agent: KMail/1.11.2 (Linux/2.6.31-rc3-00096-g78af08d-dirty; KDE/4.2.2; x86_64; ; )
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Eric Anholt <eric@anholt.net>,
       airlied@gmail.com, dri-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907212250.31353.diegocg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, I'm hitting an oops when I try to enable kernel modesetting. I'm using
one of the latests git snapshots, the one which includes some DRM fixes
(2.6.31-rc3-00096-g78af08d-dirty). It's not a regression, it's the first
time I try this. xserver-xorg-video-intel version is what was released
today, 2.8.0. The problem seems to be a "division error" here:

(gdb) l *(intel_update_watermarks+0x5c2)
0x12652 is in intel_update_watermarks (drivers/gpu/drm/i915/intel_display.c:1881).
1876            if (!planea_clock || !planeb_clock) {
1877                    sr_clock = planea_clock ? planea_clock : planeb_clock;
1878                    line_time_us = (sr_hdisplay * 1000) / sr_clock;
1879                    sr_entries = (((latency_ns / line_time_us) + 1) * pixel_size *
1880                                  sr_hdisplay) / 1000;
1881                    sr_entries = roundup(sr_entries / wm_params->cacheline_size, 1);
1882                    if (sr_entries < wm_params->fifo_size)
1883                            srwm = wm_params->fifo_size - sr_entries;
1884            }


which according to git it seems to be code from this commit:

commit 7662c8bd6545c12ac7b2b39e4554c3ba34789c50
Author: Shaohua Li <shaohua.li@intel.com>

    drm/i915: add FIFO watermark support


Oops:
kernel	[26716.280515] i915 0000:00:02.0: setting latency timer to 64
kernel	[26716.404805] [drm] fb0: inteldrmfb frame buffer device
kernel	[26716.404815] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
kernel	[26728.108978] Console: switching to colour frame buffer device 160x64
kernel	[26728.109351] divide error: 0000 [#1] PREEMPT SMP 
kernel	[26728.109357] last sysfs file: /sys/module/fb/initstate
kernel	[26728.109360] CPU 0 
kernel	[26728.109362] Modules linked in: fbcon font bitblit softcursor i915 ppp_deflate zlib_deflate bsd_comp ppp_async crc_ccitt ppp_generic slhc binfmt_misc fb drm i2c_algo_bit cfbcopyarea i2c_core cfbimgblt cfbfillrect kvm_intel kvm battery video backlight output container sbs sbshc ac snd_ca0106 snd_rawmidi snd_ac97_codec ac97_bus snd_pcm_oss snd_mixer_oss snd_pcm snd_timer snd wacom soundcore intel_agp processor snd_page_alloc button usbhid ehci_hcd atl1 mii uhci_hcd usbcore thermal fan thermal_sys fuse
kernel	[26728.109416] Pid: 18868, comm: Xorg Not tainted 2.6.31-rc3-00096-g78af08d-dirty #1 System Product Name
kernel	[26728.109419] RIP: 0010:[<ffffffffa0296622>]  [<ffffffffa0296622>] intel_update_watermarks+0x5c2/0xe40 [i915]
kernel	[26728.109436] RSP: 0018:ffff88007a427be8  EFLAGS: 00010246
kernel	[26728.109438] RAX: 0000000000000000 RBX: 0000000000000001 RCX: 0000000000000000
kernel	[26728.109441] RDX: 0000000000000000 RSI: ffffffffa02b1a85 RDI: 0000000000000001
kernel	[26728.109444] RBP: ffff88007a427c78 R08: 0000000000000001 R09: 000000000000003b
kernel	[26728.109446] R10: 0000000000000004 R11: 0000000000000000 R12: 000000000000001c
kernel	[26728.109449] R13: ffffffffa02bdde0 R14: ffff8800a919d800 R15: 0000000000010000
kernel	[26728.109452] FS:  00007fbaf2c1c700(0000) GS:ffff8800016c9000(0000) knlGS:0000000000000000
kernel	[26728.109455] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel	[26728.109458] CR2: 00000000025b1670 CR3: 000000001f452000 CR4: 00000000000026f0
kernel	[26728.109460] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
kernel	[26728.109463] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
kernel	[26728.109466] Process Xorg (pid: 18868, threadinfo ffff88007a426000, task ffff8800b1c92de0)
kernel	[26728.109468] Stack:
kernel	[26728.109470]  ffff8800aeafb0f8 ffffffff813ab600 ffff8800aeafafe0 0000000000000000
kernel	[26728.109475] <0> 0000000000000004 fffffffffffffffa 0000000000000000 0000000000000000
kernel	[26728.109480] <0> 0306010600000306 0000003f00000000 000000010000003f ffff88003016d000
kernel	[26728.109487] Call Trace:
kernel	[26728.109500]  [<ffffffffa0298624>] intel_crtc_dpms+0x974/0xf40 [i915]
kernel	[26728.109508]  [<ffffffff810beb8d>] ? __generic_file_aio_write_nolock+0x26d/0x460
kernel	[26728.109529]  [<ffffffffa01fd5a3>] ? drm_crtc_helper_set_config+0x133/0x6e0 [drm]
kernel	[26728.109544]  [<ffffffffa01fc83a>] drm_helper_disable_unused_functions+0xea/0x100 [drm]
kernel	[26728.109559]  [<ffffffffa01fda78>] drm_crtc_helper_set_config+0x608/0x6e0 [drm]
kernel	[26728.109571]  [<ffffffffa02a5815>] intelfb_restore+0x15/0x40 [i915]
kernel	[26728.109582]  [<ffffffffa0284efa>] i915_driver_lastclose+0x3a/0x70 [i915]
kernel	[26728.109597]  [<ffffffffa01eeeb9>] drm_lastclose+0x49/0x300 [drm]
kernel	[26728.109613]  [<ffffffffa01ef5d6>] drm_release+0x456/0x5a0 [drm]
kernel	[26728.109617]  [<ffffffff810f9f8f>] __fput+0xdf/0x1f0
kernel	[26728.109621]  [<ffffffff810fa0c5>] fput+0x25/0x30
kernel	[26728.109624]  [<ffffffff810f65a8>] filp_close+0x58/0x90
kernel	[26728.109628]  [<ffffffff810f669e>] sys_close+0xbe/0x120
kernel	[26728.109633]  [<ffffffff8100b65b>] system_call_fastpath+0x16/0x1b
kernel	[26728.109635] Code: 41 c1 e7 10 8b 55 d4 85 d2 0f 85 37 06 00 00 8b 45 b8 89 45 d4 41 69 d3 e8 03 00 00 49 63 c2 49 63 cb 48 0f af c8 89 d0 c1 fa 1f <f7> 7d d4 31 d2 48 63 f8 b8 88 13 00 00 48 f7 f7 48 ff c0 48 0f 
kernel	[26728.109690] RIP  [<ffffffffa0296622>] intel_update_watermarks+0x5c2/0xe40 [i915]
kernel	[26728.109702]  RSP <ffff88007a427be8>
kernel	[26728.109706] ---[ end trace 6161554342d4617e ]---
kdm[18866]	X server died during startup
kdm[18866]	Failed to start X server. Starting failsafe X server.
kernel	[26728.890347] [drm] DAC-6: set mode 1280x1024 17


00:00.0 Host bridge: Intel Corporation 82945G/GZ/P/PL Memory Controller Hub (rev 02)
00:02.0 VGA compatible controller: Intel Corporation 82945G/GZ Integrated Graphics Controller (rev 02)
00:1c.0 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 1 (rev 01)
00:1c.1 PCI bridge: Intel Corporation 82801G (ICH7 Family) PCI Express Port 2 (rev 01)
00:1d.0 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #1 (rev 01)
00:1d.1 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #2 (rev 01)
00:1d.2 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #3 (rev 01)
00:1d.3 USB Controller: Intel Corporation 82801G (ICH7 Family) USB UHCI Controller #4 (rev 01)
00:1d.7 USB Controller: Intel Corporation 82801G (ICH7 Family) USB2 EHCI Controller (rev 01)
00:1e.0 PCI bridge: Intel Corporation 82801 PCI Bridge (rev e1)
00:1f.0 ISA bridge: Intel Corporation 82801GB/GR (ICH7 Family) LPC Interface Bridge (rev 01)
00:1f.1 IDE interface: Intel Corporation 82801G (ICH7 Family) IDE Controller (rev 01)
00:1f.2 IDE interface: Intel Corporation 82801GB/GR/GH (ICH7 Family) SATA IDE Controller (rev 01)
00:1f.3 SMBus: Intel Corporation 82801G (ICH7 Family) SMBus Controller (rev 01)
01:03.0 FireWire (IEEE 1394): VIA Technologies, Inc. VT6306 Fire II IEEE 1394 OHCI Link Layer Controller (rev c0)
01:0a.0 Multimedia audio controller: Creative Labs CA0106 Soundblaster
02:00.0 Ethernet controller: Attansic Technology Corp. L1 Gigabit Ethernet Adapter (rev b0)

