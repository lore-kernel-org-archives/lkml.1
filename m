Return-Path: <linux-kernel-owner+w=401wt.eu-S1757422AbZBWXRS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422AbZBWXRS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Feb 2009 18:17:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754884AbZBWXRH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Feb 2009 18:17:07 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53100 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754856AbZBWXRE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Feb 2009 18:17:04 -0500
Date: Mon, 23 Feb 2009 15:13:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tilman Schmidt <t.schmidt@phoenixsoftware.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Jeremy Fitzhardinge <jeremy@xensource.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [2.6.28.7] BUG: using smp_processor_id() in preemptible
 [00000000] code: pageattr-test/207
Message-Id: <20090223151331.033e0bf5.akpm@linux-foundation.org>
In-Reply-To: <49A2ECF5.80104@phoenixsoftware.de>
References: <49A2ECF5.80104@phoenixsoftware.de>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Feb 2009 19:37:41 +0100
Tilman Schmidt <t.schmidt@phoenixsoftware.de> wrote:

> Booting the most recent stable kernel 2.6.28.7 on my workhorse machine
> (Pentium D, openSUSE 10.3 32 bit userspace) produces rather a lot of
> the following BUG messages:
> 
> <3>BUG: using smp_processor_id() in preemptible [00000000] code: pageattr-test/207
> <4>caller is paravirt_get_lazy_mode+0xe/0x1b
> <4>Pid: 207, comm: pageattr-test Not tainted 2.6.28.7-testing #1
> <4>Call Trace:
> <4> [<c0204760>] debug_smp_processor_id+0xac/0xc0
> <4> [<c011ad90>] paravirt_get_lazy_mode+0xe/0x1b
> <4> [<c011c925>] arch_flush_lazy_mmu_mode+0x8/0x19
> <4> [<c011d07c>] change_page_attr_set_clr+0x283/0x28e
> <4> [<c011d152>] change_page_attr_set+0xf/0x11
> <4> [<c011d347>] do_pageattr_test+0x1f3/0x3e3
> <4> [<c01247f1>] ? finish_task_switch+0xa0/0xa8
> <4> [<c032f799>] ? schedule+0x462/0x472
> <4> [<c0331353>] ? _spin_unlock_irqrestore+0x40/0x74
> <4> [<c011d154>] ? do_pageattr_test+0x0/0x3e3
> <4> [<c0139f1d>] kthread+0x3b/0x62 
> <4> [<c0139ee2>] ? kthread+0x0/0x62
> <4> [<c0104a43>] kernel_thread_helper+0x7/0x10
> 
> They occur regularly in bursts of ten, separated by 30 second break.
> The previous kernel:
> 
> ts@xenon:~> uname -a
> Linux xenon 2.6.28.6-testing #1 SMP PREEMPT Wed Feb 18 21:05:30 CET 2009 i686 i686 i386 GNU/Linux
> 
> with identical config and userspace (double-checked this time ;-)
> runs quite BUG-free.
> 

A 2.6.28.6 -> 2.6.28.7 regressionlet.

This, I bet:

commit 2cf155b300c4839a7238b825c7c5f417e9d7cc68
Author: Jeremy Fitzhardinge <jeremy@goop.org>
Date:   Wed Feb 11 09:32:19 2009 -0800

    x86/cpa: make sure cpa is safe to call in lazy mmu mode
    
    commit 4f06b0436b2ddbd3b67b10e77098a6862787b3eb upstream.
    
    Impact: fix race leading to crash under KVM and Xen
    
    The CPA code may be called while we're in lazy mmu update mode - for
    example, when using DEBUG_PAGE_ALLOC and doing a slab allocation
    in an interrupt handler which interrupted a lazy mmu update.  In this
    case, the in-memory pagetable state may be out of date due to pending
    queued updates.  We need to flush any pending updates before inspecting
    the page table.  Similarly, we must explicitly flush any modifications
    CPA may have made (which comes down to flushing queued operations when
    flushing the TLB).
