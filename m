Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbXK1UCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbXK1UCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 15:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755544AbXK1UCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 15:02:39 -0500
Received: from rtr.ca ([76.10.145.34]:1650 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbXK1UCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 15:02:38 -0500
Message-ID: <474DC95B.7000201@rtr.ca>
Date: Wed, 28 Nov 2007 15:02:35 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [BUG] Oops in USB / dev code plugging/unplugging multi flash reader
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


While testing a new USB reader/cable today,
I was plugging/unplugging the USB multi-flash reader (22 in 1),
and produced this weird oops.

There's a locking problem in there somewhere, Greg.

2.6.23.8

Cheers



[  140.987726] usb-storage: waiting for device to settle before scanning
[  141.986281] usb-storage: device scan complete
[  141.989295] scsi 10:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
[  142.147419] usb 3-2: reset full speed USB device using uhci_hcd and address 8
[  143.245586] usb 3-2: device not accepting address 8, error -75
[  143.352086] usb 3-2: reset full speed USB device using uhci_hcd and address 8
[  143.468557] usb 3-2: device descriptor read/64, error -71
[  143.688188] usb 3-2: device descriptor read/64, error -71
[  143.897843] usb 3-2: reset full speed USB device using uhci_hcd and address 8
[  144.130859] usb 3-2: reset full speed USB device using uhci_hcd and address 8
ent[10269]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:1d.2/usb3/3-2/3-2:1.0/host10/target10:0:0/10:0:0:0/ioerr_cnt' failed
[  146.706517] usb 3-2: reset full speed USB device using uhci_hcd and address 8
[  146.763152] usb 3-2: USB disconnect, address 8
[  146.763659] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  146.763667]  printing eip:
[  146.763670] c01bfe2d
[  146.763672] *pde = 00000000
[  146.763677] Oops: 0000 [#1]
[  146.763679] PREEMPT SMP 
[  146.763683] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage libusual hci_usb microcode binfmt_misc rfcomm l2cap bluetooth nfs nfsd exportfs lockd nfs_acl auth_rpcgss sunrpc acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_ondemand freq_table cpufreq_powersave container fan firmware_class usbhid pciehp pci_hotplug hid visor af_packet usbserial fuse firewire_sbp2 mousedev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi sdhci snd_seq_midi_event snd_seq firewire_ohci firewire_core ehci_hcd serio_raw sr_mod b44 fglrx(P) snd_timer snd_seq_device uhci_hcd pcspkr mmc_core psmouse cdrom sg mii crc_itu_t intel_agp agpgart thermal battery usbcore snd soundcore snd_page_alloc button ac processor unix
[  146.763784] CPU:    1
[  146.763785] EIP:    0060:[strlen+8/17]    Tainted: P        VLI
[  146.763787] EFLAGS: 00010246   (2.6.23.8 #4)
[  146.763798] EIP is at strlen+0x8/0x11
[  146.763802] eax: 00000000   ebx: 0000000b   ecx: ffffffff   edx: f5541204
[  146.763806] esi: c02f6887   edi: 00000000   ebp: f5541204   esp: f7276e58
[  146.763810] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  146.763815] Process khubd (pid: 1980, ti=f7276000 task=f7f5b550 task.ti=f7276000)
[  146.763819] Stack: f5541204 c020ed44 f55411fc c03297f4 c0329780 c020ee5d 00000000 f55411fc 
[  146.763830]        f5541098 00000202 f5715400 c020eef1 f5541000 c021ab3b f5541000 f5789800 
[  146.763840]        c0218684 f5789838 f5789800 c02139b4 f5789aec f5789800 f8d837c0 f8d77691 
[  146.763850] Call Trace:
[  146.763857]  [make_class_name+21/79] make_class_name+0x15/0x4f
[  146.763871]  [class_device_del+131/271] class_device_del+0x83/0x10f
[  146.763882]  [class_device_unregister+8/16] class_device_unregister+0x8/0x10
[  146.763891]  [__scsi_remove_device+43/104] __scsi_remove_device+0x2b/0x68
[  146.763901]  [scsi_forget_host+45/74] scsi_forget_host+0x2d/0x4a
[  146.763912]  [scsi_remove_host+101/213] scsi_remove_host+0x65/0xd5
[  146.763923]  [<f8d77691>] quiesce_and_remove_host+0x99/0xa7 [usb_storage]
[  146.763942]  [<f8d77763>] storage_disconnect+0xe/0x16 [usb_storage]
[  146.763958]  [<f889ca50>] usb_unbind_interface+0x44/0x94 [usbcore]
[  146.764009]  [__device_release_driver+113/142] __device_release_driver+0x71/0x8e
[  146.764019]  [device_release_driver+30/52] device_release_driver+0x1e/0x34
[  146.764027]  [bus_remove_device+109/125] bus_remove_device+0x6d/0x7d
[  146.764036]  [device_del+460/576] device_del+0x1cc/0x240
[  146.764046]  [<f889a3f9>] usb_disable_device+0x5c/0xbb [usbcore]
[  146.764093]  [<f8896aff>] usb_disconnect+0x83/0x11b [usbcore]
[  146.764143]  [<f889720d>] hub_thread+0x388/0xa8d [usbcore]
[  146.764193]  [schedule+1359/1463] __sched_text_start+0x54f/0x5b7
[  146.764210]  [autoremove_wake_function+0/53] autoremove_wake_function+0x0/0x35
[  146.764224]  [<f8896e85>] hub_thread+0x0/0xa8d [usbcore]
[  146.764267]  [kthread+56/95] kthread+0x38/0x5f
[  146.764274]  [kthread+0/95] kthread+0x0/0x5f
[  146.764281]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
[  146.764295]  =======================
[  146.764298] Code: f0 48 5e c3 56 89 d1 89 c6 83 ec 04 31 d2 89 c8 88 c4 ac 38 e0 75 03 8d 56 ff 84 c0 75 f4 5e 89 d0 5e c3 57 83 c9 ff 89 c7 31 c0 <f2> ae f7 d1 49 5f 89 c8 c3 57 89 c7 89 d0 31 d2 85 c9 74 0c f2 
[  146.764352] EIP: [strlen+8/17] strlen+0x8/0x11 SS:ESP 0068:f7276e58
[  146.766089] sd 10:0:0:0: [sdb] READ CAPACITY failed
[  146.766151] sd 10:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  146.766256] sd 10:0:0:0: [sdb] Sense not available.
[  146.766885] sd 10:0:0:0: [sdb] Write Protect is off
[  146.766948] sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  146.767014] sd 10:0:0:0: [sdb] Assuming drive cache: write through
[  146.770680] sd 10:0:0:0: [sdb] Attached SCSI removable disk
[  146.776314] sd 10:0:0:0: Attached scsi generic sg2 type 0
[  146.785868] sd 10:0:0:0: [sdb] READ CAPACITY failed
[  146.786122] sd 10:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  146.786492] sd 10:0:0:0: [sdb] Sense not available.
[  146.786740] sd 10:0:0:0: [sdb] Write Protect is off
[  146.786974] sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  146.786985] sd 10:0:0:0: [sdb] Assuming drive cache: write through
[  146.787555] sd 10:0:0:0: [sdb] READ CAPACITY failed
[  146.787798] sd 10:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  146.788201] sd 10:0:0:0: [sdb] Sense not available.
[  146.788453] sd 10:0:0:0: [sdb] Write Protect is off
[  146.788685] sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  146.788696] sd 10:0:0:0: [sdb] Assuming drive cache: write through
[  146.791713] sd 10:0:0:0: [sdb] READ CAPACITY failed
[  146.792228] sd 10:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  146.792303] sd 10:0:0:0: [sdb] Sense not available.
[  146.792328] sd 10:0:0:0: [sdb] Write Protect is off
[  146.792333] sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  146.792337] sd 10:0:0:0: [sdb] Assuming drive cache: write through
[  146.792393] sd 10:0:0:0: [sdb] READ CAPACITY failed
[  146.792397] sd 10:0:0:0: [sdb] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  146.792403] sd 10:0:0:0: [sdb] Sense not available.
[  146.792419] sd 10:0:0:0: [sdb] Write Protect is off
[  146.792423] sd 10:0:0:0: [sdb] Mode Sense: 00 00 00 00
[  146.792427] sd 10:0:0:0: [sdb] Assuming drive cache: write through
