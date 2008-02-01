Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbYBAERR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbYBAERR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 23:17:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752915AbYBAERI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 23:17:08 -0500
Received: from e28smtp01.in.ibm.com ([59.145.155.1]:33689 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752201AbYBAERG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 23:17:06 -0500
Date: Fri, 1 Feb 2008 09:46:55 +0530
From: Dhaval Giani <dhaval@linux.vnet.ibm.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: balbir@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
       linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       menage@google.com, containers@lists.osdl.org,
       Balbir Singh <balbir@in.ibm.com>, pj@sgi.com
Subject: Re: [RFC] Default child of a cgroup
Message-ID: <20080201041655.GC12475@linux.vnet.ibm.com>
Reply-To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
References: <20080131024049.GA9544@linux.vnet.ibm.com> <47A20EC8.4050006@linux.vnet.ibm.com> <1201811862.32654.29.camel@lappy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1201811862.32654.29.camel@lappy>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2008 at 09:37:42PM +0100, Peter Zijlstra wrote:
> 
> On Thu, 2008-01-31 at 23:39 +0530, Balbir Singh wrote:
> > Srivatsa Vaddagiri wrote:
> > > Hi,
> > > 	As we were implementing multiple-hierarchy support for CPU
> > > controller, we hit some oddities in its implementation, partly related
> > > to current cgroups implementation. Peter and I have been debating on the 
> > > exact solution and I thought of bringing that discussion to lkml.
> > > 
> > > Consider the cgroup filesystem structure for managing cpu resource.
> > > 
> > > 	# mount -t cgroup -ocpu,cpuacct none /cgroup
> > > 	# mkdir /cgroup/A
> > > 	# mkdir /cgroup/B
> > > 	# mkdir /cgroup/A/a1
> > > 
> > > will result in:
> > > 
> > > 	/cgroup
> > > 	   |------<tasks>
> > > 	   |------<cpuacct.usage>
> > >  	   |------<cpu.shares>
> > > 	   |
> > > 	   |----[A]
> > > 	   |     |----<tasks>
> > > 	   |     |----<cpuacct.usage>
> > > 	   |     |----<cpu.shares>
> > > 	   |     |
> > > 	   |     |---[a1]
> > > 	   |           |----<tasks>
> > > 	   |   	       |----<cpuacct.usage>
> > > 	   |           |----<cpu.shares>
> > > 	   |           |
> > > 	   |
> > > 	   |----[B]
> > > 	   |     |----<tasks>
> > > 	   |     |----<cpuacct.usage>
> > > 	   |     |----<cpu.shares>
> > > 	   |     
> > > 
> > > 
> > > Here are some questions that arise in this picture:
> > > 
> > > 1. What is the relationship of the task-group in A/tasks with the
> > >    task-group in A/a1/tasks? In otherwords do they form siblings
> > >    of the same parent A?
> > > 
> > 
> > I consider them to be the same relationship between directories and files.
> > A/tasks are siblings of A/a1 and A/other children, *but* the entities of
> > interest are A and A/a1.
> > 
> > > 2. Somewhat related to the above question, how much resource should the 
> > >    task-group A/a1/tasks get in relation to A/tasks? Is it 1/2 of parent
> > >    A's share or 1/(1 + N) of parent A's share (where N = number of tasks
> > >    in A/tasks)?
> > > 
> > 
> > I propose that it gets 1/2 of the bandwidth, here is why
> > 
> > 1. Assume that a task in A/tasks forks 1000 children, what happens to the
> > bandwidth of A/a1's tasks then? We have no control over how many tasks can be
> > created on A/tasks as a consequence of moving one task to A/tasks. Doing it the
> > other way would mean, that A/a1/tasks will get 1/1001 of the bandwidth (sounds
> > very unfair and prone to Denial of Service/Fairness)
> 
> And I oppose this, it means not all siblings are treated equal. Also, I
> miss the story of the 'hidden' group here. The biggest objection is this
> hidden group with no direct controls.
> 
> My proposal is to make it a hard constraint, either a group has task
> children or a group has group children, but not mixed. That keeps the
> interface explicit and doesn't hide the tricks we play.
> 

That is one solution. Otherwise you provide the controls for the hidden
group. (Namely the shares and the rt_ratio). I've been experimenting
with this approach recently.

<snip>

> > > Note that user cannot create subdirectories under def_child with this
> > > scheme! I am also not sure what impact this will have on other resources
> > > like cpusets ..
> > > 

I'm not sure why it would affect other resources? The def_child is not
exposed to the cgroup filesystem. Could someone please explain it to me?

> > 
> > Which means we'll need special logic in the cgroup filesystem to handle
> > def_child. Not a very good idea.
> 
> agreed.

-- 
regards,
Dhaval
