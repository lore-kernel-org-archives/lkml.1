Return-Path: <linux-kernel-owner+w=401wt.eu-S1754864AbYFCN1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbYFCN1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 09:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751311AbYFCN1A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 09:27:00 -0400
Received: from smtp.cs.aau.dk ([130.225.194.6]:54008 "EHLO smtp.cs.aau.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751999AbYFCN07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 09:26:59 -0400
Subject: Re: CONFIG_PREEMPT causes corruption of application's FPU stack
From: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: j.mell@t-online.de, Steven Rostedt <rostedt@goodmis.org>,
       linux-kernel@vger.kernel.org, ak@suse.de, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de, arjan@linux.intel.com, lguest <lguest@ozlabs.org>
In-Reply-To: <20080602213136.GA25114@linux-os.sc.intel.com>
References: <200806011101.06491.j.mell@t-online.de>
	 <1212340262.5802.8.camel@odie.local>
	 <20080602213136.GA25114@linux-os.sc.intel.com>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Jun 2008 15:23:30 +0200
Message-Id: <1212499410.2955.2.camel@odie.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC ﻿lguest <lguest@ozlabs.org>]
man, 02 06 2008 kl. 14:31 -0700, skrev Suresh Siddha: 
> On Sun, Jun 01, 2008 at 07:11:02PM +0200, Simon Holm Thøgersen wrote:
> > søn, 01 06 2008 kl. 11:01 +0200, skrev j.mell@t-online.de:
> > [...]
> > > 
> > > 3. If I revert the patch
> > >  
> > > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=acc207616a91a413a50fdd8847a747c4a7324167
> > > 
> > > in 2.6.20, Einstein does not crash anymore (program was run for more than 
> > > 30 hours while system was in normal use with programming, multi-media 
> > > etc.). Unfortunately git refuses to revert this patch in 2.6.26-rc4.
> > [...]
> > 
> > I don't think the bisected commit is responsible for anything, but
> > triggering a bug elsewhere with your workload. I've been chasing the
> > same problem I think, but with other symptoms.
> 
> Simon, There seems to be multiple issues here. fpu corruption seems
> to be a different problem compared to the issue you have encountered.
> 
> > 
> > I'm triggering the following by running an lguest guest, but I guess the
> > workload just need to have the right scheduler intensity to trigger the
> > bug.
> > 
> > BUG: sleeping function called from invalid context at mm/slab.c:3052
> > in_atomic():1, irqs_disabled():0
> > Pid: 4771, comm: lguest Not tainted
> > 2.6.26-rc4-debug-only-preemptible-00103-g1beee8d #3
> >  [<c01146ee>] __might_sleep+0xe4/0xeb
> >  [<c01605d9>] kmem_cache_alloc+0x22/0xb4
> >  [<c0108479>] init_fpu+0xb0/0x14d
> >  [<c0104768>] math_state_restore+0x26/0x5d
> >  [<c01045ab>] device_not_available+0x43/0x48
> >  [<c011007b>] ? handle_vm86_fault+0x213/0x6b8
> >  [<c01029ad>] ? __switch_to+0x23/0x113
> >  [<c02d6c9f>] schedule+0x221/0x2a4
> 
> Simon, Can you please try the appended patch and see if it fixes this
> issue? Thanks.
> ---
> 
> [patch] x86: fix blocking call (math_state_restore()) condition in __switch_to
> 
> Add tsk_used_math() checks to prevent calling math_state_restore()
> which can sleep in the case of !tsk_used_math(). This prevents
> making a blocking call in __switch_to().
> 
> Apparently "fpu_counter > 5" check is not enough, as in some signal handling
> and fork/exec scenarios, fpu_counter > 5 and !tsk_used_math() is possible.
> 
> Signed-off-by: Suresh Siddha <suresh.b.siddha@intel.com>
> ---
Hi Suresh,

and thanks for looking into this. The patch did not fix the issue, but
I'm wondering if it is lguest calling math_state_restore in
drivers/lguest/x86/core.c that could be the problem?

Regardless of whether that is the issue, I think you (and everybody
else) will be able to reproduce the issue by running lguest on a 32-bit
system with CONFIG_PREEMPT=y and CONFIG_DEBUG_SPINLOCKS_SLEEP=y (I'm
also using CONFIG_DEBUG_PREEMPT=y but I don't think that matter). If you
download http://xm-test.xensource.com/ramdisks/initrd-1.1-i386.img and
run

Documentation/lguest/lguest 64 vmlinux --block=initrd-1.1-i386.img

it will very likely trigger the backtraces I'm getting. Has anyone on
the lguest list tried running with CONFIG_PREEMPT?


Simon

