Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbXLNS3g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbXLNS3g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2007 13:29:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752691AbXLNS32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Dec 2007 13:29:28 -0500
Received: from E23SMTP01.au.ibm.com ([202.81.18.162]:36112 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbXLNS3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2007 13:29:23 -0500
Date: Fri, 14 Dec 2007 23:58:02 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <htejun@gmail.com>, Greg KH <gregkh@suse.de>, stable@kernel.org,
       lkml <linux-kernel@vger.kernel.org>, maneesh@linux.vnet.ibm.com,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       Balbir Singh <balbir@in.ibm.com>, Gautham Shenoy <ego@in.ibm.com>
Subject: Re: 2.6.22-stable causes oomkiller to be invoked
Message-ID: <20071214182802.GC2576@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20071213132326.GC16905@linux.vnet.ibm.com> <20071213151847.GB5676@linux.vnet.ibm.com> <20071213162936.GA7635@suse.de> <20071213164658.GA30865@linux.vnet.ibm.com> <20071213175423.GA2977@linux.vnet.ibm.com> <476295FF.1040202@gmail.com> <20071214154711.GD23670@linux.vnet.ibm.com> <4762A721.7080400@gmail.com> <20071214161637.GA2687@linux.vnet.ibm.com> <20071214095023.b5327703.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20071214095023.b5327703.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 14, 2007 at 09:50:23AM -0800, Andrew Morton wrote:
> On Fri, 14 Dec 2007 21:46:37 +0530 Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
> 
> > On Sat, Dec 15, 2007 at 12:54:09AM +0900, Tejun Heo wrote:
> > > Dhaval Giani wrote:
> > > > XXX sysfs_page_cnt=1
> > > 
> > > Hmm.. so, sysfs r/w buffer wasn't the culprit.  I'm curious what eats up
> > > all your low memory.  Please do the following.
> > > 
> > > 1. Right after boot, record /proc/meminfo and slabinfo.
> > > 
> > > 2. After or near OOM, record /proc/meminfo and slabinfo.  This can be
> > > tricky but if your machine reliably OOMs after 10mins, run it for 9mins
> > > and capturing the result should show enough.
> > > 
> > 
> > Attached. The results are after oom, but i think about a min or so after
> > that. I missed the oom point.
> 
> Looking back at your original oom-killer output: something has consumed all
> your ZONE_NORMAL memory and we cannot tell what it is.
> 
> Please run 2.6.24-rc5-mm1 again (with CONFIG_PAGE_OWNER=y) and take a peek
> at the changelog in
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.24-rc5/2.6.24-rc5-mm1/broken-out/page-owner-tracking-leak-detector.patch.
> 
> Build up Documentation/page_owner.c then cause the leak to happen then
> execute page_owner.
> 
Hi Andrew

This is a peek during the leak.

-- 
regards,
Dhaval

--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="sorted_page_owner.txt"

51957 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc011b7c9] pgd_alloc+60
[0xc0122b9e] mm_init+196
[0xc0122e06] dup_mm+101
[0xc0122eda] copy_mm+104
[0xc0123b8c] copy_process+1149
[0xc0124229] do_fork+141

12335 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc011b6ca] pte_alloc_one+21
[0xc01632ac] __pte_alloc+21
[0xc01634bb] copy_pte_range+67
[0xc0163827] copy_page_range+284
[0xc0122a79] dup_mmap+427
[0xc0122e22] dup_mm+129
[0xc0122eda] copy_mm+104

7993 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc0158b85] __grab_cache_page+89
[0xc01dc53b] ext3_write_begin+77
[0xc0158f26] generic_perform_write+145
[0xc0159040] generic_file_buffered_write+103
[0xc01594b0] __generic_file_aio_write_nolock+990
[0xc01595b5] generic_file_aio_write+86
[0xc01da7b1] ext3_file_write+26

2704 times:
Page allocated via order 0, mask 0x1201d2
[0xc015b9aa] __alloc_pages+706
[0xc015dd8b] __do_page_cache_readahead+239
[0xc015dea1] do_page_cache_readahead+63
[0xc0158067] filemap_fault+347
[0xc0165677] __do_fault+99
[0xc01659a8] do_linear_fault+55
[0xc0165c91] handle_mm_fault+307
[0xc040cc1f] do_page_fault+676

1273 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01e2301] ext3_alloc_inode+18
[0xc0187723] alloc_inode+21
[0xc01881c4] get_new_inode_fast+21

883 times:
Page allocated via order 0, mask 0x1201d2
[0xc015b9aa] __alloc_pages+706
[0xc015dd8b] __do_page_cache_readahead+239
[0xc015deec] ra_submit+23
[0xc015e055] ondemand_readahead+256
[0xc015e073] page_cache_sync_readahead+22
[0xc01577d9] do_generic_mapping_read+155
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183

821 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0187734] alloc_inode+38
[0xc01881c4] get_new_inode_fast+21
[0xc0188583] iget_locked+50

752 times:
Page allocated via order 0, mask 0x1280d2
[0xc015b9aa] __alloc_pages+706
[0xc016552c] do_anonymous_page+50
[0xc0165cc8] handle_mm_fault+362
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114

714 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc012284d] dup_task_struct+60
[0xc0123774] copy_process+101
[0xc0124229] do_fork+141
[0xc0103aba] sys_clone+31
[0xc01049fa] sysenter_past_esp+95

601 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01864d5] d_alloc+29
[0xc017da9c] real_lookup+67
[0xc017dd4b] do_lookup+95

534 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01ddca3] __ext3_get_inode_loc+80
[0xc01ddf8b] ext3_iget+92

496 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc0164b5c] do_wp_page+499
[0xc0165d64] handle_mm_fault+518
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114

469 times:
Page allocated via order 0, mask 0x1201d2
[0xc015b9aa] __alloc_pages+706
[0xc015dd8b] __do_page_cache_readahead+239
[0xc015deec] ra_submit+23
[0xc015e055] ondemand_readahead+256
[0xc015e0c9] page_cache_async_readahead+84
[0xc0157812] do_generic_mapping_read+212
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183

403 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc011b6ca] pte_alloc_one+21
[0xc01632ac] __pte_alloc+21
[0xc0165c0f] handle_mm_fault+177
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114

402 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01dc2dc] ext3_getblk+177
[0xc01dc3c8] ext3_bread+18

375 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc016572a] __do_fault+278
[0xc01659a8] do_linear_fault+55
[0xc0165c91] handle_mm_fault+307
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114

228 times:
Page allocated via order 0, mask 0xd2
[0xc015b9aa] __alloc_pages+706
[0xc016ab65] __vmalloc_area_node+186
[0xc016ac06] __vmalloc_node+80
[0xc016ac22] __vmalloc+16
[0xc016ac3d] vmalloc+25
[0xc016d86d] sys_swapon+1013
[0xc01049fa] sysenter_past_esp+95

227 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc011b76a] pmd_cache_alloc+73
[0xc011b7e5] pgd_alloc+88
[0xc0122b9e] mm_init+196

205 times:
Page allocated via order 0, mask 0x201d0
[0xc015b9aa] __alloc_pages+706
[0xc015dd8b] __do_page_cache_readahead+239
[0xc015deec] ra_submit+23
[0xc015e055] ondemand_readahead+256
[0xc015e0c9] page_cache_async_readahead+84
[0xc0157812] do_generic_mapping_read+212
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183

203 times:
Page allocated via order 0, mask 0x200d2
[0xc015b9aa] __alloc_pages+706
[0xc0158b85] __grab_cache_page+89
[0xc018f675] simple_write_begin+39
[0xc0158f26] generic_perform_write+145
[0xc0159040] generic_file_buffered_write+103
[0xc01594b0] __generic_file_aio_write_nolock+990
[0xc01595b5] generic_file_aio_write+86
[0xc01776b5] do_sync_write+183

