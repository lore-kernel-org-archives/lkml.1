Return-Path: <linux-kernel-owner+w=401wt.eu-S1751294AbXCCJhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751294AbXCCJhv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2007 04:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751297AbXCCJhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Mar 2007 04:37:51 -0500
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58896 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751294AbXCCJhu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2007 04:37:50 -0500
Date: Sat, 3 Mar 2007 15:06:55 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: menage@google.com, ebiederm@xmission.com, sam@vilain.net,
       akpm@linux-foundation.org, dev@sw.ru, xemul@sw.ru, serue@us.ibm.com,
       containers@lists.osdl.org, winget@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070303093655.GA1028@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070301113900.a7dace47.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 11:39:00AM -0800, Paul Jackson wrote:
> vatsa wrote:
> > I suspect we can make cpusets also work
> > on top of this very easily.
> 
> I'm skeptical, and kinda worried.
> 
> ... can you show me the code that does this?

In essense, the rcfs patch is same as the original containers
patch. Instead of using task->containers->container[cpuset->hierarchy]
to get to the cpuset structure for a task, it uses
task->nsproxy->ctlr_data[cpuset->subsys_id].

So if the original containers patches could implement cpusets on
containers abstraction, I don't see why it is not possible to implement
on top of nsproxy (which is essentialy same as container_group in Paul
Menage's patches). Any way code speaks best and I will try to post
something soon!

> Namespaces are not the same thing as actual resources
> (memory, cpu cycles, ...).  Namespaces are fluid mappings;
> Resources are scarce commodities.

Yes, perhaps this overloads nsproxy more than what it was intended for.
But, then if we have to to support resource management of each
container/vserver (or whatever group is represented by nsproxy), then nsproxy 
seems the best place to store this resource control information for a container.

> I'm wagering you'll break either the semantics, and/or the
> performance, of cpusets doing this.

It should have the same perf overhead as the original container patches
(basically a double dereference - task->containers/nsproxy->cpuset -
required to get to the cpuset from a task). 

Regarding semantics, can you be more specific?

In fact I think it will facilitate containers to use cpusets more
easily. You can for example divide the system into two (exclusive)
cpusets A and B, and have container C1 work inside A while C2 uses C2. 
So c1's nsproxy->cpuset will point to A will c2's nsproxy->cpuset will
point to B. If you dont want to split the cpus into cpusets like that,
then all nsproxy's->cpuset will point to the top_cpuset.

Basically the rcfs patches demonstrate that is possible to keep track of
hierarchial relationship in resource objects using corresponding file system 
objects itself (like dentries). Also if we are hooked to nsproxy, lot of
hard work to mainain life-time of nsproxy's (ref count ) is already in place - 
we just reuse that work. These should help us avoid the container
structure abstraction in Paul Menage's patches (which was the main
point of objection from last time).

-- 
Regards,
vatsa
