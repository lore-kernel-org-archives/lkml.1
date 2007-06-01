Return-Path: <linux-kernel-owner+w=401wt.eu-S1763353AbXFAScV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763353AbXFAScV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 14:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761396AbXFAScN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 14:32:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51333 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761178AbXFAScM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 14:32:12 -0400
Date: Fri, 1 Jun 2007 20:30:53 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Daniel Walker <dwalker@mvista.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Jason Baron <jbaron@redhat.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/5] lockstat: core infrastructure
Message-ID: <20070601183053.GA30072@elte.hu>
References: <20070530132431.GA23947@elte.hu> <Pine.LNX.4.58.0705300936390.15841@gandalf.stny.rr.com> <20070530134907.GA27085@elte.hu> <1180544796.32594.184.camel@imap.mvista.com> <1180545380.2958.1.camel@lappy> <1180545913.32594.194.camel@imap.mvista.com> <20070601131249.GA17059@elte.hu> <1180711606.15884.32.camel@imap.mvista.com> <1180713154.5676.4.camel@lappy> <1180714263.15884.52.camel@imap.mvista.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1180714263.15884.52.camel@imap.mvista.com>
User-Agent: Mutt/1.5.14 (2007-02-12)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Daniel Walker <dwalker@mvista.com> wrote:

> > So, having two interfaces, one fast and one accurate is the right 
> > answer IMHO.
> 
> In the case of lockstat you have two cases fast and functional, and 
> non-functional .. Right now your patch has no slow and functional 
> state.

let me explain it to you:

1) there is absolutely no problem here to begin with. If a rare 
architecture is lazy enough to not bother implementing a finegrained 
sched_clock() then it certainly does not care about the granularity of 
lockstat fields either. If it does, it can improve scheduling and get 
more finegrained lockstat by implementing a proper sched_clock() 
function - all for the same price! ;-)

2) the 'solution' you suggested for this non-problem is _far worse_ than 
the granularity non-problem, on the _majority_ of server systems today! 
Think about it! Your suggestion would make lockstat _totally unusable_. 
Not "slow and functional" like you claim but "dead-slow and unusable".

in light of all this it is puzzling to me how you can still call Peter's 
code "non-functional" with a straight face. I have just tried lockstat 
with jiffies granular sched_clock() and it was still fully functional. 
So if you want to report some bug then please do it in a proper form.

> As I said before there is no reason why and architectures should be 
> forced to implement sched_clock() .. Is there some specific reason why 
> you think it should be mandatory?

Easy: it's not mandatory, but it's certainly "nice" even today, even 
without lockstat. It will get you:

 - better scheduling
 - better printk timestamps
 - higher-quality blktrace timestamps

With lockstat, append "more finegrained lockstat output" to that list of 
benefits too. That's why every sane server architecture has a 
sched_clock() implementation - go check the kernel source. Now i wouldnt 
mind to clean the API up and call it get_stat_clock() or whatever - but 
that was not your suggestion at all - your suggestion was flawed: to 
implement sched_clock() via the GTOD clocksource.

	Ingo
