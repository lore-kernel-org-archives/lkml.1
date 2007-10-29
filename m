Return-Path: <linux-kernel-owner+w=401wt.eu-S1755409AbXJ2U0h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbXJ2U0h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 16:26:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751866AbXJ2U0a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 16:26:30 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:44028 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530AbXJ2U03 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 16:26:29 -0400
Date: Mon, 29 Oct 2007 13:26:17 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, tony@bakeyournoodle.com, paulus@samba.org,
       dino@in.ibm.com, tytso@us.ibm.com, dvhltc@us.ibm.com, antonb@us.ibm.com,
       rostedt@goodmis.org, niv@us.ibm.com
Subject: Re: [PATCH, RFC] hacks to allow -rt to run kernbench on POWER
Message-ID: <20071029202617.GF8824@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20071029185044.GA23413@linux.vnet.ibm.com> <1193688468.9928.30.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1193688468.9928.30.camel@pasglop>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2007 at 07:07:48AM +1100, Benjamin Herrenschmidt wrote:
> 
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
> there are some strong requirements that anything within that lock is not
> preempted, so zap_pte_ranges() is the obvious ones but all of them would
> need to be addressed.

Right in one!  One of the big changes in -rt is that spinlock critical
sections (and RCU read-side critical sections, for that matter) are
preemptible under CONFIG_PREEMPT_RT.

And I agree that this patchset will have missed quite a few places where
additional changes are required.  Hence the word "including" above, rather
than something like "specifically".  ;-)

							Thanx, Paul
