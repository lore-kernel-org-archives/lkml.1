Return-Path: <linux-kernel-owner+w=401wt.eu-S1762486AbZFLM77@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762486AbZFLM77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 08:59:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761443AbZFLM57
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 08:57:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:39453 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761557AbZFLM56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 08:57:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,209,1243839600"; 
   d="scan'208";a="153559658"
Date: Fri, 12 Jun 2009 20:57:41 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Nick Piggin <npiggin@suse.de>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>,
       Andi Kleen <andi@firstfloor.org>, "riel@redhat.com" <riel@redhat.com>,
       "chris.mason@oracle.com" <chris.mason@oracle.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 1/5] HWPOISON: define VM_FAULT_HWPOISON to 0 when
	feature is disabled
Message-ID: <20090612125741.GA6140@localhost>
References: <20090611142239.192891591@intel.com> <20090611144430.414445947@intel.com> <20090612112258.GA14123@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090612112258.GA14123@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On Fri, Jun 12, 2009 at 07:22:58PM +0800, Ingo Molnar wrote:
> 
> * Wu Fengguang <fengguang.wu@intel.com> wrote:
> 
> > So as to eliminate one #ifdef in the c source.
> > 
> > Proposed by Nick Piggin.
> > 
> > CC: Nick Piggin <npiggin@suse.de>
> > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > ---
> >  arch/x86/mm/fault.c |    3 +--
> >  include/linux/mm.h  |    7 ++++++-
> >  2 files changed, 7 insertions(+), 3 deletions(-)
> > 
> > --- sound-2.6.orig/arch/x86/mm/fault.c
> > +++ sound-2.6/arch/x86/mm/fault.c
> > @@ -819,14 +819,13 @@ do_sigbus(struct pt_regs *regs, unsigned
> >  	tsk->thread.error_code	= error_code;
> >  	tsk->thread.trap_no	= 14;
> >  
> > -#ifdef CONFIG_MEMORY_FAILURE
> >  	if (fault & VM_FAULT_HWPOISON) {
> >  		printk(KERN_ERR
> >  	"MCE: Killing %s:%d due to hardware memory corruption fault at %lx\n",
> >  			tsk->comm, tsk->pid, address);
> >  		code = BUS_MCEERR_AR;
> >  	}
> > -#endif
> 
> Btw., anything like this should happen in close cooperation with the 
> x86 tree, not as some pure MM feature. I dont see Cc:s and nothing 
> that indicates that realization. What's going on here?

Ah sorry for the ignorance!  Andi has a nice overview of the big
picture here: http://lkml.org/lkml/2009/6/3/371

In the above chunk, the process is trying to access the already
corrupted page and thus shall be killed, otherwise it will either
silently consume corrupted data, or will trigger another (deadly)
MCE event and bring down the whole machine.

VM_FAULT_HWPOISON is tagged by the hwpoison code to indicate that the
previously mapped page contains corrupted data, and is unrecoverable
because there are no valid on-disk copy that can be reloaded.

> It is not at all clear to me whether propagating hardware failures 
> this widely is desired from a general design POV. Most desktop 
> hardware wont give a damn about this (and if a hardware fault 
> happens you want to get as far from the crappy hardware as possible) 
> so i'm not sure how relevant it is and how well tested it will 
> become in practice.

Intel Nehalem-EX will have this feature, and is going to ship in
volume servers in the coming years. Given that the servers may
well be equipped with tons of memory, memory failures (especially
soft errors http://en.wikipedia.org/wiki/Soft_error) become
un-ignorable.

Sunspot Maximum is underway by 2011 and we must be prepared for it ;)

> I.e. really some wider discussion needs to happen on this.

OK.


Thanks,
Fengguang