156 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc0170965] shmem_getpage+1166
[0xc0170d87] shmem_write_begin+37
[0xc0158f26] generic_perform_write+145
[0xc0159040] generic_file_buffered_write+103
[0xc01594b0] __generic_file_aio_write_nolock+990
[0xc01595b5] generic_file_aio_write+86
[0xc01776b5] do_sync_write+183

152 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc011b7c9] pgd_alloc+60
[0xc0122b9e] mm_init+196
[0xc0122bf7] mm_alloc+51
[0xc017aa89] bprm_mm_init+18
[0xc017bbb6] do_execve+96
[0xc0103b00] sys_execve+41

122 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015ba3f] get_zeroed_page+63
[0xc01ab9b9] fill_read_buffer+48
[0xc01aba53] sysfs_read_file+46
[0xc0177588] vfs_read+128
[0xc0177826] sys_read+59
[0xc01049fa] sysenter_past_esp+95

113 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc011b6ca] pte_alloc_one+21
[0xc01632ac] __pte_alloc+21
[0xc0165c0f] handle_mm_fault+177
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc019f423] padzero+25
[0xc01a062c] load_elf_binary+1986

104 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc012282d] dup_task_struct+28
[0xc0123774] copy_process+101
[0xc0124229] do_fork+141

98 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc011b6ca] pte_alloc_one+21
[0xc01632ac] __pte_alloc+21
[0xc0165c0f] handle_mm_fault+177
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc019f423] padzero+25
[0xc019fc47] load_elf_interp+610

95 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc023c0e1] kobject_uevent_env+508
[0xc023c245] kobject_uevent+10

90 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc011b6ca] pte_alloc_one+21
[0xc01632ac] __pte_alloc+21
[0xc0168b9a] alloc_new_pmd+87
[0xc0168d6a] move_page_tables+97
[0xc017ad3f] shift_arg_pages+110
[0xc017aede] setup_arg_pages+205
[0xc01a03d7] load_elf_binary+1389

83 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01a3c36] proc_alloc_inode+19
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

82 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc012284d] dup_task_struct+60
[0xc0123774] copy_process+101
[0xc0124229] do_fork+141
[0xc01034c0] kernel_thread+110
[0xc013621c] create_kthread+24
[0xc013647c] kthreadd+167

81 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0171afa] shmem_alloc_inode+18
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

78 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0187734] alloc_inode+38
[0xc0187fab] new_inode+23
[0xc017d292] get_pipe_inode+17

77 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01dc2dc] ext3_getblk+177
[0xc01df8a2] ext3_find_entry+301

76 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0196a3c] alloc_buffer_head+44
[0xc0193ea4] alloc_page_buffers+37
[0xc01947a8] create_empty_buffers+20

70 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc0194613] __bread+11
[0xc01db963] ext3_get_branch+89

68 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc016572a] __do_fault+278
[0xc01659a8] do_linear_fault+55
[0xc0165c91] handle_mm_fault+307
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc019f423] padzero+25
[0xc019fc47] load_elf_interp+610

64 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0159ba9] mempool_alloc_pages+65
[0xc015985b] mempool_create_node+143
[0xc01597ca] mempool_create+13
[0xc05d340d] init_emergency_pool+52
[0xc05c2785] do_initcalls+117
[0xc05c28b9] do_basic_setup+28
[0xc05c2937] kernel_init+75

64 times:
Page allocated via order 1, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc03b1f94] __netdev_alloc_skb+23
[0xc02db58a] tg3_alloc_rx_skb+173

61 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01781b4] get_empty_filp+107
[0xc017eb90] __path_lookup_intent_open+22
[0xc017ebfe] path_lookup_open+16

58 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017d605] getname+28
[0xc0103ae4] sys_execve+13
[0xc01049fa] sysenter_past_esp+95

53 times:
Page allocated via order 0, mask 0x1280d2
[0xc015b9aa] __alloc_pages+706
[0xc016552c] do_anonymous_page+50
[0xc0165cc8] handle_mm_fault+362
[0xc0164267] get_user_pages+500
[0xc017a918] get_arg_page+43
[0xc017ac0d] copy_strings+211
[0xc017acc2] copy_strings_kernel+36
[0xc017bc15] do_execve+191

48 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023cec2] radix_tree_preload+77
[0xc0157128] add_to_page_cache+25
[0xc015719c] add_to_page_cache_lru+15

48 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc012284d] dup_task_struct+60
[0xc0123774] copy_process+101
[0xc0124229] do_fork+141
[0xc01034c0] kernel_thread+110
[0xc0132a3f] __call_usermodehelper+31
[0xc0132fc1] run_workqueue+192

44 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0123341] copy_sighand+46
[0xc0123b66] copy_process+1111
[0xc0124229] do_fork+141

43 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01ed27c] journal_get_descriptor_buffer+53
[0xc01ea40f] journal_write_commit_record+38

43 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0171f7d] alloc_arraycache+27
[0xc01744da] do_tune_cpucache+75
[0xc0174649] enable_cpucache+136

42 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01abf91] sysfs_add_file+33
[0xc01ac021] sysfs_create_file+48

41 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01ed27c] journal_get_descriptor_buffer+53
[0xc01eab91] journal_commit_transaction+1058

41 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc011b6ca] pte_alloc_one+21
[0xc01632ac] __pte_alloc+21
[0xc0165c0f] handle_mm_fault+177
[0xc0164267] get_user_pages+500
[0xc017a918] get_arg_page+43
[0xc017ac0d] copy_strings+211
[0xc017acc2] copy_strings_kernel+36

36 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0189535] alloc_fdtable+89
[0xc01895db] expand_fdtable+33
[0xc018967a] expand_files+35

33 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01758c5] percpu_populate+34
[0xc01758fe] __percpu_populate_mask+50
[0xc017596a] __percpu_alloc_mask+59

30 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01864d5] d_alloc+29
[0xc017d35c] create_write_pipe+72
[0xc017d4a0] do_pipe+17

29 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01864d5] d_alloc+29
[0xc017ecac] __lookup_hash+79
[0xc017ed06] lookup_hash+41

27 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0171f7d] alloc_arraycache+27
[0xc0172231] cpuup_prepare+254
[0xc017233e] cpuup_callback+108

26 times:
Page allocated via order 0, mask 0x1280d2
[0xc015b9aa] __alloc_pages+706
[0xc016552c] do_anonymous_page+50
[0xc0165cc8] handle_mm_fault+362
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc019f4d2] create_elf_tables+160
[0xc01a0777] load_elf_binary+2317
[0xc017ba9b] search_binary_handler+175

25 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01abf91] sysfs_add_file+33
[0xc01ad922] create_files+43

25 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc0160fd8] kstrdup+40
[0xc01ac622] sysfs_new_dirent+36
[0xc01aca3d] create_dir+30

24 times:
Page allocated via order 0, mask 0x20050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023cec2] radix_tree_preload+77
[0xc0157128] add_to_page_cache+25
[0xc015719c] add_to_page_cache_lru+15

24 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01aca3d] create_dir+30
[0xc01acab5] sysfs_create_subdir+17

23 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0123031] alloc_files+19
[0xc01230b7] dup_fd+25
[0xc01232b2] copy_files+60

23 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01233f1] copy_signal+68
[0xc0123b79] copy_process+1130
[0xc0124229] do_fork+141

22 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01edfa8] journal_alloc_journal_head+19
[0xc01ee024] journal_add_journal_head+30
[0xc01e9541] journal_dirty_data+53

22 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01229c8] dup_mmap+250
[0xc0122e22] dup_mm+129
[0xc0122eda] copy_mm+104

