Return-Path: <linux-kernel-owner+w=401wt.eu-S1754157AbYKKRWT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157AbYKKRWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 12:22:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751767AbYKKRWL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 12:22:11 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:57998 "EHLO
	viefep18-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751594AbYKKRWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 12:22:10 -0500
X-SourceIP: 213.46.9.244
Subject: Re: [RFC PATCH v3 5/5] sched: activate active load balancing in
 new idle cpus
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: svaidy@linux.vnet.ibm.com
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Suresh B Siddha <suresh.b.siddha@intel.com>,
       Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>,
       Ingo Molnar <mingo@elte.hu>, Dipankar Sarma <dipankar@in.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Vatsa <vatsa@linux.vnet.ibm.com>, Gautham R Shenoy <ego@in.ibm.com>,
       Andi Kleen <andi@firstfloor.org>, David Collier-Brown <davecb@sun.com>,
       Tim Connors <tconnors@astro.swin.edu.au>,
       Max Krasnyansky <maxk@qualcomm.com>
In-Reply-To: <20081111170441.GT4646@dirshya.in.ibm.com>
References: <20081110181526.562.69941.stgit@drishya.in.ibm.com>
	 <20081110183343.562.72751.stgit@drishya.in.ibm.com>
	 <1226411235.7685.1775.camel@twins>
	 <20081111170441.GT4646@dirshya.in.ibm.com>
Content-Type: text/plain
Date: Tue, 11 Nov 2008 18:21:50 +0100
Message-Id: <1226424110.7685.2038.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-11 at 22:34 +0530, Vaidyanathan Srinivasan wrote:
> * Peter Zijlstra <a.p.zijlstra@chello.nl> [2008-11-11 14:47:15]:
> 
> > On Tue, 2008-11-11 at 00:03 +0530, Vaidyanathan Srinivasan wrote:
> > > Active load balancing is a process by which migration thread
> > > is woken up on the target CPU in order to pull current
> > > running task on another package into this newly idle
> > > package.
> > > 
> > > This method is already in use with normal load_balance(),
> > > this patch introduces this method to new idle cpus when
> > > sched_mc is set to POWERSAVINGS_BALANCE_WAKEUP.
> > > 
> > > This logic provides effective consolidation of short running
> > > daemon jobs in a almost idle system
> > > 
> > > The side effect of this patch may be ping-ponging of tasks
> > > if the system is moderately utilised. May need to adjust the
> > > iterations before triggering.
> > 
> > OK, I'm so not getting this patch..
> > 
> > if normal newly idle balancing fails that means the other runqueue has
> > only a single task on it (or some other really stubborn stuff), so then
> > you go move that one task that is already running, from one cpu to
> > another.
> > 
> > _why_?
> > 
> > The only answer I can come up with is that you prefer one cpu's
> > idle-ness over another - which makes sense, as you try to get whole
> > packages idle.
> 
> Your answer is correct.  We want to move that one task from a non-idle
> cpu to this cpu that is just going to be idle.  
> 
> This is the same method used to move task in load_balance(), I have
> extended it for load_balance_newidle() to make the consolidation
> faster at sched_mc=2.
> 
> 
> > But I'm not seeing where that package logic is hidden..
> 
> 
> The package logic comes from find_busiest_group().  If there are no
> imbalance, then find_busiest_group() will return NULL.  However when
> sched_mc={1,2} then find_busiest_group() will select a group
> from which a running task may be pulled to this cpu in order to make
> the other package idle.  If there is no opportunity to make a package
> idle and if there are no imbalance, then find_busiest_group() will
> return NULL and no action will be taken in load_balance_newidle().
> 
> Under normal task pull operation due to imbalance, there will be more
> than one task in the source run queue and move_tasks() will succeed.
> ld_moved will be true and the active balance code will not be
> triggered.
> 
> If we enter a scenario where we are moving the only running task from
> another cpu, then this should have been suggested by
> find_busiest_group's sched_mc balance logic and thus moving that task
> will potentially freeup the source package.
> 
> Thanks for the careful review.

Ah, right, thanks!

Could you clarify this by adding a comment to this effect right before
the added code?

