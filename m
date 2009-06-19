Return-Path: <linux-kernel-owner+w=401wt.eu-S1759209AbZFSC2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759209AbZFSC2f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 22:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754235AbZFSC22
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 22:28:28 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:61023 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753798AbZFSC21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 22:28:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NXdmn5snx+CuC2qZaSdO3LPNz6ODN08kdc79sIGn8EcJI53GDUknfHhhf+JmlCpYdW
         CY1ciIq4MFkBpzHUVA1JDZmsUqnDy3UKVwtiWoRYMaf4aOWpOuSlmwj3UBHypUYM10gg
         WAhvaaaGrQ3Rxo2wMX+ju+2Ej7agv1KdoLGHk=
Date: Fri, 19 Jun 2009 04:28:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Jason Baron <jbaron@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       jiayingz@google.com, bligh@google.com, roland@redhat.com,
       fche@redhat.com
Subject: Re: [PATCH 6/7] add syscall tracepoints
Message-ID: <20090619022825.GD7903@nowhere>
References: <cover.1244837725.git.jbaron@redhat.com> <a092c3d0e03e64ef8b2b6d5ed9f5b6e3c07cf2d8.1244837725.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a092c3d0e03e64ef8b2b6d5ed9f5b6e3c07cf2d8.1244837725.git.jbaron@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 12, 2009 at 05:25:04PM -0400, Jason Baron wrote:
> Allow the return value of raw_init() to bail us out of creating a trace event
> file.
> 
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> 
> ---
>  kernel/trace/trace_events.c |   29 +++++++++++++++++++----------
>  1 files changed, 19 insertions(+), 10 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 9e91c4a..c0da5e2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -907,15 +907,6 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  	if (strcmp(call->system, TRACE_SYSTEM) != 0)
>  		d_events = event_subsystem_dir(call->system, d_events);
>  
> -	if (call->raw_init) {
> -		ret = call->raw_init();
> -		if (ret < 0) {
> -			pr_warning("Could not initialize trace point"
> -				   " events/%s\n", call->name);
> -			return ret;
> -		}
> -	}
> -
>  	call->dir = debugfs_create_dir(call->name, d_events);
>  	if (!call->dir) {
>  		pr_warning("Could not create debugfs "
> @@ -1014,6 +1005,7 @@ static void trace_module_add_events(struct module *mod)
>  	struct ftrace_module_file_ops *file_ops = NULL;
>  	struct ftrace_event_call *call, *start, *end;
>  	struct dentry *d_events;
> +	int ret;
>  
>  	start = mod->trace_events;
>  	end = mod->trace_events + mod->num_trace_events;
> @@ -1029,7 +1021,15 @@ static void trace_module_add_events(struct module *mod)
>  		/* The linker may leave blanks */
>  		if (!call->name)
>  			continue;
> -
> +		if (call->raw_init) {
> +			ret = call->raw_init();
> +			if (ret < 0) {
> +				if (ret != -ENOSYS)



I see you've set it up in case syscall_to_nr doesn't find the
matching metadata.

How is it possible? The traced syscalls, ie those which are defined through
DEFINE_SYSCALLx(), should be all in the arch syscall table. Or may be I'm
missing something?

In this case we should warn because it would reveal a bug.



> +					pr_warning("Could not initialize trace"
> +					"point events/%s\n", call->name);
> +				continue;
> +			}
> +		}
>  		/*
>  		 * This module has events, create file ops for this module
>  		 * if not already done.
> @@ -1167,6 +1167,15 @@ static __init int event_trace_init(void)
>  		/* The linker may leave blanks */
>  		if (!call->name)
>  			continue;
> +		if (call->raw_init) {
> +			ret = call->raw_init();
> +			if (ret < 0) {
> +				if (ret != -ENOSYS)
> +					pr_warning("Could not initialize trace"
> +					"point events/%s\n", call->name);
> +				continue;
> +			}
> +		}
>  		list_add(&call->list, &ftrace_events);
>  		event_create_dir(call, d_events, &ftrace_event_id_fops,
>  				 &ftrace_enable_fops, &ftrace_event_filter_fops,
> -- 
> 1.6.0.6
> 

