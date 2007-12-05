Return-Path: <linux-kernel-owner+w=401wt.eu-S1752545AbXLEA5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbXLEA5T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 19:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750993AbXLEA5E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 19:57:04 -0500
Received: from ug-out-1314.google.com ([66.249.92.173]:19868 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbXLEA5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 19:57:01 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=PrSY5rBxsFw/OxiVQwyNNCDydjUd7gsw4jK/YlCZYoXFlBgVYonGwJUgBD0L6oNY/QEr3g8YpTCfvtyEl6WLu1+lcsoJwBGGApgjOo6WH4bUsYQGdpAR0241z7JbiE3oDnvpHmilZqNcTjXuNETVD9NEeo1Pw9FP+zdMMIaz61k=
Message-ID: <5a4c581d0712041656h1ff268bbga4465e9a522eccf6@mail.gmail.com>
Date: Wed, 5 Dec 2007 01:56:59 +0100
From: "Alessandro Suardi" <alessandro.suardi@gmail.com>
To: "Linux Kernel list" <linux-kernel@vger.kernel.org>
Subject: possible circular locking dependency detected in 2.6.24-rc3-git6
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Only saw this once, but it's a relatively short time since I moved
 to Fedora 8 (i686, UP) and began building my custom kernels
 there... apparently starting my 11.1.0.6 Oracle instance caused
 lockdep to trigger this (hoping GMail doesn't mangle the
 text too badly):

 =======================================================
 [ INFO: possible circular locking dependency detected ]
 2.6.24-rc3-git6 #7
 -------------------------------------------------------
 oracle/4715 is trying to acquire lock:
  (&mm->mmap_sem){----}, at: [<c0182489>] dio_get_page+0x4d/0x159

 but task is already holding lock:
  (jbd_handle){--..}, at: [<c01a825e>] journal_start+0xc8/0xf5

 which lock already depends on the new lock.


 the existing dependency chain (in reverse order) is:

 -> #1 (jbd_handle){--..}:
        [<c01331e2>] __lock_acquire+0xa08/0xc06
        [<c013344f>] lock_acquire+0x6f/0x88
        [<c01a8281>] journal_start+0xeb/0xf5
        [<c01a1220>] ext3_journal_start_sb+0x48/0x4a
        [<c019cd75>] ext3_dirty_inode+0x26/0x6b
        [<c017a1fe>] __mark_inode_dirty+0x26/0x158
        [<c0172a83>] touch_atime+0xb7/0xbc
        [<c0145266>] generic_file_mmap+0x2d/0x42
        [<c01543fc>] mmap_region+0x1d8/0x3a4
        [<c01548f3>] do_mmap_pgoff+0x257/0x2b6
        [<c010728a>] sys_mmap2+0x9a/0xb4
        [<c0103e7a>] syscall_call+0x7/0xb
        [<ffffffff>] 0xffffffff

 -> #0 (&mm->mmap_sem){----}:
        [<c01330d2>] __lock_acquire+0x8f8/0xc06
        [<c013344f>] lock_acquire+0x6f/0x88
        [<c012bd13>] down_read+0x3f/0x50
        [<c0182489>] dio_get_page+0x4d/0x159
        [<c0182f73>] __blockdev_direct_IO+0x3f7/0xad1
        [<c019cb6f>] ext3_direct_IO+0x10c/0x195
        [<c0146367>] generic_file_direct_IO+0x124/0x139
        [<c01463d2>] generic_file_direct_write+0x56/0xed
        [<c0146c79>] __generic_file_aio_write_nolock+0x2f6/0x43e
        [<c0146e19>] generic_file_aio_write+0x58/0xb6
        [<c0198d13>] ext3_file_write+0x27/0x99
        [<c0161283>] do_sync_write+0xc4/0x101
        [<c0161a24>] vfs_write+0xa8/0x131
        [<c0161fb6>] sys_pwrite64+0x45/0x5c
        [<c0103e7a>] syscall_call+0x7/0xb
        [<ffffffff>] 0xffffffff

 other info that might help us debug this:

 2 locks held by oracle/4715:
  #0:  (&sb->s_type->i_mutex_key#7){--..}, at: [<c0146e06>]
generic_file_aio_write+0x45/0xb6
  #1:  (jbd_handle){--..}, at: [<c01a825e>] journal_start+0xc8/0xf5

 stack backtrace:
 Pid: 4715, comm: oracle Not tainted 2.6.24-rc3-git6 #7
  [<c010448a>] show_trace_log_lvl+0x1a/0x2f
  [<c0104df7>] show_trace+0x12/0x14
  [<c010568a>] dump_stack+0x6a/0x70
  [<c01318a5>] print_circular_bug_tail+0x5e/0x67
  [<c01330d2>] __lock_acquire+0x8f8/0xc06
  [<c013344f>] lock_acquire+0x6f/0x88
  [<c012bd13>] down_read+0x3f/0x50
  [<c0182489>] dio_get_page+0x4d/0x159
  [<c0182f73>] __blockdev_direct_IO+0x3f7/0xad1
  [<c019cb6f>] ext3_direct_IO+0x10c/0x195
  [<c0146367>] generic_file_direct_IO+0x124/0x139
  [<c01463d2>] generic_file_direct_write+0x56/0xed
  [<c0146c79>] __generic_file_aio_write_nolock+0x2f6/0x43e
  [<c0146e19>] generic_file_aio_write+0x58/0xb6
  [<c0198d13>] ext3_file_write+0x27/0x99
  [<c0161283>] do_sync_write+0xc4/0x101
  [<c0161a24>] vfs_write+0xa8/0x131
  [<c0161fb6>] sys_pwrite64+0x45/0x5c
  [<c0103e7a>] syscall_call+0x7/0xb
  =======================


Let me know whether this is enough info or I should try
 and hammer the thing further to see if this reproduces.


Thanks, ciao,

--alessandro

 "Damaged people are dangerous. They know they can survive."

   (Anna Barton/Juliette Binoche, 'Damage')
