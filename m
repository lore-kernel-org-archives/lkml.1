Return-Path: <linux-kernel-owner+w=401wt.eu-S1762695AbXEWQOP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762695AbXEWQOP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:14:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757389AbXEWQOB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:14:01 -0400
Received: from gateway-1237.mvista.com ([63.81.120.158]:33781 "EHLO
	gateway-1237.mvista.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921AbXEWQOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:14:00 -0400
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable
	preemption
From: Kevin Hilman <khilman@mvista.com>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070523092232.GA9482@flint.arm.linux.org.uk>
References: <20070522230128.891568116@mvista.com>
	 <1179876320.15427.214.camel@imap.mvista.com>
	 <1179877296.6122.74.camel@vence.hilman.org>
	 <20070523092232.GA9482@flint.arm.linux.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Wed, 23 May 2007 09:13:57 -0700
Message-Id: <1179936837.7051.11.camel@vence.hilman.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 10:22 +0100, Russell King wrote:
> On Tue, May 22, 2007 at 04:41:36PM -0700, Kevin Hilman wrote:
> > On Tue, 2007-05-22 at 16:25 -0700, Daniel Walker wrote:
> > > On Tue, 2007-05-22 at 16:01 -0700, Kevin Hilman wrote:
> > > > Add a preempt_enable() to flush_tlb_kernel_page() since -rt4 patch
> > > > adds a preempt_disable but no preempt_enable().
> > > > 
> > > > Signed-off-by: Kevin Hilman <khilman@mvista.com>
> > > > 
> > > > 
> > > > ---
> > > >  include/asm-arm/tlbflush.h |    1 +
> > > >  1 file changed, 1 insertion(+)
> > > > 
> > > > Index: linux-2.6.21/include/asm-arm/tlbflush.h
> > > > ===================================================================
> > > > --- linux-2.6.21.orig/include/asm-arm/tlbflush.h
> > > > +++ linux-2.6.21/include/asm-arm/tlbflush.h
> > > > @@ -378,6 +378,7 @@ static inline void local_flush_tlb_kerne
> > > >  		asm("mcr p15, 0, %0, c8, c6, 1" : : "r" (kaddr) : "cc");
> > > >  	if (tlb_flag(TLB_V6_I_PAGE))
> > > >  		asm("mcr p15, 0, %0, c8, c5, 1" : : "r" (kaddr) : "cc");
> > > 
> > > Aren't these mcr operations atomic?
> > > 
> > 
> > Individually, yes.  But the point of the preempt_disable/enable is to
> > make the whole sequence atomic.
> 
> In which case shouldn't it be at the end of the function so it includes
> the write buffer handling as well?
> 
> However, I think I agree with Daniel on this one.  I don't see the point
> of the preempt_disable() here.

Note that my patch simply adds an enable to match the disable added by
the -rt patch.  I'm not sure where the disable originally came from, but
there are disable/enable pairs scattered throughout tlbflush.h in the
-rt patch.

If this one isn't necessary, then the others probably are not either.
In most cases there are 2 mcr instructions inside the critical section.
One for the dsb() and the other for the actual function.

Russell, is there a reason any of these sections should be atomic?

Kevin




