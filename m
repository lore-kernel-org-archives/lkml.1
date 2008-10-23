Return-Path: <linux-kernel-owner+w=401wt.eu-S1755313AbYJWM71@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755313AbYJWM71 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 08:59:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbYJWM7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 08:59:19 -0400
Received: from relay1.sgi.com ([192.48.171.29]:59146 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751850AbYJWM7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 08:59:18 -0400
Message-ID: <49007562.5060105@sgi.com>
Date: Thu, 23 Oct 2008 06:00:18 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Rusty Russell <rusty@rustcorp.com.au>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [bug] Re: [PATCH 00/35] cpumask: Replace cpumask_t with struct
 cpumask
References: <20081023020826.051012000@polaris-admin.engr.sgi.com> <20081023120322.GC25132@elte.hu> <20081023125529.GA18327@elte.hu>
In-Reply-To: <20081023125529.GA18327@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks!  I'll check this out immediately...

Ingo Molnar wrote:
> ok, the new cpumask code blew up in -tip testing, with various sorts of 
> slab corruptions during scheduler init:
> 
> [    0.544012]    groups: 0-1
> [    0.546689] =============================================================================
> [    0.548000] BUG kmalloc-8: Wrong object count. Counter is 15 but counted were 50
> [    0.548000] -----------------------------------------------------------------------------
> [    0.548000] 
> [    0.548000] INFO: Slab 0xffffe200019d7ae0 objects=51 used=15 fp=0xffff88003f9cc4b0 flags=0x200000000000c3
> [    0.548000] Pid: 1, comm: swapper Not tainted 2.6.27-tip-07104-g5cf7b67-dirty #45066
> [    0.548000] Call Trace:
> [    0.548000]  [<ffffffff802cbcf0>] slab_err+0xa0/0xb0
> [    0.548000]  [<ffffffff8026df2d>] ? trace_hardirqs_on+0xd/0x10
> [    0.548000]  [<ffffffff8026deca>] ? trace_hardirqs_on_caller+0x15a/0x1b0
> [    0.548000]  [<ffffffff8023d102>] ? cpu_attach_domain+0x172/0x6b0
> [    0.548000]  [<ffffffff802cbf4d>] ? check_bytes_and_report+0x3d/0xe0
> [    0.548000]  [<ffffffff802cd927>] on_freelist+0x197/0x240
> [    0.548000]  [<ffffffff802ce926>] __slab_free+0x1a6/0x310
> [    0.548000]  [<ffffffff80415009>] ? free_cpumask_var+0x9/0x10
> [    0.548000]  [<ffffffff802ceb47>] kfree+0xb7/0x140
> [    0.548000]  [<ffffffff80415009>] ? free_cpumask_var+0x9/0x10
> [    0.548000]  [<ffffffff80415009>] free_cpumask_var+0x9/0x10
> [    0.548000]  [<ffffffff8023dadc>] __build_sched_domains+0x49c/0xd30
> [    0.548000]  [<ffffffff8026df2d>] ? trace_hardirqs_on+0xd/0x10
> [    0.548000]  [<ffffffff816698fa>] sched_init_smp+0xba/0x2b0
> [    0.548000]  [<ffffffff8026deca>] ? trace_hardirqs_on_caller+0x15a/0x1b0
> [    0.548000]  [<ffffffff802cbf4d>] ? check_bytes_and_report+0x3d/0xe0
> [    0.548000]  [<ffffffff802cdc08>] ? check_object+0x238/0x270
> [    0.548000]  [<ffffffff802cc044>] ? init_object+0x54/0x90
> [    0.548000]  [<ffffffff8026df2d>] ? trace_hardirqs_on+0xd/0x10
> [    0.548000]  [<ffffffff8026deca>] ? trace_hardirqs_on_caller+0x15a/0x1b0
> [    0.548000]  [<ffffffff8026df2d>] ? trace_hardirqs_on+0xd/0x10
> [    0.548000]  [<ffffffff816622e4>] ? check_nmi_watchdog+0x204/0x260
> [    0.548000]  [<ffffffff816622e4>] ? check_nmi_watchdog+0x204/0x260
> [    0.548000]  [<ffffffff8165fad6>] ? native_smp_cpus_done+0x1a6/0x2b0
> [    0.548000]  [<ffffffff81654f86>] kernel_init+0x176/0x240
> [    0.548000]  [<ffffffff8020c9f9>] child_rip+0xa/0x11
> [    0.548000]  [<ffffffff8020bf14>] ? restore_args+0x0/0x30
> [    0.548000]  [<ffffffff81654e10>] ? kernel_init+0x0/0x240
> [    0.548000]  [<ffffffff8020c9ef>] ? child_rip+0x0/0x11
> [    0.548000] FIX kmalloc-8: Object count adjusted.
> [    0.548000] =============================================================================
> 
> i suspect it's due to:
> 
> 01b8bd9: sched: cpumask: get rid of boutique sched.c allocations, use cpumask_va
> 
> note, CONFIG_MAXSMP is set in the .config, so this is with the dynamic 
> cpumask_t.
> 
> 	Ingo
> 

