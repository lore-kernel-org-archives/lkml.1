Return-Path: <linux-kernel-owner+w=401wt.eu-S1756706AbYJ3QaZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756706AbYJ3QaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 12:30:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbYJ3QaL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 12:30:11 -0400
Received: from mga11.intel.com ([192.55.52.93]:11332 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbYJ3QaK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 12:30:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,516,1220252400"; 
   d="scan'208";a="633445182"
Date: Thu, 30 Oct 2008 09:30:08 -0700
From: Suresh Siddha <suresh.b.siddha@intel.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Siddha, Suresh B" <suresh.b.siddha@intel.com>,
       "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
       "mingo@elte.hu" <mingo@elte.hu>,
       "jeremy.fitzhardinge@citrix.com" <jeremy.fitzhardinge@citrix.com>,
       "nickpiggin@yahoo.com.au" <nickpiggin@yahoo.com.au>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>
Subject: Re: [patch] generic-ipi: fix the smp_mb() placement
Message-ID: <20081030163008.GL30573@linux-os.sc.intel.com>
References: <20081029224229.GK30573@linux-os.sc.intel.com> <20081030072029.GK31673@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081030072029.GK31673@kernel.dk>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2008 at 12:20:30AM -0700, Jens Axboe wrote:
> > @@ -76,6 +72,11 @@ static void generic_exec_single(int cpu, struct call_single_data *data)
> >  	list_add_tail(&data->list, &dst->list);
> >  	spin_unlock_irqrestore(&dst->lock, flags);
> >  
> > +	/*
> > +	 * Make the list addition visible before sending the ipi.
> > +	 */
> > +	smp_mb();
> > +
> >  	if (ipi)
> >  		arch_send_call_function_single_ipi(cpu);
> 
> We can downgrade this to a smp_wmb().

No. We want the ipi receiver to see the new consistent data rather than possible
old consistent data.

And on x86, smp_wmb() is a simple barrier() (in !CONFIG_X86_OOSTORE) and
which doesn't do much in this case.

on x86 mfence (smp_mb()) will ensure that msr based APIC (x2apic) accesses (ipi)
will be visible only after the memory operations before smp_mb() are made
visible.

thanks,
suresh
