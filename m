Return-Path: <linux-kernel-owner+w=401wt.eu-S1758188AbZLNULl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758188AbZLNULl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 15:11:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757798AbZLNULj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 15:11:39 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:47160 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975AbZLNULh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 15:11:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ZwmJnuRXxorpYExOrEzL8+yAZx9qx4Ts0LVQDgpwvTurvgfgsc9TK59M474fm7ANN0
         fHg2bE/FMIRFOjBbHg8frr3Hls62CthYhrnRijeFZWN2ek2qWV4/fTxBsyBBTNldAqei
         9KDGk1IPBuzVRJO7nlaCOdIEveGHr+1ijy0Uo=
MIME-Version: 1.0
In-Reply-To: <20091214110921.GA5168@nowhere>
References: <a4423d670912111406g5967eb1fw93e49de242fbf54@mail.gmail.com>
	 <20091214110921.GA5168@nowhere>
Date: Mon, 14 Dec 2009 23:11:35 +0300
Message-ID: <a4423d670912141211q3e63011ftfd526ec541b09d44@mail.gmail.com>
Subject: Re: 2.6.33-rc0: reiserfs: inconsistent lock state
From: Alexander Beregalov <a.beregalov@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/12/14 Frederic Weisbecker <fweisbec@gmail.com>:
> On Sat, Dec 12, 2009 at 01:06:29AM +0300, Alexander Beregalov wrote:
>> Hi Frederic
>>
>> It is x86_32 UP
>>
>>
>> [ INFO: inconsistent lock state ]
>> 2.6.32-05594-g3ef884b #2
> [...]
>
>
> Thanks! I've pushed two fixes in my tree. May be could
> you test them by merging it on latest upstream?
>
> As usual, it's on:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
>        reiserfs/kill-bkl

Thanks, I'm going to test it.

Another piece of work for you. You should hate me.

[ INFO: possible circular locking dependency detected ]
2.6.32-06793-gf405425-dirty #2
-------------------------------------------------------
mv/18566 is trying to acquire lock:
 (&REISERFS_SB(s)->lock){+.+.+.}, at: [<c1110708>] reiserfs_write_lock+0x28/0x40

