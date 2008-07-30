Return-Path: <linux-kernel-owner+w=401wt.eu-S1758607AbYG3HUX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607AbYG3HUX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 03:20:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbYG3HUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 03:20:10 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:41233 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397AbYG3HUI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 03:20:08 -0400
Subject: Re: combinatorial explosion in lockdep
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org
In-Reply-To: <20080729.214503.126934382.davem@davemloft.net>
References: <20080728.161318.38361710.davem@davemloft.net>
	 <20080728235133.GA7956@elte.hu>
	 <20080728.174415.154327359.davem@davemloft.net>
	 <20080729.214503.126934382.davem@davemloft.net>
Content-Type: text/plain
Date: Wed, 30 Jul 2008 09:19:54 +0200
Message-Id: <1217402394.6364.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-29 at 21:45 -0700, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Mon, 28 Jul 2008 17:44:15 -0700 (PDT)
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Tue, 29 Jul 2008 01:51:33 +0200
> > 
> > > Any chance to get the "cat /proc/lockdep*" output, so that we could see 
> > > and check the expected behavior of the full graph?
> > 
> > /proc/lockdep loops forever in count_forward_deps() :-)
> > 
> > I was able to capture a copy of lockdep_chains:
> > 
> > http://vger.kernel.org/~davem/lockdep_chains.bz2
> 
> As a followup I dumped the full backwards search graph once the cost
> got up to about (1 * 1024 * 1024) checks or so.
> 
> I didn't find any loops, but it is clear that the cost is huge because
> of the runqueue lock double-locking, without the generation count
> patch I posted the other day.
> 
> For example, if you start with the first runqueue lock you search one
> entry:
> 
> 	1
> 
> Next, if you start with the second runqueue lock you search two
> entries:
> 
> 	2, 1
> 
> Next, if you start with the third runqueue lock you search
> 4 entries:
> 
> 	3, 2, 1, 1
> 
> And the next series is:
> 
> 	4, 3, 2, 1, 1, 2, 1, 1
> 
> and so on and so forth.  So the cost of a full backwards graph
> traversal for N cpus is on the order of "1 << (N - 1)".  So with just
> 32 cpus the cost is on the order of a few billions of checks.
> 
> And then you have to factor in all of those runqueue locks's backwards
> graphs that don't involve other runqueue locks (on my machine each
> such sub-graph is about 200 locks deep).
> 
> Here is an updated version of my patch to solve this problem.  The only
> unnice bit is that I had to move the procfs dep counting code into
> lockdep.c and run it under the lockdep_lock.  This is the only way to
> safely employ the dependency generation ID marking algorithm the
> short-circuiting uses.
> 
> If we can agree on this as a fix, it should definitely be backported
> and submitted for -stable :-)

Way cool stuff - will try and wrap my brains around it asap.


