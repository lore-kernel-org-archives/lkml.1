Return-Path: <linux-kernel-owner+w=401wt.eu-S1753048AbYKZWzY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbYKZWzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2008 17:55:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752435AbYKZWzE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Nov 2008 17:55:04 -0500
Received: from www.tglx.de ([62.245.132.106]:56453 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752472AbYKZWzC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2008 17:55:02 -0500
Date: Wed, 26 Nov 2008 23:54:30 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Andi Kleen <andi@firstfloor.org>
cc: eranian@googlemail.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, mingo@elte.hu, x86@kernel.org,
       eranian@gmail.com, sfr@canb.auug.org.au
Subject: Re: [patch 05/24] perfmon: X86 generic code (x86)
In-Reply-To: <20081126140054.GX6703@one.firstfloor.org>
Message-ID: <alpine.LFD.2.00.0811262237140.3325@localhost.localdomain>
References: <492d0be1.09cc660a.0b75.44b7@mx.google.com> <alpine.LFD.2.00.0811261143480.3325@localhost.localdomain> <20081126140054.GX6703@one.firstfloor.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 26 Nov 2008, Andi Kleen wrote:
> On Wed, Nov 26, 2008 at 02:35:18PM +0100, Thomas Gleixner wrote:
> > > +	 */
> > > +	pfm_arch_resend_irq(ctx);
> > 
> > Do we really need this whole NMI business ?
> 
> Without it you cannot profile interrupts off regions well.

Fair enough, but I doubt that this is a real solution.

There is not even an attempt to avoid the obvious wrmrsl races, while
there are several comments which explain how expensive wrmrsl is. In
the NMI handler we enable the NMI right away. This might cause
multiple NMIs for nothing when the NMIs hit between the manipulations
of the counters. Not likely but can happen depending on the counter
settings.

Sending an self-IPI from NMI simply sucks: For every NMI we get an
extra local interrupt and we have an extra of 2 * NR_ACTIVE_COUNTERS
accesses to MSRs.

Designing that code to use lockless buffers instead is not really
rocket science.

This code sucks performance wise in all aspects I have looked at so
far.

Thanks,

	tglx
