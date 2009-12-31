Return-Path: <linux-kernel-owner+w=401wt.eu-S1753107AbZLaTCZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbZLaTCZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Dec 2009 14:02:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753074AbZLaTCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Dec 2009 14:02:24 -0500
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:51490 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbZLaTCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Dec 2009 14:02:23 -0500
Date: Fri, 1 Jan 2010 00:32:17 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC Patch 2/2][Bugfix][x86][hw-breakpoint] Fix return-code to
	notifier chain in hw_breakpoint_handler
Message-ID: <20091231190217.GC3676@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <20091226175533.149765731@linux.vnet.ibm.com> <20091226182833.GC9494@in.ibm.com> <20091231003808.GC23808@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091231003808.GC23808@nowhere>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 31, 2009 at 01:38:09AM +0100, Frederic Weisbecker wrote:
> On Sat, Dec 26, 2009 at 11:58:33PM +0530, K.Prasad wrote:
> > The hw-breakpoint handler will return NOTIFY_DONE for user-space breakpoints
> > to generate SIGTRAP signal (and not for kernel-space addresses). 
> > 
> > Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> > ---
> >  arch/x86/kernel/hw_breakpoint.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > Index: linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> > ===================================================================
> > --- linux-2.6-tip.orig/arch/x86/kernel/hw_breakpoint.c
> > +++ linux-2.6-tip/arch/x86/kernel/hw_breakpoint.c
> > @@ -502,8 +502,6 @@ static int __kprobes hw_breakpoint_handl
> >  		rcu_read_lock();
> >  
> >  		bp = per_cpu(bp_per_reg[i], cpu);
> > -		if (bp)
> > -			rc = NOTIFY_DONE;
> >  		/*
> >  		 * Reset the 'i'th TRAP bit in dr6 to denote completion of
> >  		 * exception handling
> > @@ -517,6 +515,13 @@ static int __kprobes hw_breakpoint_handl
> >  			rcu_read_unlock();
> >  			break;
> >  		}
> > +		/*
> > +		 * Further processing in do_debug() is needed for a) user-space
> > +		 * breakpoints (to generate signals) and b) when the system has
> > +		 * taken exception due to multiple causes
> > +		 */
> > +		if (bp->attr.bp_addr < TASK_SIZE)
> > +			rc = NOTIFY_DONE;
> >  
> >  		perf_bp_event(bp, args->regs);
> >  
> > 
> 
> 
> Oh and now that I see this patch, the previous one indeed makes sense
> with this check:
> 
> if (dr6 & (~DR_TRAP_BITS))
> 	rc = NOTIFY_DONE;
> 
> That said, it means thread.debugreg6 won't get the reserved bits anymore.
> I see some use of them from kvm (it restores the reserved bits on guest<->host
> switch). Not sure if this inconsistency could affect kvm...
> 

Can you point me to the relevant code?
Anyway will copy this to Jan Kiszka <jan.kiszka@web.de> to hear what
this change means to KVM...on a similar note, will be happy to be
re-assured by Roland/Oleg about the patch's harmlessness to the
user-space (ptrace/utrace).

Hi Jan,
	Patch 20091226182725.GB9494@in.ibm.com introduces a change that

Patch 1/2: Clears the arch-reserved bits from debug status register.
This helps easy bitwise operations - such as the check for non-trap bits in
hw_breakpoint_handler. A check for the same using
"if (dr6 & (~DR_TRAP_BITS))" throws incorrect results due to the
presence of preset reserved bits.

Let us know if you foresee any harm from the said change to the
behaviour seen under KVM.

Thanks,
K.Prasad

