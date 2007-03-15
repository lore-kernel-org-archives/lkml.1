Return-Path: <linux-kernel-owner+w=401wt.eu-S1422966AbXCOQ5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422966AbXCOQ5v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 12:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1422967AbXCOQ5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 12:57:51 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:54198 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422966AbXCOQ5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 12:57:50 -0400
Date: Thu, 15 Mar 2007 22:34:35 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: xemul@sw.ru, dev@sw.ru, pj@sgi.com, sam@vilain.net, ebiederm@xmission.com,
       winget@google.com, serue@us.ibm.com, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, ckrm-tech@lists.sourceforge.net,
       containers@lists.osdl.org
Subject: Re: Summary of resource management discussion
Message-ID: <20070315170435.GA28692@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070312124226.GD17151@in.ibm.com> <6599ad830703150424t3478cd55mf9d2699f3669c9f0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830703150424t3478cd55mf9d2699f3669c9f0@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 04:24:37AM -0700, Paul Menage wrote:
> If there really was a grouping that was always guaranteed to match the
> way you wanted to group tasks for e.g. resource control, then yes, it
> would be great to use it. But I don't see an obvious candidate. The
> pid namespace is not it, IMO.

In vserver context, what is the "normal" case then? Atleast for Linux
Vserver pid namespace seems to be normal unit of resource control (as per 
Herbert). 

Even if one wanted to manage a arbitrary group of tasks in vserver
context, IMHO its still possible to construct that arbitrary group using 
the existing pointer, ns[/task]proxy, and not break existing namespace 
semantics/functionality. 

So the normal case I see is:

    pid_ns1  uts_ns1  cpu_ctl_space1   pid_ns2   uts_ns2  cpu_ctl_space2
      ^        ^           (50%)          ^          ^          (50%)
      |        |	     ^	          |          |           ^
      |	       |	     |            |          |           |
     ---------------------------        -------------------------------
    |      task_proxy1          |      |         task_proxy2           |
    |       (Vserver1)          |      |          (Vserver2)           |
     ---------------------------        -------------------------------


But, if someone wanted to manage cpu resource differently, and say that
postgres tasks from both vservers should be in same cpu resource class, 
the above becomes:


    pid_ns1 uts_ns1 cpu_ctl_space1      pid_ns1 uts_ns1 cpu_ctl_space2
       ^       ^	  (25%)              ^        ^        (50%)
       |       |           ^                 |        |          ^
       |       |           |                 |        |          |
     ---------------------------       -------------------------------
    |      task_proxy1          |     |          task_proxy2          |
    |       (Vserver1)          |     |  (postgres tasks in VServer1) |
     ---------------------------       -------------------------------
    
    
    pid_ns2 uts_ns2 cpu_ctl_space3      pid_ns2 uts_ns2 cpu_ctl_space2
       ^       ^	 (25%)              ^        ^        (50%)
       |       |          ^                 |        |          ^
       |       |          |                 |        |          |
     ---------------------------       ------------------------------
    |      task_proxy3          |     |          task_proxy4         |
    |       (Vserver2)          |     |  (postgres tasks in VServer2 |
     ---------------------------       ------------------------------

(the best I could draw using ASCII art!)

The benefit I see of this approach is it will avoid introduction of 
additional pointers in struct task_struct and also additional structures
(struct container etc) in the kernel, but we will still be able to retain 
same user interfaces you had in your patches.

Do you see any drawbacks of doing like this? What will break if we do
this?

> Resource control (and other kinds of task grouping behaviour) shouldn't 
> require virtualization.

Certainly. AFAICS, nsproxy[.c] is unconditionally available in the
kernel (even if virtualization support is not enabled). When reused for 
pure resource control purpose, I see that as a special case of virtualization
where only resources are virtualized and namespaces are not.

I think an interesting question would be : what more task-grouping
behavior do you want to implement using an additional pointer that you
can't reusing ->task_proxy?

> >a. Paul Menage's patches:
> >
> >        (tsk->containers->container[cpu_ctlr.subsys_id] - X)->cpu_limit
> 
> So what's the '-X' that you're referring to

Oh ..that's to seek pointer to begining of the cpulimit structure (subsys
pointer in 'struct container' points to a structure embedded in a larger
structure. -X gets you to point to the larger structure).

> >6. As tasks move around namespaces/resource-classes, their
> >   tsk->nsproxy/containers object will change. Do we simple create
> >   a new nsproxy/containers object or optimize storage by searching
> >   for one which matches the task's new requirements?
> 
> I think the latter.

Yes me too. But maybe to keep in simple in initial versions, we should
avoid that optimisation and at the same time get statistics on duplicates?.

-- 
Regards,
vatsa
