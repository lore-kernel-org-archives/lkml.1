Return-Path: <linux-kernel-owner+w=401wt.eu-S1756524AbYEDMNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbYEDMNS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 08:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbYEDMNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 08:13:00 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:40071 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755155AbYEDMM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 08:12:59 -0400
Subject: Re: 'global' rq->clock
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Arjan van de Ven <arjan@infradead.org>
Cc: David Miller <davem@davemloft.net>, efault@gmx.de, elendil@planet.nl,
       parag.warudkar@gmail.com, mingo@elte.hu, linux-kernel@vger.kernel.org,
       guichaz@yahoo.fr, andi@firstfloor.org
In-Reply-To: <20080502030930.6098d8ff@infradead.org>
References: <200805022053.24779.elendil@planet.nl>
	 <1209756423.4693.8.camel@marge.simson.net> <1209758186.6929.18.camel@lappy>
	 <20080502.144827.158329188.davem@davemloft.net>
	 <20080502030930.6098d8ff@infradead.org>
Content-Type: text/plain
Date: Sun, 04 May 2008 14:12:36 +0200
Message-Id: <1209903157.6929.54.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-05-02 at 03:09 -0700, Arjan van de Ven wrote:
> On Fri, 02 May 2008 14:48:27 -0700 (PDT)
> David Miller <davem@davemloft.net> wrote:
> 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date: Fri, 02 May 2008 21:56:26 +0200
> > 
> > > Ok, the the below would need something that relates
> > > tick_timestamp's to one another.. probably sucks without it..
> > > 
> > > OTOH, Andi said he was working on a fastish global sched_clock()
> > > thingy, Andi got a link to that code?
> > 
> > While I'm fine with this kind of stuff being added to constantly cope
> > with x86's joke of a TSC register implementation, it's starting to
> > become an enormous burdon for platforms where the TICK source actually
> > works properly.
> 
> it's a sad affair indeed. On some systems it counts cycles, on other
> systems it counts time. On most systems it stops while idle, on others
> it keeps running. On most systems its not very synchronized between
> packages, and on some systems it's not even synchronized between cores.
> 
> I'm not convinced TSC is the right thing for the scheduler in the first
> place; on current x86 systems TSC counts "time" not "work done". Now of
> course "time" is an approximation for "work done", but not a very good
> one given the presence of what effectively is variable cpu speeds
> (software CPU frequency control is only part of that; there's also the
> finegrained hardware level frequency control as done by what marketing
> people call "Intel Dynamic Acceleration technology"). [*]
> 
> I and others have talked to Peter about this already, and I'm sure we'll
> talk more about it in the future as well.. at some point this part of
> CFS needs to fundamentally be cleaned up. Since this gets into a debate 
> about what fairness means ;(

> [*] The converse is also true; cycles aren't a good representation of
> time either; this makes cycle based profilers a bit iffy if you're
> interested in where the system spends time rather than where it spends
> cycles.

My current view on this is that per cpu scheduling should use a time
based clock, whereas smp load balancing can take the cycle (ie work)
counter to balance different work/time loads and estimate core power.

As for using the TSC, I'm afraid we just don't have any choice. Although
I guess we could dynamically detect some counter on new cpus and use
that when available. But the TSC is the only thing available on a lot of
existing machines.

