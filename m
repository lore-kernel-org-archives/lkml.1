Return-Path: <linux-kernel-owner+w=401wt.eu-S1757086AbYJ3R0j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757086AbYJ3R0j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 13:26:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754785AbYJ3R03
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 13:26:29 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:48110 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754404AbYJ3R03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 13:26:29 -0400
Date: Thu, 30 Oct 2008 18:25:15 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081030172515.GW31673@kernel.dk>
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030072029.GK31673@kernel.dk> <20081030163008.GL30573@linux-os.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030163008.GL30573@linux-os.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30 2008, Suresh Siddha wrote:
> On Thu, Oct 30, 2008 at 12:20:30AM -0700, Jens Axboe wrote:
> > > @@ -76,6 +72,11 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
> > >  	list_add_tail(&data->list, &dst->list);
> > >  	spin_unlock_irqrestore(&dst->lock, flags);
> > >  
> > > +	/*
> > > +	 * Make the list addition visible before sending the ipi.
> > > +	 */
> > > +	smp_mb();
> > > +
> > >  	if (ipi)
> > >  		arch_send_call_function_single_ipi(cpu);
> > 
> > We can downgrade this to a smp_wmb().
> 
> No. We want the ipi receiver to see the new consistent data rather
> than possible old consistent data.

Oh right, we need visibility here and not just store ordering.

> 
> And on x86, smp_wmb() is a simple barrier() (in !CONFIG_X86_OOSTORE)
> and which doesn't do much in this case.
> 
> on x86 mfence (smp_mb()) will ensure that msr based APIC (x2apic)
> accesses (ipi) will be visible only after the memory operations before
> smp_mb() are made visible.

OK, I'm convinced. I'll queue up the patch, thanks!

-- 
Jens Axboe

