Return-Path: <linux-kernel-owner+w=401wt.eu-S1752354AbZJVFFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354AbZJVFFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 01:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751582AbZJVFFg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 01:05:36 -0400
Received: from ozlabs.org ([203.10.76.45]:40421 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440AbZJVFFf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 01:05:35 -0400
Date: Thu, 22 Oct 2009 16:00:44 +1100
From: Anton Blanchard <anton@samba.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
       fweisbec@gmail.com, acme@redhat.com
Subject: Re: [PATCH] perf record: Enable PERF_SAMPLE_ID when sampling
	multiple events
Message-ID: <20091022050044.GX4808@kryten>
References: <20091021061925.GW4808@kryten> <20091021115935.GH16586@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091021115935.GH16586@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Ingo,

> > If we are sampling multiple events we need the id in each sample so we 
> > can differentiate between them in a perf data file.
> 
> Wondering, what are you (or will you be) using this for?

I put together a simple python library for parsing perf.data files:

http://ozlabs.org/~anton/junkcode/perf_event.py

An example of using it is here:

http://ozlabs.org/~anton/junkcode/perf_event_example.py

Only tested on powerpc so far, but it should work on x86. It's still
missing bits but it has been useful for finding some corner cases in
perf_event. It should also make it easy to post process complex profiles with
multiple events in them.

One problem this has just found though, is with PERF_EVENT_SAMPLE:

	# FIXME: If sampling multiple events we have an issue
	# here. Since the SAMPLE_ID is not the first optional field
	# it might be impossible to differentiate between
	# events since the SAMPLE_ID field would be at different
	# offsets. For now we assume all events use the same
	# set of optional fields.
	eventnr = 0
	self.event = sample_event(eventbuf,
			self.header.attrs[eventnr].sample_type)

It seems like the API allows us to specify different sample options for
different events, but since the ID isnt the first option it could end up
in different places in different events, making it difficult (if not
impossible in some cases) to tag events correctly.

Anton
