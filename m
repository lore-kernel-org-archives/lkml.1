Return-Path: <linux-kernel-owner+w=401wt.eu-S932868AbXCGKM5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868AbXCGKM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2007 05:12:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932890AbXCGKM4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Mar 2007 05:12:56 -0500
Received: from gate.crashing.org ([63.228.1.57]:38768 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932868AbXCGKMz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2007 05:12:55 -0500
Subject: Re: [RFC] [patch 4/6 -rt] powerpc 2.6.20-rt8: fix a runtime
	warnings for xmon
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Tsutomu OWA <tsutomu.owa@toshiba.co.jp>, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070307091638.GC1783@elte.hu>
References: <yyi8xe925vg.wl@toshiba.co.jp> <yyi3b4h25jj.wl@toshiba.co.jp>
	 <20070307091638.GC1783@elte.hu>
Content-Type: text/plain
Date: Wed, 07 Mar 2007 11:10:59 +0100
Message-Id: <1173262259.9349.40.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-03-07 at 10:16 +0100, Ingo Molnar wrote:
> * Tsutomu OWA <tsutomu.owa@toshiba.co.jp> wrote:
> 
> > @@ -342,6 +342,7 @@ static int xmon_core(struct pt_regs *reg
> >  
> >  	msr = mfmsr();
> >  	mtmsr(msr & ~MSR_EE);	/* disable interrupts */
> > +	preempt_disable();
> 
> i'm not an xmon expert, but maybe it might make more sense to first 
> disable preemption, then interrupts - otherwise you could be preempted 
> right after having disabled these interrupts (and be scheduled to 
> another CPU, etc.). What is the difference between local_irq_save() and 
> the above 'disable interrupts' sequence? If it's not the same and 
> xmon_core() relied on having hardirqs disabled then it might make sense 
> to do a local_irq_save() there, instead of a preempt_disable().

powerpc 64 bits nowadays does lazy HW masking, so local_irq_disable()
will not actually switch MSR_EE off. However, xmon needs that to happen
(though we have a nicer accessor to do it, I suspect some bitrot need
fixing in there, possibly already fixed in .21)

I agree that preempt_disable() should be put before the MSR tweaking
though.

Ben.


