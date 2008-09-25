Return-Path: <linux-kernel-owner+w=401wt.eu-S1755934AbYIYRcH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934AbYIYRcH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 13:32:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752892AbYIYRbz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 13:31:55 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41436 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752407AbYIYRby (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 13:31:54 -0400
Date: Thu, 25 Sep 2008 10:29:57 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <compudj@krystal.dyndns.org>
cc: Martin Bligh <mbligh@google.com>, Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, prasad@linux.vnet.ibm.com,
       "Frank Ch. Eigler" <fche@redhat.com>, David Wilder <dwilder@us.ibm.com>,
       hch@lst.de, Tom Zanussi <zanussi@comcast.net>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [RFC PATCH 1/3] Unified trace buffer
In-Reply-To: <20080925171559.GB29392@Krystal>
Message-ID: <alpine.LFD.1.10.0809251025170.3265@nehalem.linux-foundation.org>
References: <20080924051400.195780424@goodmis.org> <1222268595.16700.149.camel@lappy.programming.kicks-ass.net> <33307c790809240847r31c8b683na15ff5488b60d25b@mail.gmail.com> <1222272686.16700.162.camel@lappy.programming.kicks-ass.net>
 <33307c790809240949i3026170i8f9ac1d67a0fcf00@mail.gmail.com> <alpine.LFD.1.10.0809241027251.3265@nehalem.linux-foundation.org> <33307c790809241054n47addd27hef90930f109599fd@mail.gmail.com> <alpine.LFD.1.10.0809241323590.3265@nehalem.linux-foundation.org>
 <20080924205334.GB12248@Krystal> <alpine.LFD.1.10.0809241458270.3265@nehalem.linux-foundation.org> <20080925171559.GB29392@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Sep 2008, Mathieu Desnoyers wrote:
> 
> We could use a page header instead to contain the "unused_size"
> information.

Absolutely. There's no one way to do this.

> I would prefer to put the extended timestamp within the event header
> instead of creating a separate entry for this for atomicity concerns
> (what happens if a long interrupt executes between the TSCExtend marker
> event and the event expecting to be written right next to it ?).

The log entries should be reserved with interrupts disabled anyway, and 
they are per-CPU, so there are no atomicity issues.

For NMI's, things get more exciting. I'd really prefer NMI's to go to a 
separate ring buffer entirely, because otherwise consistency gets really 
hard. Using lockless algorithms for a variable-sized pool of pages is a 
disaster waiting to happen.

I don't think we can currently necessarily reasonably trace NMI's, but 
it's something to keep in mind as required support eventually.

		Linus
