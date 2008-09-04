Return-Path: <linux-kernel-owner+w=401wt.eu-S1754824AbYIDQOz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824AbYIDQOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:14:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752326AbYIDQOn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:14:43 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55735 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750941AbYIDQOm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:14:42 -0400
Date: Thu, 4 Sep 2008 18:14:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Matthew Wilcox <matthew@wil.cx>
Cc: Peter Zijlstra <peterz@infradead.org>, Linus Torvalds <torvalds@osdl.org>,
       Andrew Morton <akpm@osdl.org>,
       Ben Hutchings <bhutchings@solarflare.com>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, linux-pci@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: [PATCH] Return value from schedule()
Message-ID: <20080904161424.GA23042@elte.hu>
References: <20080827204626.4b65862f@extreme> <20080828111323.GI7908@solarflare.com> <20080903155713.7fab2e19@extreme> <20080904160739.GK2772@parisc-linux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080904160739.GK2772@parisc-linux.org>
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


* Matthew Wilcox <matthew@wil.cx> wrote:

> In some circumstances, you want to wait for an event to happen.  let's 
> assume that it's a hardware event, so you can't just add a notifier of 
> some kind, you have to poll.  Here's an example:
> 
> On Wed, Sep 03, 2008 at 03:57:13PM -0700, Stephen Hemminger wrote:
> >  			return -ETIMEDOUT;
> > -		udelay(10);
> > +		if (signal_pending(current))
> > +			return -EINTR;
> > +		schedule();
> 
> If there's no other task ready to run, schedule() could return in much
> less than 10 microseconds (actually, it could return in much less than
> 10 microseconds even if another task does run, but let's ignore that case).
> 
> If schedule() returned whether or not it had scheduled another task, we
> could do something like:
> 
> 		if (!schedule())
> 			udelay(10);

hm, i'm not really sure - this really just seems to be a higher prio 
variant of yield() combined with some weird code. Do we really want to 
promote such arguably broken behavior? If there's any chance of any 
polling to take a material amount of CPU time it should be event driven 
to begin with.

	Ingo
