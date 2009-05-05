Return-Path: <linux-kernel-owner+w=401wt.eu-S1757304AbZEEHmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304AbZEEHmc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 03:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbZEEHmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 03:42:23 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:58499 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752000AbZEEHmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 03:42:23 -0400
Date: Tue, 5 May 2009 09:42:11 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: Re: perf_counter: resetting a event counter
Message-ID: <20090505074211.GA18437@elte.hu>
References: <49FF68EF.40300@linux.vnet.ibm.com> <20090505065206.GB27191@elte.hu> <1241508860.11059.24.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1241508860.11059.24.camel@twins>
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


* Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> On Tue, 2009-05-05 at 08:52 +0200, Ingo Molnar wrote:
> > * Corey Ashford <cjashfor@linux.vnet.ibm.com> wrote:
> > 
> > > Hi,
> > >
> > > In implementing the PAPI_reset function, whose purpose is to reset 
> > > all of the counters in an event set, I found that [it appears] 
> > > there is no straight-forward way to implement this function using 
> > > "Performance Couunters for Linux".  My current implementation just 
> > > closes the counters and reopens them again.  This is not a elegant 
> > > solution, nor is the other alternative that occurred to me: 
> > > maintain a "virtual" counter in user space, maintained using a 
> > > base count, which is subtracted off of the current perf_counter 
> > > value of a particular counter.
> > >
> > > Is there a way that I missed to reset an event counter?  If not, 
> > > I'd like to request that a new ioctl command be added to support 
> > > this ability.
> > 
> > We already have such ioctl actions:
> > 
> >         case PERF_COUNTER_IOC_ENABLE:
> >         case PERF_COUNTER_IOC_DISABLE:
> >         case PERF_COUNTER_IOC_REFRESH:
> > 
> > It would be a pretty natural addition to also have a reset method 
> > there. Would you like to take a stab at it and send a patch? A 
> > first-level approximation would be to do something like:
> > 
> > 	perf_counter_disable(counter);
> > 	atomic64_set(&counter->count, 0);
> > 	perf_counter_enable(counter);
> > 
> > btw, the reset code should probably take the counter->mutex lock as 
> > well, because parallel resets done from multiple contexts are 
> > otherwise not well-defined.
> 
> I would suggest simply bailing when the counter is active when 
> trying to reset if anything.
> 
> A plain: atomic64_set(&counter->count, 0), sounds attractive too.
> 
> The trouble with putting in those disable/enable calls is that you 
> cannot use the ioctl on an already disabled call, since it will 
> immediately enable it. Also, using it on an active counter is racy 
> in nature so the disable/enable cycle (or the proposed mutex) 
> doesn't buy you anything.

Yes, it all seems a bit racy - but straightforward.

I dont think we should restrict the ioctl to disabled state alone - 
we should disable it if it's not disabled - reset the counter - then 
re-enable-it if it was enabled before.

Btw., hw_counter->prev_counter needs to be reset too (if it's a hw 
counter not a sw counter), right?

	Ingo
