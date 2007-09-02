Return-Path: <linux-kernel-owner+w=401wt.eu-S934164AbXIBRLs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934164AbXIBRLs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2007 13:11:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932119AbXIBRLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Sep 2007 13:11:39 -0400
Received: from smtp-vbr12.xs4all.nl ([194.109.24.32]:2750 "EHLO
	smtp-vbr12.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774AbXIBRLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2007 13:11:38 -0400
Date: Sun, 2 Sep 2007 19:11:21 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Jan Kara <jack@ucw.cz>
Subject: Re: [2.6.22] circular lock detected
Message-ID: <20070902171121.GF26617@vanheusden.com>
References: <20070824210033.GB13237@vanheusden.com> <20070902045529.c66eddc9.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070902045529.c66eddc9.akpm@linux-foundation.org>
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Mon Sep  3 00:49:00 CEST 2007
X-Message-Flag: MultiTail - tail on steroids
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > 2.6.22 kernel with hyperthreading enabled only ext3 filesystems (2).
> > 
> > [  346.314640] =======================================================
...
> > [  346.349869]        [<ffffffff>] 0xffffffff
> > [  346.350438] 
> > [  346.350440] other info that might help us debug this:
> > [  346.350442] 
> > [  346.350562] 3 locks held by tor/2421:
> > [  346.350604]  #0:  (&inode->i_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> > [  346.350827]  #1:  (&ei->truncate_mutex){--..}, at: [<c121aa83>] mutex_lock+0x8/0xa
> > [  346.351049]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c10a485f>] dquot_alloc_space+0x50/0x189
> > [  346.351274] 
> > [  346.351276] stack backtrace:
...
> > [  346.353603]  =======================
> 
> Has been reported before, but I don't recall whether we fixed it.  Jan,
> do you know>?

It is repeatable. Yesterday I changed from ata to sata and it still
occurs altough in a different proces:

[ 7382.917927] 

Oh and it also seems it takes longer.

