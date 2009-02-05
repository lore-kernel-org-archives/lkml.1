Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253AbZBELye@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253AbZBELye (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 06:54:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752905AbZBELyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 06:54:25 -0500
Received: from 64-76-18-116.static.impsat.net.ar ([64.76.18.116]:54348 "EHLO
	mother.lugmen.org.ar" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1752730AbZBELyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 06:54:23 -0500
Message-ID: <498AD368.2090000@lugmen.org.ar>
Date: Thu, 05 Feb 2009 09:54:16 -0200
From: Federico Cuello <fedux@lugmen.org.ar>
User-Agent: Thunderbird 2.0.0.19 (X11/20081209)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Ralf Hildebrandt <Ralf.Hildebrandt@charite.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>,
       linux-kernel@vger.kernel.org
Subject: Re: sync-Regression in 2.6.28.2?
References: <20090127093533.GB7037@charite.de> <200902041717.27320.nickpiggin@yahoo.com.au> <4989D0D4.80300@lugmen.org.ar> <200902051425.19552.nickpiggin@yahoo.com.au>
In-Reply-To: <200902051425.19552.nickpiggin@yahoo.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin wrote:
> On Thursday 05 February 2009 04:31:00 Federico Cuello wrote:
>   
>> Nick Piggin wrote:
>>     
>>> [...]
>>> Thanks, could you reply-to-all when replying to retain ccs please?
>>>
>>> Common theme is ext4, which uses no_nrwrite_index_update, and I
>>> introduced a bug in there which could possibly cause ext4 to go into a
>>> loop...
>>>
>>> Would it be possible if you can test the following patch?
>>>       
>> I'll test it as soon as I get home.
>>     
>
> Thanks.
>
>
>   
>> Meanwhile, I think the new patch may be slightly wrong. If I understand
>> correctly PageWriteback(page) is called before nr_to_write is tested for
>> being > 0 and then decremented if true, but "done" is  not set to 1
>> until the next iteration. So another call to PageWriteback(page) while
>> take place and then "done" will be set to true (if wbc->sync_mode ==
>> WB_SYNC_NONE).
>>
>> If nr_to_write == 1 at the beginning of the loop then two pages will be
>> written.
>>
>> I think the test condition should something like:
>>
>> if (--nr_to_write <= 0 && wbc->sync_mode == WB_SYNC_NONE) {
>>     done = 1;
>>     break;
>> }
>>     
>
> I think you're quite right. Good catch. We probably want to prevent
> nr_to_write from going -ve, though.
>
> I think something like this
>
>   if (nr_to_write > 0)
>     nr_to_write--;
>   if (!nr_to_write && wbc->sync_mode == WB_SYNC_NONE) {
>     ...
>
> Would you care to send a patch?
>   

Ok, after extensive testing I haven't been able to solve the problem.

I'm posting below the patch I used. I tried 3 different patches with one
successful test run with the one you sent me. I don't know if it was
just a coincidence as I had no time to test it again.

Now, with the patch below, it stalls with 50% IO-wait (dual core, one
core at 100%). Perhaps the patch is part of the solution, I don't know.

I also have the sysrq-W logs and I'm also posting them below.

Thanks,



diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 08d2b96..9e2ae50 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -981,13 +981,23 @@ continue_unlock:
                                }
                        }

-                       if (wbc->sync_mode == WB_SYNC_NONE) {
-                               wbc->nr_to_write--;
-                               if (wbc->nr_to_write <= 0) {
+                       if (nr_to_write > 0) {
+                               nr_to_write--;
+                               if (nr_to_write == 0 && wbc->sync_mode
== WB_SYNC_NONE) {
+                                       /*
+                                        * We stop writing back only if
we are not
+                                        * doing integrity sync. In case
of integrity
+                                        * sync we have to keep going
because someone
+                                        * may be concurrently dirtying
pages, and we
+                                        * might have synced a lot of
newly appeared
+                                        * dirty pages, but have not
synced all of the
+                                        * old dirty pages.
+                                        */
                                        done = 1;
                                        break;
                                }
                        }
+
                        if (wbc->nonblocking && bdi_write_congested(bdi)) {
                                wbc->encountered_congestion = 1;
                                done = 1;


Feb  5 03:15:19 kaoz [ 1953.633858] SysRq : Show Blocked State
Feb  5 03:15:19 kaoz [ 1953.634882]   task                        PC stack   pid father
Feb  5 03:15:19 kaoz [ 1953.634896] kjournald2    D ffff880001020c20     0  4713      2
Feb  5 03:15:19 kaoz [ 1953.634904]  ffff88007e4edd50 0000000000000046 ffff8800582e2900 ffff88007e64a840
Feb  5 03:15:19 kaoz [ 1953.634912]  ffffffff805de000 ffff88007eb4ec10 ffff88007f862220 ffff88007eb4ee78
Feb  5 03:15:19 kaoz [ 1953.634919]  0000000100000000 0000000100057f3b ffff88007eb4ee78 ffff88007edc0090
Feb  5 03:15:19 kaoz [ 1953.634926] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.634938]  [<ffffffff8022e110>] update_curr+0xd0/0x140
Feb  5 03:15:19 kaoz [ 1953.634949]  [<ffffffff8031d5e1>] jbd2_journal_commit_transaction+0x171/0x1240
Feb  5 03:15:19 kaoz [ 1953.634957]  [<ffffffff8023048f>] dequeue_task_fair+0x3f/0xc0
Feb  5 03:15:19 kaoz [ 1953.634963]  [<ffffffff8022e677>] dequeue_task+0x57/0x70
Feb  5 03:15:19 kaoz [ 1953.634972]  [<ffffffff80474d27>] thread_return+0x3d/0x5e6
Feb  5 03:15:19 kaoz [ 1953.634979]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.634986]  [<ffffffff802461a4>] lock_timer_base+0x34/0x70
Feb  5 03:15:19 kaoz [ 1953.634991]  [<ffffffff80246234>] try_to_del_timer_sync+0x54/0x60
Feb  5 03:15:19 kaoz [ 1953.634998]  [<ffffffff80322598>] kjournald2+0xd8/0x230
Feb  5 03:15:19 kaoz [ 1953.635004]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635009]  [<ffffffff803224c0>] kjournald2+0x0/0x230
Feb  5 03:15:19 kaoz [ 1953.635014]  [<ffffffff80251957>] kthread+0x47/0x80
Feb  5 03:15:19 kaoz [ 1953.635020]  [<ffffffff80238697>] schedule_tail+0x27/0x70
Feb  5 03:15:19 kaoz [ 1953.635026]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Feb  5 03:15:19 kaoz [ 1953.635031]  [<ffffffff80251910>] kthread+0x0/0x80
Feb  5 03:15:19 kaoz [ 1953.635036]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Feb  5 03:15:19 kaoz [ 1953.635068] kdeinit4      D ffff88007c760870     0  6084      1
Feb  5 03:15:19 kaoz [ 1953.635075]  ffff88006e83bcf0 0000000000000086 ffffffff8026f77d 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.635082]  ffffffff805de000 ffff880070ae4440 ffff880070ae3330 ffff880070ae46a8
Feb  5 03:15:19 kaoz [ 1953.635089]  00000001805e19e0 ffffe20001a79688 ffff880070ae46a8 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.635095] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635103]  [<ffffffff8026f77d>] find_get_page+0x8d/0xc0
Feb  5 03:15:19 kaoz [ 1953.635109]  [<ffffffff80475a55>] __mutex_lock_slowpath+0x75/0xc0
Feb  5 03:15:19 kaoz [ 1953.635114]  [<ffffffff8047588a>] mutex_lock+0xa/0x10
Feb  5 03:15:19 kaoz [ 1953.635119]  [<ffffffff80271b1f>] generic_file_aio_write+0x4f/0xe0
Feb  5 03:15:19 kaoz [ 1953.635126]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.635134]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.635142]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.635148]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635155]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.635161]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.635166]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.635173] quasselcore   D ffff880001006b08     0  6204      1
Feb  5 03:15:19 kaoz [ 1953.635179]  ffff88006ae09bb8 0000000000000086 ffff88007e91d800 ffffffff80496fd0
Feb  5 03:15:19 kaoz [ 1953.635186]  ffffffff805de000 ffff88006ad685b0 ffff880055a605b0 ffff88006ad68818
Feb  5 03:15:19 kaoz [ 1953.635192]  0000000100000004 0000000000000000 ffff88006ad68818 ffffffff802fa711
Feb  5 03:15:19 kaoz [ 1953.635199] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635205]  [<ffffffff802fa711>] ext4_da_write_end+0x141/0x280
Feb  5 03:15:19 kaoz [ 1953.635259]  [<ffffffffa008c6cc>] dm_table_unplug_all+0x3c/0x90 [dm_mod]
Feb  5 03:15:19 kaoz [ 1953.635266]  [<ffffffff8026f910>] sync_page+0x0/0x70
Feb  5 03:15:19 kaoz [ 1953.635273]  [<ffffffff80475307>] io_schedule+0x37/0x50
Feb  5 03:15:19 kaoz [ 1953.635279]  [<ffffffff8026f945>] sync_page+0x35/0x70
Feb  5 03:15:19 kaoz [ 1953.635283]  [<ffffffff8047568a>] __wait_on_bit_lock+0x4a/0x80
Feb  5 03:15:19 kaoz [ 1953.635289]  [<ffffffff8026f8ee>] __lock_page+0x5e/0x70
Feb  5 03:15:19 kaoz [ 1953.635295]  [<ffffffff80251d50>] wake_bit_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635302]  [<ffffffff80276cdd>] write_cache_pages+0x1ed/0x3d0
Feb  5 03:15:19 kaoz [ 1953.635308]  [<ffffffff802fbf10>] __mpage_da_writepage+0x0/0x170
Feb  5 03:15:19 kaoz [ 1953.635315]  [<ffffffff802fbcc7>] ext4_da_writepages+0x237/0x3b0
Feb  5 03:15:19 kaoz [ 1953.635321]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635328]  [<ffffffff802fd240>] ext4_da_get_block_write+0x0/0x160
Feb  5 03:15:19 kaoz [ 1953.635333]  [<ffffffff80276f10>] do_writepages+0x20/0x40
Feb  5 03:15:19 kaoz [ 1953.635338]  [<ffffffff8027074d>] __filemap_fdatawrite_range+0x4d/0x60
Feb  5 03:15:19 kaoz [ 1953.635345]  [<ffffffff802c12b5>] do_fsync+0x45/0xe0
Feb  5 03:15:19 kaoz [ 1953.635350]  [<ffffffff802c137e>] __do_fsync+0x2e/0x50
Feb  5 03:15:19 kaoz [ 1953.635355]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.635361] kwin          D ffff88007c760870     0  6307   6283
Feb  5 03:15:19 kaoz [ 1953.635366]  ffff88006af0fcf0 0000000000000082 ffffffff8026f77d 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.635373]  ffffffff805de000 ffff88007e7ea7d0 ffff8800709d96c0 ffff88007e7eaa38
Feb  5 03:15:19 kaoz [ 1953.635380]  00000000805e19e0 ffffe20000664a20 ffff88007e7eaa38 ffff88006af0fcc8
Feb  5 03:15:19 kaoz [ 1953.635386] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635392]  [<ffffffff8026f77d>] find_get_page+0x8d/0xc0
Feb  5 03:15:19 kaoz [ 1953.635398]  [<ffffffff8022f753>] __wake_up+0x43/0x70
Feb  5 03:15:19 kaoz [ 1953.635403]  [<ffffffff80475a55>] __mutex_lock_slowpath+0x75/0xc0
Feb  5 03:15:19 kaoz [ 1953.635408]  [<ffffffff8047588a>] mutex_lock+0xa/0x10
Feb  5 03:15:19 kaoz [ 1953.635413]  [<ffffffff80271b1f>] generic_file_aio_write+0x4f/0xe0
Feb  5 03:15:19 kaoz [ 1953.635419]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.635425]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.635431]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.635437]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635443]  [<ffffffff803fc4d6>] sock_ioctl+0x56/0x260
Feb  5 03:15:19 kaoz [ 1953.635450]  [<ffffffff802ad76f>] vfs_ioctl+0x2f/0xa0
Feb  5 03:15:19 kaoz [ 1953.635456]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.635462]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.635467]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.635479] mysqld        D 0000000000000002     0  6688   6674
Feb  5 03:15:19 kaoz [ 1953.635485]  ffff88005c58db58 0000000000000086 ffff88005c58dad8 ffffffff80230285
Feb  5 03:15:19 kaoz [ 1953.635491]  ffffffff805de000 ffff88007f95ec10 ffff8800636ca7d0 ffff88007f95ee78
Feb  5 03:15:19 kaoz [ 1953.635498]  0000000100000001 ffff880070bdd840 ffff88007f95ee78 ffffffff8023384b
Feb  5 03:15:19 kaoz [ 1953.635504] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635510]  [<ffffffff80230285>] enqueue_entity+0xf5/0x160
Feb  5 03:15:19 kaoz [ 1953.635517]  [<ffffffff8023384b>] check_preempt_wakeup+0x15b/0x180
Feb  5 03:15:19 kaoz [ 1953.635522]  [<ffffffff802356ae>] try_to_wake_up+0xee/0x1a0
Feb  5 03:15:19 kaoz [ 1953.635528]  [<ffffffff8031cf3b>] start_this_handle+0x33b/0x450
Feb  5 03:15:19 kaoz [ 1953.635534]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635541]  [<ffffffff8031d226>] jbd2_journal_start+0x96/0xe0
Feb  5 03:15:19 kaoz [ 1953.635547]  [<ffffffff802f9c36>] ext4_dirty_inode+0x36/0xb0
Feb  5 03:15:19 kaoz [ 1953.635552]  [<ffffffff802be284>] __mark_inode_dirty+0x34/0x1d0
Feb  5 03:15:19 kaoz [ 1953.635558]  [<ffffffff802b3380>] file_update_time+0x110/0x130
Feb  5 03:15:19 kaoz [ 1953.635564]  [<ffffffff80270fa6>] __generic_file_aio_write_nolock+0x246/0x470
Feb  5 03:15:19 kaoz [ 1953.635569]  [<ffffffff80271b34>] generic_file_aio_write+0x64/0xe0
Feb  5 03:15:19 kaoz [ 1953.635575]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.635582]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.635588]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.635594]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635600]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.635606]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.635611]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.635616] konsole       D ffff88007c760870     0  6722      1
Feb  5 03:15:19 kaoz [ 1953.635622]  ffff88006ae49cf0 0000000000000082 ffffffff8026f77d 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.635628]  ffffffff805de000 ffff88005c594fa0 ffff88007c0b2220 ffff88005c595208
Feb  5 03:15:19 kaoz [ 1953.635635]  00000001805e19e0 ffffe20001a79688 ffff88005c595208 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.635641] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635647]  [<ffffffff8026f77d>] find_get_page+0x8d/0xc0
Feb  5 03:15:19 kaoz [ 1953.635652]  [<ffffffff80475a55>] __mutex_lock_slowpath+0x75/0xc0
Feb  5 03:15:19 kaoz [ 1953.635657]  [<ffffffff8047588a>] mutex_lock+0xa/0x10
Feb  5 03:15:19 kaoz [ 1953.635662]  [<ffffffff80271b1f>] generic_file_aio_write+0x4f/0xe0
Feb  5 03:15:19 kaoz [ 1953.635668]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.635674]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.635680]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.635686]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635692]  [<ffffffff802ad76f>] vfs_ioctl+0x2f/0xa0
Feb  5 03:15:19 kaoz [ 1953.635698]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.635704]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.635709]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.635715] pdflush       D ffff880001003178     0  7292      2
Feb  5 03:15:19 kaoz [ 1953.635720]  ffff88007c09ba20 0000000000000046 ffff880024e2b870 ffff88007ebd32d0
Feb  5 03:15:19 kaoz [ 1953.635727]  ffffffff805de000 ffff880055a638e0 ffff88007ea7c9f0 ffff880055a63b48
Feb  5 03:15:19 kaoz [ 1953.635734]  000000017c09b9c0 ffff880024e2b870 ffff880055a63b48 ffff88007edd1d80
Feb  5 03:15:19 kaoz [ 1953.635740] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635746]  [<ffffffff8032f437>] generic_make_request+0x207/0x340
Feb  5 03:15:19 kaoz [ 1953.635767]  [<ffffffffa008c6cc>] dm_table_unplug_all+0x3c/0x90 [dm_mod]
Feb  5 03:15:19 kaoz [ 1953.635775]  [<ffffffff80341b27>] radix_tree_gang_lookup_slot+0x77/0xc0
Feb  5 03:15:19 kaoz [ 1953.635781]  [<ffffffff8026f910>] sync_page+0x0/0x70
Feb  5 03:15:19 kaoz [ 1953.635788]  [<ffffffff80475307>] io_schedule+0x37/0x50
Feb  5 03:15:19 kaoz [ 1953.635794]  [<ffffffff8026f945>] sync_page+0x35/0x70
Feb  5 03:15:19 kaoz [ 1953.635798]  [<ffffffff8047568a>] __wait_on_bit_lock+0x4a/0x80
Feb  5 03:15:19 kaoz [ 1953.635805]  [<ffffffff8026f8ee>] __lock_page+0x5e/0x70
Feb  5 03:15:19 kaoz [ 1953.635810]  [<ffffffff80251d50>] wake_bit_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.635816]  [<ffffffff8027867a>] pagevec_lookup_tag+0x1a/0x30
Feb  5 03:15:19 kaoz [ 1953.635822]  [<ffffffff80276cdd>] write_cache_pages+0x1ed/0x3d0
Feb  5 03:15:19 kaoz [ 1953.635828]  [<ffffffff802fbf10>] __mpage_da_writepage+0x0/0x170
Feb  5 03:15:19 kaoz [ 1953.635835]  [<ffffffff8031bbdf>] jbd2_journal_stop+0x17f/0x200
Feb  5 03:15:19 kaoz [ 1953.635842]  [<ffffffff802fbcc7>] ext4_da_writepages+0x237/0x3b0
Feb  5 03:15:19 kaoz [ 1953.635848]  [<ffffffff80476f6c>] _spin_unlock_irq+0xc/0x30
Feb  5 03:15:19 kaoz [ 1953.635853]  [<ffffffff80236c8b>] finish_task_switch+0x2b/0xe0
Feb  5 03:15:19 kaoz [ 1953.635860]  [<ffffffff802fd240>] ext4_da_get_block_write+0x0/0x160
Feb  5 03:15:19 kaoz [ 1953.635865]  [<ffffffff80276f10>] do_writepages+0x20/0x40
Feb  5 03:15:19 kaoz [ 1953.635871]  [<ffffffff802bd516>] __writeback_single_inode+0xa6/0x470
Feb  5 03:15:19 kaoz [ 1953.635876]  [<ffffffff802bdea0>] generic_sync_sb_inodes+0x370/0x4d0
Feb  5 03:15:19 kaoz [ 1953.635882]  [<ffffffff802be1bd>] writeback_inodes+0x4d/0xe0
Feb  5 03:15:19 kaoz [ 1953.635887]  [<ffffffff8027759d>] background_writeout+0xad/0xe0
Feb  5 03:15:19 kaoz [ 1953.635893]  [<ffffffff80277ccb>] pdflush+0x15b/0x240
Feb  5 03:15:19 kaoz [ 1953.635898]  [<ffffffff802774f0>] background_writeout+0x0/0xe0
Feb  5 03:15:19 kaoz [ 1953.635904]  [<ffffffff80277b70>] pdflush+0x0/0x240
Feb  5 03:15:19 kaoz [ 1953.635909]  [<ffffffff80251957>] kthread+0x47/0x80
Feb  5 03:15:19 kaoz [ 1953.635914]  [<ffffffff80238697>] schedule_tail+0x27/0x70
Feb  5 03:15:19 kaoz [ 1953.635919]  [<ffffffff8020c7e9>] child_rip+0xa/0x11
Feb  5 03:15:19 kaoz [ 1953.635924]  [<ffffffff80251910>] kthread+0x0/0x80
Feb  5 03:15:19 kaoz [ 1953.635929]  [<ffffffff8020c7df>] child_rip+0x0/0x11
Feb  5 03:15:19 kaoz [ 1953.635932] krunner_lock  D ffff88007c760870     0  7306   6670
Feb  5 03:15:19 kaoz [ 1953.635938]  ffff880063e77cf0 0000000000000082 ffffffff8026f77d 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.635945]  ffffffff805de000 ffff88000395b330 ffff880055a63e90 ffff88000395b598
Feb  5 03:15:19 kaoz [ 1953.635952]  00000001805e19e0 ffffe200000b0d88 ffff88000395b598 0000000000000086
Feb  5 03:15:19 kaoz [ 1953.635958] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.635964]  [<ffffffff8026f77d>] find_get_page+0x8d/0xc0
Feb  5 03:15:19 kaoz [ 1953.635969]  [<ffffffff80475a55>] __mutex_lock_slowpath+0x75/0xc0
Feb  5 03:15:19 kaoz [ 1953.635974]  [<ffffffff8047588a>] mutex_lock+0xa/0x10
Feb  5 03:15:19 kaoz [ 1953.635979]  [<ffffffff80271b1f>] generic_file_aio_write+0x4f/0xe0
Feb  5 03:15:19 kaoz [ 1953.635985]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.635991]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.635997]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.636003]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.636010]  [<ffffffff802493af>] kill_pid_info+0x4f/0x80
Feb  5 03:15:19 kaoz [ 1953.636016]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.636022]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.636027]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.636031] krunner_lock  D ffff88007c760870     0  7307   7306
Feb  5 03:15:19 kaoz [ 1953.636037]  ffff88006364bcf0 0000000000000082 ffffe200000b0d88 ffffffff805e19e0
Feb  5 03:15:19 kaoz [ 1953.636044]  ffffffff805de000 ffff880055a63e90 ffff88007c0b2220 ffff880055a640f8
Feb  5 03:15:19 kaoz [ 1953.636050]  00000001802791f5 ffffe200000b0d88 ffff880055a640f8 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.636057] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.636062]  [<ffffffff80475a55>] __mutex_lock_slowpath+0x75/0xc0
Feb  5 03:15:19 kaoz [ 1953.636066]  [<ffffffff8047588a>] mutex_lock+0xa/0x10
Feb  5 03:15:19 kaoz [ 1953.636071]  [<ffffffff80271b1f>] generic_file_aio_write+0x4f/0xe0
Feb  5 03:15:19 kaoz [ 1953.636077]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.636084]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.636090]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.636095]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.636101]  [<ffffffff802493af>] kill_pid_info+0x4f/0x80
Feb  5 03:15:19 kaoz [ 1953.636108]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.636113]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.636119]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.636122] kblankscrn.ks D ffff880001020c20     0  7309   7306
Feb  5 03:15:19 kaoz [ 1953.636128]  ffff8800635e3cf0 0000000000000086 ffffffff8026f77d 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.636135]  ffffffff805de000 ffff8800039585b0 ffff88007f862220 ffff880003958818
Feb  5 03:15:19 kaoz [ 1953.636141]  00000001805e19e0 000000010005efb2 ffff880003958818 ffffffff8056ffc8
Feb  5 03:15:19 kaoz [ 1953.636148] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.636154]  [<ffffffff8026f77d>] find_get_page+0x8d/0xc0
Feb  5 03:15:19 kaoz [ 1953.636159]  [<ffffffff80475a55>] __mutex_lock_slowpath+0x75/0xc0
Feb  5 03:15:19 kaoz [ 1953.636164]  [<ffffffff8047588a>] mutex_lock+0xa/0x10
Feb  5 03:15:19 kaoz [ 1953.636169]  [<ffffffff80271b1f>] generic_file_aio_write+0x4f/0xe0
Feb  5 03:15:19 kaoz [ 1953.636175]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.636181]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.636187]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.636193]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.636200]  [<ffffffff802866e6>] unmap_region+0x106/0x1a0
Feb  5 03:15:19 kaoz [ 1953.636206]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.636212]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.636217]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.636221] kblankscrn.ks D 0000000000000002     0  7311   7307
Feb  5 03:15:19 kaoz [ 1953.636227]  ffff880042a2bb58 0000000000000086 ffff880024edb150 0000000000b29b6f
Feb  5 03:15:19 kaoz [ 1953.636233]  ffffffff805de000 ffff88000395b8e0 ffff8800039585b0 ffff88000395bb48
Feb  5 03:15:19 kaoz [ 1953.636240]  000000010395b8e0 000300018022f9c8 ffff88000395bb48 ffff880070bdd900
Feb  5 03:15:19 kaoz [ 1953.636246] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.636252]  [<ffffffff8022f928>] set_next_entity+0x38/0x80
Feb  5 03:15:19 kaoz [ 1953.636259]  [<ffffffff8031cf3b>] start_this_handle+0x33b/0x450
Feb  5 03:15:19 kaoz [ 1953.636265]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.636271]  [<ffffffff8031d226>] jbd2_journal_start+0x96/0xe0
Feb  5 03:15:19 kaoz [ 1953.636277]  [<ffffffff802f9c36>] ext4_dirty_inode+0x36/0xb0
Feb  5 03:15:19 kaoz [ 1953.636282]  [<ffffffff802be284>] __mark_inode_dirty+0x34/0x1d0
Feb  5 03:15:19 kaoz [ 1953.636288]  [<ffffffff802b3380>] file_update_time+0x110/0x130
Feb  5 03:15:19 kaoz [ 1953.636293]  [<ffffffff80270fa6>] __generic_file_aio_write_nolock+0x246/0x470
Feb  5 03:15:19 kaoz [ 1953.636299]  [<ffffffff80280332>] __do_fault+0x202/0x4c0
Feb  5 03:15:19 kaoz [ 1953.636304]  [<ffffffff80271b34>] generic_file_aio_write+0x64/0xe0
Feb  5 03:15:19 kaoz [ 1953.636310]  [<ffffffff802f6848>] ext4_file_write+0x58/0x170
Feb  5 03:15:19 kaoz [ 1953.636316]  [<ffffffff8029f66b>] do_sync_write+0xdb/0x120
Feb  5 03:15:19 kaoz [ 1953.636322]  [<ffffffff80227210>] do_page_fault+0x300/0x970
Feb  5 03:15:19 kaoz [ 1953.636328]  [<ffffffff80251d20>] autoremove_wake_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.636333]  [<ffffffff802866e6>] unmap_region+0x106/0x1a0
Feb  5 03:15:19 kaoz [ 1953.636340]  [<ffffffff802a008b>] vfs_write+0xcb/0x170
Feb  5 03:15:19 kaoz [ 1953.636346]  [<ffffffff802a0233>] sys_write+0x53/0xa0
Feb  5 03:15:19 kaoz [ 1953.636351]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b
Feb  5 03:15:19 kaoz [ 1953.636355] updatedb      D ffff880001020c20     0  7511   7506
Feb  5 03:15:19 kaoz [ 1953.636361]  ffff8800372fdbf8 0000000000000086 ffff88007ea30000 0000000000000000
Feb  5 03:15:19 kaoz [ 1953.636367]  ffffffff805de000 ffff88000395e660 ffff88007f862220 ffff88000395e8c8
Feb  5 03:15:19 kaoz [ 1953.636374]  000000017fa93a50 00000001000791d8 ffff88000395e8c8 ffff88007eb544f0
Feb  5 03:15:19 kaoz [ 1953.636381] Call Trace:
Feb  5 03:15:19 kaoz [ 1953.636386]  [<ffffffff802c3880>] sync_buffer+0x0/0x50
Feb  5 03:15:19 kaoz [ 1953.636392]  [<ffffffff80330564>] generic_unplug_device+0x24/0x40
Feb  5 03:15:19 kaoz [ 1953.636412]  [<ffffffffa008c6cc>] dm_table_unplug_all+0x3c/0x90 [dm_mod]
Feb  5 03:15:19 kaoz [ 1953.636418]  [<ffffffff802c3880>] sync_buffer+0x0/0x50
Feb  5 03:15:19 kaoz [ 1953.636424]  [<ffffffff80475307>] io_schedule+0x37/0x50
Feb  5 03:15:19 kaoz [ 1953.636429]  [<ffffffff802c38bd>] sync_buffer+0x3d/0x50
Feb  5 03:15:19 kaoz [ 1953.636433]  [<ffffffff804757b0>] __wait_on_bit+0x50/0x80
Feb  5 03:15:19 kaoz [ 1953.636439]  [<ffffffff802c3880>] sync_buffer+0x0/0x50
Feb  5 03:15:19 kaoz [ 1953.636444]  [<ffffffff80475859>] out_of_line_wait_on_bit+0x79/0xa0
Feb  5 03:15:19 kaoz [ 1953.636449]  [<ffffffff80251d50>] wake_bit_function+0x0/0x30
Feb  5 03:15:19 kaoz [ 1953.636455]  [<ffffffff802fd5ba>] ext4_bread+0x5a/0x80
Feb  5 03:15:19 kaoz [ 1953.636461]  [<ffffffff803032b3>] htree_dirblock_to_tree+0x33/0x1b0
Feb  5 03:15:19 kaoz [ 1953.636466]  [<ffffffff803035a2>] ext4_htree_fill_tree+0x172/0x210
Feb  5 03:15:19 kaoz [ 1953.636472]  [<ffffffff802aaf4e>] do_path_lookup+0x9e/0x1b0
Feb  5 03:15:19 kaoz [ 1953.636477]  [<ffffffff802a0805>] file_move+0x25/0x70
Feb  5 03:15:19 kaoz [ 1953.636483]  [<ffffffff802f6492>] ext4_readdir+0x4a2/0x600
Feb  5 03:15:19 kaoz [ 1953.636489]  [<ffffffff802ae0b0>] filldir+0x0/0xe0
Feb  5 03:15:19 kaoz [ 1953.636494]  [<ffffffff8029829f>] add_partial+0x1f/0x80
Feb  5 03:15:19 kaoz [ 1953.636500]  [<ffffffff802a34c4>] cp_new_stat+0xe4/0x100
Feb  5 03:15:19 kaoz [ 1953.636506]  [<ffffffff802ae0b0>] filldir+0x0/0xe0
Feb  5 03:15:19 kaoz [ 1953.636511]  [<ffffffff802ae320>] vfs_readdir+0xb0/0xd0
Feb  5 03:15:19 kaoz [ 1953.636518]  [<ffffffff802ae4b4>] sys_getdents+0x84/0xe0
Feb  5 03:15:19 kaoz [ 1953.636524]  [<ffffffff8029e6ca>] sys_fchdir+0x4a/0x90
Feb  5 03:15:19 kaoz [ 1953.636529]  [<ffffffff8020b8cb>] system_call_fastpath+0x16/0x1b

