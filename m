Return-Path: <linux-kernel-owner+w=401wt.eu-S1754780AbYGRI3e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbYGRI3e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 04:29:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752157AbYGRI3U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 04:29:20 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:52246 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbYGRI3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 04:29:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=EksTUYBlSb0G1smgyjRYMc9uhz+5LOecbo/CawVjlyQiosiTHv3CPL+vQT+mcLNh2e
         406mXoMDonaN6RaSZHkCeGX+BOMajR9ROSirv/c2FsLnsW76EUwRR/u+7zdeUab8mO7d
         mXrKelSxqe6L8ga04X0AUkT5mCJGODpON2sho=
Message-ID: <19f34abd0807180129k5d7e64a0nd86bbd6333df72d2@mail.gmail.com>
Date: Fri, 18 Jul 2008 10:29:15 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Dave Kleikamp" <shaggy@linux.vnet.ibm.com>
Subject: Re: latest -git: BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
Cc: jfs-discussion@lists.sourceforge.net,
       "Johannes Weiner" <hannes@saeurebad.de>, linux-kernel@vger.kernel.org
In-Reply-To: <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0807171135m4a3b39e6v4065ed676720ae46@mail.gmail.com>
	 <1216336164.32175.3.camel@norville.austin.ibm.com>
	 <19f34abd0807180110k5a19e525y463b59208f0587b2@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 18, 2008 at 10:10 AM, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> On Fri, Jul 18, 2008 at 1:09 AM, Dave Kleikamp
> <shaggy@linux.vnet.ibm.com> wrote:
>> On Thu, 2008-07-17 at 20:35 +0200, Vegard Nossum wrote:
>>> Hi,
>>>
>>> I got this on latest -git with an intentionally corrupted filesystem image:
>>>
>>> BUG at fs/jfs/namei.c:512 assert(ip->i_nlink)
>>
>> This assert shouldn't be here.  It would be better to handle this with
>> jfs_error(), which will mark the superblock dirty, and take appropriate
>> action.
>>
>>> Full log at http://folk.uio.no/vegardno/linux/log-1216318656.txt, but
>>> I think the preceding messages are just left-overs from previous
>>> mount/remount attempts. I can test patches.
>>
>> How about this one?  So far, compile tested only.
>>
>> JFS: The kernel shouldn't trap when deleting a file with nlink == 0.
>>
>> Signed-off-by: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
>
> Thanks!
>
> But whether it truly helped or not, I don't know. I got something different now:
>
> jfs_unlink: dtDelete returned -116
> jfs_unlink: dtDelete returned -116
> ------------[ cut here ]------------
> kernel BUG at fs/inode.c:262!

Running the test for some more on a freshly booted system also gives
me this after a while (I don't know if it's related, but it might give
some additional clues?):

BUG: unable to handle kernel paging request at c08845af
IP: [<c02f9122>] release_metapage+0x32/0x1c0
*pde = 37ab2163 *pte = 00884161
Oops: 0003 [#1] PREEMPT SMP DEBUG_PAGEALLOC
Pid: 387, comm: jfsCommit Not tainted (2.6.26-03415-gdf3030b #45)
EIP: 0060:[<c02f9122>] EFLAGS: 00010202 CPU: 1
EIP is at release_metapage+0x32/0x1c0
EAX: 00000246 EBX: f470e5d8 ECX: f7a2afd0 EDX: 00000000
ESI: c08845af EDI: 00000000 EBP: f735fd98 ESP: f735fd7c
 DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
Process jfsCommit (pid: 387, ti=f735e000 task=f7a2afd0 task.ti=f735e000)
Stack: c015b6e9 00000001 00000286 00000246 00000002 00000000 00000000 f735fed0
       c02e4202 00000020 f7a2afd0 c015addb 00000000 f470e9a4 f735fe34 00000000
       00000000 f470e85c c015addb 00000000 00000000 f470e5d8 f470e6d8 00000002
Call Trace:
 [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
 [<c02e4202>] ? xtTruncate+0xd42/0x1060
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c074a496>] ? _read_unlock_irq+0x36/0x60
 [<c01799b8>] ? find_get_pages+0x68/0x80
 [<c0182842>] ? pagevec_lookup+0x22/0x30
 [<c0183a59>] ? truncate_inode_pages_range+0x189/0x360
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c02e1038>] ? jfs_free_zero_link+0x98/0x1b0
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c02de2fd>] ? jfs_delete_inode+0xdd/0x130
 [<c02de220>] ? jfs_delete_inode+0x0/0x130
 [<c01b9ba1>] ? generic_delete_inode+0x81/0x120
 [<c01b9d67>] ? generic_drop_inode+0x127/0x180
 [<c01b8be7>] ? iput+0x47/0x50
 [<c02fd5b5>] ? txUpdateMap+0x1d5/0x2a0
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c02ffff1>] ? jfs_lazycommit+0xd1/0x2e0
 [<c012e940>] ? default_wake_function+0x0/0x10
 [<c02fff20>] ? jfs_lazycommit+0x0/0x2e0
 [<c014b02c>] ? kthread+0x3c/0x70
 [<c014aff0>] ? kthread+0x0/0x70
 [<c0104ddb>] ? kernel_thread_helper+0x7/0x1c
 =======================
