Return-Path: <linux-kernel-owner+w=401wt.eu-S1752116AbXB0U13@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbXB0U13 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 15:27:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752095AbXB0U12
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 15:27:28 -0500
Received: from smtp.osdl.org ([65.172.181.24]:50467 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751829AbXB0U1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 15:27:25 -0500
Date: Tue, 27 Feb 2007 12:26:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Siddha, Suresh B" <suresh.b.siddha@intel.com>
Cc: ebiederm@xmission.com, linux-kernel@vger.kernel.org, zwane@infradead.org,
       ashok.raj@intel.com, mingo@elte.hu, yinghai.lu@amd.com,
       protasnb@gmail.com, ak@suse.de, suresh.b.siddha@intel.com,
       torvalds@linux-foundation.org
Subject: Re: [PATCH 14/14] genirq: Mask irqs when migrating them.
Message-Id: <20070227122657.a8c9d2c0.akpm@linux-foundation.org>
In-Reply-To: <20070223180655.B2120@unix-os.sc.intel.com>
References: <m1tzxdunsg.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81uno3.fsf_-_@ebiederm.dsl.xmission.com>
	<m1lkipunl0.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ejohung7.fsf_-_@ebiederm.dsl.xmission.com>
	<m17iu9unb6.fsf_-_@ebiederm.dsl.xmission.com>
	<m13b4xun1c.fsf_-_@ebiederm.dsl.xmission.com>
	<m1y7mpt8d2.fsf_-_@ebiederm.dsl.xmission.com>
	<m1tzxdt8au.fsf_-_@ebiederm.dsl.xmission.com>
	<m1ps81t87h.fsf_-_@ebiederm.dsl.xmission.com>
	<m1hctdt7ub.fsf_-_@ebiederm.dsl.xmission.com>
	<20070223180655.B2120@unix-os.sc.intel.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.19; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, 23 Feb 2007 18:06:55 -0800 "Siddha, Suresh B" <suresh.b.siddha@intel.com> wrote:
> > 
> > move_native_irqs tries to do the right thing when migrating irqs
> > by disabling them.  However disabling them is a software logical
> > thing, not a hardware thing.  This has always been a little flaky
> > and after Ingo's latest round of changes it is guaranteed to not
> > mask the apic.
> > 
> > So this patch fixes move_native_irq to directly call the mask and
> > unmask chip methods to guarantee that we mask the irq when we
> > are migrating it.  We must do this as it is required by
> > all code that call into the path.
> > 
> > Since we don't know the masked status when IRQ_DISABLED is
> > set so we will not be able to restore it.   The patch makes the code
> > just give up and trying again the next time this routing is called.
> > 
> > Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
> > ---
> >  kernel/irq/migration.c |    9 ++++-----
> >  1 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/kernel/irq/migration.c b/kernel/irq/migration.c
> > index 4baa3bb..77b7acc 100644
> > --- a/kernel/irq/migration.c
> > +++ b/kernel/irq/migration.c
> > @@ -65,12 +65,11 @@ void move_native_irq(int irq)
> >  	if (likely(!(desc->status & IRQ_MOVE_PENDING)))
> >  		return;
> >  
> > -	if (likely(!(desc->status & IRQ_DISABLED)))
> > -		desc->chip->disable(irq);
> > +	if (unlikely(desc->status & IRQ_DISABLED))
> > +		return;
> >  
> > +	desc->chip->mask(irq);
> >  	move_masked_irq(irq);
> > -
> > -	if (likely(!(desc->status & IRQ_DISABLED)))
> > -		desc->chip->enable(irq);
> > +	desc->chip->unmask(irq);
> >  }
>

arghg.  Please don't top-post.  Ever.  At all.  Don't even think about 
thinking about it.

<edit, edit>

> Andrew, This is a bug fix and must go in before 2.6.21.
> 
> Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>

OK.  But the rest of the patch series was a bit of a trainwreck against
Andi's pending tree so I ducked it all.

If it's really needed for 2.6.21 then we have some work to do.  Presumably
carefully reviewing and testing this new work then repairing Andi's tree. 
 
