Return-Path: <linux-kernel-owner+w=401wt.eu-S1765621AbYBVX7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765621AbYBVX7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 18:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755083AbYBVX7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 18:59:04 -0500
Received: from cantor.suse.de ([195.135.220.2]:39854 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbYBVX7A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 18:59:00 -0500
Message-ID: <47BF61BF.3070805@suse.com>
Date: Fri, 22 Feb 2008 18:58:55 -0500
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.9 (X11/20070801)
MIME-Version: 1.0
To: Laurent Riffard <laurent.riffard@free.fr>
Cc: ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: possible circular locking in reiserfs_removexattr
References: <47BF5AFC.4060809@free.fr>
In-Reply-To: <47BF5AFC.4060809@free.fr>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Laurent Riffard wrote:
> Hello,
> 
> I've got this while running beagle. /home is mounted with the following
> options:

Thanks for the report. I have a patch queue I'm hoping to send to -mm
next week that cleans up the xattr code a lot and makes the locking
quite a bit saner. It's been in openSUSE for a few generations, so
hopefully there won't be a long incubation before it hits mainline.

- -Jeff

> /dev/mapper/vglinux1-lvhome /home reiserfs
> rw,noatime,nodiratime,user_xattr 0 0
> 
> This still happens with latest kernel (next-20080222), I can't tell when
> it first appears.
> 
> =======================================================
> [ INFO: possible circular locking dependency detected ]
> 2.6.25-rc1 #15
> -------------------------------------------------------
> beagled/3781 is trying to acquire lock:
> (&REISERFS_I(inode)->xattr_sem){----}, at: [<e1ac02fa>]
> reiserfs_removexattr+0x42/0xbf [reiserfs]
> 
> but task is already holding lock:
> (&sb->s_type->i_mutex_key#8){--..}, at: [<c016f006>]
> vfs_removexattr+0x59/0xc2
> 
> which lock already depends on the new lock.
> 
> 
> the existing dependency chain (in reverse order) is:
> 
> -> #2 (&sb->s_type->i_mutex_key#8){--..}:
>       [<c01311f5>] __lock_acquire+0x8d9/0xa83
>       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
>       [<c01316f2>] lock_acquire+0x4c/0x63
>       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
>       [<c0290e57>] mutex_lock_nested+0xa9/0x219
>       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
>       [<e1aacd0e>] reiserfs_file_release+0x171/0x3b2 [reiserfs]
>       [<c015a01b>] __fput+0x90/0x155
>       [<e1ac0ebd>] reiserfs_xattr_set+0x2a2/0x2c5 [reiserfs]
>       [<e1ac0858>] reiserfs_setxattr+0x7a/0xe3 [reiserfs]
>       [<e1ac07de>] reiserfs_setxattr+0x0/0xe3 [reiserfs]
>       [<c016f3de>] vfs_setxattr+0x74/0xe4
>       [<c016f4fb>] setxattr+0xad/0xc7
>       [<c0292243>] _spin_unlock+0x25/0x3a
>       [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
>       [<c016aeee>] mntput_no_expire+0x11/0x5b
>       [<c0160fc2>] link_path_walk+0xa5/0xaf
>       [<c010492b>] restore_nocheck+0x12/0x15
>       [<c01122d0>] do_page_fault+0x0/0x484
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c0155b72>] kmem_cache_free+0x53/0x5a
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c01619e7>] __user_walk_fd+0x37/0x3f
>       [<c016f58a>] sys_lsetxattr+0x37/0x4a
>       [<c010492b>] restore_nocheck+0x12/0x15
>       [<c01122d0>] do_page_fault+0x0/0x484
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c010492b>] restore_nocheck+0x12/0x15
>       [<c0104842>] sysenter_past_esp+0x5f/0xa5
>       [<ffffffff>] 0xffffffff
> 
> -> #1 (&REISERFS_SB(s)->xattr_dir_sem){----}:
>       [<c01311f5>] __lock_acquire+0x8d9/0xa83
>       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
>       [<c01316f2>] lock_acquire+0x4c/0x63
>       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
>       [<c0291367>] down_write+0x17/0x2f
>       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
>       [<e1ac0846>] reiserfs_setxattr+0x68/0xe3 [reiserfs]
>       [<e1ac07de>] reiserfs_setxattr+0x0/0xe3 [reiserfs]
>       [<c016f3de>] vfs_setxattr+0x74/0xe4
>       [<c016f4fb>] setxattr+0xad/0xc7
>       [<c0292243>] _spin_unlock+0x25/0x3a
>       [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
>       [<c016aeee>] mntput_no_expire+0x11/0x5b
>       [<c0160fc2>] link_path_walk+0xa5/0xaf
>       [<c010492b>] restore_nocheck+0x12/0x15
>       [<c01122d0>] do_page_fault+0x0/0x484
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c0155b72>] kmem_cache_free+0x53/0x5a
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c01619e7>] __user_walk_fd+0x37/0x3f
>       [<c016f58a>] sys_lsetxattr+0x37/0x4a
>       [<c010492b>] restore_nocheck+0x12/0x15
>       [<c01122d0>] do_page_fault+0x0/0x484
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c010492b>] restore_nocheck+0x12/0x15
>       [<c0104842>] sysenter_past_esp+0x5f/0xa5
>       [<ffffffff>] 0xffffffff
> 
> -> #0 (&REISERFS_I(inode)->xattr_sem){----}:
>       [<c0131115>] __lock_acquire+0x7f9/0xa83
>       [<c01316f2>] lock_acquire+0x4c/0x63
>       [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
>       [<c0291367>] down_write+0x17/0x2f
>       [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
>       [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
>       [<c016f014>] vfs_removexattr+0x67/0xc2
>       [<c016f0ac>] removexattr+0x3d/0x4a
>       [<c0292243>] _spin_unlock+0x25/0x3a
>       [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
>       [<c016aeee>] mntput_no_expire+0x11/0x5b
>       [<c0160fc2>] link_path_walk+0xa5/0xaf
>       [<c010487d>] sysenter_past_esp+0x9a/0xa5
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c0155b72>] kmem_cache_free+0x53/0x5a
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c01619e7>] __user_walk_fd+0x37/0x3f
>       [<c016f114>] sys_lremovexattr+0x2b/0x3c
>       [<c010487d>] sysenter_past_esp+0x9a/0xa5
>       [<c0130556>] trace_hardirqs_on+0xdd/0xfd
>       [<c010487d>] sysenter_past_esp+0x9a/0xa5
>       [<c0104842>] sysenter_past_esp+0x5f/0xa5
>       [<ffffffff>] 0xffffffff
> 
> other info that might help us debug this:
> 
> 1 lock held by beagled/3781:
> #0:  (&sb->s_type->i_mutex_key#8){--..}, at: [<c016f006>]
> vfs_removexattr+0x59/0xc2
> 
> stack backtrace:
> Pid: 3781, comm: beagled Not tainted 2.6.25-rc1 #15
> [<c012fafa>] print_circular_bug_tail+0x56/0x60
> [<c0131115>] __lock_acquire+0x7f9/0xa83
> [<c01316f2>] lock_acquire+0x4c/0x63
> [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
> [<c0291367>] down_write+0x17/0x2f
> [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
> [<e1ac02fa>] reiserfs_removexattr+0x42/0xbf [reiserfs]
> [<c016f014>] vfs_removexattr+0x67/0xc2
> [<c016f0ac>] removexattr+0x3d/0x4a
> [<c0292243>] _spin_unlock+0x25/0x3a
> [<c01bfb26>] _atomic_dec_and_lock+0x22/0x2c
> [<c016aeee>] mntput_no_expire+0x11/0x5b
> [<c0160fc2>] link_path_walk+0xa5/0xaf
> [<c010487d>] sysenter_past_esp+0x9a/0xa5
> [<c0130556>] trace_hardirqs_on+0xdd/0xfd
> [<c0155b72>] kmem_cache_free+0x53/0x5a
> [<c0130556>] trace_hardirqs_on+0xdd/0xfd
> [<c01619e7>] __user_walk_fd+0x37/0x3f
> [<c016f114>] sys_lremovexattr+0x2b/0x3c
> [<c010487d>] sysenter_past_esp+0x9a/0xa5
> [<c0130556>] trace_hardirqs_on+0xdd/0xfd
> [<c010487d>] sysenter_past_esp+0x9a/0xa5
> [<c0104842>] sysenter_past_esp+0x5f/0xa5
> =======================
> 
> step to reproduce:
> - mount /home as reiserfs with user_xattr option.
> - run "beagled --fg --debug --indexing-delay 5", and wait 10 seconds.
> 
> 
> ~~
> laurent
> -
> To unsubscribe from this list: send the line "unsubscribe
> reiserfs-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFHv2G/LPWxlyuTD7IRAgCpAJ0e1n1jo2z+O4MivXNkhpCc1f1PjwCaAiAr
2BX+r7qnceZwveGzpsbR0PY=
=+Z/7
-----END PGP SIGNATURE-----
