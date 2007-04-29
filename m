Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXD2Pwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXD2Pwf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2007 11:52:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933318AbXD2Pv5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Apr 2007 11:51:57 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.31.123]:47654 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933372AbXD2Pvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2007 11:51:49 -0400
Date: Sun, 29 Apr 2007 17:51:47 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Fw: [2.6.21] possible circular locking dependency detected IN FILESYSTEM CODE (ext3)
Message-ID: <20070429155147.GB12873@atrey.karlin.mff.cuni.cz>
References: <20070428050757.129337d8.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070428050757.129337d8.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> Jan, could you crunch on this one please?
  Yep. I've actually seen one similar report too. It looks like a false
warning.  i_mutex (from some inode in sysfs) is acquired under
tty_mutex. And in quota code it's possible we need to acquire tty_mutex
under i_mutex (when writing quota warning). Because quota should never
deal with sysfs inodes, it should be harmless but still it's ugly, I
agree.
  Definitely, it would be tough to get rid of acquiring tty_mutex under
i_mutex in the quota code. From a quick look I also don't see an easy
way how to get rid of the other dependency as tty layer needs to
serialize device removal... Hmm, how hard would it be to teach lockdep
that i_mutex's for inodes of different fs-types are different? That
would not add too many lock-types to the system, also most possible
problems will be still catched and it would solve at least this problem.
Sysfs, proc and similar virtual filesystems *are* really different from
the real ones and perhaps it makes sence to also threat their locking
differently. What do you think?

								Honza

