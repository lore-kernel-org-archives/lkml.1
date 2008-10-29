Return-Path: <linux-kernel-owner+w=401wt.eu-S1754023AbYJ2OCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023AbYJ2OCA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 10:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752759AbYJ2OBw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 10:01:52 -0400
Received: from accolon.hansenpartnership.com ([76.243.235.52]:36897 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702AbYJ2OBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 10:01:51 -0400
Subject: Re: [PATCH] x86: Fix CONFIG_PCI=n compile failure
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Glauber Costa <gcosta@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20081029073629.GB17992@elte.hu>
References: <1225228943.3251.17.camel@localhost.localdomain>
	 <20081029073629.GB17992@elte.hu>
Content-Type: text/plain
Date: Wed, 29 Oct 2008 09:01:46 -0500
Message-Id: <1225288906.3257.4.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-10-29 at 08:36 +0100, Ingo Molnar wrote:
> * James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > This:
> > 
> > commit fae9a0d8ca68a14da8d2351ad3e0bf42f3b29899
> > Author: Glauber Costa <gcosta@redhat.com>
> > Date:   Tue Apr 8 13:20:56 2008 -0300
> > 
> >     x86: merge iommu initialization parameters
> > 
> > Moved the forbid_dac parameter into pci-dma.c but forgot that it's a 
> > PCI only symbol thus causing a compile failure if CONFIG_PCI=N.  Fix 
> > by surrounding the set clause in iommu_setup with #ifdef CONFIG_PCI
> 
> uhm, that's wrong James, the above commit you refer to is half a year 
> old and has been released in v2.6.26 and v2.6.27 ;-)
> 
> The patch that broke the !CONFIG_PCI build in this cycle is this one:
> 
> | From 5b6985ce8ec7127b4d60ad450b64ca8b82748a3b Mon Sep 17 00:00:00 2001
> | From: Fenghua Yu <fenghua.yu@intel.com>
> | Date: Thu, 16 Oct 2008 18:02:32 -0700
> | Subject: [PATCH] intel-iommu: IA64 support
> |
> | The current Intel IOMMU code assumes that both host page size and 
> | Intel IOMMU page size are 4KiB. The first patch supports variable 
> | page size. This provides support for IA64 which has multiple page 
> | sizes.
> |
> | This patch also adds some other code hooks for IA64 platform 
> | including DMAR_OPERATION_TIMEOUT definition.
> |
> | [dwmw2: some cleanup]
> | Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
> | Signed-off-by: Tony Luck <tony.luck@intel.com>
> | Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>

Hmm, well, the triage could be wrong ... however the prior patch seemed
to move forbid_dac out from under the PCI defines.

> > Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.com>
> > 
> > ---
> > 
> > diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> > index 1972266..47c5a7a 100644
> > --- a/arch/x86/kernel/pci-dma.c
> > +++ b/arch/x86/kernel/pci-dma.c
> > @@ -202,6 +202,7 @@ static __init int iommu_setup(char *p)
> >  			iommu_merge = 0;
> >  		if (!strncmp(p, "forcesac", 8))
> >  			iommu_sac_force = 1;
> > +#ifdef CONFIG_PCI
> >  		if (!strncmp(p, "allowdac", 8))
> >  			forbid_dac = 0;
> >  		if (!strncmp(p, "nodac", 5))
> > @@ -210,6 +211,7 @@ static __init int iommu_setup(char *p)
> >  			forbid_dac = -1;
> >  			return 1;
> >  		}
> > +#endif
> 
> that's the wrong fix, the right fix from Fenghua Yu (from about a week 
> ago) is at:
> 
>   http://marc.info/?l=linux-kernel&m=122480590627590&w=2
> 
> and it is in the PCI tree already.

This is obviously some strange definition of the word "right" of which I
was previously unaware.  That patch moves forbid_dac plus a load of
quirk processing (also for a PCI bus) out from under CONFIG_PCI only ...
which will fix the compile error, sure.

However, if you'd be so kind, please explain how a DAC (meaning Dual
Addressing Cycle on the PCI bus) is useful (or even can be effected)
without a PCI bus?

All its really doing is contaminating pci-dma.c with clutter that only
needs to be there because someone can't get the separation right.

James


