Return-Path: <linux-kernel-owner+w=401wt.eu-S1754437AbZCUVH7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbZCUVH7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Mar 2009 17:07:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753107AbZCUVHu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Mar 2009 17:07:50 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:49293 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786AbZCUVHt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Mar 2009 17:07:49 -0400
Date: Sat, 21 Mar 2009 14:07:45 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Eric Dumazet <dada1@cosmosbay.com>
Cc: Arjan van de Ven <arjan@infradead.org>, dipankar@in.ibm.com,
       linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
       linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090321210745.GE7148@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com> <20090320065058.65d01771@infradead.org> <20090320143104.GA6698@linux.vnet.ibm.com> <20090320111354.679ab53d@infradead.org> <20090321012746.GM6698@linux.vnet.ibm.com> <20090321125115.0a76ac27@infradead.org> <49C54D60.80306@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <49C54D60.80306@cosmosbay.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 21, 2009 at 09:26:08PM +0100, Eric Dumazet wrote:
> Arjan van de Ven a écrit :
> > On Fri, 20 Mar 2009 18:27:46 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> >> On Fri, Mar 20, 2009 at 11:13:54AM -0700, Arjan van de Ven wrote:
> >>> On Fri, 20 Mar 2009 07:31:04 -0700
> >>> "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> >>>>> that'd be throwing out the baby with the bathwater... I'm
> >>>>> trying to use the other cpus to do some of the boot work (so
> >>>>> that the total goes faster); not using the other cpus would be
> >>>>> counter productive to that. (As is just sitting in
> >>>>> synchronize_rcu() when the other cpu is working.. hence this
> >>>>> discussion ;-)
> >>>> OK, so you are definitely running multiple CPUs when the offending
> >>>> synchronize_rcu() executes, then?
> >>> absolutely. 
> >>> (and I'm using bootgraph.pl in scripts to track who's stalling etc)
> >>>> If so, here are some follow-on questions:
> >>>>
> >>>> 1.	How many synchronize_rcu() calls are you seeing on the
> >>>> 	critical boot path
> >>> I've seen only this (input) one to take a long time
> >> Ouch!!!  A -single- synchronize_rcu() taking a full second???  That
> >> indicates breakage.
> >>
> >>>>  and what value of HZ are you running?
> >>> 1000
> >> K, in absence of readers for RCU_CLASSIC, we should see a handful
> >> of milliseconds for synchronize_rcu().
> > 
> > I've attached an instrumented bootgraph of what is going on;
> > the rcu delays are shown as red blocks inside the regular functions
> > as they initialize......
> > 
> > (svg can be viewed with inkscape, gimp, firefox and various other tools)
> 
> Interesting stuff...
> 
> I thought you mentioned i2c drivers being source of the udelays(),
>  but I cant see them in this svg, unless its async_probe_hard ?

Arjan, another thought -- if the udelays() are not under rcu_read_lock(),
you should be able to finesse this by using CONFIG_PREEMPT_RCU, which
will happily ignore spinning CPUs as long as they are not in an RCU
read-side critical section.

							Thanx, Paul
