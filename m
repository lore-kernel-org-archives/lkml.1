Return-Path: <linux-kernel-owner+w=401wt.eu-S939750AbXHJPMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S939750AbXHJPMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2007 11:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765225AbXHJPMM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Aug 2007 11:12:12 -0400
Received: from e4.ny.us.ibm.com ([32.97.182.144]:49675 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752583AbXHJPMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2007 11:12:10 -0400
Date: Fri, 10 Aug 2007 08:12:08 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Adrian Bunk <bunk@kernel.org>, Josh Triplett <josh@kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.23-rc2-mm1: rcutorture xtime usage
Message-ID: <20070810151208.GC8511@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070809015106.cd0bfc53.akpm@linux-foundation.org> <20070810013146.GD18938@stusta.de> <20070810020040.GK8424@linux.vnet.ibm.com> <20070809190623.f60dcf70.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070809190623.f60dcf70.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 09, 2007 at 07:06:23PM -0700, Andrew Morton wrote:
> On Thu, 9 Aug 2007 19:00:40 -0700 "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> 
> > On Fri, Aug 10, 2007 at 03:31:46AM +0200, Adrian Bunk wrote:
> > > On Thu, Aug 09, 2007 at 01:51:06AM -0700, Andrew Morton wrote:
> > > >...
> > > > Changes since 2.6.23-rc2-mm1:
> > > >...
> > > > +allow-rcutorture-to-handle-synchronize_sched.patch
> > > >...
> > > >  2.6.23 queue
> > > >...
> > > 
> > > All drivers were converted to no longer use xtime directly since it 
> > > might be quite outdated, but this patch adds a usage of xtime.tv_nsec
> > > as RNG...
> > 
> > This code doesn't care if the time is outdated, as it is simply
> > periodically perturbing an RNG, but OK.
> > 
> > So, what interface are we supposed to be using instead?  I cannot use
> > get_random_bytes() due to locking issues.  This is not a cryptographically
> > secure usage, so the perturbation does not need to be extremely high
> > quality.
> > 
> > On x86, I would just grab the low-order bits of the TSC, but all of the
> > world is not an x86.  ;-)
> 
> One used to use sched_clock() for this, then get frowned at.  Now we
> have cpu_clock()...

Hmmm...  And cpu_clock() is not in 2.6.22, so must appear in some later
release.  Which means that the rate of API change in this area is a
bit high, so I should avoid it like the plague.  Therefore, I should
look for some other convenient source of entropy.

One convenient source would the per-CPU statistics that rcutorture
maintains.  Of course, a given CPU's RNG is nearly in lock-step with
its own statistics, but not with the adjacent CPU's statistics...

I will send a patch.

						Thanx, Paul
