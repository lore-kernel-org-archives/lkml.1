Return-Path: <linux-kernel-owner+w=401wt.eu-S1761438AbYCFTEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761438AbYCFTEp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 14:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755932AbYCFTEh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 14:04:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:59666 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752981AbYCFTEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 14:04:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.25,457,1199692800"; 
   d="scan'208";a="261172787"
Date: Thu, 6 Mar 2008 11:03:31 -0800
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, hpa@zytor.com,
       tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v4
Message-ID: <20080306190331.GG28006@linux-os.sc.intel.com>
References: <20080304234003.603501000@linux-os.sc.intel.com> <20080306121714.GB19613@elte.hu> <20080306151832.GA10092@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080306151832.GA10092@elte.hu>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 06, 2008 at 04:18:32PM +0100, Ingo Molnar wrote:
> 
> > > Split the FPU save area from the task struct. This allows easy 
> > > migration of FPU context, and it's generally cleaner. It also allows 
> > > the following two optimizations:
> 
> the atomicity bug is still there:
> 
> [ 1230.409772] BUG: sleeping function called from invalid context at mm/slab.c:>
> [ 1230.409772] in_atomic():0, irqs_disabled():1
> [ 1230.409772] Pid: 1187, comm: awk Not tainted 2.6.25-rc4-sched-devel.git-x86->[ 1230.409772]
> [ 1230.409772] Call Trace:
> [ 1230.409772]  [<ffffffff8022255b>] ? do_page_fault+0x3eb/0xa80
> [ 1230.409772]  [<ffffffff8022c68e>] __might_sleep+0xce/0xf0
> [ 1230.409772]  [<ffffffff8028c299>] kmem_cache_alloc+0xf9/0x120
> [ 1230.409772]  [<ffffffff80214338>] init_fpu+0x98/0x100
> [ 1230.409772]  [<ffffffff8020ec10>] math_state_restore+0x20/0x80
> [ 1230.409772]  [<ffffffff809b8cc9>] error_exit+0x0/0x60
> 
> config and bootlog attached.

My bad. I overlooked the fact that exception handling by the processor
automatically disables interrupts and my tested configs didn't have
CONFIG_DEBUG_SPINLOCK_SLEEP set. My previous fix took care of only 32bit kernels
as they were disabling interrupts explicitly for PREEMPT kernels.

I will post a -v5 fixing this.

> # CONFIG_DEBUG_KERNEL is not set

BTW, In the .config you sent, you don't have CONFIG_DEBUG_SPINLOCK_SLEEP or
CONFIG_DEBUG_KERNEL set. How come you are seeing those backtraces?

thanks,
suresh
