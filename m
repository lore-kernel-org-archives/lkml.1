Return-Path: <linux-kernel-owner+w=401wt.eu-S1761806AbYBWRk5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761806AbYBWRk5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 12:40:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760543AbYBWRjz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 12:39:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:43260 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760408AbYBWRjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 12:39:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C05A51.7000209@s5r6.in-berlin.de>
Date: Sat, 23 Feb 2008 18:39:29 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux1394-devel@lists.sourceforge.net
Subject: Re: 2.6.25-rc2: ohci1394 problem
References: <47BBDB07.80409@m3y3r.de> <47BBF771.40203@s5r6.in-berlin.de> <47BC6918.4000203@m3y3r.de> <47BC6E42.10409@s5r6.in-berlin.de> <47BC6EEC.4020000@s5r6.in-berlin.de> <47C04F99.6030704@m3y3r.de>
In-Reply-To: <47C04F99.6030704@m3y3r.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
[...]
> [  847.320251] ohci1394: Unknown symbol hpsb_iso_packet_sent
> [  847.320328] ohci1394: Unknown symbol hpsb_packet_sent
> [  847.320406] ohci1394: Unknown symbol dma_region_sync_for_cpu
> [  847.320513] ohci1394: Unknown symbol hpsb_selfid_received
> [  847.320586] ohci1394: Unknown symbol hpsb_bus_reset

Used insmod?  Use modprobe, or resolve the module dependencies manually.

> [  856.789954] ACPI: PCI Interrupt 0000:0c:03.0[A] -> GSI 19 (level, low) -> IRQ 19
> [  856.790040] ------------[ cut here ]------------
> [  856.790044] WARNING: at arch/x86/mm/ioremap.c:137 __ioremap+0xa7/0x16a()
> [  856.790048] Modules linked in: ohci1394(+) ieee1394 wlan_wep wlan_scan_sta ath_rate_sample ath_pci wlan ath_hal(P) firmware_class fuse snd_seq snd_seq_device nls_iso8859_15 nls_cp850 vfat fat usbhid appletouch applesmc input_polldev led_class dummy binfmt_misc tun pktcdvd loop msr cpuid coretemp hwmon eeprom cpufreq_powersave cpufreq_conservative acpi_cpufreq thermal ehci_hcd tpm_infineon i2c_i801 i2c_core tpm uhci_hcd usbcore tpm_bios processor ac battery sr_mod rng_core iTCO_wdt button firewire_ohci firewire_core sg snd_hda_intel snd_pcm snd_timer snd soundcore snd_page_alloc evdev intel_agp cdrom [last unloaded: microcode]
> [  856.790119] Pid: 7140, comm: insmod Tainted: P         2.6.25-rc2 #115
> [  856.790125]  [<c011e5ab>] warn_on_slowpath+0x40/0x4f
> [  856.790143]  [<c0118045>] __wake_up+0x29/0x39
> [  856.790154]  [<c0277305>] netlink_broadcast+0x26e/0x2af
> [  856.790169]  [<c01cc36b>] kobject_uevent_env+0x33d/0x361
> [  856.790178]  [<c025ef2b>] pci_mmcfg_write+0xc4/0xd5
> [  856.790187]  [<c0260157>] raw_pci_write+0x3e/0x46
> [  856.790200]  [<c01148f8>] __ioremap+0xa7/0x16a
> [  856.790210]  [<f8b14425>] ohci1394_pci_probe+0x20c/0x5a6 [ohci1394]
> [  856.790226]  [<c01d63f1>] pci_device_probe+0x36/0x55

Wait a minute.  Why is the line 856.790048 saying that firewire-ohci is 
present, but the preceding portions of dmesg don't show any 
initialization messages from firewire-ohci?

BTW, I just tested again:  I can modprobe ohci1394 with firewire-ohci 
already present, also modprobe firewire-ohci with ohci1394 already 
present, and in either case the expected happens:  The driver first 
loaded is being bound to the PCI device, the driver loaded second just 
sits there unused.  I can unload the first driver, trigger a re-probe of 
the PCI device via sysfs and the 2nd driver gets bound and works.  I can 
unload and reload the two drivers in any order without problem.  So far 
I an unable to reproduce what you got.

> [  856.790236]  [<c02226cb>] driver_probe_device+0x9d/0x114
> [  856.790246]  [<c0222826>] __driver_attach+0x52/0x87
> [  856.790254]  [<c0221d46>] bus_for_each_dev+0x35/0x57
> [  856.790265]  [<c022257e>] driver_attach+0x11/0x13
> [  856.790270]  [<c02227d4>] __driver_attach+0x0/0x87
> [  856.790277]  [<c02223bc>] bus_add_driver+0x91/0x195
> [  856.790286]  [<c02229d9>] driver_register+0x45/0x9a
> [  856.790297]  [<c01d65a6>] __pci_register_driver+0x32/0x60
> [  856.790305]  [<c013aea0>] sys_init_module+0x16b7/0x179f
> [  856.790495]  [<c0160bb9>] do_sync_read+0xbe/0x103
> [  856.790518]  [<c01549fc>] anon_vma_prepare+0x11/0xa6
> [  856.790529]  [<f8b55185>] hpsb_bus_reset+0x0/0xe2 [ieee1394]
> [  856.790560]  [<c0171db7>] mntput_no_expire+0x13/0x5d
> [  856.790569]  [<c015f6ce>] filp_close+0x4d/0x53
> [  856.790578]  [<c01048a2>] sysenter_past_esp+0x5f/0x85
> [  856.790595]  =======================
> [  856.790598] ---[ end trace 5b0384c17c339107 ]---
> [  856.943807] ohci1394: fw-host0: Get PHY Reg timeout [0x00008400/0x00000000/100]
> [  856.947140] ohci1394: fw-host0: Set PHY Reg timeout [0x000044c0/0x00004000/100]
> [  856.947261] ohci1394: fw-host0: OHCI-1394 0.35 (PCI): IRQ=[19]  MMIO=[100000000-1000007ff]  Max Packet=[65536]  IR/IT contexts=[32/32]

The "Max Packet" and "IR/IT contexts" values are bogus because several 
MMIO reads returned ~0 (all bits set to one).

My conclusion so far:  There is something wrong with your system which 
is below/ before the control of the ieee1394 or firewire stack.

BTW, there was a single change to ohci1394 after v2.6.24 and that does 
not affect the initialization code of ohci1394.  (Patch name is 
"ieee1394: ohci1394: don't schedule IT tasklets on IR events".)  Did you 
ever use kernels before 2.6.25-rc2 and had both of ohci1394 and 
firewire-ohci inserted?

If you switch CONFIG_FIREWIRE_OHCI off in the kernel config of 
2.6.25-rc2, rebuild and reinstall the modules and reboot, does the 
problem vanish?
-- 
Stefan Richter
-=====-==--- --=- =-===
http://arcgraph.de/sr/
