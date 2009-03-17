Return-Path: <linux-kernel-owner+w=401wt.eu-S1762817AbZCQIiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762817AbZCQIiF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 04:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755751AbZCQIhx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 04:37:53 -0400
Received: from casper.infradead.org ([85.118.1.10]:46319 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbZCQIhw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 04:37:52 -0400
Subject: Re: [PATCH/RFC 1/2] perfcounters: provide a way to read the
 current value of interrupting counters
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <18879.21884.162961.690031@cargo.ozlabs.ibm.com>
References: <18879.14425.221429.861838@drongo.ozlabs.ibm.com>
	 <1237275169.5189.58.camel@laptop>
	 <18879.21884.162961.690031@cargo.ozlabs.ibm.com>
Content-Type: text/plain
Date: Tue, 17 Mar 2009 09:37:40 +0100
Message-Id: <1237279060.5189.141.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.25.92 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-17 at 18:47 +1100, Paul Mackerras wrote:
> Peter Zijlstra writes:
> 
> > I'm not sure I understand why. It seems to me you're either interested
> > in sample data, that is {tid,ip,counter} like things, or you want raw
> > count values.
> 
> It was specifically requested by people porting PAPI to PCL, and it
> seems like a reasonable request.

OK, then why didn't the changelog say so :-)

Could you ask them why though, if they need it I won't object too much,
but I'd like to know the use case.

As to the method proposed, I think Ingo and I talked about 'abusing'
non-blocking reads for this purpose, would that work? Then if you need
two fds you could dup() and flip one to non-blocking.

The non-blocking read would either output whatever is already pending,
but in case there is no data, it would generate some on the spot.

> I think we should make record_type a bitset rather than a single
> value, and define bits for recording the callchain as well as various
> other interesting things.

Sounds sensible at first though, I'll see if I can poke a hole in that.

The only two things I've got on my todo list is that challchain and mmap
info, and those can indeed be done as a bitmask, tid information too.

> > Currently the group record type writes things like {hw_event->type,
> > counter} which is ambiguous since we really have a 65bit id space. So I
> > was thinking of making that {fd, counter} to at least have a unique
> > identifier in there.
> 
> The fd is already not a unique identifier - think about dup().

You're quite right indeed - risks of mailing before waking up I
suppose :-)

> The hw_event->type values are not really necessary, in fact, since the
> group members will always be read out in the order that they were
> added to the group.  The only time there might be any possibility of
> confusion is if a new member is added after some samples have already
> been taken (or a member is removed) - then we'll get new records being
> added to the event queue being a different size from those already in
> the queue.  But that's a somewhat different problem which isn't really
> solved by having the type values in there.

Ah, ok, so we can leave that out entirely. I was already planning to add
a sibling_count field, with that we could do something like:

{ record_type, sibling_count, n*{counter} }