[ 7382.917929] =======================================================
[ 7382.918024] [ INFO: possible circular locking dependency detected ]
[ 7382.918072] 2.6.22 #2
[ 7382.918114] -------------------------------------------------------
[ 7382.918159] moo/17202 is trying to acquire lock:
[ 7382.918204]  (tty_mutex){--..}, at: [<c1228353>] mutex_lock+0x8/0xa
[ 7382.918392] 
[ 7382.918393] but task is already holding lock:
[ 7382.918474]  (&s->s_dquot.dqptr_sem){----}, at: [<c10a47a3>] dquot_alloc_space+0x50/0x189
[ 7382.918665] 
[ 7382.918666] which lock already depends on the new lock.
[ 7382.918668] 
[ 7382.918788] 
[ 7382.918789] the existing dependency chain (in reverse order) is:
[ 7382.918873] 
[ 7382.918874] -> #4 (&s->s_dquot.dqptr_sem){----}:
[ 7382.919061]        [<c103b232>] check_prev_add+0x15b/0x281
[ 7382.919378]        [<c103b3e3>] check_prevs_add+0x8b/0xe8
[ 7382.919690]        [<c103cd6e>] __lock_acquire+0x65d/0xb51
[ 7382.920004]        [<c103d6ca>] lock_acquire+0x62/0x81
[ 7382.920322]        [<c10340f3>] down_read+0x2b/0x3d
[ 7382.920635]        [<c10a47a3>] dquot_alloc_space+0x50/0x189
[ 7382.920957]        [<c10b5b99>] ext3_new_blocks+0x44b/0x5a2
[ 7382.921280]        [<c10b8128>] ext3_alloc_blocks+0x40/0xdf
[ 7382.921592]        [<c10b8217>] ext3_alloc_branch+0x50/0x21b
[ 7382.921906]        [<c10b86f5>] ext3_get_blocks_handle+0x1b8/0x367
[ 7382.922222]        [<c10b8a1e>] ext3_getblk+0x97/0x228
[ 7382.922534]        [<c10b8bc9>] ext3_bread+0x1a/0x78
[ 7382.922844]        [<c10bdda8>] ext3_mkdir+0xf4/0x270
[ 7382.923160]        [<c107cd3a>] vfs_mkdir+0xb3/0x161
[ 7382.923474]        [<c107ce74>] sys_mkdirat+0x8c/0xc4
[ 7382.923789]        [<c107cecc>] sys_mkdir+0x20/0x22
[ 7382.924106]        [<c1003eea>] syscall_call+0x7/0xb
[ 7382.924425]        [<ffffffff>] 0xffffffff
[ 7382.924752] 
[ 7382.924753] -> #3 (&ei->truncate_mutex){--..}:
[ 7382.924939]        [<c103b232>] check_prev_add+0x15b/0x281
[ 7382.925257]        [<c103b3e3>] check_prevs_add+0x8b/0xe8
[ 7382.925571]        [<c103cd6e>] __lock_acquire+0x65d/0xb51
[ 7382.925886]        [<c103d6ca>] lock_acquire+0x62/0x81
[ 7382.926202]        [<c12283d4>] __mutex_lock_slowpath+0x75/0x28c
[ 7382.926782]        [<c1228353>] mutex_lock+0x8/0xa
[ 7382.927101]        [<c10ba2c4>] ext3_truncate+0x170/0x468
[ 7382.927414]        [<c1060dde>] vmtruncate+0xa6/0x116
[ 7382.927726]        [<c108787b>] inode_setattr+0x145/0x16c
[ 7382.928041]        [<c10bb245>] ext3_setattr+0x150/0x22f
[ 7382.928358]        [<c1087bf4>] notify_change+0x352/0x386
[ 7382.928672]        [<c1071a38>] do_truncate+0x5c/0x7f
[ 7382.928988]        [<c107c227>] may_open+0x1ec/0x231
[ 7382.929289]        [<c107c3e8>] open_namei+0xdd/0x5a2
[ 7382.929298]        [<c107269f>] do_filp_open+0x2c/0x53
[ 7382.929308]        [<c10729d4>] do_sys_open+0x52/0xd8
[ 7382.929316]        [<c1072a76>] sys_open+0x1c/0x1e
[ 7382.929323]        [<c1003eea>] syscall_call+0x7/0xb
[ 7382.929332]        [<ffffffff>] 0xffffffff
[ 7382.929351] 
[ 7382.929352] -> #2 (&inode->i_alloc_sem){--..}:
[ 7382.929358]        [<c103b232>] check_prev_add+0x15b/0x281
[ 7382.929367]        [<c103b3e3>] check_prevs_add+0x8b/0xe8
[ 7382.929374]        [<c103cd6e>] __lock_acquire+0x65d/0xb51
[ 7382.929382]        [<c103d6ca>] lock_acquire+0x62/0x81
[ 7382.929390]        [<c1034189>] down_write+0x2b/0x45
[ 7382.929401]        [<c1087b7b>] notify_change+0x2d9/0x386
[ 7382.929409]        [<c1071a38>] do_truncate+0x5c/0x7f
[ 7382.929416]        [<c107c227>] may_open+0x1ec/0x231
[ 7382.929423]        [<c107c3e8>] open_namei+0xdd/0x5a2
[ 7382.929430]        [<c107269f>] do_filp_open+0x2c/0x53
[ 7382.929441]        [<c10729d4>] do_sys_open+0x52/0xd8
[ 7382.929449]        [<c1072a76>] sys_open+0x1c/0x1e
[ 7382.929455]        [<c1003eea>] syscall_call+0x7/0xb
[ 7382.929463]        [<ffffffff>] 0xffffffff
[ 7382.929471] 
[ 7382.929472] -> #1 (&sysfs_inode_imutex_key){--..}:
[ 7382.929481]        [<c103b232>] check_prev_add+0x15b/0x281
[ 7382.929489]        [<c103b3e3>] check_prevs_add+0x8b/0xe8
[ 7382.929496]        [<c103cd6e>] __lock_acquire+0x65d/0xb51
[ 7382.929505]        [<c103d6ca>] lock_acquire+0x62/0x81
[ 7382.929512]        [<c12283d4>] __mutex_lock_slowpath+0x75/0x28c
[ 7382.929523]        [<c1228353>] mutex_lock+0x8/0xa
[ 7382.929531]        [<c10b276c>] remove_dir+0x2c/0xf1
[ 7382.929538]        [<c10b2839>] sysfs_remove_subdir+0x8/0xa
[ 7382.929547]        [<c10b3c13>] sysfs_remove_group+0x67/0x78
[ 7382.929554]        [<c115cd9c>] dpm_sysfs_remove+0x12/0x16
[ 7382.929563]        [<c115c4b3>] device_pm_remove+0x21/0x62
[ 7382.929570]        [<c1156f09>] device_del+0x82/0x291
[ 7382.929578]        [<c1157123>] device_unregister+0xb/0x15
[ 7382.929585]        [<c115731e>] device_destroy+0x8d/0x9a
[ 7382.929592]        [<c1142856>] vcs_remove_sysfs+0x1c/0x3a
[ 7382.929600]        [<c11491b9>] con_close+0x5e/0x6b
[ 7382.929607]        [<c113aba2>] release_dev+0x4c4/0x6ce
[ 7382.929614]        [<c113b21a>] tty_release+0x12/0x1c
[ 7382.929620]        [<c10743bd>] __fput+0x145/0x16e
[ 7382.929628]        [<c1074276>] fput+0x19/0x1b
[ 7382.929634]        [<c1072af7>] filp_close+0x3c/0x75
[ 7382.929641]        [<c1072b99>] sys_close+0x69/0xb4
[ 7382.929648]        [<c1003eea>] syscall_call+0x7/0xb
[ 7382.929654]        [<ffffffff>] 0xffffffff
[ 7382.929665] 
[ 7382.929666] -> #0 (tty_mutex){--..}:
[ 7382.929670]        [<c103b10b>] check_prev_add+0x34/0x281
[ 7382.929677]        [<c103b3e3>] check_prevs_add+0x8b/0xe8
[ 7382.929684]        [<c103cd6e>] __lock_acquire+0x65d/0xb51
[ 7382.929691]        [<c103d6ca>] lock_acquire+0x62/0x81
[ 7382.929698]        [<c12283d4>] __mutex_lock_slowpath+0x75/0x28c
[ 7382.929706]        [<c1228353>] mutex_lock+0x8/0xa
[ 7382.929712]        [<c10a4119>] print_warning+0x8c/0x15d
[ 7382.929720]        [<c10a48d7>] dquot_alloc_space+0x184/0x189
[ 7382.929727]        [<c10b5b99>] ext3_new_blocks+0x44b/0x5a2
[ 7382.929735]        [<c10b8128>] ext3_alloc_blocks+0x40/0xdf
[ 7382.929741]        [<c10b8217>] ext3_alloc_branch+0x50/0x21b
[ 7382.929748]        [<c10b86f5>] ext3_get_blocks_handle+0x1b8/0x367
[ 7382.929755]        [<c10b891c>] ext3_get_block+0x78/0xe3
[ 7382.929761]        [<c1094746>] __block_prepare_write+0x168/0x415
[ 7382.929770]        [<c1095252>] block_prepare_write+0x28/0x3b
[ 7382.929777]        [<c10b8dc8>] ext3_prepare_write+0xe3/0x17e
[ 7382.929784]        [<c1055235>] generic_file_buffered_write+0x1b4/0x614
[ 7382.929792]        [<c10558cf>] __generic_file_aio_write_nolock+0x23a/0x533
[ 7382.929800]        [<c1055cd1>] generic_file_aio_write+0x58/0xc4
[ 7382.929807]        [<c10b69d7>] ext3_file_write+0x2d/0xba
[ 7382.929815]        [<c107347f>] do_sync_write+0xc7/0x116
[ 7382.929822]        [<c1073626>] vfs_write+0x158/0x15d
[ 7382.929829]        [<c10736cc>] sys_write+0x3d/0x64
[ 7382.929835]        [<c1003eea>] syscall_call+0x7/0xb
[ 7382.929842]        [<ffffffff>] 0xffffffff
[ 7382.929851] 
[ 7382.929852] other info that might help us debug this:
[ 7382.929853] 
[ 7382.929855] 3 locks held by moo/17202:
[ 7382.929857]  #0:  (&inode->i_mutex){--..}, at: [<c1228353>] mutex_lock+0x8/0xa
[ 7382.929864]  #1:  (&ei->truncate_mutex){--..}, at: [<c1228353>] mutex_lock+0x8/0xa
[ 7382.929871]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c10a47a3>] dquot_alloc_space+0x50/0x189
[ 7382.929877] 
[ 7382.929878] stack backtrace:
[ 7382.929880]  [<c1004cac>] show_trace_log_lvl+0x1a/0x30
[ 7382.929885]  [<c1004cd4>] show_trace+0x12/0x14
[ 7382.929888]  [<c1004dce>] dump_stack+0x16/0x18
[ 7382.929892]  [<c103aa6d>] print_circular_bug_tail+0x6f/0x71
[ 7382.929896]  [<c103b10b>] check_prev_add+0x34/0x281
[ 7382.929900]  [<c103b3e3>] check_prevs_add+0x8b/0xe8
[ 7382.929903]  [<c103cd6e>] __lock_acquire+0x65d/0xb51
[ 7382.929907]  [<c103d6ca>] lock_acquire+0x62/0x81
[ 7382.929911]  [<c12283d4>] __mutex_lock_slowpath+0x75/0x28c
[ 7382.929915]  [<c1228353>] mutex_lock+0x8/0xa
[ 7382.929919]  [<c10a4119>] print_warning+0x8c/0x15d
[ 7382.929923]  [<c10a48d7>] dquot_alloc_space+0x184/0x189
[ 7382.929926]  [<c10b5b99>] ext3_new_blocks+0x44b/0x5a2
[ 7382.929931]  [<c10b8128>] ext3_alloc_blocks+0x40/0xdf
[ 7382.929934]  [<c10b8217>] ext3_alloc_branch+0x50/0x21b
[ 7382.929937]  [<c10b86f5>] ext3_get_blocks_handle+0x1b8/0x367
[ 7382.929941]  [<c10b891c>] ext3_get_block+0x78/0xe3
[ 7382.929944]  [<c1094746>] __block_prepare_write+0x168/0x415
[ 7382.929949]  [<c1095252>] block_prepare_write+0x28/0x3b
[ 7382.929953]  [<c10b8dc8>] ext3_prepare_write+0xe3/0x17e
[ 7382.929957]  [<c1055235>] generic_file_buffered_write+0x1b4/0x614
[ 7382.929961]  [<c10558cf>] __generic_file_aio_write_nolock+0x23a/0x533
[ 7382.929966]  [<c1055cd1>] generic_file_aio_write+0x58/0xc4
[ 7382.929970]  [<c10b69d7>] ext3_file_write+0x2d/0xba
[ 7382.929974]  [<c107347f>] do_sync_write+0xc7/0x116
[ 7382.929978]  [<c1073626>] vfs_write+0x158/0x15d
[ 7382.929981]  [<c10736cc>] sys_write+0x3d/0x64
[ 7382.929985]  [<c1003eea>] syscall_call+0x7/0xb
[ 7382.929988]  =======================


Folkert van Heusden

-- 

Multitail - gibkaja utilita po sledovaniju log-fajlov i vyvoda
kommand. Fil'trovanie, raskrašivanie, slijanie, vizual'noe sravnenie,
i t.d.  http://www.vanheusden.com/multitail/
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
