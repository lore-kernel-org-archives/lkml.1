Return-Path: <linux-kernel-owner+w=401wt.eu-S1755257AbYIXQ4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbYIXQ4l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 12:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbYIXQ43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 12:56:29 -0400
Received: from smtp-out.google.com ([216.239.33.17]:14814 "EHLO
	smtp-out3.google.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752699AbYIXQ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 12:56:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=JsZ2P2LlwN7tIClVgz66PnrtHEkDMufLwAHb7C3I4dmWg+jN3Ge49yuwRG5mjIwan
	CtU9UB2rjkZsuop3iZrAA==
Message-ID: <33307c790809240956o6552e570vaf4adb3b7e1b2415@mail.gmail.com>
Date: Wed, 24 Sep 2008 09:56:20 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Peter Zijlstra" <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.DEB.1.10.0809241231520.5017@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0809240921430.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241231520.5017@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Most people will want the events to be as _small_ as humanly possible. The
>> normal event size should hopefully be in the 8-16 bytes, and I think the
>> RFC patch is already broken because it allocates that insane 64-bit event
>> counter for things. Who the hell wants a 64-bit event counter that much?
>> That's broken.
>
> The event counter is just the timestamp (quick patch, simple to fix). The
> term "counter" was bad. It should have been timestamp, which one would
> want a 64bit timestamp. Or at least a way to figure it out. Yes, we can
> store a special event called "timestamp" and have a smaller counter. But
> for simplicity, the 64 bit was easy. The event id was just 16 bits, which
> I think is way more than enough.

Yup, is just a confusing name. we can definitely make this a smaller field
by doing an offset time from the last event, but we agreed on 64 bits to
keep version 1 simple ;-)

I think in retrospect the timestamp events we used with wall time stuck
in them were a mistake, as NTP will make them difficult. We should have
just recorded wall time at the start of the buffer, and done offsets from
there.

Without relayfs subbuffers, the offset thing gets trickier, as you'd have
to update the "start time" constantly once you'd filled the buffer and
were shifting the start pointer. OTOH, I guess it's only 1 cacheline.

M.
