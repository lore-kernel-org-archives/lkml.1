Return-Path: <linux-kernel-owner+w=401wt.eu-S1757097AbZCMAmA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757097AbZCMAmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 20:42:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751348AbZCMAlv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 20:41:51 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:48898 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbZCMAlu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 20:41:50 -0400
Date: Fri, 13 Mar 2009 01:39:50 +0100
From: Ingo Molnar <mingo@elte.hu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       pm list <linux-pm@lists.linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>, Len Brown <lenb@kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Frans Pop <elendil@planet.nl>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Subject: Re: [update, rev. 6] Re: [PATCH 1/10] PM: Rework handling of
	interrupts during suspend-resume (rev. 5)
Message-ID: <20090313003950.GB19544@elte.hu>
References: <200902221837.49396.rjw@sisk.pl> <alpine.LFD.2.00.0903112342440.29264@localhost.localdomain> <200903121436.21504.rjw@sisk.pl> <200903122243.27452.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200903122243.27452.rjw@sisk.pl>
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


* Rafael J. Wysocki <rjw@sisk.pl> wrote:

> On Thursday 12 March 2009, Rafael J. Wysocki wrote:
> > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > On Wed, 11 Mar 2009, Thomas Gleixner wrote:
> > > > On Wed, 11 Mar 2009, Rafael J. Wysocki wrote:
> > > > > On Wednesday 11 March 2009, Thomas Gleixner wrote:
> > > > > > > +EXPORT_SYMBOL_GPL(suspend_device_irqs);
> > > > > > 
> > > > > >   I'm not too enthusiastic about this open coded implementation of
> > > > > >   disable_irq() with slightly different semantics.
> > > > > 
> > > > > The difference in semantics is important IMO, otherwise I woulndn't have
> > > > > done that.  In particular, IMO, the condition should be under the spinlock IMO
> > > > > and I'd rather not synchronize all interrupts we don't really disable here.
> > > > 
> > > > I don't say that the difference is not relevant. But the code is
> > > > almost the same and disable_irq() could have the sync_irq optimization
> > > > as well.
> > > 
> > > Thought more about that. Avoiding the sync_irq() for irqs which have
> > > no action associated is fine, but you need to catch the following case
> > > as well:
> > > 
> > >    driver code calls disable_irq_nosyc() from the handler (which is
> > >    still running)
> > > 
> > >    suspend code skips the sync due to depth > 0
> > > 
> > > The sync operation is not that expensive.
> > 
> > OK, what about this (untested, irrelevant parts skipped)?
> 
> Well, I guess I need to assume that no reaction means it's fine. ;-)
> 
> Below is the complete patch.  Thomas, Ingo, please let me know 
> it it is fine with you.

looks good - but you sure want to split it up some more, right?

> 13 files changed, 195 insertions(+), 47 deletions(-)

We want the non-intrusive 'add new APIs' bits [which give most 
of the linecount] separated from the 'all hell breaks lose' 
functional changes ;-) Makes it easier to revert, bisect, etc.

	Ingo
