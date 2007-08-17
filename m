Return-Path: <linux-kernel-owner+w=401wt.eu-S1758773AbXHQWWl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758773AbXHQWWl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 18:22:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752705AbXHQWWf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 18:22:35 -0400
Received: from x346.tv-sign.ru ([89.108.83.215]:32826 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbXHQWWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 18:22:34 -0400
Date: Sat, 18 Aug 2007 02:22:28 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Neil Horman <nhorman@tuxdriver.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: + proc-export-a-processes-resource-limits-via-proc-pid.patch added to -mm tree
Message-ID: <20070817222228.GA783@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Horman wrote:
> 
> +static int proc_pid_limits(struct task_struct *task, char *buffer)
> +{
> +	unsigned int i;
> +	int count = 0;
> +	char *bufptr = buffer;
> +
> +	struct rlimit rlim[RLIM_NLIMITS];
> +
> +	read_lock(&tasklist_lock);
> +	memcpy(rlim, task->signal->rlim, sizeof(struct rlimit) * RLIM_NLIMITS);
> +	read_unlock(&tasklist_lock);

Please don't re-introduce tasklist_lock unless strictly needed. And in this case
it doesn't help, sys_getrlimit() changes ->rlim[] under task_lock().

Hovewer, I think the whole patch is not right. The "tsk" itself is pinned, but its
->signal is not stable and can be == NULL.

You can use lock_task_sighand() to access ->signal.

Oleg.

