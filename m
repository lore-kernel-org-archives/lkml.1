Return-Path: <linux-kernel-owner+w=401wt.eu-S1753356AbZIKLfr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356AbZIKLfr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Sep 2009 07:35:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753224AbZIKLfq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Sep 2009 07:35:46 -0400
Received: from cam-admin0.cambridge.arm.com ([193.131.176.58]:55143 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753171AbZIKLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Sep 2009 07:35:44 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>
Subject: Re: Possible memory leak via alloc_pid()
References: <b0943d9e0907081433y599e6d51j285c390f18d7b32c@mail.gmail.com>
	<20090729170315.f62066c0.akpm@linux-foundation.org>
	<20090730212956.GA26863@redhat.com>
	<1249035398.29967.8.camel@pc1117.cambridge.arm.com>
	<20090802213528.GA18795@redhat.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Fri, 11 Sep 2009 12:35:16 +0100
In-Reply-To: <20090802213528.GA18795@redhat.com> (Oleg Nesterov's message of "Sun\, 2 Aug 2009 23\:35\:28 +0200")
Message-ID: <tnxab117lzf.fsf@pc1117.cambridge.arm.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 11 Sep 2009 11:35:18.0352 (UTC) FILETIME=[F03D5500:01CA32D3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Oleg,

Sorry for the long delay with this investigation, I got distracted to
other tasks.

Oleg Nesterov <oleg@redhat.com> wrote:
> Pleas rename Xorg to Xorg.origin, and make a simple Xorg script which
> does something like
>
> 	#!/bin/sh
>
> 	echo $$ >> /proc/sys/kernel/xxx
> 	exec /path/to/Xorg.origin $*
>
> perhaps even this is too late, gdm can do a lot before execing.

I did this change and I copied the output below. The refcount log
starts at 12 but when the task exits, it is 2, hence the suspected
leak. I also ran a dummy script (i.e. without the exec line above) and
the refcount also starts at 12 but finishes at 0 (no leak). I think
this suspected leak is something specific to what the X server does.


XXXXX(1333) ==12
XXXXX(1333) ++12
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c0171844>] (__proc_set_tty+0x60/0x12c)
[<c0171844>] (__proc_set_tty+0x60/0x12c) from [<c017437c>] (tty_open+0x39c/0x444)
[<c017437c>] (tty_open+0x39c/0x444) from [<c00a2308>] (chrdev_open+0x178/0x198)
[<c00a2308>] (chrdev_open+0x178/0x198) from [<c009dbcc>] (__dentry_open+0x14c/0x268)
[<c009dbcc>] (__dentry_open+0x14c/0x268) from [<c009ddb0>] (nameidata_to_filp+0x44/0x58)
[<c009ddb0>] (nameidata_to_filp+0x44/0x58) from [<c00aaa14>] (do_filp_open+0x408/0x820)
[<c00aaa14>] (do_filp_open+0x408/0x820) from [<c009d9a0>] (do_sys_open+0x58/0x10c)
[<c009d9a0>] (do_sys_open+0x58/0x10c) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) ++13
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c0171898>] (__proc_set_tty+0xb4/0x12c)
[<c0171898>] (__proc_set_tty+0xb4/0x12c) from [<c017437c>] (tty_open+0x39c/0x444)
[<c017437c>] (tty_open+0x39c/0x444) from [<c00a2308>] (chrdev_open+0x178/0x198)
[<c00a2308>] (chrdev_open+0x178/0x198) from [<c009dbcc>] (__dentry_open+0x14c/0x268)
[<c009dbcc>] (__dentry_open+0x14c/0x268) from [<c009ddb0>] (nameidata_to_filp+0x44/0x58)
[<c009ddb0>] (nameidata_to_filp+0x44/0x58) from [<c00aaa14>] (do_filp_open+0x408/0x820)
[<c00aaa14>] (do_filp_open+0x408/0x820) from [<c009d9a0>] (do_sys_open+0x58/0x10c)
[<c009d9a0>] (do_sys_open+0x58/0x10c) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) ++14
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c017b8ac>] (vt_ioctl+0x1168/0x1c0c)
[<c017b8ac>] (vt_ioctl+0x1168/0x1c0c) from [<c017385c>] (tty_ioctl+0x880/0x920)
[<c017385c>] (tty_ioctl+0x880/0x920) from [<c00abc50>] (vfs_ioctl+0x2c/0x8c)
[<c00abc50>] (vfs_ioctl+0x2c/0x8c) from [<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0)
[<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0) from [<c00ac38c>] (sys_ioctl+0x34/0x54)
[<c00ac38c>] (sys_ioctl+0x34/0x54) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) ++15
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c00ab42c>] (f_modown+0x60/0xcc)
[<c00ab42c>] (f_modown+0x60/0xcc) from [<c00ab4b0>] (__f_setown+0x8/0x10)
[<c00ab4b0>] (__f_setown+0x8/0x10) from [<c00ab8a4>] (sys_fcntl64+0x70/0x84)
[<c00ab8a4>] (sys_fcntl64+0x70/0x84) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) ++16
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ace0>] (get_task_pid+0x40/0x60)
[<c005ace0>] (get_task_pid+0x40/0x60) from [<c00d8898>] (proc_pid_make_inode+0x50/0x9c)
[<c00d8898>] (proc_pid_make_inode+0x50/0x9c) from [<c00dacf4>] (proc_pident_instantiate+0x18/0x98)
[<c00dacf4>] (proc_pident_instantiate+0x18/0x98) from [<c00daf08>] (proc_pident_lookup+0x90/0xd0)
[<c00daf08>] (proc_pident_lookup+0x90/0xd0) from [<c00a75f0>] (do_lookup+0xbc/0x180)
[<c00a75f0>] (do_lookup+0xbc/0x180) from [<c00a93ec>] (__link_path_walk+0x9d8/0xed8)
[<c00a93ec>] (__link_path_walk+0x9d8/0xed8) from [<c00a9aac>] (path_walk+0x44/0x8c)
[<c00a9aac>] (path_walk+0x44/0x8c) from [<c00a9b80>] (do_path_lookup+0x24/0x4c)
[<c00a9b80>] (do_path_lookup+0x24/0x4c) from [<c00aa6c4>] (do_filp_open+0xb8/0x820)
[<c00aa6c4>] (do_filp_open+0xb8/0x820) from [<c009d9a0>] (do_sys_open+0x58/0x10c)
[<c009d9a0>] (do_sys_open+0x58/0x10c) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) ++17
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ac80>] (find_get_pid+0x30/0x50)
[<c005ac80>] (find_get_pid+0x30/0x50) from [<c004cae0>] (sys_wait4+0x70/0xb8)
[<c004cae0>] (sys_wait4+0x70/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --18
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00a096c>] (__fput+0x140/0x1c8)
[<c00a096c>] (__fput+0x140/0x1c8) from [<c009d7e4>] (filp_close+0x70/0x7c)
[<c009d7e4>] (filp_close+0x70/0x7c) from [<c009d884>] (sys_close+0x94/0xe4)
[<c009d884>] (sys_close+0x94/0xe4) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --17
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c017b87c>] (vt_ioctl+0x1138/0x1c0c)
[<c017b87c>] (vt_ioctl+0x1138/0x1c0c) from [<c017385c>] (tty_ioctl+0x880/0x920)
[<c017385c>] (tty_ioctl+0x880/0x920) from [<c00abc50>] (vfs_ioctl+0x2c/0x8c)
[<c00abc50>] (vfs_ioctl+0x2c/0x8c) from [<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0)
[<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0) from [<c00ac38c>] (sys_ioctl+0x34/0x54)
[<c00ac38c>] (sys_ioctl+0x34/0x54) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) ++16
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c017b8ac>] (vt_ioctl+0x1168/0x1c0c)
[<c017b8ac>] (vt_ioctl+0x1168/0x1c0c) from [<c017385c>] (tty_ioctl+0x880/0x920)
[<c017385c>] (tty_ioctl+0x880/0x920) from [<c00abc50>] (vfs_ioctl+0x2c/0x8c)
[<c00abc50>] (vfs_ioctl+0x2c/0x8c) from [<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0)
[<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0) from [<c00ac38c>] (sys_ioctl+0x34/0x54)
[<c00ac38c>] (sys_ioctl+0x34/0x54) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --17
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --16
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --15
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --14
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --13
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --12
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --11
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --10
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --9
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --8
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --7
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00aeb00>] (__shrink_dcache_sb+0x284/0x324)
[<c00aeb00>] (__shrink_dcache_sb+0x284/0x324) from [<c00aed9c>] (shrink_dcache_parent+0x2c/0x114)
[<c00aed9c>] (shrink_dcache_parent+0x2c/0x114) from [<c00db418>] (proc_flush_task+0xa4/0x280)
[<c00db418>] (proc_flush_task+0xa4/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --6
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c00d7dd8>] (proc_delete_inode+0x20/0x4c)
[<c00d7dd8>] (proc_delete_inode+0x20/0x4c) from [<c00b241c>] (generic_delete_inode+0xac/0x150)
[<c00b241c>] (generic_delete_inode+0xac/0x150) from [<c00b1618>] (iput+0x64/0x78)
[<c00b1618>] (iput+0x64/0x78) from [<c00ae854>] (d_kill+0x3c/0x64)
[<c00ae854>] (d_kill+0x3c/0x64) from [<c00af160>] (dput+0x190/0x1ac)
[<c00af160>] (dput+0x190/0x1ac) from [<c00db48c>] (proc_flush_task+0x118/0x280)
[<c00db48c>] (proc_flush_task+0x118/0x280) from [<c004bac8>] (release_task+0x40/0x3a4)
[<c004bac8>] (release_task+0x40/0x3a4) from [<c004c32c>] (wait_consider_task+0x500/0x9c0)
[<c004c32c>] (wait_consider_task+0x500/0x9c0) from [<c004c8a8>] (do_wait+0xbc/0x284)
[<c004c8a8>] (do_wait+0xbc/0x284) from [<c004cb10>] (sys_wait4+0xa0/0xb8)
[<c004cb10>] (sys_wait4+0xa0/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --5
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c004cb1c>] (sys_wait4+0xac/0xb8)
[<c004cb1c>] (sys_wait4+0xac/0xb8) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)
XXXXX(1333) --4
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c0078dd8>] (__rcu_process_callbacks+0x1b4/0x244)
[<c0078dd8>] (__rcu_process_callbacks+0x1b4/0x244) from [<c0078ea4>] (rcu_process_callbacks+0x3c/0x68)
[<c0078ea4>] (rcu_process_callbacks+0x3c/0x68) from [<c004edf8>] (__do_softirq+0x8c/0x11c)
[<c004edf8>] (__do_softirq+0x8c/0x11c) from [<c002e3dc>] (do_local_timer+0x50/0x80)
[<c002e3dc>] (do_local_timer+0x50/0x80) from [<c002ebd8>] (__irq_svc+0x38/0xc0)
Exception stack(0xc0389f70 to 0xc0389fb8)
9f60:                                     00000000 00000000 c0389fb8 00000000 
9f80: c0388000 c07e8000 007cf000 00000004 c03af048 410fb020 c03a9c40 00000000 
9fa0: 00000001 c0389fb8 c00301f4 c00301f8 60000013 ffffffff                   
[<c002ebd8>] (__irq_svc+0x38/0xc0) from [<c00301f8>] (default_idle+0x24/0x28)
[<c00301f8>] (default_idle+0x24/0x28) from [<c00306f8>] (cpu_idle+0x84/0xd8)
[<c00306f8>] (cpu_idle+0x84/0xd8) from [<c0008cb4>] (start_kernel+0x2d4/0x330)
[<c0008cb4>] (start_kernel+0x2d4/0x330) from [<70008080>] (0x70008080)
XXXXX(1333) --3
[<c0035964>] (unwind_backtrace+0x0/0xdc) from [<c005ad2c>] (put_pid+0x2c/0x80)
[<c005ad2c>] (put_pid+0x2c/0x80) from [<c017b87c>] (vt_ioctl+0x1138/0x1c0c)
[<c017b87c>] (vt_ioctl+0x1138/0x1c0c) from [<c017385c>] (tty_ioctl+0x880/0x920)
[<c017385c>] (tty_ioctl+0x880/0x920) from [<c00abc50>] (vfs_ioctl+0x2c/0x8c)
[<c00abc50>] (vfs_ioctl+0x2c/0x8c) from [<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0)
[<c00ac2fc>] (do_vfs_ioctl+0x554/0x5b0) from [<c00ac38c>] (sys_ioctl+0x34/0x54)
[<c00ac38c>] (sys_ioctl+0x34/0x54) from [<c002efc0>] (ret_fast_syscall+0x0/0x28)

10:~# echo scan > /sys/kernel/debug/kmemleak 
kmemleak: 1 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
10:~# cat /sys/kernel/debug/kmemleak 
unreferenced object 0xdb58c700 (size 64):
  comm "gdm", pid 1331, jiffies 19732
  hex dump (first 32 bytes):
    02 00 00 00 01 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 14 16 e6 de 80 ad 05 c0  ................
  backtrace:
    [<c009d44c>] create_object+0x104/0x20c
    [<c009accc>] kmem_cache_alloc+0xc0/0xcc
    [<c005addc>] alloc_pid+0x18/0x358
    [<c00488b4>] copy_process+0x8a4/0xf00
    [<c0049074>] do_fork+0x164/0x2a8
    [<c002efc0>] ret_fast_syscall+0x0/0x28
    [<ffffffff>] 0xffffffff


Thanks.

-- 
Catalin
