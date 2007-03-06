Return-Path: <linux-kernel-owner+w=401wt.eu-S934015AbXCFKcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934015AbXCFKcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 05:32:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934014AbXCFKcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 05:32:53 -0500
Received: from e5.ny.us.ibm.com ([32.97.182.145]:40799 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934015AbXCFKcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 05:32:52 -0500
Date: Tue, 6 Mar 2007 16:09:40 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, ebiederm@xmission.com,
       winget@google.com, containers@lists.osdl.org, menage@google.com,
       akpm@linux-foundation.org, herbert@13thfloor.at
Subject: Re: [ckrm-tech] [PATCH 0/2] resource control file system - aka containers on top of nsproxy!
Message-ID: <20070306103940.GA2336@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070301133543.GK15509@in.ibm.com> <20070301113900.a7dace47.pj@sgi.com> <20070303093655.GA1028@in.ibm.com> <20070303173244.GA16051@MAIL.13thfloor.at> <20070305173401.GA17044@in.ibm.com> <20070305183937.GC22445@MAIL.13thfloor.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070305183937.GC22445@MAIL.13thfloor.at>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2007 at 07:39:37PM +0100, Herbert Poetzl wrote:
> > Thats why nsproxy has pointers to resource control objects, rather
> > than embedding resource control information in nsproxy itself.
> 
> which makes it a (name)space, no?

I tend to agree, yes!

> > This will let different nsproxy structures share the same resource
> > control objects (ctlr_data) and thus be governed by the same
> > parameters.
> 
> as it is currently done for vfs, uts, ipc and soon
> pid and network l2/l3, yes?

yes (by vfs do you mean mnt_ns?)

> > Where else do you think the resource control information for a
> > container should be stored?
> 
> an alternative for that is to keep the resource
> stuff as part of a 'context' structure, and keep
> a reference from the task to that (one less
> indirection, as we had for vfs before)

something like:

	struct resource_context {
		int cpu_limit;
		int rss_limit;
		/* all other limits here */
	}

	struct task_struct {
		...
		struct resource_context *rc;

	}

?

With this approach, it makes it hard to have task-grouping that are
unique to each resource. 

For ex: lets say that CPU and Memory needs to be divided as follows:

	CPU : C1 (70%), C2 (30%)
	Mem : M1 (60%), M2 (40%)

Tasks T1, T2, T3, T4 are assigned to these resource classes as follows:

	C1 : T1, T3
	C2 : T2, T4
	M1 : T1, T4
	M2 : T2, T3

We had a lengthy discussion on this requirement here:

	http://lkml.org/lkml/2006/11/6/95
	http://lkml.org/lkml/2006/11/1/239

Linus also has expressed a similar view here:

	http://lwn.net/Articles/94573/

Paul Menage's (and its clone rcfs) patches allows this flexibility by simply 
mounting different hierarchies:

	mount -t container -o cpu none /dev/cpu
	mount -t container -o mem none /dev/mem

The task-groups created under /dev/cpu can be completely independent of
task-groups created under /dev/mem.

Lumping together all resource parameters in one struct (like
resource_context above) makes it difficult to provide this feature.	

Now can we live w/o this flexibility? Maybe, I don't know for sure.
Since (stability of) user-interface is in question, we need to take a
carefull decision here.

> > then other derefences (->ctlr_data[] and ->limit) should be fast, as
> > they should be in the cache?
> 
> please provide real world numbers from testing ...

What kind of testing did you have in mind?


-- 
Regards,
vatsa
