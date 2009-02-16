Return-Path: <linux-kernel-owner+w=401wt.eu-S1756411AbZBPKrL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756411AbZBPKrL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 05:47:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbZBPKqz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 05:46:55 -0500
Received: from mail-gx0-f222.google.com ([209.85.217.222]:56072 "EHLO
	mail-gx0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbZBPKqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 05:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ixCuYongpPgT6KxrhFiFPbwizL0Q6WZSHDDaXTfOC1TDGe9A8ZWN7jsGV1GvLwk68g
         XOZ+KNQ4wPV5e7Zg9XcTcaQheMcJ+5w7+D39Jt597PHwCtvSXogEBk/sC+uW8oitbwff
         Hci/40A8eO+r/7f/vqF1IX04vlPsVVn6mnZuU=
MIME-Version: 1.0
In-Reply-To: <1234780480.4703.13.camel@laptop>
References: <20090216081304.GA18980@elte.hu> <1234780480.4703.13.camel@laptop>
Date: Mon, 16 Feb 2009 19:46:52 +0900
Message-ID: <28c262360902160246s7507ab6sb7f0b1d758c3671d@mail.gmail.com>
Subject: Re: [locking bug] inotify: inconsistent {RECLAIM_FS-ON-W} -> 
	{IN-RECLAIM_FS-W} usage.
From: MinChan Kim <minchan.kim@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-fsdevel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
       MinChan Kim <minchan.kim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ingo and Peter.

FYI,
Before, I reported this problem.

http://lkml.org/lkml/2009/2/2/415

But, fs-guy didn't have any response.
Let's retry.


On Mon, Feb 16, 2009 at 7:34 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Mon, 2009-02-16 at 09:13 +0100, Ingo Molnar wrote:
>
>> From 3023a3e27b909b3b309edac4bc9beb8103f127fa Mon Sep 17 00:00:00 2001
>> From: Ingo Molnar <mingo@elte.hu>
>> Date: Mon, 16 Feb 2009 09:10:32 +0100
>> Subject: [PATCH] inotify: fix GFP_KERNEL related deadlock
>>
>> enhanced lockdep coverage of __GFP_NOFS turned up this new
>> lockdep assert:
>>
>> [ 1093.677775]
>> [ 1093.677781] =================================
>> [ 1093.680031] [ INFO: inconsistent lock state ]
>> [ 1093.680031] 2.6.29-rc5-tip-01504-gb49eca1-dirty #1
>> [ 1093.680031] ---------------------------------
>> [ 1093.680031] inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
>> [ 1093.680031] kswapd0/308 [HC0[0]:SC0[0]:HE1:SE1] takes:
>> [ 1093.680031]  (&inode->inotify_mutex){+.+.?.}, at: [<c0205942>] inotify_inode_is_dead+0x20/0x80
>> [ 1093.680031] {RECLAIM_FS-ON-W} state was registered at:
>> [ 1093.680031]   [<c01696b9>] mark_held_locks+0x43/0x5b
>> [ 1093.680031]   [<c016baa4>] lockdep_trace_alloc+0x6c/0x6e
>> [ 1093.680031]   [<c01cf8b0>] kmem_cache_alloc+0x20/0x150
>> [ 1093.680031]   [<c040d0ec>] idr_pre_get+0x27/0x6c
>> [ 1093.680031]   [<c02056e3>] inotify_handle_get_wd+0x25/0xad
>> [ 1093.680031]   [<c0205f43>] inotify_add_watch+0x7a/0x129
>> [ 1093.680031]   [<c020679e>] sys_inotify_add_watch+0x20f/0x250
>> [ 1093.680031]   [<c010389e>] sysenter_do_call+0x12/0x35
>> [ 1093.680031]   [<ffffffff>] 0xffffffff
>> [ 1093.680031] irq event stamp: 60417
>> [ 1093.680031] hardirqs last  enabled at (60417): [<c018d5f5>] call_rcu+0x53/0x59
>> [ 1093.680031] hardirqs last disabled at (60416): [<c018d5b9>] call_rcu+0x17/0x59
>> [ 1093.680031] softirqs last  enabled at (59656): [<c0146229>] __do_softirq+0x157/0x16b
>> [ 1093.680031] softirqs last disabled at (59651): [<c0106293>] do_softirq+0x74/0x15d
>> [ 1093.680031]
>> [ 1093.680031] other info that might help us debug this:
>> [ 1093.680031] 2 locks held by kswapd0/308:
>> [ 1093.680031]  #0:  (shrinker_rwsem){++++..}, at: [<c01b0502>] shrink_slab+0x36/0x189
>> [ 1093.680031]  #1:  (&type->s_umount_key#4){+++++.}, at: [<c01e6d77>] shrink_dcache_memory+0x110/0x1fb
>> [ 1093.680031]
>> [ 1093.680031] stack backtrace:
>> [ 1093.680031] Pid: 308, comm: kswapd0 Not tainted 2.6.29-rc5-tip-01504-gb49eca1-dirty #1
>> [ 1093.680031] Call Trace:
>> [ 1093.680031]  [<c016947a>] valid_state+0x12a/0x13d
>> [ 1093.680031]  [<c016954e>] mark_lock+0xc1/0x1e9
>> [ 1093.680031]  [<c016a5b4>] ? check_usage_forwards+0x0/0x3f
>> [ 1093.680031]  [<c016ab74>] __lock_acquire+0x2c6/0xac8
>> [ 1093.680031]  [<c01688d9>] ? register_lock_class+0x17/0x228
>> [ 1093.680031]  [<c016b3d3>] lock_acquire+0x5d/0x7a
>> [ 1093.680031]  [<c0205942>] ? inotify_inode_is_dead+0x20/0x80
>> [ 1093.680031]  [<c08824c4>] __mutex_lock_common+0x3a/0x4cb
>> [ 1093.680031]  [<c0205942>] ? inotify_inode_is_dead+0x20/0x80
>> [ 1093.680031]  [<c08829ed>] mutex_lock_nested+0x2e/0x36
>> [ 1093.680031]  [<c0205942>] ? inotify_inode_is_dead+0x20/0x80
>> [ 1093.680031]  [<c0205942>] inotify_inode_is_dead+0x20/0x80
>> [ 1093.680031]  [<c01e6672>] dentry_iput+0x90/0xc2
>> [ 1093.680031]  [<c01e67a3>] d_kill+0x21/0x45
>> [ 1093.680031]  [<c01e6a46>] __shrink_dcache_sb+0x27f/0x355
>> [ 1093.680031]  [<c01e6dc5>] shrink_dcache_memory+0x15e/0x1fb
>> [ 1093.680031]  [<c01b05ed>] shrink_slab+0x121/0x189
>> [ 1093.680031]  [<c01b0d12>] kswapd+0x39f/0x561
>> [ 1093.680031]  [<c01ae499>] ? isolate_pages_global+0x0/0x233
>> [ 1093.680031]  [<c0157eae>] ? autoremove_wake_function+0x0/0x43
>> [ 1093.680031]  [<c01b0973>] ? kswapd+0x0/0x561
>> [ 1093.680031]  [<c0157daf>] kthread+0x41/0x82
>> [ 1093.680031]  [<c0157d6e>] ? kthread+0x0/0x82
>> [ 1093.680031]  [<c01043ab>] kernel_thread_helper+0x7/0x10
>>
>> inotify_handle_get_wd() does idr_pre_get() which does a
>> kmem_cache_alloc() without __GFP_FS - and is hence deadlockable under
>> extreme MM pressure.
>>
>> Signed-off-by: Ingo Molnar <mingo@elte.hu>
>
> Looks like a good catch,
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>
>> ---
>>  fs/notify/inotify/inotify.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/notify/inotify/inotify.c b/fs/notify/inotify/inotify.c
>> index dae3f28..331f2e8 100644
>> --- a/fs/notify/inotify/inotify.c
>> +++ b/fs/notify/inotify/inotify.c
>> @@ -156,7 +156,7 @@ static int inotify_handle_get_wd(struct inotify_handle *ih,
>>       int ret;
>>
>>       do {
>> -             if (unlikely(!idr_pre_get(&ih->idr, GFP_KERNEL)))
>> +             if (unlikely(!idr_pre_get(&ih->idr, GFP_NOFS)))
>>                       return -ENOSPC;
>>               ret = idr_get_new_above(&ih->idr, watch, ih->last_wd+1, &watch->wd);
>>       } while (ret == -EAGAIN);
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Kinds regards,
MinChan Kim
