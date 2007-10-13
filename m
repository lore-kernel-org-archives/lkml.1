Return-Path: <linux-kernel-owner+w=401wt.eu-S1763366AbXJMXUW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763366AbXJMXUW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2007 19:20:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754412AbXJMXUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Oct 2007 19:20:08 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36546 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754264AbXJMXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2007 19:20:07 -0400
Subject: Re: [2.6.23.1] possible circular locking dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Folkert van Heusden <folkert@vanheusden.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20071013223614.GF25076@vanheusden.com>
References: <20071013223614.GF25076@vanheusden.com>
Content-Type: text/plain
Date: Sun, 14 Oct 2007 01:19:56 +0200
Message-Id: <1192317596.5625.12.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 2007-10-14 at 00:36 +0200, Folkert van Heusden wrote:
> I've got a deja-vu feeling for this one but in any case:
> 
> 
> [ 7393.894980] =======================================================
> [ 7393.895081] [ INFO: possible circular locking dependency detected ]
> [ 7393.895130] 2.6.23.1 #2
> [ 7393.895175] -------------------------------------------------------
> [ 7393.895225] moo/28246 is trying to acquire lock:
> [ 7393.895275]  (tty_mutex){--..}, at: [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.895486] 
> [ 7393.895487] but task is already holding lock:
> [ 7393.895578]  (&s->s_dquot.dqptr_sem){----}, at: [<c10a76ab>] dquot_alloc_space+0x50/0x189
> [ 7393.895784] 
> [ 7393.895785] which lock already depends on the new lock.
> [ 7393.895788] 
> [ 7393.895915] 
> [ 7393.895916] the existing dependency chain (in reverse order) is:
> [ 7393.896003] 
> [ 7393.896005] -> #3 (&s->s_dquot.dqptr_sem){----}:
> [ 7393.896209]        [<c103e375>] check_prev_add+0xc4/0x1fb
> [ 7393.896555]        [<c103e537>] check_prevs_add+0x8b/0xe8
> [ 7393.896890]        [<c103e7bf>] validate_chain+0x22b/0x354
> [ 7393.897223]        [<c103fe7a>] __lock_acquire+0x1a0/0x74a
> [ 7393.897553]        [<c1040895>] lock_acquire+0x6b/0x8a
> [ 7393.897882]        [<c1036cef>] down_read+0x2b/0x3d
> [ 7393.898205]        [<c10a76ab>] dquot_alloc_space+0x50/0x189
> [ 7393.898537]        [<c10b90c7>] ext3_new_blocks+0x44b/0x5a2
> [ 7393.898868]        [<c10bb6ac>] ext3_alloc_blocks+0x40/0xdf
> [ 7393.899194]        [<c10bb79b>] ext3_alloc_branch+0x50/0x21b
> [ 7393.899527]        [<c10bbc79>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7393.899858]        [<c10bbfa2>] ext3_getblk+0x97/0x228
> [ 7393.900186]        [<c10bc14d>] ext3_bread+0x1a/0x78
> [ 7393.900514]        [<c10c13a4>] ext3_mkdir+0xf2/0x270
> [ 7393.900851]        [<c107fda3>] vfs_mkdir+0xb3/0x161
> [ 7393.901174]        [<c107fedd>] sys_mkdirat+0x8c/0xc4
> [ 7393.901512]        [<c107ff35>] sys_mkdir+0x20/0x22
> [ 7393.901841]        [<c1003ffe>] syscall_call+0x7/0xb
> [ 7393.902169]        [<ffffffff>] 0xffffffff
> [ 7393.902511] 
> [ 7393.902512] -> #2 (&ei->truncate_mutex){--..}:
> [ 7393.902706]        [<c103e375>] check_prev_add+0xc4/0x1fb
> [ 7393.903033]        [<c103e537>] check_prevs_add+0x8b/0xe8
> [ 7393.903364]        [<c103e7bf>] validate_chain+0x22b/0x354
> [ 7393.903700]        [<c103fe7a>] __lock_acquire+0x1a0/0x74a
> [ 7393.904353]        [<c1040895>] lock_acquire+0x6b/0x8a
> [ 7393.904682]        [<c1232020>] __mutex_lock_slowpath+0x75/0x299
> [ 7393.905015]        [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.905339]        [<c10bbb9a>] ext3_get_blocks_handle+0xd9/0x367
> [ 7393.905675]        [<c10bbea0>] ext3_get_block+0x78/0xe3
> [ 7393.906009]        [<c1097beb>] __block_prepare_write+0x168/0x415
> [ 7393.906339]        [<c10986f7>] block_prepare_write+0x28/0x3b
> [ 7393.906673]        [<c10bc34c>] ext3_prepare_write+0xe3/0x17e
> [ 7393.907002]        [<c10579c5>] generic_file_buffered_write+0x1cb/0x62b
> [ 7393.907333]        [<c105805f>] __generic_file_aio_write_nolock+0x23a/0x53d
> [ 7393.907667]        [<c105846b>] generic_file_aio_write+0x58/0xc4
> [ 7393.907998]        [<c10b9f1f>] ext3_file_write+0x2d/0xba
> [ 7393.908324]        [<c1076303>] do_sync_write+0xc7/0x116
> [ 7393.908655]        [<c10764aa>] vfs_write+0x158/0x15d
> [ 7393.908981]        [<c1076550>] sys_write+0x3d/0x64
> [ 7393.909310]        [<c1003ffe>] syscall_call+0x7/0xb
> [ 7393.909635]        [<ffffffff>] 0xffffffff
> [ 7393.909974] 
> [ 7393.909976] -> #1 (&inode->i_mutex){--..}:
> [ 7393.910163]        [<c103e375>] check_prev_add+0xc4/0x1fb
> [ 7393.910496]        [<c103e537>] check_prevs_add+0x8b/0xe8
> [ 7393.910823]        [<c103e7bf>] validate_chain+0x22b/0x354
> [ 7393.911152]        [<c103fe7a>] __lock_acquire+0x1a0/0x74a
> [ 7393.911478]        [<c1040895>] lock_acquire+0x6b/0x8a
> [ 7393.911807]        [<c1232020>] __mutex_lock_slowpath+0x75/0x299
> [ 7393.912137]        [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.912465]        [<c10b7385>] get_node+0x21/0x4d
> [ 7393.912788]        [<c10b7566>] devpts_get_tty+0xb/0x3b
> [ 7393.913398]        [<c1141896>] init_dev+0x22b/0x58b
> [ 7393.913718]        [<c114274e>] ptmx_open+0x90/0x1c9
> [ 7393.913992]        [<c1078c01>] chrdev_open+0xaf/0x171
> [ 7393.914001]        [<c1075456>] __dentry_open+0x152/0x1d3
> [ 7393.914008]        [<c10755d5>] nameidata_to_filp+0x28/0x3f
> [ 7393.914018]        [<c107551d>] do_filp_open+0x46/0x53
> [ 7393.914024]        [<c107585a>] do_sys_open+0x54/0xda
> [ 7393.914031]        [<c10758fc>] sys_open+0x1c/0x1e
> [ 7393.914038]        [<c1003ffe>] syscall_call+0x7/0xb
> [ 7393.914046]        [<ffffffff>] 0xffffffff
> [ 7393.914069] 
> [ 7393.914070] -> #0 (tty_mutex){--..}:
> [ 7393.914074]        [<c103e2e5>] check_prev_add+0x34/0x1fb
> [ 7393.914084]        [<c103e537>] check_prevs_add+0x8b/0xe8
> [ 7393.914092]        [<c103e7bf>] validate_chain+0x22b/0x354
> [ 7393.914103]        [<c103fe7a>] __lock_acquire+0x1a0/0x74a
> [ 7393.914111]        [<c1040895>] lock_acquire+0x6b/0x8a
> [ 7393.914117]        [<c1232020>] __mutex_lock_slowpath+0x75/0x299
> [ 7393.914126]        [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.914134]        [<c10a7039>] print_warning+0x8c/0x15d
> [ 7393.914143]        [<c10a77df>] dquot_alloc_space+0x184/0x189
> [ 7393.914154]        [<c10b90c7>] ext3_new_blocks+0x44b/0x5a2
> [ 7393.914162]        [<c10bb6ac>] ext3_alloc_blocks+0x40/0xdf
> [ 7393.914170]        [<c10bb79b>] ext3_alloc_branch+0x50/0x21b
> [ 7393.914177]        [<c10bbc79>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7393.914185]        [<c10bbea0>] ext3_get_block+0x78/0xe3
> [ 7393.914195]        [<c1097beb>] __block_prepare_write+0x168/0x415
> [ 7393.914203]        [<c10986f7>] block_prepare_write+0x28/0x3b
> [ 7393.914211]        [<c10bc34c>] ext3_prepare_write+0xe3/0x17e
> [ 7393.914218]        [<c10579c5>] generic_file_buffered_write+0x1cb/0x62b
> [ 7393.914226]        [<c105805f>] __generic_file_aio_write_nolock+0x23a/0x53d
> [ 7393.914238]        [<c105846b>] generic_file_aio_write+0x58/0xc4
> [ 7393.914245]        [<c10b9f1f>] ext3_file_write+0x2d/0xba
> [ 7393.914252]        [<c1076303>] do_sync_write+0xc7/0x116
> [ 7393.914260]        [<c10764aa>] vfs_write+0x158/0x15d
> [ 7393.914266]        [<c1076550>] sys_write+0x3d/0x64
> [ 7393.914274]        [<c1003ffe>] syscall_call+0x7/0xb
> [ 7393.914280]        [<ffffffff>] 0xffffffff
> [ 7393.914290] 
> [ 7393.914291] other info that might help us debug this:
> [ 7393.914293] 
> [ 7393.914295] 3 locks held by moo/28246:
> [ 7393.914298]  #0:  (&inode->i_mutex){--..}, at: [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.914305]  #1:  (&ei->truncate_mutex){--..}, at: [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.914315]  #2:  (&s->s_dquot.dqptr_sem){----}, at: [<c10a76ab>] dquot_alloc_space+0x50/0x189
> [ 7393.914322] 
> [ 7393.914323] stack backtrace:
> [ 7393.914325]  [<c1004dcc>] show_trace_log_lvl+0x1a/0x30
> [ 7393.914330]  [<c1004df4>] show_trace+0x12/0x14
> [ 7393.914334]  [<c1004eee>] dump_stack+0x16/0x18
> [ 7393.914339]  [<c103db51>] print_circular_bug_tail+0x6f/0x71
> [ 7393.914344]  [<c103e2e5>] check_prev_add+0x34/0x1fb
> [ 7393.914348]  [<c103e537>] check_prevs_add+0x8b/0xe8
> [ 7393.914354]  [<c103e7bf>] validate_chain+0x22b/0x354
> [ 7393.914362]  [<c103fe7a>] __lock_acquire+0x1a0/0x74a
> [ 7393.914365]  [<c1040895>] lock_acquire+0x6b/0x8a
> [ 7393.914369]  [<c1232020>] __mutex_lock_slowpath+0x75/0x299
> [ 7393.914373]  [<c1231f9f>] mutex_lock+0x8/0xa
> [ 7393.914377]  [<c10a7039>] print_warning+0x8c/0x15d
> [ 7393.914383]  [<c10a77df>] dquot_alloc_space+0x184/0x189
> [ 7393.914387]  [<c10b90c7>] ext3_new_blocks+0x44b/0x5a2
> [ 7393.914391]  [<c10bb6ac>] ext3_alloc_blocks+0x40/0xdf
> [ 7393.914397]  [<c10bb79b>] ext3_alloc_branch+0x50/0x21b
> [ 7393.914403]  [<c10bbc79>] ext3_get_blocks_handle+0x1b8/0x367
> [ 7393.914407]  [<c10bbea0>] ext3_get_block+0x78/0xe3
> [ 7393.914411]  [<c1097beb>] __block_prepare_write+0x168/0x415
> [ 7393.914415]  [<c10986f7>] block_prepare_write+0x28/0x3b
> [ 7393.914420]  [<c10bc34c>] ext3_prepare_write+0xe3/0x17e
> [ 7393.914425]  [<c10579c5>] generic_file_buffered_write+0x1cb/0x62b
> [ 7393.914429]  [<c105805f>] __generic_file_aio_write_nolock+0x23a/0x53d
> [ 7393.914433]  [<c105846b>] generic_file_aio_write+0x58/0xc4
> [ 7393.914440]  [<c10b9f1f>] ext3_file_write+0x2d/0xba
> [ 7393.914445]  [<c1076303>] do_sync_write+0xc7/0x116
> [ 7393.914448]  [<c10764aa>] vfs_write+0x158/0x15d
> [ 7393.914452]  [<c1076550>] sys_write+0x3d/0x64
> [ 7393.914455]  [<c1003ffe>] syscall_call+0x7/0xb
> [ 7393.914460]  =======================
> 

I seems that patch hasn't made it into .23... I'll stick it in the
lockdep tree aimed at .24.

