Return-Path: <linux-kernel-owner+w=401wt.eu-S1753887AbYIXUZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbYIXUZu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 16:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752136AbYIXUZm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 16:25:42 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57222 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752034AbYIXUZl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 16:25:41 -0400
Date: Wed, 24 Sep 2008 13:23:47 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809241313000.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com>  <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241340500.6759@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Steven Rostedt wrote:
> 
> Right now I have a list of pages that make up the ring buffer. Are you 
> saying that the first entry in the page should be a timestamp?

I think the most straightforward model would be that the "head" of the 
ring buffer (regardless of size in pages) would have that timestamp. 
Making them per-page is an option, of course, I have no strong opinions 
either way. The per-page one could have advantages (ie it would give a 
nice upper limit for just how many entries you have to walk in order to 
convert an entry into a full timestamp), but I certainly don't think 
that's a big decision, more of a detail.

But if we start out with having the full TSC in each entry, that's easily 
going to be painful to fix later. If we start out with a delta system, 
changing the details of where the base is gotten is likely to be exactly 
that - just a detail.

So I'd like the thing to have small headers, and be designed from the 
start to have small headers.

> I will now have a ring_buffer API, which will do basic recording. It will 
> have two modes when allocated. Fixed sized entry mode where you can just 
> put whatever you want in (I'm still aligning everything by 8 bytes, just 
> since memory is cheap). Or you can have variable length mode that will 
> make the following event header:
> 
> struct {
> 	unsigned char length;
> 	unsigned char buff[];
> };

So the only reason I'm not thrilled with this is that I really think that 
timestamping should be inherent, and at the lowest level.

Without timestamping, what's the real point? EVERYBODY eventually wants a 
timestamp. We added it even to the kernel printk()'s. People want them for 
network packets to user space. X wants it for all its events. It's one of 
those things that people never do from the beginning, but that everybody 
eventually wants anyway.

So I certainly don't mind layering, but I *do* mind it if it then means 
that some people will use a broken model and not have timestamps. So I 
think the timestamping code should just be there - without it, a trace 
buffer is pointless.

		Linus
