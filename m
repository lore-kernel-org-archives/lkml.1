Return-Path: <linux-kernel-owner+w=401wt.eu-S965263AbXCYEpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965263AbXCYEpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:45:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965225AbXCYEpy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:45:54 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:57725 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S965271AbXCYEpx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:45:53 -0400
Date: Sat, 24 Mar 2007 21:45:50 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, dev@sw.ru,
       rohitseth@google.com, ebiederm@xmission.com, mbligh@google.com,
       winget@google.com, containers@lists.osdl.org, serue@us.ibm.com,
       menage@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container
 system abstracted from cpusets code
Message-Id: <20070324214550.d6e654bf.pj@sgi.com>
In-Reply-To: <20070325022816.GE11794@in.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212085104.130746000@menage.corp.google.com>
	<20070324150505.GB9475@in.ibm.com>
	<20070324122559.11b9ba34.pj@sgi.com>
	<20070325004529.GD11794@in.ibm.com>
	<20070324184128.e8b34a3e.pj@sgi.com>
	<20070325022816.GE11794@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
> Now consider:

Nice work - thanks.  Yes, both an extra cpuset count and a negative
cpuset count are bad news, opening the door to the usual catastrophes.

Would you like the honor of submitting the patch to add a task_lock
to cpuset_exit()?  If you do, be sure to fix, or at least remove,
the cpuset_exit comment lines:

 * We don't need to task_lock() this reference to tsk->cpuset,
 * because tsk is already marked PF_EXITING, so attach_task() won't
 * mess with it, or task is a failed fork, never visible to attach_task.

I guess that taking task_lock() in cpuset_exit() should not be a serious
performance issue.  It's taking a spinlock that is in the current
exiting tasks task struct, so it should be a cache hot memory line and
a rarely contested lock.

And I guess I've not see this race in real life, as one side of it has
to execute quite a bit of code in the task exit path, from when it sets
PF_EXITING until it gets into the cpuset_exit() call, while the other side
does the three lines:

	if (tsk->flags & PF_EXITING) ...
	atomic_inc(&cs->count);
	rcu_assign_pointer(tsk->cpuset, cs);

So, in real life, this would be a difficult race to trigger.

Thanks for finding this.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
