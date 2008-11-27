Return-Path: <linux-kernel-owner+w=401wt.eu-S1753888AbYK0Jzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbYK0Jzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 04:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752608AbYK0Jze
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 04:55:34 -0500
Received: from one.firstfloor.org ([213.235.205.2]:34626 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377AbYK0Jze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 04:55:34 -0500
Date: Thu, 27 Nov 2008 11:06:02 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, eranian@googlemail.com,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
       x86@kernel.org, eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
Message-ID: <20081127100602.GF6703@one.firstfloor.org>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain> <20081126140054.GX6703@one.firstfloor.org> <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2008 at 11:54:30PM +0100, Thomas Gleixner wrote:
> On Wed, 26 Nov 2008, Andi Kleen wrote:
> > On Wed, Nov 26, 2008 at 02:35:18PM +0100, Thomas Gleixner wrote:
> > > > +	 */
> > > > +	pfm_arch_resend_irq(ctx);
> > > 
> > > Do we really need this whole NMI business ?
> > 
> > Without it you cannot profile interrupts off regions well.
> 
> Fair enough, but I doubt that this is a real solution.
> 
> There is not even an attempt to avoid the obvious wrmrsl races, while
> there are several comments which explain how expensive wrmrsl is. In
> the NMI handler we enable the NMI right away. This might cause
> multiple NMIs for nothing when the NMIs hit between the manipulations
> of the counters. Not likely but can happen depending on the counter
> settings.
> 
> Sending an self-IPI from NMI simply sucks: For every NMI we get an
> extra local interrupt and we have an extra of 2 * NR_ACTIVE_COUNTERS
> accesses to MSRs.

In newer Intel the counters can be reset/rearmed by accessing
only a few global control msrs. But it's probably still a problem 
on other PMUs.

On the other hand it also has PEBS which allows at least some 
profiling of irq-off regions without using NMIs.
> 
> Designing that code to use lockless buffers instead is not really
> rocket science.

Lockless buffers are nasty, but it works in oprofile at least.

Taking out NMis in the first version at least seems like a reasonable
solution. After all you can still use standard oprofile where they work
just fine.

-Andi

-- 
ak@linux.intel.com
