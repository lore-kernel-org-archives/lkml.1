Return-Path: <linux-kernel-owner+w=401wt.eu-S1756303AbZCTWV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756303AbZCTWV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 18:21:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752866AbZCTWVS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 18:21:18 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43004 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751704AbZCTWVQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 18:21:16 -0400
Date: Fri, 20 Mar 2009 15:21:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: dipankar@in.ibm.com, linux-input@vger.kernel.org,
       dmitry.torokhov@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Question about usage of RCU in the input layer
Message-ID: <20090320222114.GA17480@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20090318215812.15496a86@infradead.org> <20090319085628.GA6167@in.ibm.com> <20090319071841.63334eff@infradead.org> <20090320020750.GA6807@linux.vnet.ibm.com> <20090319202032.4c971d92@infradead.org> <20090320044541.GE6807@linux.vnet.ibm.com> <20090320065058.65d01771@infradead.org> <20090320143104.GA6698@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090320143104.GA6698@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 20, 2009 at 07:31:04AM -0700, Paul E. McKenney wrote:
> On Fri, Mar 20, 2009 at 06:50:58AM -0700, Arjan van de Ven wrote:
> > On Thu, 19 Mar 2009 21:45:41 -0700
> > "Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:
> > 
> > > > single CPU is soooo last decade ;-)
> > > > But seriously I no longer have systems that aren't dual core or SMT
> > > > in some form... 
> > > 
> > > OK, I will ask the stupid question...
> > > 
> > > Why not delay bringing up the non-boot CPUs until later in boot?
> > 
> > that'd be throwing out the baby with the bathwater... I'm trying to use 
> > the other cpus to do some of the boot work (so that the total goes
> > faster); not using the other cpus would be counter productive to that.
> > (As is just sitting in synchronize_rcu() when the other cpu is
> > working.. hence this discussion ;-)
> 
> OK, so you are definitely running multiple CPUs when the offending
> synchronize_rcu() executes, then?
> 
> If so, here are some follow-on questions:
> 
> 1.	How many synchronize_rcu() calls are you seeing on the
> 	critical boot path and what value of HZ are you running?
> 
> 	If each synchronize_rcu() is taking (say) tens of jiffies, then,
> 	as Peter Zijlstra notes earlier in this thread, we need to focus
> 	on what is taking too long to get through its RCU read-side
> 	critical sections.  Otherwise, if each synchronize_rcu() is
> 	in the 3-5 jiffy range, I may finally be forced to create an
> 	expedited version of the synchronize_rcu() API.
> 
> 2.	If expediting is required, then the code calling synchronize_rcu()
> 	might or might not have any idea whether or not expediting is
> 	appropriate.  If it does not, then we would need some sort of way
> 	to tell synchronize_rcu() that it should act more aggressively,
> 	perhaps /proc flag or kernel global variable indicating that
> 	boot is in progress.
> 
> 	No, we do not want to make synchronize_rcu() aggressive all the
> 	time, as this would harm performance and energy efficiency in
> 	the normal runtime situation.
> 
> 	So, if it turns out that synchronize_rcu()'s caller does not
> 	know whether or not expediting is appropriate, can the boot path
> 	manipulate such a flag or variable?
> 
> 3.	Which RCU implementation are you using?  CONFIG_CLASSIC_RCU,
> 	CONFIG_TREE_RCU, or CONFIG_PREEMPT_RCU?

And one other thing...  CONFIG_CLASSIC_RCU's synchronize_rcu() normally
runs faster than CONFIG_PREEMPT_RCU, if that helps.

							Thanx, Paul
