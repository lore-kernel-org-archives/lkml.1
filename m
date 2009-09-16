Return-Path: <linux-kernel-owner+w=401wt.eu-S1758973AbZIPTyR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758973AbZIPTyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Sep 2009 15:54:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754662AbZIPTyQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Sep 2009 15:54:16 -0400
Received: from pne-smtpout2-sn1.fre.skanova.net ([81.228.11.159]:59729 "EHLO
	pne-smtpout2-sn1.fre.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754545AbZIPTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Sep 2009 15:54:15 -0400
X-Greylist: delayed 4170 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Sep 2009 15:54:15 EDT
From: "Lars Ericsson" <Lars_Ericsson@telia.com>
To: <David.Woodhouse@intel.com>, <sachinp@in.ibm.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Oops in drivers\base\firmware_class
Date: Wed, 16 Sep 2009 20:44:43 +0200
Message-ID: <CEAB105C14FD4F848BE08388151DB4E2@gotws1589>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_0255_01CA370E.85CB3F40"
X-Mailer: Microsoft Office Outlook 11
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Thread-Index: Aco2/cGdFyAcNArPTjGFRhkeOcoo7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

------=_NextPart_000_0255_01CA370E.85CB3F40
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi,

I have discovered a Oops in the firmware_loading_store function. 
At first it looks like a timing issue but after adding a BUG_ON test,
it fails every time. 

drivers\base\firmware_class:
------------------------------
 541 01c0 F6463401 	testb $1,52(%esi)
 542 01c4 0F843FFF 	je .L38
 542      FFFF
 543              	.loc 1 174 0
 544 01ca 8B4630   	movl 48(%esi),%eax
 545 01cd 8B4004   	movl 4(%eax),%eax	<---- Oops
 546 01d0 E8FCFFFF 	call vfree
 546      FF

The code that fails was introduced in commit
6e03a201bbe8137487f340d26aa662110e324b20 

Attached you will find the:
- Oops with the vanilla 2.6.31
- The BUG_ON patch
- Oops with the patched 2.6.31

/Lars

------=_NextPart_000_0255_01CA370E.85CB3F40
Content-Type: text/plain;
	name="Vanilla_Opps.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="Vanilla_Opps.txt"

[    7.249453] rt61pci 0000:00:09.0: firmware: requesting rt2561s.bin
[    7.314512] BUG: unable to handle kernel NULL pointer dereference at =
00000004
[    7.315639] IP: [<d04d51cd>] firmware_loading_store+0xed/0x160 =
[firmware_class]
[    7.315639] *pde =3D 00000000
[    7.315639] Oops: 0000 [#1] PREEMPT
[    7.315639] last sysfs file: =
/sys/devices/pci0000:00/0000:00:09.0/firmware/0000:00:09.0/loading
[    7.315639] Modules linked in: arc4 ecb cryptomgr crypto_blkcipher =
aead pcompress crypto_hash crypto_algapi rt61pci rt2x00pci rt2x00lib =
firmware_class mac80211 input_polldev crc_itu_t eeprom_93cx6 cfg80211 =
ndccanram ndccan ndcser(P) ndcscan(P) eu16550(P) ndccon(P)
[    7.315639]
[    7.315639] Pid: 1004, comm: echo Tainted: P           (2.6.31 #1)
[    7.315639] EIP: 0060:[<d04d51cd>] EFLAGS: 00010202 CPU: 0
[    7.315639] EIP is at firmware_loading_store+0xed/0x160 =
[firmware_class]
[    7.315639] EAX: 00000000 EBX: d04d50e0 ECX: 0000000a EDX: 00000028
[    7.315639] ESI: cf65ca80 EDI: cea29c00 EBP: cea29c08 ESP: cf777f2c
[    7.315639]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    7.315639] Process echo (pid: 1004, ti=3Dcf776000 task=3Dcf755aa0 =
task.ti=3Dcf776000)
[    7.315639] Stack:
[    7.315639]  d04d50e0 cea29c00 00000002 c028051d 00000002 c0414c40 =
ce9c0420 c01c9c98
[    7.315639] <0> 00000002 c0414c40 00000002 b7f15000 ce9c1e80 cf44c000 =
c01c9ce6 ce9c1e94
[    7.315639] <0> cf44c000 b7f15000 00000002 c01c9cb0 c018d362 cf777f9c =
cf44c000 fffffff7
[    7.315639] Call Trace:
[    7.315639]  [<d04d50e0>] ? firmware_loading_store+0x0/0x160 =
[firmware_class]
[    7.315639]  [<c028051d>] ? dev_attr_store+0x1d/0x20
[    7.315639]  [<c01c9c98>] ? flush_write_buffer+0x38/0x50
[    7.315639]  [<c01c9ce6>] ? sysfs_write_file+0x36/0x60
[    7.315639]  [<c01c9cb0>] ? sysfs_write_file+0x0/0x60
[    7.315639]  [<c018d362>] ? vfs_write+0x82/0xf0
[    7.315639]  [<c018d47c>] ? sys_write+0x3c/0x70
[    7.315639]  [<c0102ba1>] ? syscall_call+0x7/0xb
[    7.315639] Code: 91 c9 ef 3b 5e 3c 7c ed eb b5 8d 74 26 00 83 f8 ff =
0f 85 50 ff ff ff e9 6a ff ff ff 89 f6 f6 46 34 01 0f 84 3f ff ff ff 8b =
46 30 <8b> 40 04 e8 5b 05 cb ef 31 c9 8b 56 3c 8b 46 38 8b 5e 30 68 61
[    7.315639] EIP: [<d04d51cd>] firmware_loading_store+0xed/0x160 =
[firmware_class] SS:ESP 0068:cf777f2c
[    7.315639] CR2: 0000000000000004
[    7.540848] ---[ end trace 6ebe83c102d3b046 ]---

------=_NextPart_000_0255_01CA370E.85CB3F40
Content-Type: application/octet-stream;
	name="BUG_ON_firmware_class.c.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="BUG_ON_firmware_class.c.patch"

diff -Nurp 1/linux-2.6.31/drivers/base/firmware_class.c =
linux/linux-2.6.31/drivers/base/firmware_class.c=0A=
--- ./drivers/base/firmware_class.c	2009-09-16 14:17:45.000000000 +0200=0A=
+++ ./drivers/base/firmware_class.c	2009-09-16 14:20:46.000000000 +0200=0A=
@@ -171,6 +172,8 @@ static ssize_t firmware_loading_store(st=0A=
 		break;=0A=
 	case 0:=0A=
 		if (test_bit(FW_STATUS_LOADING, &fw_priv->status)) {=0A=
+			/* =
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dco=
mmitdiff;h=3D6e03a201bbe8137487f340d26aa662110e324b20 */=0A=
+			BUG_ON(fw_priv->fw =3D=3D NULL);=0A=
 			vfree(fw_priv->fw->data);=0A=
 			fw_priv->fw->data =3D vmap(fw_priv->pages,=0A=
 						 fw_priv->nr_pages,=0A=

------=_NextPart_000_0255_01CA370E.85CB3F40
Content-Type: text/plain;
	name="BUG_ON_Oops.txt"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="BUG_ON_Oops.txt"

[    7.242449] ------------[ cut here ]------------
[    7.243706] Kernel BUG at d04d523e [verbose debug info unavailable]
[    7.243706] invalid opcode: 0000 [#1] PREEMPT
[    7.243706] last sysfs file: =
/sys/devices/pci0000:00/0000:00:09.0/firmware/0000:00:09.0/loading
[    7.243706] Modules linked in: arc4 ecb cryptomgr crypto_blkcipher =
aead pcompress crypto_hash crypto_algapi rt61pci rt2x00pci rt2x00lib =
firmware_class mac80211 input_polldev crc_itu_t eeprom_93cx6 cfg80211 =
ndccanram ndccan ndcser(P) ndcscan(P) eu16550(P) ndccon(P)
[    7.243706]
[    7.243706] Pid: 1004, comm: echo Tainted: P           (2.6.31 #1)
[    7.243706] EIP: 0060:[<d04d523e>] EFLAGS: 00010246 CPU: 0
[    7.243706] EIP is at firmware_loading_store+0x15e/0x170 =
[firmware_class]
[    7.243706] EAX: 00000000 EBX: d04d50e0 ECX: 0000000a EDX: 00000028
[    7.243706] ESI: cf4f2a20 EDI: cf4ffc00 EBP: cf4ffc08 ESP: cea37f2c
[    7.243706]  DS: 007b ES: 007b FS: 0000 GS: 0000 SS: 0068
[    7.243706] Process echo (pid: 1004, ti=3Dcea36000 task=3Dcf6c2380 =
task.ti=3Dcea36000)
[    7.243706] Stack:
[    7.243706]  d04d50e0 cf4ffc00 00000002 c028051d 00000002 c0414c40 =
cf4fd420 c01c9c98
[    7.243706] <0> 00000002 c0414c40 00000002 b7fc8000 cf636e80 cf471980 =
c01c9ce6 cf636e94
[    7.243706] <0> cf471980 b7fc8000 00000002 c01c9cb0 c018d362 cea37f9c =
cf471980 fffffff7
[    7.243706] Call Trace:
[    7.243706]  [<d04d50e0>] ? firmware_loading_store+0x0/0x170 =
[firmware_class]
[    7.243706]  [<c028051d>] ? dev_attr_store+0x1d/0x20
[    7.243706]  [<c01c9c98>] ? flush_write_buffer+0x38/0x50
[    7.243706]  [<c01c9ce6>] ? sysfs_write_file+0x36/0x60
[    7.243706]  [<c01c9cb0>] ? sysfs_write_file+0x0/0x60
[    7.243706]  [<c018d362>] ? vfs_write+0x82/0xf0
[    7.243706]  [<c018d47c>] ? sys_write+0x3c/0x70
[    7.243706]  [<c0102ba1>] ? syscall_call+0x7/0xb
[    7.243706] Code: 66 34 fe e9 14 ff ff ff 8b 47 08 68 1c 5f 4d d0 50 =
89 f8 e8 65 b2 da ef 50 68 c3 5f 4d d0 e8 da 3c c5 ef 83 c4 10 e9 ea fe =
ff ff <0f> 0b eb fe 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 cd
[    7.243706] EIP: [<d04d523e>] firmware_loading_store+0x15e/0x170 =
[firmware_class] SS:ESP 0068:cea37f2c
[    7.458557] ---[ end trace 604593037057054f ]---

------=_NextPart_000_0255_01CA370E.85CB3F40--

