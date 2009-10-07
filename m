Return-Path: <linux-kernel-owner+w=401wt.eu-S932903AbZJGMGO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932903AbZJGMGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 08:06:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932842AbZJGMGO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 08:06:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932774AbZJGMGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 08:06:12 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: "Nick Piggin" <npiggin@novell.com>
Cc: Christoph Hellwig <hch@lst.de>, <npiggin@suse.de>,
       <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: NULL inode->i_mapping in generic_sync_sb_inodes
References: <4ACC9E8A0200008A000439B0@novprvlin0050.provo.novell.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 07 Oct 2009 08:05:35 -0400
In-Reply-To: <4ACC9E8A0200008A000439B0@novprvlin0050.provo.novell.com> (Nick
	Piggin's message of "Tue, 06 Oct 2009 20:58:33 -0600")
Message-ID: <x49ocoj2yuo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Nick Piggin" <npiggin@novell.com> writes:

>>>> Jeff Moyer  10/07/09 12:48 AM >>>
>>Hi,
>>
>>I've come across a problem in 2.6.31 whereby the umount path on shutdown
>>Oopses like so:
>>
>>BUG: unable to handle kernel NULL pointer dereference at 00000070
>>IP: [] generic_sync_sb_inodes+0x2ca/0x34b
>>*pdpt = 00000000220b1001 *pde = 0000000099419067 
>>Oops: 0000 [#1] SMP 
>>last sysfs file:
>>/sys/devices/pci0000:00/0000:00:07.0/0000:0d:00.0/0000:0e:08.0/host0/target0:1:0>/0:1:0:0/block/sda/removable
>>Modules linked in: fcoe libfcoe libfc scsi_transport_fc scsi_tgt ipv6 xts lrw
>>gf128mul sha256_generic cbc dm_crypt dm_round_robin dm_multipath dm_snapshot
>>dm_mirror dm_region_hash dm_log dm_zero dm_mod linear raid10 raid456 raid6_pq
>>async_xor async_memcpy async_tx xor raid1 raid0 nfs lockd fscache nfs_acl
>>auth_rpcgss sunrpc radeon mptsas ttm drm_kms_helper mptscsih drm mptbase
>>i2c_algo_bit i2c_core scsi_transport_sas bnx2 iscsi_ibft pcspkr edd iscsi_tcp
>>libiscsi_tcp libiscsi scsi_transport_iscsi squashfs cramfs
>>
>>Pid: 5082, comm: grub Tainted: G        W  (2.6.31-27.el6.i686 #1) PowerEdge
>>1955
>>EIP: 0060:[] EFLAGS: 00010246 CPU: 0
>>EIP is at generic_sync_sb_inodes+0x2ca/0x34b
>>EAX: ec45ae14 EBX: 00000000 ECX: 00000000 EDX: c0510e4f
>>ESI: ec45ae04 EDI: ec45b1c4 EBP: f25fdf38 ESP: f25fdf10
>>DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
>>Process grub (pid: 5082, ti=f25fc000 task=ef0cc6f0 task.ti=f25fc000)
>>Stack:
>>00000246 00000001 f422fa6c 000abc70 f422fa64 f422fa54 8fd7ae23 f422f970
>><0> 00000001 f25fdf68 f25fdf74 c0510f0e 00000000 00000001 00000000 7fffffff
>><0> 00000000 00000000 00000000 ffffffff 7fffffff 00000000 8fd7ae23 f422f970
>>Call Trace:
>>[] ? sync_inodes_sb+0x74/0x8c
>>[] ? __sync_filesystem+0x41/0x74
>>[] ? sync_filesystems+0x96/0xed
>>[] ? sys_sync+0x27/0x4a
>>[] ? sysenter_do_call+0x12/0x38
>>Code: 0f 85 83 00 00 00 8b b3 e4 00 00 00 81 c3 e4 00 00 00 31 ff 89 5d ec 83
>>ee 10 eb 4b f6 86 6c 02 00 00 78 75 3c 8b 9e 3c 01 00 00 <83> 7b 70 00 74 30 89
>>f0 e8 d8 61 ff ff b8 cc f4 a0 c0 e8 e0 dd 
>>EIP: [] generic_sync_sb_inodes+0x2ca/0x34b SS:ESP 0068:f25fdf10
>>CR2: 0000000000000070
>>---[ end trace 8171140d16b04470 ]---
>>
>>The Oops is in fs/fs-writeback.c:568:
>>
>>list_for_each_entry(inode, &sb->s_inodes, i_sb_list) {
>>struct address_space *mapping;
>>
>>if (inode->i_state &
>>(I_FREEING|I_CLEAR|I_WILL_FREE|I_NEW))
>>continue;
>>mapping = inode->i_mapping;
>>if (mapping->nrpages == 0)    <==== BUG
>>
>>Any idea how that can happen?  Maybe a race in the umount path?
>
> Possibly. I can't quite see how it could happen in the core code, because
> we should always have i_state flags set if the inode is new or being
> freed. It might happen that a caller is mistakenly unlocking it too
> early or something, though.
>
> Is this repeatable?

I believe so.  I'm having a hard time getting this particular system to
install, but once I have it reinstalled, I'll see if we get this problem
again.  I'm pretty sure I've seen it at least twice on this machine.

hch mentioned that it would be good to instrument to what file system
the inode belonged.  Anything else you'd like to look at?

Thanks a ton!
Jeff
