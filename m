Return-Path: <linux-kernel-owner+w=401wt.eu-S1765096AbZDJQOE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765096AbZDJQOE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Apr 2009 12:14:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758721AbZDJQNu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Apr 2009 12:13:50 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:13216 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbZDJQNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Apr 2009 12:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=X6kyimyCBuj6PR3w2ofU/hajZYk7yrduz7tu7IaOugfaBMiGhQbSH+RhlMn+UKnd8/
         hskY/kC/uYasPqS8fxMuZkM95O5Y+C/7y/5SvFn19E6oH1ypnNxO5MFR7K79N6s+AUFR
         estkkqleqzYf4pRF1QPVezH9aHhO2rIWCIyj4=
Message-ID: <49DF714F.9070600@tuffmail.co.uk>
Date: Fri, 10 Apr 2009 17:18:23 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: ath5k-devel@venema.h4ckr.net
CC: Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-wireless@vger.kernel.org
Subject: BUG in wiphy_update_regulatory when loading ath5k (on latest git)
References: <49DF6216.8040303@tuffmail.co.uk>
In-Reply-To: <49DF6216.8040303@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Jenkins wrote:
> Hi, while testing latest Git (i.e. 2.6.30-rc1 + a bit), I hit a bug 
> which killed my keyboard.  SysRQ keys worked, but I couldn't type in X 
> or on the console.

> This happened when ath5k was loaded dynamically, in response to my 
> pressing the "wireless toggle" key.  (rfkill-input -> eeepc-laptop, 
> which does weird acpi-driven PCI hotplug).
>
> Can anyone at least explain where this weird backtrace comes from?

Scratch that.  I was able to reproduce it once and get a proper dmesg.  
My logs were just dropping all the useful bits.  Here it is (taint is 
due to a libusual bug, note usual-tables(P) in list of modules, no 
binary crap here, honest).

[   64.995032] ath5k 0000:01:00.0: registered as 'phy0'
[   65.062652] BUG: unable to handle kernel NULL pointer dereference at 
00000004
[   65.062665] IP: [<e0171332>] wiphy_update_regulatory+0x20f/0x295 
[cfg80211]
[   65.062705] *pdpt = 0000000008bf1001 *pde = 0000000000000000
[   65.062717] Oops: 0000 [#1]
[   65.062724] last sysfs file: /sys/class/backlight/eeepc/brightness
[   65.062734] Modules linked in: ath5k(+) mac80211 led_class cfg80211 
i915 drm i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect ipv6 
rfkill_input joydev usual_tables(P) snd_hda_codec_realtek snd_hda_intel 
snd_hda_codec snd_hwdep uhci_hcd snd_pcm_oss snd_mixer_oss i2c_i801 
ehci_hcd psmouse serio_raw i2c_core pcspkr atl2 snd_pcm intel_agp 
snd_timer usbcore agpgart eeepc_laptop snd_page_alloc ac video backlight 
output battery rfkill button processor evdev thermal fan ata_generic
[   65.062839]
[   65.062849] Pid: 2909, comm: modprobe Tainted: P           
(2.6.30-rc1eeepc #112) 701
[   65.062860] EIP: 0060:[<e0171332>] EFLAGS: 00010246 CPU: 0
[   65.062885] EIP is at wiphy_update_regulatory+0x20f/0x295 [cfg80211]
[   65.062894] EAX: 00000000 EBX: c5da0000 ECX: 00000000 EDX: c5da0060
[   65.062904] ESI: 0000001a EDI: c5da0060 EBP: df3bdd70 ESP: df3bdd40
[   65.062913]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[   65.062923] Process modprobe (pid: 2909, ti=df3bc000 task=c5d03000 
task.ti=df3bc000)
[   65.062930] Stack:
[   65.062935]  df3bdd90 c5da0060 c04277e0 00000001 00000044 c04277e4 
c5da0060 00000002
[   65.062953]  00000002 c5da0000 0000001a c5da0060 df3bdda8 e01706a2 
00000002 00000002
[   65.062971]  00000282 000080d0 00000068 c5d53500 00000080 00000282 
00000080 c5da0140
[   65.062991] Call Trace:
[   65.062999]  [<e01706a2>] ? wiphy_register+0x122/0x1b7 [cfg80211]
[   65.063028]  [<e0328e02>] ? ieee80211_register_hw+0xd8/0x346 [mac80211]
[   65.063069]  [<e06a7c9f>] ? ath5k_hw_set_bssid_mask+0x71/0x78 [ath5k]
[   65.063099]  [<e06b0c52>] ? ath5k_pci_probe+0xa5c/0xd0a [ath5k]
[   65.063126]  [<c01a6037>] ? sysfs_find_dirent+0x16/0x27
[   65.063146]  [<c01fec95>] ? local_pci_probe+0xe/0x10
[   65.063162]  [<c01ff526>] ? pci_device_probe+0x48/0x66
[   65.063176]  [<c024c9fd>] ? driver_probe_device+0x7f/0xf2
[   65.063193]  [<c024cab3>] ? __driver_attach+0x43/0x5f
[   65.063205]  [<c024c0af>] ? bus_for_each_dev+0x39/0x5a
[   65.063217]  [<c024c8d0>] ? driver_attach+0x14/0x16
[   65.063228]  [<c024ca70>] ? __driver_attach+0x0/0x5f
[   65.063240]  [<c024c5b3>] ? bus_add_driver+0xd7/0x1e7
[   65.063252]  [<c024ccb9>] ? driver_register+0x7b/0xd7
[   65.063272]  [<c01ff827>] ? __pci_register_driver+0x32/0x85
[   65.063286]  [<e00a8018>] ? init_ath5k_pci+0x18/0x30 [ath5k]
[   65.063309]  [<c0101131>] ? _stext+0x49/0x10b
[   65.063322]  [<e00a8000>] ? init_ath5k_pci+0x0/0x30 [ath5k]
[   65.063330]  [<c012f452>] ? __blocking_notifier_call_chain+0x40/0x4c
[   65.063330]  [<c013a714>] ? sys_init_module+0x87/0x18b
[   65.063330]  [<c0102804>] ? sysenter_do_call+0x12/0x22
[   65.063330] Code: b8 da 17 e0 83 c0 04 e8 92 f9 ff ff 84 c0 75 2a 8b 
55 d4 8b 42 28 85 c0 74 0c 83 c0 04 e8 7c f9 ff ff 84 c0 75 14 a1 bc da 
17 e0 <83> 78 04 03 74 66 8b 4d d4 80 79 08 00 74 5d a1 e0 d2 17 e0 48
[   65.063330] EIP: [<e0171332>] wiphy_update_regulatory+0x20f/0x295 
[cfg80211] SS:ESP 0068:df3bdd40
[   65.063330] CR2: 0000000000000004
[   65.063543] ---[ end trace 830f2dd2a95fd1a8 ]---

I had a look on kerneloops and found a recent bug in the same function, 
I wonder if it is related (bugzilla.kernel.org/show_bug.cgi?id=12456).

It's _probably_ a regression; I've been using the wireless-toggle button 
quite a bit previouslly, on 2.6.29-rc8.

Thanks in advance
Alan

