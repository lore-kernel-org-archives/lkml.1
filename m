Return-Path: <linux-kernel-owner+w=401wt.eu-S1759076AbYCCJOj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759076AbYCCJOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 04:14:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753277AbYCCJOb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 04:14:31 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:34810 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752663AbYCCJOa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 04:14:30 -0500
Date: Mon, 3 Mar 2008 10:14:16 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org, hch@infradead.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch 1/2] x86, fpu: split FPU state from task struct - v2
Message-ID: <20080303091416.GA18078@elte.hu>
References: <20080301005141.997705000@linux-os.sc.intel.com> <20080303085000.GB15943@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080303085000.GB15943@elte.hu>
User-Agent: Mutt/1.5.17 (2007-11-01)
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


* Ingo Molnar <mingo@elte.hu> wrote:

> > 2) allocate the right size for the actual cpu rather than 512 bytes 
> > always. Patches enabling xsave/xrstor support (coming shortly) will 
> > take advantage of this.
> 
> thanks, i've applied your two patches to x86.git#testing.

hm, qa immediately got problems with it:

[   20.054821] BUG: sleeping function called from invalid context at mm/slab.c:3055
[   20.057253] in_atomic():0, irqs_disabled():1
[   20.057253] no locks held by awk/1294.
[   20.057253] irq event stamp: 5745
[   20.057253] hardirqs last  enabled at (5745): [<ffffffff8079aaf0>] trace_hardirqs_on_thunk+0x35/0x3a
[   20.057253] hardirqs last disabled at (5744): [<ffffffff8079ab2a>] trace_hardirqs_off_thunk+0x35/0x37
[   20.057253] softirqs last  enabled at (0): [<ffffffff80237800>] copy_process+0x310/0x16b0
[   20.057253] softirqs last disabled at (0): [<0000000000000000>] 0x0
[   20.057253] Pid: 1294, comm: awk Not tainted 2.6.25-rc3 #2
[   20.057253] 
[   20.057253] Call Trace:
[   20.057253]  [<ffffffff8025bfb0>] ? print_irqtrace_events+0x110/0x120
[   20.057253]  [<ffffffff80230de5>] __might_sleep+0xe5/0x110
[   20.057253]  [<ffffffff802a9c53>] kmem_cache_alloc+0xe3/0x100
[   20.057253]  [<ffffffff80213f84>] init_fpu+0x94/0xf0
[   20.057253]  [<ffffffff8020e6d8>] math_state_restore+0x58/0x70
[   20.057253]  [<ffffffff8079bb39>] error_exit+0x0/0xb8
[   20.057253] 
[   35.722463] device: 'vcs1': device_add

that's a non-atomic alloc in an atomic (irqs off) section ...

	Ingo