22 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01aca3d] create_dir+30
[0xc01acae5] sysfs_create_dir+43

21 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01da39a] ext3_htree_store_dirent+52
[0xc01df3b2] htree_dirblock_to_tree+220
[0xc01df45f] ext3_htree_fill_tree+93

20 times:
Page allocated via order 0, mask 0x11200
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc0159a14] mempool_alloc+60
[0xc0196c8b] bio_alloc_bioset+26

20 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0122dd4] dup_mm+51
[0xc0122eda] copy_mm+104
[0xc0123b8c] copy_process+1149

19 times:
Page allocated via order 0, mask 0x11200
[0xc015b9aa] __alloc_pages+706
[0xc0159ba9] mempool_alloc_pages+65
[0xc0159a14] mempool_alloc+60
[0xc016b424] __blk_queue_bounce+149
[0xc016b5cf] blk_queue_bounce+71
[0xc023300f] __make_request+51
[0xc023351a] generic_make_request+542
[0xc02335f9] submit_bio+177

19 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017d1dc] alloc_pipe_info+22
[0xc017d29d] get_pipe_inode+28
[0xc017d336] create_write_pipe+34

18 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0196a3c] alloc_buffer_head+44
[0xc0193ea4] alloc_page_buffers+37
[0xc019401c] grow_dev_page+143

16 times:
Page allocated via order 0, mask 0x201d0
[0xc015b9aa] __alloc_pages+706
[0xc015dd8b] __do_page_cache_readahead+239
[0xc015dfd6] ondemand_readahead+129
[0xc015e073] page_cache_sync_readahead+22
[0xc01577d9] do_generic_mapping_read+155
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183
[0xc0177588] vfs_read+128

16 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc0160fd8] kstrdup+40
[0xc01ac622] sysfs_new_dirent+36
[0xc01ad18e] sysfs_create_link+166

16 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0171f7d] alloc_arraycache+27
[0xc0174371] alloc_kmemlist+66
[0xc01745b9] do_tune_cpucache+298

14 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc015985b] mempool_create_node+143
[0xc01597ca] mempool_create+13

13 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01731d7] alloc_slabmgmt+32
[0xc0173551] cache_grow+188
[0xc0173a5e] cache_alloc_refill+423

13 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017d605] getname+28
[0xc0103ae4] sys_execve+13
[0xc0104a82] syscall_call+7

13 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0262078] acpi_ns_create_node+44
[0xc0261abb] acpi_ns_search_and_enter+317
[0xc0261576] acpi_ns_lookup+828

12 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc0164b5c] do_wp_page+499
[0xc0165d64] handle_mm_fault+518
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc010493e] ret_from_fork+6

12 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03ad73a] sock_alloc_inode+19
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

12 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02bead7] device_add_class_symlinks+46

11 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01ddca3] __ext3_get_inode_loc+80
[0xc01dde87] ext3_get_inode_loc+23

11 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc0253e14] acpi_ds_build_internal_object+276

11 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc023b628] kobject_get_path+35
[0xc023bf95] kobject_uevent_env+176
[0xc023c245] kobject_uevent+10

10 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0189567] alloc_fdtable+139
[0xc01895db] expand_fdtable+33
[0xc018967a] expand_files+35

10 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026e8e3] acpi_add_single_object+51
[0xc026eb2d] acpi_bus_scan+255
[0xc05d6d4d] acpi_scan_init+110

10 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc03d5ee8] sk_stream_alloc_skb+39
[0xc03d65fc] tcp_sendmsg+339

9 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b1eb2] __alloc_skb+41
[0xc03b1f94] __netdev_alloc_skb+23
[0xc02db58a] tg3_alloc_rx_skb+173

9 times:
Page allocated via order 0, mask 0x201d0
[0xc015b9aa] __alloc_pages+706
[0xc015dd8b] __do_page_cache_readahead+239
[0xc015deec] ra_submit+23
[0xc015e055] ondemand_readahead+256
[0xc015e073] page_cache_sync_readahead+22
[0xc01577d9] do_generic_mapping_read+155
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183

9 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01980ab] bdev_alloc_inode+18
[0xc0187723] alloc_inode+21
[0xc0188099] get_new_inode+19

9 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc019fec5] load_elf_binary+91
[0xc017ba9b] search_binary_handler+175
[0xc017bc6f] do_execve+281

9 times:
Page allocated via order 1, mask 0x4d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc03b0ba8] sock_alloc_send_pskb+129
[0xc03b0d34] sock_alloc_send_skb+14

8 times:
Page allocated via order 0, mask 0x11200
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc0159a14] mempool_alloc+60
[0xc0196d23] bio_alloc_bioset+178

8 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01d8743] read_block_bitmap+45
[0xc01d990b] ext3_new_blocks+543

8 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc03326e3] ahc_dmamem_alloc+37
[0xc03297d9] ahc_alloc_scbs+103
[0xc033325a] ahc_linux_run_command+122
[0xc0332166] ahc_linux_queue+110
[0xc03126fb] scsi_dispatch_cmd+360

8 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc012da1e] __sigqueue_alloc+52
[0xc012e2ec] send_signal+105
[0xc012e7c9] __group_send_sig_info+114

8 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc03c3138] flow_cache_cpu_prepare+92
[0xc05e0122] flow_cache_init+161
[0xc05c2785] do_initcalls+117
[0xc05c28b9] do_basic_setup+28
[0xc05c2937] kernel_init+75
[0xc010570b] kernel_thread_helper+7

8 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0284eea] n_tty_open+60
[0xc0281611] init_dev+802
[0xc0281f08] tty_open+234
[0xc0179cef] chrdev_open+311
[0xc0176a41] __dentry_open+374
[0xc0176bba] nameidata_to_filp+31

8 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0122bd8] mm_alloc+20
[0xc017aa89] bprm_mm_init+18
[0xc017bbb6] do_execve+96

8 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc016947f] anon_vma_prepare+91
[0xc0165513] do_anonymous_page+25
[0xc0165cc8] handle_mm_fault+362

8 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023bf79] kobject_uevent_env+148
[0xc023c245] kobject_uevent+10
[0xc02bede1] device_add+304

8 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b03cd] sk_prot_alloc+21
[0xc03b0468] sk_alloc+31
[0xc0403ea1] unix_create1+60

7 times:
Page allocated via order 0, mask 0x200d2
[0xc015b9aa] __alloc_pages+706
[0xc017cc34] pipe_write+510
[0xc01776b5] do_sync_write+183
[0xc0177775] vfs_write+130
[0xc0177886] sys_write+59
[0xc01049fa] sysenter_past_esp+95

7 times:
Page allocated via order 0, mask 0x50
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01731d7] alloc_slabmgmt+32
[0xc0173551] cache_grow+188
[0xc0173a5e] cache_alloc_refill+423

7 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01e2301] ext3_alloc_inode+18
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

7 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0133c9c] alloc_pid+24
[0xc0123be5] copy_process+1238
[0xc0124229] do_fork+141

7 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc025d0c1] acpi_ex_create_method+54

7 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0240cd7] kvasprintf+39
[0xc023b8ba] kobject_set_name_vargs+17
[0xc023b8e5] kobject_set_name+17

7 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc012284d] dup_task_struct+60
[0xc0123774] copy_process+101
[0xc0124135] fork_idle+41
[0xc0116505] do_boot_cpu+74
[0xc05cb214] smp_boot_cpus+752
[0xc05cb3c1] native_smp_prepare_cpus+34

7 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc012d329] init_timers_cpu+44
[0xc012d5a2] timer_cpu_notify+36
[0xc040d084] notifier_call_chain+50

