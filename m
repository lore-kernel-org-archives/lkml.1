Return-Path: <linux-kernel-owner+w=401wt.eu-S1752336AbXCYFnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336AbXCYFnw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2007 01:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752261AbXCYFnw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Mar 2007 01:43:52 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:33040 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751275AbXCYFnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2007 01:43:51 -0400
Date: Sat, 24 Mar 2007 22:43:48 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@in.ibm.com
Cc: sekharan@us.ibm.com, ckrm-tech@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, xemul@sw.ru, containers@lists.osdl.org,
       ebiederm@xmission.com, mbligh@google.com, winget@google.com,
       rohitseth@google.com, serue@us.ibm.com, menage@google.com, dev@sw.ru,
       devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container
 system abstracted from cpusets code
Message-Id: <20070324224348.eeb96048.pj@sgi.com>
In-Reply-To: <20070325041602.GF11794@in.ibm.com>
References: <20070212081521.808338000@menage.corp.google.com>
	<20070212085104.130746000@menage.corp.google.com>
	<20070324150505.GB9475@in.ibm.com>
	<20070324122559.11b9ba34.pj@sgi.com>
	<20070325004529.GD11794@in.ibm.com>
	<20070324184128.e8b34a3e.pj@sgi.com>
	<20070325022816.GE11794@in.ibm.com>
	<20070325041602.GF11794@in.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vatsa wrote:
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
> ...
> 2nd race is tricky. We probably need to do this to avoid it:
> 
> 	task_lock(tsk);
> 
> 	/* Check if tsk->cpuset is still same. We may have raced with 
> 	 * cpuset_exit changing tsk->cpuset again under our feet.
> 	 */
> 	if (tsk->cpuset == cs && atomic_dec_and_test(&oldcs->count)) {

I'm unsure here, but this 'tsk->cpuset == cs' test feels fragile to me.

How about a bit earlier in attach_task(), right at the point we overwrite the
victim tasks cpuset pointer, we decrement the count on the old cpuset, and if
it went to zero, remember that we'll need to release it, once we've dropped
some locks:

static int attach_task(struct cpuset *cs, char *pidbuf, char **ppathbuf)
{
	...                                                                                         
	struct cpuset *oldcs;
	struct cpuset *oldcs_tobe_released;

	...
	
        task_lock(tsk);
        oldcs = tsk->cpuset;
        ...
        if (tsk->flags & PF_EXITING) {
                ...
        }
        atomic_inc(&cs->count);
        rcu_assign_pointer(tsk->cpuset, cs);
	oldcs_tobe_released = NULL;
	if (atomic_dec_and_test(&oldcs->count))
		oldcs_tobe_released = oldcs;
        task_unlock(tsk);

	...
	put_task_struct(tsk);
        synchronize_rcu();
        if (oldcs_tobe_released)
                check_for_release(oldcs_tobe_released, ppathbuf);
        return 0;
}

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
