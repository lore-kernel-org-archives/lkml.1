Return-Path: <linux-kernel-owner+w=401wt.eu-S1754263AbYIYKma@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754263AbYIYKma (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 06:42:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbYIYKmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 06:42:21 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41666 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752910AbYIYKmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 06:42:20 -0400
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
From: Peter Zijlstra <peterz@infradead.org>
To: Martin Bligh <mbligh@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
References: <20080924051056.650388887@goodmis.org>
	 <20080924051400.195780424@goodmis.org>
	 <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>
	 <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
	 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>
	 <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
	 <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
	 <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
	 <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 25 Sep 2008 12:41:43 +0200
Message-Id: <1222339303.16700.197.camel@lappy.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-09-24 at 14:03 -0700, Martin Bligh wrote:
> > OK, then how about this?
> >
> > Each page will start with a time stamp (I'm still aligning everything by 8
> > bytes, just because it simplifies things). Then we can have a 3 byte
> > (24 bit) counter offset? Then we can have a header that looks like:
> >
> > struct {
> >        unsigned char time[3];
> >        unsigned char length;
> >        unsigned char buff[];
> > };
> >
> > This still allows me to have the 2048 byte size buffer.
> >
> > Or is 24 bits for time too small? The offest will be from the previous
> > entry, and not the beginning of the page.
> >
> > If one defines a fixed size entry, we could just use the full 32 bits for
> > the timestamp, since the length will be ignored in that case, and will
> > become part of the buffer.
> >
> > Hence,
> >
> > struct {
> >        unsigned int time;
> >        unsigned char length;
> >        unsigend char buff[];
> > };
> 
> How about we just steal 5 bits from the timestamp to indicate event
> lengths up to 32 bytes, and if it's 0, that means there's a length
> field following? Also that'd mean you could use a longer length field
> and get beyond 256 bytes to 4096, without impacting most events.
> 
> struct {
>         u32 length:5, time_delta:27;
>         u16 length;
>         u8 buf[];
> };
> 
> struct {
>         u32 length:5, time_delta:27;        /* where length == 0 */
>         u8 buf[];
> };
> 
> Obviously we could less than 5 bits, even just 1 for a flag ...

I rather like this idea, as it gives small entries (the common case) the
least overhead but does allow for larger ones.

By also putting the time in there you can do the merge sort iterator,
Linus was right that everybody wants this anyway.

As for delta encoding the time, we could make the tick log the absolute
time packet, that's at least 100Hz and it already has to compute the
full gtod thing anyway.

I don't much like Linus' idea of bringing type information back into the
primitive header (sorry Linus ;-)). I'd much rather keep that
abstraction in the next layer.

