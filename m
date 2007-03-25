Return-Path: <linux-kernel-owner+w=401wt.eu-S964983AbXCYEIr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983AbXCYEIr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 00:08:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965010AbXCYEIr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 00:08:47 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:34979 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964983AbXCYEIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 00:08:46 -0400
Date: Sun, 25 Mar 2007 09:46:02 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Paul Jackson <pj@sgi.com>
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       ebiederm@xmission.com, mbligh@google.com, winget@google.com,
       rohitseth@google.com, serue@us.ibm.com, menage@google.com, dev@sw.ru,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070325041602.GF11794@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com> <20070324150505.GB9475@in.ibm.com> <20070324122559.11b9ba34.pj@sgi.com> <20070325004529.GD11794@in.ibm.com> <20070324184128.e8b34a3e.pj@sgi.com> <20070325022816.GE11794@in.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070325022816.GE11794@in.ibm.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 25, 2007 at 07:58:16AM +0530, Srivatsa Vaddagiri wrote:
> Not just this, continuing further we have more trouble:
> 
> --------------------------------------------------------------------
> CPU0 (attach_task T1 to CS2)			CPU1 (T1 is exiting)
> --------------------------------------------------------------------
> 
> synchronize_rcu()
> 						    atomic_dec(&CS1->count);
> 						    [CS1->count = 0]
> 
> if atomic_dec_and_test(&oldcs->count))
> 	[CS1->count = -1]
> 
> 
> 
> We now have CS1->count negative. Is that good? I am uncomfortable ..
> 
> We need a task_lock() in cpuset_exit to avoid this race.

2nd race is tricky. We probably need to do this to avoid it:

	task_lock(tsk);

	/* Check if tsk->cpuset is still same. We may have raced with 
	 * cpuset_exit changing tsk->cpuset again under our feet.
	 */
	if (tsk->cpuset == cs && atomic_dec_and_test(&oldcs->count)) {
		task_unlock(tsk);
                check_for_release(oldcs, ppathbuf);
		goto done;
	}

	task_unlock(tsk);

done:
	return 0;



-- 
Regards,
vatsa
