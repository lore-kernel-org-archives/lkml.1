Return-Path: <linux-kernel-owner+w=401wt.eu-S1754955AbZFXIsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955AbZFXIsu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 04:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbZFXIsm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 04:48:42 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:55128 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbZFXIsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 04:48:40 -0400
Date: Wed, 24 Jun 2009 10:48:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2 -tip] perf_counter: parse-events.c introduce alias
	member in event_symbol
Message-ID: <20090624084825.GB18713@elte.hu>
References: <1245669194.17153.6.camel@localhost.localdomain> <1245669268.17153.8.camel@localhost.localdomain> <20090622113256.GA22479@elte.hu> <1245675657.7537.3.camel@localhost.localdomain> <20090622141009.GB6486@elte.hu> <1245700551.6167.5.camel@localhost.localdomain> <20090623082411.GC11181@elte.hu> <1245765732.3776.17.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1245765732.3776.17.camel@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:

> On Tue, 2009-06-23 at 10:24 +0200, Ingo Molnar wrote:
> > * Jaswinder Singh Rajput <jaswinder@kernel.org> wrote:
> > 
> > > 
> > > perf test also need some command to execute otherwise it will also 
> > > show long list of <inactive>
> > 
> > I think what it should do is to execute test-cases _internally_. Not 
> > just execute some random command on the system and hope for events.
> 
> Can you suggest some good test cases where we can get numbers for 
> almost all the events on each and every run.

the testcases should be specific to the counter type. Some counters 
are easy (such as cycles or instructions - you in fact cannot even 
get zero out of them even if you tried) - some are harder - such as 
migrations, or cache-misses or page-faults.

Small functions that trigger them for sure would do the trick. For 
example, to provoke a minor page fault:

static void trigger_minor_page_fault(void)
{
	void *page;

	page = mmap(0, PAGE_SIZE, PROT_READ|PROT_WRITE, MAP_ANONYMOUS, -1, 0);

	/* Clearing the page will trigger a minor fault: */
	memset(page, 0, PAGE_SIZE);

	munmap(page, PAGE_SIZE);
}

These small test-functions should be attached to the event array as 
function pointers - hence the generic testing code would just do a 
->event.trigger_event() callback, it wouldnt need to know much about 
the event itself.

> > >  context-switches                                         7956
> > >  CPU-migrations                                              7
> > 
> > this needs to be provoked intentionally via sched_setaffinity(): 
> > first migrate to cpu0, then to cpu1.
> 
> There should be some option from user or we test it each time.

If this is builtin-test.c - then yes, testing it all the time would 
be a good default. (there might be other aspects of testing that 
would require options to this command in the future.)

	Ingo
