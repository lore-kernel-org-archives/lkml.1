Return-Path: <linux-kernel-owner+w=401wt.eu-S1752719AbZL2JfA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719AbZL2JfA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 04:35:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752624AbZL2Je7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 04:34:59 -0500
Received: from gate.crashing.org ([63.228.1.57]:58188 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbZL2Je6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 04:34:58 -0500
Subject: Re: i2c_powermac: Kernel access of bad area
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Christian Kujau <lists@nerdbynature.de>
Cc: linuxppc-dev@ozlabs.org, khali@linux-fr.org,
       LKML <linux-kernel@vger.kernel.org>, Jean Delvare <khali@linux-fr.org>
In-Reply-To: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de>
References: <alpine.DEB.2.01.0912281934170.3483@bogon.housecafe.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 29 Dec 2009 20:34:15 +1100
Message-ID: <1262079255.2173.216.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-12-28 at 20:40 -0800, Christian Kujau wrote:
> Hi there,
> 
> I was trying to find out if I still need i2c_powermac to get details off 
> /sys/devices/temperatures, since lm-sensors isn't working for me anyway.
> 
> After unloading this module, I noticed that reading certain objects would 
> fail with a segfault on the prompt and an Oops in the kernel log:

Definitely looks like we fail to clean things up on remove.

I don't have much time to look into this right now, so best is you file
a bug report on bugzilla.kernel.org, make sure I'm CCed.

Jean (added on CC), in case you already know what's up, please share :-)

Cheers,
Ben.

> # rmmod i2c_powermac
> # ls  /sys/devices/temperatures
> devspec    modalias  sensor1_fan_speed  sensor1_location     
> sensor2_limit     sensor2_temperature  subsystem
> limit_adjust  name      sensor1_limit      sensor1_temperature  
> sensor2_location  specified_fan_speed  uevent
> # cat /sys/devices/temperatures/sensor1_location
> CPU TOPSIDE
> # cat /sys/devices/temperatures/sensor1_fan_speed
> Segmentation fault
> 
> I've put the full dmesg and the .config on:
> http://nerdbynature.de/bits/2.6.33-rc2/i2c_powermac/
> 
> When the module is loaded, all is fine and I can successfully read all the 
> files in /sys/devices/temperatures. I just wanted to report this anyway, 
> as it seems a bit harsh to just oops when a friendly -EINVAL would be more
> useful, IMHO.
> 
> Thanks,
> Christian.
> 
> [264783.907602] adt746x: Putting max temperatures back from 67, 47, 67 to 73, 80, 109
> [264783.912552] ams: Unloading
> [264785.759586] Unable to handle kernel paging request for data at address 0x00000010
> [264785.759981] Faulting instruction address: 0xf6612a28
> [264785.760322] Oops: Kernel access of bad area, sig: 11 [#1]
> [264785.760662] PowerMac
> [264785.760991] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264785.762753] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264785.763109] REGS: e6419de0 TRAP: 0300   Not tainted  (2.6.33-rc2)
> [264785.763459] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264785.763858] DAR: 00000010, DSISR: 40000000
> [264785.764205] TASK = ee904000[29122] 'cat' THREAD: e6418000
> [264785.764241] GPR00: c021d540 e6419e90 ee904000 efb8bf10 00000028 ee5a0000 c1305420 c1305420 
> [264785.764668] GPR08: efbc9964 f6610000 00000000 00000000 28000242 1001cb7c 100042bc bf8832f4 
> [264785.765100] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8831d8 c03e2678 
> [264785.765542] GPR24: 101e6000 00001000 efb8bf18 ee3ce0d8 e6419f20 ee5a0000 f66135d8 fffffffb 
> [264785.766349] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264785.766751] LR [c021d540] dev_attr_show+0x30/0x7c
> [264785.767136] Call Trace:
> [264785.767516] [e6419e90] [00001000] 0x1000 (unreliable)
> [264785.767925] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264785.768341] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264785.768757] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264785.769174] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264785.769605] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264785.770038] --- Exception: c01 at 0xff50fb0
> [264785.770042]     LR = 0x100031f0
> [264785.770877] Instruction dump:
> [264785.771304] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264785.771812] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264785.778656] ---[ end trace cecbd2fe1c8fe255 ]---
> [264785.786061] Unable to handle kernel paging request for data at address 0x00000000
> [264785.786641] Faulting instruction address: 0xf661207c
> [264785.787129] Oops: Kernel access of bad area, sig: 11 [#2]
> [264785.787617] PowerMac
> [264785.788093] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264785.790644] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264785.791178] REGS: e6419dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264785.791726] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264785.792349] DAR: 00000000, DSISR: 40000000
> [264785.792898] TASK = ee904000[29124] 'cat' THREAD: e6418000
> [264785.793018] GPR00: f6612c10 e6419e70 ee904000 00000000 00000025 00000001 c0e32920 c0e32920 
> [264785.794762] GPR08: efbc97e4 e6419e78 00000000 00000000 28000242 1001cb7c 100042bc bf8832f4 
> [264785.795913] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8831d8 c03e2678 
> [264785.797498] GPR24: 105f7000 00001000 efb8bf18 ee3ce0d8 e6419f20 c7c48000 f6613538 00000000 
> [264785.799657] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264785.800593] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264785.801474] Call Trace:
> [264785.802018] [e6419e70] [00001000] 0x1000 (unreliable)
> [264785.802961] [e6419e90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264785.803875] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264785.804985] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264785.806054] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264785.807187] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264785.808249] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264785.809290] --- Exception: c01 at 0xff50fb0
> [264785.809293]     LR = 0x100031f0
> [264785.811240] Instruction dump:
> [264785.812156] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264785.813567] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264785.814966] ---[ end trace cecbd2fe1c8fe256 ]---
> [264785.835554] Unable to handle kernel paging request for data at address 0x0000000e
> [264785.836153] Faulting instruction address: 0xf6612b88
> [264785.836695] Oops: Kernel access of bad area, sig: 11 [#3]
> [264785.837229] PowerMac
> [264785.837750] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264785.840442] NIP: f6612b88 LR: c021d540 CTR: f6612b68
> [264785.841164] REGS: e6419df0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264785.841732] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264785.842595] DAR: 0000000e, DSISR: 40000000
> [264785.843437] TASK = ee904000[29126] 'cat' THREAD: e6418000
> [264785.843743] GPR00: c021d540 e6419ea0 ee904000 c5cd2000 f6613280 c5cd2000 c0df3a60 c0df3a60 
> [264785.845338] GPR08: efbc9844 f6610000 00000000 00000000 28000242 1001cb7c 100042bc bf8832f4 
> [264785.846534] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8831d8 c03e2678 
> [264785.848204] GPR24: 107c1000 00001000 efb8bf18 ee3cee18 e6419f20 efbc9840 f6613560 fffffffb 
> [264785.850328] NIP [f6612b88] show_sensor1_limit+0x20/0x38 [therm_adt746x]
> [264785.851289] LR [c021d540] dev_attr_show+0x30/0x7c
> [264785.852137] Call Trace:
> [264785.852688] [e6419ea0] [efbc9840] 0xefbc9840 (unreliable)
> [264785.853655] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264785.854570] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264785.855682] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264785.856787] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264785.857950] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264785.859020] --- Exception: c01 at 0xff50fb0
> [264785.859023]     LR = 0x100031f0
> [264785.861063] Instruction dump:
> [264785.861984] 80010014 38210010 7c0803a6 4e800020 9421fff0 7c0802a6 3d20f661 7ca32b78 
> [264785.863367] 3c80f661 38843280 90010014 816937d4 <88ab000e> 480002fd 80010014 38210010 
> [264785.864865] ---[ end trace cecbd2fe1c8fe257 ]---
> [264785.883885] Unable to handle kernel paging request for data at address 0x00000000
> [264785.884488] Faulting instruction address: 0xf661207c
> [264785.885033] Oops: Kernel access of bad area, sig: 11 [#4]
> [264785.885575] PowerMac
> [264785.886100] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264785.888790] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264785.889559] REGS: e6419dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264785.890124] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264785.890966] DAR: 00000000, DSISR: 40000000
> [264785.891812] TASK = ee904000[29130] 'cat' THREAD: e6418000
> [264785.892058] GPR00: f6612bc4 e6419e70 ee904000 00000000 00000027 00000001 c1306cc0 c1306cc0 
> [264785.893717] GPR08: efbc9814 e6419e78 00000000 00000000 28000242 1001cb7c 100042bc bf8832f4 
> [264785.894901] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8831d8 c03e2678 
> [264785.896524] GPR24: 100be000 00001000 efb8bf18 ee3cee18 e6419f20 ee665000 f661354c 00000000 
> [264785.898697] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264785.899636] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264785.900534] Call Trace:
> [264785.901094] [e6419e70] [00001000] 0x1000 (unreliable)
> [264785.902034] [e6419e90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264785.902975] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264785.904109] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264785.905228] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264785.906369] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264785.907432] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264785.908483] --- Exception: c01 at 0xff50fb0
> [264785.908486]     LR = 0x100031f0
> [264785.910549] Instruction dump:
> [264785.911494] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264785.912856] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264785.914313] ---[ end trace cecbd2fe1c8fe258 ]---
> [264785.928529] Unable to handle kernel paging request for data at address 0x0000000f
> [264785.929128] Faulting instruction address: 0xf6612b50
> [264785.929676] Oops: Kernel access of bad area, sig: 11 [#5]
> [264785.930217] PowerMac
> [264785.930742] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264785.933452] NIP: f6612b50 LR: c021d540 CTR: f6612b30
> [264785.934256] REGS: e6419df0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264785.934831] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264785.935696] DAR: 0000000f, DSISR: 40000000
> [264785.936602] TASK = ee904000[29132] 'cat' THREAD: e6418000
> [264785.936849] GPR00: c021d540 e6419ea0 ee904000 e6483000 f6613280 e6483000 c1203080 c1203080 
> [264785.938462] GPR08: efbc9874 f6610000 00000000 00000000 28000242 1001cb7c 100042bc bf8832f4 
> [264785.939672] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8831d8 c03e2678 
> [264785.941326] GPR24: 10160000 00001000 efb8bf18 ee3cee18 e6419f20 efbc9870 f6613574 fffffffb 
> [264785.943491] NIP [f6612b50] show_sensor2_limit+0x20/0x38 [therm_adt746x]
> [264785.944462] LR [c021d540] dev_attr_show+0x30/0x7c
> [264785.945308] Call Trace:
> [264785.945859] [e6419ea0] [efbc9870] 0xefbc9870 (unreliable)
> [264785.946830] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264785.947735] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264785.948858] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264785.949984] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264785.951153] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264785.952223] --- Exception: c01 at 0xff50fb0
> [264785.952226]     LR = 0x100031f0
> [264785.954270] Instruction dump:
> [264785.955215] 80010014 38210010 7c0803a6 4e800020 9421fff0 7c0802a6 3d20f661 7ca32b78 
> [264785.956589] 3c80f661 38843280 90010014 816937d4 <88ab000f> 48000335 80010014 38210010 
> [264785.958432] ---[ end trace cecbd2fe1c8fe259 ]---
> [264786.652217] Unable to handle kernel paging request for data at address 0x00000000
> [264786.652825] Faulting instruction address: 0xf661207c
> [264786.653372] Oops: Kernel access of bad area, sig: 11 [#6]
> [264786.653914] PowerMac
> [264786.654441] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264786.657133] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264786.657932] REGS: efbcfdc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264786.658498] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264786.659357] DAR: 00000000, DSISR: 40000000
> [264786.660220] TASK = ee95b580[29137] 'cat' THREAD: efbce000
> [264786.660471] GPR00: f6612c10 efbcfe70 ee95b580 00000000 00000025 00000001 c1205780 c1205780 
> [264786.662108] GPR08: efbc97e4 efbcfe78 00000001 00000001 28000242 1001cb7c 100042bc bfd5f024 
> [264786.663301] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bfd5ef08 c03e2678 
> [264786.664941] GPR24: 103f5000 00001000 efb8bf18 ee3cee18 efbcff20 e65bb000 f6613538 00000000 
> [264786.667099] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264786.668046] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264786.668942] Call Trace:
> [264786.669494] [efbcfe70] [00001000] 0x1000 (unreliable)
> [264786.670446] [efbcfe90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264786.671389] [efbcfeb0] [c021d540] dev_attr_show+0x30/0x7c
> [264786.672524] [efbcfec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264786.673642] [efbcfef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264786.674782] [efbcff10] [c00983d4] sys_read+0x4c/0xa4
> [264786.675868] [efbcff40] [c0012c44] ret_from_syscall+0x0/0x38
> [264786.676923] --- Exception: c01 at 0xff50fb0
> [264786.676926]     LR = 0x100031f0
> [264786.678974] Instruction dump:
> [264786.679888] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264786.681270] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264786.682682] ---[ end trace cecbd2fe1c8fe25a ]---
> [264786.702044] Unable to handle kernel paging request for data at address 0x00000010
> [264786.702686] Faulting instruction address: 0xf6612a28
> [264786.703233] Oops: Kernel access of bad area, sig: 11 [#7]
> [264786.703772] PowerMac
> [264786.704297] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264786.706989] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264786.707736] REGS: e6451de0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264786.708304] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000428  XER: 00000000
> [264786.709155] DAR: 00000010, DSISR: 40000000
> [264786.710026] TASK = e641e820[29141] 'sed' THREAD: e6450000
> [264786.710276] GPR00: c021d540 e6451e90 e641e820 efb8bf10 00000028 e67bc000 c12097a0 c12097a0 
> [264786.711916] GPR08: efbc9964 f6610000 00000001 00000000 28000422 1002357c 1000ad18 1001b664 
> [264786.713113] GPR16: 1001b6a0 10020000 bf9baeb8 10020000 10328850 10020000 10020000 c03e2678 
> [264786.714723] GPR24: 48020000 00001000 efb8bf18 ee3cee18 e6451f20 e67bc000 f66135d8 fffffffb 
> [264786.716890] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264786.717849] LR [c021d540] dev_attr_show+0x30/0x7c
> [264786.718689] Call Trace:
> [264786.719239] [e6451e90] [00001000] 0x1000 (unreliable)
> [264786.720205] [e6451eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264786.721103] [e6451ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264786.722215] [e6451ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264786.723335] [e6451f10] [c00983d4] sys_read+0x4c/0xa4
> [264786.724495] [e6451f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264786.725561] --- Exception: c01 at 0xff50fb0
> [264786.725564]     LR = 0xfef52a0
> [264786.727613] Instruction dump:
> [264786.728545] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264786.729920] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264786.731357] ---[ end trace cecbd2fe1c8fe25b ]---
> [264786.742044] Unable to handle kernel paging request for data at address 0x00000000
> [264786.742676] Faulting instruction address: 0xf661207c
> [264786.743221] Oops: Kernel access of bad area, sig: 11 [#8]
> [264786.743761] PowerMac
> [264786.744282] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264786.746956] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264786.747663] REGS: e6419dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264786.748226] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264786.749085] DAR: 00000000, DSISR: 40000000
> [264786.749893] TASK = e641dac0[29142] 'cat' THREAD: e6418000
> [264786.750121] GPR00: f6612bc4 e6419e70 e641dac0 00000000 00000027 00000001 c12097a0 c12097a0 
> [264786.751797] GPR08: efbc9814 e6419e78 00000001 00000001 28000242 1001cb7c 100042bc bfd5f024 
> [264786.752975] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bfd5ef08 c03e2678 
> [264786.754573] GPR24: 102b4000 00001000 efb8bf18 ee3cea58 e6419f20 e67bc000 f661354c 00000000 
> [264786.756750] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264786.757679] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264786.758595] Call Trace:
> [264786.759163] [e6419e70] [00001000] 0x1000 (unreliable)
> [264786.760099] [e6419e90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264786.761028] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264786.762139] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264786.763249] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264786.764401] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264786.765474] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264786.766505] --- Exception: c01 at 0xff50fb0
> [264786.766508]     LR = 0x100031f0
> [264786.768540] Instruction dump:
> [264786.769465] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264786.770843] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264786.772293] ---[ end trace cecbd2fe1c8fe25c ]---
> [264791.652295] Unable to handle kernel paging request for data at address 0x00000000
> [264791.652896] Faulting instruction address: 0xf661207c
> [264791.653440] Oops: Kernel access of bad area, sig: 11 [#9]
> [264791.653982] PowerMac
> [264791.654509] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264791.657200] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264791.657980] REGS: ee667dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264791.658546] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264791.659403] DAR: 00000000, DSISR: 40000000
> [264791.660262] TASK = e641c6b0[29147] 'cat' THREAD: ee666000
> [264791.660505] GPR00: f6612c10 ee667e70 e641c6b0 00000000 00000025 00000001 c1203080 c1203080 
> [264791.662155] GPR08: efbc97e4 ee667e78 00000002 00000002 28000242 1001cb7c 100042bc bfcd53a4 
> [264791.663348] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bfcd5288 c03e2678 
> [264791.664981] GPR24: 10049000 00001000 efb8bf18 ca3faf98 ee667f20 e6483000 f6613538 00000000 
> [264791.667155] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264791.668110] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264791.669000] Call Trace:
> [264791.669558] [ee667e70] [00001000] 0x1000 (unreliable)
> [264791.670510] [ee667e90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264791.671449] [ee667eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264791.672590] [ee667ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264791.673726] [ee667ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264791.674857] [ee667f10] [c00983d4] sys_read+0x4c/0xa4
> [264791.675950] [ee667f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264791.677011] --- Exception: c01 at 0xff50fb0
> [264791.677014]     LR = 0x100031f0
> [264791.679078] Instruction dump:
> [264791.680036] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264791.681388] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264791.682988] ---[ end trace cecbd2fe1c8fe25d ]---
> [264791.702291] Unable to handle kernel paging request for data at address 0x00000010
> [264791.702902] Faulting instruction address: 0xf6612a28
> [264791.703454] Oops: Kernel access of bad area, sig: 11 [#10]
> [264791.703998] PowerMac
> [264791.704527] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264791.707235] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264791.708071] REGS: e6419de0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264791.708643] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000428  XER: 00000000
> [264791.709502] DAR: 00000010, DSISR: 40000000
> [264791.710424] TASK = ee6edac0[29151] 'sed' THREAD: e6418000
> [264791.710672] GPR00: c021d540 e6419e90 ee6edac0 efb8bf10 00000028 e655b000 c1204b80 c1204b80 
> [264791.712284] GPR08: efbc9964 f6610000 00000002 00000000 28000422 1002357c 1000ad18 1001b664 
> [264791.713489] GPR16: 1001b6a0 10020000 bfa88488 10020000 101f1850 10020000 10020000 c03e2678 
> [264791.715163] GPR24: 48020000 00001000 efb8bf18 ca3faf98 e6419f20 e655b000 f66135d8 fffffffb 
> [264791.717318] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264791.718302] LR [c021d540] dev_attr_show+0x30/0x7c
> [264791.719169] Call Trace:
> [264791.719725] [e6419e90] [00001000] 0x1000 (unreliable)
> [264791.720669] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264791.721590] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264791.722710] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264791.723847] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264791.725017] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264791.726095] --- Exception: c01 at 0xff50fb0
> [264791.726098]     LR = 0xfef52a0
> [264791.728154] Instruction dump:
> [264791.729121] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264791.730479] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264791.731935] ---[ end trace cecbd2fe1c8fe25e ]---
> [264791.742748] Unable to handle kernel paging request for data at address 0x00000000
> [264791.743343] Faulting instruction address: 0xf661207c
> [264791.743889] Oops: Kernel access of bad area, sig: 11 [#11]
> [264791.744432] PowerMac
> [264791.744956] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264791.747646] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264791.748433] REGS: ef0a5dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264791.748998] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264791.749854] DAR: 00000000, DSISR: 40000000
> [264791.750734] TASK = ee6ee170[29152] 'cat' THREAD: ef0a4000
> [264791.750975] GPR00: f6612bc4 ef0a5e70 ee6ee170 00000000 00000027 00000001 c1203080 c1203080 
> [264791.752595] GPR08: efbc9814 ef0a5e78 00000002 00000002 28000242 1001cb7c 100042bc bfcd53a4 
> [264791.753756] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bfcd5288 c03e2678 
> [264791.755378] GPR24: 101ed000 00001000 efb8bf18 ca3fa158 ef0a5f20 e6483000 f661354c 00000000 
> [264791.757556] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264791.758491] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264791.759389] Call Trace:
> [264791.759938] [ef0a5e70] [00001000] 0x1000 (unreliable)
> [264791.760892] [ef0a5e90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264791.761846] [ef0a5eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264791.762980] [ef0a5ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264791.764102] [ef0a5ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264791.765239] [ef0a5f10] [c00983d4] sys_read+0x4c/0xa4
> [264791.766315] [ef0a5f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264791.767339] --- Exception: c01 at 0xff50fb0
> [264791.767342]     LR = 0x100031f0
> [264791.769382] Instruction dump:
> [264791.770286] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264791.771664] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264791.773071] ---[ end trace cecbd2fe1c8fe25f ]---
> [264796.652268] Unable to handle kernel paging request for data at address 0x00000000
> [264796.652871] Faulting instruction address: 0xf661207c
> [264796.653418] Oops: Kernel access of bad area, sig: 11 [#12]
> [264796.653958] PowerMac
> [264796.654486] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264796.657186] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264796.657943] REGS: ee667dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264796.658510] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264796.659371] DAR: 00000000, DSISR: 40000000
> [264796.660225] TASK = eea246b0[29158] 'cat' THREAD: ee666000
> [264796.660470] GPR00: f6612c10 ee667e70 eea246b0 00000000 00000025 00000001 c0df4300 c0df4300 
> [264796.662124] GPR08: efbc97e4 ee667e78 00000003 00000003 28000242 1001cb7c 100042bc bf8d7434 
> [264796.663311] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8d7318 c03e2678 
> [264796.664911] GPR24: 101fc000 00001000 efb8bf18 e1eb5f98 ee667f20 c5d17000 f6613538 00000000 
> [264796.667097] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264796.668027] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264796.668904] Call Trace:
> [264796.669455] [ee667e70] [00001000] 0x1000 (unreliable)
> [264796.670404] [ee667e90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264796.671339] [ee667eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264796.672463] [ee667ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264796.673538] [ee667ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264796.674686] [ee667f10] [c00983d4] sys_read+0x4c/0xa4
> [264796.675755] [ee667f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264796.676792] --- Exception: c01 at 0xff50fb0
> [264796.676795]     LR = 0x100031f0
> [264796.678830] Instruction dump:
> [264796.679725] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264796.681119] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264796.682641] ---[ end trace cecbd2fe1c8fe260 ]---
> [264796.702183] Unable to handle kernel paging request for data at address 0x00000010
> [264796.702828] Faulting instruction address: 0xf6612a28
> [264796.703376] Oops: Kernel access of bad area, sig: 11 [#13]
> [264796.703915] PowerMac
> [264796.704437] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264796.707118] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264796.707836] REGS: e6451de0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264796.708402] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000428  XER: 00000000
> [264796.709259] DAR: 00000010, DSISR: 40000000
> [264796.710086] TASK = c0986ed0[29162] 'sed' THREAD: e6450000
> [264796.710338] GPR00: c021d540 e6451e90 c0986ed0 efb8bf10 00000028 ef06a000 c131ad60 c131ad60 
> [264796.712003] GPR08: efbc9964 f6610000 00000003 00000000 28000422 1002357c 1000ad18 1001b664 
> [264796.713189] GPR16: 1001b6a0 10020000 bf9e44e8 10020000 107d0850 10020000 10020000 c03e2678 
> [264796.714772] GPR24: 48020000 00001000 efb8bf18 e1eb5f98 e6451f20 ef06a000 f66135d8 fffffffb 
> [264796.716960] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264796.717915] LR [c021d540] dev_attr_show+0x30/0x7c
> [264796.718759] Call Trace:
> [264796.719312] [e6451e90] [00001000] 0x1000 (unreliable)
> [264796.720282] [e6451eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264796.721193] [e6451ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264796.722305] [e6451ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264796.723426] [e6451f10] [c00983d4] sys_read+0x4c/0xa4
> [264796.724575] [e6451f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264796.725647] --- Exception: c01 at 0xff50fb0
> [264796.725650]     LR = 0xfef52a0
> [264796.727701] Instruction dump:
> [264796.728643] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264796.730011] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264796.731451] ---[ end trace cecbd2fe1c8fe261 ]---
> [264796.742134] Unable to handle kernel paging request for data at address 0x00000000
> [264796.742768] Faulting instruction address: 0xf661207c
> [264796.743313] Oops: Kernel access of bad area, sig: 11 [#14]
> [264796.743854] PowerMac
> [264796.744378] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264796.747061] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264796.747807] REGS: e6419dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264796.748371] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264796.749224] DAR: 00000000, DSISR: 40000000
> [264796.750080] TASK = c0987580[29163] 'cat' THREAD: e6418000
> [264796.750326] GPR00: f6612bc4 e6419e70 c0987580 00000000 00000027 00000001 c131ad60 c131ad60 
> [264796.751957] GPR08: efbc9814 e6419e78 00000003 00000003 28000242 1001cb7c 100042bc bf8d7434 
> [264796.753145] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bf8d7318 c03e2678 
> [264796.754762] GPR24: 10583000 00001000 efb8bf18 e1eb5298 e6419f20 ef06a000 f661354c 00000000 
> [264796.756944] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264796.757870] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264796.758763] Call Trace:
> [264796.759312] [e6419e70] [00001000] 0x1000 (unreliable)
> [264796.760263] [e6419e90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264796.761197] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264796.762327] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264796.763434] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264796.764588] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264796.765652] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264796.766704] --- Exception: c01 at 0xff50fb0
> [264796.766707]     LR = 0x100031f0
> [264796.768725] Instruction dump:
> [264796.769624] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264796.771015] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264796.772468] ---[ end trace cecbd2fe1c8fe262 ]---
> [264801.652809] Unable to handle kernel paging request for data at address 0x00000000
> [264801.653407] Faulting instruction address: 0xf661207c
> [264801.653947] Oops: Kernel access of bad area, sig: 11 [#15]
> [264801.654485] PowerMac
> [264801.655007] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264801.657691] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264801.658447] REGS: ee667dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264801.659011] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264801.659859] DAR: 00000000, DSISR: 40000000
> [264801.660669] TASK = efb95ac0[29169] 'cat' THREAD: ee666000
> [264801.660914] GPR00: f6612c10 ee667e70 efb95ac0 00000000 00000025 00000001 c1205080 c1205080 
> [264801.662577] GPR08: efbc97e4 ee667e78 00000004 00000004 28000242 1001cb7c 100042bc bfd1ef94 
> [264801.663763] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bfd1ee78 c03e2678 
> [264801.665349] GPR24: 104d3000 00001000 efb8bf18 ca3fadd8 ee667f20 e6583000 f6613538 00000000 
> [264801.667546] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264801.668470] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264801.669343] Call Trace:
> [264801.669892] [ee667e70] [00001000] 0x1000 (unreliable)
> [264801.670845] [ee667e90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264801.671775] [ee667eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264801.672908] [ee667ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264801.673991] [ee667ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264801.675146] [ee667f10] [c00983d4] sys_read+0x4c/0xa4
> [264801.676226] [ee667f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264801.677257] --- Exception: c01 at 0xff50fb0
> [264801.677260]     LR = 0x100031f0
> [264801.679294] Instruction dump:
> [264801.680207] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264801.681593] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264801.683107] ---[ end trace cecbd2fe1c8fe263 ]---
> [264801.704383] Unable to handle kernel paging request for data at address 0x00000010
> [264801.704991] Faulting instruction address: 0xf6612a28
> [264801.705542] Oops: Kernel access of bad area, sig: 11 [#16]
> [264801.706083] PowerMac
> [264801.706610] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264801.709309] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264801.710128] REGS: efbcfde0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264801.710698] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000428  XER: 00000000
> [264801.711539] DAR: 00000010, DSISR: 40000000
> [264801.712429] TASK = efb96ed0[29173] 'sed' THREAD: efbce000
> [264801.712677] GPR00: c021d540 efbcfe90 efb96ed0 efb8bf10 00000028 c5cd2000 c0df3a60 c0df3a60 
> [264801.714308] GPR08: efbc9964 f6610000 00000004 00000000 28000422 1002357c 1000ad18 1001b664 
> [264801.715509] GPR16: 1001b6a0 10020000 bfb5b458 10020000 10703850 10020000 10020000 c03e2678 
> [264801.717131] GPR24: 48020000 00001000 efb8bf18 ca3fadd8 efbcff20 c5cd2000 f66135d8 fffffffb 
> [264801.719315] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264801.720284] LR [c021d540] dev_attr_show+0x30/0x7c
> [264801.721129] Call Trace:
> [264801.721677] [efbcfe90] [00001000] 0x1000 (unreliable)
> [264801.722633] [efbcfeb0] [c021d540] dev_attr_show+0x30/0x7c
> [264801.723542] [efbcfec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264801.724640] [efbcfef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264801.725758] [efbcff10] [c00983d4] sys_read+0x4c/0xa4
> [264801.726910] [efbcff40] [c0012c44] ret_from_syscall+0x0/0x38
> [264801.727963] --- Exception: c01 at 0xff50fb0
> [264801.727966]     LR = 0xfef52a0
> [264801.730007] Instruction dump:
> [264801.730947] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264801.732315] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264801.734013] ---[ end trace cecbd2fe1c8fe264 ]---
> [264801.744682] Unable to handle kernel paging request for data at address 0x00000000
> [264801.745283] Faulting instruction address: 0xf661207c
> [264801.745829] Oops: Kernel access of bad area, sig: 11 [#17]
> [264801.746372] PowerMac
> [264801.746897] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264801.749588] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264801.750385] REGS: e6451dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264801.750951] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264801.751810] DAR: 00000000, DSISR: 40000000
> [264801.752664] TASK = efb96170[29174] 'cat' THREAD: e6450000
> [264801.752910] GPR00: f6612bc4 e6451e70 efb96170 00000000 00000027 00000001 c0df3a60 c0df3a60 
> [264801.754558] GPR08: efbc9814 e6451e78 00000004 00000004 28000242 1001cb7c 100042bc bfd1ef94 
> [264801.755743] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bfd1ee78 c03e2678 
> [264801.757396] GPR24: 10534000 00001000 efb8bf18 ca3fa598 e6451f20 c5cd2000 f661354c 00000000 
> [264801.759555] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264801.760499] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264801.761395] Call Trace:
> [264801.762032] [e6451e70] [00001000] 0x1000 (unreliable)
> [264801.762934] [e6451e90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264801.763879] [e6451eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264801.765017] [e6451ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264801.766117] [e6451ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264801.767256] [e6451f10] [c00983d4] sys_read+0x4c/0xa4
> [264801.768340] [e6451f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264801.769402] --- Exception: c01 at 0xff50fb0
> [264801.769405]     LR = 0x100031f0
> [264801.771465] Instruction dump:
> [264801.772436] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264801.773783] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264801.775354] ---[ end trace cecbd2fe1c8fe265 ]---
> [264806.652424] Unable to handle kernel paging request for data at address 0x00000000
> [264806.653030] Faulting instruction address: 0xf661207c
> [264806.653580] Oops: Kernel access of bad area, sig: 11 [#18]
> [264806.654125] PowerMac
> [264806.654657] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264806.657366] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264806.658193] REGS: e6451dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264806.658763] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264806.659625] DAR: 00000000, DSISR: 40000000
> [264806.660546] TASK = efb95ac0[29178] 'cat' THREAD: e6450000
> [264806.660795] GPR00: f6612c10 e6451e70 efb95ac0 00000000 00000025 00000001 c12025e0 c12025e0 
> [264806.662407] GPR08: efbc97e4 e6451e78 00000005 00000005 28000242 1001cb7c 100042bc bff0cec4 
> [264806.663613] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bff0cda8 c03e2678 
> [264806.665248] GPR24: 10475000 00001000 efb8bf18 ca3fa598 e6451f20 e642e000 f6613538 00000000 
> [264806.667423] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264806.668382] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264806.669274] Call Trace:
> [264806.669851] [e6451e70] [00001000] 0x1000 (unreliable)
> [264806.670795] [e6451e90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264806.671746] [e6451eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264806.672894] [e6451ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264806.674028] [e6451ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264806.675162] [e6451f10] [c00983d4] sys_read+0x4c/0xa4
> [264806.676247] [e6451f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264806.677300] --- Exception: c01 at 0xff50fb0
> [264806.677303]     LR = 0x100031f0
> [264806.679366] Instruction dump:
> [264806.680301] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264806.681658] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264806.683113] ---[ end trace cecbd2fe1c8fe266 ]---
> [264806.704242] Unable to handle kernel paging request for data at address 0x00000010
> [264806.704850] Faulting instruction address: 0xf6612a28
> [264806.705399] Oops: Kernel access of bad area, sig: 11 [#19]
> [264806.705939] PowerMac
> [264806.706464] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264806.709160] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264806.709982] REGS: ee667de0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264806.710551] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000428  XER: 00000000
> [264806.711406] DAR: 00000010, DSISR: 40000000
> [264806.712317] TASK = ee904000[29182] 'sed' THREAD: ee666000
> [264806.712559] GPR00: c021d540 ee667e90 ee904000 efb8bf10 00000028 c7cd7000 c0e33b00 c0e33b00 
> [264806.714156] GPR08: efbc9964 f6610000 00000005 00000000 28000422 1002357c 1000ad18 1001b664 
> [264806.715338] GPR16: 1001b6a0 10020000 bfa28c08 10020000 1025e850 10020000 10020000 c03e2678 
> [264806.716970] GPR24: 48020000 00001000 efb8bf18 ca3fa598 ee667f20 c7cd7000 f66135d8 fffffffb 
> [264806.719154] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264806.720135] LR [c021d540] dev_attr_show+0x30/0x7c
> [264806.721000] Call Trace:
> [264806.721571] [ee667e90] [00001000] 0x1000 (unreliable)
> [264806.722530] [ee667eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264806.723448] [ee667ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264806.724569] [ee667ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264806.725701] [ee667f10] [c00983d4] sys_read+0x4c/0xa4
> [264806.726874] [ee667f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264806.727947] --- Exception: c01 at 0xff50fb0
> [264806.727950]     LR = 0xfef52a0
> [264806.730002] Instruction dump:
> [264806.730965] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264806.732298] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264806.733926] ---[ end trace cecbd2fe1c8fe267 ]---
> [264806.744476] Unable to handle kernel paging request for data at address 0x00000000
> [264806.745072] Faulting instruction address: 0xf661207c
> [264806.745617] Oops: Kernel access of bad area, sig: 11 [#20]
> [264806.746159] PowerMac
> [264806.746685] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264806.749367] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264806.750127] REGS: efbcfdc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264806.750692] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264806.751549] DAR: 00000000, DSISR: 40000000
> [264806.752384] TASK = ee907580[29183] 'cat' THREAD: efbce000
> [264806.752621] GPR00: f6612bc4 efbcfe70 ee907580 00000000 00000027 00000001 c0e33b00 c0e33b00 
> [264806.754283] GPR08: efbc9814 efbcfe78 00000005 00000005 28000242 1001cb7c 100042bc bff0cec4 
> [264806.755469] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bff0cda8 c03e2678 
> [264806.757085] GPR24: 10312000 00001000 efb8bf18 ca3faf98 efbcff20 c7cd7000 f661354c 00000000 
> [264806.759265] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264806.760193] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264806.761081] Call Trace:
> [264806.761628] [efbcfe70] [00001000] 0x1000 (unreliable)
> [264806.762574] [efbcfe90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264806.763508] [efbcfeb0] [c021d540] dev_attr_show+0x30/0x7c
> [264806.764660] [efbcfec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264806.765757] [efbcfef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264806.766890] [efbcff10] [c00983d4] sys_read+0x4c/0xa4
> [264806.767963] [efbcff40] [c0012c44] ret_from_syscall+0x0/0x38
> [264806.768983] --- Exception: c01 at 0xff50fb0
> [264806.768986]     LR = 0x100031f0
> [264806.771009] Instruction dump:
> [264806.771892] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264806.773284] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264806.774677] ---[ end trace cecbd2fe1c8fe268 ]---
> [264811.652253] Unable to handle kernel paging request for data at address 0x00000000
> [264811.652848] Faulting instruction address: 0xf661207c
> [264811.653387] Oops: Kernel access of bad area, sig: 11 [#21]
> [264811.653923] PowerMac
> [264811.654442] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264811.657115] NIP: f661207c LR: f6612c10 CTR: f6612bec
> [264811.657825] REGS: efbcfdc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264811.658385] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264811.659245] DAR: 00000000, DSISR: 40000000
> [264811.660052] TASK = ee95b580[29187] 'cat' THREAD: efbce000
> [264811.660276] GPR00: f6612c10 efbcfe70 ee95b580 00000000 00000025 00000001 c1204180 c1204180 
> [264811.661963] GPR08: efbc97e4 efbcfe78 00000006 00000006 28000242 1001cb7c 100042bc bff45a84 
> [264811.663139] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bff45968 c03e2678 
> [264811.664673] GPR24: 1003b000 00001000 efb8bf18 ca3fa998 efbcff20 e650b000 f6613538 00000000 
> [264811.666875] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264811.667771] LR [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264811.668616] Call Trace:
> [264811.669160] [efbcfe70] [00001000] 0x1000 (unreliable)
> [264811.670107] [efbcfe90] [f6612c10] show_sensor1_temperature+0x24/0x4c [therm_adt746x]
> [264811.671021] [efbcfeb0] [c021d540] dev_attr_show+0x30/0x7c
> [264811.672137] [efbcfec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264811.673212] [efbcfef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264811.674355] [efbcff10] [c00983d4] sys_read+0x4c/0xa4
> [264811.675409] [efbcff40] [c0012c44] ret_from_syscall+0x0/0x38
> [264811.676443] --- Exception: c01 at 0xff50fb0
> [264811.676446]     LR = 0x100031f0
> [264811.678415] Instruction dump:
> [264811.679320] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264811.680726] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264811.682211] ---[ end trace cecbd2fe1c8fe269 ]---
> [264811.702739] Unable to handle kernel paging request for data at address 0x00000010
> [264811.703345] Faulting instruction address: 0xf6612a28
> [264811.703893] Oops: Kernel access of bad area, sig: 11 [#22]
> [264811.704434] PowerMac
> [264811.704958] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264811.707650] NIP: f6612a28 LR: c021d540 CTR: f6612a08
> [264811.708454] REGS: ee667de0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264811.709021] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000428  XER: 00000000
> [264811.709880] DAR: 00000010, DSISR: 40000000
> [264811.710750] TASK = e641e820[29191] 'sed' THREAD: ee666000
> [264811.710992] GPR00: c021d540 ee667e90 e641e820 efb8bf10 00000028 ef06a000 c131ad60 c131ad60 
> [264811.712633] GPR08: efbc9964 f6610000 00000006 00000000 28000422 1002357c 1000ad18 1001b664 
> [264811.713823] GPR16: 1001b6a0 10020000 bfd4de38 10020000 10594850 10020000 10020000 c03e2678 
> [264811.715466] GPR24: 48020000 00001000 efb8bf18 ca3fa998 ee667f20 ef06a000 f66135d8 fffffffb 
> [264811.717633] NIP [f6612a28] show_sensor1_fan_speed+0x20/0x58 [therm_adt746x]
> [264811.718604] LR [c021d540] dev_attr_show+0x30/0x7c
> [264811.719447] Call Trace:
> [264811.720005] [ee667e90] [00001000] 0x1000 (unreliable)
> [264811.720965] [ee667eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264811.721883] [ee667ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264811.722997] [ee667ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264811.724128] [ee667f10] [c00983d4] sys_read+0x4c/0xa4
> [264811.725317] [ee667f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264811.726394] --- Exception: c01 at 0xff50fb0
> [264811.726397]     LR = 0xfef52a0
> [264811.728458] Instruction dump:
> [264811.729423] bb810010 38210020 7c0803a6 4e800020 9421ffe0 7c0802a6 3d20f661 38800028 
> [264811.730761] 90010024 bf810010 7cbd2b78 816937d4 <838b0010> 7d635b78 4bfff9b9 3c80f661 
> [264811.732255] ---[ end trace cecbd2fe1c8fe26a ]---
> [264811.743097] Unable to handle kernel paging request for data at address 0x00000000
> [264811.743696] Faulting instruction address: 0xf661207c
> [264811.744245] Oops: Kernel access of bad area, sig: 11 [#23]
> [264811.744789] PowerMac
> [264811.745316] Modules linked in: iptable_filter ip_tables x_tables nfsd lockd nfs_acl auth_rpcgss sunrpc sha256_generic krng chainiv crypto_wq rng aes_generic cbc dm_crypt dm_mod therm_adt746x loop sd_mod arc4 ecb cryptomgr crypto_hash aead pcompress crypto_blkcipher crypto_algapi b43 usb_storage mac80211 scsi_mod ams cfg80211 input_polldev crypto ide_cd_mod cdrom ehci_hcd ohci_hcd ssb [last unloaded: i2c_powermac]
> [264811.748012] NIP: f661207c LR: f6612bc4 CTR: f6612ba0
> [264811.748816] REGS: e6419dc0 TRAP: 0300   Tainted: G      D     (2.6.33-rc2)
> [264811.749386] MSR: 00009032 <EE,ME,IR,DR>  CR: 28000248  XER: 00000000
> [264811.750242] DAR: 00000000, DSISR: 40000000
> [264811.751140] TASK = e641dac0[29192] 'cat' THREAD: e6418000
> [264811.751382] GPR00: f6612bc4 e6419e70 e641dac0 00000000 00000027 00000001 c131ad60 c131ad60 
> [264811.752989] GPR08: efbc9814 e6419e78 00000006 00000006 28000242 1001cb7c 100042bc bff45a84 
> [264811.754189] GPR16: 00000002 00001000 00000001 10014b98 10014b50 1002b3dc bff45968 c03e2678 
> [264811.755884] GPR24: 10610000 00001000 efb8bf18 ca3fa7d8 e6419f20 ef06a000 f661354c 00000000 
> [264811.758028] NIP [f661207c] read_reg+0x20/0x78 [therm_adt746x]
> [264811.758985] LR [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264811.759898] Call Trace:
> [264811.760493] [e6419e70] [00001000] 0x1000 (unreliable)
> [264811.761423] [e6419e90] [f6612bc4] show_sensor2_temperature+0x24/0x4c [therm_adt746x]
> [264811.762422] [e6419eb0] [c021d540] dev_attr_show+0x30/0x7c
> [264811.763553] [e6419ec0] [c00e94b8] sysfs_read_file+0xa8/0x144
> [264811.764766] [e6419ef0] [c00981c0] vfs_read+0xb4/0x1c0
> [264811.765845] [e6419f10] [c00983d4] sys_read+0x4c/0xa4
> [264811.766911] [e6419f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264811.767985] --- Exception: c01 at 0xff50fb0
> [264811.767988]     LR = 0x100031f0
> [264811.770059] Instruction dump:
> [264811.771081] 7d295850 7d29fe70 7d230038 4bffffd4 9421ffe0 7c0802a6 38a00001 7c290b78 
> [264811.772376] 93e1001c 7c7f1b78 90010024 9c890008 <80630000> 7d244b78 48000dd5 2c030000 
> [264811.773868] ---[ end trace cecbd2fe1c8fe26b ]---
> 
> 
> # modprobe i2c_powermac
> 
> [264814.736255] PowerMac i2c bus pmu 2 registered
> [264814.736876] PowerMac i2c bus pmu 1 registered
> [264814.737450] PowerMac i2c bus mac-io 0 registered
> [264814.758251] adt746x: ADT7467 initializing
> [264814.761040] adt746x: Lowering max temperatures from 73, 80, 109 to 67, 47, 67
> [264814.765442] PowerMac i2c bus uni-n 1 registered
> [264814.817834] sysfs: cannot create duplicate filename '/devices/ams'
> [264814.818481] ------------[ cut here ]------------
> [264814.819024] Badness at fs/sysfs/dir.c:477
> [264814.819559] NIP: c00ea3c0 LR: c00ea3c0 CTR: 00000000
> [264814.820101] REGS: ef0a5a50 TRAP: 0700   Tainted: G      D     (2.6.33-rc2)
> [264814.820656] MSR: 00029032 <EE,ME,CE,IR,DR>  CR: 42008444  XER: 00000000
> [264814.821285] TASK = e641dac0[29199] 'modprobe' THREAD: ef0a4000
> [264814.821326] GPR00: c00ea3c0 ef0a5b00 e641dac0 0000004d 00013b71 ffffffff ffffffff 00000000 
> [264814.821961] GPR08: efa70500 c03e0000 00000000 00013b71 44008428 10020390 100e0000 100df49c 
> [264814.822596] GPR16: 100b54c0 100df49c 100ddd20 10462de8 100b5340 c03e2664 c03e2638 c03e5f4c 
> [264814.823537] GPR24: 00000000 24008422 ffffffea ef0a5b58 ecb52000 ecb52000 ef029c90 ffffffef 
> [264814.825762] NIP [c00ea3c0] sysfs_add_one+0x94/0xc0
> [264814.826552] LR [c00ea3c0] sysfs_add_one+0x94/0xc0
> [264814.827283] Call Trace:
> [264814.827882] [ef0a5b00] [c00ea3c0] sysfs_add_one+0x94/0xc0 (unreliable)
> [264814.828771] [ef0a5b20] [c00eaad4] create_dir+0x58/0xd8
> [264814.829595] [ef0a5b50] [c00eab94] sysfs_create_dir+0x40/0x70
> [264814.830684] [ef0a5b70] [c01c8918] kobject_add_internal+0xc0/0x1fc
> [264814.831763] [ef0a5b90] [c01c8c8c] kobject_add+0x60/0x98
> [264814.832859] [ef0a5bc0] [c021e368] device_add+0x9c/0x5bc
> [264814.833837] [ef0a5c10] [c0267964] of_device_register+0x34/0x48
> [264814.834862] [ef0a5c30] [c000bfcc] of_platform_device_create+0x44/0x74
> [264814.835887] [ef0a5c40] [f20fc388] ams_sensor_attach+0xc8/0x134 [ams]
> [264814.836833] [ef0a5c60] [f20fcfc8] ams_i2c_probe+0x154/0x210 [ams]
> [264814.837816] [ef0a5c80] [c026043c] i2c_device_probe+0xe4/0x100
> [264814.838749] [ef0a5ca0] [c022108c] driver_probe_device+0xa0/0x198
> [264814.839667] [ef0a5cc0] [c02203fc] bus_for_each_drv+0x70/0xac
> [264814.840553] [ef0a5cf0] [c0221378] device_attach+0x84/0xa8
> [264814.841456] [ef0a5d10] [c021fc5c] bus_probe_device+0x2c/0x44
> [264814.842357] [ef0a5d20] [c021e66c] device_add+0x3a0/0x5bc
> [264814.843252] [ef0a5d70] [c0261998] i2c_new_device+0xfc/0x150
> [264814.844172] [ef0a5da0] [f870b64c] i2c_powermac_probe+0x1cc/0x410 [i2c_powermac]
> [264814.845164] [ef0a5df0] [c02224e8] platform_drv_probe+0x20/0x30
> [264814.846119] [ef0a5e00] [c022108c] driver_probe_device+0xa0/0x198
> [264814.847070] [ef0a5e20] [c0221240] __driver_attach+0xbc/0xc0
> [264814.848017] [ef0a5e40] [c0220790] bus_for_each_dev+0x70/0xac
> [264814.848963] [ef0a5e70] [c0220eb8] driver_attach+0x24/0x34
> [264814.849836] [ef0a5e80] [c021ff1c] bus_add_driver+0xb4/0x284
> [264814.850771] [ef0a5eb0] [c02215b0] driver_register+0x80/0x170
> [264814.851693] [ef0a5ed0] [c02228a8] platform_driver_register+0x6c/0x7c
> [264814.852634] [ef0a5ee0] [f870e018] i2c_powermac_init+0x18/0x40 [i2c_powermac]
> [264814.853604] [ef0a5ef0] [c0003eb8] do_one_initcall+0x3c/0x1e0
> [264814.854530] [ef0a5f20] [c005e3c4] sys_init_module+0xf8/0x218
> [264814.855474] [ef0a5f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264814.856434] --- Exception: c01 at 0xff63044
> [264814.856437]     LR = 0x10003c80
> [264814.858043] Instruction dump:
> [264814.858893] 4bffff41 7c7d1b78 4bf2e221 38002f00 7c1d1b2e 7fa3eb78 809e0010 4bf2e18d 
> [264814.860210] 7c641b78 3c60c037 3863e948 48225afd <0fe00000> 7f83e378 4bfa93a5 80010024 
> [264814.861569] kobject_add_internal failed for ams with -EEXIST, don't try to register things with the same name in the same directory.
> [264814.863528] Call Trace:
> [264814.864454] [ef0a5b40] [c0008e58] show_stack+0x48/0x15c (unreliable)
> [264814.865244] [ef0a5b70] [c01c8988] kobject_add_internal+0x130/0x1fc
> [264814.865928] [ef0a5b90] [c01c8c8c] kobject_add+0x60/0x98
> [264814.866772] [ef0a5bc0] [c021e368] device_add+0x9c/0x5bc
> [264814.867992] [ef0a5c10] [c0267964] of_device_register+0x34/0x48
> [264814.869107] [ef0a5c30] [c000bfcc] of_platform_device_create+0x44/0x74
> [264814.869946] [ef0a5c40] [f20fc388] ams_sensor_attach+0xc8/0x134 [ams]
> [264814.870854] [ef0a5c60] [f20fcfc8] ams_i2c_probe+0x154/0x210 [ams]
> [264814.871846] [ef0a5c80] [c026043c] i2c_device_probe+0xe4/0x100
> [264814.872781] [ef0a5ca0] [c022108c] driver_probe_device+0xa0/0x198
> [264814.873690] [ef0a5cc0] [c02203fc] bus_for_each_drv+0x70/0xac
> [264814.874582] [ef0a5cf0] [c0221378] device_attach+0x84/0xa8
> [264814.875473] [ef0a5d10] [c021fc5c] bus_probe_device+0x2c/0x44
> [264814.876312] [ef0a5d20] [c021e66c] device_add+0x3a0/0x5bc
> [264814.877209] [ef0a5d70] [c0261998] i2c_new_device+0xfc/0x150
> [264814.878132] [ef0a5da0] [f870b64c] i2c_powermac_probe+0x1cc/0x410 [i2c_powermac]
> [264814.879121] [ef0a5df0] [c02224e8] platform_drv_probe+0x20/0x30
> [264814.880080] [ef0a5e00] [c022108c] driver_probe_device+0xa0/0x198
> [264814.881024] [ef0a5e20] [c0221240] __driver_attach+0xbc/0xc0
> [264814.881965] [ef0a5e40] [c0220790] bus_for_each_dev+0x70/0xac
> [264814.882893] [ef0a5e70] [c0220eb8] driver_attach+0x24/0x34
> [264814.883752] [ef0a5e80] [c021ff1c] bus_add_driver+0xb4/0x284
> [264814.884654] [ef0a5eb0] [c02215b0] driver_register+0x80/0x170
> [264814.885562] [ef0a5ed0] [c02228a8] platform_driver_register+0x6c/0x7c
> [264814.886497] [ef0a5ee0] [f870e018] i2c_powermac_init+0x18/0x40 [i2c_powermac]
> [264814.887463] [ef0a5ef0] [c0003eb8] do_one_initcall+0x3c/0x1e0
> [264814.888375] [ef0a5f20] [c005e3c4] sys_init_module+0xf8/0x218
> [264814.889294] [ef0a5f40] [c0012c44] ret_from_syscall+0x0/0x38
> [264814.890214] --- Exception: c01 at 0xff63044
> [264814.890217]     LR = 0x10003c80
> 
> 
> 


