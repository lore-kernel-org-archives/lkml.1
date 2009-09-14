Return-Path: <linux-kernel-owner+w=401wt.eu-S933931AbZINUh4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933931AbZINUh4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 16:37:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756124AbZINUhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 16:37:53 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:53050 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZINUhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 16:37:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=gN+ai1Za+wq4ztDyx+afs1e21AuxFsm1ygBEnHA6yQ4ajm5RcOh5nqdrm/W93RRkqW
         V8btek7nmpdk0LHNyZA3tuORdDGinLYRUzHRUNB4P/MnCfz+2VdQ1Y2kuExCEYZgqg0N
         dZgjQuL/8B2x1FFT91IVWpwGph+XhHDeWWMwA=
Date: Mon, 14 Sep 2009 22:37:51 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Reiserfs <reiserfs-devel@vger.kernel.org>
Subject: Re: [PATCH 0/4] kill-the-bkl/reiserfs: fix some lock dependency
	inversions
Message-ID: <20090914203749.GF6045@nowhere>
References: <1251167570-5233-1-git-send-email-fweisbec@gmail.com> <20090826201330.GA18761@orion>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090826201330.GA18761@orion>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 27, 2009 at 12:13:30AM +0400, Alexander Beregalov wrote:
> Hi,
> possible circular locking dependency detected
> 
> Is it false positive?
> 
> REISERFS (device sda1): found reiserfs format "3.6" with standard journal
> REISERFS (device sda1): using ordered data mode
> REISERFS (device sda1): journal params: device sda1, size 8192, journal first block 18, max trans len 1024, max batch 900, max commit age 30, max trans age 30
> REISERFS (device sda1): checking transaction log (sda1)
> REISERFS debug (device sda1): journal-1153: found in header: first_unflushed_offset 6766, last_flushed_trans_id 1836992
> REISERFS debug (device sda1): journal-1206: Starting replay from offset 7889824857987694, trans_id 18
> REISERFS debug (device sda1): journal-1299: Setting newest_mount_id to 229
> REISERFS (device sda1): Using r5 hash to sort names
> VFS: Mounted root (reiserfs filesystem) readonly on device 8:1.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.31-rc7-00135-g9399a4c #5
> -------------------------------------------------------
> init.sh/599 is trying to acquire lock:
>  (&mm->mmap_sem){++++++}, at: [<c1071056>] might_fault+0x46/0xa0
> 
> but task is already holding lock:
>  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c10ff20e>] reiserfs_write_lock+0x1e/0x30
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&REISERFS_SB(s)->lock){+.+.+.}:
>        [<c104dd18>] __lock_acquire+0xd28/0x1390
>        [<c104e3ef>] lock_acquire+0x6f/0x90
>        [<c133af96>] __mutex_lock_common+0x46/0x310
>        [<c133b318>] mutex_lock_nested+0x38/0x40
>        [<c10ff1ce>] reiserfs_write_lock_once+0x1e/0x40
>        [<c10db74c>] reiserfs_get_block+0x5c/0x1440
>        [<c10ae7a0>] do_mpage_readpage+0x120/0x4b0
>        [<c10aec2f>] mpage_readpages+0x9f/0xe0
>        [<c10d8c39>] reiserfs_readpages+0x19/0x20
>        [<c10671f5>] __do_page_cache_readahead+0x195/0x210
>        [<c1067291>] ra_submit+0x21/0x30
>        [<c1061229>] filemap_fault+0x2e9/0x380
>        [<c1072f08>] __do_fault+0x38/0x3b0
>        [<c1073b5d>] handle_mm_fault+0xcd/0x550
>        [<c101ad63>] do_page_fault+0xf3/0x240
>        [<c133cd53>] error_code+0x63/0x68
>        [<c10baa74>] padzero+0x24/0x40
>        [<c10bc062>] load_elf_binary+0x632/0x1480
>        [<c108aafa>] search_binary_handler+0x8a/0x270
>        [<c108cb15>] do_execve+0x215/0x2a0
>        [<c1001658>] sys_execve+0x28/0x60
>        [<c1002d99>] syscall_call+0x7/0xb
>        [<ffffffff>] 0xffffffff
> 
> -> #0 (&mm->mmap_sem){++++++}:
>        [<c104dd99>] __lock_acquire+0xda9/0x1390
>        [<c104e3ef>] lock_acquire+0x6f/0x90
>        [<c1071087>] might_fault+0x77/0xa0
>        [<c11c1886>] copy_to_user+0x36/0x130
>        [<c1093c29>] filldir64+0xa9/0xf0
>        [<c10deda1>] reiserfs_readdir_dentry+0x4a1/0x7b0
>        [<c10df0c7>] reiserfs_readdir+0x17/0x20
>        [<c1093eb5>] vfs_readdir+0x85/0xa0
>        [<c1093f34>] sys_getdents64+0x64/0xb0
>        [<c1002d18>] sysenter_do_call+0x12/0x36
>        [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 2 locks held by init.sh/599:
>  #0:  (&sb->s_type->i_mutex_key#4){+.+.+.}, at: [<c1093e82>] vfs_readdir+0x52/0xa0
>  #1:  (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c10ff20e>] reiserfs_write_lock+0x1e/0x30
> 
> stack backtrace:
> Pid: 599, comm: init.sh Not tainted 2.6.31-rc7-00135-g9399a4c #5
> Call Trace:
>  [<c133a11a>] ? printk+0x18/0x1e
>  [<c104bfdd>] print_circular_bug_tail+0x8d/0xd0
>  [<c104dd99>] __lock_acquire+0xda9/0x1390
>  [<c104e3ef>] lock_acquire+0x6f/0x90
>  [<c1071056>] ? might_fault+0x46/0xa0
>  [<c1071087>] might_fault+0x77/0xa0
>  [<c1071056>] ? might_fault+0x46/0xa0
>  [<c11c1886>] copy_to_user+0x36/0x130
>  [<c1093c29>] filldir64+0xa9/0xf0
>  [<c10ff20e>] ? reiserfs_write_lock+0x1e/0x30
>  [<c10deda1>] reiserfs_readdir_dentry+0x4a1/0x7b0
>  [<c1093b80>] ? filldir64+0x0/0xf0
>  [<c104d453>] ? __lock_acquire+0x463/0x1390
>  [<c104c62e>] ? trace_hardirqs_on_caller+0x7e/0x170
>  [<c1093b80>] ? filldir64+0x0/0xf0
>  [<c133b153>] ? __mutex_lock_common+0x203/0x310
>  [<c1093b80>] ? filldir64+0x0/0xf0
>  [<c10df0c7>] reiserfs_readdir+0x17/0x20
>  [<c1093eb5>] vfs_readdir+0x85/0xa0
>  [<c1093f34>] sys_getdents64+0x64/0xb0
>  [<c1002d18>] sysenter_do_call+0x12/0x36



Hi Alexander,

It should be fixed now, still in the following tree:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	reiserfs/kill-bkl


Don't hesistate to tell me if you see other problems.

Thanks a lot for your report!

Frederic.

