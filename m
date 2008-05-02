Return-Path: <linux-kernel-owner+w=401wt.eu-S1762288AbYEBHQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288AbYEBHQS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 03:16:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755023AbYEBHQG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 03:16:06 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:59445 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073AbYEBHQF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 03:16:05 -0400
Date: Fri, 2 May 2008 09:15:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mingo@redhat.com,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: x86: 8K stacks by default
Message-ID: <20080502071542.GA713@elte.hu>
References: <200805010359.m413xWBV014593@hera.kernel.org> <20080501101956.695c5b34@core>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080501101956.695c5b34@core>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> >     x86: 8K stacks by default
> >     
> >     Switch back to 8K stacks as the safer default. Out-of-memory
> >     situations are less problematic than silent and hard to debug
> >     stack corruption.
> 
> On its own that makes the problem worse not better. If you are going 
> to 8K stacks fine but if you want them debuggable then 32bit needs to 
> always use separate IRQ stacks as well, otherwise you've merely made 
> the crash cases rarer and harder to debug (deep recursion colliding 
> with deep IRQ path)

you are right in the larger picture. Note that 4K stacks still move out 
of EXPERIMENTAL, so they are still a more prominent choice than they 
were in v2.6.25.

The plan is to remove "this overflows my stack here and now" technical 
argument: we'll add the stack-footprint measurement tracing plugin from 
-rt to ftrace and get that upstream. In -rt's tracer we can measure, 
track and trace the exact worst-case stack footprint of a system, since 
bootup. It relies on the function tracer which looks at the current 
stack footprint at every given moment. It's not a statistical sample, it 
tracks the true worst-case stack footprint.

we've also got other (lighter weight) "did the stack overflow" 
protective measures queued up in x86.git - but those didnt make it into 
v2.6.26. It's this commit in x86.git:

| commit 738570e1d30a5e26266072190f0ed8080594b8b0
| Author: Eric Sandeen <sandeen@sandeen.net>
| Date:   Tue Apr 22 16:38:23 2008 -0500
|
|    use canary at end of stack to indicate overruns at oops time
|
|    (Updated with a common max-stack-used checker that knows about
|    the canary, as suggested by Joe Perches)

So we'll just stay with the status quo for now - which was 8K stacks for 
most people who didnt intentionally pick 4K stacks. Distributions can 
still pick their preference anyway and we'll revisit the issue in 2.6.27 
once we've got all the right tools in place.

_Then_ there can be no real technical argument about making the more 
robust 4K stacks the default.

	Ingo
