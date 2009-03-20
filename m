Return-Path: <linux-kernel-owner+w=401wt.eu-S1754360AbZCTWZj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754360AbZCTWZj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:25:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752685AbZCTWZa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:25:30 -0400
Received: from thunk.org ([69.25.196.29]:59513 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060AbZCTWZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:25:28 -0400
Date: Fri, 20 Mar 2009 18:25:22 -0400
From: Theodore Tso <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: Lockdep problem involving sysfs_mutex in ext4 in linux-next
Message-ID: <20090320222522.GB4559@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Kay Sievers <kay.sievers@vrfy.org>
References: <E1LiURX-0000jG-Lx@closure.thunk.org> <1237071908.8939.788.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1237071908.8939.788.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 15, 2009 at 12:05:08AM +0100, Peter Zijlstra wrote:
> On Sat, 2009-03-14 at 10:02 -0400, Theodore Ts'o wrote:
> > I'm occasionally seeing a circular locking dependency in linux-next when
> > I unmount an ext4 filesystem, apparently involving sysfs_mutex in
> > sysfs_addrm_start(), and I have no idea what's going on.  Some help from
> > kobject experts would be greatly appreciated.  I assume I must be doing
> > something wrong.  I took the basic pattern from btrfs, but I suspect I
> > may have broken some of the kobject lifetime rules when I adapted what I
> > needed for ext4.
> > 
> > It doesn't happen all the time, and it seems to be caused by how I'm
> > releasing the ext4's sysfs kobject.  In ext4_put_super():
> > 
> > 	kobject_put(&sbi->s_kobj);
> > 	wait_for_completion(&sbi->s_kobj_unregister);
> 
> Right that would require sysfs_mutex() while you're holding s_lock.

Really?  I can't see anywhere else in the kernel where code outside of
fs/sysfs which grabs sysfs_mutex?

> And here you snipped the interesting bit here it tells us how you
> normally have the reverse lock order, namely:
> 
>  sysfs_mutex.
>    s_lock

Ok, here's another such report:

[42993.140759] the existing dependency chain (in reverse order) is:
[42993.140762] 
[42993.140762] -> #4 (&type->s_lock_key#6){--..}:
[42993.140769]        [<c0162845>] __lock_acquire+0x9a6/0xb19
[42993.140776]        [<c0162a13>] lock_acquire+0x5b/0x81
[42993.140780]        [<c04c402a>] __mutex_lock_common+0xdc/0x33a
[42993.140787]        [<c04c432f>] mutex_lock_nested+0x33/0x3b
[42993.140791]        [<c01b7493>] lock_super+0x26/0x28
[42993.140795]        [<c02173c1>] ext4_orphan_add+0x1ab/0x1ca
[42993.140801]        [<c020fc39>] ext4_setattr+0x19b/0x2de
[42993.140805]        [<c01c69d9>] notify_change+0x164/0x2af
[42993.140816]        [<c01b54f3>] do_truncate+0x6b/0x84
[42993.140822]        [<c01bea2b>] may_open+0x196/0x19c
[42993.140826]        [<c01bf000>] do_filp_open+0x341/0x680
[42993.140830]        [<c01b4906>] do_sys_open+0x47/0xbc
[42993.140834]        [<c01b49c7>] sys_open+0x23/0x2b
[42993.140839]        [<c0117ff6>] syscall_call+0x7/0xb
[42993.140844]        [<ffffffff>] 0xffffffff
[42993.140852] 
[42993.140853] -> #3 (jbd2_handle){--..}:
[42993.140858]        [<c0162845>] __lock_acquire+0x9a6/0xb19
[42993.140862]        [<c0162a13>] lock_acquire+0x5b/0x81
[42993.140866]        [<c0235130>] jbd2_journal_start+0xea/0xf7
[42993.140871]        [<c021ce94>] ext4_journal_start_sb+0x49/0x69
[42993.140876]        [<c020fc20>] ext4_setattr+0x182/0x2de
[42993.140880]        [<c01c69d9>] notify_change+0x164/0x2af
[42993.140884]        [<c01b54f3>] do_truncate+0x6b/0x84
[42993.140888]        [<c01bea2b>] may_open+0x196/0x19c
[42993.140892]        [<c01bf000>] do_filp_open+0x341/0x680
[42993.140896]        [<c01b4906>] do_sys_open+0x47/0xbc
[42993.140900]        [<c01b49c7>] sys_open+0x23/0x2b
[42993.140905]        [<c0117ff6>] syscall_call+0x7/0xb
[42993.140909]        [<ffffffff>] 0xffffffff
[42993.140915] 
[42993.140915] -> #2 (&sb->s_type->i_alloc_sem_key#4){----}:
[42993.140921]        [<c0162845>] __lock_acquire+0x9a6/0xb19
[42993.140925]        [<c0162a13>] lock_acquire+0x5b/0x81
[42993.140929]        [<c04c4621>] down_read+0x37/0x74
[42993.140933]        [<c020e42a>] ext4_page_mkwrite+0x36/0x16a
[42993.140937]        [<c019ff30>] do_wp_page+0x1ad/0x60a
[42993.140942]        [<c01a1a80>] handle_mm_fault+0x676/0x728
[42993.140946]        [<c04c7702>] do_page_fault+0x333/0x7ce
[42993.140950]        [<c04c5b57>] error_code+0x77/0x7c
[42993.140954]        [<ffffffff>] 0xffffffff
[42993.140958] 
[42993.140959] -> #1 (&mm->mmap_sem){----}:
[42993.140964]        [<c0162845>] __lock_acquire+0x9a6/0xb19
[42993.140968]        [<c0162a13>] lock_acquire+0x5b/0x81
[42993.140972]        [<c019f0f7>] might_fault+0x65/0x85
[42993.140975]        [<c02dafc1>] copy_to_user+0x31/0x100
[42993.140980]        [<c01c1248>] filldir64+0x9c/0xd2
[42993.140984]        [<c01f6e78>] sysfs_readdir+0x11c/0x150
[42993.140988]        [<c01c1469>] vfs_readdir+0x6d/0x99
[42993.140992]        [<c01c14fd>] sys_getdents64+0x68/0xa5
[42993.140996]        [<c0117ff6>] syscall_call+0x7/0xb
[42993.141000]        [<ffffffff>] 0xffffffff
[42993.141009] 
[42993.141009] -> #0 (sysfs_mutex){--..}:
[42993.141014]        [<c016271a>] __lock_acquire+0x87b/0xb19
[42993.141018]        [<c0162a13>] lock_acquire+0x5b/0x81
[42993.141022]        [<c04c402a>] __mutex_lock_common+0xdc/0x33a
[42993.141026]        [<c04c432f>] mutex_lock_nested+0x33/0x3b
[42993.141030]        [<c01f7098>] sysfs_addrm_start+0x28/0x9a
[42993.141034]        [<c01f7522>] sysfs_remove_dir+0x77/0xab
[42993.141039]        [<c02d5a0b>] kobject_del+0xf/0x2c
[42993.141042]        [<c02d5b5c>] kobject_release+0x134/0x1cb
[42993.141046]        [<c02d68c0>] kref_put+0x3c/0x4a
[42993.141050]        [<c02d59a4>] kobject_put+0x37/0x3c
[42993.141054]        [<c021cc89>] ext4_put_super+0xab/0x215
[42993.141058]        [<c01b7f55>] generic_shutdown_super+0x62/0xe3
[42993.141062]        [<c01b7ff8>] kill_block_super+0x22/0x36
[42993.141066]        [<c01b80c3>] deactivate_super+0x5c/0x6f
[42993.141070]        [<c01c8b98>] mntput_no_expire+0xd4/0x106
[42993.141074]        [<c01c909c>] sys_umount+0x2a1/0x2c6
[42993.141078]        [<c01c90d3>] sys_oldumount+0x12/0x14
[42993.141082]        [<c0117ff6>] syscall_call+0x7/0xb
[42993.141086]        [<ffffffff>] 0xffffffff
[42993.141092] 
[42993.141093] other info that might help us debug this:
[42993.141094] 
[42993.141097] 2 locks held by umount/30941:
[42993.141099]  #0:  (&type->s_umount_key#30){----}, at: [<c01b80be>] deactivate_super+0x57/0x6f
[42993.141107]  #1:  (&type->s_lock_key#6){--..}, at: [<c01b7493>] lock_super+0x26/0x28
[42993.141115] 

So if I'm reading this right, the problem is happening because
someplace in the kernel, fs/sysfs code is grabbing mmap_sem while it
is holding sysfs_mutex, right?  But I can't see where that might be
happening...

						- Ted
