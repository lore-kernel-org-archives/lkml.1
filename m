Return-Path: <linux-kernel-owner+w=401wt.eu-S933502AbXEVNBe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933502AbXEVNBe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 09:01:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757270AbXEVNB1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 09:01:27 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:59375 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757491AbXEVNB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 09:01:26 -0400
Date: Tue, 22 May 2007 14:01:03 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.wat.veritas.com
To: Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au>
cc: Ingo Molnar <mingo@elte.hu>, Christoph Lameter <clameter@sgi.com>,
       Oliver Xymoron <oxymoron@waste.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PROBLEM] 2.6.22-rc2 panics on x86-64 with slub
In-Reply-To: <559665.2852.qm@web52608.mail.re2.yahoo.com>
Message-ID: <Pine.LNX.4.64.0705221358360.4904@blonde.wat.veritas.com>
References: <559665.2852.qm@web52608.mail.re2.yahoo.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Brightmail-Verdict: 
X-Brightmail-Tracker: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 May 2007, Srihari Vijayaraghavan wrote:
> --- Ingo Molnar <mingo@elte.hu> wrote:
> > * Srihari Vijayaraghavan <sriharivijayaraghavan@yahoo.com.au> wrote:
> > > Yup, with CONFIG_SMP=n, I'm unable to reproduce the problem. It's 
> > > quite stable actually (having completed a dozen kernel compile 
> > > sessions so far).
> 
> [...]
> 
> > could you enable CONFIG_PROVE_LOCKING - does it spit out any warning 
> > into the syslog?
> 
> Compiled slub with SMP & CONFIG_PROVE_LOCKING. No luck. It still hangs solid
> after the second spinlock lockup call trace.
> 
> Here's the relevant sections of the kernel logs:
> 
> ...
> Freeing unused kernel memory: 228k freed
> BUG: spinlock bad magic on CPU#1, init/1
>  lock: ffff81011f5f1100, .magic: ffff8101, .owner: <none>/-1, .owner_cpu: -1
> 
> Call Trace:
>  [<ffffffff802f326a>] _raw_spin_lock+0x22/0xf6
>  [<ffffffff8026b2d5>] vma_adjust+0x21c/0x446
>  [<ffffffff8026b2d5>] vma_adjust+0x21c/0x446
>  [<ffffffff8026b9d4>] vma_merge+0x10c/0x195
>  [<ffffffff8026c757>] do_mmap_pgoff+0x3f5/0x794
>  [<ffffffff803fff0c>] _spin_unlock_irq+0x24/0x27
>  [<ffffffff8020f414>] sys_mmap+0xe5/0x110
>  [<ffffffff80209dde>] system_call+0x7e/0x83
> ...
> PM: Adding info for No Bus:vcsa1
> BUG: spinlock lockup on CPU#1, hostname/369, ffff81011f5f1fc0
> 
> Call Trace:
>  [<ffffffff802f3317>] _raw_spin_lock+0xcf/0xf6
>  [<ffffffff8026ec9c>] anon_vma_unlink+0x1c/0x68
>  [<ffffffff8026ec9c>] anon_vma_unlink+0x1c/0x68
>  [<ffffffff80269aa0>] free_pgtables+0x69/0xc4
>  [<ffffffff8026ad0e>] exit_mmap+0x91/0xeb
>  [<ffffffff80228cea>] mmput+0x2c/0x9f
>  [<ffffffff8022df72>] do_exit+0x22e/0x82e
>  [<ffffffff8022e5f4>] sys_exit_group+0x0/0xe
>  [<ffffffff80209dde>] system_call+0x7e/0x83
> 
> 
> Surprisingly, with CONFIG_SMP=n, CONFIG_PROVE_LOCKING produces this with slub
> (then hangs solid):
> 
> Freeing unused kernel memory: 188k freed
> BUG: spinlock lockup on CPU#0, init/1, ffff81011e9d3160
> 
> Call Trace:
>  [<ffffffff802eca20>] _raw_spin_lock+0xca/0xe8
>  [<ffffffff80265d6d>] vma_adjust+0x218/0x442
>  [<ffffffff80265d6d>] vma_adjust+0x218/0x442
>  [<ffffffff8026646b>] vma_merge+0x10c/0x195
>  [<ffffffff802671d5>] do_mmap_pgoff+0x3f5/0x790
>  [<ffffffff803f6e84>] _spin_unlock_irq+0x24/0x27
>  [<ffffffff8020ead0>] sys_mmap+0xe5/0x110
>  [<ffffffff80209cce>] system_call+0x7e/0x83
> 
> To recap:
> 1. No problems with slub on CONFIG_SMP=n & CONFIG_PROVE_LOCKING=n
> 2. Problem with slub on CONFIG_SMP=n & CONFIG_PROVE_LOCKING=y (perhaps a. some
> locking issue when slub is activated or b. something is wrong with 'prove
> locking' mechanism when slub is activated or c. something else I don't see) 
> 3. Problem with slub on CONFIG_SMP=y (even without CONFIG_PROVE_LOCKING=y)

You've made no mention of trying the patch I sent yesterday, or better,
the patch Christoph replied with to replace it.  Please clarify whether
you're getting the above after applying one of those patches - thanks.

Hugh
