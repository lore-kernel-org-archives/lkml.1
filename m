Return-Path: <linux-kernel-owner+w=401wt.eu-S1753102AbZBJFUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102AbZBJFUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 00:20:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750946AbZBJFTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 00:19:54 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61823 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750823AbZBJFTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 00:19:54 -0500
Message-ID: <49910E55.7050905@cn.fujitsu.com>
Date: Tue, 10 Feb 2009 13:19:17 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Paul Menage <menage@google.com>, Arjan van de Ven <arjan@infradead.org>,
       linux-fsdevel@vger.kernel.org
Subject: Re: [cgroup or VFS ?] INFO: possible recursive locking detected
References: <49617D2E.8050502@cn.fujitsu.com> <496576E7.1@cn.fujitsu.com> <20090209112321.GW28946@ZenIV.linux.org.uk> <1234180131.5951.85.camel@laptop> <4990EF3F.3010501@cn.fujitsu.com> <20090210043733.GY28946@ZenIV.linux.org.uk>
In-Reply-To: <20090210043733.GY28946@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro wrote:
> On Tue, Feb 10, 2009 at 11:06:39AM +0800, Li Zefan wrote:
> 
>> BTW, I found another bug in current code:
> 
> Why is that a bug?  If _anything_ had been trying to acquire the
> rwsem in question, it would be fscked anyway.  Not to mention
> that nothing could have ever seen that struct super_block in this
> particular case, as a general rule
> 	* if something might be blocked on your mutex/rwsem or spinning
> on a spinlock, releasing it before you free the object won't save your
> arse.
> 	You have no promise whatsoever that whoever's been trying to
> get the lock in question will even get out of the locking primitive
> before the memory that contains the lock gets freed.  In case of superblocks
> in general, you don't free them until ->s_count hits zero.  At that point
> anything as much as remembering the address of that superblock is already
> FUBAR.
> 

This is not the general case. This sb won't be seen by anyone, and destroy_super()
is called on a sb with ->s_count == 1 and ->s_umount held.

Actually I ran into this after Peter's patch applied:

=========================
[ BUG: held lock freed! ]
-------------------------
mount/13413 is freeing memory e767a800-e767abff, with a lock still held there!
 (&type->s_umount_key#29/1){--..}, at: [<c04a4104>] sget+0x1ea/0x324
2 locks held by mount/13413:
 #0:  (&type->s_umount_key#29/1){--..}, at: [<c04a4104>] sget+0x1ea/0x324
 #1:  (&type->s_umount_key#30){--..}, at: [<c04a3f72>] sget+0x58/0x324

stack backtrace:
Pid: 13413, comm: mount Not tainted 2.6.29-rc4 #548
Call Trace:
 [<c044d865>] debug_check_no_locks_freed+0xc9/0x105
 [<c049c86d>] kfree+0x82/0xd1
 [<c04a41e0>] ? sget+0x2c6/0x324
 [<c04a41e0>] sget+0x2c6/0x324
 [<c045dda9>] ? cgroup_set_super+0x0/0x3e
 [<c045cf6f>] ? cgroup_test_super+0x0/0x2f
 [<c045f840>] cgroup_get_sb+0x8d/0x284
 [<c0489216>] ? kstrdup+0x31/0x53
 [<c04a46aa>] vfs_kern_mount+0x40/0x7b
 [<c04a4733>] do_kern_mount+0x37/0xbf
 [<c04b5dc6>] do_mount+0x5c4/0x61b
 [<c04b477a>] ? copy_mount_options+0x2c/0x111
 [<c04b5e86>] sys_mount+0x69/0xa0
 [<c0403351>] sysenter_do_call+0x12/0x31

