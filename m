Return-Path: <linux-kernel-owner+w=401wt.eu-S1760909AbZLKHyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760909AbZLKHyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 02:54:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934847AbZLKHyl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 02:54:41 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50757 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760691AbZLKHyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 02:54:36 -0500
Date: Fri, 11 Dec 2009 08:54:08 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Dave Chinner <david@fromorbit.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Zhang Rui <rui.zhang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Lachlan McIlroy <lachlan@sgi.com>
Subject: Re: spinlock in completion_done() (was: Re: Async resume patch (was:
 Re: [GIT PULL] PM updates for 2.6.33))
Message-ID: <20091211075408.GB31149@elte.hu>
References: <Pine.LNX.4.44L0.0912081633540.3046-100000@iolanthe.rowland.org>
 <200912082248.14138.rjw@sisk.pl>
 <20091209092922.GC28428@elte.hu>
 <200912092337.52492.rjw@sisk.pl>
 <20091210075947.GD25549@elte.hu>
 <20091211041041.GJ30608@discord.disaster>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091211041041.GJ30608@discord.disaster>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dave Chinner <david@fromorbit.com> wrote:

> On Thu, Dec 10, 2009 at 08:59:47AM +0100, Ingo Molnar wrote:
> > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > On Wednesday 09 December 2009, Ingo Molnar wrote:
> > > > * Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > > > On Tuesday 08 December 2009, Alan Stern wrote:
> > > > > > On Tue, 8 Dec 2009, Rafael J. Wysocki wrote:
> > > > > > 
> > > > > > > BTW, is there a good reason why completion_done() doesn't use spin_lock_irqsave
> > > > > > > and spin_unlock_irqrestore?  complete() and complete_all() use them, so why not
> > > > > > > here?
> > > > > > 
> > > > > > And likewise in try_wait_for_completion().  It looks like a bug.  Maybe 
> > > > > > these routines were not intended to be called with interrupts disabled, 
> > > > > > but that requirement doesn't seem to be documented.  And it isn't a 
> > > > > > natural requirement anyway.
> 
> When I implemented them they were not called from anywhere that
> disabled interrupts.  IIRC the main reason I used spin_lock_irq()
> was because that is what wait_for_completion() used at the time....

Obviously wait_for_competion() as a non-atomic API that can block will 
(and should) use _irq() - but atomic variants (complete, but also the 
try-wait thing) use irqsafe methods. A fair portion of completions 
happen in IRQ context.

	Ingo
