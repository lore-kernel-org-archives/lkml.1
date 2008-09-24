Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbYIXReS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbYIXReS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 13:34:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751741AbYIXReG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 13:34:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40990 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbYIXReF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 13:34:05 -0400
Date: Wed, 24 Sep 2008 10:25:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
cc: Peter Zijlstra <peterz@infradead.org>, Martin Bligh <mbligh@google.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <alpine.DEB.1.10.0809241231520.5017@gandalf.stny.rr.com>
Message-ID: <alpine.LFD.1.10.0809241014250.3265@nehalem.linux-foundation.org>
References: <20080924051056.650388887@goodmis.org>  <20080924051400.195780424@goodmis.org>  <1222268595.16700.149.camel@lappy.programming.kicks-ass.net>  <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <alpine.LFD.1.10.0809240921430.3265@nehalem.linux-foundation.org> <alpine.DEB.1.10.0809241231520.5017@gandalf.stny.rr.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 24 Sep 2008, Steven Rostedt wrote:
> 
> The event counter is just the timestamp (quick patch, simple to fix). The 
> term "counter" was bad. It should have been timestamp, which one would 
> want a 64bit timestamp.

One definitely would _not_ want the full 64-bit timestamp.

There are two cases:

 - lots and lots of events

   just do a 32 bit "timestamp delta" to the previous packet (where the 
   first packet in the queue would be a delta from a value in the queue 
   header - and we can obviously make that value be the TSC so that the 
   first delta is always zero, but it may also make sense to make it a 
   real delta, and the queue header would contain some good 
   synchronization point value).

 - occasional events

   Oops. The delta wouldn't fit. So create a new "timestamp update" packet 
   with a 64-bit thing when doing the reservation. There's obviously no 
   cost issue (since this would only happen for things where there was a 
   multi-second delay - or at least an appreciable fraction of a delay - 
   between events)

This definitely is worth doing. If we have small trace objects (and many 
things really do have pretty small traces), using just a 32-bit TSC not 
only saves 4 bytes per trace event, but it makes it quite reasonable to 
keep the trace data 4-byte-aligned rather than requiring 8-byte alignment.

Of course, if the traces end up being horribly bloated, none of that will 
matter. But I really would hope that you we keep the header itself to just 
8 bytes (and being 2 4-byte entities), so that small payloads are 
reasonable. And that looks doable, if you have a 16-bit "type" and a 
16-bit "size" field.

One thing I'd like to do is to also architecturally reserve a few of the 
types for internal queue management stuff. Things like "padding" objects 
(or a "end-of-ringbuffer" object), and the TSC overflow object, and a 
"time sync" object (or heartbeat). So maybe the type would have the high 
bit set as a "reserved for internal ringbuffer use" or whatever.

			Linus
