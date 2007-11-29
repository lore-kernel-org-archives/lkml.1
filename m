Return-Path: <linux-kernel-owner+w=401wt.eu-S932934AbXK2Rsi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932934AbXK2Rsi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 12:48:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932085AbXK2RsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 12:48:22 -0500
Received: from rtr.ca ([76.10.145.34]:2877 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932822AbXK2RsT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 12:48:19 -0500
Message-ID: <474EFB61.8090803@rtr.ca>
Date: Thu, 29 Nov 2007 12:48:17 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] base/class.c: prevent ooops due to insert/remove race
References: <474E3964.7040200@rtr.ca> <20071129043307.GA4766@suse.de> <474EDDA9.1040205@rtr.ca> <20071129162727.GA8352@suse.de> <474EFAC1.1010100@rtr.ca>
In-Reply-To: <474EFAC1.1010100@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> (reposting for linux-usb-devel list)
> 
> Greg KH wrote:
>> On Wed, Nov 28, 2007 at 11:00:36PM -0500, Mark Lord wrote:
>>> While doing insert/remove (quickly) tests on USB, I managed to trigger
>>> an Oops on 2.6.23.8 on the call to strlen() in make_class_name().
>>>
>>> This patch prevents this oops.
>>>
>>> There is still the larger problem of the overall race
>>> that caused this in the first place, but much of the rest
>>> of the code in class.c appears to also do NULL checks to
>>> avoid Oops'ing, so this continues the tradition.
...

