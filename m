Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbXKZSwq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbXKZSwq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 13:52:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbXKZSwj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 13:52:39 -0500
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53701 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800AbXKZSwi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 13:52:38 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] teach set_special_pids() to use struct pid
References: <20071126142555.GA16528@tv-sign.ru>
Date: Mon, 26 Nov 2007 11:51:17 -0700
In-Reply-To: <20071126142555.GA16528@tv-sign.ru> (Oleg Nesterov's message of
	"Mon, 26 Nov 2007 17:25:55 +0300")
Message-ID: <m18x4kon6i.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@tv-sign.ru> writes:

> Change set_special_pids() to work with struct pid, not pid_t from global name
> space. This again speedups and imho cleanups the code.
>
> Signed-off-by: Oleg Nesterov <oleg@tv-sign.ru>

Overall I like it, and the version I keep meaning to send missed
the fact we only need a single argument.

> -static void set_special_pids(pid_t session, pid_t pgrp)
> +static void set_special_pids(struct pid *pid)
>  {
>  	write_lock_irq(&tasklist_lock);
> -	__set_special_pids(session, pgrp);
> +	__set_special_pids(pid);
>  	write_unlock_irq(&tasklist_lock);
>  }
>  
> @@ -385,7 +386,11 @@ void daemonize(const char *name, ...)
>  	 */
>  	current->flags |= PF_NOFREEZE;
>  
> -	set_special_pids(1, 1);
> +	if (current->nsproxy != &init_nsproxy) {
> +		get_nsproxy(&init_nsproxy);
> +		switch_task_namespaces(current, &init_nsproxy);
> +	}

Is there a reason for moving this hunk of code?

I don't see one as set_special_pids does everything with either
struct pid or global pid values.  And attach_pid and detach_pid
don't care.

Eric
