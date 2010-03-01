Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304Ab0CASJw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 13:09:52 -0500
Received: from smtprelay04.ispgateway.de ([80.67.29.8]:55971 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751054Ab0CASJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 13:09:45 -0500
Message-ID: <cone.1267466820.296261.3385.1000@deskpiie>
X-Mailer: http://www.courier-mta.org/cone/
From: Peter Feuerer <peter@piie.net>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [BUG] usb-serial / pl2302 corrupted receive
Date: Mon, 01 Mar 2010 19:07:00 +0100
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="US-ASCII"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
X-Df-Sender: 404094
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

I tried to flash an AVR microcontroler via an USB to serial converter which 
uses pl2302 driver. It didn't work, so I set up following test to reproduce 
the bug:

I connected two pls2302 usb-serial converters to two different usb-ports 
of my machine and connected them with a rs232-nullmodem cable to each 
other.

Terminal1:
cat /dev/ttyUSB1

Terminal2:
while true; do echo 123456789012345678901234567890 > /dev/ttyUSB0 ; done


When both usb-serial converters are plugged in, the first few lines appear 
correctly on Terminal1. Then I noticed two different bahaviors:

1) The lines on Terminal1 are corrupted like: 
"1111111111111111111111123456789012345678901234567890"

2) The lines "123456789012345678901234567890" appear correctly on Terminal1 
but when I kill the "cat" command and start it again, there's only one line 
and then no output anymore.

I verified this behavior on two different machines running the same 
kernel (version 2.6.32.9).

Additionally a calltrace is printed to dmesg (see end of mail)


I'm not 100% sure, but if I remember correctly was flashing AVR 
microcontrollers with pl2302 possible about the time when kernel 2.6.22 was 
released.

If you've got any questions I'd be pleased to help you.

best regards,
--peter;




---
[piie@deskpiie ~]$ lsusb
Bus 002 Device 013: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial 
Port
Bus 002 Device 012: ID 067b:2303 Prolific Technology, Inc. PL2303 Serial 
Port




------------[ cut here ]------------
WARNING: at drivers/usb/serial/usb-serial.c:406 serial_write_room+0x74/0x80 
[usbserial]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: pl2303 usbserial sha256_generic aes_i586 aes_generic cbc 
ipv6 snd_hda_codec_nvhdmi usbhid hid snd_hda_codec_via snd_seq_dummy 
snd_seq_oss snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss 
snd_mixer_oss snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer 
ohci_hcd snd soundcore coretemp snd_page_alloc nvidia(P) shpchp i2c_nforce2 
ehci_hcd agpgart wmi psmouse thermal pci_hotplug i2c_core usbcore sg 
forcedeth button processor serio_raw vboxdrv evdev dm_crypt dm_mod fuse 
rtc_cmos rtc_core rtc_lib ext4 mbcache jbd2 crc16 sr_mod cdrom sd_mod 
pata_acpi ahci ata_generic libata scsi_mod
Pid: 15, comm: events/0 Tainted: P        W  2.6.32-ARCH #1
Call Trace:
 [<c104042e>] ? warn_slowpath_common+0x6e/0xb0
 [<f8c634b4>] ? serial_write_room+0x74/0x80 [usbserial]
 [<c1040483>] ? warn_slowpath_null+0x13/0x20
 [<f8c634b4>] ? serial_write_room+0x74/0x80 [usbserial]
 [<c11ddf15>] ? tty_write_room+0x15/0x20
 [<c11db6a7>] ? process_echoes+0x47/0x2b0
 [<c11dda85>] ? n_tty_receive_buf+0xe45/0x10c0
 [<c1002374>] ? __switch_to+0x184/0x190
 [<c103655b>] ? finish_task_switch+0x3b/0xa0
 [<c12b77d9>] ? schedule+0x2f9/0xa30
 [<f8e2cfea>] ? usb_autopm_do_interface+0x7a/0xe0 [usbcore]
 [<c11e023a>] ? flush_to_ldisc+0x14a/0x180
 [<c11e00f0>] ? flush_to_ldisc+0x0/0x180
 [<c1056f7f>] ? worker_thread+0x11f/0x260
 [<c105adf0>] ? autoremove_wake_function+0x0/0x40
 [<c1056e60>] ? worker_thread+0x0/0x260
 [<c105ab44>] ? kthread+0x74/0x80
 [<c105aad0>] ? kthread+0x0/0x80
 [<c1004627>] ? kernel_thread_helper+0x7/0x10
---[ end trace 4162a861717078f5 ]---
------------[ cut here ]------------

