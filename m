Return-Path: <linux-kernel-owner+w=401wt.eu-S1762945AbXGLTPW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762945AbXGLTPW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 15:15:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753076AbXGLTPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 15:15:10 -0400
Received: from mx1.suse.de ([195.135.220.2]:49006 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755382AbXGLTPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 15:15:09 -0400
Message-ID: <46967D7D.5090204@suse.com>
Date: Thu, 12 Jul 2007 15:14:05 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: tony@tvortex.net
Cc: linux-kernel@vger.kernel.org
Subject: Re: reiserfs fs/reiserfs/bitmap.c:1287
References: <15366.199.125.14.2.1184261266.squirrel@localmail-dr.mcsimons.com>
In-Reply-To: <15366.199.125.14.2.1184261266.squirrel@localmail-dr.mcsimons.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Anthony Simons wrote:
> Was decompressing a newly compiled kernel to my usb drive and received the
> below error almost immediatly after I began.
> 
> [tonys@squishy ~]$ uname -a
> Linux squishy 2.6.21-1.3228.fc7 #1 SMP Tue Jun 12 15:37:31 EDT 2007 i686
> i686 i386 GNU/Linux
> 
> After I recive the error, a simple ls just won't work.

That's expected. Locks that you'll need to acquire for the ls to
complete were held by process that BUG()'d.

This error corresponds to this check in reiserfs_cache_bitmap_metadata():

        /* The first bit must ALWAYS be 1 */
        BUG_ON(info->first_zero_hint == 0);

Bit 0 corresponds to the bitmap block itself, so it must *always* be set.

Can you run reiserfsck on the file system? I have a patch set in
development that handles errors like these a bit more gracefully.

- -Jeff

> 
> ------------[ cut here ]------------
> kernel BUG at fs/reiserfs/bitmap.c:1287!
> invalid opcode: 0000 [#1]
> SMP
> last sysfs file: /block/sdb/size
> Modules linked in: ext2 usb_storage nvidia(P)(U) autofs4 hidp rfcomm l2cap
> bluetooth sunrpc cpufreq_ondemand acpi_cpufreq ext3 jbd mbcache dm_mirror
> dm_multipath dm_mod video sbs i2c_ec button dock battery ac ipv6 lp loop
> parport_pc parport arc4 ecb blkcipher rc80211_simple irda snd_intel8x0m
> crc_ccitt bcm43xx_mac80211 ssb iTCO_wdt mac80211 snd_intel8x0
> iTCO_vendor_support snd_ac97_codec serio_raw cfg80211 tg3 ac97_bus
> snd_seq_dummy i2c_core snd_seq_oss fw_ohci fw_core sr_mod cdrom
> snd_seq_midi_event snd_seq snd_seq_device snd_pcm_oss snd_mixer_oss joydev
> snd_pcm snd_timer snd soundcore snd_page_alloc sg ata_generic ata_piix
> libata sd_mod scsi_mod reiserfs ehci_hcd ohci_hcd uhci_hcd
> CPU:    0
> EIP:    0060:[<f88a306c>]    Tainted: P       VLI
> EFLAGS: 00210246   (2.6.21-1.3228.fc7 #1)
> EIP is at reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
> eax: e6461000   ebx: f8896314   ecx: 00000000   edx: e6460ffc
> esi: f5a54668   edi: 00000000   ebp: 000000c5   esp: e4a2dd78
> ds: 007b   es: 007b   fs: 00d8  gs: 0033  ss: 0068
> Process tar (pid: 6860, ti=e4a2d000 task=e528e710 task.ti=e4a2d000)
> Stack: f5a54668 0018a000 e4bede00 f88a313d 00000400 04040404 e4bede00
> e4bede00
>        f8896000 f8896314 e4bede00 d71cbe00 d71cbe60 f88a36d4 fffffff4
> 000041ed
>        00000000 f88adbde eab6be0c e6394950 00000001 e3af31d0 e4bede00
> d71cbe60
> Call Trace:
>  [<f88a313d>] reiserfs_read_bitmap_block+0xc9/0xd3 [reiserfs]
>  [<f88a36d4>] reiserfs_choose_packing+0x4a/0x78 [reiserfs]
>  [<f88adbde>] reiserfs_new_inode+0xb8/0x826 [reiserfs]
>  [<f88c35e7>] do_journal_begin_r+0x73/0x28d [reiserfs]
>  [<c04850e3>] d_splice_alias+0xdd/0xe3
>  [<f88c389a>] journal_begin+0x99/0xd0 [reiserfs]
>  [<f88a9a79>] reiserfs_mkdir+0x183/0x2c2 [reiserfs]
>  [<f88c6e0b>] reiserfs_permission+0x0/0x1e [reiserfs]
>  [<c047bd7c>] vfs_mkdir+0xbd/0x125
>  [<c047e226>] sys_mkdirat+0x88/0xba
>  [<c0450fcd>] audit_syscall_exit+0x294/0x2b0
>  [<c0450d0f>] audit_syscall_entry+0x10d/0x137
>  [<c047e277>] sys_mkdir+0x1f/0x23
>  [<c0404f70>] syscall_call+0x7/0xb
>  =======================
> Code: 00 00 0f a3 0a 19 c0 85 c0 75 0a 66 ff 43 02 8d 04 39 66 89 03 49 83
> f9 ff 75 e7 8b 46 18 83 ea 04 39 c2 73 ba 66 83 3b 00 75 04 <0f> 0b eb fe
> 5b 5e 5f c3 55 89 d5 57 89 c7 56 53 83 ec 14 8b 90
> EIP: [<f88a306c>] reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
> SS:ESP 0068:e4a2dd78
> BUG: warning at kernel/exit.c:798/do_exit() (Tainted: P      )
>  [<c04294f3>] do_exit+0x54/0x6d3
>  [<c040655c>] die+0x21b/0x240
>  [<c0406967>] do_invalid_op+0x0/0xab
>  [<c0406a09>] do_invalid_op+0xa2/0xab
>  [<f88a306c>] reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
>  [<f88e378d>] scsi_request_fn+0x2d3/0x31d [scsi_mod]
>  [<c04d9a27>] blk_remove_plug+0x58/0x64
>  [<c042d6e7>] getnstimeofday+0x30/0xb6
>  [<c04394c4>] ktime_get_ts+0x16/0x44
>  [<c0454c38>] delayacct_end+0x70/0x77
>  [<c0454d26>] __delayacct_blkio_end+0x5b/0x5e
>  [<c0600b39>] __wait_on_bit+0x50/0x58
>  [<c0601a84>] error_code+0x7c/0x84
>  [<f88a306c>] reiserfs_cache_bitmap_metadata+0x6c/0x74 [reiserfs]
>  [<f88a313d>] reiserfs_read_bitmap_block+0xc9/0xd3 [reiserfs]
>  [<f88a36d4>] reiserfs_choose_packing+0x4a/0x78 [reiserfs]
>  [<f88adbde>] reiserfs_new_inode+0xb8/0x826 [reiserfs]
>  [<f88c35e7>] do_journal_begin_r+0x73/0x28d [reiserfs]
>  [<c04850e3>] d_splice_alias+0xdd/0xe3
>  [<f88c389a>] journal_begin+0x99/0xd0 [reiserfs]
>  [<f88a9a79>] reiserfs_mkdir+0x183/0x2c2 [reiserfs]
>  [<f88c6e0b>] reiserfs_permission+0x0/0x1e [reiserfs]
>  [<c047bd7c>] vfs_mkdir+0xbd/0x125
>  [<c047e226>] sys_mkdirat+0x88/0xba
>  [<c0450fcd>] audit_syscall_exit+0x294/0x2b0
>  [<c0450d0f>] audit_syscall_entry+0x10d/0x137
>  [<c047e277>] sys_mkdir+0x1f/0x23
>  [<c0404f70>] syscall_call+0x7/0xb
>  =======================
> 
> 
> 


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFGln18LPWxlyuTD7IRAmDRAJ48kzuX8OX7vGvPY29O9G7EdEB6NACfbfme
VwqSa01lXDDeJYl7j0FMZYI=
=yWNQ
-----END PGP SIGNATURE-----
