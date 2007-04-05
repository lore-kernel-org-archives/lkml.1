Return-Path: <linux-kernel-owner+w=401wt.eu-S1946074AbXDEIGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946074AbXDEIGz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2007 04:06:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946078AbXDEIGz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Apr 2007 04:06:55 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:35374 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946074AbXDEIGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2007 04:06:53 -0400
Date: Thu, 5 Apr 2007 13:44:24 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: "Paul Menage" <menage@google.com>
Cc: "Paul Jackson" <pj@sgi.com>, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, "Balbir Singh" <balbir@in.ibm.com>
Subject: Re: [PATCH] Fix race between attach_task and cpuset_exit
Message-ID: <20070405081424.GA20356@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070325164746.GI11794@in.ibm.com> <20070325125025.b6e8f0d4.pj@sgi.com> <20070326115506.GL11794@in.ibm.com> <6599ad830704042255t5c126a0cj86d644cb8174e177@mail.gmail.com> <20070405070033.GB3435@in.ibm.com> <6599ad830704050001n50d9fa2bw4167c1fa16aa618f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6599ad830704050001n50d9fa2bw4167c1fa16aa618f@mail.gmail.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2007 at 12:01:53AM -0700, Paul Menage wrote:
> I don't see how that could happen. Assuming we add the
> task_lock()/task_unlock() in cpuset_exit(), then only one of the two
> threads (either cpuset_exit() or attach_task() ) can copy C1 from
> T1->cpuset and replace it with something new, and hence only one of
> them can drop the refcount.

You are correct! We can just add the task_lock()/unlock() in cpuset_exit
and be done away with the races I described.

> >How's that possible? That you have a zero-refcount cpuset with non empty
> >tasks in it?
> 
> If this is the last task in cs, then cs->count will be 1. We remove
> this task from cs, and decrement its count to 0. Then another cpu does
> cpuset_rmdir(), takes manage_mutex, sees that the count is 0, cleans
> up the cpuset, drops the dentry, and the cpuset gets freed. Then we
> get to run again, and we dereference an invalid cpuset.

Hmm yes ..I am surprised we arent doing a synhronize_rcu in
cpuset_rmdir() before dropping the dentry. Did you want to send a patch
for that?

attach_task() is ugly ....

-- 
Regards,
vatsa
