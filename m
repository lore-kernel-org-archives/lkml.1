Return-Path: <linux-kernel-owner+w=401wt.eu-S1161229AbXAZTrP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161229AbXAZTrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 14:47:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161234AbXAZTrP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 14:47:15 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:40303 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161229AbXAZTrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 14:47:13 -0500
Date: Sat, 27 Jan 2007 01:16:22 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Andrew Morton <akpm@osdl.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       Gautham Shenoy <ego@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Fw: Re: [mm PATCH 4/6] RCU: (now) CPU hotplug
Message-ID: <20070126194622.GA17134@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <20070124011519.GG1613@linux.vnet.ibm.com> <20070124090111.GC27221@in.ibm.com> <20070124161559.GA1762@linux.vnet.ibm.com> <20070124210645.GA19650@in.ibm.com> <20070126191113.GA14770@in.ibm.com> <20070126112837.059502fc.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070126112837.059502fc.akpm@osdl.org>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 26, 2007 at 11:28:37AM -0800, Andrew Morton wrote:
> On Sat, 27 Jan 2007 00:41:13 +0530
> Dipankar Sarma <dipankar@in.ibm.com> wrote:
> 
> > Is this a good example to
> > show why per-subsystem locks might be unmaintainable ?
> 
> Maybe.  It might also be a good example of confused design.

Not this one. The point is that this forces us to determine
which APIs are usable in cpu hotplug path and which aren't.
It isn't unreasonable to expect that some one may need
to use sched_setaffinity() in hotplug path. This now forces
us to have two versions of sched_setaffinity() - one with
the hotplug per-subsystem lock, the other one without.

> > Can we go back
> 
> "back" assumes it was once present.  It wasn't.

IIRC, there was one get_cpu_hotplug()/put_cpu_hotplug() implementation
based on Arjan's suggestion and implemented in a scalable way by Gautham.

> 
> > to a simple
> 
> "simple" hasn't been demonstrated.  New lock types and their use are never
> simple, especially magic ones.

get_cpu_hotplug()/put_cpu_hotplug() hides all the refcount complexities
underneath and most kernel programmers are familiar with the
get()/put() model. This seems like the most simple thing we
could do in the short term without making too many changes in all over the
kernel for CPU hotplug.

> 
> > scalable refcount model
> > for CPU hotplug now ?
> 
> The plan is, I hope, to rip it all out and do freeze_processes() on the
> hotplug side, so nobody else needs to worry about cpu hotplug any more. 
> But at present everyone seems to be in hiding.

This would be ideal. However, we don't seem to have any momentum
on this. The other thing we would need to do in this case is to
check if all the users of cpu hotplug can tolerate a very slow
hotplug step if there are 10s of thousands of processes and threads.

Thanks
Dipankar
