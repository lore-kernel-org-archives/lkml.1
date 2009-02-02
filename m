Return-Path: <linux-kernel-owner+w=401wt.eu-S1754617AbZBBJHf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754617AbZBBJHf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 04:07:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbZBBJHS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 04:07:18 -0500
Received: from gate.crashing.org ([63.228.1.57]:33125 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571AbZBBJHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 04:07:17 -0500
Subject: Re: [RFC][PATCH] create workqueue threads only when needed
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <4986B205.2040807@s5r6.in-berlin.de>
References: <20090127001708.GA4815@nowhere>
	 <20090126163015.7f879b18@infradead.org> <20090131180347.GC5884@nowhere>
	 <20090131101502.7ce8e7af@infradead.org> <20090131182843.GD5884@nowhere>
	 <1233524261.18767.60.camel@pasglop>  <20090202022414.GA5006@nowhere>
	 <1233554443.18767.71.camel@pasglop>  <4986B205.2040807@s5r6.in-berlin.de>
Content-Type: text/plain
Date: Mon, 02 Feb 2009 20:05:28 +1100
Message-Id: <1233565528.18767.80.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-02-02 at 09:42 +0100, Stefan Richter wrote:

> >  
> > IE. It will be pretty responsive -in general- but can suffer form
> > horrible latencies every now and then.
> 
> Actually it /should/ be the other way around:
> 
> The shared workqueue should only be used for work that sleeps only
> briefly (perhaps with the exception of very unlikely longer sleeps e.g.
> for allocations that cause paging).

I agree, I'm just stating the current situation :-) Hopefully something
like async funcs / slow work / whatever will take over the case of stuff
that wants to be around for longer. I haven't had a chance to look at
the async funcs yet, sounds like they may do the job tho in which case
I'll look at converting a driver or two to use them.

> Work which /may/ sleep longer, for example performs SCSI transactions,
> needs to go into a private workqueue or other kind of context.

Well, it's a bit silly to allocate a private workqueue with all it's
associated per CPU kernel threads for something as rare as resetting
your eth NIC ... or even SCSI error handling in fact.

> OTOH you are right too; work which must not be deferred too long by work
> from another uncooperative/ unfair subsystem is probably also better off
> in an own workqueue...

I suspect the main reason for dedicated work queues is that, plus the
per-CPU affinity.

Cheers,
Ben.