6 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc0194613] __bread+11
[0xc01da8ea] read_inode_bitmap+46

6 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc0194613] __bread+11
[0xc01e3711] ext3_fill_super+1537

6 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01864d5] d_alloc+29
[0xc03ad876] sock_attach_fd+53
[0xc03ad90b] sock_map_fd+32

6 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017bb7a] do_execve+36
[0xc0103b00] sys_execve+41
[0xc0104a82] syscall_call+7

6 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017d605] getname+28
[0xc017ee00] __user_walk_fd+19
[0xc0179f81] vfs_stat_fd+25

5 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01d8743] read_block_bitmap+45
[0xc01d9868] ext3_new_blocks+380

5 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01dbbff] ext3_alloc_branch+148
[0xc01dc07f] ext3_get_blocks_handle+508

5 times:
Page allocated via order 0, mask 0x1280d2
[0xc015b9aa] __alloc_pages+706
[0xc016552c] do_anonymous_page+50
[0xc0165cc8] handle_mm_fault+362
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc01578c2] do_generic_mapping_read+388
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183

5 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0187734] alloc_inode+38
[0xc0187fab] new_inode+23
[0xc01f6cab] ramfs_get_inode+15

5 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01a3c36] proc_alloc_inode+19
[0xc0187723] alloc_inode+21
[0xc01881c4] get_new_inode_fast+21

5 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0122f20] __copy_fs_struct+22
[0xc0122fe9] copy_fs+47
[0xc0123b53] copy_process+1092

5 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02c01e7] bus_add_device+105

5 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0232110] blk_alloc_queue_node+20
[0xc02320fa] blk_alloc_queue+11
[0xc02cb48e] brd_alloc+84

5 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b1eb2] __alloc_skb+41
[0xc03d5ee8] sk_stream_alloc_skb+39
[0xc03d65fc] tcp_sendmsg+339

5 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc019ff7f] load_elf_binary+277
[0xc017ba9b] search_binary_handler+175
[0xc017bc6f] do_execve+281

5 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01da39a] ext3_htree_store_dirent+52
[0xc01df3b2] htree_dirblock_to_tree+220
[0xc01df52e] ext3_htree_fill_tree+300

5 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02467f7] alloc_pci_dev+19
[0xc02468d7] pci_scan_device+190
[0xc0246a4c] pci_scan_single_device+12

5 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc05d75f8] pnpacpi_add_device+102
[0xc05d781d] pnpacpi_add_device_handler+29
[0xc0261ebf] acpi_ns_get_device_callback+275

5 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01758c5] percpu_populate+34
[0xc01758fe] __percpu_populate_mask+50
[0xc017596a] __percpu_alloc_mask+59

4 times:
Page allocated via order 0, mask 0x1201d2
[0xc015b9aa] __alloc_pages+706
[0xc0157a3c] do_generic_mapping_read+766
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183
[0xc0177588] vfs_read+128
[0xc0177826] sys_read+59
[0xc01049fa] sysenter_past_esp+95

4 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03122d6] __scsi_get_command+22
[0xc0312343] scsi_get_command+44
[0xc03168a1] scsi_get_cmd_from_req+26

4 times:
Page allocated via order 0, mask 0x200d2
[0xc015b9aa] __alloc_pages+706
[0xc0158b85] __grab_cache_page+89
[0xc018f675] simple_write_begin+39
[0xc015888d] pagecache_write_begin+53
[0xc0180dc5] __page_symlink+56
[0xc0180e49] page_symlink+25
[0xc01f6e89] ramfs_symlink+67
[0xc01801f2] vfs_symlink+86

4 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc031a5c7] scsi_dev_info_list_add+29
[0xc05db7f5] scsi_init_devinfo+62
[0xc05db697] init_scsi+18

4 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc03b098d] sock_wmalloc+41
[0xc04048b2] unix_stream_connect+171

4 times:
Page allocated via order 0, mask 0xd2
[0xc015b9aa] __alloc_pages+706
[0xc016ab65] __vmalloc_area_node+186
[0xc016ac06] __vmalloc_node+80
[0xc016ac22] __vmalloc+16
[0xc016ac3d] vmalloc+25
[0xc02a25f3] drm_ht_create+127
[0xc02a031f] drm_fill_in_dev+299
[0xc02a0660] drm_get_dev+100

4 times:
Page allocated via order 0, mask 0xd2
[0xc015b9aa] __alloc_pages+706
[0xc016ab65] __vmalloc_area_node+186
[0xc016ac06] __vmalloc_node+80
[0xc016ac22] __vmalloc+16
[0xc016ac3d] vmalloc+25
[0xc02a25f3] drm_ht_create+127
[0xc02a0360] drm_fill_in_dev+364
[0xc02a0660] drm_get_dev+100

4 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc027f9ea] alloc_tty_struct+18
[0xc028139e] init_dev+175
[0xc0281f08] tty_open+234

4 times:
Page allocated via order 3, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc015985b] mempool_create_node+143
[0xc01597ca] mempool_create+13

3 times:
Page allocated via order 0, mask 0x11200
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc0159a14] mempool_alloc+60
[0xc02322d7] blk_alloc_request+25

3 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc0194613] __bread+11
[0xc01e3448] ext3_fill_super+824

3 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01d8743] read_block_bitmap+45
[0xc01d8b16] ext3_free_blocks_sb+175

3 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01ed568] journal_init_inode+212
[0xc01e3bfc] ext3_get_journal+89

3 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc016572a] __do_fault+278
[0xc01659a8] do_linear_fault+55
[0xc0165c91] handle_mm_fault+307
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc019f423] padzero+25
[0xc01a062c] load_elf_binary+1986

3 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03bc016] dst_alloc+42
[0xc03cc5d4] ip_route_output_slow+1470
[0xc03cc930] __ip_route_output_key+270

3 times:
Page allocated via order 0, mask 0x4d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b1eb2] __alloc_skb+41
[0xc03b0ba8] sock_alloc_send_pskb+129
[0xc03b0d34] sock_alloc_send_skb+14

3 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01edfa8] journal_alloc_journal_head+19
[0xc01ee024] journal_add_journal_head+30
[0xc01e9291] journal_get_write_access+14

3 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc01a5412] do_proc_readlink+26
[0xc01a54a6] proc_pid_readlink+60
[0xc017a455] sys_readlinkat+97
[0xc017a47c] sys_readlink+19
[0xc01049fa] sysenter_past_esp+95

3 times:
Page allocated via order 0, mask 0x80850
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0196a3c] alloc_buffer_head+44
[0xc01ecc8e] journal_write_metadata_buffer+72
[0xc01eac3f] journal_commit_transaction+1232

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01743f6] alloc_kmemlist+199
[0xc01745b9] do_tune_cpucache+298
[0xc0174649] enable_cpucache+136

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01781b4] get_empty_filp+107
[0xc0178278] alloc_file+20
[0xc017d38e] create_write_pipe+122

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01781b4] get_empty_filp+107
[0xc017d416] create_read_pipe+11
[0xc017d4b3] do_pipe+36

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017a9a6] __bprm_mm_init+39
[0xc017aaaf] bprm_mm_init+56
[0xc017bbb6] do_execve+96

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc018da6b] seq_read+86
[0xc0177588] vfs_read+128
[0xc0177826] sys_read+59

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02c01c9] bus_add_device+75

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02c1a91] class_device_add+276

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0232110] blk_alloc_queue_node+20
[0xc02320fa] blk_alloc_queue+11
[0xc02ccf43] loop_alloc+43

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0232110] blk_alloc_queue_node+20
[0xc02321c1] blk_init_queue_node+26
[0xc02321a5] blk_init_queue+11

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc025c367] acpi_ex_prep_field_value+126

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0171f7d] alloc_arraycache+27
[0xc0174371] alloc_kmemlist+66
[0xc01745b9] do_tune_cpucache+298

