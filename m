Return-Path: <linux-kernel-owner+w=401wt.eu-S1758518AbXFVRIR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518AbXFVRIR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 13:08:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753193AbXFVRIC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 13:08:02 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:39318 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbXFVRIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 13:08:00 -0400
Date: Fri, 22 Jun 2007 22:46:34 +0530
From: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: mingo@elte.hu, clameter@sgi.com, linux-kernel@vger.kernel.org,
       dino@in.ibm.com, akpm@linux-foundation.org
Subject: Re: cpuset attach_task to touch per-cpu kernel threads?
Message-ID: <20070622171634.GA21543@linux.vnet.ibm.com>
Reply-To: vatsa@linux.vnet.ibm.com
References: <20070621014935.GF10980@linux.vnet.ibm.com> <20070621121635.GB19811@elte.hu> <20070621100712.52a4784a.pj@sgi.com> <20070621173232.GP10980@linux.vnet.ibm.com> <20070621105152.8daf87ad.pj@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070621105152.8daf87ad.pj@sgi.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 21, 2007 at 10:51:52AM -0700, Paul Jackson wrote:
> The only problem comes with kernel tasks that are pinned to less than
> the entire system, and that are in the top cpuset.

That again is not fool-proof. What if kernel-tasks change their cpu affinity
after we have done the is_pinned_kernel_thread() test? Ideally they
should not, but one never knows!

IMHO we simply should not allow kernel threads to move out of top-cpuset
(unless you know of a good reason where we may want to move them).


int cpuset_can_attach()
{

	int is_kthread = !tsk->mm || (tsk->flags & PF_BORROWED_MM);

	...

 	/* Don't moved pinned kernel threads out of top cpuset */
 	if (is_kthread && oldcs == &top_cpuset && cs != oldcs) {
                 task_unlock(tsk);
                 mutex_unlock(&callback_mutex);
                 put_task_struct(tsk);
 		return -EINVAL;
 	}

}


What do you think?

-- 
Regards,
vatsa
