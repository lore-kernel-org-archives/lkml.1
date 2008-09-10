Return-Path: <linux-kernel-owner+w=401wt.eu-S1754011AbYIJMdT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754011AbYIJMdT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 08:33:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752101AbYIJMdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 08:33:10 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60283 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751744AbYIJMdI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 08:33:08 -0400
Date: Wed, 10 Sep 2008 14:32:46 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86: some lock annotations for user copy paths
Message-ID: <20080910123246.GA2564@elte.hu>
References: <20080910113717.GB16811@wotan.suse.de> <1221046892.30429.85.camel@twins.programming.kicks-ass.net> <20080910114755.GA9696@elte.hu> <20080910121217.GA16013@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080910121217.GA16013@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


here's another one found on another box:

[  574.380319] =======================================================
[  574.380381] [ INFO: possible circular locking dependency detected ]
[  574.380413] 2.6.27-rc6-tip #30918
[  574.380440] -------------------------------------------------------
[  574.380472] sshd/8255 is trying to acquire lock:
[  574.380500]  (&sb->s_type->i_mutex_key#9){--..}, at: [<ffffffff802d5aab>] do_truncate+0x59/0x83
[  574.380628] 
[  574.380629] but task is already holding lock:
[  574.380679]  (&mm->mmap_sem){----}, at: [<ffffffff80249775>] sys32_mmap2+0x64/0xa7
[  574.380781] 
[  574.380781] which lock already depends on the new lock.
[  574.380782] 
[  574.380857] 
[  574.380857] the existing dependency chain (in reverse order) is:
[  574.380910] 
[  574.380911] -> #1 (&mm->mmap_sem){----}:
[  574.381025]        [<ffffffff80281979>] __lock_acquire+0x9b4/0xb3b
[  574.381081]        [<ffffffff80282499>] lock_acquire+0x8d/0xba
[  574.381219]        [<ffffffff802a94ff>] iov_iter_fault_in_readable+0x84/0x169
[  574.381359]        [<ffffffff802aae18>] generic_file_buffered_write+0x119/0x5ad
[  574.381584]        [<ffffffff802ab6cb>] __generic_file_aio_write_nolock+0x260/0x294
[  574.381809]        [<ffffffff802ab768>] generic_file_aio_write+0x69/0xc5
[  574.381948]        [<ffffffff802d68e2>] do_sync_write+0xeb/0x132
[  574.382086]        [<ffffffff802d6f28>] vfs_write+0xa7/0xe1
[  574.382222]        [<ffffffff802d701c>] sys_write+0x47/0x6d
[  574.382359]        [<ffffffff802481b7>] cstar_dispatch+0x7/0x4b
[  574.382496]        [<ffffffffffffffff>] 0xffffffffffffffff
[  574.382635] 
[  574.382636] -> #0 (&sb->s_type->i_mutex_key#9){--..}:
[  574.382942]        [<ffffffff8028181b>] __lock_acquire+0x856/0xb3b
[  574.383080]        [<ffffffff80282499>] lock_acquire+0x8d/0xba
[  574.383218]        [<ffffffff80b77600>] __mutex_lock_common+0xe4/0x333
[  574.383358]        [<ffffffff80b778e9>] mutex_lock_nested+0x30/0x35
[  574.383495]        [<ffffffff802d5aab>] do_truncate+0x59/0x83
[  574.383633]        [<ffffffff802cbbf7>] shmem_file_setup+0xcf/0x106
[  574.383772]        [<ffffffff802cbc50>] shmem_zero_setup+0x22/0x5e
[  574.383910]        [<ffffffff802bfc92>] mmap_region+0x250/0x438
[  574.384031]        [<ffffffff802c047f>] do_mmap_pgoff+0x2fe/0x363
[  574.384031]        [<ffffffff8024978e>] sys32_mmap2+0x7d/0xa7
[  574.384031]        [<ffffffff802481b7>] cstar_dispatch+0x7/0x4b
[  574.384031]        [<ffffffffffffffff>] 0xffffffffffffffff
[  574.384031] 
[  574.384031] other info that might help us debug this:
[  574.384031] 
[  574.384031] 1 lock held by sshd/8255:
[  574.384031]  #0:  (&mm->mmap_sem){----}, at: [<ffffffff80249775>] sys32_mmap2+0x64/0xa7
[  574.384031] 
[  574.384031] stack backtrace:
[  574.384031] Pid: 8255, comm: sshd Not tainted 2.6.27-rc6-tip #30918
[  574.384031] Call Trace:
[  574.384031]  [<ffffffff80280fba>] print_circular_bug_tail+0x71/0x7c
[  574.384031]  [<ffffffff8028181b>] __lock_acquire+0x856/0xb3b
[  574.384031]  [<ffffffff80282499>] lock_acquire+0x8d/0xba
[  574.384031]  [<ffffffff802d5aab>] ? do_truncate+0x59/0x83
[  574.384031]  [<ffffffff80b77600>] __mutex_lock_common+0xe4/0x333
[  574.384031]  [<ffffffff802d5aab>] ? do_truncate+0x59/0x83
[  574.384031]  [<ffffffff802d5aab>] ? do_truncate+0x59/0x83
[  574.384031]  [<ffffffff804e475f>] ? _raw_spin_unlock+0x8e/0x93
[  574.384031]  [<ffffffff80b778e9>] mutex_lock_nested+0x30/0x35
[  574.384031]  [<ffffffff802d5aab>] do_truncate+0x59/0x83
[  574.384031]  [<ffffffff802d7c1f>] ? init_file+0x99/0xbb
[  574.384031]  [<ffffffff802d7deb>] ? alloc_file+0x3e/0x4e
[  574.384031]  [<ffffffff802cbbf7>] shmem_file_setup+0xcf/0x106
[  574.384031]  [<ffffffff802cbc50>] shmem_zero_setup+0x22/0x5e
[  574.384031]  [<ffffffff802bfc92>] mmap_region+0x250/0x438
[  574.384031]  [<ffffffff802282aa>] ? arch_get_unmapped_area_topdown+0x192/0x294
[  574.384031]  [<ffffffff802c047f>] do_mmap_pgoff+0x2fe/0x363
[  574.384031]  [<ffffffff8024978e>] sys32_mmap2+0x7d/0xa7
[  574.384031]  [<ffffffff802481b7>] cstar_dispatch+0x7/0x4b

	Ingo
