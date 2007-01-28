Return-Path: <linux-kernel-owner+w=401wt.eu-S932942AbXA1XNv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932942AbXA1XNv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jan 2007 18:13:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932937AbXA1XNv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jan 2007 18:13:51 -0500
Received: from pool-71-111-65-226.ptldor.dsl-w.verizon.net ([71.111.65.226]:17722
	"EHLO IBM-8EC8B5596CA.beaverton.ibm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932942AbXA1XNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jan 2007 18:13:50 -0500
X-Greylist: delayed 1564 seconds by postgrey-1.27 at vger.kernel.org; Sun, 28 Jan 2007 18:13:50 EST
Date: Sun, 28 Jan 2007 14:47:56 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: dipankar@in.ibm.com, Gautham Shenoy <ego@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070128224756.GA7672@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20070124011519.GG1613@linux.vnet.ibm.com> <20070124090111.GC27221@in.ibm.com> <20070124161559.GA1762@linux.vnet.ibm.com> <20070124210645.GA19650@in.ibm.com> <20070126191113.GA14770@in.ibm.com> <20070126112837.059502fc.akpm@osdl.org> <20070126194622.GA17134@in.ibm.com> <20070126121739.be3e072a.akpm@osdl.org> <20070126204406.GB17134@in.ibm.com> <20070126132949.50544e90.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126132949.50544e90.akpm@osdl.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 01:29:49PM -0800, Andrew Morton wrote:
> On Sat, 27 Jan 2007 02:14:06 +0530
> Dipankar Sarma <dipankar@in.ibm.com> wrote:
> 
> > On Fri, Jan 26, 2007 at 12:17:39PM -0800, Andrew Morton wrote:
> > > On Sat, 27 Jan 2007 01:16:22 +0530
> > > Dipankar Sarma <dipankar@in.ibm.com> wrote:
> > > > > The plan is, I hope, to rip it all out and do freeze_processes() on the
> > > > > hotplug side, so nobody else needs to worry about cpu hotplug any more. 
> > > > > But at present everyone seems to be in hiding.
> > > > 
> > > > This would be ideal. However, we don't seem to have any momentum
> > > > on this.
> > > 
> > > There's no point in expending effort on a fancy new lock until this option
> > > has been eliminated, so yeah, things are stuck.
> > 
> > The new lock (scalable refcount) is almost already there. 
> > This http://lkml.org/lkml/2006/10/26/65 can be used to implement
> > get_cpu_hotplug()/put_cpu_hotplug(). The unfairness issue
> > can be fixed. I am going to play with these patches and
> > see if I can come up with something useful quickly.
> 
> You're forgetting the large, unknown number of places in the kernel which
> are presently buggy in the presence of CPU hotplug.  With your proposal, we
> still need to hunt them all down and put magic locks around them, and we need to
> continue to do that as the kernel evolves.

Certainly the current practice of notifying CPU_UP_PREPARE and CPU_ONLINE
in the same order as CPU_DOWN_PREPARE and CPU_DEAD is just asking for lots
of bugs.  The "up" notifications should proceed in the same order as the
services were initialized at boot time, and the "down" notifications need
to proceed in the opposite order.

As things stand, if service B relies on service A, either service B must
go without during the CPU-removal process or services A and B must know
way too much about one another.  Either approach is an excellent way
to breed endless quantities of bugs.  If "down" notifications instead
proceeded in the opposite order from boot-time initialization, such
dependencies would be resolved automatically, and life is -much- simpler.

So why are we doing hard things the hard way here???  ;-)

> If we use the process freezer, these bugs all get automatically fixed,
> and we get to remove the existing locking, and we don't need to think
> about it any more.

The idea being to essentially suspend the system to RAM, remove the
CPU and then unsuspend it?  Seems like quite high overhead -- or am
I misunderstanding the proposal?

						Thanx, Paul
