Return-Path: <linux-kernel-owner+w=401wt.eu-S1763419AbXK2SNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763419AbXK2SNS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 13:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759497AbXK2SM7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 13:12:59 -0500
Received: from rtr.ca ([76.10.145.34]:4057 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686AbXK2SM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 13:12:59 -0500
Message-ID: <474F0129.5080306@rtr.ca>
Date: Thu, 29 Nov 2007 13:12:57 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-usb-devel@lists.sourceforge.net
Subject: Re: [PATCH] base/class.c: prevent ooops due to insert/remove race
 (v3)
References: <474E3964.7040200@rtr.ca> <20071129043307.GA4766@suse.de> <474EDDA9.1040205@rtr.ca> <20071129162727.GA8352@suse.de> <474EFAC1.1010100@rtr.ca> <474EFB61.8090803@rtr.ca> <474EFBFF.9090400@rtr.ca> <474F0071.5010507@rtr.ca>
In-Reply-To: <474F0071.5010507@rtr.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
> ..
> 
> While doing insert/remove (quickly) tests on USB,
> I managed to trigger an Oops on 2.6.23.8 on a call
> to strlen() in make_class_name().
> 
> USB maintainers can try this themselves, by plugging in an
> external USB XX-in-1 flash reader, with a CF card inserted.
> Then just jiggle the connection so that the device connects
> and disconnects rapidly.  This may not sound realistic,
> but there's definitely a race in there, and this is a quick
> way to reproduce it if need be.
> 
> The patch below prevents the oops, but still keeps the bug visible.
> 
> Signed-off-by:  Mark Lord <mlord@pobox.com> ---
> 
> Patch applies to both 2.6.24 and 2.6.23.
...

And below is a "prevented Oops", courtesy of the patch.
The next bug to fix is whereever the code resides that
repeatedly continues to flog the unplugged device
after the test, despite SCSI returning host_byte=DID_NO_CONNECT.

[  181.315376] sd 27:0:0:0: [sdc] Write Protect is off
[  181.315383] sd 27:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  181.315387] sd 27:0:0:0: [sdc] Assuming drive cache: write through
[  181.315392]  sdc: sdc1
[  181.365660] sd 27:0:0:0: [sdc] Attached SCSI removable disk
[  181.365917] sd 27:0:0:0: Attached scsi generic sg2 type 0
[  184.000408] usb 2-3: USB disconnect, address 35
[  184.583453] usb 2-3: new high speed USB device using ehci_hcd and address 36
[  184.706295] usb 2-3: configuration #1 chosen from 1 choice
[  184.706941] scsi28 : SCSI emulation for USB Mass Storage devices
[  184.707761] usb-storage: device found at 36
[  184.707906] usb-storage: waiting for device to settle before scanning
[  185.148714] usb 2-3: USB disconnect, address 36
[  185.405447] usb 2-3: new high speed USB device using ehci_hcd and address 37
[  185.531664] usb 2-3: configuration #1 chosen from 1 choice
[  185.532368] scsi29 : SCSI emulation for USB Mass Storage devices
[  185.533193] usb-storage: device found at 37
[  185.533339] usb-storage: waiting for device to settle before scanning
[  185.934491] usb 2-3: USB disconnect, address 37
[  186.190758] usb 2-3: new high speed USB device using ehci_hcd and address 38
[  186.316228] usb 2-3: configuration #1 chosen from 1 choice
[  186.316939] scsi30 : SCSI emulation for USB Mass Storage devices
[  188.186831] usb-storage: device found at 38
[  188.186931] usb-storage: waiting for device to settle before scanning
[  189.195339] usb-storage: device scan complete
[  189.196003] scsi 30:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
[  188.524182] sd 30:0:0:0: [sdc] 31194450 512-byte hardware sectors (15972 MB)
[  188.525055] sd 30:0:0:0: [sdc] Write Protect is off
[  188.525062] sd 30:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  188.525066] sd 30:0:0:0: [sdc] Assuming drive cache: write through
[  188.527548] sd 30:0:0:0: [sdc] 31194450 512-byte hardware sectors (15972 MB)
[  188.528451] sd 30:0:0:0: [sdc] Write Protect is off
[  188.528457] sd 30:0:0:0: [sdc] Mode Sense: 03 00 00 00
[  188.528461] sd 30:0:0:0: [sdc] Assuming drive cache: write through
[  188.528465]  sdc: sdc1
[  188.579003] sd 30:0:0:0: [sdc] Attached SCSI removable disk
[  188.579330] sd 30:0:0:0: Attached scsi generic sg2 type 0
[  191.433584] usb 2-3: USB disconnect, address 38
[  193.557629] usb 2-3: new high speed USB device using ehci_hcd and address 39
[  191.813558] usb 2-3: configuration #1 chosen from 1 choice
[  193.683997] scsi31 : SCSI emulation for USB Mass Storage devices
[  193.684946] usb-storage: device found at 39
[  193.685143] usb-storage: waiting for device to settle before scanning
[  192.160978] usb 2-3: USB disconnect, address 39
[  194.346286] usb 2-3: new high speed USB device using ehci_hcd and address 40
[  192.602680] usb 2-3: configuration #1 chosen from 1 choice
[  192.603060] scsi32 : SCSI emulation for USB Mass Storage devices
[  192.603512] usb-storage: device found at 40
[  192.603522] usb-storage: waiting for device to settle before scanning
[  194.911396] usb 2-3: USB disconnect, address 40
[  193.298706] usb 2-3: new high speed USB device using ehci_hcd and address 41
[  193.424793] usb 2-3: configuration #1 chosen from 1 choice
[  195.294783] scsi33 : SCSI emulation for USB Mass Storage devices
[  195.295270] usb-storage: device found at 41
[  195.295482] usb-storage: waiting for device to settle before scanning
[  196.293163] usb-storage: device scan complete
[  196.294133] scsi 33:0:0:0: Direct-Access     Multi    Flash Reader     1.00 PQ: 0 ANSI: 0
[  197.348120] usb 2-3: USB disconnect, address 41
[  195.479262] make_class_name: name=c02f68ad kname=00000000
[  195.479293] ------------[ cut here ]------------
[  195.479298] kernel BUG at drivers/base/class.c:367!
[  195.479303] invalid opcode: 0000 [#1]
[  195.479306] PREEMPT SMP 
[  195.479311] Modules linked in: nls_iso8859_1 nls_cp437 vfat fat usb_storage libusual microcode binfmt_misc rfcomm l2cap bluetooth nfs nfsd exportfs lockd nfs_acl auth_rpcgss sunrpc acpi_cpufreq cpufreq_stats cpufreq_userspace cpufreq_ondemand freq_table cpufreq_powersave container fan firmware_class pciehp usbhid pci_hotplug hid visor af_packet usbserial fuse firewire_sbp2 mousedev snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq snd_timer serio_raw snd_seq_device firewire_ohci firewire_core thermal ac battery sdhci mmc_core pcspkr sg psmouse crc_itu_t ehci_hcd intel_agp agpgart uhci_hcd b44 mii snd soundcore sr_mod cdrom button processor usbcore snd_page_alloc unix
[  195.479455] CPU:    0
[  195.479456] EIP:    0060:[make_class_name+41/122]    Not tainted VLI
[  195.479458] EFLAGS: 00010282   (2.6.23.8 #9)
[  195.479468] EIP is at make_class_name+0x29/0x7a
[  195.479473] eax: 00000040   ebx: f5db3dfc   ecx: c031ce3c   edx: 00000002
[  195.479478] esi: 00000000   edi: c02f68ad   ebp: f5db3e04   esp: f7013e50
[  195.479483] ds: 007b   es: 007b   fs: 00d8  gs: 0000  ss: 0068
[  195.479489] Process khubd (pid: 1878, ti=f7013000 task=f7113550 task.ti=f7013000)
[  195.479493] Stack: c02ef264 c02f68ad 00000000 f5db3dfc c03297f4 c0329780 f5db3e04 c020ee88 
[  195.479509]        00000000 f5db3dfc f5db3c98 00000202 f6601c00 c020ef1c f5db3c00 c021ab67 
[  195.479526]        f5db3c00 f5977000 c02186b0 f5977038 f5977000 c02139e0 f59772ec f5977000 
[  195.479541] Call Trace:
[  195.479552]  [class_device_del+131/271] class_device_del+0x83/0x10f
[  195.479565]  [class_device_unregister+8/16] class_device_unregister+0x8/0x10
[  195.479574]  [__scsi_remove_device+43/104] __scsi_remove_device+0x2b/0x68
[  195.479584]  [scsi_forget_host+45/74] scsi_forget_host+0x2d/0x4a
[  195.479595]  [scsi_remove_host+101/213] scsi_remove_host+0x65/0xd5
[  195.479608]  [<f8bd7691>] quiesce_and_remove_host+0x99/0xa7 [usb_storage]
[  195.479626]  [<f8bd7763>] storage_disconnect+0xe/0x16 [usb_storage]
[  195.479642]  [<f885aa50>] usb_unbind_interface+0x44/0x94 [usbcore]
[  195.479680]  [__device_release_driver+113/142] __device_release_driver+0x71/0x8e
[  195.479690]  [device_release_driver+30/52] device_release_driver+0x1e/0x34
[  195.479699]  [bus_remove_device+109/125] bus_remove_device+0x6d/0x7d
[  195.479708]  [device_del+460/576] device_del+0x1cc/0x240
[  195.479720]  [<f88583f9>] usb_disable_device+0x5c/0xbb [usbcore]
[  195.479755]  [<f8854aff>] usb_disconnect+0x83/0x11b [usbcore]
[  195.479793]  [<f885520d>] hub_thread+0x388/0xa8d [usbcore]
[  195.479831]  [schedule+1359/1463] __sched_text_start+0x54f/0x5b7
[  195.479849]  [autoremove_wake_function+0/53] autoremove_wake_function+0x0/0x35
[  195.479863]  [<f8854e85>] hub_thread+0x0/0xa8d [usbcore]
[  195.479894]  [kthread+56/95] kthread+0x38/0x5f
[  195.479902]  [kthread+0/95] kthread+0x0/0x5f
[  195.479910]  [kernel_thread_helper+7/16] kernel_thread_helper+0x7/0x10
[  195.479922]  =======================
[  195.479925] Code: 5b c3 55 89 d5 57 89 c7 56 53 83 ec 0c 8b 32 85 f6 74 04 85 c0 75 18 89 74 24 08 89 7c 24 04 c7 04 24 64 f2 2e c0 e8 34 1f f1 ff <0f> 0b eb fe e8 c4 10 fb ff 89 c3 89 f0 e8 bb 10 fb ff ba d0 00 
[  195.480006] EIP: [make_class_name+41/122] make_class_name+0x29/0x7a SS:ESP 0068:f7013e50
[  195.480094] sd 33:0:0:0: [sdc] READ CAPACITY failed
[  195.480099] sd 33:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  195.480108] sd 33:0:0:0: [sdc] Sense not available.
[  195.480124] sd 33:0:0:0: [sdc] Write Protect is off
[  195.480129] sd 33:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  195.480134] sd 33:0:0:0: [sdc] Assuming drive cache: write through
[  195.480206] sd 33:0:0:0: [sdc] Attached SCSI removable disk
[  195.480272] sd 33:0:0:0: Attached scsi generic sg2 type 0
[  197.405084] sd 33:0:0:0: [sdc] READ CAPACITY failed
[  197.405093] sd 33:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  197.405100] sd 33:0:0:0: [sdc] Sense not available.
[  197.405116] sd 33:0:0:0: [sdc] Write Protect is off
[  197.405121] sd 33:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  197.405125] sd 33:0:0:0: [sdc] Assuming drive cache: write through
[  197.406419] sd 33:0:0:0: [sdc] READ CAPACITY failed
[  197.406425] sd 33:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  197.406432] sd 33:0:0:0: [sdc] Sense not available.
[  197.406449] sd 33:0:0:0: [sdc] Write Protect is off
[  197.406454] sd 33:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  197.406458] sd 33:0:0:0: [sdc] Assuming drive cache: write through
[  197.409389] sd 33:0:0:0: [sdc] READ CAPACITY failed
[  197.409614] sd 33:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  197.409931] sd 33:0:0:0: [sdc] Sense not available.
[  197.410151] sd 33:0:0:0: [sdc] Write Protect is off
[  197.410359] sd 33:0:0:0: [sdc] Mode Sense: 00 00 00 00
[  197.410570] sd 33:0:0:0: [sdc] Assuming drive cache: write through
[  195.541321] sd 33:0:0:0: [sdc] READ CAPACITY failed
[  195.541328] sd 33:0:0:0: [sdc] Result: hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK,SUGGEST_OK
[  195.541336] sd 33:0:0:0: [sdc] Sense not available.
