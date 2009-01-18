Return-Path: <linux-kernel-owner+w=401wt.eu-S1754371AbZARWXc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754371AbZARWXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2009 17:23:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752210AbZARWXX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Jan 2009 17:23:23 -0500
Received: from vs02.svr02.mucip.net ([83.170.6.69]:38482 "EHLO
	mailout.mucip.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbZARWXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2009 17:23:22 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Jan 2009 17:23:22 EST
Date: Sun, 18 Jan 2009 23:13:29 +0100
From: Bernhard Schmidt <berni@birkenwald.de>
To: linux-kernel@vger.kernel.org
Cc: linux-cifs-client@lists.samba.org
Subject: BUG: Possible cifs+IPv6-Regression 2.6.27.4 -> 2.6.27.9
Message-ID: <20090118221329.GA12742@pest>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

first off, this might be an Ubuntu regression and I've also opened a
bugreport there, but I think it is in mainline as well. Maybe someone
familiar with the code can see the problem at first glance without too
much debugging.

Since quite a while I've been mounting my CIFS fileserver at home
(running Samba 3.2) using IPv6 transport:

# mount -t cifs -o user=berni,ip=2001:xxx::yy //fileserv/pub /pub

This used to work fine with the Ubuntu kernel 2.6.27-9, which according
to the changelog is 2.6.27.4-based. Ubuntu kernel 2.6.27-11 (currently
in the -proposed repository, so not rolled out yet, appears to be based
on 2.6.27.9) throws a BUG in my face (and does not mount, obviously).
Since according to the Ubuntu changelog the only changes in cifs have
been the ones in -stable 2.6.27.7 to 2.6.27.8, namely

  * cifs: Reduce number of socket retries in large write path
  * cifs: Fix error in smb_send2
  * cifs: Fix cifs reconnection flags
  * cifs: remove unused list, add new cifs sock list to prepare for
    mount/umount fix
  * cifs: clean up server protocol handling
  * cifs: disable sharing session and tcon and add new TCP sharing code
  * cifs: reinstate sharing of SMB sessions sans races
  * cifs: minor cleanup to cifs_mount
  * cifs: reinstate sharing of tree connections
  * cifs: Fix build break
  * cifs: Fix check for tcon seal setting and fix oops on failed mount
    from earlier patch
  * cifs: prevent cifs_writepages() from skipping unwritten pages
  * cifs: fix check for dead tcon in smb_init

I assume it's an upstream problem.

[28816.788084]  CIFS VFS: Error connecting to socket. Aborting operation
[28816.788094]  CIFS VFS: cifs_mount failed w/return code = -113
[28816.788121] BUG: unable to handle kernel paging request at 69000030
[28816.788125] IP: [<f9bfde00>] :cifs:cifs_read_super+0xa0/0x1e0
[28816.788140] *pde = 00000000
[28816.788144] Oops: 0000 [#1] SMP
[28816.788148] Modules linked in: nls_utf8 ufs qnx4 hfsplus hfs minix
ntfs vfat msdos fat jfs xfs reiserfs ext2 nls_cp437 cifs af_packet
binfmt_misc rfcomm bridge stp bnep sco l2cap bluetooth kvm_amd kvm ppdev
tun ipv6 pci_slot container sbs sbshc video output battery
iptable_filter ip_tables x_tables ac parport_pc lp parport serio_raw
psmouse snd_hda_intel snd_pcm_oss snd_mixer_oss snd_pcm pcspkr
snd_seq_dummy k8temp snd_seq_oss snd_seq_midi snd_rawmidi
snd_seq_midi_event snd_seq snd_timer snd_seq_device snd soundcore
i2c_piix4 snd_page_alloc i2c_core evdev dm_multipath scsi_dh pl2303
usbserial fglrx(P) agpgart wmi button shpchp pci_hotplug ext3 jbd
mbcache sr_mod cdrom pata_acpi sd_mod crc_t10dif pata_atiixp sg usbhid
hid usb_storage libusual ata_generic ahci ohci_hcd ehci_hcd libata
usbcore scsi_mod dock r8169 mii dm_mirror dm_log dm_snapshot dm_mod
thermal processor fan fbcon tileblit font bitblit softcursor fuse
[28816.788215]
[28816.788219] Pid: 20540, comm: mount.cifs Tainted: P
(2.6.27-11-generic #1)
[28816.788222] EIP: 0060:[<f9bfde00>] EFLAGS: 00010286 CPU: 0
[28816.788232] EIP is at cifs_read_super+0xa0/0x1e0 [cifs]
[28816.788234] EAX: 00000044 EBX: 69000000 ECX: ffffffff EDX: 00000046
[28816.788237] ESI: d43b5000 EDI: ffffff8f EBP: d42a1e8c ESP: d42a1e6c
[28816.788239]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
[28816.788242] Process mount.cifs (pid: 20540, ti=d42a0000 task=d1b48c90
task.ti=d42a0000)
[28816.788245] Stack: f9c24428 ffffff8f d31aa000 d8951e00 0000004e
d8951e00 d8951e00 00000000
[28816.788252]        d42a1eb0 f9bfdfa9 00000000 f6603e80 fffffff4
d31aa000 f6603e80 00000000
[28816.788258]        f9c38520 d42a1ed8 c01b468e d43b5000 f6603e80
d31aa000 00000040 d4086000
[28816.788264] Call Trace:
[28816.788270]  [<f9bfdfa9>] ? cifs_get_sb+0x69/0xc0 [cifs]
[28816.788282]  [<c01b468e>] ? vfs_kern_mount+0x5e/0x130
[28816.788292]  [<c01b47be>] ? do_kern_mount+0x3e/0xe0
[28816.788296]  [<c01cccff>] ? do_new_mount+0x6f/0x90
[28816.788301]  [<c01cd242>] ? do_mount+0x1d2/0x1f0
[28816.788306]  [<c01ca95d>] ? exact_copy_from_user+0x4d/0xa0
[28816.788310]  [<c01caf6e>] ? copy_mount_options+0x6e/0xd0
[28816.788314]  [<c01cd2f1>] ? sys_mount+0x91/0xc0
[28816.788318]  [<c0103f7b>] ? sysenter_do_call+0x12/0x2f
[28816.788323]  =======================
[28816.788324] Code: 65 c6 8b 43 30 8b 55 f0 c6 04 10 00 8b 45 e8 89 f1
89 da 89 04 24 8b 45 ec e8 fd dc 00 00 85 c0 89 c7 74 57 8b 45 08 85 c0
74 30 <8b> 43 30 85 c0 74 0c e8 a4 f0 5a c6 c7 43 30 00 00 00 00 8b 43
[28816.788354] EIP: [<f9bfde00>] cifs_read_super+0xa0/0x1e0 [cifs]
SS:ESP 0068:d42a1e6c
[28816.788365] ---[ end trace 9d71176ecad6924f ]---

Do you need any further information? As far as I can see the Ubuntu
Jaunty packaged version of 2.6.28 works fine, but I did not run
extensive tests on it.

Bernhard
