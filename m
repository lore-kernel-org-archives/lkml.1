Return-Path: <linux-kernel-owner+w=401wt.eu-S1761527AbZCMRLy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761527AbZCMRLy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:11:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbZCMRHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:07:47 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:37766 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761126AbZCMRHq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:07:46 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of interrupts during suspend-resume (rev. 5)
Date: Fri, 13 Mar 2009 18:07:36 +0100
User-Agent: KMail/1.11.1 (Linux/2.6.29-rc7-tst; KDE/4.2.1; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>
References: <200902221837.49396.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl> <20090313003950.GB19544@elte.hu>
In-Reply-To: <20090313003950.GB19544@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903131807.37579.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 13 March 2009, Ingo Molnar wrote:
> 
> * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> 
> > On Thursday 12 March 2009, Rafael J. Wysocki wrote:
> > > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> > > > > On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > > > > > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > > > > > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > > > > > > 
> > > > > > >   I'm not too enthusiastic about this open coded implementation of
> > > > > > >   disable_irq() with slightly different semantics.
> > > > > > 
> > > > > > The difference in semantics is important IMO, otherwise I woulndn't have
> > > > > > done that.  In particular, IMO, the condition should be under the spinlock IMO
> > > > > > and I'd rather not synchronize all interrupts we don't really disable here.
> > > > > 
> > > > > I don't say that the difference is not relevant. But the code is
> > > > > almost the same and disable_irq() could have the sync_irq optimization
> > > > > as well.
> > > > 
> > > > Thought more about that. Avoiding the sync_irq() for irqs which have
> > > > no action associated is fine, but you need to catch the following case
> > > > as well:
> > > > 
> > > >    driver code calls disable_irq_nosyc() from the handler (which is
> > > >    still running)
> > > > 
> > > >    suspend code skips the sync due to depth > 0
> > > > 
> > > > The sync operation is not that expensive.
> > > 
> > > OK, what about this (untested, irrelevant parts skipped)?
> > 
> > Well, I guess I need to assume that no reaction means it's fine. ;-)
> > 
> > Below is the complete patch.  Thomas, Ingo, please let me know 
> > it it is fine with you.
> 
> looks good - but you sure want to split it up some more, right?

Well, in fact I didn't think about that.

> > 13 files changed, 195 insertions(+), 47 deletions(-)
> 
> We want the non-intrusive 'add new APIs' bits [which give most 
> of the linecount] separated from the 'all hell breaks lose' 
> functional changes ;-) Makes it easier to revert, bisect, etc.

I can split it into a patch adding the new functions under kernel/irq and
another one making the suspend code use them, but that's going
to put the new functions somewhat out of context, IMO.

Still, I'll do it if you want me to.

Thanks,
Rafael
