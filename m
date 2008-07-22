Return-Path: <linux-kernel-owner+w=401wt.eu-S1754103AbYGVTSm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103AbYGVTSm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:18:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751207AbYGVTSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:18:32 -0400
Received: from mgw1.diku.dk ([130.225.96.91]:49227 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750718AbYGVTSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:18:31 -0400
Date: Tue, 22 Jul 2008 21:18:27 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Simon Holm =?ISO-8859-1?Q?Th=F8gersen?= <odie@cs.aau.dk>
Cc: avi@qumranet.com, kvm@vger.kernel.org, xiantao.zhang@intel.com,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] arch/ia64/kvm/kvm-ia64.c: Add local_irq_restore in
 error handling code
In-Reply-To: <1216753864.28082.11.camel@odie.local>
Message-ID: <Pine.LNX.4.64.0807222115210.2670@ask.diku.dk>
References: <Pine.LNX.4.64.0807221843140.2670@ask.diku.dk>
 <1216753864.28082.11.camel@odie.local>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-511516320-1442744024-1216754307=:2670"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---511516320-1442744024-1216754307=:2670
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Tue, 22 Jul 2008, Simon Holm Thøgersen wrote:

> tir, 22 07 2008 kl. 18:44 +0200, skrev Julia Lawall:
> > From: Julia Lawall <julia@diku.dk>
> > 
> > There is a call to local_irq_restore in the normal exit case, so it would
> > seem that there should be one on an error return as well.
> > 
> > The semantic patch that makes this change is as follows:
> > (http://www.emn.fr/x-info/coccinelle/)
> > 
> > // <smpl>
> > @@
> > expression l;
> > expression E,E1,E2;
> > @@
> > 
> > local_irq_save(l);
> > ... when != local_irq_restore(l)
> >     when != spin_unlock_irqrestore(E,l)
> >     when any
> >     when strict
> > (
> > if (...) { ... when != local_irq_restore(l)
> >                when != spin_unlock_irqrestore(E1,l)
> > +   local_irq_restore(l);
> >     return ...;
> > }
> > |
> > if (...)
> > +   {local_irq_restore(l);
> >     return ...;
> > +   }
> > |
> > spin_unlock_irqrestore(E2,l);
> > |
> > local_irq_restore(l);
> > )
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <julia@diku.dk>
> > 
> > ---
> >  arch/ia64/kvm/kvm-ia64.c      |    9 +++++++--
> >  1 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/ia64/kvm/kvm-ia64.c b/arch/ia64/kvm/kvm-ia64.c
> > index 318b811..14e5c99 100644
> > --- a/arch/ia64/kvm/kvm-ia64.c
> > +++ b/arch/ia64/kvm/kvm-ia64.c
> > @@ -125,8 +125,10 @@ void kvm_arch_hardware_enable(void *garbage)
> >  				PAGE_KERNEL));
> >  	local_irq_save(saved_psr);
> >  	slot = ia64_itr_entry(0x3, KVM_VMM_BASE, pte, KVM_VMM_SHIFT);
> > -	if (slot < 0)
> > +	if (slot < 0) {
> > +		local_irq_restore(saved_psr);
> >  		return;
> > +	}
> >  	local_irq_restore(saved_psr);
> 
> If this change makes sense, how about merging the two local_irq_restore
> calls and put them before the if? And shouldn't your checker be able to
> figure this?

No, it pretty much only does what it's told, which is to put a
local_irq_restore before the return.  

Since slot is a local variable, it does seem like the call to 
local_irq_restore could be safely moved upwards, so I will do that 
instead.

thanks,
julia

---511516320-1442744024-1216754307=:2670--
