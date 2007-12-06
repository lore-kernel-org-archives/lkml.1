Return-Path: <linux-kernel-owner+w=401wt.eu-S1753023AbXLFSoT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753023AbXLFSoT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2007 13:44:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751902AbXLFSoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Dec 2007 13:44:12 -0500
Received: from x346.tv-sign.ru ([89.108.83.215]:60277 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743AbXLFSoL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2007 13:44:11 -0500
Date: Thu, 6 Dec 2007 21:45:02 +0300
From: Oleg Nesterov <oleg@tv-sign.ru>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Linux Containers <containers@lists.osdl.org>,
       Pavel Emelyanov <xemul@openvz.org>, sukadev@us.ibm.com
Subject: Re: [PATCH] pid: sys_wait... fixes (v2)
Message-ID: <20071206184502.GA11752@tv-sign.ru>
References: <m17ijsv7iu.fsf@ebiederm.dsl.xmission.com> <20071206170145.GA10674@tv-sign.ru> <m1k5nrsn18.fsf_-_@ebiederm.dsl.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1k5nrsn18.fsf_-_@ebiederm.dsl.xmission.com>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06, Eric W. Biederman wrote:
> 
> +static struct pid *task_pid_type(struct task_struct *task, enum pid_type type)
> +{
> +	struct pid *pid = NULL;
> +	if (type == PIDTYPE_PID)
> +		pid = task->pids[type].pid;
> +	else if (type < PIDTYPE_MAX)
> +		pid = task->group_leader->pids[type].pid;
> +	return pid;
> +}

Looks like a useful helper regardless.

> +static int eligible_child(enum pid_type type, struct pid *pid, int options,
> +			  struct task_struct *p)
>  {
>  	int err;
> -	struct pid_namespace *ns;
>  
> -	ns = current->nsproxy->pid_ns;
> -	if (pid > 0) {
> -		if (task_pid_nr_ns(p, ns) != pid)
> -			return 0;
> -	} else if (!pid) {
> -		if (task_pgrp_nr_ns(p, ns) != task_pgrp_vnr(current))
> -			return 0;
> -	} else if (pid != -1) {
> -		if (task_pgrp_nr_ns(p, ns) != -pid)
> +	if (type < PIDTYPE_MAX) {
> +		if (task_pid_type(p, type) != pid)
>  			return 0;
>  	}

Minor, minor nit.

If type == PIDTYPE_MAX, pid must be == NULL. but task_pid_type(PIDTYPE_PID)
also returns NULL. So we can just do

	if (task_pid_type(p, type) != pid)
		return 0;

Not that it really makes a difference though.

Oleg.

