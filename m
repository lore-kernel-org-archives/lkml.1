Return-Path: <linux-kernel-owner+w=401wt.eu-S934655AbZJJA01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934655AbZJJA01 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933388AbZJJA00
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:26:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:53004 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933372AbZJJA0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:26:25 -0400
Subject: USB serial regression 2.6.31.1 -> 2.6.31.2
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Greg KH <greg@kroah.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
       Hugh Blemings <hugh@blemings.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Oct 2009 11:25:15 +1100
Message-Id: <1255134315.2139.8.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks !

My USB GSM modem (Huawei 169, pretty common stuff) stopped working in
the latest ubuntu karmic update. So far, I tracked it down to a
regression that happened in the stable releases between 2.6.31.1 and
2.6.31.2 (still present in .3). I haven't tested 2.6.32-rc* yet and
haven't had a chance to bisect (need to make myself a trimmed
down .config first).

There's a lot of usb-serial changes in there. At first glance, I'd say
you guys are taking chances in a stable release for stuff that hasn't
been out in the main "upstream" release for some time but heh :-)

The symptom is that the USB modem just disconnects/reconnects in a loop.
The log looks like what I pasted below when plugging the device (and
leaving it in, the disconnects don't correspond to the device being
removed).

Note that 2.6.31.1 works but tends to oops on removal of the device,
I'll paste the oops log too.

Next, as time permits, I'll test upstream and if you think it's worth it
try to bisect the .2 problem down to one of the numerous usb-serial
changes in there.

Cheers,
Ben.

