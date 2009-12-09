Return-Path: <linux-kernel-owner+w=401wt.eu-S1755382AbZLIGfo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382AbZLIGfo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:35:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754850AbZLIGfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:35:43 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46718 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754374AbZLIGfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:35:42 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
       rostedt@goodmis.org, srostedt@redhat.com, tglx@linutronix.de
Subject: Re: [tip:tracing/urgent] tracing: Add pipe_close interface
Cc: kosaki.motohiro@jp.fujitsu.com, linux-tip-commits@vger.kernel.org,
       hpa@zytor.com, mingo@redhat.com, rostedt@goodmis.org,
       srostedt@redhat.com, tglx@linutronix.de
In-Reply-To: <tip-c521efd1700a8c0f7ce26f011f5eaecca17fabfa@git.kernel.org>
References: <tip-c521efd1700a8c0f7ce26f011f5eaecca17fabfa@git.kernel.org>
Message-Id: <20091209153204.F4CD.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed,  9 Dec 2009 15:35:46 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Commit-ID:  c521efd1700a8c0f7ce26f011f5eaecca17fabfa
> Gitweb:     http://git.kernel.org/tip/c521efd1700a8c0f7ce26f011f5eaecca17fabfa
> Author:     Steven Rostedt <srostedt@redhat.com>
> AuthorDate: Mon, 7 Dec 2009 09:06:24 -0500
> Committer:  Steven Rostedt <rostedt@goodmis.org>
> CommitDate: Mon, 7 Dec 2009 12:01:35 -0500
> 
> tracing: Add pipe_close interface
> 
> An ftrace plugin can add a pipe_open interface when the user opens
> trace_pipe. But if the plugin allocates something within the pipe_open
> it can not free it because there exists no pipe_close. The hook to
> the trace file open has a corresponding close. The closing of the
> trace_pipe file should also have a corresponding close.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c |    4 ++++
>  kernel/trace/trace.h |    2 ++
>  2 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 874f289..f804b40 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2898,6 +2898,10 @@ static int tracing_release_pipe(struct inode *inode, struct file *file)
>  	else
>  		cpumask_clear_cpu(iter->cpu_file, tracing_reader_cpumask);
>  
> +
> +	if (iter->trace->pipe_open)
> +		iter->trace->pipe_close(iter);
> +

What's happen if pipe_close is NULL? Wny following straightforward check
is wrong?
I mean the above description explain pipe_close is only useful if plugin
allocate something at pipe_open. then allowing NULL seems natural.

	if (iter->trace->pipe_close)
		iter->trace->pipe_close(iter);

just nit.




