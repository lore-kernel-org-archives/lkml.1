Return-Path: <linux-kernel-owner+w=401wt.eu-S1754766AbZBTJMr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbZBTJMr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Feb 2009 04:12:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752845AbZBTJM3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Feb 2009 04:12:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:55345 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753437AbZBTJM1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:12:27 -0500
Date: Fri, 20 Feb 2009 11:09:12 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Yinghai Lu <yinghai@kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: enable x2apic early at the first point
Message-ID: <20090220090912.GA4632@redhat.com>
References: <499DD40F.40102@kernel.org> <1235081612.14523.23.camel@vayu> <499DE05A.40804@kernel.org> <1235086118.14523.40.camel@vayu> <20090220083528.GB24555@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090220083528.GB24555@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 20, 2009 at 09:35:28AM +0100, Ingo Molnar wrote:
> 
> * Suresh Siddha <suresh.b.siddha@intel.com> wrote:
> 
> > On Thu, 2009-02-19 at 14:42 -0800, Yinghai Lu wrote:
> > > Ingo want to decouple that x2apic and intr_remapping.
> > > it seems it does work with x2apic without intr_remapping in one of setup.
> > 
> > x2apic with out intr-remapping is not architectural. Even when 
> > we have < 255 logical cpu's, logical x2apic id's will be 
> > greater than 16 bits even on a single/two socket systems and 
> > this will break interrupt delivery. Please look at the x2apic 
> > logical destination mode definition in the SDM (Section 
> > 9.7.2.3 and 9.7.2.4 in my copy of SDM Vol3a)
> >
This is what Intel doc says:
 It is likely that processor implementations may choose to support less
 than 16 bits of the cluster ID or less than 16-bits of the Logical ID
 in the Logical Destination Register.  However system software should be
 agnostic to the number of bits implemented in the cluster ID and logical
 ID sub-fields. The x2APIC hardware initialization will ensure that the
 appropriately initialized logical x2APIC IDs are available to system
 software and reads of non-implemented bits return zero.

KVM will implement 0 bits of cluster ID and will want to use x2apic without
implementing IR.

> > While it might work in certain configurations (for example, 
> > physical mode with < 8 bit apicids), it is not architectural 
> > and implementation dependent, which may break in future 
> > generations.
> > 
It will not break in future generation of KVM though.

> > And also, logical x2apic mode has more advantages compared to 
> > physical mode (like using lowest priority delivery mode etc).
> > 
> > I will post couple of patches, which revert's Gleb's patch and 
> > another fix for the early boot failure issue, tomorrow.
> 
If you'll revert my patch it will not be possible to use x2apic in
KVM (at least without KVM implementing interrupt remapping which is
unneeded otherwise) and x2apic interface is much better for vitalization.
Instead of reverting the patch it will be better to add check if x2apic
can be used without intr-remmaping (all CPUs belong to cluster 0) or
allow enabling of x2apic without IR if running as a guest.

--
			Gleb.