Code: c3 83 ec 10 8b 70 50 83 3d 40 d8 8f c0 03 0f 8f 85 01 00 00 85
f6 0f 84 75 01 00 00 ba a9 00 00 00 b8 91 05 84 c0 e8 ee 52 e3 ff <f0>
0f ba 2e 00 19 c0 85 c0 75 7b 8d 7b 14 f0 80 63 14 fe b9 01
EIP: [<c02f9122>] release_metapage+0x32/0x1c0 SS:ESP 0068:f735fd7c
Kernel panic - not syncing: Fatal exception
------------[ cut here ]------------
WARNING: at kernel/smp.c:288 smp_call_function_mask+0x154/0x160()
Pid: 387, comm: jfsCommit Tainted: G      D   2.6.26-03415-gdf3030b #45
 [<c0135b6f>] warn_on_slowpath+0x4f/0xa0
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c0176a12>] ? __rcu_read_unlock+0xb2/0xc0
 [<c015078c>] ? __atomic_notifier_call_chain+0x3c/0x50
 [<c074a6d7>] ? _spin_unlock+0x27/0x50
 [<c0493660>] ? vt_console_print+0x230/0x320
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c074a673>] ? _spin_unlock_irqrestore+0x43/0x80
 [<c0136489>] ? release_console_sem+0x1e9/0x200
 [<c0161ea4>] smp_call_function_mask+0x154/0x160
 [<c0118510>] ? stop_this_cpu+0x0/0x50
 [<c010567f>] ? show_registers+0x7f/0x240
 [<c0118510>] ? stop_this_cpu+0x0/0x50
 [<c0161ee0>] smp_call_function+0x30/0x60
 [<c01184ae>] native_smp_send_stop+0x1e/0x80
 [<c0105e40>] ? die+0x110/0x180
 [<c012028d>] ? do_page_fault+0x14d/0x880
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c015ab70>] ? mark_held_locks+0x40/0x80
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c010a4e2>] ? native_sched_clock+0xb2/0xe0
 [<c015908e>] ? get_lock_stats+0x1e/0x50
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c014f916>] ? up_read+0x16/0x30
 [<c02ef124>] ? dbFree+0x194/0x270
 [<c0120140>] ? do_page_fault+0x0/0x880
 [<c074b0d2>] ? error_code+0x72/0x78
 [<c02f00d8>] ? dbSync+0x68/0x140
 [<c02f9122>] ? release_metapage+0x32/0x1c0
 [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
 [<c02e4202>] ? xtTruncate+0xd42/0x1060
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c074a496>] ? _read_unlock_irq+0x36/0x60
 [<c01799b8>] ? find_get_pages+0x68/0x80
 [<c0182842>] ? pagevec_lookup+0x22/0x30
 [<c0183a59>] ? truncate_inode_pages_range+0x189/0x360
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c02e1038>] ? jfs_free_zero_link+0x98/0x1b0
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c02de2fd>] ? jfs_delete_inode+0xdd/0x130
 [<c02de220>] ? jfs_delete_inode+0x0/0x130
 [<c01b9ba1>] ? generic_delete_inode+0x81/0x120
 [<c01b9d67>] ? generic_drop_inode+0x127/0x180
 [<c01b8be7>] ? iput+0x47/0x50
 [<c02fd5b5>] ? txUpdateMap+0x1d5/0x2a0
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c02ffff1>] ? jfs_lazycommit+0xd1/0x2e0
 [<c012e940>] ? default_wake_function+0x0/0x10
 [<c02fff20>] ? jfs_lazycommit+0x0/0x2e0
 [<c014b02c>] ? kthread+0x3c/0x70
 [<c014aff0>] ? kthread+0x0/0x70
 [<c0104ddb>] ? kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 3a81a57639faabca ]---
