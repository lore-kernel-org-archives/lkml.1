Return-Path: <linux-kernel-owner+w=401wt.eu-S1755787AbZCEKm0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755787AbZCEKm0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 05:42:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752191AbZCEKmO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 05:42:14 -0500
Received: from h1047321.serverkompetenz.net ([85.214.67.163]:37904 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbZCEKmN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 05:42:13 -0500
X-Greylist: delayed 1811 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Mar 2009 05:42:13 EST
Message-ID: <49AFA565.6030902@ahsoftware.de>
Date: Thu, 05 Mar 2009 11:11:49 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Oops using 2.6.28.n after a lazy umount of a crypted loop-device
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

for some reason I can't remember I've done a lazy umount follwing the
deregistration of the loop-device. The commands in question are:

---------
umount -l /mnt/crypted
cryptsetup luksClose crypted
losetup -d /dev/loop1
---------

Using Kernels 2.6.28.2 and .7 this two times resulted
in an Oops like the following (both having the same Call Trace):

-----------------
BUG: unable to handle kernel paging request at 622f7377
IP: [<c013f57b>] mempool_free+0xb/0x80
*pde = 00000000
Oops: 0000 [#1] PREEMPT
last sysfs file: /sys/class/net/sit1/address
Modules linked in: sit tunnel4 tun nfsd lockd nfs_acl auth_rpcgss
exportfs sunrpc loop dm_crypt dm_mod lrw gf128mul aes_i586 aes_generic
longhaul 8250_pci 8250 serial_core ipv6 fan aic7xxx vt8231 cyblafb
uhci_hcd parport_pc i2c_viapro pcspkr scsi_transport_spi via_agp thermal
processor usbcore i2c_core parport button agpgart sg evdev
Pid: 15933, comm: loop1 Not tainted (2.6.28.7 #1) EPIA
EIP: 0060:[<c013f57b>] EFLAGS: 00010282 CPU: 0
EIP is at mempool_free+0xb/0x80
EAX: d1ebe280 EBX: d1e47360 ECX: d1d50438 EDX: 622f7373
ESI: 622f7373 EDI: d1ebe280 EBP: 00000000 ESP: d1ed8f28
  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
Process loop1 (pid: 15933, ti=d1ed8000 task=d0edc3e0 task.ti=d1ed8000)
Stack:
  d1e47360 d1fd0920 d1e47360 c01796a5 00000000 d1ebe5f0 c0179522 d813b513
  d8d30020 d1d75600 d1ffbf78 d0b7da00 d1ebeadc d1e47de0 c017922e d814e455
  0017a000 00000000 c017922e d81616c2 d5409e00 00000000 00000000 d8161700
Call Trace:
  [<c01796a5>] bio_free+0x25/0x30
  [<c0179522>] bio_put+0x22/0x30
  [<d813b513>] clone_endio+0x83/0xa0 [dm_mod]
  [<c017922e>] bio_endio+0x1e/0x20
  [<d814e455>] crypt_dec_pending+0x25/0x50 [dm_crypt]
  [<c017922e>] bio_endio+0x1e/0x20
  [<d81616c2>] loop_thread+0x362/0x3a0 [loop]
  [<d8161700>] do_lo_send_aops+0x0/0x160 [loop]
  [<c012a5c0>] autoremove_wake_function+0x0/0x30
  [<d8161360>] loop_thread+0x0/0x3a0 [loop]
  [<c012a4e8>] kthread+0x38/0x60
  [<c012a4b0>] kthread+0x0/0x60
  [<c0103fa7>] kernel_thread_helper+0x7/0x10
Code: ff 89 e8 e9 4e ff ff ff 31 f6 89 f0 83 c4 14 5b 5e 5f 5d c3 8d b6
00 00 00 00 8d bf 00 00 00 00 57 56 53 89 c7 89 d6 85 c0 74 71 <8b> 42
043b 02 7d 62 9c 5b fa 89 e0 25 00 f0 ff ff ff 40 14 8b
EIP: [<c013f57b>] mempool_free+0xb/0x80 SS:ESP 0068:d1ed8f28
---[ end trace c4cedfb39b6cc26d ]---
-----------------

I've digged something arround in drivers/block/loop.c and I assume that
loop_clr_fd() misses to stop or clear something before it destroys
needed datas the kernel-thread (loop_thread) uses. Anyway I don't have
much knowledge about all the stuff going on there, so I don't think I
will find the problem by myself without spending much time. I know using
a normal umount will be the obvious workaround, anyway I don't think the
lazy umount should result in an Oops afterwards, regardless how
reasonable the lazy umount following the deletion of the device is.

If I could help with some more infos or similar, feel free to ask.

Kind regards,

Alexander Holler

