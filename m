Return-Path: <linux-kernel-owner+w=401wt.eu-S1759576AbZEGQYc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759576AbZEGQYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 12:24:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754936AbZEGQYW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 12:24:22 -0400
Received: from mail-bw0-f174.google.com ([209.85.218.174]:53565 "EHLO
	mail-bw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754421AbZEGQYV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 12:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w7fPUHyy9iSnchPdbVvqCk15z7ICg6hcejodfnAH0YrRjxd81Rw4htgsG4xOZgQRkw
         NKcTI1IF4osp0XOTlJGqAHL4DNUyVAwj2nR+blOAhyhAEn57U1a/od8knfXVMoia4wCR
         A1ylOh6/oZD/B2UarZ5NlYxmwoMcNUNnfndaI=
Date: Thu, 7 May 2009 18:24:18 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Li Zefan <lizf@cn.fujitsu.com>, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 6/7] tracing: reset ring buffer when removing modules
	with events
Message-ID: <20090507162415.GA5987@nowhere>
References: <20090507031335.815354104@goodmis.org> <20090507031434.586509269@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090507031434.586509269@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 11:13:41PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Li Zefan found that there's a race using the event ids of events and
> modules. When a module is loaded, an event id is incremented. We only
> have 16 bits for event ids (65536) and there is a possible (but highly
> unlikely) race that we could load and unload a module that registers
> events so many times that the event id counter overflows.
> 
> When it overflows, it then restarts and goes looking for available
> ids. An id is available if it was added by a module and released.
> 
> The race is if you have one module add an id, and then is removed.
> Another module loaded can use that same event id. But if the old module
> still had events in the ring buffer, the new module's call back would
> get bogus data.  At best (and most likely) the output would just be
> garbage. But if the module for some reason used pointers (not recommended)
> then this could potentially crash.
> 
> The safest thing to do is just reset the ring buffer if a module that
> registered events is removed.
> 
> [ Impact: prevent unpredictable results of event id overflows ]
> 
> Reported-by: Li Zefan <lizf@cn.fujitsu.com>
> LKML-Reference: <49FEAFD0.30106@cn.fujitsu.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace.c        |   10 ++++++++++
>  kernel/trace/trace.h        |    2 ++
>  kernel/trace/trace_events.c |    9 +++++++++
>  3 files changed, 21 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 4164a34..dd40d23 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -639,6 +639,16 @@ void tracing_reset_online_cpus(struct trace_array *tr)
>  		tracing_reset(tr, cpu);
>  }
>  
> +void tracing_reset_current(int cpu)
> +{
> +	tracing_reset(&global_trace, cpu);
> +}
> +
> +void tracing_reset_current_online_cpus(void)
> +{
> +	tracing_reset_online_cpus(&global_trace);
> +}
> +
>  #define SAVED_CMDLINES 128
>  #define NO_CMDLINE_MAP UINT_MAX
>  static unsigned map_pid_to_cmdline[PID_MAX_DEFAULT+1];
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 777c6c3..ba25793 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -409,6 +409,8 @@ int tracing_is_enabled(void);
>  void trace_wake_up(void);
>  void tracing_reset(struct trace_array *tr, int cpu);
>  void tracing_reset_online_cpus(struct trace_array *tr);
> +void tracing_reset_current(int cpu);
> +void tracing_reset_current_online_cpus(void);
>  int tracing_open_generic(struct inode *inode, struct file *filp);
>  struct dentry *trace_create_file(const char *name,
>  				 mode_t mode,
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 8d579ff..6d2c842 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -932,9 +932,11 @@ static void trace_module_remove_events(struct module *mod)
>  {
>  	struct ftrace_module_file_ops *file_ops;
>  	struct ftrace_event_call *call, *p;
> +	bool found = false;
>  
>  	list_for_each_entry_safe(call, p, &ftrace_events, list) {
>  		if (call->mod == mod) {
> +			found = true;
>  			if (call->enabled) {
>  				call->enabled = 0;
>  				call->unregfunc();
> @@ -957,6 +959,13 @@ static void trace_module_remove_events(struct module *mod)
>  		list_del(&file_ops->list);
>  		kfree(file_ops);
>  	}
> +
> +	/*
> +	 * It is safest to reset the ring buffer if the module being unloaded
> +	 * registered any events.
> +	 */
> +	if (found)
> +		tracing_reset_current_online_cpus();
>  }



I would suggest to send a single trace_printk message after that
which says:

# current trace buffer content deleted due to module %s unloading

So that no one would end up being stucked while searching why tracing
during module unloading (eg: a module_exit callback of a driver)
never produce any trace :-)

Also there is still a narrow race:

tracing_read_pipe() {
  get_entry_from_buffer();
  tracer_output_callback() {
    ...				              module_unloading()
    dereference_freed_pointer_from_entry()

But at least this patch fixes most of the race window.

Frederic.

