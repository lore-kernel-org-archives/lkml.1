Return-Path: <linux-kernel-owner+w=401wt.eu-S1756314AbZFES2n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756314AbZFES2n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:28:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753898AbZFES2e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:28:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:43719 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752469AbZFES2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:28:33 -0400
Message-ID: <4A296343.4050005@suse.com>
Date: Fri, 05 Jun 2009 14:26:11 -0400
From: Jeff Mahoney <jeffm@suse.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: "Trenton D. Adams" <trenton.d.adams@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Al Viro <viro@zeniv.linux.org.uk>,
       Reiserfs <reiserfs-devel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Chris Mason <chris.mason@oracle.com>, Ingo Molnar <mingo@elte.hu>,
       Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: [PATCH 1/2] kill-the-bkl/reiserfs: acquire the inode mutex safely
References: <1242496922-6330-1-git-send-email-fweisbec@gmail.com>	 <1242496922-6330-2-git-send-email-fweisbec@gmail.com> <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com>
In-Reply-To: <9b1675090905292005p2b53de7dy9e36f84368d76f01@mail.gmail.com>
X-Enigmail-Version: 0.95.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Trenton D. Adams wrote:
> On Sat, May 16, 2009 at 12:02 PM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
>> While searching a pathname, an inode mutex can be acquired
>> in do_lookup() which calls reiserfs_lookup() which in turn
>> acquires the write lock.
>>
>> On the other side reiserfs_fill_super() can acquire the write_lock
>> and then call reiserfs_lookup_privroot() which can acquire an
>> inode mutex (the root of the mount point).
>>
>> So we theoretically risk an AB - BA lock inversion that could lead
>> to a deadlock.
>>
>> As for other lock dependencies found since the bkl to mutex
>> conversion, the fix is to use reiserfs_mutex_lock_safe() which
>> drops the lock dependency to the write lock.
>>
> 
> I'm curious, did this get applied, and is it related to the following?
>  I was having these in 2.6.30-rc3.  I am now on 2.6.30-rc7 as of
> today.  I haven't seen them today.  But then again, I only seen this
> happen one time.
> 
> May 27 01:56:12 tdamac INFO: task pdflush:15370 blocked for more than
> 120 seconds.
> May 27 01:56:12 tdamac "echo 0 >
> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> May 27 01:56:12 tdamac pdflush       D ffff8800518a0000     0 15370      2
> May 27 01:56:12 tdamac ffff880025023b50 0000000000000046
> 0000000025023a90 000000000000d7a0
> May 27 01:56:12 tdamac 0000000000004000 0000000000011440
> 000000000000ca78 ffff880045e71568
> May 27 01:56:12 tdamac ffff880045e7156c ffff8800518a0000
> ffff880067f54230 ffff8800518a0380
> May 27 01:56:12 tdamac Call Trace:
> May 27 01:56:12 tdamac [<ffffffff80687d1b>] ? __mutex_lock_slowpath+0xe2/0x124
> May 27 01:56:12 tdamac [<ffffffff80687d13>] __mutex_lock_slowpath+0xda/0x124
> May 27 01:56:12 tdamac [<ffffffff8068809e>] mutex_lock+0x1e/0x36
> May 27 01:56:12 tdamac [<ffffffff803087ae>] flush_commit_list+0x150/0x689
> May 27 01:56:12 tdamac [<ffffffff8022f8e5>] ? __wake_up+0x43/0x50
> May 27 01:56:12 tdamac [<ffffffff8030ad8a>] do_journal_end+0xb4a/0xd6c
> May 27 01:56:12 tdamac [<ffffffff8023053d>] ? dequeue_entity+0x1b/0x1df
> May 27 01:56:12 tdamac [<ffffffff8030b020>] journal_end_sync+0x74/0x7d
> May 27 01:56:12 tdamac [<ffffffff802fd2fd>] reiserfs_sync_fs+0x41/0x67
> May 27 01:56:12 tdamac [<ffffffff80688091>] ? mutex_lock+0x11/0x36
> May 27 01:56:12 tdamac [<ffffffff802fd331>] reiserfs_write_super+0xe/0x10
> May 27 01:56:12 tdamac [<ffffffff802a532a>] sync_supers+0x61/0xa6
> May 27 01:56:12 tdamac [<ffffffff8027e140>] wb_kupdate+0x32/0x128
> May 27 01:56:12 tdamac [<ffffffff8027ee7c>] pdflush+0x140/0x21f
> May 27 01:56:12 tdamac [<ffffffff8027e10e>] ? wb_kupdate+0x0/0x128
> May 27 01:56:12 tdamac [<ffffffff8027ed3c>] ? pdflush+0x0/0x21f
> May 27 01:56:12 tdamac [<ffffffff8024fb26>] kthread+0x56/0x83
> May 27 01:56:12 tdamac [<ffffffff8020beba>] child_rip+0xa/0x20
> May 27 01:56:12 tdamac [<ffffffff8024fad0>] ? kthread+0x0/0x83
> May 27 01:56:12 tdamac [<ffffffff8020beb0>] ? child_rip+0x0/0x20

Can you capture a sysrq+t when this happens? The lock is properly
released, but I have a hunch that another thread is doing ordered
writeback that's taking a while. That happens under the j_commit_mutex.

- -Jeff

- --
Jeff Mahoney
SUSE Labs
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkopY0MACgkQLPWxlyuTD7IM0gCdGepeXFcB68gcCaXCb3Z/KTg9
F5MAn3rOomgVzmXfI4DKtIHqKxwLNDj0
=qzqo
-----END PGP SIGNATURE-----