3 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc017594f] __percpu_alloc_mask+32
[0xc0244bc7] percpu_counter_init+53
[0xc0244c19] percpu_counter_init_irq+12

3 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc015985b] mempool_create_node+143
[0xc01597ca] mempool_create+13

3 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b03cd] sk_prot_alloc+21
[0xc03b0468] sk_alloc+31
[0xc03f0bdc] inet_create+405

3 times:
Page allocated via order 3, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01e3157] ext3_fill_super+71
[0xc01794e1] get_sb_bdev+222
[0xc01e4697] ext3_get_sb+19

2 times:
Page allocated via order 0, mask 0x11220
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc0159a14] mempool_alloc+60
[0xc03162ea] scsi_alloc_sgtable+176

2 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc0170965] shmem_getpage+1166
[0xc0170af8] shmem_fault+113
[0xc0165677] __do_fault+99
[0xc01659a8] do_linear_fault+55
[0xc0165c91] handle_mm_fault+307
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114

2 times:
Page allocated via order 0, mask 0x1280d2
[0xc015b9aa] __alloc_pages+706
[0xc016552c] do_anonymous_page+50
[0xc0165cc8] handle_mm_fault+362
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc01a0777] load_elf_binary+2317
[0xc017ba9b] search_binary_handler+175
[0xc017bc6f] do_execve+281

2 times:
Page allocated via order 0, mask 0x1280d2
[0xc015b9aa] __alloc_pages+706
[0xc016552c] do_anonymous_page+50
[0xc0165cc8] handle_mm_fault+362
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc023ff9a] copy_to_user+66
[0xc03b4a38] memcpy_toiovec+44
[0xc03b4fa8] skb_copy_datagram_iovec+73

2 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc03326e3] ahc_dmamem_alloc+37
[0xc03297d9] ahc_alloc_scbs+103
[0xc03295be] ahc_init_scbdata+540
[0xc032a310] ahc_init+408
[0xc032ec73] ahc_pci_config+1816

2 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc03326e3] ahc_dmamem_alloc+37
[0xc032a22f] ahc_init+183
[0xc032ec73] ahc_pci_config+1816
[0xc03359f5] ahc_linux_pci_dev_probe+310
[0xc024a17f] pci_call_probe+13

2 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0132bcb] call_usermodehelper_setup+29
[0xc023c213] kobject_uevent_env+814
[0xc023c245] kobject_uevent+10

2 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0233d49] current_io_context+33
[0xc0233d9c] get_io_context+8
[0xc023655e] as_get_io_context+16

2 times:
Page allocated via order 0, mask 0x280d2
[0xc015b9aa] __alloc_pages+706
[0xc016f7d4] shmem_swp_alloc+334
[0xc0170574] shmem_getpage+157
[0xc0170d87] shmem_write_begin+37
[0xc0158f26] generic_perform_write+145
[0xc0159040] generic_file_buffered_write+103
[0xc01594b0] __generic_file_aio_write_nolock+990
[0xc01595b5] generic_file_aio_write+86

2 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc01a72d5] proc_file_read+123
[0xc01a3db3] proc_reg_read+99
[0xc0177588] vfs_read+128
[0xc0177826] sys_read+59
[0xc01049fa] sysenter_past_esp+95

2 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015ba3f] get_zeroed_page+63
[0xc01ad387] sysfs_follow_link+27
[0xc017e51e] __link_path_walk+1927
[0xc017e7a9] link_path_walk+65
[0xc017e816] path_walk+25
[0xc017ea9e] do_path_lookup+323
[0xc017ee1a] __user_walk_fd+45

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0284eea] n_tty_open+60
[0xc0281611] init_dev+802
[0xc0282131] ptmx_open+196
[0xc0179cef] chrdev_open+311
[0xc0176a41] __dentry_open+374
[0xc0176bba] nameidata_to_filp+31

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0284eea] n_tty_open+60
[0xc0281630] init_dev+833
[0xc0282131] ptmx_open+196
[0xc0179cef] chrdev_open+311
[0xc0176a41] __dentry_open+374
[0xc0176bba] nameidata_to_filp+31

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0159b29] mempool_alloc_slab+14
[0xc015985b] mempool_create_node+143
[0xc02320db] blk_init_free_list+93

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0167590] mmap_region+317
[0xc01673d3] do_mmap_pgoff+624
[0xc010759a] sys_mmap2+89

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d3746] kmem_cache_init+428
[0xc05c268b] start_kernel+398

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017d605] getname+28
[0xc0176d9d] do_sys_open+19
[0xc0176e59] sys_open+22

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0189511] alloc_fdtable+53
[0xc01895db] expand_fdtable+33
[0xc018967a] expand_files+35

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0189a93] alloc_vfsmnt+27
[0xc0179655] vfs_kern_mount+37
[0xc0179781] kern_mount_data+16

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02c0ae7] driver_sysfs_add+63

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023a96b] idr_pre_get+27
[0xc023b0e6] ida_pre_get+14
[0xc01ac4e8] sysfs_alloc_ino+68

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023b67c] verify_dynamic_kobject_allocation+23
[0xc023b700] kobject_init+56
[0xc023bced] kset_init+14

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023bf79] kobject_uevent_env+148
[0xc023c245] kobject_uevent+10
[0xc023bd7e] kset_register+43

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02bf1db] device_create+47
[0xc0283208] tty_register_device+93
[0xc02834cd] tty_register_driver+406

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc04093d6] setup_cpu_cache+144
[0xc0172e75] kmem_cache_create+880
[0xc05d3746] kmem_cache_init+428

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a00a9] load_elf_binary+575
[0xc017ba9b] search_binary_handler+175
[0xc019f376] load_script+470

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0262a94] acpi_ns_internalize_name+90
[0xc0262d6b] acpi_ns_get_node+54
[0xc0262378] acpi_ns_evaluate+44

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc02c1641] make_class_name+40
[0xc02c168e] make_deprecated_class_device_links+32
[0xc02c1ab3] class_device_add+310

2 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc05c50c1] malloc+13
[0xc05c5c02] huft_build+630
[0xc05c632f] inflate_fixed+150

2 times:
Page allocated via order 1, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc03326e3] ahc_dmamem_alloc+37
[0xc0329523] ahc_init_scbdata+385
[0xc032a310] ahc_init+408
[0xc032ec73] ahc_pci_config+1816
[0xc03359f5] ahc_linux_pci_dev_probe+310

2 times:
Page allocated via order 1, mask 0x200d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017889f] alloc_super+23
[0xc0178d71] sget+141
[0xc018f2bf] get_sb_pseudo+31

2 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc012282d] dup_task_struct+28
[0xc0123774] copy_process+101
[0xc0124135] fork_idle+41

2 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02355d5] alloc_disk_node+22
[0xc02355bd] alloc_disk+11
[0xc02cb4d1] brd_alloc+151

2 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02355d5] alloc_disk_node+22
[0xc02355bd] alloc_disk+11
[0xc05da267] floppy_init+38

2 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0274859] acpi_processor_add+31
[0xc026de2b] acpi_bus_driver_init+46
[0xc026da0c] acpi_device_probe+36

2 times:
Page allocated via order 2, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc03326e3] ahc_dmamem_alloc+37
[0xc032947c] ahc_init_scbdata+218
[0xc032a310] ahc_init+408
[0xc032ec73] ahc_pci_config+1816
[0xc03359f5] ahc_linux_pci_dev_probe+310

