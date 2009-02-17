Return-Path: <linux-kernel-owner+w=401wt.eu-S1754514AbZBQVz4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754514AbZBQVz4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 16:55:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751177AbZBQVzs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 16:55:48 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:42237 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbZBQVzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 16:55:47 -0500
Date: Tue, 17 Feb 2009 22:55:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, hpa@linux.intel.com,
       linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/headers] x86: truncate ISA addresses to unsigned int
Message-ID: <20090217215535.GA11336@elte.hu>
References: <tip-a7eb518998529c08cc53fef17756d9fe433b0c23@kernel.org> <1234905865.23466.11.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234905865.23466.11.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Tue, 2009-02-17 at 21:12 +0000, H. Peter Anvin wrote:
> > Author:     H. Peter Anvin <hpa@linux.intel.com>
> > AuthorDate: Tue, 17 Feb 2009 13:01:51 -0800
> > Commit:     H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Tue, 17 Feb 2009 13:01:51 -0800
> > 
> > x86: truncate ISA addresses to unsigned int
> > 
> > Impact: Cleanup; fix inappropriate macro use
> > 
> > ISA addresses on x86 are mapped 1:1 with the physical address space.
> > Since the ISA address space is only 24 bits (32 for VLB or LPC) it
> > will always fit in an unsigned int, and at least in the aha1542 driver
> > using a wider type would cause an undesirable promotion.  Hence
> > explicitly cast the ISA bus addresses to unsigned int.
> > 
> > Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> > Cc: James Bottomley <James.Bottomley@hansenpartnership.com>
> > 
> > 
> > ---
> >  arch/x86/include/asm/io.h |   11 ++++++++---
> >  1 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
> > index 4f8e820..683d0b4 100644
> > --- a/arch/x86/include/asm/io.h
> > +++ b/arch/x86/include/asm/io.h
> > @@ -124,10 +124,15 @@ static inline void *phys_to_virt(phys_addr_t address)
> >  
> >  /*
> >   * ISA I/O bus memory addresses are 1:1 with the physical address.
> > + * However, we truncate the address to unsigned int to avoid undesirable
> > + * promitions in legacy drivers.
> >   */
> > -#define isa_virt_to_bus (unsigned long)virt_to_phys
> > -#define isa_page_to_bus page_to_phys
> > -#define isa_bus_to_virt phys_to_virt
> > +static inline unsigned int isa_virt_to_bus(volatile void *address)
> 
> The rest looks fine, but why is the address volatile?  The macro below
> never actually dereferences it.

That is because the volatile keyword here broadens the permitted 
_input_ type.

	Ingo
