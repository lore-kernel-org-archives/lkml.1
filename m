Return-Path: <linux-kernel-owner+w=401wt.eu-S1756521AbZF2D5p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521AbZF2D5p (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 23:57:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751915AbZF2D5i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 23:57:38 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60271 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751906AbZF2D5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 23:57:38 -0400
Date: Mon, 29 Jun 2009 05:57:08 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3 -tip] perf_counter tools: Add support to set of
	multiple events in one shot
Message-ID: <20090629035708.GD8059@elte.hu>
References: <1246051852.2988.8.camel@hpdv5.satnam> <1246051927.2988.10.camel@hpdv5.satnam> <1246051996.2988.12.camel@hpdv5.satnam> <20090627163821.GA17638@elte.hu> <1246129498.32198.27.camel@hpdv5.satnam> <20090628132926.GD31988@elte.hu> <1246202166.2982.8.camel@hpdv5.satnam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246202166.2982.8.camel@hpdv5.satnam>
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

> On Sun, 2009-06-28 at 15:29 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > On Sat, 2009-06-27 at 18:38 +0200, Ingo Molnar wrote:
> > > > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > > > 
> > > > > Add support for HARDWARE and SOFTWARE events :
> > > > >  perf stat -e all-sw-events
> > > > >  perf stat -e sw-events
> > > > >  perf stat -e all-hw-events
> > > > >  perf stat -e hw-events
> > > > 
> > > > > +static struct event_type_symbol event_type_symbols[] = {
> > > > > + [PERF_TYPE_HARDWARE]	= { "hw-events",	"all-hw-events",	},
> > > > > + [PERF_TYPE_SOFTWARE]	= { "sw-events",	"all-sw-events",	},
> > > > 
> > > > Hm, this really just special-cases and open-codes these. The better 
> > > > solution is what i suggested in my review of your prior patches: 
> > > > regex pattern matching.
> > > > 
> > > 
> > > parse_events() is responsible to parse events for 'perf stat -e' 
> > > and it is parsing by parse_event_symbol()
> > > 
> > > If you want to use regex pattern matching then either we should 
> > > make some another option or if we need to rewrite 
> > > parse_event_symbol to use regex pattern matching which will be 
> > > applicable to all the events.
> > 
> > As i mentioned it before, i think the most intuitive solution is to 
> > extend the --event syntax with regex patterns. No new option - just 
> > richer -e syntax.
> > 
> > We could have this syntax:
> > 
> >   hw-cpu-cycles
> >   hw-instructions
> >   hw-cache-references
> >   hw-cache-misses
> >   hw-branch-instructions
> >   hw-branch-misses
> >   hw-bus-cycles
> > 
> >   sw-cpu-clock
> >   sw-task-clock
> >   sw-page-faults
> >   sw-minor-faults
> >   sw-major-faults
> >   sw-context-switches
> >   sw-cpu-migrations
> > 
> > regex patterns like:
> > 
> >   hw-*
> >   sw-*
> >   *
> > 
> > the first one would select all hardware events - the second all 
> > software events - the third all events in general. But other regex 
> > patterns make sense too, like:
> > 
> >   *branch*
> >   *cache*
> >   *fault*
> > 
> > And as the number of generic events increases, so will regex 
> > patterns become more and more useful.
> > 
> 
> This is a good approach, but this should be done separately 
> because these will effect all the events.
> 
> Currently I send patches to support multiple events in one shot 
> which is adding new feature.
> 
> And you telling to use regex wildcard for all the events in 
> parse_event_symbol() which is enhancement and should be done in 
> series of patches.

The above patterns i suggested _already cover_ 'multiple events'.

We might define further aliases like:

	all := "*"
        all-sw := "sw-*"

but it should all be in terms of patterns and regular expressions, 
not via some hardcoded special-case thing as your posted patches 
did.

	Ingo
