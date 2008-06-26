Return-Path: <linux-kernel-owner+w=401wt.eu-S1756882AbYFZRsg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbYFZRsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 13:48:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759317AbYFZRsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 13:48:22 -0400
Received: from viefep20-int.chello.at ([62.179.121.40]:43588 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759254AbYFZRsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 13:48:20 -0400
Subject: Re: Spinlocks: Factor our GENERIC_LOCKBREAK in order to avoid spin
	with irqs disable
From: Peter Zijlstra <peterz@infradead.org>
To: Christoph Lameter <clameter@sgi.com>
Cc: Petr Tesarik <ptesarik@suse.cz>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Nick Piggin <nickpiggin@yahoo.com.au>
In-Reply-To: <Pine.LNX.4.64.0806261001310.7369@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0805061220570.30604@schroedinger.engr.sgi.com>
	 <20080507073017.GJ32195@elte.hu>
	 <Pine.LNX.4.64.0805071002330.3110@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071022230.3173@schroedinger.engr.sgi.com>
	 <Pine.LNX.4.64.0805071148240.8441@schroedinger.engr.sgi.com>
	 <1214241561.19392.21.camel@elijah.suse.cz>
	 <Pine.LNX.4.64.0806231115420.22557@schroedinger.engr.sgi.com>
	 <1214253593.11254.30.camel@twins>
	 <Pine.LNX.4.64.0806231345001.28304@schroedinger.engr.sgi.com>
	 <1214254730.11254.34.camel@twins>  <48630420.1090102@goop.org>
	 <1214471867.17319.8.camel@elijah.suse.cz>
	 <Pine.LNX.4.64.0806261001310.7369@schroedinger.engr.sgi.com>
Content-Type: text/plain
Date: Thu, 26 Jun 2008 19:48:10 +0200
Message-Id: <1214502490.10371.44.camel@twins.programming.kicks-ass.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 (2.22.2-2.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-06-26 at 10:02 -0700, Christoph Lameter wrote:
> On Thu, 26 Jun 2008, Petr Tesarik wrote:
> 
> > We should probably re-think the whole locking scheme, because spinlocks
> > were designed to be held for a short period of time. This was a fair
> > assumption when they were introduced, but obviously it is now false in
> > many cases (such as virtualization).
> 
> And NUMA.
> 
> > Ticket-based spinlocks have actually already changed the original
> > design, so why not implement a generic "lock scheduler" on top of
> > spinlock_t and rwlock_t?
> 
> How about making the semaphore / mutex code as fast as spinlocks and just 
> use that?

Hehe, please have a look at a recent -rt tree and possibly test some of
that if you're interested.

It has adaptive spins for rt_mutex. Which is to say, as long as the lock
owner is current on its cpu, we'll spin trying to acquire the lock. The
reasoning here is that as long as the owner is running, there is a fair
chance it'll release the lock soonish.

This is another case where semaphores can never match, due to their lack
of ownership.