------------[ cut here ]------------
WARNING: at kernel/smp.c:214 smp_call_function_single+0x11f/0x130()
Pid: 387, comm: jfsCommit Tainted: G      D W 2.6.26-03415-gdf3030b #45
 [<c0135b6f>] warn_on_slowpath+0x4f/0xa0
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c0176a12>] ? __rcu_read_unlock+0xb2/0xc0
 [<c015078c>] ? __atomic_notifier_call_chain+0x3c/0x50
 [<c074a6d7>] ? _spin_unlock+0x27/0x50
 [<c0493660>] ? vt_console_print+0x230/0x320
 [<c0161d3f>] smp_call_function_single+0x11f/0x130
 [<c0118510>] ? stop_this_cpu+0x0/0x50
 [<c074a673>] ? _spin_unlock_irqrestore+0x43/0x80
 [<c0161e6e>] smp_call_function_mask+0x11e/0x160
 [<c0118510>] ? stop_this_cpu+0x0/0x50
 [<c010567f>] ? show_registers+0x7f/0x240
 [<c0118510>] ? stop_this_cpu+0x0/0x50
 [<c0161ee0>] smp_call_function+0x30/0x60
 [<c01184ae>] native_smp_send_stop+0x1e/0x80
 [<c0105e40>] ? die+0x110/0x180
 [<c012028d>] ? do_page_fault+0x14d/0x880
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c015ab70>] ? mark_held_locks+0x40/0x80
 [<c015ad76>] ? trace_hardirqs_on_caller+0x116/0x170
 [<c015906b>] ? trace_hardirqs_off+0xb/0x10
 [<c010a4e2>] ? native_sched_clock+0xb2/0xe0
 [<c015908e>] ? get_lock_stats+0x1e/0x50
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c014f916>] ? up_read+0x16/0x30
 [<c02ef124>] ? dbFree+0x194/0x270
 [<c0120140>] ? do_page_fault+0x0/0x880
 [<c074b0d2>] ? error_code+0x72/0x78
 [<c02f00d8>] ? dbSync+0x68/0x140
 [<c02f9122>] ? release_metapage+0x32/0x1c0
 [<c015b6e9>] ? __lock_acquire+0x2c9/0x1110
 [<c02e4202>] ? xtTruncate+0xd42/0x1060
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c074a496>] ? _read_unlock_irq+0x36/0x60
 [<c01799b8>] ? find_get_pages+0x68/0x80
 [<c0182842>] ? pagevec_lookup+0x22/0x30
 [<c0183a59>] ? truncate_inode_pages_range+0x189/0x360
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c02e1038>] ? jfs_free_zero_link+0x98/0x1b0
 [<c01590cd>] ? put_lock_stats+0xd/0x30
 [<c02de2fd>] ? jfs_delete_inode+0xdd/0x130
 [<c02de220>] ? jfs_delete_inode+0x0/0x130
 [<c01b9ba1>] ? generic_delete_inode+0x81/0x120
 [<c01b9d67>] ? generic_drop_inode+0x127/0x180
 [<c01b8be7>] ? iput+0x47/0x50
 [<c02fd5b5>] ? txUpdateMap+0x1d5/0x2a0
 [<c0159173>] ? lock_release_holdtime+0x83/0x120
 [<c015addb>] ? trace_hardirqs_on+0xb/0x10
 [<c02ffff1>] ? jfs_lazycommit+0xd1/0x2e0
 [<c012e940>] ? default_wake_function+0x0/0x10
 [<c02fff20>] ? jfs_lazycommit+0x0/0x2e0
 [<c014b02c>] ? kthread+0x3c/0x70
 [<c014aff0>] ? kthread+0x0/0x70
 [<c0104ddb>] ? kernel_thread_helper+0x7/0x1c
 =======================
---[ end trace 3a81a57639faabca ]---

The page fault had this address:

$ addr2line -e vmlinux -i c02f9122
include/asm/bitops.h:186
include/linux/page-flags.h:151
include/linux/pagemap.h:170
fs/jfs/jfs_metapage.c:741

The current tree is 33af79d12e0fa25545d49e86afc67ea8ad5f2f40 + your
previous patch.

Thanks,


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
