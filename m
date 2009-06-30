Return-Path: <linux-kernel-owner+w=401wt.eu-S1756959AbZF3Wre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756959AbZF3Wre (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 18:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755640AbZF3WrZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 18:47:25 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51495 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757581AbZF3WrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 18:47:24 -0400
Date: Wed, 1 Jul 2009 00:47:04 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
	multiple events in one shot
Message-ID: <20090630224704.GJ1241@elte.hu>
References: <1246051927.2988.10.camel@hpdv5.satnam> <1246051996.2988.12.camel@hpdv5.satnam> <20090627163821.GA17638@elte.hu> <1246129498.32198.27.camel@hpdv5.satnam> <20090628132926.GD31988@elte.hu> <1246202166.2982.8.camel@hpdv5.satnam> <20090629035708.GD8059@elte.hu> <1246351114.2476.38.camel@ht.satnam> <20090630095738.GD6942@elte.hu> <1246368165.2434.1.camel@ht.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246368165.2434.1.camel@ht.satnam>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-06-30 at 11:57 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Mon, 2009-06-29 at 05:57 +0200, Ingo Molnar wrote:
> > > 
> > > > The above patterns i suggested _already cover_ 'multiple events'.
> > > > 
> > > > We might define further aliases like:
> > > > 
> > > > 	all := "*"
> > > >         all-sw := "sw-*"
> > > > 
> > > > but it should all be in terms of patterns and regular 
> > > > expressions, not via some hardcoded special-case thing as your 
> > > > posted patches did.
> > > > 
> > > 
> > > It seems to me very confusing and needs lot of book-keeping and 
> > > need to rewrite whole tools/perf/util/parse-events.c because :
> > > 
> > > * means all perf_event_types :
> > > 	PERF_TYPE_HARDWARE,
> > >         PERF_TYPE_SOFTWARE,
> > >         PERF_TYPE_TRACEPOINT,
> > >         PERF_TYPE_HW_CACHE,
> > >         PERF_TYPE_RAW
> > > 
> > > hw-* means all hardware events :
> > > 	PERF_TYPE_HARDWARE,
> > >         PERF_TYPE_HW_CACHE,
> > >         PERF_TYPE_RAW
> > > 
> > > sw-* means all software events :
> > >         PERF_TYPE_SOFTWARE,
> > >         PERF_TYPE_TRACEPOINT
> > > 
> > > *cache* means all cache based events :
> > > 	PERF_COUNT_CACHE_REFERENCES, 	/* Generalized H/W */
> > > 	PERF_COUNT_CACHE_MISSES,	/* Generalized H/W */
> > >         PERF_TYPE_HW_CACHE,		/* Generalized Cache */
> > > 
> > > *write* means all write based events :
> > > 	(L1D,       WRITE,          ACCESS),
> > > 	(L1D,       WRITE,          MISS),
> > > 	(LL,        WRITE,          ACCESS),
> > > 	(LL,        WRITE,          MISS),
> > > 	(DTLB,      WRITE,          ACCESS),
> > > 	(DTLB,      WRITE,          MISS)
> > > 
> > > Please let me know why it looks complex to me, is it really 
> > > complex or I am going in wrong direction.
> > 
> > It would certainly need some reorganization of the code but the end 
> > result would be more flexible and other places could use it too, for 
> > example:
> > 
> > 	perf test -e hw-*
> > 
> > would test all (known) hardware counters.
> > 
> 
> Its true.
> 
> Can you please verify that the assumptions I made above are 
> correct.

Well, the right way to approach this is to assign each event a "full 
name" and a list of aliases/shortcuts (like we have now), and then 
do pattern matching on the full name.

So we'd have full/long event names like:

  hw-cycles
  hw-instructions
  hw-l1-cache-load-misses
  sw-minor-page-faults
  ...

to implement regex patterns over these, no event specific knowledge 
should be put into the pattern matching engine itself - it just 
blindly goes over the full names as strings.

As long as the full names are unique and structured well, this will 
work fine. The only non-trivial piece of restructuring is to make it 
easy for the pattern matching engine to iterate over all events. 
Right now they are in separate tables - perhaps they should be 
collected into a single table or so.

	Ingo
