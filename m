Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZK2SvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZK2SvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 13:51:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752048AbZK2SvI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 13:51:08 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:44804 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751909AbZK2SvG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 13:51:06 -0500
Date: Sun, 29 Nov 2009 10:51:22 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Nick Piggin <npiggin@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [rfc] "fair" rw spinlocks
Message-ID: <20091129185122.GE6883@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20091123145409.GA29627@wotan.suse.de> <alpine.LFD.2.00.0911280927180.2561@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0911280927180.2561@localhost>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 28, 2009 at 09:30:18AM -0800, Linus Torvalds wrote:
> 
> 
> On Mon, 23 Nov 2009, Nick Piggin wrote:
> > 
> > Last time this issue came up that I could see, I don't think
> > there were objections to making rwlocks fair, the main
> > difficulty seemed to be that we allow reentrant read locks
> > (so a write lock waiting must not block arbitrary read lockers).
> 
> We have at least one major rwlock user - tasklist_lock or whatever. And 
> that one definitely depends on being able to do 'rwlock()' in an 
> interrupt, without other rwlock'ers having to disable irq's (even if there 
> might be a new writer coming in on another cpu).

In other words, any fair rwlock must unconditionally grant read access
to any CPU that already read-holds the lock, regardless of the state of
any writer wannabees.  Or is there another requirement I am missing?

> That usage case _might_ be turned into RCU or something similar, in which 
> case I don't think any major rwlock users remain. However, if that's the 
> case, then why should anybody care about fairness any more either?

Indeed, RCU goes a step further, permitting new readers unconditionally,
regardless of writer state.  ;-)

> So as far as I can tell, we have only one real user of rwlocks where 
> livelocks might be relevant, but that one real user absolutely _requires_ 
> the unfair behavior.

But the required unfairness is limited to unconditionally granting
recursive read requests, right?  If I understand correctly, if a given
CPU does not already read-hold the lock, then we can safely make that
CPU wait for a writer that might otherwise be starved.  Again, is there
another requirement that I am missing?

							Thanx, Paul
