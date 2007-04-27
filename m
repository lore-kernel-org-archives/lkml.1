Return-Path: <linux-kernel-owner+w=401wt.eu-S1754611AbXD0FoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611AbXD0FoY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 01:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755344AbXD0FoY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 01:44:24 -0400
Received: from smtp1.linux-foundation.org ([65.172.181.25]:47914 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754611AbXD0FoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 01:44:22 -0400
Date: Thu, 26 Apr 2007 22:44:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brownell <david-b@pacbell.net>
Cc: Linux Kernel list <linux-kernel@vger.kernel.org>, reiserfs-dev@namesys.com
Subject: Re: 2.6.21 reiserfs -- cicular locking?
Message-Id: <20070426224408.fd525b46.akpm@linux-foundation.org>
In-Reply-To: <200704261640.15068.david-b@pacbell.net>
References: <200704261640.15068.david-b@pacbell.net>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2007 16:40:14 -0700 David Brownell <david-b@pacbell.net> wrote:

> This might be a Heisenberg, but I figure it's worth posting
> in case anyone else sees similar oddness.  Never seen it
> before or since.  It's as if a gremlin got annoyed with me
> for switching a filesystem from reiser to ext3.  :)
> 
> - Dave
> 
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.21-git #6
> -------------------------------------------------------
> vi/4556 is trying to acquire lock:
>  (&REISERFS_SB(s)->xattr_dir_sem){..--}, at: [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
> 
> but task is already holding lock:
>  (&inode->i_mutex){--..}, at: [<ffffffff8026c4fa>] chown_common+0x93/0xb3
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #1 (&inode->i_mutex){--..}:
>        [<ffffffff802405f4>] __lock_acquire+0x9f7/0xbaa
>        [<ffffffff802ca1ac>] get_xa_root+0x49/0x107
>        [<ffffffff80240822>] lock_acquire+0x7b/0x9f
>        [<ffffffff802ca1ac>] get_xa_root+0x49/0x107
>        [<ffffffff8023dee0>] save_trace+0x40/0x9e
>        [<ffffffff8041e1db>] __mutex_lock_slowpath+0xd8/0x281
>        [<ffffffff8041ff18>] _spin_unlock_irq+0x24/0x4a
>        [<ffffffff802ca1ac>] get_xa_root+0x49/0x107
>        [<ffffffff802ca2a8>] open_xa_dir+0x1c/0xf8
>        [<ffffffff8041f34b>] __down_read+0x34/0x9d
>        [<ffffffff802cb50a>] reiserfs_delete_xattrs+0x64/0x185
>        [<ffffffff802fd620>] _atomic_dec_and_lock+0x14/0x34
>        [<ffffffff802b252e>] reiserfs_delete_inode+0x38/0xae
>        [<ffffffff8027f6bc>] generic_delete_inode+0x64/0xf5
>        [<ffffffff802b24f6>] reiserfs_delete_inode+0x0/0xae
>        [<ffffffff8027f6d2>] generic_delete_inode+0x7a/0xf5
>        [<ffffffff80276b95>] do_unlinkat+0xd9/0x14f
>        [<ffffffff8023f75f>] trace_hardirqs_on+0x123/0x14d
>        [<ffffffff8041f4d1>] trace_hardirqs_on_thunk+0x35/0x37
>        [<ffffffff8020954e>] system_call+0x7e/0x83
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> -> #0 (&REISERFS_SB(s)->xattr_dir_sem){..--}:
>        [<ffffffff8023ee6f>] print_circular_bug_header+0xcc/0xd3
>        [<ffffffff802404f0>] __lock_acquire+0x8f3/0xbaa
>        [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
>        [<ffffffff80240822>] lock_acquire+0x7b/0x9f
>        [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
>        [<ffffffff8023bb03>] down_read+0x32/0x3b
>        [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
>        [<ffffffff8022e285>] __capable+0x9/0x1d
>        [<ffffffff802b2828>] reiserfs_setattr+0x11e/0x1ec
>        [<ffffffff8022bd6b>] current_fs_time+0x35/0x3a
>        [<ffffffff802803a1>] notify_change+0x122/0x231
>        [<ffffffff8026c505>] chown_common+0x9e/0xb3
>        [<ffffffff8026e7a6>] fget+0x88/0xa7
>        [<ffffffff8026c54a>] sys_fchown+0x30/0x47
>        [<ffffffff8020954e>] system_call+0x7e/0x83
>        [<ffffffffffffffff>] 0xffffffffffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by vi/4556:
>  #0:  (&inode->i_mutex){--..}, at: [<ffffffff8026c4fa>] chown_common+0x93/0xb3
> 
> stack backtrace:
> 
> Call Trace:
>  [<ffffffff8023eacc>] print_circular_bug_tail+0x69/0x72
>  [<ffffffff8023ee6f>] print_circular_bug_header+0xcc/0xd3
>  [<ffffffff802404f0>] __lock_acquire+0x8f3/0xbaa
>  [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
>  [<ffffffff80240822>] lock_acquire+0x7b/0x9f
>  [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
>  [<ffffffff8023bb03>] down_read+0x32/0x3b
>  [<ffffffff802caf4b>] reiserfs_chown_xattrs+0x5b/0x128
>  [<ffffffff8022e285>] __capable+0x9/0x1d
>  [<ffffffff802b2828>] reiserfs_setattr+0x11e/0x1ec
>  [<ffffffff8022bd6b>] current_fs_time+0x35/0x3a
>  [<ffffffff802803a1>] notify_change+0x122/0x231
>  [<ffffffff8026c505>] chown_common+0x9e/0xb3
>  [<ffffffff8026e7a6>] fget+0x88/0xa7
>  [<ffffffff8026c54a>] sys_fchown+0x30/0x47
>  [<ffffffff8020954e>] system_call+0x7e/0x83
> 

cc added.  This was also reported againt -rc7-mm1 (or 2)
