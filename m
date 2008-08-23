Return-Path: <linux-kernel-owner+w=401wt.eu-S1755291AbYHWVlu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291AbYHWVlu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2008 17:41:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753462AbYHWVln
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Aug 2008 17:41:43 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60439 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753887AbYHWVlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2008 17:41:42 -0400
Date: Sat, 23 Aug 2008 14:40:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [RFC PATCH] Writer-biased low-latency rwlock v8
In-Reply-To: <20080823203016.GA1328@Krystal>
Message-ID: <alpine.LFD.1.10.0808231435230.3363@nehalem.linux-foundation.org>
References: <20080817191034.GA5258@Krystal> <20080818232500.GF6732@linux.vnet.ibm.com> <20080819060417.GB24085@Krystal> <20080819073345.GA30285@Krystal> <alpine.LFD.1.10.0808190946560.3324@nehalem.linux-foundation.org> <20080821205045.GA24909@Krystal>
 <alpine.LFD.1.10.0808211356360.3487@nehalem.linux-foundation.org> <alpine.LFD.1.10.0808211402370.3487@nehalem.linux-foundation.org> <20080823050916.GA1172@Krystal> <alpine.LFD.1.10.0808231100090.3363@nehalem.linux-foundation.org>
 <20080823203016.GA1328@Krystal>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2008, Mathieu Desnoyers wrote:
>
> Actually, the point I just fixed in my head is that this bit will be a
> "MAY_CONTEND" bit, which could let higher priority readers access the
> lock in the slow path.

EXACTLY.

It's not even necessarily a "contention" bit per se - it's literally a 
"readers have to take the slow-path" bit (writers will obviously _always_ 
take the slowpath if there is any non-zero value at all, so they don't 
need it).

Then, the slow-path might actually decide that "hey, there is no _actual_ 
writer there yet - just some _waiting_ writer, but since this read lock is 
in an interrupt context, we have to let it go through _despite_ the fact 
that the lock is contended in order to avoid deadlock".

So it allows a fast-path for the trivial cases that is literally just a 
couple of instructions long, and that is nice not just because of 
performance issues, but because it then means that you can entirely ignore 
all those things in the slow path. It also means that everybody can look 
at the fast-path and decide that "ok, the fast-path really is optimal". 

That fast-path is what a lot of people care more about than just about 
anything else.

The slow-path, in comparison, can be in C, and can do all those checks 
like "are we in an (sw-)interrupt handler?" and basically prioritize 
certain classes of people.

			Linus