And here is a "prevented" oops, courtesy of the patch (2.6.23.8).
These are easy to reproduce (just jiggle the connection on an
attached USB multi-card reader with a CF card inserted):

 
[  334.896262] usb 5-6: new high speed USB device using ehci_hcd and address 7
[  335.021691] usb 5-6: configuration #1 chosen from 1 choice
[  336.898965] scsi4 : SCSI emulation for USB Mass Storage devices
[  336.899932] usb-storage: device found at 7
[  336.900147] usb-storage: waiting for device to settle before scanning
[  336.990877] usb 5-6: USB disconnect, address 7
[  338.180189] usb 5-6: new high speed USB device using ehci_hcd and address 8
[  338.306630] usb 5-6: configuration #1 chosen from 1 choice
[  338.307467] scsi5 : SCSI emulation for USB Mass Storage devices
[  338.308351] usb-storage: device found at 8
[  338.308566] usb-storage: waiting for device to settle before scanning
[  339.305274] usb-storage: device scan complete
[  337.429741] scsi 5:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
[  340.511500] sd 5:0:0:0: [sdc] 31194450 512-byte hardware sectors (15972 MB)
[  340.512497] sd 5:0:0:0: [sdc] Write Protect is off
[  340.512528] sd 5:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  338.636196] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[  340.515259] sd 5:0:0:0: [sdc] 31194450 512-byte hardware sectors (15972 MB)
[  340.516118] sd 5:0:0:0: [sdc] Write Protect is off
[  340.516124] sd 5:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  340.516128] sd 5:0:0:0: [sdc] Assuming drive cache: write through
[  340.516133]  sdc: sdc1
[  338.690276] sd 5:0:0:0: [sdc] Attached SCSI removable disk
[  338.690581] sd 5:0:0:0: Attached scsi generic sg2 type 0
[  343.136516] usb 5-6: USB disconnect, address 8
[  342.227115] usb 5-6: new high speed USB device using ehci_hcd and address 9
[  342.352670] usb 5-6: configuration #1 chosen from 1 choice
[  344.229737] scsi6 : SCSI emulation for USB Mass Storage devices
[  342.353847] usb-storage: device found at 9
[  342.353989] usb-storage: waiting for device to settle before scanning
[  344.415574] usb 5-6: USB disconnect, address 9
[  345.610896] usb 5-6: new high speed USB device using ehci_hcd and address 10
[  343.870682] usb 5-6: configuration #1 chosen from 1 choice
[  345.747498] scsi7 : SCSI emulation for USB Mass Storage devices
[  345.747986] usb-storage: device found at 10
[  345.748213] usb-storage: waiting for device to settle before scanning
[  346.745898] usb-storage: device scan complete
[  346.746856] scsi 7:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
[  347.099562] usb 5-6: USB disconnect, address 10
[  347.101077] BUG: unable to handle kernel NULL pointer dereference at virtual address 00000000
[  347.101086]  printing eip:
[  347.101088] c01bfe2d
[  347.101091] *pde = 00000000
[  347.101095] Oops: 0000 [#1]
[  347.101098] PREEMPT SMP 
[  347.101102] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage libusual microcode binfmt_misc rfcomm l2cap bluetooth nfs nfsd exportfs lockd nfs_acl auth_rpcgss sunrpc acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_ondemand freq_table cpufreq_powersave container fan firmware_class pciehp pci_hotplug usbhid hid visor af_packet usbserial fuse firewire_sbp2 mousedev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi serio_raw snd_seq_midi_event snd_seq snd_timer snd_seq_device firewire_ohci firewire_core b44 mii thermal ehci_hcd uhci_hcd usbcore sdhci pcspkr sr_mod cdrom mmc_core crc_itu_t sg ac psmouse processor snd soundcore intel_agp agpgart battery button snd_page_alloc unix
[  347.101196] CPU:    1
[  347.101197] EIP:    0060:[strlen+8/17]    Not tainted VLI
[  347.101199] EFLAGS: 00010246   (2.6.23.8 #6)
[  347.101209] EIP is at strlen+0x8/0x11
[  347.101212] eax: 00000000   ebx: 0000000b   ecx: ffffffff   edx: f6cad204
[  347.101217] esi: c02f6887   edi: 00000000   ebp: f6cad204   esp: f7152e58
[  347.101221] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  347.101226] Process khubd (pid: 2087, ti=f7152000 task=c29beaa0 task.ti=f7152000)
[  347.101229] Stack: f6cad204 c020ed4c f6cad1fc c03297f4 c0329780 c020ee65 00000000 f6cad1fc 
[  347.101240]        f6cad098 00000202 f5a70000 c020eef9 f6cad000 c021ab43 f6cad000 f77e0000 
[  347.101250]        c021868c f77e0038 f77e0000 c02139bc f77e02ec f77e0000 f8be27c0 f8bd6691 
[  347.101261] Call Trace:
[  347.101268]  [make_class_name+29/87] make_class_name+0x1d/0x57
[  347.101280]  [class_device_del+131/271] class_device_del+0x83/0x10f
[  347.101291]  [class_device_unregister+8/16] class_device_unregister+0x8/0x10
[  347.101300]  [__scsi_remove_device+43/104] __scsi_remove_device+0x2b/0x68
[  347.101309]  [scsi_forget_host+45/74] scsi_forget_host+0x2d/0x4a
[  347.101319]  [scsi_remove_host+101/213] scsi_remove_host+0x65/0xd5
[  347.101329]  [<f8bd6691>] quiesce_and_remove_host+0x99/0xa7 [usb_storage]
Nov 29 12:39:07 corey kernel: [  347.101346]  [<f8bd6763>] storage_disconnect+0xe/0x16 [usb_storage]
Nov 29 12:39:07 corey kernel: [  347.101361]  [<f88d7a50>] usb_unbind_interface+0x44/0x94 [usbcore]
Nov 29 12:39:07 corey kernel: [  347.101409]  [__device_release_driver+113/142] __device_release_driver+0x71/0x8e
Nov 29 12:39:07 corey kernel: [  347.101418]  [device_release_driver+30/52] device_release_driver+0x1e/0x34
Nov 29 12:39:07 corey kernel: [  347.101426]  [bus_remove_device+109/125] bus_remove_device+0x6d/0x7d
Nov 29 12:39:07 corey kernel: [  347.101434]  [device_del+460/576] device_del+0x1cc/0x240
Nov 29 12:39:07 corey kernel: [  347.101444]  [<f88d53f9>] usb_disable_device+0x5c/0xbb [usbcore]
Nov 29 12:39:07 corey kernel: [  347.101489]  [<f88d1aff>] usb_disconnect+0x83/0x11b [usbcore]
Nov 29 12:39:07 corey kernel: [  347.101537]  [<f88d220d>] hub_thread+0x388/0xa8d [usbcore]
Nov 29 12:39:07 corey kernel: [  347.101586]  [schedule+1417/1463] __sched_text_start+0x589/0x5b7
Nov 29 12:39:07 corey kernel: [  347.101602]  [autoremove_wake_function+0/53] autoremove_wake_function+0x0/0x35
Nov 29 12:39:07 corey kernel: [  347.101615]  [<f88d1e85>] hub_thread+0x0/0xa8d [usbcore]
Nov 29 12:39:07 corey kernel: [  347.101656]  [kthread+56/95] kthread+0x38/0x5f
Nov 29 12:39:07 corey kernel: [  347.101663]  [kthread+0/95] kthread+0x0/0x5f
Nov 29 12:39:07 corey kernel: [  347.101669]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
Nov 29 12:39:07 corey kernel: [  347.101681]  =======================
Nov 29 12:39:07 corey kernel: [  347.101683] Code: f0 48 5e c3 56 89 d1 89 c6 83 ec 04 31 d2 89 c8 88 c4 ac 38 e0 75 03 8d 56 ff 84 c0 75 f4 5e 89 d0 5e c3 57 83 c9 ff 89 c7 31 c0 <f2> ae f7 d1 49 5f 89 c8 c3 57 89 c7 89 d0 31 d2 85 c9 74 0c f2 
Nov 29 12:39:07 corey kernel: [  347.101738] EIP: [strlen+8/17] strlen+0x8/0x11 SS:ESP 0068:f7152e58
Nov 29 12:39:07 corey kernel: [  345.226354] sd 7:0:0:0: [sdc] READ CAPACITY failed
Nov 29 12:39:07 corey kernel: [  345.226360] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 12:39:07 corey kernel: [  345.226367] sd 7:0:0:0: [sdc] Sense not available.
Nov 29 12:39:07 corey kernel: [  345.226382] sd 7:0:0:0: [sdc] Write Protect is off
Nov 29 12:39:07 corey kernel: [  345.226386] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
Nov 29 12:39:07 corey kernel: [  345.226390] sd 7:0:0:0: [sdc] Assuming drive cache: write through
Nov 29 12:39:07 corey kernel: [  345.226471] sd 7:0:0:0: [sdc] Attached SCSI removable disk
Nov 29 12:39:07 corey kernel: [  345.226539] sd 7:0:0:0: Attached scsi generic sg2 type 0
Nov 29 12:39:07 corey kernel: [  347.151887] sd 7:0:0:0: [sdc] READ CAPACITY failed
Nov 29 12:39:07 corey kernel: [  347.151895] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 12:39:07 corey kernel: [  347.151902] sd 7:0:0:0: [sdc] Sense not available.
Nov 29 12:39:07 corey kernel: [  347.151918] sd 7:0:0:0: [sdc] Write Protect is off
Nov 29 12:39:07 corey kernel: [  347.151922] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
Nov 29 12:39:07 corey kernel: [  347.151927] sd 7:0:0:0: [sdc] Assuming drive cache: write through
Nov 29 12:39:07 corey kernel: [  347.151981] sd 7:0:0:0: [sdc] READ CAPACITY failed
Nov 29 12:39:07 corey kernel: [  347.151985] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 12:39:07 corey kernel: [  347.151993] sd 7:0:0:0: [sdc] Sense not available.
Nov 29 12:39:07 corey kernel: [  347.152008] sd 7:0:0:0: [sdc] Write Protect is off
Nov 29 12:39:07 corey kernel: [  347.152013] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
Nov 29 12:39:07 corey kernel: [  347.152017] sd 7:0:0:0: [sdc] Assuming drive cache: write through
Nov 29 12:39:07 corey kernel: [  345.279916] sd 7:0:0:0: [sdc] READ CAPACITY failed
Nov 29 12:39:07 corey kernel: [  345.279951] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 12:39:07 corey kernel: [  345.279965] sd 7:0:0:0: [sdc] Sense not available.
Nov 29 12:39:07 corey kernel: [  345.279982] sd 7:0:0:0: [sdc] Write Protect is off
Nov 29 12:39:07 corey kernel: [  345.279987] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
Nov 29 12:39:07 corey kernel: [  345.279991] sd 7:0:0:0: [sdc] Assuming drive cache: write through
Nov 29 12:39:07 corey kernel: [  345.280047] sd 7:0:0:0: [sdc] READ CAPACITY failed
Nov 29 12:39:07 corey kernel: [  345.280051] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 12:39:07 corey kernel: [  345.280059] sd 7:0:0:0: [sdc] Sense not available.
Nov 29 12:39:07 corey kernel: [  345.280075] sd 7:0:0:0: [sdc] Write Protect is off
Nov 29 12:39:07 corey kernel: [  345.280079] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
Nov 29 12:39:07 corey kernel: [  345.280083] sd 7:0:0:0: [sdc] Assuming drive cache: write through
Nov 29 12:39:07 corey kernel: [  345.289528] sd 7:0:0:0: [sdc] READ CAPACITY failed
Nov 29 12:39:07 corey kernel: [  345.289536] sd 7:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
Nov 29 12:39:07 corey kernel: [  345.289542] sd 7:0:0:0: [sdc] Sense not available.
Nov 29 12:39:07 corey kernel: [  345.289560] sd 7:0:0:0: [sdc] Write Protect is off
Nov 29 12:39:07 corey kernel: [  345.289564] sd 7:0:0:0: [sdc] Mode Sense: 00 00 00 00
Nov 29 12:39:07 corey kernel: [  345.289569] sd 7:0:0:0: [sdc] Assuming drive cache: write through