but task is already holding lock:
 (&sb->s_type->i_mutex_key#5/3){+.+.+.}, at: [<c111033c>]
reiserfs_for_each_xattr+0x10c/0x380

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&sb->s_type->i_mutex_key#5/3){+.+.+.}:
       [<c104f723>] validate_chain+0xa23/0xf70
       [<c1050155>] __lock_acquire+0x4e5/0xa70
       [<c105075a>] lock_acquire+0x7a/0xa0
       [<c134c76f>] mutex_lock_nested+0x5f/0x2b0
       [<c11102b4>] reiserfs_for_each_xattr+0x84/0x380
       [<c1110615>] reiserfs_delete_xattrs+0x15/0x50
       [<c10ef57f>] reiserfs_delete_inode+0x8f/0x140
       [<c10a565c>] generic_delete_inode+0x9c/0x150
       [<c10a574d>] generic_drop_inode+0x3d/0x60
       [<c10a4667>] iput+0x47/0x50
       [<c109cc0b>] do_unlinkat+0xdb/0x160
       [<c109cca0>] sys_unlink+0x10/0x20
       [<c1002c50>] sysenter_do_call+0x12/0x36

-> #0 (&REISERFS_SB(s)->lock){+.+.+.}:
       [<c104fc68>] validate_chain+0xf68/0xf70
       [<c1050155>] __lock_acquire+0x4e5/0xa70
       [<c105075a>] lock_acquire+0x7a/0xa0
       [<c134c76f>] mutex_lock_nested+0x5f/0x2b0
       [<c1110708>] reiserfs_write_lock+0x28/0x40
       [<c1103d6b>] search_by_key+0x1f7b/0x21b0
       [<c10e73ef>] search_by_entry_key+0x1f/0x3b0
       [<c10e77f7>] reiserfs_find_entry+0x77/0x400
       [<c10e81e5>] reiserfs_lookup+0x85/0x130
       [<c109a144>] __lookup_hash+0xb4/0x110
       [<c109b763>] lookup_one_len+0xb3/0x100
       [<c1110350>] reiserfs_for_each_xattr+0x120/0x380
       [<c1110615>] reiserfs_delete_xattrs+0x15/0x50
       [<c10ef57f>] reiserfs_delete_inode+0x8f/0x140
       [<c10a565c>] generic_delete_inode+0x9c/0x150
       [<c10a574d>] generic_drop_inode+0x3d/0x60
       [<c10a4667>] iput+0x47/0x50
       [<c10a1c4f>] dentry_iput+0x6f/0xf0
       [<c10a1d74>] d_kill+0x24/0x50
       [<c10a396b>] dput+0x5b/0x120
       [<c109ca89>] sys_renameat+0x1b9/0x230
       [<c109cb28>] sys_rename+0x28/0x30
       [<c1002c50>] sysenter_do_call+0x12/0x36

other info that might help us debug this:

2 locks held by mv/18566:
 #0:  (&sb->s_type->i_mutex_key#5/1){+.+.+.}, at: [<c109b6ac>]
lock_rename+0xcc/0xd0
 #1:  (&sb->s_type->i_mutex_key#5/3){+.+.+.}, at: [<c111033c>]
reiserfs_for_each_xattr+0x10c/0x380

stack backtrace:
Pid: 18566, comm: mv Tainted: G         C 2.6.32-06793-gf405425-dirty #2
Call Trace:
 [<c134b252>] ? printk+0x18/0x1e
 [<c104e790>] print_circular_bug+0xc0/0xd0
 [<c104fc68>] validate_chain+0xf68/0xf70
 [<c104c8cb>] ? trace_hardirqs_off+0xb/0x10
 [<c1050155>] __lock_acquire+0x4e5/0xa70
 [<c105075a>] lock_acquire+0x7a/0xa0
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c134c76f>] mutex_lock_nested+0x5f/0x2b0
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c134b60a>] ? schedule+0x27a/0x440
 [<c1110708>] reiserfs_write_lock+0x28/0x40
 [<c1103d6b>] search_by_key+0x1f7b/0x21b0
 [<c1050176>] ? __lock_acquire+0x506/0xa70
 [<c1051267>] ? lock_release_non_nested+0x1e7/0x340
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c104e354>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c104e3ab>] ? trace_hardirqs_on+0xb/0x10
 [<c1042a55>] ? T.316+0x15/0x1a0
 [<c1042d2d>] ? sched_clock_cpu+0x9d/0x100
 [<c10e73ef>] search_by_entry_key+0x1f/0x3b0
 [<c134bf2a>] ? __mutex_unlock_slowpath+0x9a/0x120
 [<c104e354>] ? trace_hardirqs_on_caller+0x124/0x170
 [<c10e77f7>] reiserfs_find_entry+0x77/0x400
 [<c10e81e5>] reiserfs_lookup+0x85/0x130
 [<c1042d2d>] ? sched_clock_cpu+0x9d/0x100
 [<c109a144>] __lookup_hash+0xb4/0x110
 [<c109b763>] lookup_one_len+0xb3/0x100
 [<c1110350>] reiserfs_for_each_xattr+0x120/0x380
 [<c110ffe0>] ? delete_one_xattr+0x0/0x1c0
 [<c1003342>] ? math_error+0x22/0x150
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c1110615>] reiserfs_delete_xattrs+0x15/0x50
 [<c1110708>] ? reiserfs_write_lock+0x28/0x40
 [<c10ef57f>] reiserfs_delete_inode+0x8f/0x140
 [<c10a561f>] ? generic_delete_inode+0x5f/0x150
 [<c10ef4f0>] ? reiserfs_delete_inode+0x0/0x140
 [<c10a565c>] generic_delete_inode+0x9c/0x150
 [<c10a574d>] generic_drop_inode+0x3d/0x60
 [<c10a4667>] iput+0x47/0x50
 [<c10a1c4f>] dentry_iput+0x6f/0xf0
 [<c10a1d74>] d_kill+0x24/0x50
 [<c10a396b>] dput+0x5b/0x120
 [<c109ca89>] sys_renameat+0x1b9/0x230
 [<c1042d2d>] ? sched_clock_cpu+0x9d/0x100
 [<c104c8cb>] ? trace_hardirqs_off+0xb/0x10
 [<c1042dde>] ? cpu_clock+0x4e/0x60
 [<c1350825>] ? do_page_fault+0x155/0x370
 [<c1041816>] ? up_read+0x16/0x30
 [<c1350825>] ? do_page_fault+0x155/0x370
 [<c109cb28>] sys_rename+0x28/0x30
 [<c1002c50>] sysenter_do_call+0x12/0x36
