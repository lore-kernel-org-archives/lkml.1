Return-Path: <linux-kernel-owner+w=401wt.eu-S1755870AbXJaUzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbXJaUzd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2007 16:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbXJaUzQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Oct 2007 16:55:16 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:47261 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102AbXJaUzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2007 16:55:14 -0400
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
From: Darren Hart <dvhltc@us.ibm.com>
To: benh@kernel.crashing.org
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       tony@bakeyournoodle.com, paulus@samba.org, dino@in.ibm.com,
       tytso@us.ibm.com, antonb@us.ibm.com, rostedt@goodmis.org
In-Reply-To: <1193688468.9928.30.camel@pasglop>
References: <20071029185044.GA23413@linux.vnet.ibm.com>
	 <1193688468.9928.30.camel@pasglop>
Content-Type: text/plain
Date: Wed, 31 Oct 2007 13:54:35 -0700
Message-Id: <1193864075.9767.20.camel@Aeon>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2007-10-30 at 07:07 +1100, Benjamin Herrenschmidt wrote: 
> On Mon, 2007-10-29 at 11:50 -0700, Paul E. McKenney wrote:
> > Hello!
> > 
> > A few random patches that permit POWER to pass kernbench on -rt.
> > Many of these have more focus on expediency than care for correctness,
> > so might best be thought of as workarounds than as complete solutions.
> > There are still issues not addressed by this patch, including:
> > 
> > o	kmem_cache_alloc() from non-preemptible context during
> > 	bootup (xics_startup() building the irq_radix_revmap()).
> > 
> > o	unmap_vmas() freeing pages with preemption disabled.
> > 	Might be able to address this by linking the pages together,
> > 	then freeing them en masse after preemption has been re-enabled,
> > 	but there is likely a better approach.
> > 
> > Thoughts?
> 
> I see a lot of case where you add preempt_disable/enable around areas
> that have the PTE lock held...
> 
> So in -rt, spin_lock doesn't disable preempt ? I'm a bit worried...

So as Paul mentioned, spin_lock is now a mutex.  There is a new
raw_spinlock however (simply change the way it is declared, calling
conventions are the same) which is used in a very few areas where a
traditional spin_lock is truly necessary.  This may or may not be one of
those times, but I wanted to point it out.

--Darren


> there are some strong requirements that anything within that lock is not
> preempted, so zap_pte_ranges() is the obvious ones but all of them would
> need to be addressed.
> 
> Ben.
> 
> 

