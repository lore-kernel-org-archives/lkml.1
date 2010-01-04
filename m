Return-Path: <linux-kernel-owner+w=401wt.eu-S1753139Ab0ADFjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753139Ab0ADFjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 00:39:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923Ab0ADFjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 00:39:00 -0500
Received: from mga11.intel.com ([192.55.52.93]:62248 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752298Ab0ADFix (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 00:38:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,493,1257148800"; 
   d="scan'208";a="528160472"
Subject: [regression]: soft lockup in dmesg after suspend/resume
From: ykzhao <yakui.zhao@intel.com>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, nanhai.zou@intel.com,
       venkatesh.pallipadi@intel.com
Content-Type: multipart/mixed; boundary="=-cjtlXywonB/LAebr3DH3"
Organization: Intel Open Source Technology Center
Date: Mon, 04 Jan 2010 13:36:50 +0800
Message-Id: <1262583410.4633.98.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-2.fc9) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cjtlXywonB/LAebr3DH3
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Hi,
   My box can work well before suspend/resume. But it will complain the
following warning message after suspend/resume. 
   >[1266874868.022103] Enabling non-boot CPUs ...
[1266874868.022198] BUG: soft lockup - CPU#0 stuck for 0s! [kthreadd:2]

    At the same time after I add the boot option of "printk.time=1", I
find that the log time is changed spontaneously from 76 to 1266874868.
    > [   76.475266] CPU3 is down
[   76.475312] Extended CMOS year: 2000
[1266874868.020631] x86 PAT enabled: cpu 0, old 0x7040600070406, new
0x7010600070106
[1266874868.021779] Back to C!
[1266874868.022003] CPU0: Thermal LVT vector (0xfa) already installed
[1266874868.022060] Extended CMOS year: 2000

    More detailed info can be found in the attached file of
dmesg_after_origin.

   After I look at the source code, I find that on this box the TSC runs
at constant rate with P/T states and does not stop in deep C-states. And
then the sched_clock_stable is set to 1. In such case the TSC time is
used directly in the function of sched_clock_cpu. 
   
   Then I do another test on this box, in which the clock_stable flag is
saved/restored in course of suspend/resume(I add this by using per-cpu
structure). When entering the suspended state, the clock_stable will be
cleared. And when the system is resumed, the clock_stable will be set
again. But unfortunately the soft lockup still exists. The file of
dmesg_after_test2 is the dmesg log after I save/restore the clock_stable
flag in course of suspend/resume.

   How about clearing the sched_clock_stable flag even when TSC doesn't
stop in deep C-state?  From my test it seems that the TSC value is
unknown after doing suspend/resume. 

Thanks.
   Yakui.


--=-cjtlXywonB/LAebr3DH3
Content-Disposition: attachment; filename=dmesg_after_origin
Content-Type: text/plain; name=dmesg_after_origin; charset=UTF-8
Content-Transfer-Encoding: 7bit

3:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.721748] atl1c 0000:43:00.0: setting latency timer to 64
[   15.721806] atl1c 0000:43:00.0: PME# disabled
[   15.721814] atl1c 0000:43:00.0: PME# disabled
[   15.725327] calling  alsa_pcm_oss_init+0x0/0x8a [snd_pcm_oss] @ 1370
[   15.725354] initcall alsa_pcm_oss_init+0x0/0x8a [snd_pcm_oss] returned 0 after 21 usecs
[   15.728762] calling  alsa_seq_device_init+0x0/0x51 [snd_seq_device] @ 1374
[   15.728773] initcall alsa_seq_device_init+0x0/0x51 [snd_seq_device] returned 0 after 5 usecs
[   15.729908] calling  init_module+0x0/0x27 [intel_agp] @ 1172
[   15.729934] agpgart-intel 0000:00:00.0: Intel IGDNG/M Chipset
[   15.730576] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[   15.735465] calling  alsa_seq_init+0x0/0x51 [snd_seq] @ 1376
[   15.735636] initcall alsa_seq_init+0x0/0x51 [snd_seq] returned 0 after 157 usecs
[   15.738384] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x40000000
[   15.738430] initcall init_module+0x0/0x27 [intel_agp] returned 0 after 8327 usecs
[   15.738795] calling  alsa_seq_midi_event_init+0x0/0x7 [snd_seq_midi_event] @ 1376
[   15.738801] initcall alsa_seq_midi_event_init+0x0/0x7 [snd_seq_midi_event] returned 0 after 0 usecs
[   15.741750] calling  alsa_seq_oss_init+0x0/0x14f [snd_seq_oss] @ 1376
[   15.754158] calling  init_module+0x0/0xef [drm] @ 1167
[   15.754306] [drm] Initialized drm 1.1.0 20060810
[   15.754319] initcall init_module+0x0/0xef [drm] returned 0 after 145 usecs
[   15.755208] calling  alsa_seq_dummy_init+0x0/0xb4 [snd_seq_dummy] @ 1389
[   15.755220] initcall alsa_seq_dummy_init+0x0/0xb4 [snd_seq_dummy] returned 0 after 8 usecs
[   15.758557] calling  alsa_hwdep_init+0x0/0x49 [snd_hwdep] @ 1395
[   15.758566] initcall alsa_hwdep_init+0x0/0x49 [snd_hwdep] returned 0 after 5 usecs
[   15.768919] calling  init_module+0x0/0x2e [hp_accel] @ 1313
[   15.768986] lis3lv02d: laptop model unknown, using default axes configuration
[   15.769787] lis3lv02d: 1-byte sensor found
[   15.778574] input: ST LIS3LV02DL Accelerometer as /class/input/input7
[   15.778609] lis3_init_device: irq 23
[   15.778610] lis3: registering device
[   15.778665] Registered led device: hp::hddprotect
[   15.778686] lis3lv02d driver loaded.
[   15.778690] initcall init_module+0x0/0x2e [hp_accel] returned 0 after 9551 usecs
[   15.802567] atl1c 0000:43:00.0: version 1.0.0.1-NAPI
[   15.802600] initcall init_module+0x0/0x19 [atl1c] returned 0 after 79122 usecs
[   15.807061] calling  alsa_card_azx_init+0x0/0x19 [snd_hda_intel] @ 1410
[   15.810503] calling  init_module+0x0/0xf [joydev] @ 1407
[   15.810646] initcall init_module+0x0/0xf [joydev] returned 0 after 135 usecs
[   15.814454] HDA Intel 0000:00:1b.0: power state changed by ACPI to D0
[   15.814467] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   15.814514] HDA Intel 0000:00:1b.0: setting latency timer to 64
[   15.875833] calling  patch_sigmatel_init+0x0/0xf [snd_hda_codec_idt] @ 1426
[   15.875839] initcall patch_sigmatel_init+0x0/0xf [snd_hda_codec_idt] returned 0 after 0 usecs
[   15.876313] input: HDA Digital PCBeep as /class/input/input8
[   15.882402] calling  patch_intelhdmi_init+0x0/0xf [snd_hda_codec_intelhdmi] @ 1429
[   15.882409] initcall patch_intelhdmi_init+0x0/0xf [snd_hda_codec_intelhdmi] returned 0 after 0 usecs
[   15.884064] ALSA hda_codec.c:2960: HDMI already defined
[   15.886428] input: HDA Intel Mic at Ext Left Jack as /class/input/input9
[   15.886605] input: HDA Intel HP Out at Ext Left Jack as /class/input/input10
[   15.887909] initcall alsa_card_azx_init+0x0/0x19 [snd_hda_intel] returned 0 after 79058 usecs
[   15.980878] calling  init_module+0x0/0x82 [i915] @ 1434
[   15.980911] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   15.980915] i915 0000:00:02.0: setting latency timer to 64
[   15.983817] i915 0000:00:02.0: irq 28 for MSI/MSI-X
[   16.090014] initcall alsa_seq_oss_init+0x0/0x14f [snd_seq_oss] returned 0 after 340575 usecs
[   16.092840] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-D
[   16.486584] i2c-adapter i2c-2: unable to read EDID block.
[   16.486587] i915 0000:00:02.0: DVI-D-1: no EDID data
[   16.542475] [drm] LVDS-8: set mode 1366x768 12
[   16.835733] Console: switching to colour frame buffer device 170x48
[   16.841808] [drm] fb0: inteldrmfb frame buffer device
[   16.846678] acpi device:10: registered as cooling_device4
[   16.847342] input: Video Bus as /class/input/input11
[   16.847372] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[   16.847417] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[   16.847453] initcall init_module+0x0/0x82 [i915] returned 0 after 847457 usecs
[   16.950853] calling  init_module+0x0/0xf [uinput] @ 1500
[   16.950894] initcall init_module+0x0/0xf [uinput] returned 0 after 36 usecs
[   17.047782] calling  init_module+0x0/0x1b [pci_slot] @ 1509
[   17.048382] initcall init_module+0x0/0x1b [pci_slot] returned 0 after 581 usecs
[   17.050568] calling  init_module+0x0/0x15 [sbshc] @ 1511
[   17.050615] initcall init_module+0x0/0x15 [sbshc] returned 0 after 41 usecs
[   17.053500] calling  init_module+0x0/0x46 [sbs] @ 1514
[   17.053540] initcall init_module+0x0/0x46 [sbs] returned 0 after 35 usecs
[   17.347750] md: Autodetecting RAID arrays.
[   17.347752] md: Scanned 0 and added 0 devices.
[   17.347754] md: autorun ...
[   17.347755] md: ... autorun DONE.
[   17.391000] calling  init_module+0x0/0x132 [dm_mod] @ 1523
[   17.391885] device-mapper: ioctl: 4.15.0-ioctl (2009-04-01) initialised: dm-devel@redhat.com
[   17.391894] initcall init_module+0x0/0x132 [dm_mod] returned 0 after 866 usecs
[   17.417649] calling  init_module+0x0/0x49 [dm_log] @ 1533
[   17.417679] initcall init_module+0x0/0x49 [dm_log] returned 0 after 25 usecs
[   17.422964] calling  init_module+0x0/0x69 [dm_mirror] @ 1533
[   17.423144] initcall init_module+0x0/0x69 [dm_mirror] returned 0 after 171 usecs
[   17.734458] EXT3 FS on sda3, internal journal
[   18.157056] EXT4-fs (sda1): barriers enabled
[   18.169977] kjournald2 starting: pid 1687, dev sda1:8, commit interval 5 seconds
[   18.170021] EXT4-fs (sda1): warning: maximal mount count reached, running e2fsck is recommended
[   18.170233] EXT4-fs (sda1): internal journal on sda1:8
[   18.170241] EXT4-fs (sda1): delayed allocation enabled
[   18.170246] EXT4-fs: file extents enabled
[   18.175718] EXT4-fs: mballoc enabled
[   18.175735] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   18.192585] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   18.707648] Adding 5116660k swap on /dev/sda5.  Priority:-1 extents:1 across:5116660k 
[   19.229571] calling  init_module+0x0/0x87 [acpi_cpufreq] @ 1827
[   19.231734] initcall init_module+0x0/0x87 [acpi_cpufreq] returned 0 after 2109 usecs
[   21.082997] calling  init_module+0x0/0x19 [lib80211] @ 2073
[   21.083002] lib80211: common routines for IEEE802.11 drivers
[   21.083033] lib80211_crypt: registered algorithm 'NULL'
[   21.083040] initcall init_module+0x0/0x19 [lib80211] returned 0 after 33 usecs
[   21.109179] wl: module license 'unspecified' taints kernel.
[   21.109185] Disabling lock debugging due to kernel taint
[   21.112792] calling  wl_module_init+0x0/0x19 [wl] @ 2073
[   21.113175] initcall wl_module_init+0x0/0x19 [wl] returned 0 after 339 usecs
[   21.142560] calling  init_module+0x0/0x45 [usb_storage] @ 2070
[   21.142565] Initializing USB Mass Storage driver...
[   21.142620] usbcore: registered new interface driver usb-storage
[   21.142625] USB Mass Storage support registered.
[   21.142636] initcall init_module+0x0/0x45 [usb_storage] returned 0 after 63 usecs
[   22.019333] calling  init_module+0x0/0x277 [ipv6] @ 2121
[   22.019908] NET: Registered protocol family 10
[   22.020585] lo: Disabled Privacy Extensions
[   22.021363] initcall init_module+0x0/0x277 [ipv6] returned 0 after 1971 usecs
[   22.261908] [i915_drv:i915_driver_open], 
[   22.262612] [i915_drv:i915_driver_open], 
[   22.415793] i2c-adapter i2c-2: unable to read EDID block.
[   22.415796] i915 0000:00:02.0: DVI-D-1: no EDID data
[   22.420426] i2c-adapter i2c-2: unable to read EDID block.
[   22.420428] i915 0000:00:02.0: DVI-D-1: no EDID data
[   22.554000] i2c-adapter i2c-2: unable to read EDID block.
[   22.554002] i915 0000:00:02.0: DVI-D-1: no EDID data
[   22.558634] i2c-adapter i2c-2: unable to read EDID block.
[   22.558636] i915 0000:00:02.0: DVI-D-1: no EDID data
[   26.854167] calling  init_module+0x0/0x75 [rfkill] @ 2305
[   26.854737] initcall init_module+0x0/0x75 [rfkill] returned 0 after 541 usecs
[   26.901738] calling  init_module+0x0/0x50 [bluetooth] @ 2305
[   26.901741] Bluetooth: Core ver 2.15
[   26.902065] NET: Registered protocol family 31
[   26.902067] Bluetooth: HCI device and connection manager initialized
[   26.902069] Bluetooth: HCI socket layer initialized
[   26.902075] initcall init_module+0x0/0x50 [bluetooth] returned 0 after 322 usecs
[   26.942662] calling  init_module+0x0/0xbc [l2cap] @ 2313
[   26.942672] Bluetooth: L2CAP ver 2.13
[   26.942676] Bluetooth: L2CAP socket layer initialized
[   26.942683] initcall init_module+0x0/0xbc [l2cap] returned 0 after 11 usecs
[   27.010409] calling  init_module+0x0/0x6c [bnep] @ 2316
[   27.010416] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.010419] Bluetooth: BNEP filters: protocol multicast
[   27.010427] initcall init_module+0x0/0x6c [bnep] returned 0 after 8 usecs
[   27.217069] calling  init_module+0x0/0xb4 [bridge] @ 2319
[   27.217258] Bridge firewalling registered
[   27.217280] initcall init_module+0x0/0xb4 [bridge] returned 0 after 188 usecs
[   27.245154] calling  init_module+0x0/0xc2 [sco] @ 2325
[   27.245165] Bluetooth: SCO (Voice Link) ver 0.6
[   27.245168] Bluetooth: SCO socket layer initialized
[   27.245175] initcall init_module+0x0/0xc2 [sco] returned 0 after 11 usecs
[   29.953141] atl1c 0000:43:00.0: irq 29 for MSI/MSI-X
[   29.953247] atl1c 0000:43:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
[   40.324809] eth0: no IPv6 routers present
[   74.919926] PM: Syncing filesystems ... done.
[   74.936683] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   74.937262] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   74.937472] Suspending console(s) (use no_console_suspend to debug)
[   74.938108] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   75.059056] sd 0:0:0:0: [sda] Stopping disk
[   76.106356] atl1c 0000:43:00.0: wake-up capability disabled by ACPI
[   76.106367] atl1c 0000:43:00.0: PME# disabled
[   76.106379] atl1c 0000:43:00.0: PCI INT A disabled
[   76.160918] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[   76.363695] HDA Intel 0000:00:1b.0: PCI INT A disabled
[   76.382303] HDA Intel 0000:00:1b.0: power state changed by ACPI to D3
[   76.382319] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[   76.421920] ehci_hcd 0000:00:1d.0: PME# disabled
[   76.432843] ehci_hcd 0000:00:1a.0: PME# disabled
[   76.443789] ACPI: Preparing to enter system sleep state S3
[   76.455649] Disabling non-boot CPUs ...
[   76.456755] Breaking affinity for irq 12
[   76.457972] CPU 1 is now offline
[   76.458201] CPU0 attaching NULL sched-domain.
[   76.458204] CPU1 attaching NULL sched-domain.
[   76.458205] CPU2 attaching NULL sched-domain.
[   76.458207] CPU3 attaching NULL sched-domain.
[   76.462488] CPU0 attaching sched-domain:
[   76.462493]  domain 0: span 0,2-3 level MC
[   76.462497]   groups: 0 2-3
[   76.462505] CPU2 attaching sched-domain:
[   76.462509]  domain 0: span 2-3 level SIBLING
[   76.462512]   groups: 2 3
[   76.462518]   domain 1: span 0,2-3 level MC
[   76.462522]    groups: 2-3 0
[   76.462529] CPU3 attaching sched-domain:
[   76.462532]  domain 0: span 2-3 level SIBLING
[   76.462535]   groups: 3 2
[   76.462541]   domain 1: span 0,2-3 level MC
[   76.462544]    groups: 2-3 0
[   76.463099] CPU1 is down
[   76.464174] Breaking affinity for irq 9
[   76.464242] Breaking affinity for irq 27
[   76.465294] CPU 2 is now offline
[   76.465515] CPU0 attaching NULL sched-domain.
[   76.465518] CPU2 attaching NULL sched-domain.
[   76.465520] CPU3 attaching NULL sched-domain.
[   76.469475] CPU0 attaching sched-domain:
[   76.469479]  domain 0: span 0,3 level MC
[   76.469483]   groups: 0 3
[   76.469490] CPU3 attaching sched-domain:
[   76.469493]  domain 0: span 0,3 level MC
[   76.469497]   groups: 3 0
[   76.469862] CPU2 is down
[   76.470912] Breaking affinity for irq 1
[   76.472033] CPU 3 is now offline
[   76.472034] lockdep: fixing up alternatives.
[   76.472036] SMP alternatives: switching to UP code
[   76.475078] CPU0 attaching NULL sched-domain.
[   76.475081] CPU3 attaching NULL sched-domain.
[   76.475089] CPU0 attaching NULL sched-domain.
[   76.475266] CPU3 is down
[   76.475312] Extended CMOS year: 2000
[1266874868.020631] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[1266874868.021779] Back to C!
[1266874868.022003] CPU0: Thermal LVT vector (0xfa) already installed
[1266874868.022060] Extended CMOS year: 2000
[1266874868.022103] Enabling non-boot CPUs ...
[1266874868.022198] BUG: soft lockup - CPU#0 stuck for 0s! [kthreadd:2]
[1266874868.022200] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874868.022231] 
[1266874868.022234] Pid: 2, comm: kthreadd Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874868.022236] EIP: 0060:[<c0712942>] EFLAGS: 00000202 CPU: 0
[1266874868.022243] EIP is at _spin_unlock_irq+0x1f/0x21
[1266874868.022245] EAX: 00000000 EBX: c1b56660 ECX: c0423b82 EDX: 00007372
[1266874868.022246] ESI: 00000000 EDI: eb186460 EBP: f6c67f34 ESP: f6c67f34
[1266874868.022248]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874868.022250] CR0: 8005003b CR2: 006f80a0 CR3: 2b11a000 CR4: 000006d0
[1266874868.022252] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874868.022253] DR6: ffff0ff0 DR7: 00000400
[1266874868.022255] Call Trace:
[1266874868.022261]  [<c0423b82>] finish_task_switch+0x67/0xdc
[1266874868.022264]  [<c0423b4c>] ? finish_task_switch+0x31/0xdc
[1266874868.022267]  [<c0710c65>] schedule+0x7f9/0x855
[1266874868.022271]  [<c043e15d>] kthreadd+0x75/0xe8
[1266874868.022274]  [<c043e0e8>] ? kthreadd+0x0/0xe8
[1266874868.022277]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874868.022334] lockdep: fixing up alternatives.
[1266874868.022335] SMP alternatives: switching to SMP code
[1266874868.025164] Booting processor 1 APIC 0x1 ip 0x6000
[1266874868.035280] Initializing CPU#1
[1266874868.095089] Calibrating delay using timer specific routine.. 4800.72 BogoMIPS (lpj=2400363)
[1266874868.095097] CPU: Physical Processor ID: 0
[1266874868.095099] CPU: Processor Core ID: 0
[1266874868.095102] CPU: L1 I cache: 32K, L1 D cache: 32K
[1266874868.095104] CPU: L2 cache: 256K
[1266874868.095105] CPU: L3 cache: 3072K
[1266874868.095109] mce: CPU supports 9 MCE banks
[1266874868.095118] CPU1: Thermal monitoring enabled (TM1)
[1266874868.095122] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6
[1266874868.096134] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[1266874868.097669] CPU1: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[1266874868.097680] Skipping synchronization checks as TSC is reliable.
[1266874868.097874] CPU0 attaching NULL sched-domain.
[1266874868.098096] Switched to NOHz mode on CPU #1
[1266874868.099089] BUG: soft lockup - CPU#1 stuck for 0s! [swapper:0]
[1266874868.099093] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874868.099163] 
[1266874868.099169] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874868.099174] EIP: 0060:[<c04085b0>] EFLAGS: 00000246 CPU: 1
[1266874868.099182] EIP is at mwait_idle+0x86/0xb5
[1266874868.099184] EAX: 00000000 EBX: f6c90000 ECX: 00000000 EDX: 00000000
[1266874868.099186] ESI: f6c90000 EDI: c08f97e4 EBP: f6c91f98 ESP: f6c91f78
[1266874868.099188]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874868.099189] CR0: 8005003b CR2: 00000000 CR3: 00957000 CR4: 000006d0
[1266874868.099191] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874868.099193] DR6: ffff0ff0 DR7: 00000400
[1266874868.099194] Call Trace:
[1266874868.099200]  [<c044822d>] ? tick_nohz_restart_sched_tick+0x27/0x12a
[1266874868.099203]  [<c0401b09>] cpu_idle+0x47/0x59
[1266874868.099207]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874868.101142] CPU0 attaching sched-domain:
[1266874868.101147]  domain 0: span 0-1 level SIBLING
[1266874868.101151]   groups: 0 1
[1266874868.101159] CPU1 attaching sched-domain:
[1266874868.101162]  domain 0: span 0-1 level SIBLING
[1266874868.101166]   groups: 1 0
[1266874868.101644] CPU1 is up
[1266874868.101797] lockdep: fixing up alternatives.
[1266874868.101801] Booting processor 2 APIC 0x4 ip 0x6000
[1266874868.111906] Initializing CPU#2
[1266874868.171979] Calibrating delay using timer specific routine.. 4800.70 BogoMIPS (lpj=2400354)
[1266874868.171987] CPU: Physical Processor ID: 0
[1266874868.171988] CPU: Processor Core ID: 2
[1266874868.171991] CPU: L1 I cache: 32K, L1 D cache: 32K
[1266874868.171992] CPU: L2 cache: 256K
[1266874868.171994] CPU: L3 cache: 3072K
[1266874868.171996] mce: CPU supports 9 MCE banks
[1266874868.172005] CPU2: Thermal monitoring enabled (TM1)
[1266874868.172008] CPU 2 MCA banks SHD:6
[1266874868.172794] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[1266874868.173932] CPU2: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[1266874868.173946] Skipping synchronization checks as TSC is reliable.
[1266874868.173985] Switched to NOHz mode on CPU #2
[1266874868.174026] CPU0 attaching NULL sched-domain.
[1266874868.174029] CPU1 attaching NULL sched-domain.
[1266874868.177997] CPU0 attaching sched-domain:
[1266874868.178001]  domain 0: span 0-1 level SIBLING
[1266874868.178005]   groups: 0 1
[1266874868.178011]   domain 1: span 0-2 level MC
[1266874868.178015]    groups: 0-1 2
[1266874868.178022] CPU1 attaching sched-domain:
[1266874868.178026]  domain 0: span 0-1 level SIBLING
[1266874868.178029]   groups: 1 0
[1266874868.178035]   domain 1: span 0-2 level MC
[1266874868.178038]    groups: 0-1 2
[1266874868.178045] CPU2 attaching sched-domain:
[1266874868.178048]  domain 0: span 0-2 level MC
[1266874868.178052]   groups: 2 0-1
[1266874868.178766] CPU2 is up
[1266874868.178923] lockdep: fixing up alternatives.
[1266874868.178928] Booting processor 3 APIC 0x5 ip 0x6000
[1266874868.189033] Initializing CPU#3
[1266874868.248870] Calibrating delay using timer specific routine.. 4800.74 BogoMIPS (lpj=2400371)
[1266874868.248878] CPU: Physical Processor ID: 0
[1266874868.248879] CPU: Processor Core ID: 2
[1266874868.248882] CPU: L1 I cache: 32K, L1 D cache: 32K
[1266874868.248883] CPU: L2 cache: 256K
[1266874868.248884] CPU: L3 cache: 3072K
[1266874868.248887] mce: CPU supports 9 MCE banks
[1266874868.248896] CPU3: Thermal monitoring enabled (TM1)
[1266874868.248899] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6
[1266874868.249957] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[1266874868.251558] CPU3: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[1266874868.251572] Skipping synchronization checks as TSC is reliable.
[1266874868.251637] CPU0 attaching NULL sched-domain.
[1266874868.251640] CPU1 attaching NULL sched-domain.
[1266874868.251642] CPU2 attaching NULL sched-domain.
[1266874868.251875] Switched to NOHz mode on CPU #3
[1266874868.252869] BUG: soft lockup - CPU#3 stuck for 0s! [swapper:0]
[1266874868.252872] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874868.252935] 
[1266874868.252940] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874868.252945] EIP: 0060:[<c04085b0>] EFLAGS: 00000246 CPU: 3
[1266874868.252953] EIP is at mwait_idle+0x86/0xb5
[1266874868.252959] EAX: 00000000 EBX: f6ca8000 ECX: 00000000 EDX: 00000000
[1266874868.252961] ESI: f6ca8000 EDI: c08f97e4 EBP: f6ca9f98 ESP: f6ca9f78
[1266874868.252963]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874868.252965] CR0: 8005003b CR2: 00000000 CR3: 00957000 CR4: 000006d0
[1266874868.252966] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874868.252968] DR6: ffff0ff0 DR7: 00000400
[1266874868.252970] Call Trace:
[1266874868.252975]  [<c044822d>] ? tick_nohz_restart_sched_tick+0x27/0x12a
[1266874868.252979]  [<c0401b09>] cpu_idle+0x47/0x59
[1266874868.252983]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874868.254885] CPU0 attaching sched-domain:
[1266874868.254889]  domain 0: span 0-1 level SIBLING
[1266874868.254893]   groups: 0 1
[1266874868.254899]   domain 1: span 0-3 level MC
[1266874868.254903]    groups: 0-1 2-3
[1266874868.254910] CPU1 attaching sched-domain:
[1266874868.254914]  domain 0: span 0-1 level SIBLING
[1266874868.254917]   groups: 1 0
[1266874868.254923]   domain 1: span 0-3 level MC
[1266874868.254927]    groups: 0-1 2-3
[1266874868.254934] CPU2 attaching sched-domain:
[1266874868.254937]  domain 0: span 2-3 level SIBLING
[1266874868.254941]   groups: 2 3
[1266874868.254946]   domain 1: span 0-3 level MC
[1266874868.254950]    groups: 2-3 0-1
[1266874868.254958] CPU3 attaching sched-domain:
[1266874868.254960]  domain 0: span 2-3 level SIBLING
[1266874868.254961]   groups: 3 2
[1266874868.254964]   domain 1: span 0-3 level MC
[1266874868.254965]    groups: 2-3 0-1
[1266874868.255864] BUG: soft lockup - CPU#1 stuck for 0s! [bash:2504]
[1266874868.255865] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874868.255891] 
[1266874868.255893] Pid: 2504, comm: bash Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874868.255896] EIP: 0060:[<c05bcc51>] EFLAGS: 00000202 CPU: 1
[1266874868.255900] EIP is at acpi_processor_notify_smm+0xd1/0xe1
[1266874868.255902] EAX: c1b6a250 EBX: 00000000 ECX: f3358f00 EDX: 00000001
[1266874868.255903] ESI: f81986c0 EDI: 0000000b EBP: eb161d4c ESP: eb161d44
[1266874868.255905]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874868.255907] CR0: 8005003b CR2: 00000000 CR3: 2b11a000 CR4: 000006d0
[1266874868.255909] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874868.255910] DR6: ffff0ff0 DR7: 00000400
[1266874868.255911] Call Trace:
[1266874868.255916]  [<f8197879>] 0xf8197879
[1266874868.255920]  [<c067c0aa>] cpufreq_add_dev+0x197/0x54e
[1266874868.255926]  [<c04350e5>] ? add_timer_on+0x46/0x73
[1266874868.255928]  [<c043510c>] ? add_timer_on+0x6d/0x73
[1266874868.255932]  [<c043ae26>] ? queue_delayed_work_on+0x91/0xa7
[1266874868.255934]  [<c043ae4d>] ? schedule_delayed_work_on+0x11/0x13
[1266874868.255938]  [<c07102e8>] cpufreq_cpu_callback+0x5b/0x65
[1266874868.255942]  [<c044165a>] notifier_call_chain+0x2b/0x4a
[1266874868.255944]  [<c044169b>] __raw_notifier_call_chain+0xe/0x10
[1266874868.255947]  [<c04416a9>] raw_notifier_call_chain+0xc/0xe
[1266874868.255949]  [<c070ec61>] _cpu_up+0xbe/0xf3
[1266874868.255954]  [<c06ff9b9>] enable_nonboot_cpus+0x37/0x89
[1266874868.255957]  [<c0453505>] suspend_devices_and_enter+0xd1/0x139
[1266874868.255960]  [<c0453613>] enter_state+0xa6/0xd9
[1266874868.255962]  [<c0452ef6>] state_store+0x96/0xac
[1266874868.255964]  [<c0452e60>] ? state_store+0x0/0xac
[1266874868.255969]  [<c0566201>] kobj_attr_store+0x1a/0x22
[1266874868.255973]  [<c04e2b3d>] sysfs_write_file+0xb8/0xe3
[1266874868.255976]  [<c04e2a85>] ? sysfs_write_file+0x0/0xe3
[1266874868.255979]  [<c049f6d6>] vfs_write+0x8c/0x141
[1266874868.255981]  [<c049fc7b>] sys_write+0x3b/0x60
[1266874868.255984]  [<c0402a65>] syscall_call+0x7/0xb
[1266874868.256019] CPU3 is up
[1266874868.256021] ACPI: Waking up from system sleep state S3
[1266874868.520409] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874868.520417] i915 0000:00:02.0: restoring config space at offset 0x8 (was 0x1, writing 0x5031)
[1266874868.520424] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900000, writing 0x900407)
[1266874868.520451] pci 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874868.520472] pci 0000:00:16.0: restoring config space at offset 0x4 (was 0x4, writing 0x54706004)
[1266874868.520481] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x180000, writing 0x100006)
[1266874868.520488] BUG: soft lockup - CPU#0 stuck for 0s! [kacpi_notify:176]
[1266874868.520490] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output
[1266874868.520516] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874868.520518]  sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874868.520524] 
[1266874868.520526] Pid: 176, comm: kacpi_notify Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874868.520529] EIP: 0060:[<c056b2d1>] EFLAGS: 00000246 CPU: 0
[1266874868.520533] EIP is at delay_tsc+0x21/0x3f
[1266874868.520535] EAX: 0011f844 EBX: 00125037 ECX: 00000000 EDX: 00000000
[1266874868.520537] ESI: 00000000 EDI: 6589dfc7 EBP: f6d95bd0 ESP: f6d95bc4
[1266874868.520540] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0x54705c00)
[1266874868.520542]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874868.520545] CR0: 8005003b CR2: 006f80a0 CR3: 2b11a000 CR4: 000006d0
[1266874868.520547] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874868.520549] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[1266874868.520552] DR6: ffff0ff0 DR7: 00000400
[1266874868.520553] Call Trace:
[1266874868.520557]  [<c056b27e>] __delay+0x9/0xb
[1266874868.520559]  [<c056b2ae>] __const_udelay+0x2e/0x30
[1266874868.520563]  [<c059db6d>] acpi_ec_transaction+0x317/0x3d9
[1266874868.520568]  [<c0424e29>] ? try_to_wake_up+0x1e5/0x1ef
[1266874868.520571]  [<c059dde9>] acpi_ec_burst_enable+0x30/0x37
[1266874868.520573] ehci_hcd 0000:00:1a.0: PME# disabled
[1266874868.520576]  [<c059de65>] acpi_ec_space_handler+0x59/0x140
[1266874868.520579]  [<c059de0c>] ? acpi_ec_space_handler+0x0/0x140
[1266874868.520584]  [<c05a63b2>] acpi_ev_address_space_dispatch+0x132/0x172
[1266874868.520588]  [<c05aa543>] acpi_ex_access_region+0x1aa/0x1be
[1266874868.520591]  [<c05aa668>] acpi_ex_field_datum_io+0x111/0x197
[1266874868.520594]  [<c05aa780>] acpi_ex_extract_from_field+0x92/0x200
[1266874868.520598]  [<c05b8715>] ? acpi_ut_create_internal_object_dbg+0x18/0x74
[1266874868.520602]  [<c05a943b>] acpi_ex_read_data_from_field+0x105/0x136
[1266874868.520605]  [<c05adfb8>] acpi_ex_resolve_node_to_value+0x154/0x1c8
[1266874868.520608]  [<c05a9d0c>] acpi_ex_resolve_to_value+0x1b7/0x1c3
[1266874868.520611]  [<c05a4c19>] acpi_ds_evaluate_name_path+0x6e/0xe3
[1266874868.520614]  [<c05a3aea>] acpi_ds_exec_end_op+0x7a/0x35c
[1266874868.520617] HDA Intel 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100002)
[1266874868.520622]  [<c05b337f>] acpi_ps_parse_loop+0x5a8/0x72d
[1266874868.520625]  [<c05b27cf>] acpi_ps_parse_aml+0x87/0x281
[1266874868.520627]  [<c05b3ac8>] acpi_ps_execute_method+0x18f/0x233
[1266874868.520631]  [<c05b02eb>] acpi_ns_evaluate+0xcb/0x17c
[1266874868.520633]  [<c05afe29>] acpi_evaluate_object+0x140/0x21d
[1266874868.520638]  [<c059a689>] acpi_evaluate_integer+0x37/0x5f
[1266874868.520643]  [<c066d0df>] ? thermal_zone_device_update+0x1b/0x1eb
[1266874868.520649]  [<c05bd67c>] acpi_thermal_get_temperature+0x2d/0x48
[1266874868.520652]  [<c05bd6b4>] thermal_get_temp+0x1d/0x37
[1266874868.520655]  [<c066d0ed>] thermal_zone_device_update+0x29/0x1eb
[1266874868.520658] pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[1266874868.520661]  [<c05bdc17>] acpi_thermal_check+0xe/0x10
[1266874868.520664]  [<c05be770>] acpi_thermal_notify+0x31/0xa4
[1266874868.520667]  [<c059bd52>] acpi_device_notify+0x12/0x15
[1266874868.520670]  [<c05a6f99>] acpi_ev_notify_dispatch+0x4f/0x5a
[1266874868.520673] pcieport-driver 0000:00:1c.0: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[1266874868.520677]  [<c0599b43>] acpi_os_execute_deferred+0x20/0x2c
[1266874868.520679] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[1266874868.520683]  [<c043b55e>] worker_thread+0x170/0x23c
[1266874868.520686]  [<c043b521>] ? worker_thread+0x133/0x23c
[1266874868.520688] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x54605460)
[1266874868.520692]  [<c0599b23>] ? acpi_os_execute_deferred+0x0/0x2c
[1266874868.520695] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
[1266874868.520699]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874868.520702] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x10100)
[1266874868.520705]  [<c043b3ee>] ? worker_thread+0x0/0x23c
[1266874868.520708]  [<c043e23e>] kthread+0x6e/0x74
[1266874868.520711]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874868.520714] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[1266874868.520718]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874868.520722] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[1266874868.520780] pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
[1266874868.520792] pcieport-driver 0000:00:1c.1: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[1266874868.520798] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[1266874868.520804] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0x54505060)
[1266874868.520810] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x20000000, writing 0x4030)
[1266874868.520816] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x6 (was 0x0, writing 0x420200)
[1266874868.520825] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[1266874868.520833] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[1266874868.520887] pcieport-driver 0000:00:1c.5: restoring config space at offset 0xf (was 0x200, writing 0x20a)
[1266874868.520900] pcieport-driver 0000:00:1c.5: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[1266874868.520906] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[1266874868.520912] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x8 (was 0x0, writing 0x50505050)
[1266874868.520918] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x7 (was 0x20000000, writing 0x2020)
[1266874868.520924] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x6 (was 0x0, writing 0x434300)
[1266874868.520933] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[1266874868.520940] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[1266874868.520990] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874868.521011] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0x54705800)
[1266874868.521021] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[1266874868.521042] ehci_hcd 0000:00:1d.0: PME# disabled
[1266874868.521155] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[1266874868.521202] pci 0000:00:1f.6: restoring config space at offset 0xf (was 0x300, writing 0x30a)
[1266874868.521223] pci 0000:00:1f.6: restoring config space at offset 0x4 (was 0x4, writing 0x54704004)
[1266874868.521232] pci 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[1266874868.521272] atl1c 0000:43:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[1266874868.521298] atl1c 0000:43:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[1266874868.521306] atl1c 0000:43:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[1266874868.637288] i915 0000:00:02.0: PME# disabled
[1266874868.637301] i915 0000:00:02.0: setting latency timer to 64
[1266874868.679447] [drm] LVDS-8: set mode 1366x768 12
[1266874868.680963] pci 0000:00:16.0: PME# disabled
[1266874868.680970] ehci_hcd 0000:00:1a.0: PME# disabled
[1266874868.680976] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[1266874868.680983] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[1266874868.680994] HDA Intel 0000:00:1b.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[1266874868.680999] HDA Intel 0000:00:1b.0: setting latency timer to 64
[1266874868.681028] ehci_hcd 0000:00:1d.0: PME# disabled
[1266874868.681032] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[1266874868.681038] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[1266874868.681048] pci 0000:00:1e.0: setting latency timer to 64
[1266874868.681066] ahci 0000:00:1f.2: setting latency timer to 64
[1266874868.681151] pci 0000:00:1f.6: PME# disabled
[1266874868.681158] atl1c 0000:43:00.0: wake-up capability disabled by ACPI
[1266874868.681163] atl1c 0000:43:00.0: PME# disabled
[1266874868.681165] atl1c 0000:43:00.0: wake-up capability disabled by ACPI
[1266874868.681171] atl1c 0000:43:00.0: PME# disabled
[1266874868.743524] atl1c 0000:43:00.0: irq 29 for MSI/MSI-X
[1266874868.785000] sd 0:0:0:0: [sda] Starting disk
[1266874868.986851] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[1266874868.988852] ata5: SATA link down (SStatus 0 SControl 300)
[1266874868.992078] ata2.00: configured for UDMA/100
[1266874869.061744] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0xf t4
[1266874869.061748] ata2: irq_stat 0x40000001
[1266874869.061758] ata2: hard resetting link
[1266874869.579989] BUG: soft lockup - CPU#0 stuck for 0s! [swapper:0]
[1266874869.579993] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874869.580053] 
[1266874869.580058] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874869.580063] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 0
[1266874869.580073] EIP is at __do_softirq+0x4c/0x14e
[1266874869.580077] EAX: 00000000 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874869.580081] ESI: 00000000 EDI: c1b52138 EBP: c08a7f4c ESP: c08a7f28
[1266874869.580085]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874869.580089] CR0: 8005003b CR2: 006f80a0 CR3: 2b11a000 CR4: 000006d0
[1266874869.580093] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874869.580096] DR6: ffff0ff0 DR7: 00000400
[1266874869.580099] Call Trace:
[1266874869.580108]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874869.580114]  [<c04313d9>] irq_exit+0x29/0x57
[1266874869.580122]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874869.580129]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874869.580137]  [<c044832b>] ? tick_nohz_restart_sched_tick+0x125/0x12a
[1266874869.580142]  [<c0401b14>] cpu_idle+0x52/0x59
[1266874869.580151]  [<c06ff3cb>] rest_init+0x53/0x55
[1266874869.580159]  [<c08fc8c5>] start_kernel+0x2d6/0x2db
[1266874869.580166]  [<c08fc06a>] i386_start_kernel+0x6a/0x6f
[1266874869.783719] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[1266874869.788938] ata2.00: configured for UDMA/100
[1266874869.808319] ata2: EH complete
[1266874870.261237] atl1c 0000:43:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
[1266874871.531234] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[1266874871.537851] ata1.00: configured for UDMA/100
[1266874872.223384] BUG: soft lockup - CPU#0 stuck for 0s! [bash:2504]
[1266874872.223387] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.223437] 
[1266874872.223442] Pid: 2504, comm: bash Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.223447] EIP: 0060:[<c042c89c>] EFLAGS: 00000246 CPU: 0
[1266874872.223453] EIP is at release_console_sem+0x14e/0x187
[1266874872.223457] EAX: 00021aa5 EBX: 00021aa5 ECX: ffffffff EDX: 00021aa5
[1266874872.223461] ESI: 00021a70 EDI: 00021aa5 EBP: eb161eec ESP: eb161ed4
[1266874872.223465]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874872.223469] CR0: 8005003b CR2: 006f80a0 CR3: 2b11a000 CR4: 000006d0
[1266874872.223473] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.223476] DR6: ffff0ff0 DR7: 00000400
[1266874872.223479] Call Trace:
[1266874872.223485]  [<c042caab>] resume_console+0x25/0x27
[1266874872.223492]  [<c045353a>] suspend_devices_and_enter+0x106/0x139
[1266874872.223497]  [<c0453613>] enter_state+0xa6/0xd9
[1266874872.223502]  [<c0452ef6>] state_store+0x96/0xac
[1266874872.223507]  [<c0452e60>] ? state_store+0x0/0xac
[1266874872.223515]  [<c0566201>] kobj_attr_store+0x1a/0x22
[1266874872.223522]  [<c04e2b3d>] sysfs_write_file+0xb8/0xe3
[1266874872.223527]  [<c04e2a85>] ? sysfs_write_file+0x0/0xe3
[1266874872.223533]  [<c049f6d6>] vfs_write+0x8c/0x141
[1266874872.223538]  [<c049fc7b>] sys_write+0x3b/0x60
[1266874872.223543]  [<c0402a65>] syscall_call+0x7/0xb
[1266874872.349749] Restarting tasks ... 
[1266874872.351051] BUG: soft lockup - CPU#1 stuck for 0s! [NetworkManager:2158]
[1266874872.355392] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.357835] 
[1266874872.357840] Pid: 2158, comm: NetworkManager Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.357844] EIP: 0060:[<f81cc8f7>] EFLAGS: 00000286 CPU: 1
[1266874872.357853] EIP is at atl1c_up+0x91e/0x1bcc [atl1c]
[1266874872.357856] EAX: 00000000 EBX: f544a540 ECX: f544a47c EDX: f544a4c0
[1266874872.357860] ESI: 00001744 EDI: f544a3c0 EBP: f314fbe4 ESP: f314fbd8
[1266874872.357863]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874872.357866] CR0: 8005003b CR2: 00000000 CR3: 330e5000 CR4: 000006d0
[1266874872.357869] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.357872] DR6: ffff0ff0 DR7: 00000400
[1266874872.357874] Call Trace:
[1266874872.357883]  [<c069d261>] dev_get_stats+0x2d/0x61
[1266874872.357889]  [<c057201e>] ? nla_reserve+0x37/0x40
[1266874872.357895]  [<c06a838e>] rtnl_fill_ifinfo+0x2bc/0x477
[1266874872.357901]  [<c06a8c5a>] rtnl_dump_ifinfo+0x53/0x83
[1266874872.357906]  [<c06b3b4c>] netlink_dump+0x4e/0x17b
[1266874872.357910]  [<c06b5a7e>] netlink_dump_start+0x154/0x17a
[1266874872.357915]  [<c06a8c07>] ? rtnl_dump_ifinfo+0x0/0x83
[1266874872.357919]  [<c06a89a3>] rtnetlink_rcv_msg+0xbc/0x1b7
[1266874872.357923]  [<c06a8c07>] ? rtnl_dump_ifinfo+0x0/0x83
[1266874872.357927]  [<c06a88e7>] ? rtnetlink_rcv_msg+0x0/0x1b7
[1266874872.357931]  [<c06b4998>] netlink_rcv_skb+0x30/0x75
[1266874872.357935]  [<c06a88df>] rtnetlink_rcv+0x17/0x1f
[1266874872.357939]  [<c06b47c8>] netlink_unicast+0x1bc/0x21d
[1266874872.357943]  [<c06b4f26>] netlink_sendmsg+0x23e/0x24b
[1266874872.357949]  [<c069325d>] sock_sendmsg+0xde/0xf9
[1266874872.357956]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874872.357960]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874872.357968]  [<c04a0589>] ? fget_light+0x38/0xb0
[1266874872.357973]  [<c056b989>] ? copy_from_user+0x31/0x54
[1266874872.357977]  [<c069a8e3>] ? verify_iovec+0x40/0x71
[1266874872.357982]  [<c06933c5>] sys_sendmsg+0x14d/0x1a8
[1266874872.357986]  [<c0693c99>] ? sys_recvmsg+0x172/0x17f
[1266874872.357993]  [<c0712940>] ? _spin_unlock_irq+0x1d/0x21
[1266874872.358000]  [<c043813c>] ? get_signal_to_deliver+0x33c/0x348
[1266874872.358005]  [<c04021d5>] ? do_notify_resume+0x85/0x6e6
[1266874872.358010]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874872.358015]  [<c0694125>] sys_socketcall+0x138/0x165
[1266874872.358020]  [<c0402a71>] ? syscall_exit+0x8/0x1b
[1266874872.358023]  [<c0402a65>] syscall_call+0x7/0xb
[1266874872.358038] BUG: soft lockup - CPU#2 stuck for 0s! [udevd:858]
[1266874872.358040] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.358064] 
[1266874872.358066] Pid: 858, comm: udevd Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.358068] EIP: 0060:[<c044b4df>] EFLAGS: 00000246 CPU: 2
[1266874872.358073] EIP is at lock_release+0x14c/0x155
[1266874872.358075] EAX: f5a436c0 EBX: f5a436c0 ECX: c048aa26 EDX: 00000001
[1266874872.358077] ESI: f69c8bc4 EDI: c048aa26 EBP: f5a4de5c ESP: f5a4de48
[1266874872.358078]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874872.358080] CR0: 8005003b CR2: 08066d64 CR3: 356ee000 CR4: 000006d0
[1266874872.358082] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.358083] DR6: ffff0ff0 DR7: 00000400
[1266874872.358085] Call Trace:
[1266874872.358089]  [<c071267c>] _spin_unlock+0x16/0x20
[1266874872.358092]  [<c048aa26>] unlink_file_vma+0x36/0x3c
[1266874872.358096]  [<c0488f4b>] free_pgtables+0x55/0x95
[1266874872.358098]  [<c048a7b8>] exit_mmap+0xc1/0x11b
[1266874872.358102]  [<c042a3af>] mmput+0x2b/0x94
[1266874872.358104]  [<c042b59d>] copy_process+0xe60/0xf6c
[1266874872.358106]  [<c042b83e>] do_fork+0x11d/0x289
[1266874872.358110]  [<c042ee34>] ? sys_wait4+0x91/0x9b
[1266874872.358112]  [<c04016f1>] sys_clone+0x24/0x2b
[1266874872.358114]  [<c0402a65>] syscall_call+0x7/0xb
[1266874872.360035] BUG: soft lockup - CPU#3 stuck for 0s! [udevd:2652]
[1266874872.360037] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.360071] 
[1266874872.360074] Pid: 2652, comm: udevd Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.360078] EIP: 0060:[<c04ad1e4>] EFLAGS: 00000246 CPU: 3
[1266874872.360083] EIP is at __d_lookup+0x36/0x114
[1266874872.360086] EAX: f6bad0a0 EBX: f6290100 ECX: d7c6bb9d EDX: 00000000
[1266874872.360088] ESI: c1bcc000 EDI: f6293ec4 EBP: f6293e04 ESP: f6293dd4
[1266874872.360091]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874872.360093] CR0: 8005003b CR2: 001d9a90 CR3: 2b02a000 CR4: 000006d0
[1266874872.360095] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.360097] DR6: ffff0ff0 DR7: 00000400
[1266874872.360098] Call Trace:
[1266874872.360102]  [<c04ad1ae>] ? __d_lookup+0x0/0x114
[1266874872.360105]  [<c04a5dea>] do_lookup+0x25/0x154
[1266874872.360108]  [<c04a7c8c>] __link_path_walk+0x70e/0xac1
[1266874872.360110]  [<c04a7330>] ? path_init+0x3f/0x110
[1266874872.360113]  [<c04a8078>] path_walk+0x39/0x72
[1266874872.360115]  [<c04a8132>] do_path_lookup+0x21/0x42
[1266874872.360117]  [<c04a8924>] user_path_at+0x3c/0x67
[1266874872.360120]  [<c04a8932>] ? user_path_at+0x4a/0x67
[1266874872.360122]  [<c04a8932>] ? user_path_at+0x4a/0x67
[1266874872.360125]  [<c04a2508>] vfs_fstatat+0x2d/0x54
[1266874872.360127]  [<c04a2600>] vfs_stat+0x13/0x15
[1266874872.360129]  [<c04a2616>] sys_stat64+0x14/0x28
[1266874872.360132]  [<c04b1b13>] ? mntput_no_expire+0x16/0x8a
[1266874872.360135]  [<c04a5c79>] ? path_put+0x20/0x23
[1266874872.360137]  [<c04a228f>] ? sys_readlinkat+0x77/0x81
[1266874872.360140]  [<c04a22ac>] ? sys_readlink+0x13/0x15
[1266874872.360142]  [<c0402a71>] ? syscall_exit+0x8/0x1b
[1266874872.360145]  [<c0402a65>] syscall_call+0x7/0xb
[1266874872.580780] done.
[1266874872.582718] BUG: soft lockup - CPU#3 stuck for 0s! [pidof:2644]
[1266874872.582720] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.582748] 
[1266874872.582751] Pid: 2644, comm: pidof Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.582753] EIP: 0073:[<00b16f6a>] EFLAGS: 00000246 CPU: 3
[1266874872.582756] EIP is at 0xb16f6a
[1266874872.582758] EAX: 00000000 EBX: 00c10ff4 ECX: 00000001 EDX: 0805faf0
[1266874872.582760] ESI: b773d6c0 EDI: 0805fa58 EBP: bf9e32e8 ESP: bf9e32bc
[1266874872.582762]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874872.582764] CR0: 8005003b CR2: b775f000 CR3: 2b01a000 CR4: 000006d0
[1266874872.582765] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.582767] DR6: ffff0ff0 DR7: 00000400
[1266874872.582768] Call Trace:
[1266874872.645629] BUG: soft lockup - CPU#0 stuck for 0s! [dmesg:2658]
[1266874872.645695] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.646340] 
[1266874872.646361] Pid: 2658, comm: dmesg Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.646450] EIP: 0073:[<00b34657>] EFLAGS: 00000202 CPU: 0
[1266874872.646504] EIP is at 0xb34657
[1266874872.646536] EAX: 00000000 EBX: 00c32ff4 ECX: 00000001 EDX: 00c340d0
[1266874872.646597] ESI: 00c334c0 EDI: b77746c0 EBP: bfceed08 ESP: bfceecf4
[1266874872.646660]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874872.646712] CR0: 8005003b CR2: b77726c5 CR3: 33121000 CR4: 000006d0
[1266874872.646771] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.646831] DR6: ffff0ff0 DR7: 00000400
[1266874872.646872] Call Trace:
[1266874872.653794] usb 2-1.3: new high speed USB device using ehci_hcd and address 3
[1266874872.751506] usb 2-1.3: New USB device found, idVendor=0bda, idProduct=0158
[1266874872.751513] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1266874872.751518] usb 2-1.3: Product: USB2.0-CRW
[1266874872.751521] usb 2-1.3: Manufacturer: Generic
[1266874872.751525] usb 2-1.3: SerialNumber: 20071114173400000
[1266874872.751664] usb 2-1.3: configuration #1 chosen from 1 choice
[1266874872.753481] BUG: soft lockup - CPU#2 stuck for 0s! [hald:1945]
[1266874872.753621] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.756724] scsi6 : SCSI emulation for USB Mass Storage devices
[1266874872.756985] usb-storage: device found at 3
[1266874872.756988] usb-storage: waiting for device to settle before scanning
[1266874872.760780] 
[1266874872.766511] Pid: 1945, comm: hald Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.772446] EIP: 0060:[<c044ab38>] EFLAGS: 00000296 CPU: 2
[1266874872.778403] EIP is at lock_acquire+0x9e/0xa6
[1266874872.784329] EAX: f59b8000 EBX: 00000246 ECX: 00000000 EDX: 00000000
[1266874872.790363] ESI: 00000000 EDI: 00000000 EBP: f6fe3dd0 ESP: f6fe3dc0
[1266874872.796394]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874872.802319] CR0: 8005003b CR2: f95823c4 CR3: 365db000 CR4: 000006d0
[1266874872.808225] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.814085] DR6: ffff0ff0 DR7: 00000400
[1266874872.819769] Call Trace:
[1266874872.825418]  [<c0712720>] _spin_lock+0x1b/0x2a
[1266874872.830920]  [<c04ad22e>] ? __d_lookup+0x80/0x114
[1266874872.836233]  [<c04ad22e>] __d_lookup+0x80/0x114
[1266874872.841350]  [<c04a5dea>] do_lookup+0x25/0x154
[1266874872.846277]  [<c04a784a>] __link_path_walk+0x2cc/0xac1
[1266874872.851226]  [<c04a7330>] ? path_init+0x3f/0x110
[1266874872.856112]  [<c04a8078>] path_walk+0x39/0x72
[1266874872.860911]  [<c04a8132>] do_path_lookup+0x21/0x42
[1266874872.865714]  [<c04a8b12>] do_filp_open+0xd2/0x6fa
[1266874872.870474]  [<c04b067f>] ? alloc_fd+0x22/0xca
[1266874872.875201]  [<c04b071d>] ? alloc_fd+0xc0/0xca
[1266874872.879879]  [<c049da0f>] do_sys_open+0x4a/0xe7
[1266874872.884517]  [<c049daee>] sys_open+0x1e/0x26
[1266874872.889135]  [<c0402a65>] syscall_call+0x7/0xb
[1266874872.893735] BUG: soft lockup - CPU#1 stuck for 0s! [swapper:0]
[1266874872.896274] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874872.896313] 
[1266874872.896317] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874872.896320] EIP: 0060:[<c0712942>] EFLAGS: 00000286 CPU: 1
[1266874872.896325] EIP is at _spin_unlock_irq+0x1f/0x21
[1266874872.896328] EAX: 00000001 EBX: c1b66660 ECX: c0423b82 EDX: 00008483
[1266874872.896330] ESI: f5b2df80 EDI: eb051240 EBP: f6c91efc ESP: f6c91efc
[1266874872.896333]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874872.896336] CR0: 8005003b CR2: 00179420 CR3: 00957000 CR4: 000006d0
[1266874872.896339] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874872.896341] DR6: ffff0ff0 DR7: 00000400
[1266874872.896343] Call Trace:
[1266874872.896349]  [<c0423b82>] finish_task_switch+0x67/0xdc
[1266874872.896353]  [<c0423b4c>] ? finish_task_switch+0x31/0xdc
[1266874872.896357]  [<c0710c65>] schedule+0x7f9/0x855
[1266874872.896362]  [<c044222f>] ? sched_clock_idle_wakeup_event+0x16/0x18
[1266874872.896367]  [<c044822d>] ? tick_nohz_restart_sched_tick+0x27/0x12a
[1266874872.896371]  [<c0401b19>] cpu_idle+0x57/0x59
[1266874872.896375]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874873.742078] BUG: soft lockup - CPU#0 stuck for 0s! [bash:2504]
[1266874873.742084] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874873.742155] 
[1266874873.742161] Pid: 2504, comm: bash Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874873.742166] EIP: 0060:[<c058de00>] EFLAGS: 00000297 CPU: 0
[1266874873.742173] EIP is at bit_putcs+0x2ea/0x520
[1266874873.742177] EAX: 000000ce EBX: f5514315 ECX: f5fd2078 EDX: 00000000
[1266874873.742181] ESI: f5514315 EDI: f5fd2078 EBP: eb161d04 ESP: eb161c2c
[1266874873.742185]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874873.742189] CR0: 8005003b CR2: 005c16f4 CR3: 2b11a000 CR4: 000006d0
[1266874873.742193] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874873.742197] DR6: ffff0ff0 DR7: 00000400
[1266874873.742200] Call Trace:
[1266874873.742209]  [<c0403049>] ? common_interrupt+0x29/0x30
[1266874873.742215]  [<c058e72c>] ? soft_cursor+0x18c/0x198
[1266874873.742221]  [<c058e4c7>] ? bit_cursor+0x491/0x4a6
[1266874873.742228]  [<c05801ff>] ? pci_disable_msix+0x24/0x2b
[1266874873.742235]  [<c0589062>] fbcon_putcs+0x1f5/0x23e
[1266874873.742240]  [<c058db16>] ? bit_putcs+0x0/0x520
[1266874873.742246]  [<c058a7d8>] fbcon_redraw+0xbb/0x13d
[1266874873.742251]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874873.742257]  [<c058c770>] fbcon_scroll+0x5f5/0xb90
[1266874873.742264]  [<c05d410e>] scrup+0x57/0xbe
[1266874873.742271]  [<c044194c>] ? __atomic_notifier_call_chain+0x52/0x5c
[1266874873.742277]  [<c05d41d4>] lf+0x1b/0x47
[1266874873.742282]  [<c05d636a>] do_con_write+0x838/0x1878
[1266874873.742290]  [<c05c9b2c>] ? process_output+0x19/0x41
[1266874873.742296]  [<c05d73eb>] con_write+0xc/0x1b
[1266874873.742301]  [<c05c97a1>] do_output_char+0x94/0x1a9
[1266874873.742306]  [<c05c9b41>] process_output+0x2e/0x41
[1266874873.742312]  [<c05ca286>] n_tty_write+0x224/0x2e5
[1266874873.742319]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874873.742325]  [<c05c7fdd>] tty_write+0x14d/0x1c4
[1266874873.742330]  [<c05ca062>] ? n_tty_write+0x0/0x2e5
[1266874873.742335]  [<c05c7e90>] ? tty_write+0x0/0x1c4
[1266874873.742341]  [<c049f6d6>] vfs_write+0x8c/0x141
[1266874873.742346]  [<c049fc7b>] sys_write+0x3b/0x60
[1266874873.742351]  [<c0402a65>] syscall_call+0x7/0xb
[1266874874.384163] BUG: soft lockup - CPU#1 stuck for 0s! [swapper:0]
[1266874874.388169] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874874.388256] 
[1266874874.388263] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874874.388270] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 1
[1266874874.388280] EIP is at __do_softirq+0x4c/0x14e
[1266874874.388286] EAX: 00000001 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874874.388292] ESI: 00000000 EDI: c08f97e4 EBP: f6c91f34 ESP: f6c91f10
[1266874874.388298]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874874.388304] CR0: 8005003b CR2: 00119a56 CR3: 33283000 CR4: 000006d0
[1266874874.388310] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874874.388315] DR6: ffff0ff0 DR7: 00000400
[1266874874.388319] Call Trace:
[1266874874.388329]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874874.388339]  [<c04313d9>] irq_exit+0x29/0x57
[1266874874.388349]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874874.388359]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874874.388369]  [<c044007b>] ? posix_cpu_clock_get+0xa3/0x12c
[1266874874.388380]  [<c071046c>] ? schedule+0x0/0x855
[1266874874.388388]  [<c0401b19>] ? cpu_idle+0x57/0x59
[1266874874.388397]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874875.121117] BUG: soft lockup - CPU#0 stuck for 0s! [bash:2504]
[1266874875.121121] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874875.121172] 
[1266874875.121177] Pid: 2504, comm: bash Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874875.121182] EIP: 0060:[<c0597275>] EFLAGS: 00000213 CPU: 0
[1266874875.121190] EIP is at cfb_imageblit+0x1d9/0x4f4
[1266874875.121194] EAX: 00000000 EBX: 0000000a ECX: f8e948f0 EDX: 00000003
[1266874875.121198] ESI: f5fd2f93 EDI: f6ec7800 EBP: eb161c24 ESP: eb161b88
[1266874875.121202]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874875.121206] CR0: 8005003b CR2: 080f6310 CR3: 2b11a000 CR4: 000006d0
[1266874875.121210] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874875.121213] DR6: ffff0ff0 DR7: 00000400
[1266874875.121215] Call Trace:
[1266874875.121226]  [<c058dfcd>] bit_putcs+0x4b7/0x520
[1266874875.121234]  [<c0712940>] ? _spin_unlock_irq+0x1d/0x21
[1266874875.121241]  [<c0423b4c>] ? finish_task_switch+0x31/0xdc
[1266874875.121249]  [<c0589062>] fbcon_putcs+0x1f5/0x23e
[1266874875.121254]  [<c058db16>] ? bit_putcs+0x0/0x520
[1266874875.121260]  [<c058a7d8>] fbcon_redraw+0xbb/0x13d
[1266874875.121265]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874875.121271]  [<c058c770>] fbcon_scroll+0x5f5/0xb90
[1266874875.121278]  [<c05d410e>] scrup+0x57/0xbe
[1266874875.121284]  [<c044194c>] ? __atomic_notifier_call_chain+0x52/0x5c
[1266874875.121289]  [<c05d41d4>] lf+0x1b/0x47
[1266874875.121295]  [<c05d636a>] do_con_write+0x838/0x1878
[1266874875.121302]  [<c05c9b2c>] ? process_output+0x19/0x41
[1266874875.121308]  [<c05d73eb>] con_write+0xc/0x1b
[1266874875.121313]  [<c05c97a1>] do_output_char+0x94/0x1a9
[1266874875.121318]  [<c05c9b41>] process_output+0x2e/0x41
[1266874875.121323]  [<c05ca286>] n_tty_write+0x224/0x2e5
[1266874875.121329]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874875.121335]  [<c05c7fdd>] tty_write+0x14d/0x1c4
[1266874875.121340]  [<c05ca062>] ? n_tty_write+0x0/0x2e5
[1266874875.121345]  [<c05c7e90>] ? tty_write+0x0/0x1c4
[1266874875.121350]  [<c049f6d6>] vfs_write+0x8c/0x141
[1266874875.121355]  [<c049fc7b>] sys_write+0x3b/0x60
[1266874875.121361]  [<c0402a65>] syscall_call+0x7/0xb
[1266874875.297861] BUG: soft lockup - CPU#3 stuck for 0s! [ls:2677]
[1266874875.297863] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874875.297889] 
[1266874875.297891] Pid: 2677, comm: ls Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874875.297894] EIP: 0060:[<c059728b>] EFLAGS: 00000246 CPU: 3
[1266874875.297898] EIP is at cfb_imageblit+0x1ef/0x4f4
[1266874875.297900] EAX: 00000000 EBX: 0000008a ECX: c0732e38 EDX: 00000002
[1266874875.297902] ESI: f5fd3844 EDI: f6ec7800 EBP: eb1b3c24 ESP: eb1b3b88
[1266874875.297903]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874875.297905] CR0: 8005003b CR2: 00000000 CR3: 2b013000 CR4: 000006d0
[1266874875.297907] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874875.297908] DR6: ffff0ff0 DR7: 00000400
[1266874875.297910] Call Trace:
[1266874875.297915]  [<c058dfcd>] bit_putcs+0x4b7/0x520
[1266874875.297918]  [<c058e72c>] ? soft_cursor+0x18c/0x198
[1266874875.297920]  [<c058e4c7>] ? bit_cursor+0x491/0x4a6
[1266874875.297924]  [<c05801ff>] ? pci_disable_msix+0x24/0x2b
[1266874875.297927]  [<c0589062>] fbcon_putcs+0x1f5/0x23e
[1266874875.297930]  [<c058db16>] ? bit_putcs+0x0/0x520
[1266874875.297932]  [<c058a7d8>] fbcon_redraw+0xbb/0x13d
[1266874875.297935]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874875.297938]  [<c058c770>] fbcon_scroll+0x5f5/0xb90
[1266874875.297941]  [<c05d410e>] scrup+0x57/0xbe
[1266874875.297944]  [<c044194c>] ? __atomic_notifier_call_chain+0x52/0x5c
[1266874875.297947]  [<c05d41d4>] lf+0x1b/0x47
[1266874875.297949]  [<c05d636a>] do_con_write+0x838/0x1878
[1266874875.297953]  [<c05c9b2c>] ? process_output+0x19/0x41
[1266874875.297955]  [<c05d73eb>] con_write+0xc/0x1b
[1266874875.297958]  [<c05c97a1>] do_output_char+0x94/0x1a9
[1266874875.297960]  [<c05c9b41>] process_output+0x2e/0x41
[1266874875.297962]  [<c05ca286>] n_tty_write+0x224/0x2e5
[1266874875.297966]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874875.297968]  [<c05c7fdd>] tty_write+0x14d/0x1c4
[1266874875.297971]  [<c05ca062>] ? n_tty_write+0x0/0x2e5
[1266874875.297973]  [<c05c7e90>] ? tty_write+0x0/0x1c4
[1266874875.297976]  [<c049f6d6>] vfs_write+0x8c/0x141
[1266874875.297978]  [<c049fc7b>] sys_write+0x3b/0x60
[1266874875.297980]  [<c0402a65>] syscall_call+0x7/0xb
[1266874876.493174] BUG: soft lockup - CPU#1 stuck for 0s! [swapper:0]
[1266874876.496930] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874876.497014] 
[1266874876.497021] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874876.497027] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 1
[1266874876.497038] EIP is at __do_softirq+0x4c/0x14e
[1266874876.497043] EAX: 00000001 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874876.497048] ESI: 00000000 EDI: c1b62138 EBP: f6c91f24 ESP: f6c91f00
[1266874876.497054]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874876.497059] CR0: 8005003b CR2: f95823c4 CR3: 35cfa000 CR4: 000006d0
[1266874876.497065] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874876.497069] DR6: ffff0ff0 DR7: 00000400
[1266874876.497073] Call Trace:
[1266874876.497083]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874876.497092]  [<c04313d9>] irq_exit+0x29/0x57
[1266874876.497102]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874876.497111]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874876.497122]  [<c044832b>] ? tick_nohz_restart_sched_tick+0x125/0x12a
[1266874876.497131]  [<c0401b14>] cpu_idle+0x52/0x59
[1266874876.497140]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874876.543095] BUG: soft lockup - CPU#2 stuck for 0s! [swapper:0]
[1266874876.543099] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874876.543145] 
[1266874876.543149] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874876.543154] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 2
[1266874876.543161] EIP is at __do_softirq+0x4c/0x14e
[1266874876.543164] EAX: 00000002 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874876.543168] ESI: 00000000 EDI: c1b72138 EBP: f6c99f24 ESP: f6c99f00
[1266874876.543172]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874876.543175] CR0: 8005003b CR2: 0806ee80 CR3: 35af2000 CR4: 000006d0
[1266874876.543179] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874876.543182] DR6: ffff0ff0 DR7: 00000400
[1266874876.543184] Call Trace:
[1266874876.543190]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874876.543196]  [<c04313d9>] irq_exit+0x29/0x57
[1266874876.543202]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874876.543207]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874876.543213]  [<c044832b>] ? tick_nohz_restart_sched_tick+0x125/0x12a
[1266874876.543218]  [<c0401b14>] cpu_idle+0x52/0x59
[1266874876.543223]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874876.581309] BUG: soft lockup - CPU#0 stuck for 0s! [events/0:15]
[1266874876.581312] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874876.581357] 
[1266874876.581361] Pid: 15, comm: events/0 Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874876.581366] EIP: 0060:[<c042c89c>] EFLAGS: 00000246 CPU: 0
[1266874876.581372] EIP is at release_console_sem+0x14e/0x187
[1266874876.581375] EAX: 00028d56 EBX: 00028d56 ECX: ffffffff EDX: 00028d56
[1266874876.581379] ESI: 00028d18 EDI: 00028d56 EBP: f6cabf10 ESP: f6cabef8
[1266874876.581383]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874876.581386] CR0: 8005003b CR2: b740b000 CR3: 2b1a0000 CR4: 000006d0
[1266874876.581390] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874876.581393] DR6: ffff0ff0 DR7: 00000400
[1266874876.581395] Call Trace:
[1266874876.581404]  [<c058d551>] fb_flashcursor+0x242/0x24d
[1266874876.581409]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874876.581415]  [<c043b55e>] worker_thread+0x170/0x23c
[1266874876.581420]  [<c043b521>] ? worker_thread+0x133/0x23c
[1266874876.581425]  [<c058d30f>] ? fb_flashcursor+0x0/0x24d
[1266874876.581431]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874876.581436]  [<c043b3ee>] ? worker_thread+0x0/0x23c
[1266874876.581441]  [<c043e23e>] kthread+0x6e/0x74
[1266874876.581446]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874876.581451]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874877.676489] BUG: soft lockup - CPU#1 stuck for 0s! [swapper:0]
[1266874877.680977] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874877.700051] 
[1266874877.704655] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874877.709479] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 1
[1266874877.714258] EIP is at __do_softirq+0x4c/0x14e
[1266874877.719053] EAX: 00000001 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874877.723872] ESI: 00000000 EDI: c1b62138 EBP: f6c91f24 ESP: f6c91f00
[1266874877.728700]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874877.733482] CR0: 8005003b CR2: 004990a0 CR3: 33283000 CR4: 000006d0
[1266874877.738334] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874877.743211] DR6: ffff0ff0 DR7: 00000400
[1266874877.748030] Call Trace:
[1266874877.752862]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874877.757699]  [<c04313d9>] irq_exit+0x29/0x57
[1266874877.762549]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874877.767409]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874877.772251]  [<c044832b>] ? tick_nohz_restart_sched_tick+0x125/0x12a
[1266874877.777328]  [<c0401b14>] cpu_idle+0x52/0x59
[1266874877.782132]  [<c070ddc1>] start_secondary+0x194/0x199
[1266874877.787234] usb-storage: device scan complete
[1266874877.789341] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[1266874877.793929] BUG: soft lockup - CPU#3 stuck for 0s! [scsi_scan_6:2682]
[1266874877.798343] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874877.817686] 
[1266874877.822411] Pid: 2682, comm: scsi_scan_6 Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874877.822417] EIP: 0060:[<c042ce48>] EFLAGS: 00000282 CPU: 3
[1266874877.822423] EIP is at vprintk+0x39b/0x3a9
[1266874877.822427] EAX: f6d9e460 EBX: 00000001 ECX: c042c8c2 EDX: 00008b8a
[1266874877.822432] ESI: eb027d4a EDI: 00000014 EBP: eb027db8 ESP: eb027d10
[1266874877.822436]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874877.822440] CR0: 8005003b CR2: 080b095c CR3: 00957000 CR4: 000006d0
[1266874877.822443] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874877.822447] DR6: ffff0ff0 DR7: 00000400
[1266874877.822449] Call Trace:
[1266874877.822458]  [<c04313e4>] ? irq_exit+0x34/0x57
[1266874877.822464]  [<c0413a5e>] ? smp_apic_timer_interrupt+0x6f/0x7d
[1266874877.822470]  [<c0403316>] ? apic_timer_interrupt+0x2a/0x30
[1266874877.822476]  [<c042ce6b>] printk+0x15/0x17
[1266874877.822483]  [<c060d0de>] scsi_probe_and_add_lun+0x82e/0xb6d
[1266874877.822491]  [<c071134d>] ? mutex_unlock+0x8/0xa
[1266874877.822497]  [<c060c4fc>] ? scsi_alloc_target+0x1ee/0x246
[1266874877.822502]  [<c060d612>] __scsi_scan_target+0x90/0x52f
[1266874877.822509]  [<c060dba7>] ? scsi_scan_host_selected+0x8c/0xf8
[1266874877.822514]  [<c060daef>] scsi_scan_channel+0x3e/0x6a
[1266874877.822520]  [<c060dbda>] scsi_scan_host_selected+0xbf/0xf8
[1266874877.822526]  [<c060dc76>] ? do_scan_async+0x0/0x145
[1266874877.822531]  [<c060dc6d>] do_scsi_scan_host+0x5a/0x63
[1266874877.822536]  [<c060dc8a>] do_scan_async+0x14/0x145
[1266874877.822541]  [<c060dc76>] ? do_scan_async+0x0/0x145
[1266874877.822548]  [<c043e23e>] kthread+0x6e/0x74
[1266874877.822554]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874877.822559]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874877.823873] sd 6:0:0:0: Attached scsi generic sg2 type 0
[1266874877.826274] BUG: soft lockup - CPU#2 stuck for 0s! [hald:1945]
[1266874877.826279] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874877.826352] 
[1266874877.826359] Pid: 1945, comm: hald Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874877.826366] EIP: 0073:[<001fc22e>] EFLAGS: 00000246 CPU: 2
[1266874877.826373] EIP is at 0x1fc22e
[1266874877.826378] EAX: 080c0f72 EBX: 080c1f40 ECX: 080c0fd2 EDX: bf95134f
[1266874877.826384] ESI: 080bfaa0 EDI: bf95134d EBP: bf951298 ESP: bf95127c
[1266874877.826390]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874877.826396] CR0: 8005003b CR2: b76f9000 CR3: 365db000 CR4: 000006d0
[1266874877.826402] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874877.826406] DR6: ffff0ff0 DR7: 00000400
[1266874877.826410] Call Trace:
[1266874877.853967] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[1266874878.033382] BUG: soft lockup - CPU#0 stuck for 1s! [events/0:15]
[1266874878.033386] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874878.033443] 
[1266874878.033448] Pid: 15, comm: events/0 Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874878.033453] EIP: 0060:[<c042c89c>] EFLAGS: 00000246 CPU: 0
[1266874878.033462] EIP is at release_console_sem+0x14e/0x187
[1266874878.033466] EAX: 0002b32b EBX: 0002b32b ECX: ffffffff EDX: 0002b32b
[1266874878.033470] ESI: 0002b30b EDI: 0002b32b EBP: f6cabf10 ESP: f6cabef8
[1266874878.033474]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874878.033478] CR0: 8005003b CR2: b740b000 CR3: 2b1a0000 CR4: 000006d0
[1266874878.033482] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874878.033485] DR6: ffff0ff0 DR7: 00000400
[1266874878.033488] Call Trace:
[1266874878.033499]  [<c058d551>] fb_flashcursor+0x242/0x24d
[1266874878.033504]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874878.033511]  [<c043b55e>] worker_thread+0x170/0x23c
[1266874878.033517]  [<c043b521>] ? worker_thread+0x133/0x23c
[1266874878.033522]  [<c058d30f>] ? fb_flashcursor+0x0/0x24d
[1266874878.033529]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874878.033534]  [<c043b3ee>] ? worker_thread+0x0/0x23c
[1266874878.033540]  [<c043e23e>] kthread+0x6e/0x74
[1266874878.033545]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874878.033552]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874878.167788] BUG: soft lockup - CPU#0 stuck for 0s! [usb_id:2692]
[1266874878.172628] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874878.194404] 
[1266874878.199632] Pid: 2692, comm: usb_id Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874878.204914] EIP: 0073:[<0018d93c>] EFLAGS: 00000246 CPU: 0
[1266874878.210008] EIP is at 0x18d93c
[1266874878.214904] EAX: 00000000 EBX: 00279ff4 ECX: 00000000 EDX: 00000050
[1266874878.219892] ESI: bf94f5cc EDI: 08051710 EBP: bf94ed28 ESP: bf94ed08
[1266874878.224838]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874878.229756] CR0: 8005003b CR2: 001487a0 CR3: 3312c000 CR4: 000006d0
[1266874878.234664] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874878.239577] DR6: ffff0ff0 DR7: 00000400
[1266874878.244433] Call Trace:
[1266874878.252663] BUG: soft lockup - CPU#1 stuck for 0s! [path_id:2697]
[1266874878.255082] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874878.266043] 
[1266874878.268749] Pid: 2697, comm: path_id Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874878.271447] EIP: 0073:[<00a7d867>] EFLAGS: 00000292 CPU: 1
[1266874878.274070] EIP is at 0xa7d867
[1266874878.276619] EAX: 00000000 EBX: 00b72ff4 ECX: 00b74148 EDX: 00000000
[1266874878.279096] ESI: 080fb060 EDI: 00000010 EBP: bf8077a0 ESP: bf807798
[1266874878.281609]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874878.284046] CR0: 8005003b CR2: 080fb004 CR3: 35d74000 CR4: 000006d0
[1266874878.286550] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874878.288981] DR6: ffff0ff0 DR7: 00000400
[1266874878.291410] Call Trace:
[1266874878.293791] BUG: soft lockup - CPU#2 stuck for 0s! [nscd:2699]
[1266874878.296190] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874878.308176] 
[1266874878.313660] Pid: 2699, comm: nscd Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874878.319743] EIP: 0073:[<0807dfc0>] EFLAGS: 00000282 CPU: 2
[1266874878.325811] EIP is at 0x807dfc0
[1266874878.331856] EAX: 080f6728 EBX: 080f6738 ECX: 0000005b EDX: 7f7f7f7f
[1266874878.337995] ESI: 080f6738 EDI: 080f65f8 EBP: bfa9c268 ESP: bfa9c25c
[1266874878.344125]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874878.350268] CR0: 8005003b CR2: 08085790 CR3: 2b1c5000 CR4: 000006d0
[1266874878.356471] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874878.362691] DR6: ffff0ff0 DR7: 00000400
[1266874878.368889] Call Trace:
[1266874878.375015] BUG: soft lockup - CPU#3 stuck for 0s! [hald:1945]
[1266874878.380319] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874878.403919] 
[1266874878.409620] Pid: 1945, comm: hald Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874878.415435] EIP: 0073:[<001f60d4>] EFLAGS: 00000283 CPU: 3
[1266874878.421245] EIP is at 0x1f60d4
[1266874878.427016] EAX: 080f4048 EBX: 002eaff4 ECX: 0000000c EDX: 002ec3c8
[1266874878.432835] ESI: 002ec3c8 EDI: 002ec140 EBP: bf950e50 ESP: bf950da8
[1266874878.438594]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874878.444401] CR0: 8005003b CR2: b76f9000 CR3: 365db000 CR4: 000006d0
[1266874878.450198] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874878.450201] DR6: ffff0ff0 DR7: 00000400
[1266874878.450204] Call Trace:
[1266874879.389054] BUG: soft lockup - CPU#0 stuck for 0s! [swapper:0]
[1266874879.394714] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874879.418245] 
[1266874879.423969] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874879.429780] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 0
[1266874879.435632] EIP is at __do_softirq+0x4c/0x14e
[1266874879.441434] EAX: 00000000 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874879.447242] ESI: 00000000 EDI: c08f97e4 EBP: c08a7f60 ESP: c08a7f3c
[1266874879.453055]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874879.458857] CR0: 8005003b CR2: 002689c0 CR3: 33283000 CR4: 000006d0
[1266874879.464706] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874879.470527] DR6: ffff0ff0 DR7: 00000400
[1266874879.476323] Call Trace:
[1266874879.482091]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874879.487712]  [<c04313d9>] irq_exit+0x29/0x57
[1266874879.493124]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874879.498391]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874879.503465]  [<c0401b14>] ? cpu_idle+0x52/0x59
[1266874879.508579]  [<c06ff3cb>] rest_init+0x53/0x55
[1266874879.513622]  [<c08fc8c5>] start_kernel+0x2d6/0x2db
[1266874879.518593]  [<c08fc06a>] i386_start_kernel+0x6a/0x6f
[1266874880.122013] BUG: soft lockup - CPU#0 stuck for 0s! [swapper:0]
[1266874880.127050] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874880.149550] 
[1266874880.155146] Pid: 0, comm: swapper Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874880.160952] EIP: 0060:[<c0430971>] EFLAGS: 00000206 CPU: 0
[1266874880.166566] EIP is at __do_softirq+0x4c/0x14e
[1266874880.171977] EAX: 00000000 EBX: 00000046 ECX: 00000000 EDX: c094dff0
[1266874880.177296] ESI: 00000000 EDI: c1b52138 EBP: c08a7f4c ESP: c08a7f28
[1266874880.182408]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874880.187596] CR0: 8005003b CR2: f95823c4 CR3: 35608000 CR4: 000006d0
[1266874880.192747] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874880.197848] DR6: ffff0ff0 DR7: 00000400
[1266874880.202916] Call Trace:
[1266874880.207887]  [<c0430a99>] do_softirq+0x26/0x2b
[1266874880.212897]  [<c04313d9>] irq_exit+0x29/0x57
[1266874880.217884]  [<c0413a5e>] smp_apic_timer_interrupt+0x6f/0x7d
[1266874880.222874]  [<c0403316>] apic_timer_interrupt+0x2a/0x30
[1266874880.227858]  [<c044832b>] ? tick_nohz_restart_sched_tick+0x125/0x12a
[1266874880.232880]  [<c0401b14>] cpu_idle+0x52/0x59
[1266874880.237894]  [<c06ff3cb>] rest_init+0x53/0x55
[1266874880.242875]  [<c08fc8c5>] start_kernel+0x2d6/0x2db
[1266874880.247703]  [<c08fc06a>] i386_start_kernel+0x6a/0x6f
[1266874880.382642] BUG: soft lockup - CPU#2 stuck for 0s! [hald:1945]
[1266874880.387117] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874880.406347] 
[1266874880.411027] Pid: 1945, comm: hald Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874880.415872] EIP: 0060:[<c0712942>] EFLAGS: 00000286 CPU: 2
[1266874880.420696] EIP is at _spin_unlock_irq+0x1f/0x21
[1266874880.425499] EAX: 00000002 EBX: f6fe3f58 ECX: c0435831 EDX: 0000eeed
[1266874880.430345] ESI: 0000000d EDI: f59b8000 EBP: f6fe3f48 ESP: f6fe3f48
[1266874880.435201]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874880.440048] CR0: 8005003b CR2: 00678d00 CR3: 365db000 CR4: 000006d0
[1266874880.444950] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874880.449863] DR6: ffff0ff0 DR7: 00000400
[1266874880.454758] Call Trace:
[1266874880.454769]  [<c0435831>] do_sigaction+0x112/0x123
[1266874880.454775]  [<c04358ca>] sys_rt_sigaction+0x50/0x7e
[1266874880.454782]  [<c0402a65>] syscall_call+0x7/0xb
[1266874881.597915] BUG: soft lockup - CPU#2 stuck for 0s! [pidof:2719]
[1266874881.602983] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874881.625288] 
[1266874881.630454] Pid: 2719, comm: pidof Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874881.635647] EIP: 0073:[<002aca97>] EFLAGS: 00000246 CPU: 2
[1266874881.640675] EIP is at 0x2aca97
[1266874881.645729] EAX: 08052638 EBX: 003a1ff4 ECX: 003a3140 EDX: 08052638
[1266874881.650805] ESI: 08052638 EDI: 0001a9c8 EBP: bfb79d80 ESP: bfb79d08
[1266874881.650810]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874881.650814] CR0: 8005003b CR2: b770f000 CR3: 36e0f000 CR4: 000006d0
[1266874881.650818] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.650822] DR6: ffff0ff0 DR7: 00000400
[1266874881.650824] Call Trace:
[1266874881.665492] BUG: soft lockup - CPU#0 stuck for 0s! [events/0:15]
[1266874881.665494] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874881.665520] 
[1266874881.665522] Pid: 15, comm: events/0 Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874881.665524] EIP: 0060:[<c042c89c>] EFLAGS: 00000246 CPU: 0
[1266874881.665530] EIP is at release_console_sem+0x14e/0x187
[1266874881.665532] EAX: 0002ea0b EBX: 0002ea0b ECX: ffffffff EDX: 0002ea0b
[1266874881.665533] ESI: 0002e9eb EDI: 0002ea0b EBP: f6cabf10 ESP: f6cabef8
[1266874881.665535]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874881.665537] CR0: 8005003b CR2: 080f17f8 CR3: 35c9e000 CR4: 000006d0
[1266874881.665539] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.665540] DR6: ffff0ff0 DR7: 00000400
[1266874881.665542] Call Trace:
[1266874881.665548]  [<c058d551>] fb_flashcursor+0x242/0x24d
[1266874881.665550]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874881.665555]  [<c043b55e>] worker_thread+0x170/0x23c
[1266874881.665557]  [<c043b521>] ? worker_thread+0x133/0x23c
[1266874881.665560]  [<c058d30f>] ? fb_flashcursor+0x0/0x24d
[1266874881.665563]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874881.665565]  [<c043b3ee>] ? worker_thread+0x0/0x23c
[1266874881.665568]  [<c043e23e>] kthread+0x6e/0x74
[1266874881.665570]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874881.665574]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874881.666816] BUG: soft lockup - CPU#1 stuck for 0s! [prefdm:2096]
[1266874881.666821] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874881.666905] 
[1266874881.666912] Pid: 2096, comm: prefdm Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874881.666920] EIP: 0060:[<c041bc14>] EFLAGS: 00000202 CPU: 1
[1266874881.666930] EIP is at flush_tlb_others_ipi+0x89/0xab
[1266874881.666937] EAX: ffffb300 EBX: c0966104 ECX: c08c3b40 EDX: 000008f1
[1266874881.666944] ESI: 00000001 EDI: c09660e0 EBP: f62ebe90 ESP: f62ebe74
[1266874881.666951]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874881.666958] CR0: 8005003b CR2: 080f2d58 CR3: 35c9e000 CR4: 000006d0
[1266874881.666964] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.666970] DR6: ffff0ff0 DR7: 00000400
[1266874881.666974] Call Trace:
[1266874881.666984]  [<c041bc3e>] native_flush_tlb_others+0x8/0xa
[1266874881.666993]  [<c041bcf5>] flush_tlb_page+0x58/0x5d
[1266874881.667002]  [<c041b50b>] ptep_set_access_flags+0x21/0x28
[1266874881.667013]  [<c048661c>] do_wp_page+0x31d/0x6d9
[1266874881.667024]  [<c0487e34>] ? handle_mm_fault+0x6fc/0x7a0
[1266874881.667033]  [<c0487e5e>] handle_mm_fault+0x726/0x7a0
[1266874881.667044]  [<c0440fc2>] ? down_read_trylock+0x39/0x43
[1266874881.667054]  [<c0418e52>] do_page_fault+0x17c/0x1e3
[1266874881.667062]  [<c0418cd6>] ? do_page_fault+0x0/0x1e3
[1266874881.667073]  [<c0712b3e>] error_code+0x66/0x6c
[1266874881.667081]  [<c0418cd6>] ? do_page_fault+0x0/0x1e3
[1266874883.603069] BUG: soft lockup - CPU#0 stuck for 0s! [hald-addon-stor:2714]
[1266874883.603076] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874883.603185] 
[1266874883.603192] Pid: 2714, comm: hald-addon-stor Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874883.603200] EIP: 0073:[<006244d7>] EFLAGS: 00000246 CPU: 0
[1266874883.603208] EIP is at 0x6244d7
[1266874883.603213] EAX: 080520f0 EBX: 00633ff4 ECX: 080520f0 EDX: 080520f0
[1266874883.603220] ESI: 080520f0 EDI: 0804edf8 EBP: bfef2ce8 ESP: bfef2cd0
[1266874883.603226]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874883.603232] CR0: 8005003b CR2: 0807c1e4 CR3: 333a8000 CR4: 000006d0
[1266874883.603238] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874883.603243] DR6: ffff0ff0 DR7: 00000400
[1266874883.603247] Call Trace:
[1266874883.603255] BUG: soft lockup - CPU#1 stuck for 0s! [X:2119]
[1266874883.603260] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874883.603374] 
[1266874883.603381] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874883.603389] EIP: 0060:[<c0547a0d>] EFLAGS: 00203286 CPU: 1
[1266874883.603401] EIP is at cap_file_ioctl+0x1/0x7
[1266874883.603407] EAX: f62fb3c0 EBX: c08d091c ECX: bfc1bc48 EDX: 40046460
[1266874883.603414] ESI: fffffff7 EDI: bfc1bc48 EBP: f5c77f94 ESP: f5c77f88
[1266874883.603420]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874883.603426] CR0: 8005003b CR2: 0843724c CR3: 362d1000 CR4: 000006d0
[1266874883.603432] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874883.603438] DR6: ffff0ff0 DR7: 00000400
[1266874883.603442] Call Trace:
[1266874883.603451]  [<c0546b68>] ? security_file_ioctl+0x10/0x13
[1266874883.603461]  [<c04aa815>] sys_ioctl+0x2c/0x5a
[1266874883.603471]  [<c0402a65>] syscall_call+0x7/0xb
[1266874883.654991] BUG: soft lockup - CPU#3 stuck for 0s! [X:2119]
[1266874883.654994] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874883.655036] 
[1266874883.655039] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874883.655042] EIP: 0073:[<005246e1>] EFLAGS: 00203246 CPU: 3
[1266874883.655046] EIP is at 0x5246e1
[1266874883.655047] EAX: bfc1ad14 EBX: 0054b55c ECX: 08231598 EDX: 00000060
[1266874883.655050] ESI: 00000000 EDI: 0ac5a3d4 EBP: bfc1ac28 ESP: bfc1ab50
[1266874883.655052]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874883.655054] CR0: 80050033 CR2: b6a12000 CR3: 362d1000 CR4: 000006d0
[1266874883.655056] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874883.655058] DR6: ffff0ff0 DR7: 00000400
[1266874883.655060] Call Trace:
[1266874884.804360] BUG: soft lockup - CPU#0 stuck for 0s! [pidof:2724]
[1266874884.804367] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874884.804454] 
[1266874884.804460] Pid: 2724, comm: pidof Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874884.804466] EIP: 0073:[<00b30819>] EFLAGS: 00000216 CPU: 0
[1266874884.804472] EIP is at 0xb30819
[1266874884.804476] EAX: 00000031 EBX: 00c62ff4 ECX: bf8c59e0 EDX: 00000031
[1266874884.804481] ESI: 00c1ebe0 EDI: 00c63380 EBP: bf8c59a4 ESP: bf8c5950
[1266874884.804486]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874884.804491] CR0: 8005003b CR2: b77cb000 CR3: 2b01b000 CR4: 000006d0
[1266874884.804495] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874884.804499] DR6: ffff0ff0 DR7: 00000400
[1266874884.804503] Call Trace:
[1266874885.881832] BUG: soft lockup - CPU#0 stuck for 0s! [X:2119]
[1266874885.885840] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874885.904055] 
[1266874885.908564] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874885.913228] EIP: 0060:[<f813758e>] EFLAGS: 00200286 CPU: 0
[1266874885.917876] EIP is at drm_clflush_pages+0x22/0x6c [drm]
[1266874885.922524] EAX: c191a6d8 EBX: f80c9808 ECX: ecd0d000 EDX: 00048000
[1266874885.927226] ESI: 00000202 EDI: 00000800 EBP: f5c77e28 ESP: f5c77e1c
[1266874885.931972]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874885.936752] CR0: 80050033 CR2: 0aba6fa8 CR3: 362d1000 CR4: 000006d0
[1266874885.941574] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874885.946409] DR6: ffff0ff0 DR7: 00000400
[1266874885.951186] Call Trace:
[1266874885.955966]  [<f85c0e09>] i915_gem_clflush_object+0x2f/0x58 [i915]
[1266874885.960838]  [<f85c19bb>] i915_gem_throttle_ioctl+0x11a/0x291 [i915]
[1266874885.965699]  [<f85c4cbe>] i915_gem_set_domain_ioctl+0xee/0x116 [i915]
[1266874885.970596]  [<f8138534>] drm_ioctl+0x1f4/0x266 [drm]
[1266874885.975502]  [<f85c4bd0>] ? i915_gem_set_domain_ioctl+0x0/0x116 [i915]
[1266874885.980427]  [<c04aa267>] vfs_ioctl+0x4e/0x67
[1266874885.985204]  [<c04aa7b5>] do_vfs_ioctl+0x48a/0x4be
[1266874885.989756]  [<c0710c65>] ? schedule+0x7f9/0x855
[1266874885.994128]  [<c04aa829>] sys_ioctl+0x40/0x5a
[1266874885.998304]  [<c0402a65>] syscall_call+0x7/0xb
[1266874886.008644] BUG: soft lockup - CPU#1 stuck for 0s! [X:2119]
[1266874886.010704] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874886.019955] 
[1266874886.022216] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874886.024543] EIP: 0060:[<f81375a9>] EFLAGS: 00200293 CPU: 1
[1266874886.026853] EIP is at drm_clflush_pages+0x3d/0x6c [drm]
[1266874886.029159] EAX: 00000040 EBX: f803bac0 ECX: f214d000 EDX: 00000f00
[1266874886.031491] ESI: 000002b0 EDI: 00000800 EBP: f5c77e1c ESP: f5c77e10
[1266874886.033827]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874886.036173] CR0: 80050033 CR2: b50357ac CR3: 362d1000 CR4: 000006d0
[1266874886.038542] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874886.040934] DR6: ffff0ff0 DR7: 00000400
[1266874886.043306] Call Trace:
[1266874886.045664]  [<f85c0e09>] i915_gem_clflush_object+0x2f/0x58 [i915]
[1266874886.048079]  [<f85c0e20>] i915_gem_clflush_object+0x46/0x58 [i915]
[1266874886.050473]  [<f85c1b73>] i915_gem_object_set_to_gtt_domain+0x41/0x6f [i915]
[1266874886.052896]  [<f85c4c71>] i915_gem_set_domain_ioctl+0xa1/0x116 [i915]
[1266874886.055333]  [<f8138534>] drm_ioctl+0x1f4/0x266 [drm]
[1266874886.057760]  [<f85c4bd0>] ? i915_gem_set_domain_ioctl+0x0/0x116 [i915]
[1266874886.060195]  [<c04408ee>] ? lock_hrtimer_base+0x18/0x33
[1266874886.062550]  [<c04aa267>] vfs_ioctl+0x4e/0x67
[1266874886.064811]  [<c04aa7b5>] do_vfs_ioctl+0x48a/0x4be
[1266874886.066988]  [<c042f9ab>] ? do_setitimer+0x157/0x2d0
[1266874886.069083]  [<c056b989>] ? copy_from_user+0x31/0x54
[1266874886.071191]  [<c042fb69>] ? sys_setitimer+0x45/0x73
[1266874886.073263]  [<c04aa829>] sys_ioctl+0x40/0x5a
[1266874886.075307]  [<c0402a65>] syscall_call+0x7/0xb
[1266874886.382116] BUG: soft lockup - CPU#2 stuck for 0s! [hald-addon-stor:2058]
[1266874886.386312] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874886.405201] 
[1266874886.405206] Pid: 2058, comm: hald-addon-stor Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874886.405213] EIP: 0060:[<c0712a6a>] EFLAGS: 00000246 CPU: 2
[1266874886.405221] EIP is at __reacquire_kernel_lock+0x1d/0x30
[1266874886.405225] EAX: 00000000 EBX: f5dce000 ECX: 00000000 EDX: c08c0660
[1266874886.405229] ESI: f5d6f6a0 EDI: f55cf600 EBP: f5dcf9e4 ESP: f5dcf9e0
[1266874886.405233]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874886.405237] CR0: 8005003b CR2: 005ecd50 CR3: 35cfa000 CR4: 000006d0
[1266874886.405241] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874886.405244] DR6: ffff0ff0 DR7: 00000400
[1266874886.405247] Call Trace:
[1266874886.405253]  [<c0710c93>] schedule+0x827/0x855
[1266874886.405261]  [<c06274b0>] ? ahci_qc_prep+0x126/0x12e
[1266874886.405267]  [<c0710f64>] schedule_timeout+0x17/0x14b
[1266874886.405273]  [<c0710d47>] ? wait_for_common+0x20/0x101
[1266874886.405279]  [<c0710dd9>] wait_for_common+0xb2/0x101
[1266874886.405286]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874886.405292]  [<c0710eaa>] wait_for_completion+0x12/0x14
[1266874886.405299]  [<c055bf11>] blk_execute_rq+0xa8/0xbf
[1266874886.405304]  [<c055bdcc>] ? blk_end_sync_rq+0x0/0x28
[1266874886.405312]  [<c056454b>] ? cfq_set_request+0x0/0x2a9
[1266874886.405318]  [<c0552297>] ? elv_set_request+0x17/0x26
[1266874886.405324]  [<c0555c01>] ? get_request+0x204/0x2b9
[1266874886.405331]  [<c060b09d>] scsi_execute+0xbf/0x113
[1266874886.405336]  [<c060b17e>] scsi_execute_req+0x8d/0xb8
[1266874886.405348]  [<f80d0101>] sr_test_unit_ready+0x3b/0xe1e [sr_mod]
[1266874886.405356]  [<f80d0d20>] sr_test_unit_ready+0xc5a/0xe1e [sr_mod]
[1266874886.405362]  [<c041f43b>] ? __enqueue_entity+0x9c/0xa4
[1266874886.405369]  [<c062b7b5>] media_changed+0x43/0x72
[1266874886.405376]  [<c062b810>] cdrom_media_changed+0x2c/0x32
[1266874886.405383]  [<f80d01a6>] sr_test_unit_ready+0xe0/0xe1e [sr_mod]
[1266874886.405390]  [<c04be5bb>] check_disk_change+0x1c/0x48
[1266874886.405395]  [<c062e629>] cdrom_open+0x7d5/0x839
[1266874886.405401]  [<c0424e29>] ? try_to_wake_up+0x1e5/0x1ef
[1266874886.405407]  [<c0424e3e>] ? default_wake_function+0xb/0xd
[1266874886.405413]  [<c04abece>] ? pollwake+0x4c/0x59
[1266874886.405419]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874886.405429]  [<f80d0204>] ? sr_test_unit_ready+0x13e/0xe1e [sr_mod]
[1266874886.405440]  [<f80d0254>] sr_test_unit_ready+0x18e/0xe1e [sr_mod]
[1266874886.405446]  [<c04bf051>] __blkdev_get+0xb5/0x31c
[1266874886.405452]  [<c04bf2c2>] blkdev_get+0xa/0xc
[1266874886.405457]  [<c04bf32a>] blkdev_open+0x66/0x92
[1266874886.405465]  [<c049dc21>] __dentry_open+0x116/0x204
[1266874886.405470]  [<c049eb09>] nameidata_to_filp+0x2c/0x43
[1266874886.405476]  [<c04bf2c4>] ? blkdev_open+0x0/0x92
[1266874886.405481]  [<c04a8e24>] do_filp_open+0x3e4/0x6fa
[1266874886.405488]  [<c04b067f>] ? alloc_fd+0x22/0xca
[1266874886.405494]  [<c04b071d>] ? alloc_fd+0xc0/0xca
[1266874886.405499]  [<c049da0f>] do_sys_open+0x4a/0xe7
[1266874886.405505]  [<c049daee>] sys_open+0x1e/0x26
[1266874886.405511]  [<c0402a65>] syscall_call+0x7/0xb
[1266874886.879413] BUG: soft lockup - CPU#1 stuck for 0s! [X:2119]
[1266874886.882246] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874886.896062] 
[1266874886.899499] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874886.903123] EIP: 0060:[<c0485371>] EFLAGS: 00200283 CPU: 1
[1266874886.906765] EIP is at page_address+0x4/0xa1
[1266874886.910428] EAX: c1a40704 EBX: c1a40704 ECX: 00000163 EDX: 00000003
[1266874886.914152] ESI: 00000163 EDI: 00000800 EBP: f5c77de8 ESP: f5c77de4
[1266874886.917884]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874886.921639] CR0: 80050033 CR2: b50357ac CR3: 362d1000 CR4: 000006d0
[1266874886.925423] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874886.929245] DR6: ffff0ff0 DR7: 00000400
[1266874886.933041] Call Trace:
[1266874886.936802]  [<c041c4bf>] kmap_atomic_prot+0xaa/0xb0
[1266874886.940658]  [<c041c4d3>] kmap_atomic+0xe/0x10
[1266874886.944511]  [<f8137598>] drm_clflush_pages+0x2c/0x6c [drm]
[1266874886.948403]  [<f85c0e09>] i915_gem_clflush_object+0x2f/0x58 [i915]
[1266874886.952327]  [<f85c0e20>] i915_gem_clflush_object+0x46/0x58 [i915]
[1266874886.956205]  [<f85c1b73>] i915_gem_object_set_to_gtt_domain+0x41/0x6f [i915]
[1266874886.960135]  [<f85c4c71>] i915_gem_set_domain_ioctl+0xa1/0x116 [i915]
[1266874886.964069]  [<f8138534>] drm_ioctl+0x1f4/0x266 [drm]
[1266874886.967999]  [<f85c4bd0>] ? i915_gem_set_domain_ioctl+0x0/0x116 [i915]
[1266874886.971961]  [<c04408ee>] ? lock_hrtimer_base+0x18/0x33
[1266874886.975934]  [<c04aa267>] vfs_ioctl+0x4e/0x67
[1266874886.979870]  [<c04aa7b5>] do_vfs_ioctl+0x48a/0x4be
[1266874886.983792]  [<c042f9ab>] ? do_setitimer+0x157/0x2d0
[1266874886.987721]  [<c0546b34>] ? security_file_permission+0xf/0x11
[1266874886.991686]  [<c056b989>] ? copy_from_user+0x31/0x54
[1266874886.995653]  [<c042fb69>] ? sys_setitimer+0x45/0x73
[1266874886.999597]  [<c04aa829>] sys_ioctl+0x40/0x5a
[1266874887.003519]  [<c0402a65>] syscall_call+0x7/0xb
[1266874887.379702] BUG: soft lockup - CPU#0 stuck for 0s! [X:2119]
[1266874887.383657] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874887.402128] 
[1266874887.406763] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874887.411610] EIP: 0060:[<c041c364>] EFLAGS: 00200212 CPU: 0
[1266874887.416444] EIP is at kunmap_atomic+0x0/0x4d
[1266874887.421329] EAX: f20f1000 EBX: f803b944 ECX: f20f1000 EDX: 00000003
[1266874887.426281] ESI: 00000251 EDI: 00000800 EBP: f5c77e1c ESP: f5c77e0c
[1266874887.431267]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874887.436289] CR0: 80050033 CR2: b4416000 CR3: 362d1000 CR4: 000006d0
[1266874887.441345] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874887.446346] DR6: ffff0ff0 DR7: 00000400
[1266874887.451118] Call Trace:
[1266874887.455692]  [<f81375bf>] ? drm_clflush_pages+0x53/0x6c [drm]
[1266874887.460149]  [<f85c0e09>] i915_gem_clflush_object+0x2f/0x58 [i915]
[1266874887.464455]  [<f85c0e20>] i915_gem_clflush_object+0x46/0x58 [i915]
[1266874887.468755]  [<f85c1b73>] i915_gem_object_set_to_gtt_domain+0x41/0x6f [i915]
[1266874887.473020]  [<f85c4c71>] i915_gem_set_domain_ioctl+0xa1/0x116 [i915]
[1266874887.477231]  [<f8138534>] drm_ioctl+0x1f4/0x266 [drm]
[1266874887.481411]  [<f85c4bd0>] ? i915_gem_set_domain_ioctl+0x0/0x116 [i915]
[1266874887.485625]  [<c04408ee>] ? lock_hrtimer_base+0x18/0x33
[1266874887.489792]  [<c04aa267>] vfs_ioctl+0x4e/0x67
[1266874887.493925]  [<c04aa7b5>] do_vfs_ioctl+0x48a/0x4be
[1266874887.498021]  [<c042f9ab>] ? do_setitimer+0x157/0x2d0
[1266874887.502134]  [<c0546b34>] ? security_file_permission+0xf/0x11
[1266874887.506256]  [<c056b989>] ? copy_from_user+0x31/0x54
[1266874887.510357]  [<c042fb69>] ? sys_setitimer+0x45/0x73
[1266874887.514430]  [<c04aa829>] sys_ioctl+0x40/0x5a
[1266874887.518558]  [<c0402a65>] syscall_call+0x7/0xb
[1266874887.810088] BUG: soft lockup - CPU#3 stuck for 0s! [pidof:2728]
[1266874887.814097] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874887.832628] 
[1266874887.837186] Pid: 2728, comm: pidof Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874887.841923] EIP: 0060:[<c056ea6c>] EFLAGS: 00000246 CPU: 3
[1266874887.846663] EIP is at _raw_spin_lock+0x1e/0x109
[1266874887.851389] EAX: eb165540 EBX: eb165540 ECX: 00000000 EDX: 00000000
[1266874887.856192] ESI: 00000004 EDI: eb165540 EBP: eb201f28 ESP: eb201f18
[1266874887.860986]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874887.865794] CR0: 8005003b CR2: b7719000 CR3: 2b11b000 CR4: 000006d0
[1266874887.870638] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874887.875498] DR6: ffff0ff0 DR7: 00000400
[1266874887.880332] Call Trace:
[1266874887.885118]  [<c0712727>] _spin_lock+0x22/0x2a
[1266874887.889789]  [<c049d861>] ? fd_install+0x24/0x51
[1266874887.894268]  [<c049d861>] fd_install+0x24/0x51
[1266874887.898541]  [<c049da91>] do_sys_open+0xcc/0xe7
[1266874887.902637]  [<c049daee>] sys_open+0x1e/0x26
[1266874887.906740]  [<c0402a65>] syscall_call+0x7/0xb
[1266874887.910767] BUG: soft lockup - CPU#1 stuck for 0s! [X:2119]
[1266874887.913174] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874887.922357] 
[1266874887.922361] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874887.922364] EIP: 0060:[<f81375a9>] EFLAGS: 00200297 CPU: 1
[1266874887.922382] EIP is at drm_clflush_pages+0x3d/0x6c [drm]
[1266874887.922386] EAX: 00000040 EBX: f803b368 ECX: f2786000 EDX: 00000240
[1266874887.922388] ESI: 000000da EDI: 00000800 EBP: f5c77e1c ESP: f5c77e10
[1266874887.922391]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874887.922394] CR0: 80050033 CR2: b50357ac CR3: 362d1000 CR4: 000006d0
[1266874887.922398] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874887.922400] DR6: ffff0ff0 DR7: 00000400
[1266874887.922404] Call Trace:
[1266874887.922427]  [<f85c0e09>] i915_gem_clflush_object+0x2f/0x58 [i915]
[1266874887.922438]  [<f85c0e20>] i915_gem_clflush_object+0x46/0x58 [i915]
[1266874887.922450]  [<f85c1b73>] i915_gem_object_set_to_gtt_domain+0x41/0x6f [i915]
[1266874887.922464]  [<f85c4c71>] i915_gem_set_domain_ioctl+0xa1/0x116 [i915]
[1266874887.922482]  [<f8138534>] drm_ioctl+0x1f4/0x266 [drm]
[1266874887.922494]  [<f85c4bd0>] ? i915_gem_set_domain_ioctl+0x0/0x116 [i915]
[1266874887.922501]  [<c04408ee>] ? lock_hrtimer_base+0x18/0x33
[1266874887.922507]  [<c04aa267>] vfs_ioctl+0x4e/0x67
[1266874887.922511]  [<c04aa7b5>] do_vfs_ioctl+0x48a/0x4be
[1266874887.922516]  [<c042f9ab>] ? do_setitimer+0x157/0x2d0
[1266874887.922522]  [<c0546b34>] ? security_file_permission+0xf/0x11
[1266874887.922527]  [<c056b989>] ? copy_from_user+0x31/0x54
[1266874887.922531]  [<c042fb69>] ? sys_setitimer+0x45/0x73
[1266874887.922535]  [<c04aa829>] sys_ioctl+0x40/0x5a
[1266874887.922540]  [<c0402a65>] syscall_call+0x7/0xb
[1266874888.026546] BUG: soft lockup - CPU#0 stuck for 0s! [events/0:15]
[1266874888.026549] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874888.026602] 
[1266874888.026606] Pid: 15, comm: events/0 Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874888.026612] EIP: 0060:[<c042c89c>] EFLAGS: 00000246 CPU: 0
[1266874888.026618] EIP is at release_console_sem+0x14e/0x187
[1266874888.026622] EAX: 0003539e EBX: 0003539e ECX: ffffffff EDX: 0003539e
[1266874888.026626] ESI: 00035367 EDI: 0003539e EBP: f6cabf10 ESP: f6cabef8
[1266874888.026631]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874888.026634] CR0: 8005003b CR2: 002bb420 CR3: 00957000 CR4: 000006d0
[1266874888.026638] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874888.026641] DR6: ffff0ff0 DR7: 00000400
[1266874888.026644] Call Trace:
[1266874888.026653]  [<c058d551>] fb_flashcursor+0x242/0x24d
[1266874888.026658]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874888.026665]  [<c043b55e>] worker_thread+0x170/0x23c
[1266874888.026670]  [<c043b521>] ? worker_thread+0x133/0x23c
[1266874888.026676]  [<c058d30f>] ? fb_flashcursor+0x0/0x24d
[1266874888.026682]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874888.026687]  [<c043b3ee>] ? worker_thread+0x0/0x23c
[1266874888.026693]  [<c043e23e>] kthread+0x6e/0x74
[1266874888.026698]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874888.026704]  [<c04034bf>] kernel_thread_helper+0x7/0x10
[1266874888.379279] BUG: soft lockup - CPU#2 stuck for 0s! [hald-addon-stor:2058]
[1266874888.383261] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874888.401357] 
[1266874888.405869] Pid: 2058, comm: hald-addon-stor Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874888.410625] EIP: 0060:[<c0712a6a>] EFLAGS: 00000246 CPU: 2
[1266874888.415434] EIP is at __reacquire_kernel_lock+0x1d/0x30
[1266874888.420200] EAX: 00000000 EBX: f5dce000 ECX: 00000000 EDX: c08c0660
[1266874888.425023] ESI: f5d6f6a0 EDI: f5b2e640 EBP: f5dcf9e4 ESP: f5dcf9e0
[1266874888.429858]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874888.434647] CR0: 8005003b CR2: b77136c5 CR3: 35cfa000 CR4: 000006d0
[1266874888.439477] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874888.444303] DR6: ffff0ff0 DR7: 00000400
[1266874888.449094] Call Trace:
[1266874888.453857]  [<c0710c93>] schedule+0x827/0x855
[1266874888.458666]  [<c06274b0>] ? ahci_qc_prep+0x126/0x12e
[1266874888.463472]  [<c0710f64>] schedule_timeout+0x17/0x14b
[1266874888.468300]  [<c0710d47>] ? wait_for_common+0x20/0x101
[1266874888.473139]  [<c0710dd9>] wait_for_common+0xb2/0x101
[1266874888.478010]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874888.482857]  [<c0710eaa>] wait_for_completion+0x12/0x14
[1266874888.487551]  [<c055bf11>] blk_execute_rq+0xa8/0xbf
[1266874888.492033]  [<c055bdcc>] ? blk_end_sync_rq+0x0/0x28
[1266874888.496313]  [<c056454b>] ? cfq_set_request+0x0/0x2a9
[1266874888.500418]  [<c0552297>] ? elv_set_request+0x17/0x26
[1266874888.504508]  [<c0555c01>] ? get_request+0x204/0x2b9
[1266874888.508536]  [<c060b09d>] scsi_execute+0xbf/0x113
[1266874888.512472]  [<c060b17e>] scsi_execute_req+0x8d/0xb8
[1266874888.516383]  [<f80d0101>] sr_test_unit_ready+0x3b/0xe1e [sr_mod]
[1266874888.520318]  [<f80d0d20>] sr_test_unit_ready+0xc5a/0xe1e [sr_mod]
[1266874888.524210]  [<c04abe82>] ? pollwake+0x0/0x59
[1266874888.528068]  [<c062b7b5>] media_changed+0x43/0x72
[1266874888.531932]  [<c062b810>] cdrom_media_changed+0x2c/0x32
[1266874888.535798]  [<f80d01a6>] sr_test_unit_ready+0xe0/0xe1e [sr_mod]
[1266874888.539667]  [<c04be5bb>] check_disk_change+0x1c/0x48
[1266874888.543554]  [<c062e629>] cdrom_open+0x7d5/0x839
[1266874888.543560]  [<c0710de3>] ? wait_for_common+0xbc/0x101
[1266874888.543566]  [<c0712940>] ? _spin_unlock_irq+0x1d/0x21
[1266874888.543571]  [<c0710e1e>] ? wait_for_common+0xf7/0x101
[1266874888.543577]  [<c0424e33>] ? default_wake_function+0x0/0xd
[1266874888.543583]  [<c0710eaa>] ? wait_for_completion+0x12/0x14
[1266874888.543588]  [<c055bf11>] ? blk_execute_rq+0xa8/0xbf
[1266874888.543594]  [<c055bdcc>] ? blk_end_sync_rq+0x0/0x28
[1266874888.543599]  [<c056454b>] ? cfq_set_request+0x0/0x2a9
[1266874888.543610]  [<f80d0204>] ? sr_test_unit_ready+0x13e/0xe1e [sr_mod]
[1266874888.543622]  [<f80d0254>] sr_test_unit_ready+0x18e/0xe1e [sr_mod]
[1266874888.543628]  [<c04bf051>] __blkdev_get+0xb5/0x31c
[1266874888.543633]  [<c04bf2c2>] blkdev_get+0xa/0xc
[1266874888.543638]  [<c04bf32a>] blkdev_open+0x66/0x92
[1266874888.543646]  [<c049dc21>] __dentry_open+0x116/0x204
[1266874888.543651]  [<c049eb09>] nameidata_to_filp+0x2c/0x43
[1266874888.543656]  [<c04bf2c4>] ? blkdev_open+0x0/0x92
[1266874888.543661]  [<c04a8e24>] do_filp_open+0x3e4/0x6fa
[1266874888.543669]  [<c04b067f>] ? alloc_fd+0x22/0xca
[1266874888.543675]  [<c04b071d>] ? alloc_fd+0xc0/0xca
[1266874888.543680]  [<c049da0f>] do_sys_open+0x4a/0xe7
[1266874888.543686]  [<c049daee>] sys_open+0x1e/0x26
[1266874888.543692]  [<c0402a65>] syscall_call+0x7/0xb
[1266874888.876576] BUG: soft lockup - CPU#1 stuck for 0s! [X:2119]
[1266874888.879327] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874888.892889] 
[1266874888.896269] Pid: 2119, comm: X Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874888.899834] EIP: 0060:[<f81375a2>] EFLAGS: 00200297 CPU: 1
[1266874888.903415] EIP is at drm_clflush_pages+0x36/0x6c [drm]
[1266874888.907009] EAX: f277ff80 EBX: f803b34c ECX: f277f000 EDX: 00000f80
[1266874888.910650] ESI: 000000d3 EDI: 00000800 EBP: f5c77e1c ESP: f5c77e10
[1266874888.914294]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874888.917952] CR0: 80050033 CR2: 00ae1188 CR3: 362d1000 CR4: 000006d0
[1266874888.921676] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874888.925427] DR6: ffff0ff0 DR7: 00000400
[1266874888.929159] Call Trace:
[1266874888.932844]  [<f85c0e09>] i915_gem_clflush_object+0x2f/0x58 [i915]
[1266874888.936662]  [<f85c0e20>] i915_gem_clflush_object+0x46/0x58 [i915]
[1266874888.940411]  [<f85c1b73>] i915_gem_object_set_to_gtt_domain+0x41/0x6f [i915]
[1266874888.944213]  [<f85c4c71>] i915_gem_set_domain_ioctl+0xa1/0x116 [i915]
[1266874888.948030]  [<f8138534>] drm_ioctl+0x1f4/0x266 [drm]
[1266874888.948051]  [<f85c4bd0>] ? i915_gem_set_domain_ioctl+0x0/0x116 [i915]
[1266874888.948063]  [<c04408ee>] ? lock_hrtimer_base+0x18/0x33
[1266874888.948074]  [<c04aa267>] vfs_ioctl+0x4e/0x67
[1266874888.948082]  [<c04aa7b5>] do_vfs_ioctl+0x48a/0x4be
[1266874888.948093]  [<c042f9ab>] ? do_setitimer+0x157/0x2d0
[1266874888.948102]  [<c0546b34>] ? security_file_permission+0xf/0x11
[1266874888.948113]  [<c056b989>] ? copy_from_user+0x31/0x54
[1266874888.948122]  [<c042fb69>] ? sys_setitimer+0x45/0x73
[1266874888.948130]  [<c04aa829>] sys_ioctl+0x40/0x5a
[1266874888.948139]  [<c0402a65>] syscall_call+0x7/0xb
[1266874888.973142] BUG: soft lockup - CPU#0 stuck for 0s! [events/0:15]
[1266874888.973145] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage wl(P) lib80211 acpi_cpufreq dm_mirror dm_region_hash dm_log dm_mod sbs sbshc pci_slot uinput i915 snd_hda_codec_intelhdmi snd_hda_codec_idt joydev snd_hda_intel snd_hda_codec hp_accel lis3lv02d snd_hwdep snd_seq_dummy drm snd_seq_oss snd_seq_midi_event snd_seq intel_agp snd_seq_device snd_pcm_oss atl1c snd_mixer_oss snd_pcm i2c_algo_bit snd_timer snd video output sg serio_raw sr_mod rtc_cmos rtc_core rtc_lib pcspkr snd_page_alloc wmi
[1266874888.973195] 
[1266874888.973200] Pid: 15, comm: events/0 Tainted: P           (2.6.31-1 #1) HP ProBook 4420s Notebook PCcpqt
[1266874888.973205] EIP: 0060:[<c042c89c>] EFLAGS: 00000246 CPU: 0
[1266874888.973211] EIP is at release_console_sem+0x14e/0x187
[1266874888.973215] EAX: 00037534 EBX: 00037534 ECX: ffffffff EDX: 00037534
[1266874888.973220] ESI: 000374fd EDI: 00037534 EBP: f6cabf10 ESP: f6cabef8
[1266874888.973224]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874888.973228] CR0: 8005003b CR2: 002bb420 CR3: 35d0e000 CR4: 000006d0
[1266874888.973231] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874888.973235] DR6: ffff0ff0 DR7: 00000400
[1266874888.973237] Call Trace:
[1266874888.973247]  [<c058d551>] fb_flashcursor+0x242/0x24d
[1266874888.973252]  [<c058e036>] ? bit_cursor+0x0/0x4a6
[1266874888.973258]  [<c043b55e>] worker_thread+0x170/0x23c
[1266874888.973264]  [<c043b521>] ? worker_thread+0x133/0x23c
[1266874888.973269]  [<c058d30f>] ? fb_flashcursor+0x0/0x24d
[1266874888.973276]  [<c043e2dd>] ? autoremove_wake_function+0x0/0x30
[1266874888.973281]  [<c043b3ee>] ? worker_thread+0x0/0x23c
[1266874888.973286]  [<c043e23e>] kthread+0x6e/0x74
[1266874888.973292]  [<c043e1d0>] ? kthread+0x0/0x74
[1266874888.973298]  [<c04034bf>] kernel_thread_helper+0x7/0x10

