Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYIYRrU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYIYRrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:47:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYIYRrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:47:09 -0400
Received: from tomts20-srv.bellnexxia.net ([209.226.175.74]:59903 "EHLO
	tomts20-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751672AbYIYRrI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:47:08 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApsEANVl20hMQWq+/2dsb2JhbACBXrlTgWU
Date: Thu, 25 Sep 2008 13:42:06 -0400
From: Mathieu Desnoyers <compudj@krystal.dyndns.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
Message-ID: <20080925174206.GE29392@Krystal>
References: <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net> <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org> <20080924205334.GB12248@Krystal> <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org> <20080925171559.GB29392@Krystal> <alpine.LFD.1.10.0809251025170.3265@nehalem.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0809251025170.3265@nehalem.linux-foundation.org>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 13:35:46 up 112 days, 22:16, 10 users,  load average: 4.06, 2.44,
	1.94
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> 
> 
> On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:
> > 
> > We could use a page header instead to contain the "unused_size"
> > information.
> 
> Absolutely. There's no one way to do this.
> 
> > I would prefer to put the extended timestamp within the event header
> > instead of creating a separate entry for this for atomicity concerns
> > (what happens if a long interrupt executes between the TSCExtend marker
> > event and the event expecting to be written right next to it ?).
> 
> The log entries should be reserved with interrupts disabled anyway, and 
> they are per-CPU, so there are no atomicity issues.
> 

I actually do use a lockless algorithm in LTTng and don't have to
disable interrupts around tracing. This is how I get the kind of
performance the Google folks expect. I would recommend to stay with
interrupt disable + per-cpu spinlock (slow and heavy locking) for v1,
but to keep in mind that we might want to go for a more lightweight
locking scheme in v2.

> For NMI's, things get more exciting. I'd really prefer NMI's to go to a 
> separate ring buffer entirely, because otherwise consistency gets really 
> hard. Using lockless algorithms for a variable-sized pool of pages is a 
> disaster waiting to happen.
> 

LTTng does it, no disaster happened in the past 2-3 years. :)

I guess we could manage to deal with NMI tracing specfically using the
in_nmi() helpers.

> I don't think we can currently necessarily reasonably trace NMI's, but 
> it's something to keep in mind as required support eventually.
> 

NMI tracing is a nice-to-have (and lttng does provide it), but the core
thing is really performance; disabling interrupts happens to be fairly
slow on many architectures.

Mathieu

> 		Linus
> 

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
