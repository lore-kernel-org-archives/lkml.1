Return-Path: <linux-kernel-owner+w=401wt.eu-S1030428AbXBTV3J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030428AbXBTV3J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 16:29:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030430AbXBTV3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 16:29:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:34172 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030428AbXBTV3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 16:29:06 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.20-mm2: possible recursive locking detected (reiserfs-related)
Date: Tue, 20 Feb 2007 22:23:53 +0100
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
In-Reply-To: <20070217215146.30e7ffa3.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200702202223.54046.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 18 February 2007 06:51, Andrew Morton wrote:
> 
> Temporarily at
> 
>   http://userweb.kernel.org/~akpm/2.6.20-mm2/
> 
> Will appear later at
> 
>  ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.20/2.6.20-mm2/

Looks like reiserfs has some locking problems:

=============================================
[ INFO: possible recursive locking detected ]
2.6.20-mm2 #6
---------------------------------------------
beagled/4786 is trying to acquire lock:
 (&inode->i_mutex){--..}, at: [<ffffffff80479df9>] mutex_lock+0x19/0x20

but task is already holding lock:
 (&inode->i_mutex){--..}, at: [<ffffffff80479df9>] mutex_lock+0x19/0x20

other info that might help us debug this:
3 locks held by beagled/4786:
 #0:  (&inode->i_mutex){--..}, at: [<ffffffff80479df9>] mutex_lock+0x19/0x20
 #1:  (&REISERFS_I(inode)->xattr_sem){----}, at: [<ffffffff80304c99>] reiserfs_setxattr+0x79/0x150
 #2:  (&REISERFS_SB(s)->xattr_dir_sem){----}, at: [<ffffffff80304cc0>] reiserfs_setxattr+0xa0/0x150

stack backtrace:

Call Trace:
 [<ffffffff8024823f>] __lock_acquire+0xa9f/0xf30
 [<ffffffff80479df9>] mutex_lock+0x19/0x20
 [<ffffffff80248758>] lock_acquire+0x88/0xc0
 [<ffffffff80479df9>] mutex_lock+0x19/0x20
 [<ffffffff80479c5c>] __mutex_lock_slowpath+0xec/0x270
 [<ffffffff8028d63a>] dentry_open+0x6a/0x80
 [<ffffffff80479df9>] mutex_lock+0x19/0x20
 [<ffffffff803052c7>] reiserfs_xattr_set+0x127/0x3d0
 [<ffffffff80246ffd>] mark_held_locks+0x5d/0x90
 [<ffffffff8047add8>] __down_write_nested+0x38/0xb0
 [<ffffffff8024722f>] trace_hardirqs_on+0x13f/0x170
 [<ffffffff8047b96b>] _spin_unlock_irq+0x2b/0x40
 [<ffffffff80305698>] user_set+0x68/0x90
 [<ffffffff80304cd4>] reiserfs_setxattr+0xb4/0x150
 [<ffffffff802ad829>] vfs_setxattr+0xb9/0x200
 [<ffffffff802ada5a>] setxattr+0xea/0x110
 [<ffffffff8024722f>] trace_hardirqs_on+0x13f/0x170
 [<ffffffff8028a342>] poison_obj+0x42/0x60
 [<ffffffff8028aa75>] kmem_cache_free+0xf5/0x110
 [<ffffffff8024722f>] trace_hardirqs_on+0x13f/0x170
 [<ffffffff80298aef>] putname+0x3f/0x50
 [<ffffffff8029ac67>] __user_walk_fd+0x57/0x70
 [<ffffffff802adae3>] sys_lsetxattr+0x63/0x90
 [<ffffffff8047b020>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8024722f>] trace_hardirqs_on+0x13f/0x170
 [<ffffffff8047b020>] trace_hardirqs_on_thunk+0x35/0x37
 [<ffffffff8020989e>] system_call+0x7e/0x83
