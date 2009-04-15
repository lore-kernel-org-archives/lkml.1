Return-Path: <linux-kernel-owner+w=401wt.eu-S1759172AbZDOL7m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759172AbZDOL7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 07:59:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753965AbZDOL7d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 07:59:33 -0400
Received: from mail-fx0-f158.google.com ([209.85.220.158]:61150 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753046AbZDOL7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 07:59:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mfYhDzikbVscq4s/RSCw6CgeVuKl5qJYh57BUhtC40Hnc499JnqIA7tMsU415S8a6m
         ZxfcodpD/E41nEbGW8f9fuE2ZOJMjkY0k+OZm3uGdNXiYjCaxAdtaOkVxx66aIQ7ZdHf
         sDe9p1M52yZNQMUzmft+Ik83RFmJgHGNcB+5A=
MIME-Version: 1.0
In-Reply-To: <20090414161329.094b977c.akpm@linux-foundation.org>
References: <20090410192533.GA24345@dreamland.darkstar.lan>
	 <20090414161329.094b977c.akpm@linux-foundation.org>
Date: Wed, 15 Apr 2009 13:59:29 +0200
Message-ID: <68676e00904150459q6cc34f9fjb9475937a4e73c71@mail.gmail.com>
Subject: Re: [PATCH] Fix inconsistent lock state in inotify
From: Luca Tettamanti <kronos.it@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, john@johnmccutchan.com, rlove@rlove.org,
       Eric Paris <eparis@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 15, 2009 at 1:13 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Fri, 10 Apr 2009 21:25:33 +0200
> Luca Tettamanti <kronos.it@gmail.com> wrote:
>
>> Hello,
>> in current -git lockdep generates the following warning:
>>
>>  =================================
>>  [ INFO: inconsistent lock state ]
>>  2.6.30-rc1-kgdb #182
>>  ---------------------------------
>>  inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-W} usage.
>>  kswapd0/419 [HC0[0]:SC0[0]:HE1:SE1] takes:
>>   (&inode->inotify_mutex){+.+.?.}, at: [<ffffffff802c7036>] inotify_inode_is_dead+0x30/0x94
>>  {RECLAIM_FS-ON-W} state was registered at:
>>    [<ffffffff80259621>] mark_held_locks+0x4d/0x6b
>>    [<ffffffff802596e3>] lockdep_trace_alloc+0xa4/0xbd
>>    [<ffffffff8029ac2e>] __kmalloc+0x51/0xe6
>>    [<ffffffff802c7ea2>] kernel_event+0xa7/0x10e
>>    [<ffffffff802c7fdc>] inotify_dev_queue_event+0xd3/0x14b
>>    [<ffffffff802c6f56>] inotify_inode_queue_event+0xab/0xe0
>>    [<ffffffff802a6d83>] vfs_create+0xb1/0xc0
>>    [<ffffffff802a975a>] do_filp_open+0x240/0x842
>>    [<ffffffff8029cb1e>] do_sys_open+0x53/0xda
>>    [<ffffffff802d0a62>] compat_sys_open+0x15/0x17
>>    [<ffffffff80228e14>] sysenter_dispatch+0x7/0x30
>>    [<ffffffffffffffff>] 0xffffffffffffffff
>>  irq event stamp: 30075
>>  hardirqs last  enabled at (30075): [<ffffffff802712cf>] call_rcu+0x5d/0x6a
>>  hardirqs last disabled at (30074): [<ffffffff80271296>] call_rcu+0x24/0x6a
>>  softirqs last  enabled at (27584): [<ffffffff8023d151>] __do_softirq+0x115/0x124
>>  softirqs last disabled at (27573): [<ffffffff8020c13c>] call_softirq+0x1c/0x28
>>
>>  other info that might help us debug this:
>>  2 locks held by kswapd0/419:
>>   #0:  (shrinker_rwsem){++++..}, at: [<ffffffff8027dd86>] shrink_slab+0x38/0x188
>>   #1:  (&type->s_umount_key#16){++++..}, at: [<ffffffff802ad8c9>] shrink_dcache_memory+0xb9/0x193
>>
>>  stack backtrace:
>>  Pid: 419, comm: kswapd0 Not tainted 2.6.30-rc1-kgdb #182
>>  Call Trace:
>>   [<ffffffff8025906c>] print_usage_bug+0x1b6/0x1c7
>>   [<ffffffff80259c54>] ? check_usage_forwards+0x0/0xa1
>>   [<ffffffff8025938f>] mark_lock+0x312/0x557
>>   [<ffffffff8025ad03>] __lock_acquire+0x7b7/0x1668
>>   [<ffffffff802c7036>] ? inotify_inode_is_dead+0x30/0x94
>>   [<ffffffff8025bc09>] lock_acquire+0x55/0x71
>>   [<ffffffff802c7036>] ? inotify_inode_is_dead+0x30/0x94
>>   [<ffffffff80442ec8>] mutex_lock_nested+0x5a/0x2fa
>>   [<ffffffff802c7036>] ? inotify_inode_is_dead+0x30/0x94
>>   [<ffffffff80259621>] ? mark_held_locks+0x4d/0x6b
>>   [<ffffffff802712cf>] ? call_rcu+0x5d/0x6a
>>   [<ffffffff802c7036>] inotify_inode_is_dead+0x30/0x94
>>   [<ffffffff802ad3f1>] dentry_iput+0x82/0xc1
>>   [<ffffffff802ad4f9>] d_kill+0x24/0x45
>>   [<ffffffff802ad778>] __shrink_dcache_sb+0x25e/0x2f6
>>   [<ffffffff802ad901>] shrink_dcache_memory+0xf1/0x193
>>   [<ffffffff8027de2d>] shrink_slab+0xdf/0x188
>>   [<ffffffff8027e3be>] kswapd+0x4e8/0x6a3
>>   [<ffffffff80232d0c>] ? finish_task_switch+0x3b/0x10c
>>   [<ffffffff8027bec4>] ? isolate_pages_global+0x0/0x26f
>>   [<ffffffff8024becf>] ? autoremove_wake_function+0x0/0x38
>>   [<ffffffff802598d6>] ? trace_hardirqs_on+0xd/0xf
>>   [<ffffffff80444a41>] ? _spin_unlock_irqrestore+0x4c/0x68
>>   [<ffffffff8027ded6>] ? kswapd+0x0/0x6a3
>>   [<ffffffff8027ded6>] ? kswapd+0x0/0x6a3
>>   [<ffffffff8024bb80>] kthread+0x49/0x76
>>   [<ffffffff8020c03a>] child_rip+0xa/0x20
>>   [<ffffffff8020ba00>] ? restore_args+0x0/0x30
>>   [<ffffffff8024bb37>] ? kthread+0x0/0x76
>>   [<ffffffff8020c030>] ? child_rip+0x0/0x20
>>
>> The cause is a call to kmalloc with GFP_KERNEL; the following patch
>> changes the flag to GFP_NOFS, which is also consistent with an earlier
>> call to kmem_cache_alloc in the same function.
>>
>> Signed-off-by: Luca Tettamanti <kronos.it@gmail.com>
>> ---
>>
>>  fs/notify/inotify/inotify_user.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/notify/inotify/inotify_user.c b/fs/notify/inotify/inotify_user.c
>> index bed766e..1634319 100644
>> --- a/fs/notify/inotify/inotify_user.c
>> +++ b/fs/notify/inotify/inotify_user.c
>> @@ -220,7 +220,7 @@ static struct inotify_kernel_event * kernel_event(s32 wd, u32 mask, u32 cookie,
>>                               rem = 0;
>>               }
>>
>> -             kevent->name = kmalloc(len + rem, GFP_KERNEL);
>> +             kevent->name = kmalloc(len + rem, GFP_NOFS);
>>               if (unlikely(!kevent->name)) {
>>                       kmem_cache_free(event_cachep, kevent);
>>                       return NULL;
>
> Thanks.
>
> This is in fact a false positive and we plan to fix it via lockdep
> annotation.

Well, I trust you on the "false positive", but a few line before there this:

  kevent = kmem_cache_alloc(event_cachep, GFP_NOFS);

so can kmem_cache_alloc also use GFP_KERNEL?

Luca
