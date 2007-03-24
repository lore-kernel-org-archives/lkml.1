Return-Path: <linux-kernel-owner+w=401wt.eu-S1752169AbXCXO5w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbXCXO5w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2007 10:57:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752680AbXCXO5v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Mar 2007 10:57:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:45540 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbXCXO5u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2007 10:57:50 -0400
Date: Sat, 24 Mar 2007 20:35:05 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, ebiederm@xmission.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       containers@lists.osdl.org, mbligh@google.com, winget@google.com,
       rohitseth@google.com, devel@openvz.org
Subject: Re: [ckrm-tech] [PATCH 1/7] containers (V7): Generic container system abstracted from cpusets code
Message-ID: <20070324150505.GB9475@in.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <20070212081521.808338000@menage.corp.google.com> <20070212085104.130746000@menage.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070212085104.130746000@menage.corp.google.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 12, 2007 at 12:15:22AM -0800, menage@google.com wrote:
> +static int attach_task(struct container *cont, char *pidbuf, char **ppathbuf)
> +{
> +	pid_t pid;
> +	struct task_struct *tsk;
> +	struct container *oldcont;
> +	int retval;
> +
> +	if (sscanf(pidbuf, "%d", &pid) != 1)
> +		return -EIO;
> +
> +	if (pid) {
> +		read_lock(&tasklist_lock);
> +
> +		tsk = find_task_by_pid(pid);
> +		if (!tsk || tsk->flags & PF_EXITING) {

This is probably carrying over code from cpuset.c, but :

/me thinks that there is a ugly race here with 'tsk' exiting.
What happens if the tsk is marked PF_EXITING just after this check?
If that happens, then:

> +			read_unlock(&tasklist_lock);
> +			return -ESRCH;
> +		}
> +
> +		get_task_struct(tsk);
> +		read_unlock(&tasklist_lock);
> +
> +		if ((current->euid) && (current->euid != tsk->uid)
> +		    && (current->euid != tsk->suid)) {
> +			put_task_struct(tsk);
> +			return -EACCES;
> +		}
> +	} else {
> +		tsk = current;
> +		get_task_struct(tsk);
> +	}
> +
> +	retval = security_task_setscheduler(tsk, 0, NULL);
> +	if (retval) {
> +		put_task_struct(tsk);
> +		return retval;
> +	}
> +
> +	mutex_lock(&callback_mutex);
> +
> +	task_lock(tsk);
> +	oldcont = tsk->container;
> +	if (!oldcont) {
> +		task_unlock(tsk);
> +		mutex_unlock(&callback_mutex);
> +		put_task_struct(tsk);
> +		return -ESRCH;
> +	}
> +	atomic_inc(&cont->count);
> +	rcu_assign_pointer(tsk->container, cont);

Above assignment A1 can race with below assignment A2 in container_exit() :

	tsk->container = &top_container; /* the_top_container_hack - see above */

What happens if A1 follows after A2? I feel very uncomfortable abt it.

IMO, we need to use task_lock() in container_exit() to avoid this race.

(I think this race already exists in mainline cpuset.c?)

P.S : cpuset.c checks for PF_EXITING twice in attach_task(), while this
patch seems to be checking only once. Is that fine?


-- 
Regards,
vatsa
