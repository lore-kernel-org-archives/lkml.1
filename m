Return-Path: <linux-kernel-owner+w=401wt.eu-S1756095Ab0A1JTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756095Ab0A1JTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755771Ab0A1JTt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:19:49 -0500
Received: from smtp-out.google.com ([216.239.44.51]:9408 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755511Ab0A1JTs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:19:48 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:date:message-id:subject:from:to:cc:
	content-type:x-system-of-record;
	b=ZlIo+kDgDRRF1fVtF2iMUHVCkOap9svu/FdFNoH3lmaq5PC5Ta1BDKEpaKKR2nHzU
	9nbrat92YQf9KTWAOP8HA==
MIME-Version: 1.0
Date: Thu, 28 Jan 2010 10:19:45 +0100
Message-ID: <bd4cb8901001280119j20a5404ds16079b5238b5271e@mail.gmail.com>
Subject: [BUG] perf_event: circular lock dependency
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Intel Core, one of my test programs generate this kind of
warning when it unmaps the sampling buffer after it has closed
the events fds.


[ 1729.440898] =======================================================
[ 1729.440913] [ INFO: possible circular locking dependency detected ]
[ 1729.440922] 2.6.33-rc3-tip+ #281
[ 1729.440927] -------------------------------------------------------
[ 1729.440936] task_smpl/5498 is trying to acquire lock:
[ 1729.440943]  (&ctx->mutex){+.+...}, at: [<ffffffff810c2ebd>]
perf_event_release_kernel+0x2d/0xe0
[ 1729.440972]
[ 1729.440973] but task is already holding lock:
[ 1729.440997]  (&mm->mmap_sem){++++++}, at: [<ffffffff810ebab2>]
sys_munmap+0x42/0x80
[ 1729.441030]
[ 1729.441030] which lock already depends on the new lock.
[ 1729.441031]
[ 1729.441066]
[ 1729.441066] the existing dependency chain (in reverse order) is:
[ 1729.441092]
[ 1729.441093] -> #1 (&mm->mmap_sem){++++++}:
[ 1729.441123]        [<ffffffff81077f97>] validate_chain+0xc17/0x1360
[ 1729.441151]        [<ffffffff81078a53>] __lock_acquire+0x373/0xb30
[ 1729.441170]        [<ffffffff810792ac>] lock_acquire+0x9c/0x100
[ 1729.441189]        [<ffffffff810e74a4>] might_fault+0x84/0xb0
[ 1729.441207]        [<ffffffff810c3605>] perf_read+0x135/0x2d0
[ 1729.441225]        [<ffffffff8110c604>] vfs_read+0xc4/0x180
[ 1729.441245]        [<ffffffff8110ca10>] sys_read+0x50/0x90
[ 1729.441263]        [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[ 1729.441284]
[ 1729.441284] -> #0 (&ctx->mutex){+.+...}:
[ 1729.441313]        [<ffffffff810786cd>] validate_chain+0x134d/0x1360
[ 1729.441332]        [<ffffffff81078a53>] __lock_acquire+0x373/0xb30
[ 1729.441351]        [<ffffffff810792ac>] lock_acquire+0x9c/0x100
[ 1729.441369]        [<ffffffff81442e59>] mutex_lock_nested+0x69/0x340
[ 1729.441389]        [<ffffffff810c2ebd>] perf_event_release_kernel+0x2d/0xe0
[ 1729.441409]        [<ffffffff810c2f8b>] perf_release+0x1b/0x20
[ 1729.441426]        [<ffffffff8110d051>] __fput+0x101/0x230
[ 1729.441444]        [<ffffffff8110d457>] fput+0x17/0x20
[ 1729.441462]        [<ffffffff810e98d1>] remove_vma+0x51/0x90
[ 1729.441480]        [<ffffffff810ea708>] do_munmap+0x2e8/0x340
[ 1729.441498]        [<ffffffff810ebac0>] sys_munmap+0x50/0x80
[ 1729.441516]        [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
[ 1729.441535]
[ 1729.441536] other info that might help us debug this:
[ 1729.441537]
[ 1729.441539] 1 lock held by task_smpl/5498:
[ 1729.441539]  #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff810ebab2>]
sys_munmap+0x42/0x80
[ 1729.441539]
[ 1729.441539] stack backtrace:
[ 1729.441539] Pid: 5498, comm: task_smpl Not tainted 2.6.33-rc3-tip+ #281
[ 1729.441539] Call Trace:
[ 1729.441539]  [<ffffffff81076b1a>] print_circular_bug+0xea/0xf0
[ 1729.441539]  [<ffffffff810786cd>] validate_chain+0x134d/0x1360
[ 1729.441539]  [<ffffffff81078a53>] __lock_acquire+0x373/0xb30
[ 1729.441539]  [<ffffffff81078a53>] ? __lock_acquire+0x373/0xb30
[ 1729.441539]  [<ffffffff810792ac>] lock_acquire+0x9c/0x100
[ 1729.441539]  [<ffffffff810c2ebd>] ? perf_event_release_kernel+0x2d/0xe0
[ 1729.441539]  [<ffffffff81442e59>] mutex_lock_nested+0x69/0x340
[ 1729.441539]  [<ffffffff810c2ebd>] ? perf_event_release_kernel+0x2d/0xe0
[ 1729.441539]  [<ffffffff810678ca>] ? sched_clock_cpu+0xba/0xf0
[ 1729.441539]  [<ffffffff810c2ebd>] ? perf_event_release_kernel+0x2d/0xe0
[ 1729.441539]  [<ffffffff81074f6f>] ? mark_held_locks+0x6f/0x90
[ 1729.441539]  [<ffffffff810c2ebd>] perf_event_release_kernel+0x2d/0xe0
[ 1729.441539]  [<ffffffff810c2f8b>] perf_release+0x1b/0x20
[ 1729.441539]  [<ffffffff8110d051>] __fput+0x101/0x230
[ 1729.441539]  [<ffffffff8110d457>] fput+0x17/0x20
[ 1729.441539]  [<ffffffff810e98d1>] remove_vma+0x51/0x90
[ 1729.441539]  [<ffffffff810ea708>] do_munmap+0x2e8/0x340
[ 1729.441539]  [<ffffffff810ebac0>] sys_munmap+0x50/0x80
[ 1729.441539]  [<ffffffff81002ceb>] system_call_fastpath+0x16/0x1b
