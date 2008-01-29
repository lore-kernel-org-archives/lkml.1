Return-Path: <linux-kernel-owner+w=401wt.eu-S1760722AbYA2WYr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760722AbYA2WYr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 17:24:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759521AbYA2WXw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 17:23:52 -0500
Received: from ms-smtp-02.nyroc.rr.com ([24.24.2.56]:39418 "EHLO
	ms-smtp-02.nyroc.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759471AbYA2WXu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 17:23:50 -0500
Date: Tue, 29 Jan 2008 17:23:28 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Gregory Haskins <ghaskins@novell.com>
cc: Paul Jackson <pj@sgi.com>, a.p.zijlstra@chello.nl, mingo@elte.hu,
       dmitry.adamushko@gmail.com, menage@google.com, rientjes@google.com,
       tong.n.li@intel.com, tglx@linutronix.de, akpm@linux-foundation.org,
       dhaval@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com, sgrubb@redhat.com,
       linux-kernel@vger.kernel.org, ebiederm@xmission.com,
       nickpiggin@yahoo.com.au
Subject: Re: scheduler scalability - cgroups, cpusets and load-balancing
In-Reply-To: <479F4E1A.BA47.005A.0@novell.com>
Message-ID: <Pine.LNX.4.58.0801291712450.20371@gandalf.stny.rr.com>
References: <1201600428.28547.87.camel@lappy> <1201604243.28547.101.camel@lappy>
 <20080129053005.bc7a11d7.pj@sgi.com> <479F01AF.BA47.005A.0@novell.com>
 <20080129102836.be614579.pj@sgi.com> <479F1118.BA47.005A.0@novell.com>
 <20080129133700.7f1ab444.pj@sgi.com> <479F4631.BA47.005A.0@novell.com>
 <20080129145647.579b7d53.pj@sgi.com> <479F4E1A.BA47.005A.0@novell.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 29 Jan 2008, Gregory Haskins wrote:
> >
> > I would like to get our concepts clear, and terms consistent.  That's
> > important for those others who would try to understand this.
>
> Very good idea.  Thanks for doing this!
>

Sorry for coming in so late, I've been banging my head on different bugs
all day.

Just to clear up what our goal for the RT balancer was, and how simple it
is ;-)  Basically any task that has an RT priority needs to run ASAP from
the time it woke up if there's a CPU available that it can run on and it
has a higher priority than what is currently running on that CPU.

If an RT task wakes up, and there's a CPU available somewhere for it to
run on, we want the RT task to jump to that CPU and run. RT tasks should
not be waiting around for nice load balancing that optimizes the cache
usage.  But we also have a problem as well. We don't want to kill the
cache on large NUMA architectures by looking for places for on RT task to
run.  With domains, we first look for a place that an RT task can run on a
local CPU in the node, if so, then place it there, otherwise look at other
nodes to run on.

Note, that the RT balancing is aggressive and not passive. That means that
the balancing takes place at the time the RT task is awoken (perhaps by
the task that is waking it) or at the time a task changes priority. It is
not passive, being that it waits for something else to migrate it
(i.e. migration thread)

Paul, I think you now understand that we don't have some scheduler domain
that is specific for RT. The scheduling class is specific to the priority
of the process and not to what domain it is in. But if you keep a domain
invisible to an RT task, that domain never needs to worry about RT tasks
migrating to it.

The code that Gregory and I have been adding was to try to migrate RT
tasks to CPUs they can run on as quick as possible without algorithms that
cause cacheline bouncing.

-- Steve