Oct 10 11:07:03 pasglop kernel: [   49.144079] usb 4-1: new full speed USB device using uhci_hcd and address 2
Oct 10 11:07:03 pasglop kernel: [   49.305220] usb 4-1: configuration #1 chosen from 1 choice
Oct 10 11:07:04 pasglop kernel: [   49.317562] Initializing USB Mass Storage driver...
Oct 10 11:07:04 pasglop kernel: [   49.319184] scsi2 : SCSI emulation for USB Mass Storage devices
Oct 10 11:07:04 pasglop kernel: [   49.319322] usbcore: registered new interface driver usb-storage
Oct 10 11:07:04 pasglop kernel: [   49.319326] USB Mass Storage support registered.
Oct 10 11:07:04 pasglop kernel: [   49.320661] usb-storage: device found at 2
Oct 10 11:07:04 pasglop kernel: [   49.320664] usb-storage: waiting for device to settle before scanning
Oct 10 11:07:04 pasglop kernel: [   49.504146] usb 4-1: USB disconnect, address 2
Oct 10 11:07:04 pasglop kernel: [   50.296066] usb 4-1: new full speed USB device using uhci_hcd and address 3
Oct 10 11:07:04 pasglop kernel: [   50.457214] usb 4-1: configuration #1 chosen from 1 choice
Oct 10 11:07:04 pasglop kernel: [   50.478880] usbcore: registered new interface driver usbserial
Oct 10 11:07:04 pasglop kernel: [   50.479309] USB Serial support registered for generic
Oct 10 11:07:04 pasglop kernel: [   50.492138] scsi6 : SCSI emulation for USB Mass Storage devices
Oct 10 11:07:04 pasglop kernel: [   50.493166] usbcore: registered new interface driver usbserial_generic
Oct 10 11:07:04 pasglop kernel: [   50.493170] usbserial: USB Serial Driver core
Oct 10 11:07:04 pasglop kernel: [   50.497581] USB Serial support registered for GSM modem (1-port)
Oct 10 11:07:04 pasglop kernel: [   50.497626] option 4-1:1.0: GSM modem (1-port) converter detected
Oct 10 11:07:04 pasglop kernel: [   50.497712] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB0
Oct 10 11:07:04 pasglop kernel: [   50.497723] option 4-1:1.1: GSM modem (1-port) converter detected
Oct 10 11:07:04 pasglop kernel: [   50.497772] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB1
Oct 10 11:07:04 pasglop kernel: [   50.497782] option 4-1:1.2: GSM modem (1-port) converter detected
Oct 10 11:07:04 pasglop kernel: [   50.497841] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB2
Oct 10 11:07:04 pasglop kernel: [   50.497859] usbcore: registered new interface driver option
Oct 10 11:07:09 pasglop kernel: [   50.497861] option: v0.7.2:USB Driver for GSM modems
Oct 10 11:07:09 pasglop kernel: [   50.502750] usb-storage: device found at 3
Oct 10 11:07:09 pasglop kernel: [   50.502753] usb-storage: waiting for device to settle before scanning
Oct 10 11:07:09 pasglop kernel: [   55.501229] usb-storage: device scan complete
Oct 10 11:07:09 pasglop kernel: [   55.504147] scsi 6:0:0:0: CD-ROM            HUAWEI   Mass Storage     2.31 PQ: 0 ANSI: 2
Oct 10 11:07:09 pasglop kernel: [   55.507170] scsi 6:0:0:1: Direct-Access     HUAWEI   SD Storage       2.31 PQ: 0 ANSI: 2
Oct 10 11:07:09 pasglop kernel: [   55.530139] sr1: scsi-1 drive
Oct 10 11:07:09 pasglop kernel: [   55.530341] sr 6:0:0:0: Attached scsi CD-ROM sr1
Oct 10 11:07:09 pasglop kernel: [   55.531248] sr 6:0:0:0: Attached scsi generic sg2 type 5
Oct 10 11:07:09 pasglop kernel: [   55.531376] sd 6:0:0:1: Attached scsi generic sg3 type 0
Oct 10 11:07:09 pasglop kernel: [   55.554127] option: option_instat_callback: error -108
Oct 10 11:07:09 pasglop kernel: [   55.554232] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
Oct 10 11:07:09 pasglop kernel: [   55.554254] option 4-1:1.0: device disconnected
Oct 10 11:07:09 pasglop kernel: [   55.557199] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
Oct 10 11:07:09 pasglop kernel: [   55.557215] option 4-1:1.1: device disconnected
Oct 10 11:07:10 pasglop kernel: [   55.557284] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
Oct 10 11:07:10 pasglop kernel: [   55.557303] option 4-1:1.2: device disconnected
Oct 10 11:07:10 pasglop kernel: [   55.669058] usb 4-1: reset full speed USB device using uhci_hcd and address 3
Oct 10 11:07:10 pasglop kernel: [   55.819263] option 4-1:1.2: GSM modem (1-port) converter detected
Oct 10 11:07:10 pasglop kernel: [   55.819339] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB0
Oct 10 11:07:10 pasglop kernel: [   55.820552] option 4-1:1.1: GSM modem (1-port) converter detected
Oct 10 11:07:10 pasglop kernel: [   55.820616] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB1
Oct 10 11:07:10 pasglop kernel: [   55.821460] option 4-1:1.0: GSM modem (1-port) converter detected
Oct 10 11:07:10 pasglop kernel: [   55.821522] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB2
Oct 10 11:07:10 pasglop kernel: [   55.839093] option: option_instat_callback: error -108
Oct 10 11:07:10 pasglop kernel: [   55.839209] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
Oct 10 11:07:10 pasglop kernel: [   55.839228] option 4-1:1.0: device disconnected
Oct 10 11:07:10 pasglop kernel: [   55.839289] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
Oct 10 11:07:10 pasglop kernel: [   55.839306] option 4-1:1.1: device disconnected
Oct 10 11:07:10 pasglop kernel: [   55.839366] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
Oct 10 11:07:10 pasglop kernel: [   55.839382] option 4-1:1.2: device disconnected
Oct 10 11:07:10 pasglop kernel: [   56.008068] usb 4-1: reset full speed USB device using uhci_hcd and address 3
Oct 10 11:07:10 pasglop kernel: [   56.156255] option 4-1:1.2: GSM modem (1-port) converter detected
Oct 10 11:07:10 pasglop kernel: [   56.156337] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB0
Oct 10 11:07:10 pasglop kernel: [   56.156434] option 4-1:1.1: GSM modem (1-port) converter detected
Oct 10 11:07:10 pasglop kernel: [   56.156488] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB1
Oct 10 11:07:10 pasglop kernel: [   56.159274] option 4-1:1.0: GSM modem (1-port) converter detected
Oct 10 11:07:10 pasglop kernel: [   56.159346] usb 4-1: GSM modem (1-port) converter now attached to ttyUSB2
Oct 10 11:07:10 pasglop kernel: [   56.180094] option: option_instat_callback: error -108
Oct 10 11:07:10 pasglop kernel: [   56.180190] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
Oct 10 11:07:10 pasglop kernel: [   56.180209] option 4-1:1.0: device disconnected
Oct 10 11:07:10 pasglop kernel: [   56.180290] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
Oct 10 11:07:10 pasglop kernel: [   56.180307] option 4-1:1.1: device disconnected
Oct 10 11:07:10 pasglop kernel: [   56.180374] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
Oct 10 11:07:10 pasglop kernel: [   56.180390] option 4-1:1.2: device disconnected

