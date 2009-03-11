Return-Path: <linux-kernel-owner+w=401wt.eu-S1753737AbZCKWsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737AbZCKWsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Mar 2009 18:48:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752482AbZCKWr6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Mar 2009 18:47:58 -0400
Received: from www.tglx.de ([62.245.132.106]:54560 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752309AbZCKWr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Mar 2009 18:47:57 -0400
Date: Wed, 11 Mar 2009 23:45:48 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Ingo Molnar <mingo@elte.hu>, pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
Subject: Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume
 (rev. 5)
In-Reply-To: <alpine.LFD.2.00.0903112238280.29264@localhost.localdomain>
Message-ID: <alpine.LFD.2.00.0903112342440.29264@localhost.localdomain>
References: <200902221837.49396.rjw@sisk.pl> <200903111036.02482.rjw@sisk.pl> <alpine.LFD.2.00.0903111106450.29264@localhost.localdomain> <200903112159.21166.rjw@sisk.pl> <alpine.LFD.2.00.0903112238280.29264@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > > 
> > >   I'm not too enthusiastic about this open coded implementation of
> > >   disable_irq() with slightly different semantics.
> > 
> > The difference in semantics is important IMO, otherwise I woulndn't have
> > done that.  In particular, IMO, the condition should be under the spinlock IMO
> > and I'd rather not synchronize all interrupts we don't really disable here.
> 
> I don't say that the difference is not relevant. But the code is
> almost the same and disable_irq() could have the sync_irq optimization
> as well.

Thought more about that. Avoiding the sync_irq() for irqs which have
no action associated is fine, but you need to catch the following case
as well:

   driver code calls disable_irq_nosyc() from the handler (which is
   still running)

   suspend code skips the sync due to depth > 0

The sync operation is not that expensive.

Thanks,

	tglx
