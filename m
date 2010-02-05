Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933625Ab0BEH0G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Feb 2010 02:26:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42318 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933310Ab0BEH0D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Feb 2010 02:26:03 -0500
Message-ID: <4B6BC87D.1090603@redhat.com>
Date: Fri, 05 Feb 2010 15:27:57 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Xiaotian Feng <xtfeng@gmail.com>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Zijlstra <peterz@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Miles Lane <miles.lane@gmail.com>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Larry Finger <Larry.Finger@lwfinger.net>, akpm@linux-foundation.org
Subject: Re: [Patch v2] sysfs: add lockdep class support to s_active
References: <20100205064622.4141.72867.sendpatchset@localhost.localdomain> <7b6bb4a51002042309v3ca1dd0p60b9dbcacdafaee6@mail.gmail.com>
In-Reply-To: <7b6bb4a51002042309v3ca1dd0p60b9dbcacdafaee6@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiaotian Feng wrote:
> On Fri, Feb 5, 2010 at 2:42 PM, Amerigo Wang <amwang@redhat.com> wrote:
>> Recently we met a lockdep warning from sysfs during s2ram or cpu hotplug.
>> As reported by several people, it is something like:
>>
>> [ 6967.926563] ACPI: Preparing to enter system sleep state S3
>> [ 6967.956156] Disabling non-boot CPUs ...
>> [ 6967.970401]
>> [ 6967.970408] =============================================
>> [ 6967.970419] [ INFO: possible recursive locking detected ]
>> [ 6967.970431] 2.6.33-rc2-git6 #27
>> [ 6967.970439] ---------------------------------------------
>> [ 6967.970450] pm-suspend/22147 is trying to acquire lock:
>> [ 6967.970460]  (s_active){++++.+}, at: [<c10d2941>]
>> sysfs_hash_and_remove+0x3d/0x4f
>> [ 6967.970493]
>> [ 6967.970497] but task is already holding lock:
>> [ 6967.970506]  (s_active){++++.+}, at: [<c10d4110>]
>> sysfs_get_active_two+0x16/0x36
>> [...]
>>
>> Eric already provides a patch for this[1], but it still can't fix the
>> problem. Based on his work and Peter's suggestion, I write this patch,
>> hopefully we can fix the warning completely.
>>
>> This patch put sysfs s_active into two classes, one is for PM, the other
>> is for the rest, so lockdep will distinguish them.
> 
> I think this patch does not hit the root cause, we have a similiar
> warning which is not related with PM.
> Reported by Nick when he's trying to switch evalator. It is
> reproducable with "echo deadline >/sys/block/sdx/queue/scheduler"
> while kernel is using cfq.
> 


Well, the four reports that I got are all pm-related,
this one is new for me.

I think adding another class for io_scheduler would fix this.

Thanks.

> [ INFO: possible recursive locking detected ]
> 2.6.33-rc6 #1
> ---------------------------------------------
> sh/889 is trying to acquire lock:
>  (s_active){++++.+}, at: [<7820a975>] sysfs_addrm_finish+0x27/0x4e
> 
> but task is already holding lock:
>  (s_active){++++.+}, at: [<7820ab82>] sysfs_get_active_two+0x18/0x3e
> 
> other info that might help us debug this:
> 4 locks held by sh/889:
>  #0:  (&buffer->mutex){+.+.+.}, at: [<7820984e>] sysfs_write_file+0x20/0x99
>  #1:  (s_active){++++.+}, at: [<7820ab82>] sysfs_get_active_two+0x18/0x3e
>  #2:  (s_active){++++.+}, at: [<7820ab91>] sysfs_get_active_two+0x27/0x3e
>  #3:  (&q->sysfs_lock){+.+.+.}, at: [<78289e95>] queue_attr_store+0x2e/0x68
> 
> stack backtrace:
> Pid: 889, comm: sh Not tainted 2.6.33-rc6 #1
> Call Trace:
>  [<784a6966>] ? printk+0xf/0x11
>  [<781752a1>] print_deadlock_bug+0x99/0xa3
>  [<781753c6>] check_deadlock+0x11b/0x140
>  [<781763e5>] validate_chain+0x4ec/0x4f9
>  [<78176a68>] __lock_acquire+0x676/0x6cf
>  [<78176b64>] lock_acquire+0xa3/0xbc
>  [<7820a975>] ? sysfs_addrm_finish+0x27/0x4e
>  [<7820a37a>] sysfs_deactivate+0x6c/0xa4
>  [<7820a975>] ? sysfs_addrm_finish+0x27/0x4e
>  [<7820a975>] sysfs_addrm_finish+0x27/0x4e
>  [<7820aa3a>] sysfs_remove_dir+0x62/0x72
>  [<7829d6dd>] kobject_del+0x11/0x32
>  [<78283406>] __elv_unregister_queue+0x18/0x20
>  [<78283c66>] elevator_switch+0x6d/0x11b
>  [<78283d92>] elv_iosched_store+0x7e/0x9b
>  [<78289eb8>] queue_attr_store+0x51/0x68
>  [<78209894>] sysfs_write_file+0x66/0x99
>  [<781cd460>] vfs_write+0x8a/0x108
>  [<781cd578>] sys_write+0x3c/0x63
>  [<78125b90>] sysenter_do_call+0x12/0x36
> 

