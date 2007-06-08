Return-Path: <linux-kernel-owner+w=401wt.eu-S937700AbXFHOxb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937700AbXFHOxb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2007 10:53:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761035AbXFHOxX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jun 2007 10:53:23 -0400
Received: from py-out-1112.google.com ([64.233.166.177]:50350 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645AbXFHOxW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2007 10:53:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=TYEASFOGn4UN3CQ/17vQ+6bHCytjQhoO1vKatJwGslt7pGT5sr9kZnWxNEw4QaAVR82pV61U9rr+AIgf4+vtrRu2cp0cAiXlPorQxTMSaDd1SG9kDVGCcqJO19ZQMWgd5vljerHJfBR9uX3VmD97SlQad3fa2s3njUHA3JysLDI=
Message-ID: <f9be06770706080753m41959da2m2034e428854c1c0b@mail.gmail.com>
Date: Fri, 8 Jun 2007 10:53:21 -0400
From: "Karl Pickett" <karl.pickett@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Kernel BUG when using corrupted ext3 fs
In-Reply-To: <f9be06770706080751y4bbb60d0q3a2286d8e2b576f6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <f9be06770706080751y4bbb60d0q3a2286d8e2b576f6@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I had to hard shutdown a fc6 machine due to vmware and nvidia doing
ridiculous things to my screen resolution and locking up.  ugh.
Anyway, upon reboot it recovers the journal and mounts / rw fine.
Then rc.sysinit tries to delete various things from /tmp (.ICE-unix,
.font stuff, etc), kernel shows a BUG, and boot stops.  Booting from a
fc7 live cd and trying to mount /dev/sda2 rw and delete /tmp/* also
causes a BUG.  This dump is from fc7:


eth0: no IPv6 routers present
kjournald starting.  Commit interval 5 seconds
EXT3 FS on sda2, internal journal
EXT3-fs: mounted filesystem with ordered data mode.
SELinux: initialized (dev sda2, type ext3), uses xattr
inode_doinit_with_dentry:  getxattr returned 5 for dev=sda2 ino=13271075
EXT3-fs warning (device sda2): ext3_unlink: Deleting nonexistent file
(13271075), 0
list_add corruption. next->prev should be prev (e8a1412c), but was
e8b4ba78. (next=e8b4ba78).
------------[ cut here ]------------
kernel BUG at lib/list_debug.c:27!
invalid opcode: 0000 [#1]
SMP
last sysfs file: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/enable
Modules linked in: ipv6 dm_mirror dm_multipath video sbs i2c_ec button
dock battery ac lp iTCO_wdt tg3 iTCO_vendor_support i2c_i801 i2c_core
parport_pc serio_raw parport sg pcspkr ext3 jbd mbcache squashfs
dm_snapshot dm_mod loop sd_mod ata_piix ehci_hcd ahci ata_generic
libata uhci_hcd sr_mod scsi_mod cdrom
CPU:    0
EIP:    0060:[<c04e85bf>]    Not tainted VLI
EFLAGS: 00210282   (2.6.21-1.3194.fc7 #1)
EIP is at __list_add+0x26/0x5c
eax: 00000061   ebx: e8b4ba78   ecx: 00200086   edx: 00200000
esi: e8b4ba9c   edi: c1964000   ebp: e89bf48c   esp: e8a80eb8
ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
Process rm (pid: 2511, ti=e8a80000 task=dfb4c710 task.ti=e8a80000)
Stack: c069e0d0 e8a1412c e8b4ba78 e8b4ba78 00000000 e8b4ba9c f8a5d704 e89bf48c
       e8997710 e8b4b634 e8b4b6cc e89bf48c e8b4ba04 e8b4ba78 e8997710 00000b00
       00000195 e8b4ba9c 00000000 e8b4b6cc e89bf48c f8a5e593 e8a03400 00000000
Call Trace:
 [<f8a5d704>] ext3_orphan_add+0x123/0x153 [ext3]
 [<f8a5e593>] ext3_unlink+0x13a/0x188 [ext3]
 [<c047c6ed>] vfs_unlink+0x9f/0xd5
 [<c047e0ad>] do_unlinkat+0x8b/0x119
 [<c047fd52>] sys_getdents64+0x9b/0xa5
 [<c0404f70>] syscall_call+0x7/0xb
 =======================
Code: 83 c4 0c 5b c3 56 53 89 c3 83 ec 10 8b 41 04 39 d0 74 1c 89 4c
24 0c 89 54 24 04 89 44 24 08 c7 04 24 d0 e0 69 c0 e8 8b f1 f3 ff <0f>
0b eb fe 8b 32 39 ce 74 1c 89 54 24 0c 89 74 24 08 89 4c 24
EIP: [<c04e85bf>] __list_add+0x26/0x5c SS:ESP 0068:e8a80eb8
BUG: warning at kernel/exit.c:798/do_exit() (Not tainted)
 [<c04294f3>] do_exit+0x54/0x6d3
 [<c040655c>] die+0x21b/0x240
 [<c0406967>] do_invalid_op+0x0/0xab
 [<c0406a09>] do_invalid_op+0xa2/0xab
 [<c04e85bf>] __list_add+0x26/0x5c
 [<c0427711>] vprintk+0x290/0x2c9
 [<c049085b>] __getblk+0x3b/0x286
 [<f8a20b1c>] do_get_write_access+0x444/0x471 [jbd]
 [<c060190c>] error_code+0x7c/0x84
 [<c04e85bf>] __list_add+0x26/0x5c
 [<f8a5d704>] ext3_orphan_add+0x123/0x153 [ext3]
 [<f8a5e593>] ext3_unlink+0x13a/0x188 [ext3]
 [<c047c6ed>] vfs_unlink+0x9f/0xd5
 [<c047e0ad>] do_unlinkat+0x8b/0x119
 [<c047fd52>] sys_getdents64+0x9b/0xa5
 [<c0404f70>] syscall_call+0x7/0xb
 =======================


I did an fsck -f from the fc7 live cd and now it boots.