> Begin forwarded message:
> 
> Date: Fri, 27 Apr 2007 15:39:12 +0200
> From: Folkert van Heusden <folkert@vanheusden.com>
> To: linux-kernel@vger.kernel.org
> Cc: udovdh@xs4all.nl
> Subject: [2.6.21] possible circular locking dependency detected IN FILESYSTEM CODE (ext3)
> 
> 
> Hi,
> 
> Running 2.6.21 on a P4 with HT and 2GB of ram. One filesystem which is
> ext3. After 2+ hours of uptime I got the following circular locking
> dependency in my dmesg output:
> 
> [ 7429.853775] =======================================================
> [ 7429.853884] [ INFO: possible circular locking dependency detected ]
> [ 7429.853939] 2.6.21 #1
> [ 7429.854005] -------------------------------------------------------
> [ 7429.854058] moo/5453 is trying to acquire lock:
> [ 7429.854112]  (tty_mutex){--..}, at: [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.854286]
> [ 7429.854287] but task is already holding lock:
> [ 7429.854413]  (&s->s_dquot.dqptr_sem){----}, at: [<c109e3e4>] dquot_alloc_space+0x50/0x189
> [ 7429.854423]
> [ 7429.854424] which lock already depends on the new lock.
> [ 7429.854426]
> [ 7429.854427]
> [ 7429.854428] the existing dependency chain (in reverse order) is:
> [ 7429.854431]
> [ 7429.854432] -> #4 (&s->s_dquot.dqptr_sem){----}:
> [ 7429.854437]        [<c103983e>] check_prev_add+0x15b/0x281
> [ 7429.854445]        [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.854452]        [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.854460]        [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.854468]        [<c1033dbf>] down_read+0x2b/0x3d
> [ 7429.854477]        [<c109e3e4>] dquot_alloc_space+0x50/0x189
> [ 7429.854490]        [<c10af496>] ext3_new_blocks+0x44b/0x5a2
> [ 7429.854497]        [<c10b1a28>] ext3_alloc_blocks+0x40/0xdf
> [ 7429.854505]        [<c10b1b17>] ext3_alloc_branch+0x50/0x21b
> [ 7429.854512]        [<c10b1ff5>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7429.854519]        [<c10b231e>] ext3_getblk+0x97/0x228
> [ 7429.854530]        [<c10b24c9>] ext3_bread+0x1a/0x78
> [ 7429.854536]        [<c10b760a>] ext3_mkdir+0xf4/0x270
> [ 7429.854545]        [<c1077cb6>] vfs_mkdir+0xb3/0x161
> [ 7429.854553]        [<c1077df0>] sys_mkdirat+0x8c/0xc4
> [ 7429.854560]        [<c1077e48>] sys_mkdir+0x20/0x22
> [ 7429.854570]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.854578]        [<ffffffff>] 0xffffffff
> [ 7429.854600]
> [ 7429.854600] -> #3 (&ei->truncate_mutex){--..}:
> [ 7429.854608]        [<c103983e>] check_prev_add+0x15b/0x281
> [ 7429.854616]        [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.854623]        [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.854630]        [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.854637]        [<c120d400>] __mutex_lock_slowpath+0x75/0x28c
> [ 7429.854647]        [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.854654]        [<c10b3b97>] ext3_truncate+0x170/0x468
> [ 7429.854661]        [<c105dea4>] vmtruncate+0xa6/0x116
> [ 7429.854669]        [<c108276f>] inode_setattr+0x145/0x16c
> [ 7429.854678]        [<c10b4ab9>] ext3_setattr+0x150/0x22f
> [ 7429.854690]        [<c1082ae8>] notify_change+0x352/0x386
> [ 7429.854697]        [<c106ccf6>] do_truncate+0x52/0x75
> [ 7429.854705]        [<c10771aa>] may_open+0x1ec/0x231
> [ 7429.854713]        [<c1077368>] open_namei+0xda/0x59b
> [ 7429.854720]        [<c106d95e>] do_filp_open+0x2c/0x53
> [ 7429.854731]        [<c106dc93>] do_sys_open+0x52/0xd8
> [ 7429.854738]        [<c106dd35>] sys_open+0x1c/0x1e
> [ 7429.854745]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.854752]        [<ffffffff>] 0xffffffff
> [ 7429.854760]
> [ 7429.854761] -> #2 (&inode->i_alloc_sem){--..}:
> [ 7429.854770]        [<c103983e>] check_prev_add+0x15b/0x281
> [ 7429.854777]        [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.854784]        [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.854792]        [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.854798]        [<c1033e55>] down_write+0x2b/0x45
> [ 7429.854808]        [<c1082a6f>] notify_change+0x2d9/0x386
> [ 7429.854818]        [<c106ccf6>] do_truncate+0x52/0x75
> [ 7429.854826]        [<c10771aa>] may_open+0x1ec/0x231
> [ 7429.854834]        [<c1077368>] open_namei+0xda/0x59b
> [ 7429.854842]        [<c106d95e>] do_filp_open+0x2c/0x53
> [ 7429.854850]        [<c106dc93>] do_sys_open+0x52/0xd8
> [ 7429.854860]        [<c106dd35>] sys_open+0x1c/0x1e
> [ 7429.854867]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.854874]        [<ffffffff>] 0xffffffff
> [ 7429.854882]
> [ 7429.854883] -> #1 (&sysfs_inode_imutex_key){--..}:
> [ 7429.854887]        [<c103983e>] check_prev_add+0x15b/0x281
> [ 7429.854895]        [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.854902]        [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.854910]        [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.854917]        [<c120d400>] __mutex_lock_slowpath+0x75/0x28c
> [ 7429.854924]        [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.854934]        [<c10ac0b7>] remove_dir+0x2c/0xf1
> [ 7429.854942]        [<c10ac184>] sysfs_remove_subdir+0x8/0xa
> [ 7429.854950]        [<c10ad58b>] sysfs_remove_group+0x67/0x78
> [ 7429.854957]        [<c1154f44>] dpm_sysfs_remove+0x12/0x16
> [ 7429.854966]        [<c11546b3>] device_pm_remove+0x21/0x62
> [ 7429.854977]        [<c114e700>] device_del+0x89/0x1dd
> [ 7429.854984]        [<c114e85f>] device_unregister+0xb/0x15
> [ 7429.854992]        [<c114ea5a>] device_destroy+0x8d/0x9a
> [ 7429.854999]        [<c113a453>] vcs_remove_sysfs+0x1c/0x39
> [ 7429.855007]        [<c1140bd9>] con_close+0x5e/0x6b
> [ 7429.855017]        [<c11329d6>] release_dev+0x4c4/0x6ce
> [ 7429.855025]        [<c1133059>] tty_release+0x12/0x1c
> [ 7429.855033]        [<c106f67d>] __fput+0x145/0x16e
> [ 7429.855040]        [<c106f536>] fput+0x19/0x1b
> [ 7429.855046]        [<c106ddb6>] filp_close+0x3c/0x75
> [ 7429.855056]        [<c106de58>] sys_close+0x69/0xb4
> [ 7429.855064]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.855070]        [<ffffffff>] 0xffffffff
> [ 7429.855081]
> [ 7429.855082] -> #0 (tty_mutex){--..}:
> [ 7429.855085]        [<c1039717>] check_prev_add+0x34/0x281
> [ 7429.855098]        [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.855105]        [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.855112]        [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.855120]        [<c120d400>] __mutex_lock_slowpath+0x75/0x28c
> [ 7429.855127]        [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855134]        [<c109dd5a>] print_warning+0x8c/0x15d
> [ 7429.855144]        [<c109e518>] dquot_alloc_space+0x184/0x189
> [ 7429.855151]        [<c10af496>] ext3_new_blocks+0x44b/0x5a2
> [ 7429.855162]        [<c10b1a28>] ext3_alloc_blocks+0x40/0xdf
> [ 7429.855169]        [<c10b1b17>] ext3_alloc_branch+0x50/0x21b
> [ 7429.855177]        [<c10b1ff5>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7429.855184]        [<c10b221c>] ext3_get_block+0x78/0xe3
> [ 7429.855195]        [<c108f265>] __block_prepare_write+0x168/0x408
> [ 7429.855202]        [<c108fd47>] block_prepare_write+0x28/0x3b
> [ 7429.855210]        [<c10b26c8>] ext3_prepare_write+0xe3/0x17e
> [ 7429.855218]        [<c1052a29>] generic_file_buffered_write+0x1b1/0x611
> [ 7429.855226]        [<c1053137>] __generic_file_aio_write_nolock+0x2ae/0x5ad
> [ 7429.855239]        [<c105353f>] generic_file_aio_write+0x58/0xc4
> [ 7429.855246]        [<c10b02d3>] ext3_file_write+0x2d/0xba
> [ 7429.855253]        [<c106e73f>] do_sync_write+0xc7/0x116
> [ 7429.855260]        [<c106e8e6>] vfs_write+0x158/0x15d
> [ 7429.855266]        [<c106e98c>] sys_write+0x3d/0x64
> [ 7429.855275]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.855282]        [<ffffffff>] 0xffffffff
> [ 7429.855290]
> [ 7429.855291] other info that might help us debug this:
> [ 7429.855293]
> [ 7429.855296] 3 locks held by moo/5453:
> [ 7429.855297]  #0:  (&inode->i_mutex){--..}, at: [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855305]  #1:  (&ei->truncate_mutex){--..}, at: [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855312]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c109e3e4>] dquot_alloc_space+0x50/0x189
> [ 7429.855323]
> [ 7429.855324] stack backtrace:
> [ 7429.855326]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [ 7429.855331]  [<c1004d7b>] show_trace+0x12/0x14
> [ 7429.855335]  [<c1004e75>] dump_stack+0x16/0x18
> [ 7429.855339]  [<c103908e>] print_circular_bug_tail+0x6f/0x71
> [ 7429.855343]  [<c1039717>] check_prev_add+0x34/0x281
> [ 7429.855347]  [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.855350]  [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.855355]  [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.855362]  [<c120d400>] __mutex_lock_slowpath+0x75/0x28c
> [ 7429.855366]  [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855370]  [<c109dd5a>] print_warning+0x8c/0x15d
> [ 7429.855374]  [<c109e518>] dquot_alloc_space+0x184/0x189
> [ 7429.855378]  [<c10af496>] ext3_new_blocks+0x44b/0x5a2
> [ 7429.855382]  [<c10b1a28>] ext3_alloc_blocks+0x40/0xdf
> [ 7429.855386]  [<c10b1b17>] ext3_alloc_branch+0x50/0x21b
> [ 7429.855007]        [<c1140bd9>] con_close+0x5e/0x6b
> [ 7429.855017]        [<c11329d6>] release_dev+0x4c4/0x6ce
> [ 7429.855025]        [<c1133059>] tty_release+0x12/0x1c
> [ 7429.855033]        [<c106f67d>] __fput+0x145/0x16e
> [ 7429.855040]        [<c106f536>] fput+0x19/0x1b
> [ 7429.855046]        [<c106ddb6>] filp_close+0x3c/0x75
> [ 7429.855056]        [<c106de58>] sys_close+0x69/0xb4
> [ 7429.855064]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.855070]        [<ffffffff>] 0xffffffff
> [ 7429.855081]
> [ 7429.855082] -> #0 (tty_mutex){--..}:
> [ 7429.855085]        [<c1039717>] check_prev_add+0x34/0x281
> [ 7429.855098]        [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.855105]        [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.855112]        [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.855120]        [<c120d400>] __mutex_lock_slowpath+0x75/0x28c
> [ 7429.855127]        [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855134]        [<c109dd5a>] print_warning+0x8c/0x15d
> [ 7429.855144]        [<c109e518>] dquot_alloc_space+0x184/0x189
> [ 7429.855151]        [<c10af496>] ext3_new_blocks+0x44b/0x5a2
> [ 7429.855162]        [<c10b1a28>] ext3_alloc_blocks+0x40/0xdf
> [ 7429.855169]        [<c10b1b17>] ext3_alloc_branch+0x50/0x21b
> [ 7429.855177]        [<c10b1ff5>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7429.855184]        [<c10b221c>] ext3_get_block+0x78/0xe3
> [ 7429.855195]        [<c108f265>] __block_prepare_write+0x168/0x408
> [ 7429.855202]        [<c108fd47>] block_prepare_write+0x28/0x3b
> [ 7429.855210]        [<c10b26c8>] ext3_prepare_write+0xe3/0x17e
> [ 7429.855218]        [<c1052a29>] generic_file_buffered_write+0x1b1/0x611
> [ 7429.855226]        [<c1053137>] __generic_file_aio_write_nolock+0x2ae/0x5ad
> [ 7429.855239]        [<c105353f>] generic_file_aio_write+0x58/0xc4
> [ 7429.855246]        [<c10b02d3>] ext3_file_write+0x2d/0xba
> [ 7429.855253]        [<c106e73f>] do_sync_write+0xc7/0x116
> [ 7429.855260]        [<c106e8e6>] vfs_write+0x158/0x15d
> [ 7429.855266]        [<c106e98c>] sys_write+0x3d/0x64
> [ 7429.855275]        [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.855282]        [<ffffffff>] 0xffffffff
> [ 7429.855290]
> [ 7429.855291] other info that might help us debug this:
> [ 7429.855293]
> [ 7429.855296] 3 locks held by moo/5453:
> [ 7429.855297]  #0:  (&inode->i_mutex){--..}, at: [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855305]  #1:  (&ei->truncate_mutex){--..}, at: [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855312]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c109e3e4>] dquot_alloc_space+0x50/0x189
> [ 7429.855323]
> [ 7429.855324] stack backtrace:
> [ 7429.855326]  [<c1004d53>] show_trace_log_lvl+0x1a/0x30
> [ 7429.855331]  [<c1004d7b>] show_trace+0x12/0x14
> [ 7429.855335]  [<c1004e75>] dump_stack+0x16/0x18
> [ 7429.855339]  [<c103908e>] print_circular_bug_tail+0x6f/0x71
> [ 7429.855343]  [<c1039717>] check_prev_add+0x34/0x281
> [ 7429.855347]  [<c10399ef>] check_prevs_add+0x8b/0xe8
> [ 7429.855350]  [<c103b3bf>] __lock_acquire+0x692/0xb81
> [ 7429.855355]  [<c103bd16>] lock_acquire+0x62/0x81
> [ 7429.855362]  [<c120d400>] __mutex_lock_slowpath+0x75/0x28c
> [ 7429.855366]  [<c120d37f>] mutex_lock+0x8/0xa
> [ 7429.855370]  [<c109dd5a>] print_warning+0x8c/0x15d
> [ 7429.855374]  [<c109e518>] dquot_alloc_space+0x184/0x189
> [ 7429.855378]  [<c10af496>] ext3_new_blocks+0x44b/0x5a2
> [ 7429.855382]  [<c10b1a28>] ext3_alloc_blocks+0x40/0xdf
> [ 7429.855386]  [<c10b1b17>] ext3_alloc_branch+0x50/0x21b
> [ 7429.855389]  [<c10b1ff5>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7429.855393]  [<c10b221c>] ext3_get_block+0x78/0xe3
> [ 7429.855400]  [<c108f265>] __block_prepare_write+0x168/0x408
> [ 7429.855405]  [<c108fd47>] block_prepare_write+0x28/0x3b
> [ 7429.855409]  [<c10b26c8>] ext3_prepare_write+0xe3/0x17e
> [ 7429.855412]  [<c1052a29>] generic_file_buffered_write+0x1b1/0x611
> [ 7429.855417]  [<c1053137>] __generic_file_aio_write_nolock+0x2ae/0x5ad
> [ 7429.855422]  [<c105353f>] generic_file_aio_write+0x58/0xc4
> [ 7429.855426]  [<c10b02d3>] ext3_file_write+0x2d/0xba
> [ 7429.855430]  [<c106e73f>] do_sync_write+0xc7/0x116
> [ 7429.855433]  [<c106e8e6>] vfs_write+0x158/0x15d
> [ 7429.855440]  [<c106e98c>] sys_write+0x3d/0x64
> [ 7429.855445]  [<c1003f74>] syscall_call+0x7/0xb
> [ 7429.855449]  =======================
> 
> 
> Folkert van Heusden
> 
> -- 
> www.biglumber.com <- site where one can exchange PGP key signatures 
> ----------------------------------------------------------------------
> Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
