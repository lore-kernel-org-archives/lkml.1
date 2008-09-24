Return-Path: <linux-kernel-owner+w=401wt.eu-S1755182AbYIXUre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182AbYIXUre (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752721AbYIXUrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:47:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47593 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbYIXUrU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:47:20 -0400
Date: Wed, 24 Sep 2008 16:47:17 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809241637400.6759@gandalf.stny.rr.com>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com> <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 24 Sep 2008, Linus Torvalds wrote:

> 
> 
> On Wed, 24 Sep 2008, Steven Rostedt wrote:
> 
> > I will now have a ring_buffer API, which will do basic recording. It will 
> > have two modes when allocated. Fixed sized entry mode where you can just 
> > put whatever you want in (I'm still aligning everything by 8 bytes, just 
> > since memory is cheap). Or you can have variable length mode that will 
> > make the following event header:
> > 
> > struct {
> > 	unsigned char length;
> > 	unsigned char buff[];
> > };
> 
> So the only reason I'm not thrilled with this is that I really think that 
> timestamping should be inherent, and at the lowest level.

OK, then how about this?

Each page will start with a time stamp (I'm still aligning everything by 8 
bytes, just because it simplifies things). Then we can have a 3 byte
(24 bit) counter offset? Then we can have a header that looks like:

struct {
	unsigned char time[3];
	unsigned char length;
	unsigned char buff[];
};

This still allows me to have the 2048 byte size buffer.

Or is 24 bits for time too small? The offest will be from the previous
entry, and not the beginning of the page.

If one defines a fixed size entry, we could just use the full 32 bits for 
the timestamp, since the length will be ignored in that case, and will 
become part of the buffer.

Hence,

struct {
	unsigned int time;
	unsigned char length;
	unsigend char buff[];
};



> 
> Without timestamping, what's the real point? EVERYBODY eventually wants a 
> timestamp. We added it even to the kernel printk()'s. People want them for 
> network packets to user space. X wants it for all its events. It's one of 
> those things that people never do from the beginning, but that everybody 
> eventually wants anyway.

OK, I'll hack something up like this.

> 
> So I certainly don't mind layering, but I *do* mind it if it then means 
> that some people will use a broken model and not have timestamps. So I 
> think the timestamping code should just be there - without it, a trace 
> buffer is pointless.

OK, the bottom layer will have some kind of timestamps. Now we only need 
to agree on what the header will look like.

Thanks,

-- Steve

