Return-Path: <linux-kernel-owner+w=401wt.eu-S1761915AbYA2R2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761915AbYA2R2S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2008 12:28:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752406AbYA2R2A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jan 2008 12:28:00 -0500
Received: from sinclair.provo.novell.com ([137.65.248.137]:30187 "EHLO
	sinclair.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbYA2R2A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2008 12:28:00 -0500
Message-Id: <479F1A4F.BA47.005A.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Tue, 29 Jan 2008 10:21:35 -0700
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Paul Jackson" <pj@sgi.com>
Cc: <a.p.zijlstra@chello.nl>, <mingo@elte.hu>, <dmitry.adamushko@gmail.com>,
       <rostedt@goodmis.org>, <menage@google.com>, <rientjes@google.com>,
       <tong.n.li@intel.com>, <tglx@linutronix.de>,
       <akpm@linux-foundation.org>, <dhaval@linux.vnet.ibm.com>,
       <vatsa@linux.vnet.ibm.com>, <sgrubb@redhat.com>,
       <linux-kernel@vger.kernel.org>, <ebiederm@xmission.com>,
       <nickpiggin@yahoo.com.au>
Subject: Re: scheduler scalability - cgroups, cpusets and
	load-balancing
References: <1201600428.28547.87.camel@lappy>
 <1201604243.28547.101.camel@lappy> <20080129053005.bc7a11d7.pj@sgi.com>
 <1201607401.28547.124.camel@lappy> <479F0507.BA47.005A.0@novell.com>
 <20080129105104.d70f36ef.pj@sgi.com>
In-Reply-To: <20080129105104.d70f36ef.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On Tue, Jan 29, 2008 at 11:51 AM, in message
<20080129105104.d70f36ef.pj@sgi.com>, Paul Jackson <pj@sgi.com> wrote: 
> Gregory wrote:
>> This is correct.  We have the balance policy polymorphically associated
>> with each sched_class, and the CFS load-balancer and RT "load" (really,
>> priority) balancer can coexist together at the same time and across
>> arbitrary #s of cores
> 
> So ... we have the option of having all sched_classes coexist 
> polymorphically.
> 
> That I didn't realize until this thread.

Its on a per-task basis when the task elects SCHED_FIFO/RR/BATCH/OTHER, etc.  If the task is on a particular RQ, the RQ operates under the policy of that class.  There are some cases where the RQ consults the policy of all classes, but they are still influenced by whether there are actual tasks running within the scope of the current cpuset (or root-domain).

> 
> Now ... do we -want- to ?)

I think so, yes.  But I will give the disclaimer that I don't fully understand your world ;)

You could certainly create a group of cpus with homogeneous policy by creating a cpuset with only tasks of a single class as members.  But likewise, if you populate a cpuset with tasks from mixed classes, you have mixed balance policy affecting those cpus.


> 
> That is, what is the easiest kernel-user API to work with and understand?
> 
> Is it one where we essentially expose sched_class to user space, and let
> them pick their sched_class, or pick none of the above (don't balance)?

IMHO it works well the way it is:  The user selects the class for a particular task using sched_setscheduler(), and they select the cpuset (or inherit it) that defines its execution scope.  If that scope has balancing enabled, the policy for the member classes is in effect.

(on this topic, note that I do not know if the RT-balancer will respect the cpuset concept of "balance-enabled" anyway.  That might have to be fixed)

Again, the disclaimer that I do not have expertise in your area, so perhaps this is naive.

> 
> Or is it one where, other than the special case my batch schedulers need
> to not balance at all, we expose nothing more to user space, and provide
> all sched_class load balancers to all sched_domains (other than those
> not balanced at all)?



