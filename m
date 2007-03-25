Return-Path: <linux-kernel-owner+w=401wt.eu-S964807AbXCYCU7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964807AbXCYCU7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 22:20:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964812AbXCYCU7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 22:20:59 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:58686 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964807AbXCYCU6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 22:20:58 -0400
Date: Sun, 25 Mar 2007 07:58:16 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070325022816.GE11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070324150505.GB9475@in.ibm.com> <20070324122559.11b9ba34.pj@sgi.com> <20070325004529.GD11794@in.ibm.com> <20070324184128.e8b34a3e.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324184128.e8b34a3e.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 06:41:28PM -0700, Paul Jackson wrote:
> > the following code becomes racy with cpuset_exit() ...
> > 
> >         atomic_inc(&cs->count);
> >         rcu_assign_pointer(tsk->cpuset, cs);
> >         task_unlock(tsk);
> 
> eh ... so ... ?
> 
> I don't know of any sequence where that causes any problem.
> 
> Do you see one?

Let's say we had two cpusets CS1 amd CS2 (both different from top_cpuset).
CS1 has just one task T1 in it (CS1->count = 0) while CS2 has no tasks
in it (CS2->count = 0).

Now consider:

--------------------------------------------------------------------
CPU0 (attach_task T1 to CS2)			CPU1 (T1 is exiting)
--------------------------------------------------------------------

task_lock(T1);

oldcs = tsk->cpuset;
[oldcs = CS1]

T1->flags & PF_EXITING? (No)			

						T1->flags = PF_EXITING;

atomic_inc(&CS2->count);

						cpuset_exit()
						    cs = tsk->cpuset; (cs = CS1)
							
T1->cpuset = CS2;

						    T1->cpuset = &top_cpuset;

task_unlock(T1);


CS2 has one bogus count now (with no tasks in it), which may prevent it from 
being removed/freed forever.


Not just this, continuing further we have more trouble:

--------------------------------------------------------------------
CPU0 (attach_task T1 to CS2)			CPU1 (T1 is exiting)
--------------------------------------------------------------------

synchronize_rcu()
						    atomic_dec(&CS1->count);
						    [CS1->count = 0]

if atomic_dec_and_test(&oldcs->count))
	[CS1->count = -1]



We now have CS1->count negative. Is that good? I am uncomfortable ..

We need a task_lock() in cpuset_exit to avoid this race.

-- 
Regards,
vatsa
