Return-Path: <linux-kernel-owner+w=401wt.eu-S1754756AbYIYP0V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbYIYP0V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:26:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754098AbYIYP0B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:26:01 -0400
Received: from smtp-out.google.com ([216.239.33.17]:5384 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225AbYIYP0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:26:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=mcRE7zD1uMU0Mx3OCAUBTu1t/j06jwWJqCu0hGcH057bG/nJ/Eg9KjtIVtK3vE6GX
	xSipfXnH9KK8yM8ARVxMw==
Message-ID: <33307c790809250825u567d3680w682899c111e10ed6@mail.gmail.com>
Date: Thu, 25 Sep 2008 08:25:39 -0700
From: "Martin Bligh" <mbligh@google.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Cc: "Peter Zijlstra" <peterz@infradead.org>,
       "Martin Bligh" <mbligh@mbligh.org>,
       "Steven Rostedt" <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Mathieu Desnoyers" <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       "David Wilder" <dwilder@us.ibm.com>, hch@lst.de,
       "Tom Zanussi" <zanussi@comcast.net>,
       "Steven Rostedt" <srostedt@redhat.com>
In-Reply-To: <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080924051056.650388887@goodmis.org>
	 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
	 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
	 <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>
	 <8f3aa8d60809250733q70561e6agfa3b00da83773e9f@mail.gmail.com>
	 <1222354409.16700.215.camel@lappy.programming.kicks-ass.net>
	 <alpine.LFD.1.10.0809250758400.3265@nehalem.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Right - if you use raw tsc you're dependent on clock speed, if we'd
>> normalize that on ns instead you'd need at least: [...]
>
> Please don't normalize to ns.
>
> It's really quite hard, and it's rather _expensive_ on many CPU's. It
> involves a non-constant 64-bit divide, after all. I bet it can be
> optimized to be a multiply-by-inverse instead, but it would be a 128-bit
> (or maybe just 96-bit?) multiply, and the code would be nasty, and likely
> rather more expensive than the TSC reading itself.
>
> Sure, you have to normalize at _some_ point, and normalizing early might
> make some things simpler, but the main thing that would become easier is
> people messing about in the raw log buffer on their own directly, which
> would hopefully be something that we'd discourage _anyway_ (ie we should
> try to use helper functions for people to do things like "get the next
> event data", not only because the headers are going to be odd due to
> trying to pack things together, but because maybe we can more easily
> extend on them later that way when nobody accesses the headers by hand).
>
> And I don't think normalizing later is in any way more fundamentally hard.
> It just means that you do part of the expensive things after you have
> gathered the trace, rather than during.

Agree with you on doing the expensive stuff later. If we wanted to get
something that'd pack down to a couple fewer bits, and approximate ns,
we could always >> 1 if you were > 2GHz, and >> 2 if you where > 4GHz,
etc. which is at least cheap.

But do we really need more than 3 bits for size anyway? 28 bytes
would fit most events such as system calls, interrupts, page faults,
all the common stuff.. Longer than that starts to be expensive
in memory consumption anyway, and if you're logging 32 bytes
or more ... 2 extra bytes for a length field is a small overhead to pay.

M.