1 times:
Page allocated via order 0, mask 0x120050
[0xc015b9aa] __alloc_pages+706
[0xc0157518] find_or_create_page+90
[0xc0193fbf] grow_dev_page+50
[0xc0194128] grow_buffers+154
[0xc019423e] __getblk_slow+241
[0xc01945c5] __getblk+64
[0xc01ed27c] journal_get_descriptor_buffer+53
[0xc01ec77f] write_one_revoke_record+54

1 times:
Page allocated via order 0, mask 0x1200d2
[0xc015b9aa] __alloc_pages+706
[0xc0164b5c] do_wp_page+499
[0xc0165d64] handle_mm_fault+518
[0xc040cc1f] do_page_fault+676
[0xc040b5a2] error_code+114
[0xc023ff9a] copy_to_user+66
[0xc0284fac] copy_from_read_buf+114
[0xc028549e] read_chan+1001

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc02dd1f5] tg3_alloc_consistent+303
[0xc02e023d] tg3_open+92
[0xc03b74bf] dev_open+72
[0xc03b94fd] dev_change_flags+152
[0xc03ef74b] devinet_ioctl+550

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc02dd21a] tg3_alloc_consistent+340
[0xc02e023d] tg3_open+92
[0xc03b74bf] dev_open+72
[0xc03b94fd] dev_change_flags+152
[0xc03ef74b] devinet_ioctl+550

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc05d3eeb] mnt_init+65
[0xc05d3c38] vfs_caches_init+120
[0xc05c26d2] start_kernel+469

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023a96b] idr_pre_get+27
[0xc0179308] set_anon_super+23
[0xc0178d8d] sget+169

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03bc703] neigh_alloc+103
[0xc03bca30] neigh_create+37
[0xc03ec92a] arp_bind_neighbour+85

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03d37dc] inet_bind_bucket_create+20
[0xc03d4d5d] inet_csk_get_port+307
[0xc03e3f3a] tcp_v4_get_port+23

1 times:
Page allocated via order 0, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc05c8593] init_iomem_resources+61
[0xc05c8097] request_standard_resources+39
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 0, mask 0x200d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc01874dd] sys_getcwd+21
[0xc01049fa] sysenter_past_esp+95

1 times:
Page allocated via order 0, mask 0x201d0
[0xc015b9aa] __alloc_pages+706
[0xc015825b] __read_cache_page+102
[0xc01582d7] read_cache_page_async+36
[0xc015836d] read_cache_page+12
[0xc016d724] sys_swapon+684
[0xc01049fa] sysenter_past_esp+95

1 times:
Page allocated via order 0, mask 0x201d2
[0xc015b9aa] __alloc_pages+706
[0xc0157a3c] do_generic_mapping_read+766
[0xc0157d73] generic_file_aio_read+301
[0xc01774ca] do_sync_read+183
[0xc0177588] vfs_read+128
[0xc0177826] sys_read+59
[0xc0104a82] syscall_call+7

1 times:
Page allocated via order 0, mask 0x4d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc03b0ba8] sock_alloc_send_pskb+129
[0xc03b0d34] sock_alloc_send_skb+14

1 times:
Page allocated via order 0, mask 0x50
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc01e9412] journal_get_undo_access+91
[0xc01e5fc7] __ext3_journal_get_undo_access+23
[0xc01d94b5] ext3_try_to_allocate_with_rsv+55
[0xc01d9890] ext3_new_blocks+420
[0xc01dbafa] ext3_alloc_blocks+64
[0xc01dbbab] ext3_alloc_branch+64

1 times:
Page allocated via order 0, mask 0x80050
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01e8b16] new_handle+25
[0xc01e8b89] journal_start+56
[0xc01e1da4] ext3_journal_start_sb+64

1 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc01a535d] proc_loginuid_write+110
[0xc0177775] vfs_write+130
[0xc0177886] sys_write+59
[0xc01049fa] sysenter_past_esp+95

1 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01864d5] d_alloc+29
[0xc01867fa] d_alloc_root+25
[0xc01ad41c] sysfs_fill_super+80

1 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0187734] alloc_inode+38
[0xc0187fab] new_inode+23
[0xc018f33a] get_sb_pseudo+154

1 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01980ab] bdev_alloc_inode+18
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

1 times:
Page allocated via order 0, mask 0x800d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ec28a] journal_init_revoke+55
[0xc01ed3c6] journal_init_common+222
[0xc01ed4a2] journal_init_inode+14

1 times:
Page allocated via order 0, mask 0x8020
[0xc015b9aa] __alloc_pages+706
[0xc015ba3f] get_zeroed_page+63
[0xc05cf6c0] sysenter_setup+16
[0xc05c94b3] identify_boot_cpu+18
[0xc05c963d] check_bugs+8
[0xc05c26f0] start_kernel+499

1 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015ba3f] get_zeroed_page+63
[0xc01ab9b9] fill_read_buffer+48
[0xc01aba53] sysfs_read_file+46
[0xc0177588] vfs_read+128
[0xc0177826] sys_read+59
[0xc0104a82] syscall_call+7

1 times:
Page allocated via order 0, mask 0x80d0
[0xc015b9aa] __alloc_pages+706
[0xc015ba3f] get_zeroed_page+63
[0xc02b7ea1] uart_startup+71
[0xc02b9839] uart_open+186
[0xc0281f6d] tty_open+335
[0xc0179cef] chrdev_open+311
[0xc0176a41] __dentry_open+374
[0xc0176bba] nameidata_to_filp+31

