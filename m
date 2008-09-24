Return-Path: <linux-kernel-owner+w=401wt.eu-S1754099AbYIXVSW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099AbYIXVSW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 17:18:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753207AbYIXVRz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 17:17:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:41582 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbYIXVRy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 17:17:54 -0400
Date: Wed, 24 Sep 2008 17:17:52 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Martin Bligh <mbligh@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
Message-ID: <alpine.DEB.1.10.0809241712270.10631@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
  <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com>  <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org>  <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>  <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org> 
 <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com> <33307c790809241403w236f2242y18ba44982d962287@mail.gmail.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Martin Bligh wrote:
> 
> How about we just steal 5 bits from the timestamp to indicate event
> lengths up to 32 bytes, and if it's 0, that means there's a length
> field following? Also that'd mean you could use a longer length field
> and get beyond 256 bytes to 4096, without impacting most events.
> 
> struct {
>         u32 length:5, time_delta:27;

I think you mean this is where length == 0 ;-)

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
> 

OK then. Since I like the idea of aligning the buffer to 8 bytes, we can 
always shift the length field by 3. So...

For records 256 bytes or less, we only have:

struct {
	u32 length:5, time_delta: 27;
	u8 buf[];
};

For 257 bytes or more we have:

struct {
	u32 length:5 (=0), time_delta: 27;
	u16 large_length;
	u8 buf[];
};

This is what you want?

-- Steve

