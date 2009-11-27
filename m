Return-Path: <linux-kernel-owner+w=401wt.eu-S1752631AbZK0Ni6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752631AbZK0Ni6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 08:38:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752129AbZK0Ni5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 08:38:57 -0500
Received: from mail1-out1.atlantis.sk ([80.94.52.55]:42023 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751482AbZK0Ni4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 08:38:56 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: linux-usb@vger.kernel.org
Subject: debugging oops after disconnecting Nexio USB touchscreen
Date: Fri, 27 Nov 2009 14:38:56 +0100
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911271438.57467.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,
I have problems debbugging an oops. It happens when Nexio USB touchscreen
(using my new code http://lkml.org/lkml/2009/11/25/568) is disconnected:

BUG: unable to handle kernel NULL pointer dereference at 00000048
IP: [<f7c38afd>] start_unlink_async+0xb2/0x160 [ehci_hcd]
*pde = 00000000
Oops: 0000 [#1] SMP
last sysfs file: /sys/devices/pci0000:00/0000:00:1b.0/sound/card0/controlC0/uevent
Modules linked in: uvesafb cn i915 drm i2c_algo_bit joydev usbtouchscreen loop snd_usb_audio snd_usb_lib snd_rawmidi snd_seq_device
snd_hda_codec_realtek snd_hda_intel snd_hda_codec snd_hwdep snd_pcm snd_timer snd ftdi_sio soundcore snd_page_alloc
gspca_ov519 usblp usbhid hid usbserial gspca_main videodev rng_core v4l1_compat i2c_i801 i2c_core processor pcspkr psmouse
asus_atk0110 evdev serio_raw button ext3 jbd mbcache usb_storage sd_mod crc_t10dif ata_generic ata_piix libata scsi_mod
ide_pci_generic r8169 mii video output uhci_hcd intel_agp agpgart ehci_hcd ide_core usbcore nls_base thermal fan thermal_sys
Pid: 195, comm: khubd Not tainted (2.6.31 #1) B202
EIP: 0060:[<f7c38afd>] EFLAGS: 00010003 CPU: 0
EIP is at start_unlink_async+0xb2/0x160 [ehci_hcd]
EAX: 00000000 EBX: f648c8e8 ECX: 78bd7dee EDX: 78bd7dee
ESI: 00000000 EDI: f65fc080 EBP: 00010030 ESP: f65bfddc
 DS: 007b  ES: 007b  FS: 00d8  GS: 00e0  SS: 0068
Process hbuhd (pid: 195, ti=f65be000 task=f644e1c0 task.ti=f65be000)
Stack:
 78bd7dee fffffffe f65fc080 f648c800 f648c8e8 f7c3ab29 f648c8f8 00000246
<0> 00000000 78bd7dee f7c3e278 f648c800 f605d840 fffffffe f7c977fc f6481800
<0> 78bd7dee 00000000 f605d840 00000246 fffffffe f7c9795d 78bd7dee f605d840
Call Trace:
 [<f7c3ab29>] ? ehci_urb_dequeue+0x7c/0x11a [ehci_hcd]
 [<f7c977fc>] ? unlink1+0xaa/0xc7 [usbcore]
 [<f7c9795d>] ? usb_hcd_unlink_urb+0x57/0x84 [usbcore]
 [<f7c98b28>] ? usb_kill_urb+0x40/0xbe [usbcore]
 [<c1034ec2>] ? default_wake_function+0x0/0x2b
 [<f7c99ff9>] ? usb_start_wait_urb+0x6e/0xb0 [usbcore]
 [<f7c9a2cf>] ? usb_control_msg+0x10a/0x136 [usbcore]
 [<f7c92e46>] ? hub_port_status+0x77/0xf7 [usbcore]
 [<f7c95f9d>] ? hub_thread+0x56d/0xe14 [usbcore]
 [<c1050003>] ? autoremove_wake_function+0x0/0x4f
 [<f7c95a30>] ? hub_thread+0x0/0xe14 [usbcore]
 [<c104fc73>] ? kthread+0x7a/0x7f
 [<c104fbf9>] ? kthread+0x0/0x7f
 [<c1004027>] ? kernel_thread_helper+0x7/0x10
Code: 00 fb e9 bb 00 00 00 c6 46 68 02 89 f0 e8 ee e8 ff ff 85 db 89 c7 89 43 18 75 06 68 c5 e4 c3 f7 e8 b4 5f 68 c9 50 8b 43 14 89 c6
<8b> 40 48 39 f8 75 f7 85 f6 75 0b 68 0c e5 c3 f7 e8 99 5f 68 c9
EIP: [<f7c38afd>] start_unlink_async+0xb2/0x160 [ehci_hcd] SS:ESP 0068:f65bfddc
CR2: 0000000000000048
---[ end trace 040b72a526aa0755 ]---


It does not happen everytime - sometimes it survives the first disconnect.
Tried adding printk()s to start_unlink_async function - and the oops does not appear.
Looks like a race. It might be a bug in my code but I'm not able to find it.

It also happens only when the touchscreen is connected through a hub:
Bus 001 Device 002: ID 2001:f103 D-Link Corp. [hex] DUB-H7 7-port USB 2.0 hub
When connected directly to the machine, it does not oops.

Tried decodecode:
Code: 00 fb e9 bb 00 00 00 c6 46 68 02 89 f0 e8 ee e8 ff ff 85 db 89 c7 89 43 18 75 06 68 c5 e4 c3 f7 e8 b4 5f 68 c9 50 8b 43 14 89 c6 <8b> 40 48 39 f8 75 
f7 85 f6 75 0b 68 0c e5 c3 f7 e8 99 5f 68 c9
All code
========
   0:   00 fb                   add    %bh,%bl
   2:   e9 bb 00 00 00          jmp    0xc2
   7:   c6 46 68 02             movb   $0x2,0x68(%esi)
   b:   89 f0                   mov    %esi,%eax
   d:   e8 ee e8 ff ff          call   0xffffe900
  12:   85 db                   test   %ebx,%ebx
  14:   89 c7                   mov    %eax,%edi
  16:   89 43 18                mov    %eax,0x18(%ebx)
  19:   75 06                   jne    0x21
  1b:   68 c5 e4 c3 f7          push   $0xf7c3e4c5
  20:   e8 b4 5f 68 c9          call   0xc9685fd9
  25:   50                      push   %eax
  26:   8b 43 14                mov    0x14(%ebx),%eax
  29:   89 c6                   mov    %eax,%esi
  2b:*  8b 40 48                mov    0x48(%eax),%eax     <-- trapping instruction
  2e:   39 f8                   cmp    %edi,%eax
  30:   75 f7                   jne    0x29
  32:   85 f6                   test   %esi,%esi
  34:   75 0b                   jne    0x41
  36:   68 0c e5 c3 f7          push   $0xf7c3e50c
  3b:   e8 99 5f 68 c9          call   0xc9685fd9

Code starting with the faulting instruction
===========================================
   0:   8b 40 48                mov    0x48(%eax),%eax
   3:   39 f8                   cmp    %edi,%eax
   5:   75 f7                   jne    0xfffffffe
   7:   85 f6                   test   %esi,%esi
   9:   75 0b                   jne    0x16
   b:   68 0c e5 c3 f7          push   $0xf7c3e50c
  10:   e8 99 5f 68 c9          call   0xc9685fae

and "make drivers/usb/host/ehci-hcd.s" but I'm not able to find the above code in ehci-hcd.s.

What am I doing wrong?

-- 
Ondrej Zary
