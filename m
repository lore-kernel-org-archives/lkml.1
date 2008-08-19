Return-Path: <linux-kernel-owner+w=401wt.eu-S1755252AbYHSNpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755252AbYHSNpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 09:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752462AbYHSNpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 09:45:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:61443 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbYHSNpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 09:45:20 -0400
Date: Tue, 19 Aug 2008 09:45:16 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu, tglx@linutronix.de,
       linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: Re: [PATCH RT 2/2] ftrace: fix elevated preempt_count in
 wakeup-tracer
In-Reply-To: <48AAC8E7.1030506@novell.com>
Message-ID: <alpine.DEB.1.10.0808190942070.23667@gandalf.stny.rr.com>
References: <20080819091817.21725.81831.stgit@dev.haskins.net>  <20080819091923.21725.41087.stgit@dev.haskins.net> <1219151556.10800.383.camel@twins> <48AAC8E7.1030506@novell.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 19 Aug 2008, Gregory Haskins wrote:
> > 
> > Is preempt_count > 1 at all times here?
> > 
> > If not, it might drop to 0 and any interrupt might cause preemption -
> > and its not obvious to me that that is actually correct.
> >   
> According to Steve, we are already in an interrupt-disabled section here, but
> I will defer to him.  He suggested I try this over an IRC conversation when I
> noticed a strange wakeup trace, and it seems to have solved the problem.

Exactly.

Peter,

We disable preemption, do a per_cpu check, if we are not nested we grab 
disable interrupts and grab the spin lock.

The issue that Gregory brought up, was that the tracer would always show 
that preemption was disabled, when it really wasn't. It was recording the
preempt disabled that the trace function itself made. The answer was 
simply to do as Greg did, and enable preemption (but interrupts are 
still disabled), call the function tracer, then disable preemption again 
(to match the outside preemption enabling.


> 
> Im really sending this patch more of a reminder to Steve that he was going to
> fix this, rather than to accept my patch as is.  Of course I don't mind if it
> is accepted as is, and I can make the prologue/comments more descriptive if
> necessary.  But if Steve wants to do something like fold this into his ftrace
> series, that is fine too.  I just didn't want it to be forgotten ;)

Greg thanks, otherwise I would have probably forgotten it ;-)

-- Steve


