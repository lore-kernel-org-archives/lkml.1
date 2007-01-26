Return-Path: <linux-kernel-owner+w=401wt.eu-S1751595AbXAZVez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751595AbXAZVez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 16:34:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbXAZVez
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 16:34:55 -0500
Received: from smtp.osdl.org ([65.172.181.24]:56191 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751568AbXAZVey (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 16:34:54 -0500
Date: Fri, 26 Jan 2007 13:29:49 -0800
From: Andrew Morton <akpm@osdl.org>
To: dipankar@in.ibm.com
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-Id: <20070126132949.50544e90.akpm@osdl.org>
In-Reply-To: <20070126204406.GB17134@in.ibm.com>
References: <20070124011519.GG1613@linux.vnet.ibm.com>
	<20070124090111.GC27221@in.ibm.com>
	<20070124161559.GA1762@linux.vnet.ibm.com>
	<20070124210645.GA19650@in.ibm.com>
	<20070126191113.GA14770@in.ibm.com>
	<20070126112837.059502fc.akpm@osdl.org>
	<20070126194622.GA17134@in.ibm.com>
	<20070126121739.be3e072a.akpm@osdl.org>
	<20070126204406.GB17134@in.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Jan 2007 02:14:06 +0530
Dipankar Sarma <dipankar@in.ibm.com> wrote:

> On Fri, Jan 26, 2007 at 12:17:39PM -0800, Andrew Morton wrote:
> > On Sat, 27 Jan 2007 01:16:22 +0530
> > Dipankar Sarma <dipankar@in.ibm.com> wrote:
> > > > The plan is, I hope, to rip it all out and do freeze_processes() on the
> > > > hotplug side, so nobody else needs to worry about cpu hotplug any more. 
> > > > But at present everyone seems to be in hiding.
> > > 
> > > This would be ideal. However, we don't seem to have any momentum
> > > on this.
> > 
> > There's no point in expending effort on a fancy new lock until this option
> > has been eliminated, so yeah, things are stuck.
> 
> The new lock (scalable refcount) is almost already there. 
> This http://lkml.org/lkml/2006/10/26/65 can be used to implement
> get_cpu_hotplug()/put_cpu_hotplug(). The unfairness issue
> can be fixed. I am going to play with these patches and
> see if I can come up with something useful quickly.

You're forgetting the large, unknown number of places in the kernel which
are presently buggy in the presence of CPU hotplug.  With your proposal, we
still need to hunt them all down and put magic locks around them, and we need to
continue to do that as the kernel evolves.

If we use the process freezer, these bugs all get automatically fixed, and we get
to remove the existing locking, and we don't need to think about it any
more.

> > > The other thing we would need to do in this case is to
> > > check if all the users of cpu hotplug can tolerate a very slow
> > > hotplug step if there are 10s of thousands of processes and threads.
> > 
> > Yes, that needs evaluation.  If it's a problem then we might need to
> 
> I will check with the dynamic LPAR people to see if they
> have any requirements in this regard. I have also heard
> about some people wanting to disable additional threads
> in processors (running 1 h/w thread per core) using cpu hotplug 
> for some type of applications. I will check with those
> folks as well.

OK.

> > introduce a more sophisticated user interface which enables userspace to
> > take multiple CPUs online and offline in a single step, rather than
> > one-at-a-time.  I expect that'd be fairly straightforward.
> 
> The worry I have is that all of this is a complete rewrite of
> existing CPU hotplug and it took us 1+ years to get a decent
> CPU hotplug implementation. Rusty and Vatsa can probably vouch
> for how difficult it was to get it right. I don't think
> it is a good idea to keep CPU hotplug broken until this
> rewrite happens. Can't we just go with something that is
> already there and works correctly for us without waiting
> for the perfect solution ?

Who said it's complete rewrite?  Nobody's even started to look at it afaik.
It might be quite simple.