--=-cjtlXywonB/LAebr3DH3
Content-Disposition: attachment; filename=dmesg_after_test2
Content-Type: text/plain; name=dmesg_after_test2; charset=UTF-8
Content-Transfer-Encoding: 7bit

ne: 3947 pages, LIFO batch:0
  Normal zone: 2834 pages used for memmap
  Normal zone: 219951 pages, LIFO batch:31
  HighMem zone: 1 pages used for memmap
Using APIC driver default
ACPI: PM-Timer IO Port: 0x408
ACPI: Local APIC address 0xfee00000
ACPI: LAPIC (acpi_id[0x00] lapic_id[0x00] enabled)
ACPI: LAPIC (acpi_id[0x01] lapic_id[0x01] enabled)
ACPI: LAPIC (acpi_id[0x02] lapic_id[0x04] enabled)
ACPI: LAPIC (acpi_id[0x03] lapic_id[0x05] enabled)
ACPI: LAPIC (acpi_id[0x04] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x05] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x06] lapic_id[0x00] disabled)
ACPI: LAPIC (acpi_id[0x07] lapic_id[0x00] disabled)
ACPI: LAPIC_NMI (acpi_id[0x00] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
ACPI: IOAPIC (id[0x01] address[0xfec00000] gsi_base[0])
IOAPIC[0]: apic_id 1, version 32, address 0xfec00000, GSI 0-23
ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high level)
ACPI: IRQ0 used by override.
ACPI: IRQ2 used by override.
ACPI: IRQ9 used by override.
Enabling APIC mode:  Flat.  Using 1 I/O APICs
Using ACPI (MADT) for SMP configuration information
ACPI: HPET id: 0x8086a201 base: 0xfed00000
SMP: Allowing 8 CPUs, 4 hotplug CPUs
nr_irqs_gsi: 24
PM: Registered nosave memory: 000000000009f000 - 00000000000a0000
PM: Registered nosave memory: 00000000000a0000 - 00000000000ef000
PM: Registered nosave memory: 00000000000ef000 - 0000000000100000
PM: Registered nosave memory: 00000000375ae000 - 00000000375b6000
PM: Registered nosave memory: 00000000375bc000 - 000000003762c000
PM: Registered nosave memory: 0000000037694000 - 000000003769a000
PM: Registered nosave memory: 00000000376bf000 - 00000000376cf000
PM: Registered nosave memory: 00000000376cf000 - 00000000377cf000
PM: Registered nosave memory: 00000000377cf000 - 00000000377ff000
Allocating PCI resources starting at 38000000 (gap: 38000000:a8000000)
NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:8 nr_node_ids:1
PERCPU: Embedded 12 pages at c1b50000, static data 27588 bytes
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 223898
Kernel command line: ro root=LABEL=/ initcall_debug drm.debug=0x06 psmouse.proto=bare resume=/dev/sda5 printk.time=1
[    0.000000] PID hash table entries: 4096 (order: 12, 16384 bytes)
[    0.000000] Dentry cache hash table entries: 131072 (order: 7, 524288 bytes)
[    0.000000] Inode-cache hash table entries: 65536 (order: 6, 262144 bytes)
[    0.000000] Enabling fast FPU save and restore... done.
[    0.000000] Enabling unmasked SIMD FPU exception support... done.
[    0.000000] Initializing CPU#0
[    0.000000] allocated 4546560 bytes of page_cgroup
[    0.000000] please try 'cgroup_disable=memory' option if you don't want memory cgroups
[    0.000000] Initializing HighMem for node 0 (000377fe:00037800)
[    0.000000] Memory: 874100k/909312k available (3260k kernel code, 32308k reserved, 2014k data, 344k init, 4k highmem)
[    0.000000] virtual kernel memory layout:
[    0.000000]     fixmap  : 0xfff1f000 - 0xfffff000   ( 896 kB)
[    0.000000]     pkmap   : 0xff800000 - 0xffc00000   (4096 kB)
[    0.000000]     vmalloc : 0xf7ffe000 - 0xff7fe000   ( 120 MB)
[    0.000000]     lowmem  : 0xc0000000 - 0xf77fe000   ( 887 MB)
[    0.000000]       .init : 0xc0927000 - 0xc097d000   ( 344 kB)
[    0.000000]       .data : 0xc072f0e3 - 0xc09268f0   (2014 kB)
[    0.000000]       .text : 0xc0400000 - 0xc072f0e3   (3260 kB)
[    0.000000] Checking if this processor honours the WP bit even in supervisor mode...Ok.
[    0.000000] SLUB: Genslabs=13, HWalign=64, Order=0-3, MinObjects=0, CPUs=8, Nodes=1
[    0.000000] NR_IRQS:512
[    0.000000] Extended CMOS year: 2000
[    0.000000] Fast TSC calibration using PIT
[    0.000000] Detected 2400.540 MHz processor.
[    0.000999] Console: colour VGA+ 80x25
[    0.001824] console [tty0] enabled
[    0.015204] Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
[    0.015339] ... MAX_LOCKDEP_SUBCLASSES:  8
[    0.015428] ... MAX_LOCK_DEPTH:          48
[    0.015515] ... MAX_LOCKDEP_KEYS:        8191
[    0.015604] ... CLASSHASH_SIZE:          4096
[    0.015692] ... MAX_LOCKDEP_ENTRIES:     16384
[    0.015782] ... MAX_LOCKDEP_CHAINS:      32768
[    0.015871] ... CHAINHASH_SIZE:          16384
[    0.015960]  memory used by lock dependency info: 3487 kB
[    0.016053]  per task-struct memory footprint: 1152 bytes
[    0.016272] hpet clockevent registered
[    0.016292] HPET: 8 timers in total, 5 timers will be used for per-cpu timer
[    0.016390] Calibrating delay loop (skipped), value calculated using timer frequency.. 4801.08 BogoMIPS (lpj=2400540)
[    0.016592] Security Framework initialized
[    0.016689] Mount-cache hash table entries: 512
[    0.016997] Initializing cgroup subsys ns
[    0.017088] Initializing cgroup subsys cpuacct
[    0.017181] Initializing cgroup subsys memory
[    0.017297] Initializing cgroup subsys devices
[    0.017386] Initializing cgroup subsys freezer
[    0.017487] CPU: Physical Processor ID: 0
[    0.017576] CPU: Processor Core ID: 0
[    0.017664] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.017794] CPU: L2 cache: 256K
[    0.017878] CPU: L3 cache: 3072K
[    0.017966] mce: CPU supports 9 MCE banks
[    0.018063] CPU0: Thermal monitoring enabled (TM1)
[    0.018158] CPU 0 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6
[    0.018465] using mwait in idle threads.
[    0.018556] Checking 'hlt' instruction... OK.
[    0.022717] ACPI: Core revision 20090521
[    0.059953] ..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
[    0.070047] CPU0: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[    0.172041] calling  migration_init+0x0/0x4b @ 1
[    0.172183] initcall migration_init+0x0/0x4b returned 1 after 0 usecs
[    0.172291] initcall migration_init+0x0/0x4b returned with error code 1 
[    0.172399] calling  spawn_ksoftirqd+0x0/0x47 @ 1
[    0.172511] initcall spawn_ksoftirqd+0x0/0x47 returned 0 after 0 usecs
[    0.172620] calling  init_call_single_data+0x0/0x7c @ 1
[    0.172723] initcall init_call_single_data+0x0/0x7c returned 0 after 0 usecs
[    0.172832] calling  spawn_softlockup_task+0x0/0x5f @ 1
[    0.172950] initcall spawn_softlockup_task+0x0/0x5f returned 0 after 0 usecs
[    0.173063] calling  relay_init+0x0/0x11 @ 1
[    0.173164] initcall relay_init+0x0/0x11 returned 0 after 0 usecs
[    0.174015] calling  tracer_alloc_buffers+0x0/0x127 @ 1
[    0.174146] initcall tracer_alloc_buffers+0x0/0x127 returned 0 after 0 usecs
[    0.174255] calling  init_trace_printk+0x0/0xf @ 1
[    0.174356] initcall init_trace_printk+0x0/0xf returned 0 after 0 usecs
[    0.174505] lockdep: fixing up alternatives.
[    0.174619] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[    0.244918] Calibrating delay using timer specific routine.. 4799.82 BogoMIPS (lpj=2399913)
[    0.244927] CPU: Physical Processor ID: 0
[    0.244928] CPU: Processor Core ID: 0
[    0.244931] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.244933] CPU: L2 cache: 256K
[    0.244934] CPU: L3 cache: 3072K
[    0.244937] mce: CPU supports 9 MCE banks
[    0.244947] CPU1: Thermal monitoring enabled (TM1)
[    0.244950] CPU 1 MCA banks SHD:2 SHD:3 SHD:5 SHD:6
[    0.246013] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[    0.247441] CPU1: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[    0.248765] Skipping synchronization checks as TSC is reliable.
[    0.248956] lockdep: fixing up alternatives.
[    0.249065] Booting processor 2 APIC 0x4 ip 0x6000
[    0.000999] Initializing CPU#2
[    0.319798] Calibrating delay using timer specific routine.. 4799.85 BogoMIPS (lpj=2399925)
[    0.319806] CPU: Physical Processor ID: 0
[    0.319807] CPU: Processor Core ID: 2
[    0.319810] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.319811] CPU: L2 cache: 256K
[    0.319812] CPU: L3 cache: 3072K
[    0.319815] mce: CPU supports 9 MCE banks
[    0.319824] CPU2: Thermal monitoring enabled (TM1)
[    0.319827] CPU 2 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6
[    0.320627] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[    0.321705] CPU2: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[    0.323039] Skipping synchronization checks as TSC is reliable.
[    0.323235] lockdep: fixing up alternatives.
[    0.323344] Booting processor 3 APIC 0x5 ip 0x6000
[    0.000999] Initializing CPU#3
[    0.393679] Calibrating delay using timer specific routine.. 4799.84 BogoMIPS (lpj=2399921)
[    0.393687] CPU: Physical Processor ID: 0
[    0.393688] CPU: Processor Core ID: 2
[    0.393690] CPU: L1 I cache: 32K, L1 D cache: 32K
[    0.393692] CPU: L2 cache: 256K
[    0.393693] CPU: L3 cache: 3072K
[    0.393696] mce: CPU supports 9 MCE banks
[    0.393705] CPU3: Thermal monitoring enabled (TM1)
[    0.393708] CPU 3 MCA banks SHD:2 SHD:3 SHD:5 SHD:6
[    0.394800] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[    0.396287] CPU3: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[    0.397617] Skipping synchronization checks as TSC is reliable.
[    0.397742] Brought up 4 CPUs
[    0.397837] Total of 4 processors activated (19200.59 BogoMIPS).
[    0.398011] CPU0 attaching sched-domain:
[    0.398014]  domain 0: span 0-1 level SIBLING
[    0.398016]   groups: 0 1
[    0.398020]   domain 1: span 0-3 level MC
[    0.398022]    groups: 0-1 2-3
[    0.398026] CPU1 attaching sched-domain:
[    0.398028]  domain 0: span 0-1 level SIBLING
[    0.398030]   groups: 1 0
[    0.398032]   domain 1: span 0-3 level MC
[    0.398034]    groups: 0-1 2-3
[    0.398038] CPU2 attaching sched-domain:
[    0.398040]  domain 0: span 2-3 level SIBLING
[    0.398042]   groups: 2 3
[    0.398045]   domain 1: span 0-3 level MC
[    0.398047]    groups: 2-3 0-1
[    0.398051] CPU3 attaching sched-domain:
[    0.398052]  domain 0: span 2-3 level SIBLING
[    0.398054]   groups: 3 2
[    0.398057]   domain 1: span 0-3 level MC
[    0.398059]    groups: 2-3 0-1
[    0.398534] calling  init_mmap_min_addr+0x0/0x11 @ 1
[    0.398637] initcall init_mmap_min_addr+0x0/0x11 returned 0 after 0 usecs
[    0.398751] calling  init_cpufreq_transition_notifier_list+0x0/0x18 @ 1
[    0.398861] initcall init_cpufreq_transition_notifier_list+0x0/0x18 returned 0 after 0 usecs
[    0.399017] calling  net_ns_init+0x0/0xc8 @ 1
[    0.399143] initcall net_ns_init+0x0/0xc8 returned 0 after 0 usecs
[    0.399250] calling  e820_mark_nvs_memory+0x0/0x37 @ 1
[    0.399367] initcall e820_mark_nvs_memory+0x0/0x37 returned 0 after 0 usecs
[    0.399477] calling  cpufreq_tsc+0x0/0x25 @ 1
[    0.399577] initcall cpufreq_tsc+0x0/0x25 returned 0 after 0 usecs
[    0.399688] calling  pci_reboot_init+0x0/0x11 @ 1
[    0.399791] initcall pci_reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.399898] calling  reboot_init+0x0/0x11 @ 1
[    0.400002] initcall reboot_init+0x0/0x11 returned 0 after 0 usecs
[    0.400109] calling  init_lapic_sysfs+0x0/0x28 @ 1
[    0.400263] initcall init_lapic_sysfs+0x0/0x28 returned 0 after 0 usecs
[    0.400372] calling  init_smp_flush+0x0/0x2a @ 1
[    0.400474] initcall init_smp_flush+0x0/0x2a returned 0 after 0 usecs
[    0.400583] calling  alloc_frozen_cpus+0x0/0x7 @ 1
[    0.400688] initcall alloc_frozen_cpus+0x0/0x7 returned 0 after 0 usecs
[    0.400797] calling  sysctl_init+0x0/0x29 @ 1
[    0.401021] initcall sysctl_init+0x0/0x29 returned 0 after 0 usecs
[    0.401126] calling  ksysfs_init+0x0/0x96 @ 1
[    0.401233] initcall ksysfs_init+0x0/0x96 returned 0 after 0 usecs
[    0.401338] calling  async_init+0x0/0x51 @ 1
[    0.401454] initcall async_init+0x0/0x51 returned 0 after 0 usecs
[    0.401558] calling  init_jiffies_clocksource+0x0/0xf @ 1
[    0.401663] initcall init_jiffies_clocksource+0x0/0xf returned 0 after 0 usecs
[    0.401819] calling  pm_init+0x0/0x2d @ 1
[    0.401921] initcall pm_init+0x0/0x2d returned 0 after 0 usecs
[    0.402025] calling  pm_disk_init+0x0/0x14 @ 1
[    0.402127] initcall pm_disk_init+0x0/0x14 returned 0 after 0 usecs
[    0.402236] calling  swsusp_header_init+0x0/0x26 @ 1
[    0.402337] initcall swsusp_header_init+0x0/0x26 returned 0 after 0 usecs
[    0.402446] calling  filelock_init+0x0/0x27 @ 1
[    0.402547] initcall filelock_init+0x0/0x27 returned 0 after 0 usecs
[    0.402653] calling  init_misc_binfmt+0x0/0x35 @ 1
[    0.402764] initcall init_misc_binfmt+0x0/0x35 returned 0 after 0 usecs
[    0.402871] calling  init_script_binfmt+0x0/0x11 @ 1
[    0.402972] initcall init_script_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.403080] calling  init_elf_binfmt+0x0/0x11 @ 1
[    0.403180] initcall init_elf_binfmt+0x0/0x11 returned 0 after 0 usecs
[    0.403287] calling  debugfs_init+0x0/0x4a @ 1
[    0.403389] initcall debugfs_init+0x0/0x4a returned 0 after 0 usecs
[    0.403496] calling  securityfs_init+0x0/0x41 @ 1
[    0.403600] initcall securityfs_init+0x0/0x41 returned 0 after 0 usecs
[    0.403708] calling  random32_init+0x0/0xa9 @ 1
[    0.403809] initcall random32_init+0x0/0xa9 returned 0 after 0 usecs
[    0.403915] calling  cpufreq_core_init+0x0/0x5f @ 1
[    0.404019] initcall cpufreq_core_init+0x0/0x5f returned 0 after 0 usecs
[    0.404127] calling  cpuidle_init+0x0/0x32 @ 1
[    0.404230] initcall cpuidle_init+0x0/0x32 returned 0 after 0 usecs
[    0.404336] calling  sock_init+0x0/0x51 @ 1
[    0.404482] initcall sock_init+0x0/0x51 returned 0 after 0 usecs
[    0.404587] calling  net_inuse_init+0x0/0x1f @ 1
[    0.404692] initcall net_inuse_init+0x0/0x1f returned 0 after 0 usecs
[    0.404799] calling  netlink_proto_init+0x0/0x157 @ 1
[    0.404910] NET: Registered protocol family 16
[    0.405026] initcall netlink_proto_init+0x0/0x157 returned 0 after 0 usecs
[    0.405134] calling  olpc_init+0x0/0x100 @ 1
[    0.405234] initcall olpc_init+0x0/0x100 returned 0 after 0 usecs
[    0.405341] calling  bdi_class_init+0x0/0x35 @ 1
[    0.405493] initcall bdi_class_init+0x0/0x35 returned 0 after 0 usecs
[    0.405601] calling  kobject_uevent_init+0x0/0x4e @ 1
[    0.405708] initcall kobject_uevent_init+0x0/0x4e returned 0 after 0 usecs
[    0.405816] calling  pcibus_class_init+0x0/0x14 @ 1
[    0.405948] initcall pcibus_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.406057] calling  pci_driver_init+0x0/0xf @ 1
[    0.406186] initcall pci_driver_init+0x0/0xf returned 0 after 0 usecs
[    0.406293] calling  backlight_class_init+0x0/0x4d @ 1
[    0.406420] initcall backlight_class_init+0x0/0x4d returned 0 after 0 usecs
[    0.406529] calling  video_output_class_init+0x0/0x14 @ 1
[    0.406658] initcall video_output_class_init+0x0/0x14 returned 0 after 0 usecs
[    0.406814] calling  tty_class_init+0x0/0x28 @ 1
[    0.406941] initcall tty_class_init+0x0/0x28 returned 0 after 0 usecs
[    0.407049] calling  vtconsole_class_init+0x0/0xa1 @ 1
[    0.407220] initcall vtconsole_class_init+0x0/0xa1 returned 0 after 0 usecs
[    0.407329] calling  spi_init+0x0/0xae @ 1
[    0.407482] initcall spi_init+0x0/0xae returned 0 after 0 usecs
[    0.407586] calling  i2c_init+0x0/0x54 @ 1
[    0.407772] initcall i2c_init+0x0/0x54 returned 0 after 0 usecs
[    0.407878] calling  amd_postcore_init+0x0/0x66 @ 1
[    0.407980] initcall amd_postcore_init+0x0/0x66 returned 0 after 0 usecs
[    0.408086] calling  arch_kdebugfs_init+0x0/0x1e @ 1
[    0.408191] initcall arch_kdebugfs_init+0x0/0x1e returned 0 after 0 usecs
[    0.408298] calling  init_pit_clocksource+0x0/0x96 @ 1
[    0.408400] initcall init_pit_clocksource+0x0/0x96 returned 0 after 0 usecs
[    0.408508] calling  mtrr_if_init+0x0/0x44 @ 1
[    0.408611] initcall mtrr_if_init+0x0/0x44 returned 0 after 0 usecs
[    0.408719] calling  ffh_cstate_init+0x0/0x27 @ 1
[    0.408821] initcall ffh_cstate_init+0x0/0x27 returned 0 after 0 usecs
[    0.408929] calling  kdump_buf_page_init+0x0/0x72 @ 1
[    0.409031] initcall kdump_buf_page_init+0x0/0x72 returned 0 after 0 usecs
[    0.409140] calling  acpi_pci_init+0x0/0x4c @ 1
[    0.409239] ACPI FADT declares the system doesn't support PCIe ASPM, so disable it
[    0.409396] ACPI: bus type pci registered
[    0.409495] initcall acpi_pci_init+0x0/0x4c returned 0 after 0 usecs
[    0.409603] calling  dmi_id_init+0x0/0x2ae @ 1
[    0.409784] initcall dmi_id_init+0x0/0x2ae returned 0 after 0 usecs
[    0.409890] calling  dma_bus_init+0x0/0x32 @ 1
[    0.410017] initcall dma_bus_init+0x0/0x32 returned 0 after 0 usecs
[    0.410123] calling  dma_channel_table_init+0x0/0xcf @ 1
[    0.410234] initcall dma_channel_table_init+0x0/0xcf returned 0 after 0 usecs
[    0.410344] calling  pci_arch_init+0x0/0x5c @ 1
[    0.410482] PCI: MCFG configuration 0: base e0000000 segment 0 buses 0 - 255
[    0.410591] PCI: MCFG area at e0000000 reserved in E820
[    0.410695] PCI: Using MMCONFIG for extended config space
[    0.410797] PCI: Using configuration type 1 for base access
[    0.410910] initcall pci_arch_init+0x0/0x5c returned 0 after 976 usecs
[    0.411017] calling  topology_init+0x0/0x36 @ 1
[    0.411218] initcall topology_init+0x0/0x36 returned 0 after 0 usecs
[    0.411324] calling  mtrr_init_finialize+0x0/0x35 @ 1
[    0.411427] initcall mtrr_init_finialize+0x0/0x35 returned 0 after 0 usecs
[    0.411536] calling  param_sysfs_init+0x0/0x1cf @ 1
[    0.415163] initcall param_sysfs_init+0x0/0x1cf returned 0 after 3905 usecs
[    0.415274] calling  pm_sysrq_init+0x0/0x16 @ 1
[    0.415380] initcall pm_sysrq_init+0x0/0x16 returned 0 after 0 usecs
[    0.415487] calling  default_bdi_init+0x0/0x2f @ 1
[    0.415644] initcall default_bdi_init+0x0/0x2f returned 0 after 0 usecs
[    0.415754] calling  init_bio+0x0/0xed @ 1
[    0.415923] bio: create slab <bio-0> at 0
[    0.416025] initcall init_bio+0x0/0xed returned 0 after 0 usecs
[    0.416876] calling  fsnotify_init+0x0/0xf @ 1
[    0.416978] initcall fsnotify_init+0x0/0xf returned 0 after 0 usecs
[    0.417084] calling  fsnotify_notification_init+0x0/0x5b @ 1
[    0.417190] initcall fsnotify_notification_init+0x0/0x5b returned 0 after 0 usecs
[    0.417345] calling  cryptomgr_init+0x0/0xf @ 1
[    0.417444] initcall cryptomgr_init+0x0/0xf returned 0 after 0 usecs
[    0.417552] calling  blk_settings_init+0x0/0x1d @ 1
[    0.417658] initcall blk_settings_init+0x0/0x1d returned 0 after 0 usecs
[    0.417767] calling  blk_ioc_init+0x0/0x24 @ 1
[    0.417868] initcall blk_ioc_init+0x0/0x24 returned 0 after 0 usecs
[    0.417974] calling  blk_softirq_init+0x0/0x5b @ 1
[    0.418077] initcall blk_softirq_init+0x0/0x5b returned 0 after 0 usecs
[    0.418185] calling  genhd_device_init+0x0/0x50 @ 1
[    0.418346] initcall genhd_device_init+0x0/0x50 returned 0 after 0 usecs
[    0.418455] calling  blk_dev_integrity_init+0x0/0x24 @ 1
[    0.418558] initcall blk_dev_integrity_init+0x0/0x24 returned 0 after 0 usecs
[    0.418673] calling  pci_slot_init+0x0/0x3b @ 1
[    0.418775] initcall pci_slot_init+0x0/0x3b returned 0 after 0 usecs
[    0.418881] calling  fbmem_init+0x0/0x78 @ 1
[    0.419014] initcall fbmem_init+0x0/0x78 returned 0 after 0 usecs
[    0.419122] calling  acpi_init+0x0/0x25e @ 1
[    0.421587] ACPI: EC: Enabling special treatment for EC from MSI.
[    0.421695] ACPI: EC: Look up EC in DSDT
[    0.447361] ACPI: BIOS _OSI(Linux) query ignored
[    0.459113] ACPI: EC: non-query interrupt received, switching to interrupt mode
[    0.502240] ACPI: Interpreter enabled
[    0.502341] ACPI: (supports S0 S3 S4 S5)
[    0.502631] ACPI: Using IOAPIC for interrupt routing
[    0.514522] ACPI: EC: GPE = 0x16, I/O: command/status = 0x66, data = 0x62
[    0.514631] ACPI: EC: driver started in interrupt mode
[    0.514841] ACPI: Power Resource [APPR] (off)
[    0.515281] initcall acpi_init+0x0/0x25e returned 0 after 93794 usecs
[    0.515388] calling  dock_init+0x0/0x7d @ 1
[    0.515725] ACPI: No dock devices found.
[    0.515823] initcall dock_init+0x0/0x7d returned 0 after 0 usecs
[    0.515929] calling  acpi_pci_root_init+0x0/0x25 @ 1
[    0.517415] ACPI: PCI Root Bridge [PCI0] (0000:00)
[    0.517653] pci 0000:00:02.0: reg 10 64bit mmio: [0x50000000-0x503fffff]
[    0.517660] pci 0000:00:02.0: reg 18 64bit mmio: [0x40000000-0x4fffffff]
[    0.517665] pci 0000:00:02.0: reg 20 io port: [0x5030-0x5037]
[    0.517774] pci 0000:00:16.0: reg 10 64bit mmio: [0x54706000-0x5470600f]
[    0.517843] pci 0000:00:16.0: PME# supported from D0 D3hot D3cold
[    0.517951] pci 0000:00:16.0: PME# disabled
[    0.518126] pci 0000:00:1a.0: reg 10 32bit mmio: [0x54705c00-0x54705fff]
[    0.518199] pci 0000:00:1a.0: PME# supported from D0 D3hot D3cold
[    0.518307] pci 0000:00:1a.0: PME# disabled
[    0.518466] pci 0000:00:1b.0: reg 10 64bit mmio: [0x54700000-0x54703fff]
[    0.518531] pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
[    0.518639] pci 0000:00:1b.0: PME# disabled
[    0.518824] pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
[    0.518931] pci 0000:00:1c.0: PME# disabled
[    0.519119] pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
[    0.519227] pci 0000:00:1c.1: PME# disabled
[    0.519419] pci 0000:00:1c.5: PME# supported from D0 D3hot D3cold
[    0.519529] pci 0000:00:1c.5: PME# disabled
[    0.519698] pci 0000:00:1d.0: reg 10 32bit mmio: [0x54705800-0x54705bff]
[    0.519771] pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
[    0.519878] pci 0000:00:1d.0: PME# disabled
[    0.520213] pci 0000:00:1f.2: reg 10 io port: [0x5028-0x502f]
[    0.520221] pci 0000:00:1f.2: reg 14 io port: [0x503c-0x503f]
[    0.520230] pci 0000:00:1f.2: reg 18 io port: [0x5020-0x5027]
[    0.520238] pci 0000:00:1f.2: reg 1c io port: [0x5038-0x503b]
[    0.520247] pci 0000:00:1f.2: reg 20 io port: [0x5000-0x501f]
[    0.520255] pci 0000:00:1f.2: reg 24 32bit mmio: [0x54705000-0x547057ff]
[    0.520304] pci 0000:00:1f.2: PME# supported from D3hot
[    0.520408] pci 0000:00:1f.2: PME# disabled
[    0.520579] pci 0000:00:1f.6: reg 10 64bit mmio: [0x54704000-0x54704fff]
[    0.520712] pci 0000:00:1c.0: bridge 32bit mmio: [0x54600000-0x546fffff]
[    0.520783] pci 0000:00:1c.1: bridge io port: [0x3000-0x4fff]
[    0.520788] pci 0000:00:1c.1: bridge 32bit mmio: [0x50600000-0x545fffff]
[    0.520863] pci 0000:43:00.0: reg 10 64bit mmio: [0x50500000-0x5053ffff]
[    0.520873] pci 0000:43:00.0: reg 18 io port: [0x2000-0x207f]
[    0.520951] pci 0000:43:00.0: PME# supported from D0 D1 D2 D3hot D3cold
[    0.521061] pci 0000:43:00.0: PME# disabled
[    0.521233] pci 0000:00:1c.5: bridge io port: [0x2000-0x2fff]
[    0.521239] pci 0000:00:1c.5: bridge 32bit mmio: [0x50500000-0x505fffff]
[    0.521305] pci 0000:00:1e.0: transparent bridge
[    0.521410] pci 0000:00:1e.0: bridge 32bit mmio: [0x50400000-0x504fffff]
[    0.521447] pci_bus 0000:00: on NUMA node 0
[    0.521453] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0._PRT]
[    0.521849] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.PCIB._PRT]
[    0.521975] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP01._PRT]
[    0.522059] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP02._PRT]
[    0.522222] ACPI: PCI Interrupt Routing Table [\_SB_.PCI0.RP06._PRT]
[    0.537565] ACPI: PCI Root Bridge [CPBG] (0000:ff)
[    0.537862] pci_bus 0000:ff: on NUMA node 0
[    0.538276] initcall acpi_pci_root_init+0x0/0x25 returned 0 after 21484 usecs
[    0.538387] calling  acpi_pci_link_init+0x0/0x3f @ 1
[    0.538599] ACPI: PCI Interrupt Link [LNKA] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.539330] ACPI: PCI Interrupt Link [LNKB] (IRQs 1 3 4 *5 6 7 11 12 14 15)
[    0.540065] ACPI: PCI Interrupt Link [LNKC] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.540798] ACPI: PCI Interrupt Link [LNKD] (IRQs 1 3 4 5 6 7 11 12 14 15) *10
[    0.541614] ACPI: PCI Interrupt Link [LNKE] (IRQs 1 3 4 5 6 7 *10 12 14 15)
[    0.542344] ACPI: PCI Interrupt Link [LNKF] (IRQs 1 3 4 5 6 7 *11 12 14 15)
[    0.543077] ACPI: PCI Interrupt Link [LNKG] (IRQs 1 3 4 5 6 7 10 12 14 15) *0, disabled.
[    0.543936] ACPI: PCI Interrupt Link [LNKH] (IRQs 1 3 4 5 6 7 11 12 14 15) *0, disabled.
[    0.544753] initcall acpi_pci_link_init+0x0/0x3f returned 0 after 5859 usecs
[    0.544862] calling  pnp_init+0x0/0xf @ 1
[    0.544989] initcall pnp_init+0x0/0xf returned 0 after 0 usecs
[    0.545093] calling  misc_init+0x0/0x92 @ 1
[    0.545219] initcall misc_init+0x0/0x92 returned 0 after 0 usecs
[    0.545326] calling  twl4030_init+0x0/0x11 @ 1
[    0.545457] initcall twl4030_init+0x0/0x11 returned 0 after 976 usecs
[    0.545564] calling  da903x_init+0x0/0x11 @ 1
[    0.545689] initcall da903x_init+0x0/0x11 returned 0 after 0 usecs
[    0.545796] calling  init_scsi+0x0/0x89 @ 1
[    0.546039] SCSI subsystem initialized
[    0.546138] initcall init_scsi+0x0/0x89 returned 0 after 0 usecs
[    0.546243] calling  ata_init+0x0/0x2a9 @ 1
[    0.546409] libata version 3.00 loaded.
[    0.546412] initcall ata_init+0x0/0x2a9 returned 0 after 0 usecs
[    0.546517] calling  phy_init+0x0/0x29 @ 1
[    0.546695] initcall phy_init+0x0/0x29 returned 0 after 0 usecs
[    0.546802] calling  init_pcmcia_cs+0x0/0x2d @ 1
[    0.546929] initcall init_pcmcia_cs+0x0/0x2d returned 0 after 0 usecs
[    0.547036] calling  usb_init+0x0/0x181 @ 1
[    0.547228] usbcore: registered new interface driver usbfs
[    0.547390] usbcore: registered new interface driver hub
[    0.547538] usbcore: registered new device driver usb
[    0.547640] initcall usb_init+0x0/0x181 returned 0 after 976 usecs
[    0.547746] calling  serio_init+0x0/0x82 @ 1
[    0.547886] initcall serio_init+0x0/0x82 returned 0 after 0 usecs
[    0.547992] calling  input_init+0x0/0x101 @ 1
[    0.548120] initcall input_init+0x0/0x101 returned 0 after 0 usecs
[    0.548226] calling  power_supply_class_init+0x0/0x2b @ 1
[    0.548353] initcall power_supply_class_init+0x0/0x2b returned 0 after 0 usecs
[    0.548508] calling  thermal_init+0x0/0x46 @ 1
[    0.548631] initcall thermal_init+0x0/0x46 returned 0 after 0 usecs
[    0.548737] calling  leds_init+0x0/0x32 @ 1
[    0.548859] initcall leds_init+0x0/0x32 returned 0 after 0 usecs
[    0.548966] calling  pci_subsys_init+0x0/0xdf @ 1
[    0.549066] PCI: Using ACPI for IRQ routing
[    0.549265] initcall pci_subsys_init+0x0/0xdf returned 0 after 0 usecs
[    0.549372] calling  proto_init+0x0/0xf @ 1
[    0.549475] initcall proto_init+0x0/0xf returned 0 after 0 usecs
[    0.549580] calling  net_dev_init+0x0/0x14d @ 1
[    0.549800] initcall net_dev_init+0x0/0x14d returned 0 after 0 usecs
[    0.549908] calling  neigh_init+0x0/0x66 @ 1
[    0.550007] initcall neigh_init+0x0/0x66 returned 0 after 0 usecs
[    0.550112] calling  fib_rules_init+0x0/0x99 @ 1
[    0.550214] initcall fib_rules_init+0x0/0x99 returned 0 after 0 usecs
[    0.550320] calling  pktsched_init+0x0/0xa9 @ 1
[    0.550427] initcall pktsched_init+0x0/0xa9 returned 0 after 0 usecs
[    0.550534] calling  tc_filter_init+0x0/0x43 @ 1
[    0.550634] initcall tc_filter_init+0x0/0x43 returned 0 after 0 usecs
[    0.550741] calling  tc_action_init+0x0/0x43 @ 1
[    0.550842] initcall tc_action_init+0x0/0x43 returned 0 after 0 usecs
[    0.550949] calling  genl_init+0x0/0xb0 @ 1
[    0.554400] initcall genl_init+0x0/0xb0 returned 0 after 2929 usecs
[    0.554514] calling  wireless_nlevent_init+0x0/0x39 @ 1
[    0.554617] initcall wireless_nlevent_init+0x0/0x39 returned 0 after 0 usecs
[    0.554725] calling  sysctl_init+0x0/0x3b @ 1
[    0.554826] initcall sysctl_init+0x0/0x3b returned 0 after 0 usecs
[    0.554931] calling  pci_iommu_init+0x0/0xc @ 1
[    0.555032] initcall pci_iommu_init+0x0/0xc returned 0 after 0 usecs
[    0.555138] calling  print_all_ICs+0x0/0x43f @ 1
[    0.555244] initcall print_all_ICs+0x0/0x43f returned 0 after 0 usecs
[    0.555352] calling  hpet_late_init+0x0/0x183 @ 1
[    0.555465] hpet0: at MMIO 0xfed00000, IRQs 2, 8, 24, 25, 26, 27, 28, 0
[    0.555942] hpet0: 8 comparators, 64-bit 14.318180 MHz counter
[    0.558475] hpet: hpet2 irq 24 for MSI
[    0.559345] hpet: hpet3 irq 25 for MSI
[    0.559715] hpet: hpet4 irq 26 for MSI
[    0.560409] hpet: hpet5 irq 27 for MSI
[    0.560415] initcall hpet_late_init+0x0/0x183 returned 0 after 4882 usecs
[    0.560525] calling  clocksource_done_booting+0x0/0x11 @ 1
[    0.560629] initcall clocksource_done_booting+0x0/0x11 returned 0 after 0 usecs
[    0.560785] calling  rb_init_debugfs+0x0/0x27 @ 1
[    0.560894] initcall rb_init_debugfs+0x0/0x27 returned 0 after 0 usecs
[    0.561001] calling  tracer_init_debugfs+0x0/0x271 @ 1
[    0.561283] initcall tracer_init_debugfs+0x0/0x271 returned 0 after 0 usecs
[    0.561396] calling  init_trace_printk_function_export+0x0/0x2a @ 1
[    0.561419] Switched to high resolution mode on CPU 0
[    0.561505] initcall init_trace_printk_function_export+0x0/0x2a returned 0 after 2 usecs
[    0.561659] calling  event_trace_init+0x0/0x13d @ 1
[    0.561686] Switched to high resolution mode on CPU 2
[    0.562312] Switched to high resolution mode on CPU 1
[    0.562381] Switched to high resolution mode on CPU 3
[    0.563214] initcall event_trace_init+0x0/0x13d returned 0 after 1418 usecs
[    0.563324] calling  init_pipe_fs+0x0/0x41 @ 1
[    0.563445] initcall init_pipe_fs+0x0/0x41 returned 0 after 19 usecs
[    0.563553] calling  eventpoll_init+0x0/0x84 @ 1
[    0.563664] initcall eventpoll_init+0x0/0x84 returned 0 after 6 usecs
[    0.563772] calling  anon_inode_init+0x0/0xf2 @ 1
[    0.563884] initcall anon_inode_init+0x0/0xf2 returned 0 after 11 usecs
[    0.563992] calling  blk_scsi_ioctl_init+0x0/0x288 @ 1
[    0.564095] initcall blk_scsi_ioctl_init+0x0/0x288 returned 0 after 0 usecs
[    0.564204] calling  acpi_event_init+0x0/0x6f @ 1
[    0.567609] initcall acpi_event_init+0x0/0x6f returned 0 after 3228 usecs
[    0.567725] calling  pnpacpi_init+0x0/0x7b @ 1
[    0.567824] pnp: PnP ACPI init
[    0.567932] ACPI: bus type pnp registered
[    0.571961] pnp: PnP ACPI: found 12 devices
[    0.572059] ACPI: ACPI bus type pnp unregistered
[    0.572161] initcall pnpacpi_init+0x0/0x7b returned 0 after 4239 usecs
[    0.572267] calling  pnp_system_init+0x0/0xf @ 1
[    0.572376] system 00:01: iomem range 0xfed1c000-0xfed1ffff has been reserved
[    0.572485] system 00:01: iomem range 0xfed10000-0xfed13fff has been reserved
[    0.572597] system 00:01: iomem range 0xfed1b000-0xfed1bfff has been reserved
[    0.572706] system 00:01: iomem range 0xfed19000-0xfed19fff has been reserved
[    0.572815] system 00:01: iomem range 0x3c000000-0x3c000fff has been reserved
[    0.572925] system 00:01: iomem range 0xe0000000-0xefffffff has been reserved
[    0.573034] system 00:01: iomem range 0xfed20000-0xfed3ffff has been reserved
[    0.573144] system 00:01: iomem range 0xfed45000-0xfed8ffff has been reserved
[    0.573253] system 00:01: iomem range 0xfec00000-0xfec00fff could not be reserved
[    0.573412] system 00:06: ioport range 0x200-0x27f has been reserved
[    0.573519] system 00:06: ioport range 0x1000-0x100f has been reserved
[    0.573629] system 00:06: ioport range 0xffff-0xffff has been reserved
[    0.573735] system 00:06: ioport range 0xffff-0xffff has been reserved
[    0.573843] system 00:06: ioport range 0x400-0x47f has been reserved
[    0.574696] system 00:06: ioport range 0x500-0x57f has been reserved
[    0.574801] system 00:06: ioport range 0xef80-0xef9f has been reserved
[    0.574939] initcall pnp_system_init+0x0/0xf returned 0 after 2513 usecs
[    0.575047] calling  chr_dev_init+0x0/0x8d @ 1
[    0.575477] initcall chr_dev_init+0x0/0x8d returned 0 after 321 usecs
[    0.575589] calling  firmware_class_init+0x0/0x61 @ 1
[    0.575718] initcall firmware_class_init+0x0/0x61 returned 0 after 25 usecs
[    0.575827] calling  init_pcmcia_bus+0x0/0x6c @ 1
[    0.575970] initcall init_pcmcia_bus+0x0/0x6c returned 0 after 40 usecs
[    0.576079] calling  cpufreq_gov_performance_init+0x0/0xf @ 1
[    0.576188] initcall cpufreq_gov_performance_init+0x0/0xf returned 0 after 4 usecs
[    0.576341] calling  cpufreq_gov_userspace_init+0x0/0xf @ 1
[    0.576445] initcall cpufreq_gov_userspace_init+0x0/0xf returned 0 after 0 usecs
[    0.576601] calling  init_acpi_pm_clocksource+0x0/0x1a9 @ 1
[    0.611197] initcall init_acpi_pm_clocksource+0x0/0x1a9 returned 0 after 33727 usecs
[    0.611351] calling  pcibios_assign_resources+0x0/0x66 @ 1
[    0.611514] pci 0000:00:1c.0: PCI bridge, secondary bus 0000:01
[    0.611621] pci 0000:00:1c.0:   IO window: disabled
[    0.611726] pci 0000:00:1c.0:   MEM window: 0x54600000-0x546fffff
[    0.611835] pci 0000:00:1c.0:   PREFETCH window: disabled
[    0.611939] pci 0000:00:1c.1: PCI bridge, secondary bus 0000:02
[    0.612045] pci 0000:00:1c.1:   IO window: 0x3000-0x4fff
[    0.612151] pci 0000:00:1c.1:   MEM window: 0x50600000-0x545fffff
[    0.612258] pci 0000:00:1c.1:   PREFETCH window: disabled
[    0.612364] pci 0000:00:1c.5: PCI bridge, secondary bus 0000:43
[    0.612472] pci 0000:00:1c.5:   IO window: 0x2000-0x2fff
[    0.612582] pci 0000:00:1c.5:   MEM window: 0x50500000-0x505fffff
[    0.612690] pci 0000:00:1c.5:   PREFETCH window: disabled
[    0.612796] pci 0000:00:1e.0: PCI bridge, secondary bus 0000:44
[    0.612899] pci 0000:00:1e.0:   IO window: disabled
[    0.613005] pci 0000:00:1e.0:   MEM window: 0x50400000-0x504fffff
[    0.613111] pci 0000:00:1e.0:   PREFETCH window: disabled
[    0.613227] pci 0000:00:1c.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[    0.613338] pci 0000:00:1c.0: setting latency timer to 64
[    0.613349] pci 0000:00:1c.1: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.613459] pci 0000:00:1c.1: setting latency timer to 64
[    0.613469] pci 0000:00:1c.5: PCI INT B -> GSI 16 (level, low) -> IRQ 16
[    0.613582] pci 0000:00:1c.5: setting latency timer to 64
[    0.613591] pci 0000:00:1e.0: setting latency timer to 64
[    0.613595] pci_bus 0000:00: resource 0 io:  [0x00-0xffff]
[    0.613598] pci_bus 0000:00: resource 1 mem: [0x000000-0xffffffff]
[    0.613600] pci_bus 0000:01: resource 1 mem: [0x54600000-0x546fffff]
[    0.613602] pci_bus 0000:02: resource 0 io:  [0x3000-0x4fff]
[    0.613604] pci_bus 0000:02: resource 1 mem: [0x50600000-0x545fffff]
[    0.613607] pci_bus 0000:43: resource 0 io:  [0x2000-0x2fff]
[    0.613609] pci_bus 0000:43: resource 1 mem: [0x50500000-0x505fffff]
[    0.613611] pci_bus 0000:44: resource 1 mem: [0x50400000-0x504fffff]
[    0.613613] pci_bus 0000:44: resource 3 io:  [0x00-0xffff]
[    0.613615] pci_bus 0000:44: resource 4 mem: [0x000000-0xffffffff]
[    0.613617] pci_bus 0000:ff: resource 0 io:  [0x00-0xffff]
[    0.613619] pci_bus 0000:ff: resource 1 mem: [0x000000-0xffffffff]
[    0.613623] initcall pcibios_assign_resources+0x0/0x66 returned 0 after 2119 usecs
[    0.613776] calling  sysctl_core_init+0x0/0x2d @ 1
[    0.613903] initcall sysctl_core_init+0x0/0x2d returned 0 after 25 usecs
[    0.614010] calling  inet_init+0x0/0x1c3 @ 1
[    0.614116] NET: Registered protocol family 2
[    0.614342] IP route cache hash table entries: 32768 (order: 5, 131072 bytes)
[    0.614800] TCP established hash table entries: 131072 (order: 8, 1048576 bytes)
[    0.615779] TCP bind hash table entries: 65536 (order: 9, 2097152 bytes)
[    0.618038] TCP: Hash tables configured (established 131072 bind 65536)
[    0.618163] TCP reno registered
[    0.618388] initcall inet_init+0x0/0x1c3 returned 0 after 4180 usecs
[    0.618495] calling  af_unix_init+0x0/0x47 @ 1
[    0.618599] NET: Registered protocol family 1
[    0.618709] initcall af_unix_init+0x0/0x47 returned 0 after 108 usecs
[    0.618820] calling  populate_rootfs+0x0/0x203 @ 1
[    0.618977] Trying to unpack rootfs image as initramfs...
[    0.736273] Freeing initrd memory: 4988k freed
[    0.737450] initcall populate_rootfs+0x0/0x203 returned 0 after 115897 usecs
[    0.737562] calling  i8259A_init_sysfs+0x0/0x1d @ 1
[    0.737784] initcall i8259A_init_sysfs+0x0/0x1d returned 0 after 117 usecs
[    0.737892] calling  sbf_init+0x0/0xbd @ 1
[    0.737990] initcall sbf_init+0x0/0xbd returned 0 after 0 usecs
[    0.738096] calling  i8237A_init_sysfs+0x0/0x1d @ 1
[    0.738253] initcall i8237A_init_sysfs+0x0/0x1d returned 0 after 53 usecs
[    0.738361] calling  add_rtc_cmos+0x0/0x7e @ 1
[    0.738468] initcall add_rtc_cmos+0x0/0x7e returned 0 after 3 usecs
[    0.738576] calling  cache_sysfs_init+0x0/0x50 @ 1
[    0.739445] initcall cache_sysfs_init+0x0/0x50 returned 0 after 749 usecs
[    0.739554] calling  mce_init_device+0x0/0x124 @ 1
[    0.739894] initcall mce_init_device+0x0/0x124 returned 0 after 232 usecs
[    0.740001] calling  threshold_init_device+0x0/0x41 @ 1
[    0.740104] initcall threshold_init_device+0x0/0x41 returned 0 after 0 usecs
[    0.740213] calling  thermal_throttle_init_device+0x0/0x79 @ 1
[    0.740330] initcall thermal_throttle_init_device+0x0/0x79 returned 0 after 11 usecs
[    0.740487] calling  powernow_k6_init+0x0/0x85 @ 1
[    0.740588] initcall powernow_k6_init+0x0/0x85 returned -19 after 0 usecs
[    0.740697] calling  eps_init+0x0/0x3e @ 1
[    0.740795] initcall eps_init+0x0/0x3e returned -19 after 0 usecs
[    0.740901] calling  longrun_init+0x0/0x2d @ 1
[    0.741002] initcall longrun_init+0x0/0x2d returned -19 after 0 usecs
[    0.741109] calling  cpufreq_gx_init+0x0/0x168 @ 1
[    0.741210] initcall cpufreq_gx_init+0x0/0x168 returned -19 after 0 usecs
[    0.741316] calling  ioapic_init_sysfs+0x0/0x84 @ 1
[    0.741493] initcall ioapic_init_sysfs+0x0/0x84 returned 0 after 57 usecs
[    0.741602] calling  add_pcspkr+0x0/0x24 @ 1
[    0.741740] initcall add_pcspkr+0x0/0x24 returned 0 after 37 usecs
[    0.741846] calling  init_sched_debug_procfs+0x0/0x27 @ 1
[    0.741954] initcall init_sched_debug_procfs+0x0/0x27 returned 0 after 4 usecs
[    0.742105] calling  proc_execdomains_init+0x0/0x1c @ 1
[    0.742208] initcall proc_execdomains_init+0x0/0x1c returned 0 after 1 usecs
[    0.742317] calling  ioresources_init+0x0/0x31 @ 1
[    0.742423] initcall ioresources_init+0x0/0x31 returned 0 after 2 usecs
[    0.742532] calling  uid_cache_init+0x0/0x5e @ 1
[    0.742641] initcall uid_cache_init+0x0/0x5e returned 0 after 8 usecs
[    0.742747] calling  init_posix_timers+0x0/0xb3 @ 1
[    0.742851] initcall init_posix_timers+0x0/0xb3 returned 0 after 1 usecs
[    0.742957] calling  init_posix_cpu_timers+0x0/0x90 @ 1
[    0.743061] initcall init_posix_cpu_timers+0x0/0x90 returned 0 after 0 usecs
[    0.743170] calling  nsproxy_cache_init+0x0/0x27 @ 1
[    0.743271] initcall nsproxy_cache_init+0x0/0x27 returned 0 after 0 usecs
[    0.743381] calling  timekeeping_init_device+0x0/0x1d @ 1
[    0.743538] initcall timekeeping_init_device+0x0/0x1d returned 0 after 51 usecs
[    0.743692] calling  init_clocksource_sysfs+0x0/0x43 @ 1
[    0.743845] initcall init_clocksource_sysfs+0x0/0x43 returned 0 after 47 usecs
[    0.743998] calling  init_timer_list_procfs+0x0/0x27 @ 1
[    0.744104] initcall init_timer_list_procfs+0x0/0x27 returned 0 after 1 usecs
[    0.744213] calling  init_tstats_procfs+0x0/0x27 @ 1
[    0.744317] initcall init_tstats_procfs+0x0/0x27 returned 0 after 1 usecs
[    0.744428] calling  lockdep_proc_init+0x0/0x37 @ 1
[    0.744533] initcall lockdep_proc_init+0x0/0x37 returned 0 after 2 usecs
[    0.744640] calling  futex_init+0x0/0x78 @ 1
[    0.744751] initcall futex_init+0x0/0x78 returned 0 after 11 usecs
[    0.744857] calling  proc_dma_init+0x0/0x1c @ 1
[    0.744959] initcall proc_dma_init+0x0/0x1c returned 0 after 1 usecs
[    0.745066] calling  proc_modules_init+0x0/0x1c @ 1
[    0.745169] initcall proc_modules_init+0x0/0x1c returned 0 after 1 usecs
[    0.745277] calling  kallsyms_init+0x0/0x1f @ 1
[    0.745381] initcall kallsyms_init+0x0/0x1f returned 0 after 1 usecs
[    0.745488] calling  snapshot_device_init+0x0/0xf @ 1
[    0.745626] initcall snapshot_device_init+0x0/0xf returned 0 after 35 usecs
[    0.745735] calling  crash_save_vmcoreinfo_init+0x0/0x348 @ 1
[    0.745858] initcall crash_save_vmcoreinfo_init+0x0/0x348 returned 0 after 16 usecs
[    0.746013] calling  crash_notes_memory_init+0x0/0x31 @ 1
[    0.746120] initcall crash_notes_memory_init+0x0/0x31 returned 0 after 3 usecs
[    0.746273] calling  pid_namespaces_init+0x0/0x27 @ 1
[    0.746380] initcall pid_namespaces_init+0x0/0x27 returned 0 after 0 usecs
[    0.746488] calling  hung_task_init+0x0/0x42 @ 1
[    0.746609] initcall hung_task_init+0x0/0x42 returned 0 after 19 usecs
[    0.746715] calling  utsname_sysctl_init+0x0/0x11 @ 1
[    0.746845] initcall utsname_sysctl_init+0x0/0x11 returned 0 after 27 usecs
[    0.746955] calling  init_markers+0x0/0xf @ 1
[    0.747055] initcall init_markers+0x0/0xf returned 0 after 0 usecs
[    0.747161] calling  init_tracepoints+0x0/0xf @ 1
[    0.747261] initcall init_tracepoints+0x0/0xf returned 0 after 0 usecs
[    0.747370] calling  init_events+0x0/0x5a @ 1
[    0.747472] initcall init_events+0x0/0x5a returned 0 after 2 usecs
[    0.747578] calling  init_sched_switch_trace+0x0/0xf @ 1
[    0.747683] initcall init_sched_switch_trace+0x0/0xf returned 0 after 1 usecs
[    0.747792] calling  init_blk_tracer+0x0/0x4b @ 1
[    0.747893] initcall init_blk_tracer+0x0/0x4b returned 0 after 0 usecs
[    0.748000] calling  init_per_zone_wmark_min+0x0/0x59 @ 1
[    0.748135] initcall init_per_zone_wmark_min+0x0/0x59 returned 0 after 31 usecs
[    0.748289] calling  pdflush_init+0x0/0x20 @ 1
[    0.748427] initcall pdflush_init+0x0/0x20 returned 0 after 34 usecs
[    0.748534] calling  kswapd_init+0x0/0x1d @ 1
[    0.748654] initcall kswapd_init+0x0/0x1d returned 0 after 20 usecs
[    0.748761] calling  init_tmpfs+0x0/0xb9 @ 1
[    0.748898] initcall init_tmpfs+0x0/0xb9 returned 0 after 35 usecs
[    0.749005] calling  setup_vmstat+0x0/0xa8 @ 1
[    0.749114] initcall setup_vmstat+0x0/0xa8 returned 0 after 9 usecs
[    0.749221] calling  mm_sysfs_init+0x0/0x22 @ 1
[    0.749325] initcall mm_sysfs_init+0x0/0x22 returned 0 after 3 usecs
[    0.749435] calling  proc_vmalloc_init+0x0/0x1f @ 1
[    0.749538] initcall proc_vmalloc_init+0x0/0x1f returned 0 after 1 usecs
[    0.749646] calling  init_emergency_pool+0x0/0x57 @ 1
[    0.749763] highmem bounce pool size: 64 pages
[    0.749863] initcall init_emergency_pool+0x0/0x57 returned 0 after 112 usecs
[    0.749972] calling  procswaps_init+0x0/0x1c @ 1
[    0.750074] initcall procswaps_init+0x0/0x1c returned 0 after 1 usecs
[    0.750181] calling  hugetlb_init+0x0/0x261 @ 1
[    0.750282] HugeTLB registered 4 MB page size, pre-allocated 0 pages
[    0.750400] initcall hugetlb_init+0x0/0x261 returned 0 after 116 usecs
[    0.750508] calling  slab_proc_init+0x0/0x1f @ 1
[    0.750609] initcall slab_proc_init+0x0/0x1f returned 0 after 1 usecs
[    0.750716] calling  slab_sysfs_init+0x0/0xb7 @ 1
[    0.753477] initcall slab_sysfs_init+0x0/0xb7 returned 0 after 2601 usecs
[    0.753587] calling  fasync_init+0x0/0x24 @ 1
[    0.753690] initcall fasync_init+0x0/0x24 returned 0 after 4 usecs
[    0.753796] calling  proc_filesystems_init+0x0/0x1c @ 1
[    0.753901] initcall proc_filesystems_init+0x0/0x1c returned 0 after 2 usecs
[    0.754009] calling  dnotify_init+0x0/0x6f @ 1
[    0.754121] initcall dnotify_init+0x0/0x6f returned 0 after 12 usecs
[    0.754227] calling  inotify_setup+0x0/0x11 @ 1
[    0.755074] initcall inotify_setup+0x0/0x11 returned 0 after 0 usecs
[    0.755180] calling  inotify_user_setup+0x0/0x9e @ 1
[    0.755306] initcall inotify_user_setup+0x0/0x9e returned 0 after 22 usecs
[    0.755417] calling  aio_setup+0x0/0x66 @ 1
[    0.755583] initcall aio_setup+0x0/0x66 returned 0 after 64 usecs
[    0.755689] calling  proc_locks_init+0x0/0x1c @ 1
[    0.755791] initcall proc_locks_init+0x0/0x1c returned 0 after 1 usecs
[    0.755897] calling  init_mbcache+0x0/0x11 @ 1
[    0.755997] initcall init_mbcache+0x0/0x11 returned 0 after 0 usecs
[    0.756104] calling  dquot_init+0x0/0xc1 @ 1
[    0.756202] VFS: Disk quotas dquot_6.5.2
[    0.756395] Dquot-cache hash table entries: 1024 (order 0, 4096 bytes)
[    0.756504] initcall dquot_init+0x0/0xc1 returned 0 after 294 usecs
[    0.756609] calling  init_v2_quota_format+0x0/0xf @ 1
[    0.756711] initcall init_v2_quota_format+0x0/0xf returned 0 after 0 usecs
[    0.756819] calling  proc_cmdline_init+0x0/0x1c @ 1
[    0.756922] initcall proc_cmdline_init+0x0/0x1c returned 0 after 1 usecs
[    0.757030] calling  proc_cpuinfo_init+0x0/0x1c @ 1
[    0.757133] initcall proc_cpuinfo_init+0x0/0x1c returned 0 after 1 usecs
[    0.757240] calling  proc_devices_init+0x0/0x1c @ 1
[    0.757346] initcall proc_devices_init+0x0/0x1c returned 0 after 1 usecs
[    0.757452] calling  proc_interrupts_init+0x0/0x1c @ 1
[    0.757556] initcall proc_interrupts_init+0x0/0x1c returned 0 after 1 usecs
[    0.757665] calling  proc_loadavg_init+0x0/0x1c @ 1
[    0.757767] initcall proc_loadavg_init+0x0/0x1c returned 0 after 1 usecs
[    0.757874] calling  proc_meminfo_init+0x0/0x1c @ 1
[    0.757977] initcall proc_meminfo_init+0x0/0x1c returned 0 after 1 usecs
[    0.758084] calling  proc_stat_init+0x0/0x1c @ 1
[    0.758186] initcall proc_stat_init+0x0/0x1c returned 0 after 1 usecs
[    0.758295] calling  proc_uptime_init+0x0/0x1c @ 1
[    0.758400] initcall proc_uptime_init+0x0/0x1c returned 0 after 1 usecs
[    0.758507] calling  proc_version_init+0x0/0x1c @ 1
[    0.758610] initcall proc_version_init+0x0/0x1c returned 0 after 1 usecs
[    0.758718] calling  proc_softirqs_init+0x0/0x1c @ 1
[    0.758821] initcall proc_softirqs_init+0x0/0x1c returned 0 after 1 usecs
[    0.758928] calling  proc_kcore_init+0x0/0x40 @ 1
[    0.759030] initcall proc_kcore_init+0x0/0x40 returned 0 after 1 usecs
[    0.759137] calling  vmcore_init+0x0/0xa11 @ 1
[    0.759238] initcall vmcore_init+0x0/0xa11 returned 0 after 0 usecs
[    0.759346] calling  proc_kmsg_init+0x0/0x1f @ 1
[    0.759447] initcall proc_kmsg_init+0x0/0x1f returned 0 after 1 usecs
[    0.759553] calling  proc_page_init+0x0/0x37 @ 1
[    0.759655] initcall proc_page_init+0x0/0x37 returned 0 after 2 usecs
[    0.759761] calling  init_devpts_fs+0x0/0x41 @ 1
[    0.759880] initcall init_devpts_fs+0x0/0x41 returned 0 after 17 usecs
[    0.759987] calling  init_ext3_fs+0x0/0x5f @ 1
[    0.760199] initcall init_ext3_fs+0x0/0x5f returned 0 after 109 usecs
[    0.760307] calling  init_ext2_fs+0x0/0x5f @ 1
[    0.760463] initcall init_ext2_fs+0x0/0x5f returned 0 after 51 usecs
[    0.760569] calling  init_ext4_fs+0x0/0xe5 @ 1
[    0.760929] initcall init_ext4_fs+0x0/0xe5 returned 0 after 253 usecs
[    0.761035] calling  journal_init+0x0/0x85 @ 1
[    0.761293] initcall journal_init+0x0/0x85 returned 0 after 153 usecs
[    0.761403] calling  journal_init+0x0/0x98 @ 1
[    0.761518] initcall journal_init+0x0/0x98 returned 0 after 16 usecs
[    0.761624] calling  init_ramfs_fs+0x0/0xf @ 1
[    0.761727] initcall init_ramfs_fs+0x0/0xf returned 0 after 1 usecs
[    0.761832] calling  init_hugetlbfs_fs+0x0/0x84 @ 1
[    0.762012] initcall init_hugetlbfs_fs+0x0/0x84 returned 0 after 75 usecs
[    0.762120] calling  init_iso9660_fs+0x0/0x61 @ 1
[    0.762283] initcall init_iso9660_fs+0x0/0x61 returned 0 after 59 usecs
[    0.762393] calling  init_nls_cp437+0x0/0xf @ 1
[    0.762499] initcall init_nls_cp437+0x0/0xf returned 0 after 4 usecs
[    0.762605] calling  init_nls_ascii+0x0/0xf @ 1
[    0.762705] initcall init_nls_ascii+0x0/0xf returned 0 after 0 usecs
[    0.762810] calling  ipc_init+0x0/0x20 @ 1
[    0.762911] msgmni has been set to 1718
[    0.763012] initcall ipc_init+0x0/0x20 returned 0 after 101 usecs
[    0.763118] calling  ipc_sysctl_init+0x0/0x11 @ 1
[    0.763255] initcall ipc_sysctl_init+0x0/0x11 returned 0 after 35 usecs
[    0.763366] calling  init_mqueue_fs+0x0/0xa8 @ 1
[    0.763564] initcall init_mqueue_fs+0x0/0xa8 returned 0 after 95 usecs
[    0.763671] calling  key_proc_init+0x0/0x2c @ 1
[    0.763774] initcall key_proc_init+0x0/0x2c returned 0 after 2 usecs
[    0.763881] calling  crypto_wq_init+0x0/0x2f @ 1
[    0.764036] initcall crypto_wq_init+0x0/0x2f returned 0 after 53 usecs
[    0.764143] calling  crypto_algapi_init+0x0/0xc @ 1
[    0.764255] initcall crypto_algapi_init+0x0/0xc returned 0 after 9 usecs
[    0.764367] calling  chainiv_module_init+0x0/0xf @ 1
[    0.764478] initcall chainiv_module_init+0x0/0xf returned 0 after 8 usecs
[    0.764586] calling  eseqiv_module_init+0x0/0xf @ 1
[    0.764688] initcall eseqiv_module_init+0x0/0xf returned 0 after 0 usecs
[    0.764795] calling  hmac_module_init+0x0/0xf @ 1
[    0.764896] initcall hmac_module_init+0x0/0xf returned 0 after 0 usecs
[    0.765004] calling  md5_mod_init+0x0/0xf @ 1
[    0.765138] initcall md5_mod_init+0x0/0xf returned 0 after 32 usecs
[    0.765244] calling  sha1_generic_mod_init+0x0/0xf @ 1
[    0.765374] initcall sha1_generic_mod_init+0x0/0xf returned 0 after 23 usecs
[    0.765483] calling  krng_mod_init+0x0/0xf @ 1
[    0.765596] alg: No test for stdrng (krng)
[    0.765699] initcall krng_mod_init+0x0/0xf returned 0 after 113 usecs
[    0.765805] calling  proc_genhd_init+0x0/0x31 @ 1
[    0.765909] initcall proc_genhd_init+0x0/0x31 returned 0 after 3 usecs
[    0.766016] calling  bsg_init+0x0/0x10d @ 1
[    0.766203] Block layer SCSI generic (bsg) driver version 0.4 loaded (major 253)
[    0.766361] initcall bsg_init+0x0/0x10d returned 0 after 240 usecs
[    0.766467] calling  noop_init+0x0/0x11 @ 1
[    0.766570] io scheduler noop registered
[    0.766668] initcall noop_init+0x0/0x11 returned 0 after 99 usecs
[    0.766773] calling  as_init+0x0/0x11 @ 1
[    0.766871] io scheduler anticipatory registered
[    0.766973] initcall as_init+0x0/0x11 returned 0 after 98 usecs
[    0.767077] calling  deadline_init+0x0/0x11 @ 1
[    0.767177] io scheduler deadline registered
[    0.767275] initcall deadline_init+0x0/0x11 returned 0 after 95 usecs
[    0.767383] calling  cfq_init+0x0/0x91 @ 1
[    0.767543] io scheduler cfq registered (default)
[    0.767645] initcall cfq_init+0x0/0x91 returned 0 after 158 usecs
[    0.767750] calling  percpu_counter_startup+0x0/0x16 @ 1
[    0.767855] initcall percpu_counter_startup+0x0/0x16 returned 0 after 1 usecs
[    0.767964] calling  pci_init+0x0/0x2c @ 1
[    0.768071] pci 0000:00:02.0: Boot video device
[    0.768129] initcall pci_init+0x0/0x2c returned 0 after 64 usecs
[    0.768236] calling  pci_proc_init+0x0/0x5b @ 1
[    0.768387] initcall pci_proc_init+0x0/0x5b returned 0 after 46 usecs
[    0.768494] calling  pcie_portdrv_init+0x0/0x41 @ 1
[    0.768726] pcieport-driver 0000:00:1c.0: irq 29 for MSI/MSI-X
[    0.768739] pcieport-driver 0000:00:1c.0: setting latency timer to 64
[    0.768909] pcieport-driver 0000:00:1c.1: irq 30 for MSI/MSI-X
[    0.768920] pcieport-driver 0000:00:1c.1: setting latency timer to 64
[    0.769120] pcieport-driver 0000:00:1c.5: irq 31 for MSI/MSI-X
[    0.769131] pcieport-driver 0000:00:1c.5: setting latency timer to 64
[    0.769299] initcall pcie_portdrv_init+0x0/0x41 returned 0 after 685 usecs
[    0.769411] calling  aer_service_init+0x0/0x1d @ 1
[    0.769548] initcall aer_service_init+0x0/0x1d returned 0 after 33 usecs
[    0.769657] calling  pci_hotplug_init+0x0/0x41 @ 1
[    0.769758] pci_hotplug: PCI Hot Plug PCI Core version: 0.5
[    0.769862] initcall pci_hotplug_init+0x0/0x41 returned 0 after 100 usecs
[    0.769970] calling  fb_console_init+0x0/0xf5 @ 1
[    0.770120] initcall fb_console_init+0x0/0xf5 returned 0 after 46 usecs
[    0.770227] calling  genericbl_init+0x0/0xf @ 1
[    0.770364] initcall genericbl_init+0x0/0xf returned 0 after 31 usecs
[    0.770471] calling  imsttfb_init+0x0/0xec @ 1
[    0.770606] initcall imsttfb_init+0x0/0xec returned 0 after 34 usecs
[    0.770712] calling  asiliantfb_init+0x0/0x2f @ 1
[    0.770848] initcall asiliantfb_init+0x0/0x2f returned 0 after 33 usecs
[    0.770956] calling  vesafb_init+0x0/0x1f9 @ 1
[    0.771130] initcall vesafb_init+0x0/0x1f9 returned 0 after 71 usecs
[    0.771237] calling  efifb_init+0x0/0x1b8 @ 1
[    0.771347] initcall efifb_init+0x0/0x1b8 returned -19 after 7 usecs
[    0.771454] calling  acpi_reserve_resources+0x0/0xc8 @ 1
[    0.771558] initcall acpi_reserve_resources+0x0/0xc8 returned 0 after 2 usecs
[    0.771669] calling  irqrouter_init_sysfs+0x0/0x33 @ 1
[    0.771824] initcall irqrouter_init_sysfs+0x0/0x33 returned 0 after 50 usecs
[    0.771933] calling  acpi_ac_init+0x0/0x3d @ 1
[    0.772452] ACPI: AC Adapter [AC] (on-line)
[    0.772622] initcall acpi_ac_init+0x0/0x3d returned 0 after 573 usecs
[    0.772729] calling  acpi_button_init+0x0/0x4a @ 1
[    0.772913] input: Power Button as /class/input/input0
[    0.773026] ACPI: Power Button [PWRF]
[    0.773216] input: Power Button as /class/input/input1
[    0.773322] ACPI: Power Button [SLPB]
[    0.773483] input: Lid Switch as /class/input/input2
[    0.773653] ACPI: Lid Switch [LID]
[    0.773783] initcall acpi_button_init+0x0/0x4a returned 0 after 930 usecs
[    0.773892] calling  acpi_fan_init+0x0/0x4a @ 1
[    0.774043] initcall acpi_fan_init+0x0/0x4a returned 0 after 48 usecs
[    0.774150] calling  acpi_video_init+0x0/0x6b @ 1
[    0.774259] initcall acpi_video_init+0x0/0x6b returned 0 after 5 usecs
[    0.774370] calling  acpi_processor_init+0x0/0xf6 @ 1
[    0.775052] ACPI: SSDT 376c8918 003EB (v01  PmRef  Cpu0Ist 00003000 INTL 20060912)
[    0.776146] ACPI: SSDT 376c6698 005E5 (v01  PmRef  Cpu0Cst 00003001 INTL 20060912)
[    0.778803] Monitor-Mwait will be used to enter C-1 state
[    0.778825] Monitor-Mwait will be used to enter C-2 state
[    0.778912] processor LNXCPU:00: registered as cooling_device0
[    0.779019] ACPI: Processor [CPU0] (supports 8 throttling states)
[    0.779718] ACPI: SSDT 376c7a98 00303 (v01  PmRef    ApIst 00003000 INTL 20060912)
[    0.780750] ACPI: SSDT 376c5d98 00119 (v01  PmRef    ApCst 00003000 INTL 20060912)
[    0.782395] processor LNXCPU:01: registered as cooling_device1
[    0.782503] ACPI: Processor [CPU1] (supports 8 throttling states)
[    0.783942] processor LNXCPU:02: registered as cooling_device2
[    0.784049] ACPI: Processor [CPU2] (supports 8 throttling states)
[    0.785425] processor LNXCPU:03: registered as cooling_device3
[    0.785531] ACPI: Processor [CPU3] (supports 8 throttling states)
[    0.785876] initcall acpi_processor_init+0x0/0xf6 returned 0 after 11149 usecs
[    0.786028] calling  acpi_container_init+0x0/0x3d @ 1
[    0.791168] initcall acpi_container_init+0x0/0x3d returned 0 after 4924 usecs
[    0.791278] calling  acpi_thermal_init+0x0/0x6f @ 1
[    0.797883] thermal LNXTHERM:01: registered as thermal_zone0
[    0.797993] ACPI: Thermal Zone [EXTZ] (50 C)
[    0.798265] thermal LNXTHERM:02: registered as thermal_zone1
[    0.798380] ACPI: Thermal Zone [EX2Z] (0 C)
[    0.798653] thermal LNXTHERM:03: registered as thermal_zone2
[    0.799511] ACPI: Thermal Zone [PWMZ] (0 C)
[    0.803430] thermal LNXTHERM:04: registered as thermal_zone3
[    0.803541] ACPI: Thermal Zone [LOCZ] (49 C)
[    0.804581] thermal LNXTHERM:05: registered as thermal_zone4
[    0.804692] ACPI: Thermal Zone [GFXZ] (0 C)
[    0.818812] thermal LNXTHERM:06: registered as thermal_zone5
[    0.818924] ACPI: Thermal Zone [BATZ] (27 C)
[    0.833388] thermal LNXTHERM:07: registered as thermal_zone6
[    0.833497] ACPI: Thermal Zone [EGXZ] (0 C)
[    0.834016] thermal LNXTHERM:08: registered as thermal_zone7
[    0.834131] ACPI: Thermal Zone [CPUZ] (60 C)
[    0.834621] thermal LNXTHERM:09: registered as thermal_zone8
[    0.834730] ACPI: Thermal Zone [MCHZ] (60 C)
[    0.835218] thermal LNXTHERM:0a: registered as thermal_zone9
[    0.835328] ACPI: Thermal Zone [PCHZ] (65 C)
[    0.835462] initcall acpi_thermal_init+0x0/0x6f returned 0 after 43102 usecs
[    0.835572] calling  acpi_battery_init+0x0/0x13 @ 1
[    0.835682] initcall acpi_battery_init+0x0/0x13 returned 0 after 7 usecs
[    0.835716] calling  1_acpi_battery_init_async+0x0/0x34 @ 492
[    0.835886] calling  isapnp_init+0x0/0xc82 @ 1
[    0.835992] isapnp: Scanning for PnP cards...
[    0.903338] ACPI: Battery Slot [BAT0] (battery present)
[    0.903484] initcall 1_acpi_battery_init_async+0x0/0x34 returned 0 after 66263 usecs
[    1.193984] isapnp: No Plug & Play device found
[    1.194086] initcall isapnp_init+0x0/0xc82 returned 0 after 350175 usecs
[    1.194195] calling  rand_initialize+0x0/0x25 @ 1
[    1.194317] initcall rand_initialize+0x0/0x25 returned 0 after 20 usecs
[    1.194425] calling  tty_init+0x0/0xd5 @ 1
[    1.197100] initcall tty_init+0x0/0xd5 returned 0 after 2517 usecs
[    1.197208] calling  pty_init+0x0/0x20d @ 1
[    1.197369] initcall pty_init+0x0/0x20d returned 0 after 59 usecs
[    1.197474] calling  sysrq_init+0x0/0x1f @ 1
[    1.197578] initcall sysrq_init+0x0/0x1f returned 0 after 4 usecs
[    1.197692] calling  hpet_init+0x0/0x57 @ 1
[    1.198025] initcall hpet_init+0x0/0x57 returned 0 after 228 usecs
[    1.198131] calling  nvram_init+0x0/0x70 @ 1
[    1.198270] Non-volatile memory driver v1.3
[    1.198370] initcall nvram_init+0x0/0x70 returned 0 after 136 usecs
[    1.198476] calling  agp_init+0x0/0x21 @ 1
[    1.198573] Linux agpgart interface v0.103
[    1.198677] initcall agp_init+0x0/0x21 returned 0 after 100 usecs
[    1.198780] calling  agp_intel_init+0x0/0x24 @ 1
[    1.198892] agpgart-intel 0000:00:00.0: Intel IGDNG/M Chipset
[    1.199607] agpgart-intel 0000:00:00.0: detected 32764K stolen memory
[    1.207599] agpgart-intel 0000:00:00.0: AGP aperture is 256M @ 0x40000000
[    1.207769] initcall agp_intel_init+0x0/0x24 returned 0 after 8687 usecs
[    1.207878] calling  drm_core_init+0x0/0xea @ 1
[    1.208032] [drm] Initialized drm 1.1.0 20060810
[    1.208134] initcall drm_core_init+0x0/0xea returned 0 after 152 usecs
[    1.208240] calling  i915_init+0x0/0x5f @ 1
[    1.208358] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    1.208467] i915 0000:00:02.0: setting latency timer to 64
[    1.211126] i915 0000:00:02.0: irq 32 for MSI/MSI-X
[    1.319040] [drm:intel_dp_i2c_init] *ERROR* i2c_init DPDDC-D
[    1.444164] i2c-adapter i2c-2: unable to read EDID block.
[    1.444270] i915 0000:00:02.0: DVI-D-1: no EDID data
[    1.740904] [drm] LVDS-8: set mode 1366x768 12
[    1.740909] unmatched BPC setting between FDI RX reg and pipeconf for pipe A
[    1.741574] Fix unmatched BPC setting between Transcoder and Pipe config in pipe A
[    2.195414] Console: switching to colour frame buffer device 170x48
[    2.201058] [drm] fb0: inteldrmfb frame buffer device
[    2.206020] acpi device:10: registered as cooling_device4
[    2.206765] input: Video Bus as /class/input/input3
[    2.206816] ACPI: Video Device [GFX0] (multi-head: yes  rom: no  post: no)
[    2.206925] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
[    2.207039] initcall i915_init+0x0/0x5f returned 0 after 976595 usecs
[    2.207096] calling  serial8250_init+0x0/0x113 @ 1
[    2.207140] Serial: 8250/16550 driver, 4 ports, IRQ sharing enabled
[    2.207574] initcall serial8250_init+0x0/0x113 returned 0 after 422 usecs
[    2.207638] calling  serial8250_pnp_init+0x0/0xf @ 1
[    2.207804] initcall serial8250_pnp_init+0x0/0xf returned 0 after 116 usecs
[    2.207869] calling  serial8250_pci_init+0x0/0x16 @ 1
[    2.207966] initcall serial8250_pci_init+0x0/0x16 returned 0 after 48 usecs
[    2.208032] calling  isa_bus_init+0x0/0x33 @ 1
[    2.208119] initcall isa_bus_init+0x0/0x33 returned 0 after 43 usecs
[    2.208179] calling  topology_sysfs_init+0x0/0x3f @ 1
[    2.208255] initcall topology_sysfs_init+0x0/0x3f returned 0 after 25 usecs
[    2.208318] calling  brd_init+0x0/0x14e @ 1
[    2.210082] brd: module loaded
[    2.210114] initcall brd_init+0x0/0x14e returned 0 after 1718 usecs
[    2.210171] calling  ezx_pcap_init+0x0/0xf @ 1
[    2.210251] initcall ezx_pcap_init+0x0/0xf returned 0 after 35 usecs
[    2.211337] calling  ide_init+0x0/0x6c @ 1
[    2.212448] Uniform Multi-Platform E-IDE driver
[    2.213656] initcall ide_init+0x0/0x6c returned 0 after 1180 usecs
[    2.214860] calling  ali14xx_init+0x0/0x17a @ 1
[    2.216086] initcall ali14xx_init+0x0/0x17a returned -19 after 0 usecs
[    2.217361] calling  umc8672_init+0x0/0x10a @ 1
[    2.218666] initcall umc8672_init+0x0/0x10a returned -19 after 0 usecs
[    2.220024] calling  dtc2278_init+0x0/0x60 @ 1
[    2.221403] initcall dtc2278_init+0x0/0x60 returned -19 after 0 usecs
[    2.222827] calling  ht6560b_init+0x0/0xef @ 1
[    2.224278] initcall ht6560b_init+0x0/0xef returned -19 after 0 usecs
[    2.225767] calling  qd65xx_init+0x0/0x3c @ 1
[    2.227285] initcall qd65xx_init+0x0/0x3c returned -19 after 0 usecs
[    2.228855] calling  ide_4drives_init+0x0/0x107 @ 1
[    2.230460] initcall ide_4drives_init+0x0/0x107 returned -19 after 0 usecs
[    2.232111] calling  aec62xx_ide_init+0x0/0x16 @ 1
[    2.233824] initcall aec62xx_ide_init+0x0/0x16 returned 0 after 39 usecs
[    2.235548] calling  ali15x3_ide_init+0x0/0x16 @ 1
[    2.237325] initcall ali15x3_ide_init+0x0/0x16 returned 0 after 37 usecs
[    2.239071] calling  amd74xx_ide_init+0x0/0x16 @ 1
[    2.240830] initcall amd74xx_ide_init+0x0/0x16 returned 0 after 38 usecs
[    2.242567] calling  atiixp_ide_init+0x0/0x16 @ 1
[    2.244329] initcall atiixp_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.246064] calling  cmd64x_ide_init+0x0/0x16 @ 1
[    2.247805] initcall cmd64x_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.249499] calling  cs5530_ide_init+0x0/0x16 @ 1
[    2.251203] initcall cs5530_ide_init+0x0/0x16 returned 0 after 40 usecs
[    2.252871] calling  cs5535_ide_init+0x0/0x16 @ 1
[    2.254548] initcall cs5535_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.256188] calling  sc1200_ide_init+0x0/0x16 @ 1
[    2.257850] initcall sc1200_ide_init+0x0/0x16 returned 0 after 41 usecs
[    2.259486] calling  delkin_cb_init+0x0/0x16 @ 1
[    2.261160] initcall delkin_cb_init+0x0/0x16 returned 0 after 38 usecs
[    2.262803] calling  hpt366_ide_init+0x0/0x16 @ 1
[    2.264463] initcall hpt366_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.266114] calling  it8213_ide_init+0x0/0x16 @ 1
[    2.267768] initcall it8213_ide_init+0x0/0x16 returned 0 after 35 usecs
[    2.269410] calling  it821x_ide_init+0x0/0x16 @ 1
[    2.271061] initcall it821x_ide_init+0x0/0x16 returned 0 after 39 usecs
[    2.272685] calling  jmicron_ide_init+0x0/0x16 @ 1
[    2.274330] initcall jmicron_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.275945] calling  ns87415_ide_init+0x0/0x16 @ 1
[    2.277593] initcall ns87415_ide_init+0x0/0x16 returned 0 after 37 usecs
[    2.279206] calling  pdc202xx_ide_init+0x0/0x16 @ 1
[    2.280860] initcall pdc202xx_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.282474] calling  pdc202new_ide_init+0x0/0x16 @ 1
[    2.284109] initcall pdc202new_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.285724] calling  piix_ide_init+0x0/0xa5 @ 1
[    2.287374] initcall piix_ide_init+0x0/0xa5 returned 0 after 41 usecs
[    2.288999] calling  rz1000_ide_init+0x0/0x16 @ 1
[    2.290643] initcall rz1000_ide_init+0x0/0x16 returned 0 after 35 usecs
[    2.292256] calling  svwks_ide_init+0x0/0x16 @ 1
[    2.293896] initcall svwks_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.295525] calling  siimage_ide_init+0x0/0x16 @ 1
[    2.297165] initcall siimage_ide_init+0x0/0x16 returned 0 after 35 usecs
[    2.298804] calling  sis5513_ide_init+0x0/0x16 @ 1
[    2.300442] initcall sis5513_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.302071] calling  slc90e66_ide_init+0x0/0x16 @ 1
[    2.303726] initcall slc90e66_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.305365] calling  tc86c001_ide_init+0x0/0x16 @ 1
[    2.307020] initcall tc86c001_ide_init+0x0/0x16 returned 0 after 35 usecs
[    2.308649] calling  triflex_ide_init+0x0/0x16 @ 1
[    2.310295] initcall triflex_ide_init+0x0/0x16 returned 0 after 35 usecs
[    2.311922] calling  trm290_ide_init+0x0/0x16 @ 1
[    2.313567] initcall trm290_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.315195] calling  via_ide_init+0x0/0x16 @ 1
[    2.316850] initcall via_ide_init+0x0/0x16 returned 0 after 36 usecs
[    2.318496] calling  generic_ide_init+0x0/0x16 @ 1
[    2.320175] initcall generic_ide_init+0x0/0x16 returned 0 after 41 usecs
[    2.321831] calling  cmd640x_init+0x0/0x3de @ 1
[    2.323683] initcall cmd640x_init+0x0/0x3de returned 0 after 198 usecs
[    2.325356] calling  pnpide_init+0x0/0xf @ 1
[    2.327054] initcall pnpide_init+0x0/0xf returned 0 after 32 usecs
[    2.328748] calling  ide_gd_init+0x0/0x19 @ 1
[    2.330414] ide-gd driver 1.18
[    2.332098] initcall ide_gd_init+0x0/0x19 returned 0 after 1644 usecs
[    2.333772] calling  ide_cdrom_init+0x0/0x19 @ 1
[    2.335448] ide-cd driver 5.00
[    2.337132] initcall ide_cdrom_init+0x0/0x19 returned 0 after 1645 usecs
[    2.338841] calling  init_sd+0x0/0xd4 @ 1
[    2.340607] initcall init_sd+0x0/0xd4 returned 0 after 59 usecs
[    2.342322] calling  ahci_init+0x0/0x16 @ 1
[    2.344035] ahci 0000:00:1f.2: version 3.0
[    2.344053] ahci 0000:00:1f.2: PCI INT B -> GSI 21 (level, low) -> IRQ 21
[    2.345838] ahci 0000:00:1f.2: irq 33 for MSI/MSI-X
[    2.345884] ahci: SSS flag set, parallel bus scan disabled
[    2.347740] ahci 0000:00:1f.2: AHCI 0001.0300 32 slots 6 ports 3 Gbps 0x13 impl SATA mode
[    2.349532] ahci 0000:00:1f.2: flags: 64bit ncq sntf stag pm led clo pio slum part ems 
[    2.351321] ahci 0000:00:1f.2: setting latency timer to 64
[    2.356092] scsi0 : ahci
[    2.357995] scsi1 : ahci
[    2.359797] scsi2 : ahci
[    2.361586] scsi3 : ahci
[    2.363333] scsi4 : ahci
[    2.365058] scsi5 : ahci
[    2.366892] ata1: SATA max UDMA/133 abar m2048@0x54705000 port 0x54705100 irq 33
[    2.368656] ata2: SATA max UDMA/133 abar m2048@0x54705000 port 0x54705180 irq 33
[    2.370380] ata3: DUMMY
[    2.372088] ata4: DUMMY
[    2.373756] ata5: SATA max UDMA/133 abar m2048@0x54705000 port 0x54705300 irq 33
[    2.375498] ata6: DUMMY
[    2.377240] calling  2_async_port_probe+0x0/0xa3 @ 688
[    2.378128] calling  3_async_port_probe+0x0/0xa3 @ 689
[    2.378131] async_waiting @ 689
[    2.378142] calling  4_async_port_probe+0x0/0xa3 @ 690
[    2.378144] async_waiting @ 690
[    2.378160] calling  5_async_port_probe+0x0/0xa3 @ 691
[    2.378162] async_waiting @ 691
[    2.378180] calling  6_async_port_probe+0x0/0xa3 @ 692
[    2.378182] async_waiting @ 692
[    2.378197] calling  7_async_port_probe+0x0/0xa3 @ 693
[    2.378198] async_waiting @ 693
[    2.380158] initcall ahci_init+0x0/0x16 returned 0 after 35337 usecs
[    2.380161] calling  net_olddevs_init+0x0/0x81 @ 1
[    2.380166] initcall net_olddevs_init+0x0/0x81 returned 0 after 3 usecs
[    2.380169] calling  arcnet_init+0x0/0x50 @ 1
[    2.380170] arcnet loaded.
[    2.380172] initcall arcnet_init+0x0/0x50 returned 0 after 1 usecs
[    2.380174] calling  cdrom_init+0x0/0xc @ 1
[    2.380215] initcall cdrom_init+0x0/0xc returned 0 after 37 usecs
[    2.380217] calling  nonstatic_sysfs_init+0x0/0xf @ 1
[    2.380221] initcall nonstatic_sysfs_init+0x0/0xf returned 0 after 1 usecs
[    2.380223] calling  yenta_socket_init+0x0/0x16 @ 1
[    2.380289] initcall yenta_socket_init+0x0/0x16 returned 0 after 61 usecs
[    2.380291] calling  mon_init+0x0/0xee @ 1
[    2.380421] initcall mon_init+0x0/0xee returned 0 after 123 usecs
[    2.380424] calling  ehci_hcd_init+0x0/0x65 @ 1
[    2.380426] ehci_hcd: USB 2.0 'Enhanced' Host Controller (EHCI) Driver
[    2.380444] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[    2.380456] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[    2.380460] ehci_hcd 0000:00:1a.0: EHCI Host Controller
[    2.380585] ehci_hcd 0000:00:1a.0: new USB bus registered, assigned bus number 1
[    2.384492] ehci_hcd 0000:00:1a.0: debug port 2
[    2.384498] ehci_hcd 0000:00:1a.0: cache line size of 32 is not supported
[    2.384514] ehci_hcd 0000:00:1a.0: irq 16, io mem 0x54705c00
[    2.393963] ehci_hcd 0000:00:1a.0: USB 2.0 started, EHCI 1.00
[    2.394015] usb usb1: New USB device found, idVendor=1d6b, idProduct=0002
[    2.394017] usb usb1: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.394020] usb usb1: Product: EHCI Host Controller
[    2.394022] usb usb1: Manufacturer: Linux 2.6.31 ehci_hcd
[    2.394024] usb usb1: SerialNumber: 0000:00:1a.0
[    2.394123] usb usb1: configuration #1 chosen from 1 choice
[    2.394223] hub 1-0:1.0: USB hub found
[    2.394231] hub 1-0:1.0: 2 ports detected
[    2.394363] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[    2.394374] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[    2.394377] ehci_hcd 0000:00:1d.0: EHCI Host Controller
[    2.394445] ehci_hcd 0000:00:1d.0: new USB bus registered, assigned bus number 2
[    2.398354] ehci_hcd 0000:00:1d.0: debug port 2
[    2.398361] ehci_hcd 0000:00:1d.0: cache line size of 32 is not supported
[    2.398375] ehci_hcd 0000:00:1d.0: irq 20, io mem 0x54705800
[    2.407944] ehci_hcd 0000:00:1d.0: USB 2.0 started, EHCI 1.00
[    2.407968] usb usb2: New USB device found, idVendor=1d6b, idProduct=0002
[    2.407970] usb usb2: New USB device strings: Mfr=3, Product=2, SerialNumber=1
[    2.407972] usb usb2: Product: EHCI Host Controller
[    2.407973] usb usb2: Manufacturer: Linux 2.6.31 ehci_hcd
[    2.407975] usb usb2: SerialNumber: 0000:00:1d.0
[    2.408062] usb usb2: configuration #1 chosen from 1 choice
[    2.408125] hub 2-0:1.0: USB hub found
[    2.408131] hub 2-0:1.0: 2 ports detected
[    2.408271] initcall ehci_hcd_init+0x0/0x65 returned 0 after 27227 usecs
[    2.408274] calling  ohci_hcd_mod_init+0x0/0x4d @ 1
[    2.408275] ohci_hcd: USB 1.1 'Open' Host Controller (OHCI) Driver
[    2.408324] initcall ohci_hcd_mod_init+0x0/0x4d returned 0 after 46 usecs
[    2.408327] calling  uhci_hcd_init+0x0/0xa4 @ 1
[    2.408328] uhci_hcd: USB Universal Host Controller Interface driver
[    2.408396] initcall uhci_hcd_init+0x0/0xa4 returned 0 after 64 usecs
[    2.408398] calling  xhci_hcd_init+0x0/0x25 @ 1
[    2.408454] initcall xhci_hcd_init+0x0/0x25 returned 0 after 52 usecs
[    2.408457] calling  usb_usual_init+0x0/0x32 @ 1
[    2.408514] usbcore: registered new interface driver libusual
[    2.408519] initcall usb_usual_init+0x0/0x32 returned 0 after 57 usecs
[    2.408521] calling  i8042_init+0x0/0x35f @ 1
[    2.408632] PNP: PS/2 Controller [PNP0303:PS2K,PNP0f13:PS2M] at 0x60,0x64 irq 1,12
[    2.495209] i8042.c: Detected active multiplexing controller, rev 1.1.
[    2.497641] serio: i8042 KBD port at 0x60,0x64 irq 1
[    2.499287] serio: i8042 AUX0 port at 0x60,0x64 irq 12
[    2.500931] serio: i8042 AUX1 port at 0x60,0x64 irq 12
[    2.502536] serio: i8042 AUX2 port at 0x60,0x64 irq 12
[    2.504141] serio: i8042 AUX3 port at 0x60,0x64 irq 12
[    2.505749] initcall i8042_init+0x0/0x35f returned 0 after 95072 usecs
[    2.507362] calling  serport_init+0x0/0x2b @ 1
[    2.508969] initcall serport_init+0x0/0x2b returned 0 after 0 usecs
[    2.510578] calling  mousedev_init+0x0/0x51 @ 1
[    2.512244] mice: PS/2 mouse device common for all mice
[    2.513874] initcall mousedev_init+0x0/0x51 returned 0 after 1653 usecs
[    2.515529] calling  evdev_init+0x0/0xf @ 1
[    2.517332] initcall evdev_init+0x0/0xf returned 0 after 165 usecs
[    2.518994] calling  atkbd_init+0x0/0x20 @ 1
[    2.520669] initcall atkbd_init+0x0/0x20 returned 0 after 41 usecs
[    2.522334] calling  psmouse_init+0x0/0x67 @ 1
[    2.524033] initcall psmouse_init+0x0/0x67 returned 0 after 56 usecs
[    2.525685] calling  da9034_touch_init+0x0/0xf @ 1
[    2.527386] initcall da9034_touch_init+0x0/0xf returned 0 after 34 usecs
[    2.529072] calling  cpufreq_gov_powersave_init+0x0/0xf @ 1
[    2.530750] initcall cpufreq_gov_powersave_init+0x0/0xf returned 0 after 1 usecs
[    2.532433] calling  cpufreq_gov_dbs_init+0x0/0xa5 @ 1
[    2.534171] initcall cpufreq_gov_dbs_init+0x0/0xa5 returned 0 after 51 usecs
[    2.535872] calling  init_ladder+0x0/0xf @ 1
[    2.537591] cpuidle: using governor ladder
[    2.539309] initcall init_ladder+0x0/0xf returned 0 after 1685 usecs
[    2.541027] calling  init_menu+0x0/0xf @ 1
[    2.542761] cpuidle: using governor menu
[    2.542995] input: AT Translated Set 2 keyboard as /class/input/input4
[    2.546230] initcall init_menu+0x0/0xf returned 0 after 3390 usecs
[    2.547963] calling  ledtrig_ide_init+0x0/0x16 @ 1
[    2.549694] initcall ledtrig_ide_init+0x0/0x16 returned 0 after 1 usecs
[    2.551425] calling  efivars_init+0x0/0x1c2 @ 1
[    2.553151] initcall efivars_init+0x0/0x1c2 returned -19 after 0 usecs
[    2.554865] calling  hid_init+0x0/0x3d @ 1
[    2.556638] initcall hid_init+0x0/0x3d returned 0 after 64 usecs
[    2.558375] calling  a4_init+0x0/0x16 @ 1
[    2.560132] initcall a4_init+0x0/0x16 returned 0 after 32 usecs
[    2.561858] calling  apple_init+0x0/0x2d @ 1
[    2.563601] initcall apple_init+0x0/0x2d returned 0 after 35 usecs
[    2.565321] calling  belkin_init+0x0/0x16 @ 1
[    2.567035] initcall belkin_init+0x0/0x16 returned 0 after 30 usecs
[    2.568718] calling  ch_init+0x0/0x16 @ 1
[    2.570409] initcall ch_init+0x0/0x16 returned 0 after 31 usecs
[    2.572084] calling  ch_init+0x0/0x16 @ 1
[    2.573790] initcall ch_init+0x0/0x16 returned 0 after 30 usecs
[    2.575508] calling  cp_init+0x0/0x16 @ 1
[    2.577243] initcall cp_init+0x0/0x16 returned 0 after 30 usecs
[    2.578955] calling  dr_init+0x0/0x16 @ 1
[    2.580666] initcall dr_init+0x0/0x16 returned 0 after 30 usecs
[    2.582353] calling  ez_init+0x0/0x16 @ 1
[    2.584050] initcall ez_init+0x0/0x16 returned 0 after 32 usecs
[    2.585717] calling  gyration_init+0x0/0x16 @ 1
[    2.587410] initcall gyration_init+0x0/0x16 returned 0 after 30 usecs
[    2.589067] calling  ks_init+0x0/0x16 @ 1
[    2.590756] initcall ks_init+0x0/0x16 returned 0 after 30 usecs
[    2.592419] calling  kye_init+0x0/0x16 @ 1
[    2.594119] initcall kye_init+0x0/0x16 returned 0 after 38 usecs
[    2.595793] calling  lg_init+0x0/0x16 @ 1
[    2.597477] initcall lg_init+0x0/0x16 returned 0 after 32 usecs
[    2.599122] calling  ms_init+0x0/0x16 @ 1
[    2.600777] initcall ms_init+0x0/0x16 returned 0 after 30 usecs
[    2.602404] calling  mr_init+0x0/0x16 @ 1
[    2.604054] initcall mr_init+0x0/0x16 returned 0 after 30 usecs
[    2.605667] calling  ntrig_init+0x0/0x16 @ 1
[    2.607308] initcall ntrig_init+0x0/0x16 returned 0 after 30 usecs
[    2.608911] calling  pl_init+0x0/0x16 @ 1
[    2.610543] initcall pl_init+0x0/0x16 returned 0 after 30 usecs
[    2.612138] calling  pl_init+0x0/0x16 @ 1
[    2.613737] initcall pl_init+0x0/0x16 returned 0 after 33 usecs
[    2.615330] calling  samsung_init+0x0/0x16 @ 1
[    2.616942] initcall samsung_init+0x0/0x16 returned 0 after 30 usecs
[    2.618527] calling  sjoy_init+0x0/0x16 @ 1
[    2.620123] initcall sjoy_init+0x0/0x16 returned 0 after 30 usecs
[    2.621710] calling  sony_init+0x0/0x16 @ 1
[    2.623298] initcall sony_init+0x0/0x16 returned 0 after 30 usecs
[    2.624874] calling  sp_init+0x0/0x16 @ 1
[    2.626462] initcall sp_init+0x0/0x16 returned 0 after 30 usecs
[    2.628033] calling  ga_init+0x0/0x16 @ 1
[    2.629602] initcall ga_init+0x0/0x16 returned 0 after 30 usecs
[    2.631164] calling  tm_init+0x0/0x16 @ 1
[    2.632725] initcall tm_init+0x0/0x16 returned 0 after 30 usecs
[    2.634269] calling  ts_init+0x0/0x16 @ 1
[    2.635818] initcall ts_init+0x0/0x16 returned 0 after 30 usecs
[    2.637355] calling  zp_init+0x0/0x16 @ 1
[    2.638900] initcall zp_init+0x0/0x16 returned 0 after 32 usecs
[    2.640434] calling  hid_init+0x0/0xb0 @ 1
[    2.642038] usbcore: registered new interface driver hiddev
[    2.643620] usbcore: registered new interface driver usbhid
[    2.645155] usbhid: v2.6:USB HID core driver
[    2.646677] initcall hid_init+0x0/0xb0 returned 0 after 4617 usecs
[    2.648222] calling  staging_init+0x0/0x7 @ 1
[    2.649782] initcall staging_init+0x0/0x7 returned 0 after 0 usecs
[    2.651348] calling  flow_cache_init+0x0/0x14c @ 1
[    2.652978] initcall flow_cache_init+0x0/0x14c returned 0 after 71 usecs
[    2.654546] calling  llc_init+0x0/0x1b @ 1
[    2.656105] initcall llc_init+0x0/0x1b returned 0 after 0 usecs
[    2.657665] calling  snap_init+0x0/0x31 @ 1
[    2.659237] initcall snap_init+0x0/0x31 returned 0 after 6 usecs
[    2.660803] calling  rif_init+0x0/0x71 @ 1
[    2.662387] initcall rif_init+0x0/0x71 returned 0 after 26 usecs
[    2.663955] calling  blackhole_module_init+0x0/0xf @ 1
[    2.665524] initcall blackhole_module_init+0x0/0xf returned 0 after 0 usecs
[    2.667101] calling  sysctl_ipv4_init+0x0/0x3f @ 1
[    2.669064] initcall sysctl_ipv4_init+0x0/0x3f returned 0 after 370 usecs
[    2.670657] calling  init_syncookies+0x0/0x16 @ 1
[    2.672283] initcall init_syncookies+0x0/0x16 returned 0 after 28 usecs
[    2.673881] calling  ipv4_netfilter_init+0x0/0xf @ 1
[    2.675492] initcall ipv4_netfilter_init+0x0/0xf returned 0 after 6 usecs
[    2.677095] calling  bictcp_register+0x0/0xf @ 1
[    2.678699] TCP bic registered
[    2.680304] initcall bictcp_register+0x0/0xf returned 0 after 1569 usecs
[    2.681941] calling  xfrm_user_init+0x0/0x40 @ 1
[    2.683575] Initializing XFRM netlink socket
[    2.685223] initcall xfrm_user_init+0x0/0x40 returned 0 after 1610 usecs
[    2.686875] calling  packet_init+0x0/0x39 @ 1
[    2.688523] NET: Registered protocol family 17
[    2.690186] initcall packet_init+0x0/0x39 returned 0 after 1626 usecs
[    2.691858] calling  severities_debugfs_init+0x0/0x4e @ 1
[    2.693547] initcall severities_debugfs_init+0x0/0x4e returned 0 after 16 usecs
[    2.695224] calling  powernowk8_init+0x0/0x8a @ 1
[    2.696911] initcall powernowk8_init+0x0/0x8a returned -19 after 5 usecs
[    2.698608] calling  powernow_init+0x0/0xd3 @ 1
[    2.699694] usb 1-1: new high speed USB device using ehci_hcd and address 2
[    2.701989] initcall powernow_init+0x0/0xd3 returned -19 after 0 usecs
[    2.703713] calling  longhaul_init+0x0/0x78 @ 1
[    2.705425] initcall longhaul_init+0x0/0x78 returned -19 after 0 usecs
[    2.707160] calling  hpet_insert_resource+0x0/0x1e @ 1
[    2.708892] initcall hpet_insert_resource+0x0/0x1e returned 0 after 1 usecs
[    2.710634] calling  update_mp_table+0x0/0x3ad @ 1
[    2.712362] initcall update_mp_table+0x0/0x3ad returned 0 after 0 usecs
[    2.714129] calling  lapic_insert_resource+0x0/0x33 @ 1
[    2.715893] initcall lapic_insert_resource+0x0/0x33 returned 0 after 0 usecs
[    2.717660] calling  print_ipi_mode+0x0/0x26 @ 1
[    2.719407] Using IPI No-Shortcut mode
[    2.721155] initcall print_ipi_mode+0x0/0x26 returned 0 after 1708 usecs
[    2.722919] calling  init_lapic_nmi_sysfs+0x0/0x33 @ 1
[    2.724707] initcall init_lapic_nmi_sysfs+0x0/0x33 returned 0 after 0 usecs
[    2.726483] calling  io_apic_bug_finalize+0x0/0x1c @ 1
[    2.728271] initcall io_apic_bug_finalize+0x0/0x1c returned 0 after 0 usecs
[    2.730059] calling  check_early_ioremap_leak+0x0/0x5e @ 1
[    2.731849] initcall check_early_ioremap_leak+0x0/0x5e returned 0 after 0 usecs
[    2.733640] calling  pat_memtype_list_init+0x0/0x23 @ 1
[    2.735445] initcall pat_memtype_list_init+0x0/0x23 returned 0 after 4 usecs
[    2.737243] calling  sched_init_debug+0x0/0x1f @ 1
[    2.739056] initcall sched_init_debug+0x0/0x1f returned 0 after 2 usecs
[    2.740855] calling  init_oops_id+0x0/0x3a @ 1
[    2.742660] initcall init_oops_id+0x0/0x3a returned 0 after 3 usecs
[    2.744467] calling  disable_boot_consoles+0x0/0x36 @ 1
[    2.746277] initcall disable_boot_consoles+0x0/0x36 returned 0 after 0 usecs
[    2.748080] calling  pm_qos_power_init+0x0/0x54 @ 1
[    2.750005] initcall pm_qos_power_init+0x0/0x54 returned 0 after 111 usecs
[    2.751830] calling  software_resume+0x0/0x15d @ 1
[    2.798444] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    2.802570] ata1.00: ACPI _SDD failed (AE 0x5)
[    2.813789] usb 1-1: New USB device found, idVendor=8087, idProduct=0020
[    2.815653] usb 1-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    2.817545] usb 1-1: configuration #1 chosen from 1 choice
[    2.819496] hub 1-1:1.0: USB hub found
[    2.821400] hub 1-1:1.0: 6 ports detected
[    2.920124] input: PS/2 Generic Mouse as /class/input/input5
[    2.925049] async_waiting @ 1
[    2.926909] usb 2-1: new high speed USB device using ehci_hcd and address 2
[    3.042427] usb 2-1: New USB device found, idVendor=8087, idProduct=0020
[    3.044355] usb 2-1: New USB device strings: Mfr=0, Product=0, SerialNumber=0
[    3.046226] usb 2-1: configuration #1 chosen from 1 choice
[    3.048261] hub 2-1:1.0: USB hub found
[    3.050160] hub 2-1:1.0: 8 ports detected
[    8.097343] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[    8.101376] ata1.00: ACPI _SDD failed (AE 0x5)
[    8.103221] ata1.00: ACPI: failed the second time, disabled
[    8.105017] ata1.00: ATA-8: WDC WD2500BEKT-60V5T1, 12.01A12, max UDMA/100
[    8.106811] ata1.00: 488397168 sectors, multi 0: LBA48 NCQ (depth 31/32)
[    8.110830] ata1.00: configured for UDMA/100
[    8.123300] async_waiting @ 688
[    8.125125] async_continuing @ 688 after 0 usec
[    8.127031] scsi 0:0:0:0: Direct-Access     ATA      WDC WD2500BEKT-6 12.0 PQ: 0 ANSI: 5
[    8.129034] calling  8_sd_probe_async+0x0/0x1a2 @ 781
[    8.129162] initcall 2_async_port_probe+0x0/0xa3 returned 0 after 5510123 usecs
[    8.131281] async_continuing @ 689 after 5625836 usec
[    8.134517] sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 GiB)
[    8.136394] sd 0:0:0:0: [sda] Write Protect is off
[    8.138234] sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
[    8.138256] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
[    8.140259]  sda: sda1 sda2 sda3 sda4 < sda5 >
[    8.193153] sd 0:0:0:0: [sda] Attached SCSI disk
[    8.195010] initcall 8_sd_probe_async+0x0/0x1a2 returned 0 after 59188 usecs
[    8.853331] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[    8.865620] ata2.00: ACPI _SDD failed (AE 0x5)
[   14.152231] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[   14.164692] ata2.00: ACPI _SDD failed (AE 0x5)
[   14.166705] ata2.00: ACPI: failed the second time, disabled
[   14.169230] ata2.00: ATAPI: hp      BDDVDRW CT21L, 1.02, max UDMA/100, ATAPI AN
[   14.176237] ata2.00: configured for UDMA/100
[   14.190183] async_waiting @ 689
[   14.192062] async_continuing @ 689 after 0 usec
[   14.195461] scsi 1:0:0:0: CD-ROM            hp       BDDVDRW CT21L    1.02 PQ: 0 ANSI: 5
[   14.197524] initcall 3_async_port_probe+0x0/0xa3 returned 0 after 11557840 usecs
[   14.199432] async_continuing @ 690 after 11559693 usec
[   14.201332] async_waiting @ 690
[   14.203188] async_continuing @ 690 after 0 usec
[   14.205040] initcall 4_async_port_probe+0x0/0xa3 returned 0 after 11565177 usecs
[   14.206932] async_continuing @ 691 after 11567009 usec
[   14.208855] async_waiting @ 691
[   14.210721] async_continuing @ 691 after 0 usec
[   14.212601] initcall 5_async_port_probe+0x0/0xa3 returned 0 after 11572552 usecs
[   14.214526] async_continuing @ 692 after 11574415 usec
[   14.520733] ata5: SATA link down (SStatus 0 SControl 300)
[   14.532710] async_waiting @ 692
[   14.534603] async_continuing @ 692 after 0 usec
[   14.536454] initcall 6_async_port_probe+0x0/0xa3 returned 0 after 11889220 usecs
[   14.538378] async_continuing @ 693 after 11891085 usec
[   14.540396] async_waiting @ 693
[   14.542363] async_continuing @ 693 after 0 usec
[   14.544343] initcall 7_async_port_probe+0x0/0xa3 returned 0 after 11896918 usecs
[   14.546371] async_continuing @ 1 after 11362341 usec
[   14.556500] initcall software_resume+0x0/0x15d returned -22 after 11541674 usecs
[   14.558485] initcall software_resume+0x0/0x15d returned with error code -22 
[   14.560423] calling  taskstats_init+0x0/0x7d @ 1
[   14.562366] registered taskstats version 1
[   14.564284] initcall taskstats_init+0x0/0x7d returned 0 after 1878 usecs
[   14.566205] calling  clear_boot_tracer+0x0/0x27 @ 1
[   14.568107] initcall clear_boot_tracer+0x0/0x27 returned 0 after 0 usecs
[   14.570019] calling  max_swapfiles_check+0x0/0x7 @ 1
[   14.571899] initcall max_swapfiles_check+0x0/0x7 returned 0 after 0 usecs
[   14.573785] calling  random32_reseed+0x0/0x83 @ 1
[   14.575694] initcall random32_reseed+0x0/0x83 returned 0 after 36 usecs
[   14.577538] calling  pci_resource_alignment_sysfs_init+0x0/0x14 @ 1
[   14.579402] initcall pci_resource_alignment_sysfs_init+0x0/0x14 returned 0 after 2 usecs
[   14.581256] calling  pci_sysfs_init+0x0/0x44 @ 1
[   14.583151] initcall pci_sysfs_init+0x0/0x44 returned 0 after 68 usecs
[   14.585003] calling  seqgen_init+0x0/0xe @ 1
[   14.586843] initcall seqgen_init+0x0/0xe returned 0 after 11 usecs
[   14.588689] calling  scsi_complete_async_scans+0x0/0x124 @ 1
[   14.590538] initcall scsi_complete_async_scans+0x0/0x124 returned 0 after 0 usecs
[   14.592389] calling  memmap_init+0x0/0x8a @ 1
[   14.594301] initcall memmap_init+0x0/0x8a returned 0 after 72 usecs
[   14.596163] calling  pci_mmcfg_late_insert_resources+0x0/0x12e @ 1
[   14.598038] initcall pci_mmcfg_late_insert_resources+0x0/0x12e returned 0 after 2 usecs
[   14.599899] calling  tcp_congestion_default+0x0/0xf @ 1
[   14.601738] initcall tcp_congestion_default+0x0/0xf returned 0 after 0 usecs
[   14.603575] calling  initialize_hashrnd+0x0/0x16 @ 1
[   14.605414] initcall initialize_hashrnd+0x0/0x16 returned 0 after 2 usecs
[   14.607281] async_waiting @ 1
[   14.609103] async_continuing @ 1 after 0 usec
[   14.610927] Freeing unused kernel memory: 344k freed
[   15.190201] kjournald starting.  Commit interval 5 seconds
[   15.190277] EXT3-fs: mounted filesystem with writeback data mode.
[   17.135198] calling  init_sr+0x0/0x3d [sr_mod] @ 1288
[   17.144311] calling  atl1c_init_module+0x0/0x19 [atl1c] @ 1197
[   17.144361] atl1c 0000:43:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
[   17.144374] atl1c 0000:43:00.0: setting latency timer to 64
[   17.144425] atl1c 0000:43:00.0: PME# disabled
[   17.144432] atl1c 0000:43:00.0: PME# disabled
[   17.150226] sr0: scsi3-mmc drive: 24x/24x writer dvd-ram cd/rw xa/form2 cdda tray
[   17.150232] Uniform CD-ROM driver Revision: 3.20
[   17.150365] sr 1:0:0:0: Attached scsi CD-ROM sr0
[   17.150378] initcall init_sr+0x0/0x3d [sr_mod] returned 0 after 14838 usecs
[   17.184710] calling  init_sg+0x0/0x136 [sg] @ 1277
[   17.184840] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   17.184881] sr 1:0:0:0: Attached scsi generic sg1 type 5
[   17.184903] initcall init_sg+0x0/0x136 [sg] returned 0 after 181 usecs
[   17.202734] calling  pcspkr_init+0x0/0xf [pcspkr] @ 1293
[   17.202793] input: PC Speaker as /class/input/input6
[   17.202841] initcall pcspkr_init+0x0/0xf [pcspkr] returned 0 after 100 usecs
[   17.220131] calling  lis3lv02d_init_module+0x0/0x2e [hp_accel] @ 1346
[   17.220203] lis3lv02d: laptop model unknown, using default axes configuration
[   17.221010] lis3lv02d: 1-byte sensor found
[   17.225080] atl1c 0000:43:00.0: version 1.0.0.1-NAPI
[   17.225118] initcall atl1c_init_module+0x0/0x19 [atl1c] returned 0 after 79010 usecs
[   17.231608] input: ST LIS3LV02DL Accelerometer as /class/input/input7
[   17.231756] Registered led device: hp::hddprotect
[   17.231779] lis3lv02d driver loaded.
[   17.231785] initcall lis3lv02d_init_module+0x0/0x2e [hp_accel] returned 0 after 11390 usecs
[   17.234506] calling  joydev_init+0x0/0xf [joydev] @ 1400
[   17.234560] initcall joydev_init+0x0/0xf [joydev] returned 0 after 47 usecs
[   17.253822] calling  serio_raw_init+0x0/0x19 [serio_raw] @ 1289
[   17.253846] initcall serio_raw_init+0x0/0x19 [serio_raw] returned 0 after 19 usecs
[   17.457803] calling  uinput_init+0x0/0xf [uinput] @ 1418
[   17.457967] initcall uinput_init+0x0/0xf [uinput] returned 0 after 154 usecs
[   17.550495] calling  acpi_pci_slot_init+0x0/0x1b [pci_slot] @ 1427
[   17.551007] initcall acpi_pci_slot_init+0x0/0x1b [pci_slot] returned 0 after 496 usecs
[   17.563031] calling  acpi_smb_hc_init+0x0/0x15 [sbshc] @ 1429
[   17.563079] initcall acpi_smb_hc_init+0x0/0x15 [sbshc] returned 0 after 42 usecs
[   17.565787] calling  acpi_sbs_init+0x0/0x46 [sbs] @ 1432
[   17.565832] initcall acpi_sbs_init+0x0/0x46 [sbs] returned 0 after 39 usecs
[   18.178674] EXT3 FS on sda3, internal journal
[   18.609726] EXT4-fs (sda1): barriers enabled
[   18.622669] kjournald2 starting: pid 1592, dev sda1:8, commit interval 5 seconds
[   18.622693] EXT4-fs (sda1): warning: maximal mount count reached, running e2fsck is recommended
[   18.622915] EXT4-fs (sda1): internal journal on sda1:8
[   18.622922] EXT4-fs (sda1): delayed allocation enabled
[   18.622928] EXT4-fs: file extents enabled
[   18.628413] EXT4-fs: mballoc enabled
[   18.628429] EXT4-fs (sda1): mounted filesystem with ordered data mode
[   18.645267] EXT2-fs warning: mounting unchecked fs, running e2fsck is recommended
[   19.151981] Adding 5116660k swap on /dev/sda5.  Priority:-1 extents:1 across:5116660k 
[   19.729216] calling  acpi_cpufreq_init+0x0/0x87 [acpi_cpufreq] @ 1732
[   19.730600] initcall acpi_cpufreq_init+0x0/0x87 [acpi_cpufreq] returned 0 after 1347 usecs
[   21.796791] calling  usb_stor_init+0x0/0x45 [usb_storage] @ 1973
[   21.796796] Initializing USB Mass Storage driver...
[   21.796858] usbcore: registered new interface driver usb-storage
[   21.796864] USB Mass Storage support registered.
[   21.796909] initcall usb_stor_init+0x0/0x45 [usb_storage] returned 0 after 102 usecs
[   22.532394] calling  inet6_init+0x0/0x277 [ipv6] @ 2016
[   22.534524] NET: Registered protocol family 10
[   22.536197] lo: Disabled Privacy Extensions
[   22.538134] initcall inet6_init+0x0/0x277 [ipv6] returned 0 after 5577 usecs
[   22.786992] [i915_drv:i915_driver_open], 
[   22.787114] [i915_drv:i915_driver_open], 
[   22.935023] i2c-adapter i2c-2: unable to read EDID block.
[   22.935030] i915 0000:00:02.0: DVI-D-1: no EDID data
[   22.939688] i2c-adapter i2c-2: unable to read EDID block.
[   22.939693] i915 0000:00:02.0: DVI-D-1: no EDID data
[   23.073346] i2c-adapter i2c-2: unable to read EDID block.
[   23.073351] i915 0000:00:02.0: DVI-D-1: no EDID data
[   23.078019] i2c-adapter i2c-2: unable to read EDID block.
[   23.078024] i915 0000:00:02.0: DVI-D-1: no EDID data
[   27.401929] calling  rfkill_init+0x0/0x75 [rfkill] @ 2201
[   27.402212] initcall rfkill_init+0x0/0x75 [rfkill] returned 0 after 104 usecs
[   27.427011] calling  bt_init+0x0/0x50 [bluetooth] @ 2201
[   27.427064] Bluetooth: Core ver 2.15
[   27.427116] NET: Registered protocol family 31
[   27.427118] Bluetooth: HCI device and connection manager initialized
[   27.427181] Bluetooth: HCI socket layer initialized
[   27.427190] initcall bt_init+0x0/0x50 [bluetooth] returned 0 after 116 usecs
[   27.522298] calling  l2cap_init+0x0/0xbc [l2cap] @ 2209
[   27.522465] Bluetooth: L2CAP ver 2.13
[   27.522468] Bluetooth: L2CAP socket layer initialized
[   27.522477] initcall l2cap_init+0x0/0xbc [l2cap] returned 0 after 60 usecs
[   27.602618] calling  bnep_init+0x0/0x6c [bnep] @ 2212
[   27.602742] Bluetooth: BNEP (Ethernet Emulation) ver 1.3
[   27.602747] Bluetooth: BNEP filters: protocol multicast
[   27.602760] initcall bnep_init+0x0/0x6c [bnep] returned 0 after 13 usecs
[   27.810684] calling  br_init+0x0/0xb4 [bridge] @ 2215
[   27.810975] Bridge firewalling registered
[   27.811057] initcall br_init+0x0/0xb4 [bridge] returned 0 after 267 usecs
[   27.824806] calling  sco_init+0x0/0xc2 [sco] @ 2221
[   27.824871] Bluetooth: SCO (Voice Link) ver 0.6
[   27.824873] Bluetooth: SCO socket layer initialized
[   27.824878] initcall sco_init+0x0/0xc2 [sco] returned 0 after 9 usecs
[   29.505857] atl1c 0000:43:00.0: irq 34 for MSI/MSI-X
[   29.506457] ADDRCONF(NETDEV_UP): eth0: link is not ready
[   61.713085] PM: Syncing filesystems ... done.
[   61.731204] Freezing user space processes ... (elapsed 0.00 seconds) done.
[   61.732019] Freezing remaining freezable tasks ... (elapsed 0.00 seconds) done.
[   61.732231] Suspending console(s) (use no_console_suspend to debug)
[   61.733198] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[   61.904325] sd 0:0:0:0: [sda] Stopping disk
[   62.950311] atl1c 0000:43:00.0: wake-up capability disabled by ACPI
[   62.950322] atl1c 0000:43:00.0: PME# disabled
[   62.950333] atl1c 0000:43:00.0: PCI INT A disabled
[   63.004776] ehci_hcd 0000:00:1d.0: PCI INT A disabled
[   63.004800] ehci_hcd 0000:00:1a.0: PCI INT A disabled
[   63.028378] ehci_hcd 0000:00:1d.0: PME# disabled
[   63.039139] ehci_hcd 0000:00:1a.0: PME# disabled
[   63.049981] ACPI: Preparing to enter system sleep state S3
[   63.061410] Disabling non-boot CPUs ...
[   63.062576] Breaking affinity for irq 12
[   63.062610] Breaking affinity for irq 25
[   63.063816] CPU 1 is now offline
[   63.064104] CPU0 attaching NULL sched-domain.
[   63.064108] CPU1 attaching NULL sched-domain.
[   63.064110] CPU2 attaching NULL sched-domain.
[   63.064112] CPU3 attaching NULL sched-domain.
[   63.067695] CPU0 attaching sched-domain:
[   63.067700]  domain 0: span 0,2-3 level MC
[   63.067704]   groups: 0 2-3
[   63.067712] CPU2 attaching sched-domain:
[   63.067715]  domain 0: span 2-3 level SIBLING
[   63.067719]   groups: 2 3
[   63.067725]   domain 1: span 0,2-3 level MC
[   63.067728]    groups: 2-3 0
[   63.067735] CPU3 attaching sched-domain:
[   63.067739]  domain 0: span 2-3 level SIBLING
[   63.067742]   groups: 3 2
[   63.067747]   domain 1: span 0,2-3 level MC
[   63.067751]    groups: 2-3 0
[   63.068484] CPU1 is down
[   63.069615] Breaking affinity for irq 26
[   63.070717] CPU 2 is now offline
[   63.071010] CPU0 attaching NULL sched-domain.
[   63.071015] CPU2 attaching NULL sched-domain.
[   63.071017] CPU3 attaching NULL sched-domain.
[   63.074679] CPU0 attaching sched-domain:
[   63.074683]  domain 0: span 0,3 level MC
[   63.074687]   groups: 0 3
[   63.074695] CPU3 attaching sched-domain:
[   63.074698]  domain 0: span 0,3 level MC
[   63.074702]   groups: 3 0
[   63.075282] CPU2 is down
[   63.076428] Breaking affinity for irq 27
[   63.076480] Breaking affinity for irq 33
[   63.077525] CPU 3 is now offline
[   63.077527] lockdep: fixing up alternatives.
[   63.077529] SMP alternatives: switching to UP code
[   63.081560] CPU0 attaching NULL sched-domain.
[   63.081565] CPU3 attaching NULL sched-domain.
[   63.081582] CPU0 attaching NULL sched-domain.
[   63.081979] CPU3 is down
[   63.082036] Extended CMOS year: 2000
[   63.082039] timing suspend time is 1262636253s
[   63.082047] sched_clock_s3_init function is called
[    0.000999] x86 PAT enabled: cpu 0, old 0x7040600070406, new 0x7010600070106
[    0.000999] Back to C!
[    0.000999] CPU0: Thermal LVT vector (0xfa) already installed
[    0.000999] Extended CMOS year: 2000
[    0.000999] timing resume time is 1262636257s
[1266874881.233309] Enabling non-boot CPUs ...
[1266874881.233465] lockdep: fixing up alternatives.
[1266874881.233466] SMP alternatives: switching to SMP code
[1266874881.234882] BUG: soft lockup - CPU#0 stuck for 0s! [bash:2321]
[1266874881.234883] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874881.234898] 
[1266874881.234901] Pid: 2321, comm: bash Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874881.234903] EIP: 0060:[<c0406fb9>] EFLAGS: 00000286 CPU: 0
[1266874881.234909] EIP is at text_poke+0x149/0x154
[1266874881.234911] EAX: 000206f0 EBX: 00100800 ECX: c05c8445 EDX: 00000001
[1266874881.234913] ESI: f62b1e17 EDI: fff20446 EBP: f62b1e00 ESP: f62b1ddc
[1266874881.234915]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874881.234916] CR0: 8005003b CR2: 08073ed8 CR3: 3624a000 CR4: 000006d0
[1266874881.234918] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.234920] DR6: ffff0ff0 DR7: 00000400
[1266874881.234921] Call Trace:
[1266874881.234927]  [<c05c8445>] ? n_tty_set_termios+0x139/0x2c5
[1266874881.234930]  [<c04071b9>] alternatives_smp_switch+0xce/0x177
[1266874881.234936]  [<c072f0e3>] ? _etext+0x0/0x1
[1266874881.234939]  [<c07291c4>] native_cpu_up+0x16a/0x666
[1266874881.234941]  [<c0728d96>] ? do_fork_idle+0x0/0x1e
[1266874881.234944]  [<c072a6c3>] _cpu_up+0x8d/0xf3
[1266874881.234949]  [<c042df85>] ? printk+0x15/0x17
[1266874881.234951]  [<c071b365>] enable_nonboot_cpus+0x37/0x89
[1266874881.234956]  [<c0454ee9>] suspend_devices_and_enter+0xd1/0x139
[1266874881.234958]  [<c0454ff7>] enter_state+0xa6/0xd9
[1266874881.234960]  [<c04548da>] state_store+0x96/0xac
[1266874881.234963]  [<c0454844>] ? state_store+0x0/0xac
[1266874881.234967]  [<c056755d>] kobj_attr_store+0x1a/0x22
[1266874881.234971]  [<c04e3e8d>] sysfs_write_file+0xb8/0xe3
[1266874881.234974]  [<c04e3dd5>] ? sysfs_write_file+0x0/0xe3
[1266874881.234978]  [<c04a0a7e>] vfs_write+0x8c/0x141
[1266874881.234980]  [<c04a1023>] sys_write+0x3b/0x60
[1266874881.234983]  [<c04028b0>] sysenter_do_call+0x12/0x31
[1266874881.236182] Booting processor 1 APIC 0x1 ip 0x6000
[    0.000999] Initializing CPU#1
[1266874881.306767] Calibrating delay using timer specific routine.. 4801.10 BogoMIPS (lpj=2400553)
[1266874881.306776] CPU: Physical Processor ID: 0
[1266874881.306777] CPU: Processor Core ID: 0
[1266874881.306780] CPU: L1 I cache: 32K, L1 D cache: 32K
[1266874881.306782] CPU: L2 cache: 256K
[1266874881.306783] CPU: L3 cache: 3072K
[1266874881.306787] mce: CPU supports 9 MCE banks
[1266874881.306796] CPU1: Thermal monitoring enabled (TM1)
[1266874881.306800] CPU 1 MCA banks CMCI:2 CMCI:3 CMCI:5 CMCI:6
[1266874881.307851] x86 PAT enabled: cpu 1, old 0x7040600070406, new 0x7010600070106
[1266874881.309376] CPU1: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[1266874881.309387] Skipping synchronization checks as TSC is reliable.
[1266874881.309500] CPU0 attaching NULL sched-domain.
[1266874881.309777] Switched to high resolution mode on CPU 1
[1266874881.309831] BUG: soft lockup - CPU#1 stuck for 0s! [swapper:0]
[1266874881.309834] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874881.309865] 
[1266874881.309868] Pid: 0, comm: swapper Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874881.309870] EIP: 0060:[<c0408aa0>] EFLAGS: 00000246 CPU: 1
[1266874881.309875] EIP is at mwait_idle+0x86/0xb5
[1266874881.309876] EAX: 00000000 EBX: f6c90000 ECX: 00000000 EDX: 00000000
[1266874881.309878] ESI: f6c90000 EDI: c0924a64 EBP: f6c91f98 ESP: f6c91f78
[1266874881.309880]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874881.309882] CR0: 8005003b CR2: 00000000 CR3: 00981000 CR4: 000006d0
[1266874881.309884] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.309885] DR6: ffff0ff0 DR7: 00000400
[1266874881.309887] Call Trace:
[1266874881.309893]  [<c0449b3a>] ? tick_nohz_restart_sched_tick+0x27/0x12a
[1266874881.309897]  [<c0401a13>] cpu_idle+0x47/0x59
[1266874881.309901]  [<c0729854>] start_secondary+0x194/0x199
[1266874881.312792] CPU0 attaching sched-domain:
[1266874881.312797]  domain 0: span 0-1 level SIBLING
[1266874881.312801]   groups: 0 1
[1266874881.312809] CPU1 attaching sched-domain:
[1266874881.312813]  domain 0: span 0-1 level SIBLING
[1266874881.312817]   groups: 1 0
[1266874881.313781] hpet: hpet3 irq 25 for MSI
[1266874881.313786] CPU1 is up
[1266874881.313957] lockdep: fixing up alternatives.
[1266874881.313961] Booting processor 2 APIC 0x4 ip 0x6000
[    0.000999] Initializing CPU#2
[1266874881.384662] Calibrating delay using timer specific routine.. 4801.13 BogoMIPS (lpj=2400566)
[1266874881.384670] CPU: Physical Processor ID: 0
[1266874881.384671] CPU: Processor Core ID: 2
[1266874881.384674] CPU: L1 I cache: 32K, L1 D cache: 32K
[1266874881.384675] CPU: L2 cache: 256K
[1266874881.384676] CPU: L3 cache: 3072K
[1266874881.384679] mce: CPU supports 9 MCE banks
[1266874881.384688] CPU2: Thermal monitoring enabled (TM1)
[1266874881.384692] CPU 2 MCA banks SHD:6
[1266874881.385485] x86 PAT enabled: cpu 2, old 0x7040600070406, new 0x7010600070106
[1266874881.386608] CPU2: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[1266874881.386620] Skipping synchronization checks as TSC is reliable.
[1266874881.386667] Switched to high resolution mode on CPU 2
[1266874881.386694] CPU0 attaching NULL sched-domain.
[1266874881.386698] CPU1 attaching NULL sched-domain.
[1266874881.389755] CPU0 attaching sched-domain:
[1266874881.389757]  domain 0: span 0-1 level SIBLING
[1266874881.389759]   groups: 0 1
[1266874881.389762]   domain 1: span 0-2 level MC
[1266874881.389764]    groups: 0-1 2
[1266874881.389767] CPU1 attaching sched-domain:
[1266874881.389769]  domain 0: span 0-1 level SIBLING
[1266874881.389771]   groups: 1 0
[1266874881.389773]   domain 1: span 0-2 level MC
[1266874881.389775]    groups: 0-1 2
[1266874881.389778] CPU2 attaching sched-domain:
[1266874881.389779]  domain 0: span 0-2 level MC
[1266874881.389781]   groups: 2 0-1
[1266874881.390814] hpet: hpet4 irq 26 for MSI
[1266874881.390823] CPU2 is up
[1266874881.391046] lockdep: fixing up alternatives.
[1266874881.391050] Booting processor 3 APIC 0x5 ip 0x6000
[    0.000999] Initializing CPU#3
[1266874881.461622] Calibrating delay using timer specific routine.. 4801.11 BogoMIPS (lpj=2400558)
[1266874881.461629] CPU: Physical Processor ID: 0
[1266874881.461630] CPU: Processor Core ID: 2
[1266874881.461633] CPU: L1 I cache: 32K, L1 D cache: 32K
[1266874881.461634] CPU: L2 cache: 256K
[1266874881.461636] CPU: L3 cache: 3072K
[1266874881.461638] mce: CPU supports 9 MCE banks
[1266874881.461647] CPU3: Thermal monitoring enabled (TM1)
[1266874881.461651] CPU 3 MCA banks CMCI:2 CMCI:3 CMCI:5 SHD:6
[1266874881.462715] x86 PAT enabled: cpu 3, old 0x7040600070406, new 0x7010600070106
[1266874881.464291] CPU3: Intel(R) Core(TM) i5 CPU       M 520  @ 2.40GHz stepping 02
[1266874881.464306] Skipping synchronization checks as TSC is reliable.
[1266874881.464383] CPU0 attaching NULL sched-domain.
[1266874881.464388] CPU1 attaching NULL sched-domain.
[1266874881.464391] CPU2 attaching NULL sched-domain.
[1266874881.464566] Switched to high resolution mode on CPU 3
[1266874881.464748] BUG: soft lockup - CPU#3 stuck for 0s! [swapper:0]
[1266874881.464751] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874881.464780] 
[1266874881.464785] Pid: 0, comm: swapper Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874881.464790] EIP: 0060:[<c0408aa0>] EFLAGS: 00000246 CPU: 3
[1266874881.464798] EIP is at mwait_idle+0x86/0xb5
[1266874881.464802] EAX: 00000000 EBX: f6ca8000 ECX: 00000000 EDX: 00000000
[1266874881.464806] ESI: f6ca8000 EDI: c0924a64 EBP: f6ca9f98 ESP: f6ca9f78
[1266874881.464810]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[1266874881.464814] CR0: 8005003b CR2: 00000000 CR3: 00981000 CR4: 000006d0
[1266874881.464818] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.464821] DR6: ffff0ff0 DR7: 00000400
[1266874881.464824] Call Trace:
[1266874881.464835]  [<c0449b3a>] ? tick_nohz_restart_sched_tick+0x27/0x12a
[1266874881.464845]  [<c0401a13>] cpu_idle+0x47/0x59
[1266874881.464849]  [<c0729854>] start_secondary+0x194/0x199
[1266874881.466581] CPU0 attaching sched-domain:
[1266874881.466585]  domain 0: span 0-1 level SIBLING
[1266874881.466589]   groups: 0 1
[1266874881.466596]   domain 1: span 0-3 level MC
[1266874881.466599]    groups: 0-1 2-3
[1266874881.466608] CPU1 attaching sched-domain:
[1266874881.466611]  domain 0: span 0-1 level SIBLING
[1266874881.466615]   groups: 1 0
[1266874881.466620]   domain 1: span 0-3 level MC
[1266874881.466624]    groups: 0-1 2-3
[1266874881.466631] CPU2 attaching sched-domain:
[1266874881.466634]  domain 0: span 2-3 level SIBLING
[1266874881.466638]   groups: 2 3
[1266874881.466643]   domain 1: span 0-3 level MC
[1266874881.466649]    groups: 2-3 0-1
[1266874881.466652] CPU3 attaching sched-domain:
[1266874881.466654]  domain 0: span 2-3 level SIBLING
[1266874881.466655]   groups: 3 2
[1266874881.466658]   domain 1: span 0-3 level MC
[1266874881.466659]    groups: 2-3 0-1
[1266874881.467817] hpet: hpet5 irq 27 for MSI
[1266874881.467823] CPU3 is up
[1266874881.467825] ACPI: Waking up from system sleep state S3
[1266874881.759258] i915 0000:00:02.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874881.759265] i915 0000:00:02.0: restoring config space at offset 0x8 (was 0x1, writing 0x5031)
[1266874881.759272] i915 0000:00:02.0: restoring config space at offset 0x1 (was 0x900000, writing 0x900407)
[1266874881.759298] pci 0000:00:16.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874881.759319] pci 0000:00:16.0: restoring config space at offset 0x4 (was 0x4, writing 0x54706004)
[1266874881.759327] pci 0000:00:16.0: restoring config space at offset 0x1 (was 0x180000, writing 0x100006)
[1266874881.759358] ehci_hcd 0000:00:1a.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874881.759379] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x4 (was 0x0, writing 0x54705c00)
[1266874881.759388] ehci_hcd 0000:00:1a.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[1266874881.759410] ehci_hcd 0000:00:1a.0: PME# disabled
[1266874881.759451] pci 0000:00:1b.0: restoring config space at offset 0x1 (was 0x100004, writing 0x100006)
[1266874881.759488] pcieport-driver 0000:00:1c.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[1266874881.759500] pcieport-driver 0000:00:1c.0: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[1266874881.759505] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[1266874881.759511] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x8 (was 0x0, writing 0x54605460)
[1266874881.759517] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x7 (was 0x20000000, writing 0x200000f0)
[1266874881.759522] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x6 (was 0x0, writing 0x10100)
[1266874881.759531] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[1266874881.759539] pcieport-driver 0000:00:1c.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[1266874881.759593] pcieport-driver 0000:00:1c.1: restoring config space at offset 0xf (was 0x200, writing 0x20a)
[1266874881.759605] pcieport-driver 0000:00:1c.1: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[1266874881.759611] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[1266874881.759616] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x8 (was 0x0, writing 0x54505060)
[1266874881.759622] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x7 (was 0x20000000, writing 0x4030)
[1266874881.759627] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x6 (was 0x0, writing 0x420200)
[1266874881.759636] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[1266874881.759643] pcieport-driver 0000:00:1c.1: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[1266874881.759697] pcieport-driver 0000:00:1c.5: restoring config space at offset 0xf (was 0x200, writing 0x20a)
[1266874881.759709] pcieport-driver 0000:00:1c.5: restoring config space at offset 0xa (was 0x0, writing 0xffffffff)
[1266874881.759714] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x9 (was 0x10001, writing 0x1fff1)
[1266874881.759720] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x8 (was 0x0, writing 0x50505050)
[1266874881.759726] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x7 (was 0x20000000, writing 0x2020)
[1266874881.759731] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x6 (was 0x0, writing 0x434300)
[1266874881.759740] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x3 (was 0x810000, writing 0x810010)
[1266874881.759747] pcieport-driver 0000:00:1c.5: restoring config space at offset 0x1 (was 0x100000, writing 0x100407)
[1266874881.759797] ehci_hcd 0000:00:1d.0: restoring config space at offset 0xf (was 0x100, writing 0x10a)
[1266874881.759817] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x4 (was 0x0, writing 0x54705800)
[1266874881.759826] ehci_hcd 0000:00:1d.0: restoring config space at offset 0x1 (was 0x2900000, writing 0x2900002)
[1266874881.759847] ehci_hcd 0000:00:1d.0: PME# disabled
[1266874881.759960] ahci 0000:00:1f.2: restoring config space at offset 0x1 (was 0x2b00403, writing 0x2b00407)
[1266874881.760007] pci 0000:00:1f.6: restoring config space at offset 0xf (was 0x300, writing 0x30a)
[1266874881.760028] pci 0000:00:1f.6: restoring config space at offset 0x4 (was 0x4, writing 0x54704004)
[1266874881.760036] pci 0000:00:1f.6: restoring config space at offset 0x1 (was 0x100000, writing 0x100006)
[1266874881.760074] atl1c 0000:43:00.0: restoring config space at offset 0xf (was 0x100, writing 0x105)
[1266874881.760099] atl1c 0000:43:00.0: restoring config space at offset 0x3 (was 0x0, writing 0x10)
[1266874881.760107] atl1c 0000:43:00.0: restoring config space at offset 0x1 (was 0x100000, writing 0x100007)
[1266874881.863115] i915 0000:00:02.0: setting latency timer to 64
[1266874881.886118] BUG: soft lockup - CPU#2 stuck for 0s! [bash:2321]
[1266874881.886120] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874881.886135] 
[1266874881.886138] Pid: 2321, comm: bash Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874881.886140] EIP: 0060:[<c056c62b>] EFLAGS: 00000246 CPU: 2
[1266874881.886146] EIP is at delay_tsc+0x1b/0x3f
[1266874881.886147] EAX: 00087b13 EBX: 0024a149 ECX: 00000002 EDX: 00000000
[1266874881.886149] ESI: 00000002 EDI: 7bb7072f EBP: f62b1bcc ESP: f62b1bc0
[1266874881.886151]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874881.886153] CR0: 8005003b CR2: 00000000 CR3: 3624a000 CR4: 000006d0
[1266874881.886155] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874881.886156] DR6: ffff0ff0 DR7: 00000400
[1266874881.886158] Call Trace:
[1266874881.886163]  [<c056c5de>] __delay+0x9/0xb
[1266874881.886166]  [<c056c60e>] __const_udelay+0x2e/0x30
[1266874881.886170]  [<c05fb958>] intel_wait_for_vblank+0x15/0x1e
[1266874881.886173]  [<c05fcb87>] intel_pipe_set_base+0x445/0x4c1
[1266874881.886178]  [<c05ff6b2>] intel_crtc_mode_set+0x140f/0x1438
[1266874881.886184]  [<c056c60e>] ? __const_udelay+0x2e/0x30
[1266874881.886188]  [<c05fc660>] ? intel_crtc_dpms+0xcff/0xde1
[1266874881.886194]  [<c05ea7f7>] drm_crtc_helper_set_mode+0x201/0x316
[1266874881.886198]  [<c05ea944>] drm_helper_resume_force_mode+0x38/0x76
[1266874881.886201]  [<c05ece91>] i915_resume+0xbd/0xc5
[1266874881.886204]  [<c05ecea7>] i915_pci_resume+0xe/0x10
[1266874881.886207]  [<c0578843>] pci_legacy_resume+0x26/0x33
[1266874881.886210]  [<c0578938>] pci_pm_resume+0x39/0x63
[1266874881.886213]  [<c0615db0>] pm_op+0x55/0xb0
[1266874881.886215]  [<c0616290>] dpm_resume_end+0x7a/0x28f
[1266874881.886219]  [<c0454f19>] suspend_devices_and_enter+0x101/0x139
[1266874881.886222]  [<c0454ff7>] enter_state+0xa6/0xd9
[1266874881.886224]  [<c04548da>] state_store+0x96/0xac
[1266874881.886227]  [<c0454844>] ? state_store+0x0/0xac
[1266874881.886231]  [<c056755d>] kobj_attr_store+0x1a/0x22
[1266874881.886235]  [<c04e3e8d>] sysfs_write_file+0xb8/0xe3
[1266874881.886238]  [<c04e3dd5>] ? sysfs_write_file+0x0/0xe3
[1266874881.886242]  [<c04a0a7e>] vfs_write+0x8c/0x141
[1266874881.886244]  [<c04a1023>] sys_write+0x3b/0x60
[1266874881.886248]  [<c04028b0>] sysenter_do_call+0x12/0x31
[1266874881.904861] [drm] LVDS-8: set mode 1366x768 12
[1266874881.904865] unmatched BPC setting between FDI RX reg and pipeconf for pipe A
[1266874881.905531] Fix unmatched BPC setting between Transcoder and Pipe config in pipe A
[1266874881.906274] pci 0000:00:16.0: PME# disabled
[1266874881.906283] ehci_hcd 0000:00:1a.0: PME# disabled
[1266874881.906291] ehci_hcd 0000:00:1a.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[1266874881.906297] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[1266874881.906308] pci 0000:00:1b.0: PME# disabled
[1266874881.906323] ehci_hcd 0000:00:1d.0: PME# disabled
[1266874881.906327] ehci_hcd 0000:00:1d.0: PCI INT A -> GSI 20 (level, low) -> IRQ 20
[1266874881.906333] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[1266874881.906346] pci 0000:00:1e.0: setting latency timer to 64
[1266874881.906362] ahci 0000:00:1f.2: setting latency timer to 64
[1266874881.906420] pci 0000:00:1f.6: PME# disabled
[1266874881.906426] atl1c 0000:43:00.0: wake-up capability disabled by ACPI
[1266874881.906432] atl1c 0000:43:00.0: PME# disabled
[1266874881.906434] atl1c 0000:43:00.0: wake-up capability disabled by ACPI
[1266874881.906440] atl1c 0000:43:00.0: PME# disabled
[1266874881.969151] atl1c 0000:43:00.0: irq 34 for MSI/MSI-X
[1266874882.010570] sd 0:0:0:0: [sda] Starting disk
[1266874882.212581] ata2: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[1266874882.214578] ata5: SATA link down (SStatus 0 SControl 300)
[1266874882.217807] ata2.00: configured for UDMA/100
[1266874882.287494] ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9 t4
[1266874882.287498] ata2: irq_stat 0x40000001
[1266874882.292790] ata2.00: configured for UDMA/100
[1266874882.292795] ata2: EH complete
[1266874884.808105] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[1266874884.814764] ata1.00: configured for UDMA/100
[1266874884.995135] Restarting tasks ... 
[1266874884.995833] BUG: soft lockup - CPU#0 stuck for 0s! [udevd:881]
[1266874884.999496] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874885.003603] 
[1266874885.005562] Pid: 881, comm: udevd Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874885.007606] EIP: 0060:[<c072e4d4>] EFLAGS: 00000286 CPU: 0
[1266874885.009584] EIP is at _spin_unlock_irqrestore+0x22/0x26
[1266874885.011469] EAX: 00000000 EBX: c1b66680 ECX: f5744cbc EDX: 00004544
[1266874885.013386] ESI: 00000286 EDI: f59edb40 EBP: f6f2bf28 ESP: f6f2bf20
[1266874885.015281]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874885.017156] CR0: 8005003b CR2: bf8ffda4 CR3: 35105000 CR4: 000006d0
[1266874885.019039] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874885.020930] DR6: ffff0ff0 DR7: 00000400
[1266874885.022790] Call Trace:
[1266874885.024629]  [<c042aef8>] wake_up_new_task+0xbe/0xc4
[1266874885.026467]  [<c042ca2f>] do_fork+0x1ee/0x289
[1266874885.028290]  [<c04a18f7>] ? fput+0x17/0x19
[1266874885.030089]  [<c0401626>] sys_clone+0x24/0x2b
[1266874885.031898]  [<c04028b0>] sysenter_do_call+0x12/0x31
[1266874885.033712] BUG: soft lockup - CPU#1 stuck for 0s! [klogd:2172]
[1266874885.035592] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874885.035609] 
[1266874885.035612] Pid: 2172, comm: klogd Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874885.035616] EIP: 0060:[<c072e402>] EFLAGS: 00000286 CPU: 1
[1266874885.035621] EIP is at _spin_unlock_irq+0x1f/0x21
[1266874885.035624] EAX: 00000001 EBX: 00000036 ECX: f59e9f1c EDX: 0000fffe
[1266874885.035627] ESI: 00000fff EDI: 00000000 EBP: f5cb9ef8 ESP: f5cb9ef8
[1266874885.035630]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874885.035633] CR0: 8005003b CR2: b7e37420 CR3: 361e7000 CR4: 000006d0
[1266874885.035636] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874885.035639] DR6: ffff0ff0 DR7: 00000400
[1266874885.035641] Call Trace:
[1266874885.035646]  [<c042e32e>] do_syslog+0x134/0x320
[1266874885.035654]  [<c04d7181>] ? proc_reg_read+0x25/0x74
[1266874885.035659]  [<c04de906>] ? kmsg_read+0x0/0x3c
[1266874885.035662]  [<c04de93a>] kmsg_read+0x34/0x3c
[1266874885.035665]  [<c04d71bc>] proc_reg_read+0x60/0x74
[1266874885.035669]  [<c04d715c>] ? proc_reg_read+0x0/0x74
[1266874885.035673]  [<c04a0bbd>] vfs_read+0x8a/0x13f
[1266874885.035676]  [<c04a0fc3>] sys_read+0x3b/0x60
[1266874885.035680]  [<c04028b0>] sysenter_do_call+0x12/0x31
[1266874885.037958] BUG: soft lockup - CPU#3 stuck for 0s! [prefdm:2479]
[1266874885.037960] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874885.037970] 
[1266874885.037972] Pid: 2479, comm: prefdm Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874885.037975] EIP: 0060:[<c056c627>] EFLAGS: 00000246 CPU: 3
[1266874885.037979] EIP is at delay_tsc+0x17/0x3f
[1266874885.037981] EAX: 3f53f2c6 EBX: 00000001 ECX: 00000003 EDX: 00000002
[1266874885.037982] ESI: 00010a0c EDI: 00000001 EBP: f6cade34 ESP: f6cade28
[1266874885.037984]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874885.037986] CR0: 8005003b CR2: b7ddd5b0 CR3: 362a7000 CR4: 000006d0
[1266874885.037987] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874885.037989] DR6: ffff0ff0 DR7: 00000400
[1266874885.037990] Call Trace:
[1266874885.037993]  [<c056c5de>] __delay+0x9/0xb
[1266874885.037996]  [<c056fe44>] _raw_spin_lock+0xa6/0xfd
[1266874885.038000]  [<c072e557>] lock_kernel+0x1a/0x26
[1266874885.038003]  [<c05c3bd2>] memory_open+0xe/0x73
[1266874885.038006]  [<c04a2de7>] chrdev_open+0x11f/0x136
[1266874885.038008]  [<c049efc9>] __dentry_open+0x116/0x204
[1266874885.038011]  [<c049feb1>] nameidata_to_filp+0x2c/0x43
[1266874885.038013]  [<c04a2cc8>] ? chrdev_open+0x0/0x136
[1266874885.038016]  [<c04aa1cc>] do_filp_open+0x3e4/0x6fa
[1266874885.038019]  [<c04b1a2b>] ? alloc_fd+0x22/0xca
[1266874885.038022]  [<c049edb7>] do_sys_open+0x4a/0xe7
[1266874885.038026]  [<c04426aa>] ? up_read+0x16/0x2c
[1266874885.038028]  [<c049ee96>] sys_open+0x1e/0x26
[1266874885.038031]  [<c04028b0>] sysenter_do_call+0x12/0x31
[1266874885.141384] done.
[1266874885.142756] BUG: soft lockup - CPU#2 stuck for 0s! [pidof:2479]
[1266874885.142758] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874885.142770] 
[1266874885.142773] Pid: 2479, comm: pidof Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874885.142775] EIP: 0060:[<c044c51c>] EFLAGS: 00000282 CPU: 2
[1266874885.142781] EIP is at lock_acquire+0xa2/0xa6
[1266874885.142782] EAX: f5756460 EBX: c08e85c0 ECX: f5756460 EDX: 00000001
[1266874885.142784] ESI: 00000000 EDI: 00000000 EBP: f6cade14 ESP: f6cade0c
[1266874885.142786]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874885.142788] CR0: 8005003b CR2: 08060a5c CR3: 361c8000 CR4: 000006d0
[1266874885.142789] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874885.142791] DR6: ffff0ff0 DR7: 00000400
[1266874885.142792] Call Trace:
[1266874885.142796]  [<c072e1e0>] _spin_lock+0x1b/0x2a
[1266874885.142799]  [<c04b263b>] ? lookup_mnt+0x10/0x38
[1266874885.142802]  [<c04b263b>] lookup_mnt+0x10/0x38
[1266874885.142804]  [<c04a70dd>] __follow_mount+0x13/0x65
[1266874885.142806]  [<c04a71bc>] do_lookup+0x4f/0x154
[1266874885.142809]  [<c04a8bf2>] __link_path_walk+0x2cc/0xac1
[1266874885.142811]  [<c04a86d8>] ? path_init+0x3f/0x110
[1266874885.142814]  [<c04a9420>] path_walk+0x39/0x72
[1266874885.142817]  [<c04a94da>] do_path_lookup+0x21/0x42
[1266874885.142820]  [<c04a9ccc>] user_path_at+0x3c/0x67
[1266874885.142824]  [<c0489556>] ? handle_mm_fault+0x769/0x77a
[1266874885.142828]  [<c04a35f2>] sys_readlinkat+0x26/0x81
[1266874885.142832]  [<c04426aa>] ? up_read+0x16/0x2c
[1266874885.142835]  [<c04a3660>] sys_readlink+0x13/0x15
[1266874885.142839]  [<c04028b0>] sysenter_do_call+0x12/0x31
[1266874885.247746] usb 2-1.3: new high speed USB device using ehci_hcd and address 3
[1266874885.346328] usb 2-1.3: New USB device found, idVendor=0bda, idProduct=0158
[1266874885.346334] usb 2-1.3: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[1266874885.346339] usb 2-1.3: Product: USB2.0-CRW
[1266874885.346343] usb 2-1.3: Manufacturer: Generic
[1266874885.346347] usb 2-1.3: SerialNumber: 20071114173400000
[1266874885.346526] usb 2-1.3: configuration #1 chosen from 1 choice
[1266874885.352045] scsi6 : SCSI emulation for USB Mass Storage devices
[1266874885.352384] usb-storage: device found at 3
[1266874885.352390] usb-storage: waiting for device to settle before scanning
[1266874888.148610] BUG: soft lockup - CPU#0 stuck for 0s! [pidof:2534]
[1266874888.152638] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874888.161373] 
[1266874888.165538] Pid: 2534, comm: pidof Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874888.169863] EIP: 0073:[<b7da755b>] EFLAGS: 00000292 CPU: 0
[1266874888.174181] EIP is at 0xb7da755b
[1266874888.178382] EAX: b7eda380 EBX: b7ed9ff4 ECX: 0000000a EDX: 00000020
[1266874888.182601] ESI: 00000000 EDI: 00000040 EBP: bfd76c34 ESP: bfd76c1c
[1266874888.186859]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b
[1266874888.191110] CR0: 8005003b CR2: b7dc81ec CR3: 35deb000 CR4: 000006d0
[1266874888.195398] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874888.199612] DR6: ffff0ff0 DR7: 00000400
[1266874888.203848] Call Trace:
[1266874888.994476] BUG: soft lockup - CPU#0 stuck for 0s! [bash:2321]
[1266874888.994480] Modules linked in: sco bridge stp bnep l2cap bluetooth rfkill ipv6 usb_storage acpi_cpufreq sbs sbshc pci_slot uinput serio_raw joydev hp_accel lis3lv02d pcspkr sg input_polldev atl1c sr_mod
[1266874888.994505] 
[1266874888.994510] Pid: 2321, comm: bash Not tainted (2.6.31 #13) HP ProBook 4420s Notebook PCcpqt
[1266874888.994515] EIP: 0060:[<c058dea9>] EFLAGS: 00000217 CPU: 0
[1266874888.994522] EIP is at bit_putcs+0x2c6/0x4de
[1266874888.994526] EAX: 00000000 EBX: f5138216 ECX: f56d0f57 EDX: 00000001
[1266874888.994532] ESI: f5138216 EDI: f56d0f5a EBP: f62b1d04 ESP: f62b1c2c
[1266874888.994538]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[1266874888.994542] CR0: 8005003b CR2: 080f17f8 CR3: 3624a000 CR4: 000006d0
[1266874888.994546] DR0: 00000000 DR1: 00000000 DR2: 00000000 DR3: 00000000
[1266874888.994549] DR6: ffff0ff0 DR7: 00000400
[1266874888.994552] Call Trace:
[1266874888.994563]  [<c05894ca>] fbcon_putcs+0x1f5/0x23e
[1266874888.994569]  [<c058dbe3>] ? bit_putcs+0x0/0x4de
[1266874888.994575]  [<c058a9fe>] fbcon_redraw+0xbb/0x13d
[1266874888.994581]  [<c058e0c1>] ? bit_cursor+0x0/0x493
[1266874888.994586]  [<c058c8e3>] fbcon_scroll+0x5e9/0xb71
[1266874888.994593]  [<c05d277c>] scrup+0x57/0xbe
[1266874888.994602]  [<c0442fb0>] ? __atomic_notifier_call_chain+0x52/0x5c
[1266874888.994607]  [<c05d2842>] lf+0x1b/0x47
[1266874888.994613]  [<c05d49d8>] do_con_write+0x838/0x1878
[1266874888.994621]  [<c05c82e4>] ? process_output+0x19/0x41
[1266874888.994627]  [<c05d5a59>] con_write+0xc/0x1b
[1266874888.994633]  [<c05c7f59>] do_output_char+0x94/0x1a9
[1266874888.994638]  [<c05c82f9>] process_output+0x2e/0x41
[1266874888.994644]  [<c05c8a3e>] n_tty_write+0x224/0x2e5
[1266874888.994652]  [<c0425ef9>] ? default_wake_function+0x0/0xd
[1266874888.994657]  [<c05c6795>] tty_write+0x14d/0x1c4
[1266874888.994663]  [<c05c881a>] ? n_tty_write+0x0/0x2e5
[1266874888.994668]  [<c05c6648>] ? tty_write+0x0/0x1c4
[1266874888.994674]  [<c04a0a7e>] vfs_write+0x8c/0x141
[1266874888.994680]  [<c04a1023>] sys_write+0x3b/0x60
[1266874888.994686]  [<c04028b0>] sysenter_do_call+0x12/0x31
[    0.636466] usb-storage: device scan complete
[    0.638543] scsi 6:0:0:0: Direct-Access     Generic- Multi-Card       1.00 PQ: 0 ANSI: 0 CCS
[    0.639735] sd 6:0:0:0: Attached scsi generic sg2 type 0
[    0.645070] sd 6:0:0:0: [sdb] Attached SCSI removable disk
[  272.656797] atl1c 0000:43:00.0: atl1c: eth0 NIC Link is Up<100 Mbps Full Duplex>
[  272.657103] ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[  280.851225] lo: Disabled Privacy Extensions
[  282.720148] eth0: no IPv6 routers present

--=-cjtlXywonB/LAebr3DH3--

