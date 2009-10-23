Return-Path: <linux-kernel-owner+w=401wt.eu-S1751910AbZJWGSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbZJWGSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 02:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751775AbZJWGSf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 02:18:35 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43552 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083AbZJWGSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 02:18:34 -0400
Date: Fri, 23 Oct 2009 08:18:27 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Anton Blanchard <anton@samba.org>, Tom Zanussi <tzanussi@gmail.com>
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, acme@redhat.com
Subject: Re: [PATCH] perf record: Enable PERF_SAMPLE_ID when sampling
	multiple events
Message-ID: <20091023061827.GA1389@elte.hu>
References: <20091021061925.GW4808@kryten> <20091021115935.GH16586@elte.hu> <20091022050044.GX4808@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091022050044.GX4808@kryten>
User-Agent: Mutt/1.5.19 (2009-01-05)
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


* Anton Blanchard <anton@samba.org> wrote:

> 
> Hi Ingo,
> 
> > > If we are sampling multiple events we need the id in each sample so we 
> > > can differentiate between them in a perf data file.
> > 
> > Wondering, what are you (or will you be) using this for?
> 
> I put together a simple python library for parsing perf.data files:
> 
> http://ozlabs.org/~anton/junkcode/perf_event.py
> 
> An example of using it is here:
> 
> http://ozlabs.org/~anton/junkcode/perf_event_example.py
> 
> Only tested on powerpc so far, but it should work on x86. It's still 
> missing bits but it has been useful for finding some corner cases in 
> perf_event. It should also make it easy to post process complex 
> profiles with multiple events in them.

Ah, cool!

Note, there's a related development: we are working on script extensions 
to perf, in a built-in way. It can be found in this patch series from 
Tom on lkml:

  [RFC][PATCH 0/9] perf trace: support for general-purpose scripting

Tom started with Perl support - Python could be another script engine to 
add.

Now, your perf_event_example.py library goes deeper and exposes the 
perf.data itself as an independent codepath. I _think_ Tom's approach 
gives us a bit of an extra value by allowing us to tweak the environment 
of scripts with each perf version - i.e. we can iterate the perf.data 
format in the future without breaking scripts.

We are not ready yet to declare perf.data an ABI, and there's a few 
changes in tip:perf/* that might break the python library.

Also, as your fix demonstrates it, there's extra value in going 
ab-initio as well. Just wanted to mention the scripting engine work to 
couple perf with scriptlets, in case you find it interesting. We could 
easily do both.

> One problem this has just found though, is with PERF_EVENT_SAMPLE:
> 
> 	# FIXME: If sampling multiple events we have an issue
> 	# here. Since the SAMPLE_ID is not the first optional field
> 	# it might be impossible to differentiate between
> 	# events since the SAMPLE_ID field would be at different
> 	# offsets. For now we assume all events use the same
> 	# set of optional fields.
> 	eventnr = 0
> 	self.event = sample_event(eventbuf,
> 			self.header.attrs[eventnr].sample_type)
> 
> It seems like the API allows us to specify different sample options 
> for different events, but since the ID isnt the first option it could 
> end up in different places in different events, making it difficult 
> (if not impossible in some cases) to tag events correctly.

Could we fix this bug at the kernel level somehow, to imply SAMPLE_ID 
automatically? Producing a stream of data that cannot be decoded in some 
cases does not look smart.

	Ingo
