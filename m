Return-Path: <linux-kernel-owner+w=401wt.eu-S934796AbXEWQZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934796AbXEWQZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2007 12:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757071AbXEWQZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 May 2007 12:25:14 -0400
Received: from caramon.arm.linux.org.uk ([217.147.92.249]:4710 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759900AbXEWQZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2007 12:25:12 -0400
Date: Wed, 23 May 2007 17:25:00 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Kevin Hilman <khilman@mvista.com>
Cc: Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -rt] ARM TLB flush fix: don't forget to re-enable preemption
Message-ID: <20070523162500.GA1976@flint.arm.linux.org.uk>
Mail-Followup-To: Kevin Hilman <khilman@mvista.com>,
	Daniel Walker <dwalker@mvista.com>, Ingo Molnar <mingo@elte.hu>,
	linux-kernel@vger.kernel.org
References: <20070522230128.891568116@mvista.com> <1179876320.15427.214.camel@imap.mvista.com> <1179877296.6122.74.camel@vence.hilman.org> <20070523092232.GA9482@flint.arm.linux.org.uk> <1179936837.7051.11.camel@vence.hilman.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1179936837.7051.11.camel@vence.hilman.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2007 at 09:13:57AM -0700, Kevin Hilman wrote:
> On Wed, 2007-05-23 at 10:22 +0100, Russell King wrote:
> > In which case shouldn't it be at the end of the function so it includes
> > the write buffer handling as well?
> > 
> > However, I think I agree with Daniel on this one.  I don't see the point
> > of the preempt_disable() here.
> 
> Note that my patch simply adds an enable to match the disable added by
> the -rt patch.  I'm not sure where the disable originally came from, but
> there are disable/enable pairs scattered throughout tlbflush.h in the
> -rt patch.
> 
> If this one isn't necessary, then the others probably are not either.
> In most cases there are 2 mcr instructions inside the critical section.
> One for the dsb() and the other for the actual function.
> 
> Russell, is there a reason any of these sections should be atomic?

I don't see any reason for them to be - when switching to another process
we'll generally do a full TLB flush anyway, so what's the point in making
these flushes atomic?

Consider:

flush_tlb_page()
 first mcr - invalidates tlb single entry
	--- context switch, invalidates entire tlb, inc dsb ---
		something else runs
	--- context switch, invalidates entire tlb, inc dsb, again ---
 dsb

That context switch is harmless - we end up with the entire TLB being
invalidated and a DSB following.  Now consider:

flush_tlb_page()
	--- context switch, invalidates entire tlb, inc dsb ---
		something else runs
	--- context switch, invalidates entire tlb, inc dsb, again ---
 preempt_disable()
 first mcr - invalidates tlb single entry
 dsb
 preempt_enable()

Any difference?  No.  Without the preempt disable/enable fiddling?  No.

flush_tlb_page()
 preempt_disable()
 first mcr - invalidates tlb single entry
 dsb
 preempt_enable()
	--- context switch, invalidates entire tlb, inc dsb ---
		something else runs
	--- context switch, invalidates entire tlb, inc dsb, again ---

Any difference?  No.  Without the preempt disable/enable fiddling?  No.

In every case of a preemption occuring in the middle of a tlb operation,
the ultimate result is identical irrespective of preempt control
sprinkling.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
