Return-Path: <linux-kernel-owner+w=401wt.eu-S1761582AbXGOMRU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761582AbXGOMRU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2007 08:17:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759201AbXGOMRN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jul 2007 08:17:13 -0400
Received: from mail.screens.ru ([213.234.233.54]:56573 "EHLO mail.screens.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759106AbXGOMRM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2007 08:17:12 -0400
Date: Sun, 15 Jul 2007 16:17:50 +0400
From: Oleg Nesterov <oleg@tv-sign.ru>
To: Sukadev Bhattiprolu <sukadev@us.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Cedric Le Goater <clg@fr.ibm.com>, Dave Hansen <haveblue@us.ibm.com>,
       Serge Hallyn <serue@us.ibm.com>, Herbert Poetzel <herbert@13thfloor.at>,
       Pavel Emelianov <xemul@openvz.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] Use task_pid() to find leader's pid
Message-ID: <20070715121750.GA173@tv-sign.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu wrote:
>
> Use task_pid() to get leader's pid since find_pid() cannot be used
> after detach_pid(). See comments in the code below for more details.
>
> ...
>
> +		 * Note: With multiple pid namespaces, active pid namespace of
> +		 * 	 a process is stored in its struct pid. The detach_pid
> +		 * 	 below frees the struct pid, so we will have no notion
> +		 * 	 of an active pid namespace until we complete the
> +		 * 	 subsequent attach_pid(). Which means - calls like
> +		 * 	 find_pid()/pid_to_nr() return NULL and cannot be used
> +		 * 	 between the detach_pid() and attach_pid() calls.

I think both the changelog and the comment are confusing,

>  		detach_pid(tsk, PIDTYPE_PID);
>  		tsk->pid = leader->pid;
> -		attach_pid(tsk, PIDTYPE_PID,  find_pid(tsk->pid));
> +		attach_pid(tsk, PIDTYPE_PID,  task_pid(leader));

because the change itself looks like an obvious performance fix, even
we don't use multiple pid namespaces. I don't think it is good idea to
add a fat comment which doesn't match the current reality, and find_pid()
should be avoided anyway.

Stupid question: why do we need to put the pid namespace into the struct
pid? Isn't it better if the user of the struct pid should know its ns?
For example, if /proc does put_pid(), that pid should be from the active
namespace.

Sukadev, could you cc me if you do that kind of changes?

Oleg.

