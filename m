Return-Path: <linux-kernel-owner+w=401wt.eu-S1759300AbZCWTTK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759300AbZCWTTK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Mar 2009 15:19:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754072AbZCWTSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Mar 2009 15:18:55 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55324 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbZCWTSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Mar 2009 15:18:53 -0400
Date: Mon, 23 Mar 2009 15:18:49 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: Frederic Weisbecker <fweisbec@gmail.com>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [PATCH 3/5] tracing/ftrace: check if debugfs is registered before
 creating files
In-Reply-To: <1237759847-21025-3-git-send-email-fweisbec@gmail.com>
Message-ID: <alpine.DEB.2.00.0903231517410.3578@gandalf.stny.rr.com>
References: <1237759847-21025-1-git-send-email-fweisbec@gmail.com> <1237759847-21025-3-git-send-email-fweisbec@gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 22 Mar 2009, Frederic Weisbecker wrote:

> Impact: fix a crash with ftrace={nop,boot} parameter
> 
> If the nop or initcall tracers are launched as boot tracers,
> they will attempt to create their option directory and files.
> But these tracers are registered very early and then assigned
> as "boot tracers" very early if asked to.
> 
> Since they do this before debugfs has been registered (core initcall),
> a crash is triggered.
> 
> Another early tracers could also come later. So we fix it by
> checking if debugfs is initialized before creating the root
> tracing directory.
> 
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  kernel/trace/trace.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index ace685c..f0e1337 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -3513,6 +3513,9 @@ struct dentry *tracing_init_dentry(void)
>  	if (d_tracer)
>  		return d_tracer;
>  
> +	if (!debugfs_initialized())
> +		return NULL;
> +
>  	d_tracer = debugfs_create_dir("tracing", NULL);
>  

Hmm, those tracers should separate out the debugfs code, and put it into 
a fs_initcall(), where debugfs should already initialized.

-- Steve

