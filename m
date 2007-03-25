Return-Path: <linux-kernel-owner+w=401wt.eu-S1753014AbXCYAiV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753014AbXCYAiV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 20:38:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753010AbXCYAiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 20:38:21 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:48520 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbXCYAiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 20:38:20 -0400
Date: Sun, 25 Mar 2007 06:15:29 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070325004529.GD11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070324150505.GB9475@in.ibm.com> <20070324122559.11b9ba34.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070324122559.11b9ba34.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 24, 2007 at 12:25:59PM -0700, Paul Jackson wrote:
> > P.S : cpuset.c checks for PF_EXITING twice in attach_task(), while this
> > patch seems to be checking only once. Is that fine?
> 
> I think the cpuset code is ok, because, as you note, it locks the task,
> picks off the cpuset pointer, and then checks a second time that the
> task still does not have PF_EXITING set:

Well afaics, PF_EXITING is set for the exiting task w/o taking any lock, which
makes this racy always.

> In the kernel/cpuset.c code for attach_task():
> 
>         task_lock(tsk);
>         oldcs = tsk->cpuset;
>         /*
>          * After getting 'oldcs' cpuset ptr, be sure still not exiting.
>          * If 'oldcs' might be the top_cpuset due to the_top_cpuset_hack
>          * then fail this attach_task(), to avoid breaking top_cpuset.count.
>          */
>         if (tsk->flags & PF_EXITING) {

What if PF_EXITING is set after this check? If that happens then,

>                 task_unlock(tsk);
>                 mutex_unlock(&callback_mutex);
>                 put_task_struct(tsk);
>                 return -ESRCH;
>         }

the following code becomes racy with cpuset_exit() ...

        atomic_inc(&cs->count);
        rcu_assign_pointer(tsk->cpuset, cs);
        task_unlock(tsk);


-- 
Regards,
vatsa