etc... in a loop.

The oops log with .1 is:

Oct 10 11:09:33 pasglop kernel: [   92.409225] usb 4-1: USB disconnect, address 4
Oct 10 11:09:33 pasglop kernel: [   92.410299] option: option_instat_callback: error -108
Oct 10 11:09:33 pasglop kernel: [   92.410691] option1 ttyUSB0: GSM modem (1-port) converter now disconnected from ttyUSB0
Oct 10 11:09:33 pasglop kernel: [   92.410726] option 4-1:1.0: device disconnected
Oct 10 11:09:33 pasglop kernel: [   92.411023] option1 ttyUSB1: GSM modem (1-port) converter now disconnected from ttyUSB1
Oct 10 11:09:33 pasglop kernel: [   92.411054] option 4-1:1.1: device disconnected
Oct 10 11:09:33 pasglop kernel: [   92.411364] option1 ttyUSB2: GSM modem (1-port) converter now disconnected from ttyUSB2
Oct 10 11:09:33 pasglop kernel: [   92.411409] option 4-1:1.2: device disconnected
Oct 10 11:09:33 pasglop kernel: [   93.445278] BUG: unable to handle kernel paging request at 349a46ed
Oct 10 11:09:33 pasglop kernel: [   93.445294] IP: [<f96dee98>] serial_do_free+0x38/0x80 [usbserial]
Oct 10 11:09:33 pasglop kernel: [   93.445319] *pde = 00000000 
Oct 10 11:09:33 pasglop kernel: [   93.445327] Oops: 0000 [#1] SMP 
Oct 10 11:09:33 pasglop kernel: [   93.445336] last sysfs file: /sys/devices/pci0000:00/0000:00:1c.1/0000:03:00.0/ieee80211/phy0/rfkill2/uevent
Oct 10 11:09:33 pasglop kernel: [   93.445344] Modules linked in: ppp_async crc_ccitt option usbserial usb_storage aes_i586 aes_generic binfmt_misc bridge stp ppdev bnep snd_hda_codec_analog joydev fbcon tileblit font bitblit softcursor snd_hda_intel snd_hda_codec snd_hwdep snd_pcm_oss snd_mixer_oss snd_pcm snd_seq_dummy snd_seq_oss snd_seq_midi snd_rawmidi snd_seq_midi_event arc4 ecb snd_seq snd_timer iptable_filter psmouse pcmcia ip_tables snd_seq_device iwlagn iwlcore mac80211 sdhci_pci serio_raw i915 x_tables snd thinkpad_acpi yenta_socket drm i2c_algo_bit soundcore sdhci btusb snd_page_alloc led_class nvram video rsrc_nonstatic ricoh_mmc pcmcia_core intel_agp cfg80211 output agpgart lp parport ohci1394 ieee1394 e1000e
Oct 10 11:09:33 pasglop kernel: [   93.445495] 
Oct 10 11:09:33 pasglop kernel: [   93.445503] Pid: 2085, comm: pppd Not tainted (2.6.31-02063101-generic #02063101) 7659AB8
Oct 10 11:09:33 pasglop kernel: [   93.445511] EIP: 0060:[<f96dee98>] EFLAGS: 00010246 CPU: 1
Oct 10 11:09:33 pasglop kernel: [   93.445528] EIP is at serial_do_free+0x38/0x80 [usbserial]
Oct 10 11:09:33 pasglop kernel: [   93.445535] EAX: 349a46d1 EBX: f343e960 ECX: 00000000 EDX: f3ffc000
Oct 10 11:09:33 pasglop kernel: [   93.445542] ESI: f343e998 EDI: f4601198 EBP: f265fe84 ESP: f265fe78
Oct 10 11:09:33 pasglop kernel: [   93.445548]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
Oct 10 11:09:33 pasglop kernel: [   93.445556] Process pppd (pid: 2085, ti=f265e000 task=f327b240 task.ti=f265e000)
Oct 10 11:09:33 pasglop kernel: [   93.445561] Stack:
Oct 10 11:09:33 pasglop kernel: [   93.445565]  f3ffc000 f250b800 f4601198 f265feac f96def1b f265feac c037b2db f250b8b4
Oct 10 11:09:33 pasglop kernel: [   93.445584] <0> 00000000 f3c0fd00 f250b800 00000000 f4601198 f265ff38 c037ceb1 f265ff38
Oct 10 11:09:33 pasglop kernel: [   93.445604] <0> f265fedc f265fed0 c015d9f3 f265fed0 f3c0fd00 00000000 f6672cd8 c015e43a
Oct 10 11:09:33 pasglop kernel: [   93.445626] Call Trace:
Oct 10 11:09:33 pasglop kernel: [   93.445645]  [<f96def1b>] ? serial_close+0x3b/0xa0 [usbserial]
Oct 10 11:09:33 pasglop kernel: [   93.445660]  [<c037b2db>] ? tty_fasync+0x3b/0x110
Oct 10 11:09:33 pasglop kernel: [   93.445670]  [<c037ceb1>] ? tty_release_dev+0x151/0x4b0
Oct 10 11:09:33 pasglop kernel: [   93.445681]  [<c015d9f3>] ? lock_hrtimer_base+0x23/0x50
Oct 10 11:09:33 pasglop kernel: [   93.445690]  [<c015e43a>] ? hrtimer_try_to_cancel+0x3a/0x80
Oct 10 11:09:33 pasglop kernel: [   93.445700]  [<c015e491>] ? hrtimer_cancel+0x11/0x20
Oct 10 11:09:33 pasglop kernel: [   93.445710]  [<c05670af>] ? do_nanosleep+0x8f/0xc0
Oct 10 11:09:33 pasglop kernel: [   93.445719]  [<c015e5b9>] ? hrtimer_nanosleep+0x99/0x120
Oct 10 11:09:33 pasglop kernel: [   93.445738]  [<c037d222>] ? tty_release+0x12/0x20
Oct 10 11:09:33 pasglop kernel: [   93.445749]  [<c01e610a>] ? __fput+0xda/0x1f0
Oct 10 11:09:33 pasglop kernel: [   93.445758]  [<c01e6439>] ? fput+0x19/0x20
Oct 10 11:09:33 pasglop kernel: [   93.445767]  [<c01e3027>] ? filp_close+0x47/0x70
Oct 10 11:09:33 pasglop kernel: [   93.445778]  [<c01f2744>] ? do_vfs_ioctl+0x64/0x1c0
Oct 10 11:09:33 pasglop kernel: [   93.445787]  [<c01e43d9>] ? sys_close+0x69/0xb0
Oct 10 11:09:33 pasglop kernel: [   93.445797]  [<c0102ee3>] ? sysenter_do_call+0x12/0x28
Oct 10 11:09:33 pasglop kernel: [   93.445803] Code: 24 04 89 7c 24 08 80 b8 da 00 00 00 00 74 14 8b 1c 24 8b 74 24 04 8b 7c 24 08 89 ec 5d c3 90 8d 74 26 00 8b 18 8b 43 04 8d 73 38 <8b> 78 1c 8d 82 e0 00 00 00 e8 3a d5 cb c6 89 f0 e8 23 7d e8 c6 

Cheers,
Ben.

