Return-Path: <linux-kernel-owner+w=401wt.eu-S1757732AbYGaTmK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732AbYGaTmK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 15:42:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756879AbYGaTl0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 15:41:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:49798 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756769AbYGaTlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 15:41:25 -0400
Date: Thu, 31 Jul 2008 09:50:18 -0700
From: Greg KH <greg@kroah.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu,
       linux-kernel@vger.kernel.org, stable <stable@kernel.org>
Subject: Re: [stable] combinatorial explosion in lockdep
Message-ID: <20080731165018.GB10422@kroah.com>
References: <20080728.161318.38361710.davem@davemloft.net> <20080728235133.GA7956@elte.hu> <20080728.174415.154327359.davem@davemloft.net> <20080729.214503.126934382.davem@davemloft.net> <1217416519.8157.15.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1217416519.8157.15.camel@twins>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2008 at 01:15:19PM +0200, Peter Zijlstra wrote:
> On Tue, 2008-07-29 at 21:45 -0700, David Miller wrote:
> > From: David Miller <davem@davemloft.net>
> > Date: Mon, 28 Jul 2008 17:44:15 -0700 (PDT)
> > 
> > > From: Ingo Molnar <mingo@elte.hu>
> > > Date: Tue, 29 Jul 2008 01:51:33 +0200
> > > 
> > > > Any chance to get the "cat /proc/lockdep*" output, so that we could see 
> > > > and check the expected behavior of the full graph?
> > > 
> > > /proc/lockdep loops forever in count_forward_deps() :-)
> > > 
> > > I was able to capture a copy of lockdep_chains:
> > > 
> > > http://vger.kernel.org/~davem/lockdep_chains.bz2
> > 
> > As a followup I dumped the full backwards search graph once the cost
> > got up to about (1 * 1024 * 1024) checks or so.
> > 
> > I didn't find any loops, but it is clear that the cost is huge because
> > of the runqueue lock double-locking, without the generation count
> > patch I posted the other day.
> > 
> > For example, if you start with the first runqueue lock you search one
> > entry:
> > 
> > 	1
> > 
> > Next, if you start with the second runqueue lock you search two
> > entries:
> > 
> > 	2, 1
> > 
> > Next, if you start with the third runqueue lock you search
> > 4 entries:
> > 
> > 	3, 2, 1, 1
> > 
> > And the next series is:
> > 
> > 	4, 3, 2, 1, 1, 2, 1, 1
> > 
> > and so on and so forth.  So the cost of a full backwards graph
> > traversal for N cpus is on the order of "1 << (N - 1)".  So with just
> > 32 cpus the cost is on the order of a few billions of checks.
> > 
> > And then you have to factor in all of those runqueue locks's backwards
> > graphs that don't involve other runqueue locks (on my machine each
> > such sub-graph is about 200 locks deep).
> > 
> > Here is an updated version of my patch to solve this problem.  The only
> > unnice bit is that I had to move the procfs dep counting code into
> > lockdep.c and run it under the lockdep_lock.  This is the only way to
> > safely employ the dependency generation ID marking algorithm the
> > short-circuiting uses.
> > 
> > If we can agree on this as a fix, it should definitely be backported
> > and submitted for -stable :-)
> 
> Agreed adding the stable team to the CC

Great, please send the stable team the patch when it hits Linus's tree.

thanks,

greg k-h