1 times:
Page allocated via order 0, mask 0x84d0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc011b6b3] pte_alloc_one_kernel+15
[0xc016335a] __pte_alloc_kernel+20
[0xc023b3e3] ioremap_pte_range+43
[0xc023b50d] ioremap_page_range+170
[0xc011bc1e] __ioremap+246
[0xc0250244] acpi_os_map_memory+19

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc012d78c] alloc_uid+82
[0xc0130fe8] set_user+31
[0xc01311f0] sys_setuid+74

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0133694] __create_workqueue_key+37
[0xc02501ac] acpi_os_initialize1+80
[0xc05d6b2c] acpi_bus_init+8

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0167590] mmap_region+317
[0xc01673d3] do_mmap_pgoff+624
[0xc019f966] elf_map+239

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0167f0b] split_vma+69
[0xc0168017] do_munmap+136
[0xc01674cf] mmap_region+124

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0167f0b] split_vma+69
[0xc0168017] do_munmap+136
[0xc019f92e] elf_map+183

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0168233] do_brk+362
[0xc01669c6] sys_brk+192
[0xc01049fa] sysenter_past_esp+95

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc016947f] anon_vma_prepare+91
[0xc0164b43] do_wp_page+474
[0xc0165d64] handle_mm_fault+518

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc016947f] anon_vma_prepare+91
[0xc0165715] __do_fault+257
[0xc01659a8] do_linear_fault+55

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc01a1e70] mb_cache_create+251
[0xc05d4a6e] init_ext3_xattr+24

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc0208e19] init_inodecache+30
[0xc05d4db3] init_smb_fs+9

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc0250e0a] acpi_os_create_cache+17
[0xc02688f8] acpi_ut_create_caches+88

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d0435] uid_cache_init+27
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d0610] pidmap_init+62
[0xc05c26a0] start_kernel+419

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d36ee] kmem_cache_init+340
[0xc05c268b] start_kernel+398

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d3a9d] filelock_init+30
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d3c00] vfs_caches_init+64
[0xc05c26d2] start_kernel+469

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05d5285] blk_dev_init+95
[0xc05d5479] genhd_device_init+38

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05e009d] flow_cache_init+28
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0172cf7] kmem_cache_create+498
[0xc05e10c5] fib_hash_init+41
[0xc05e0fc5] fib4_rules_init+13

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01744ae] do_tune_cpucache+31
[0xc0174649] enable_cpucache+136
[0xc040935f] setup_cpu_cache+25

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01744ae] do_tune_cpucache+31
[0xc0174649] enable_cpucache+136
[0xc05d38a7] kmem_cache_init+781

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0179e2c] cdev_alloc+19
[0xc036123c] sg_add+83
[0xc02c1e93] class_interface_register+134

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017bb7a] do_execve+36
[0xc0103b00] sys_execve+41
[0xc01049fa] sysenter_past_esp+95

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc017d605] getname+28
[0xc017ee00] __user_walk_fd+19
[0xc0179fd1] vfs_lstat_fd+22

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01834e6] locks_alloc_lock+18
[0xc0185009] fcntl_setlk+22
[0xc018146b] do_fcntl+256

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc018da6b] seq_read+86
[0xc01a3db3] proc_reg_read+99
[0xc0177588] vfs_read+128

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0197c0c] bioset_create+25
[0xc05d40c1] init_bio+55
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01a4a3f] mounts_open+169
[0xc0176a41] __dentry_open+374
[0xc0176bba] nameidata_to_filp+31

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01abf91] sysfs_add_file+33
[0xc01ad8c0] sysfs_create_bin_file+48

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02c0168] make_deprecated_bus_links+30

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01ac63b] sysfs_new_dirent+61
[0xc01ad18e] sysfs_create_link+166
[0xc02c16ac] make_deprecated_class_device_links+62

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc01f79e6] hugetlbfs_alloc_inode+69
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc022d137] mqueue_alloc_inode+18
[0xc0187723] alloc_inode+21
[0xc0187fab] new_inode+23

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023a96b] idr_pre_get+27
[0xc0282096] ptmx_open+41
[0xc0179cef] chrdev_open+311

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023b67c] verify_dynamic_kobject_allocation+23
[0xc023b700] kobject_init+56
[0xc0179e49] cdev_alloc+48

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023b67c] verify_dynamic_kobject_allocation+23
[0xc023b700] kobject_init+56
[0xc022f192] elevator_alloc+47

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023b67c] verify_dynamic_kobject_allocation+23
[0xc023b700] kobject_init+56
[0xc0232179] blk_alloc_queue_node+125

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023b67c] verify_dynamic_kobject_allocation+23
[0xc023b700] kobject_init+56
[0xc023b88d] kobject_register+21

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023b67c] verify_dynamic_kobject_allocation+23
[0xc023b700] kobject_init+56
[0xc02be9d9] device_initialize+38

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023bc75] kobject_create+19
[0xc023bc9d] kobject_create_and_add+15
[0xc01aacd5] register_disk+119

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023bc75] kobject_create+19
[0xc023bc9d] kobject_create_and_add+15
[0xc01aace7] register_disk+137

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023be1e] kset_create+29
[0xc023be5a] kset_create_and_add+9
[0xc05d9abb] devices_init+20

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc023bf79] kobject_uevent_env+148
[0xc023c245] kobject_uevent+10
[0xc02c1ac6] class_device_add+329

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc025485b] acpi_ds_create_operand+478

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc0257a3e] acpi_install_notify_handler+352

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc025dd09] acpi_ex_opcode_2A_0T_1R+47

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc026b49e] acpi_ut_allocate_object_desc_dbg+48
[0xc026b243] acpi_ut_create_internal_object_dbg+19
[0xc02610ea] acpi_ns_root_initialize+286

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc027230c] acpi_pci_link_add+45
[0xc026de2b] acpi_bus_driver_init+46
[0xc026da0c] acpi_device_probe+36

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02725d2] acpi_pci_irq_add_entry+47
[0xc027281d] acpi_pci_irq_add_prt+322
[0xc0271a5a] acpi_pci_root_add+606

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc027eef5] rand_initialize_disk+21
[0xc023563a] alloc_disk_node+123
[0xc02355bd] alloc_disk+11

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0283241] alloc_tty_driver+21
[0xc02ba100] uart_register_driver+59
[0xc05d9604] serial8250_init+104

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0283241] alloc_tty_driver+21
[0xc05d80c6] legacy_pty_init+50
[0xc05d8503] pty_init+8

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02893ea] con_insert_unipair+111
[0xc0289730] con_set_default_unimap+178
[0xc05d860b] console_map_init+43

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02bf1db] device_create+47
[0xc0288de0] vcs_make_sysfs+71
[0xc028ef46] con_open+116

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02c0882] bus_register+24
[0xc05d9b76] platform_bus_init+30
[0xc05d9be2] driver_init+28

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02ccf2f] loop_alloc+23
[0xc05da98f] loop_init+92
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03124eb] scsi_setup_command_freelist+133
[0xc03131eb] scsi_host_alloc+498
[0xc0332a6d] ahc_linux_register_host+32

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b03cd] sk_prot_alloc+21
[0xc03b0468] sk_alloc+31
[0xc03f0bdc] inet_create+405

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03b1eb2] __alloc_skb+41
[0xc023c0e1] kobject_uevent_env+508
[0xc023c245] kobject_uevent+10

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03f850e] fn_hash_insert+565
[0xc03f5e34] fib_magic+176
[0xc03f5ea7] fib_add_ifaddr+97

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03f852f] fn_hash_insert+598
[0xc03f5e34] fib_magic+176
[0xc03f5ea7] fib_add_ifaddr+97

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc04093a3] setup_cpu_cache+93
[0xc0172e75] kmem_cache_create+880
[0xc05d3711] kmem_cache_init+375

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc05d05e4] pidmap_init+18
[0xc05c26a0] start_kernel+419

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc012ac74] __register_sysctl_paths+71
[0xc012ad48] register_sysctl_paths+30
[0xc03f06b3] __devinet_sysctl_register+133

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0135192] param_sysfs_setup+83
[0xc05d06cf] kernel_param_sysfs_setup+127
[0xc05d07ad] param_sysfs_builtin+205

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0159802] mempool_create_node+54
[0xc01597ca] mempool_create+13
[0xc05db78b] scsi_init_queue+144

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc017594f] __percpu_alloc_mask+32
[0xc01336b1] __create_workqueue_key+66
[0xc05dce4c] psmouse_init+26

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0189b0b] alloc_vfsmnt+147
[0xc0179655] vfs_kern_mount+37
[0xc0179781] kern_mount_data+16

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a00a9] load_elf_binary+575
[0xc017ba9b] search_binary_handler+175
[0xc017bc6f] do_execve+281

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7b64] proc_mkdir_mode+26
[0xc05d443d] proc_tty_init+53

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7bf0] create_proc_entry+86
[0xc015696a] register_irq_proc+111

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7bf0] create_proc_entry+86
[0xc01aa7ab] proc_net_fops_create+19

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7bf0] create_proc_entry+86
[0xc0212291] cifs_proc_init+394

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7bf0] create_proc_entry+86
[0xc024c302] pci_proc_attach_device+164

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7bf0] create_proc_entry+86
[0xc0274133] acpi_processor_add_fs+82

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a7a61] proc_create+126
[0xc01a7bf0] create_proc_entry+86
[0xc05d44ef] proc_misc_init+114

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01a9ce3] read_page_owner+302
[0xc01a3db3] proc_reg_read+99
[0xc0177588] vfs_read+128

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc023b628] kobject_get_path+35
[0xc02be4f7] dev_uevent+217
[0xc02be652] show_uevent+134

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0254016] acpi_ds_build_internal_package_obj+142
[0xc02529f6] acpi_ds_eval_data_object_operands+167
[0xc02533bc] acpi_ds_exec_end_op+799

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc02597ef] acpi_ex_allocate_name_string+59
[0xc0259bc1] acpi_ex_get_name_string+512
[0xc02546db] acpi_ds_create_operand+94

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0262a94] acpi_ns_internalize_name+90
[0xc0262d6b] acpi_ns_get_node+54
[0xc0262ea3] acpi_get_handle+143

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0267554] acpi_reallocate_root_table+66
[0xc05d6a75] acpi_early_init+64
[0xc05c26f5] start_kernel+504

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc02c2832] kobj_map+62
[0xc0234ba3] blk_register_region+27
[0xc0234bfb] add_disk+39

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc03bff2c] __rtnl_register+56
[0xc03bff6a] rtnl_register+17
[0xc05e0020] rtnetlink_init+142

1 times:
Page allocated via order 0, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc0160fd8] kstrdup+40
[0xc03f0695] __devinet_sysctl_register+103
[0xc03f0736] devinet_sysctl_register+51

1 times:
Page allocated via order 1, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc02dd15c] tg3_alloc_consistent+150
[0xc02e023d] tg3_open+92
[0xc03b74bf] dev_open+72
[0xc03b94fd] dev_change_flags+152
[0xc03ef74b] devinet_ioctl+550

1 times:
Page allocated via order 1, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc02dd1d0] tg3_alloc_consistent+266
[0xc02e023d] tg3_open+92
[0xc03b74bf] dev_open+72
[0xc03b94fd] dev_change_flags+152
[0xc03ef74b] devinet_ioctl+550

1 times:
Page allocated via order 1, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0325d23] ahc_alloc_tstate+102
[0xc032a330] ahc_init+440
[0xc032ec73] ahc_pci_config+1816

1 times:
Page allocated via order 1, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0317cbf] scsi_alloc_sdev+97
[0xc0318897] scsi_probe_and_add_lun+175
[0xc0319015] __scsi_scan_target+134

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc012284d] dup_task_struct+60
[0xc0123774] copy_process+101
[0xc0124229] do_fork+141
[0xc01034c0] kernel_thread+110
[0xc04091b0] rest_init+20
[0xc05c26fa] start_kernel+509

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc012284d] dup_task_struct+60
[0xc0123774] copy_process+101
[0xc0124229] do_fork+141
[0xc01034c0] kernel_thread+110
[0xc04091c1] rest_init+37
[0xc05c26fa] start_kernel+509

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0106afe] sys_ioperm+99
[0xc01049fa] sysenter_past_esp+95

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0123341] copy_sighand+46
[0xc0123b66] copy_process+1111
[0xc0124135] fork_idle+41

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02355d5] alloc_disk_node+22
[0xc02355bd] alloc_disk+11
[0xc02ccf5b] loop_alloc+67

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02355d5] alloc_disk_node+22
[0xc02355bd] alloc_disk+11
[0xc035d210] sd_probe+99

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc02355d5] alloc_disk_node+22
[0xc02355bd] alloc_disk+11
[0xc036120c] sg_add+35

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc038fdfa] evdev_connect+72
[0xc038c4c9] input_attach_handler+61
[0xc038d510] input_register_handler+140

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0390da3] atkbd_connect+34
[0xc0388e58] serio_connect_driver+32
[0xc03899fe] serio_driver_probe+25

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc05e0381] rt_hash_lock_init+27
[0xc05e04e8] ip_rt_init+181
[0xc05e06dd] ip_init+8

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc05e07c4] tcp_init+182
[0xc05e0ed8] inet_init+281
[0xc05c2785] do_initcalls+117

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc01ec2e5] journal_init_revoke+146
[0xc01ed3c6] journal_init_common+222
[0xc01ed4a2] journal_init_inode+14

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc028115a] tty_write+239
[0xc0281293] redirected_tty_write+102
[0xc0177775] vfs_write+130

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0309f0f] hwif_init+226
[0xc030a0e3] ide_device_add_all+83
[0xc05db663] ide_generic_init+46

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc0317f53] scsi_alloc_target+80
[0xc0318fde] __scsi_scan_target+79
[0xc031912e] scsi_scan_channel+63

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc03ba4a6] alloc_netdev_mq+61
[0xc05dac84] loopback_net_init+32
[0xc03b68a3] register_pernet_operations+19

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc05c50c1] malloc+13
[0xc05c59b9] huft_build+45
[0xc05c632f] inflate_fixed+150

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc05e01c5] netlink_proto_init+44
[0xc05c2785] do_initcalls+117
[0xc05c28b9] do_basic_setup+28

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc0161067] kmemdup+28
[0xc03f0664] __devinet_sysctl_register+54
[0xc05e0c73] devinet_init+134

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc014df0a] audit_buffer_alloc+138
[0xc014e18a] audit_log_start+473

1 times:
Page allocated via order 1, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017413f] __kmalloc_track_caller+187
[0xc03b1ed3] __alloc_skb+74
[0xc023c0e1] kobject_uevent_env+508
[0xc023c245] kobject_uevent+10

1 times:
Page allocated via order 2, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc02dd12b] tg3_alloc_consistent+101
[0xc02e023d] tg3_open+92
[0xc03b74bf] dev_open+72
[0xc03b94fd] dev_change_flags+152
[0xc03ef74b] devinet_ioctl+550

1 times:
Page allocated via order 2, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc03293cc] ahc_init_scbdata+42
[0xc032a310] ahc_init+408
[0xc032ec73] ahc_pci_config+1816

1 times:
Page allocated via order 2, mask 0xd0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc017401a] __kmalloc+190
[0xc05c50c1] malloc+13
[0xc05c6e43] unpack_to_rootfs+43
[0xc05c70cc] populate_rootfs+27

1 times:
Page allocated via order 3, mask 0x10d1
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc02c5470] dma_mem_alloc+25
[0xc02ca453] floppy_open+283
[0xc0198af1] do_open+147
[0xc0198d8f] blkdev_open+42
[0xc0176a41] __dentry_open+374
[0xc0176bba] nameidata_to_filp+31

1 times:
Page allocated via order 3, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc0107aab] dma_alloc_coherent+203
[0xc02dd1a4] tg3_alloc_consistent+222
[0xc02e023d] tg3_open+92
[0xc03b74bf] dev_open+72
[0xc03b94fd] dev_change_flags+152
[0xc03ef74b] devinet_ioctl+550

1 times:
Page allocated via order 4, mask 0x4d0
[0xc015b9aa] __alloc_pages+706
[0xc0172497] kmem_getpages+96
[0xc017352f] cache_grow+154
[0xc0173a5e] cache_alloc_refill+423
[0xc0173e8a] kmem_cache_alloc+123
[0xc0311f4e] idecd_open+66
[0xc0198af1] do_open+147
[0xc0198d8f] blkdev_open+42

1 times:
Page allocated via order 5, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc05d3140] alloc_large_system_hash+335
[0xc05e04b5] ip_rt_init+130
[0xc05e06dd] ip_init+8
[0xc05e0ec9] inet_init+266
[0xc05c2785] do_initcalls+117
[0xc05c28b9] do_basic_setup+28

1 times:
Page allocated via order 8, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc05d3140] alloc_large_system_hash+335
[0xc05e076e] tcp_init+96
[0xc05e0ed8] inet_init+281
[0xc05c2785] do_initcalls+117
[0xc05c28b9] do_basic_setup+28
[0xc05c2937] kernel_init+75

1 times:
Page allocated via order 9, mask 0x20
[0xc015b9aa] __alloc_pages+706
[0xc015b9f0] __get_free_pages+60
[0xc05d3140] alloc_large_system_hash+335
[0xc05e0837] tcp_init+297
[0xc05e0ed8] inet_init+281
[0xc05c2785] do_initcalls+117
[0xc05c28b9] do_basic_setup+28
[0xc05c2937] kernel_init+75


--qMm9M+Fa2AknHoGS--
