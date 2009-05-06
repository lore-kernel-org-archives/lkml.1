Return-Path: <linux-kernel-owner+w=401wt.eu-S1752376AbZEFF1p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752376AbZEFF1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 01:27:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750789AbZEFF1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 01:27:36 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:10917 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbZEFF1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 01:27:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=OqDH4+jPwHGnTrZIK+gbCj4zBwdEdO0w/s8TMytCuovGDDBvo86A8ad5+2JiYVkRkA
         o7EUGD1451920crXNiA4pm1VuKa3IpvzFmzqOh6yc8272EEef2LFiHCvhNJsuRAr7gNg
         6yX8jYKwtbd1yBxjo0m9PtqEI/DYS5qclbu4o=
Date: Wed, 6 May 2009 07:27:31 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 4/4] tracing/events: fix concurrent access to
	ftrace_events list
Message-ID: <20090506052730.GA5986@nowhere>
References: <4A00F6AD.2070008@cn.fujitsu.com> <4A00F709.3080800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A00F709.3080800@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 06, 2009 at 10:33:45AM +0800, Li Zefan wrote:
> A module will add/remove its trace events when it gets loaded/unloaded, so
> the ftrace_events list is not "const", and concurrent access needs to be
> protected.
> 
> This patch thus fixes races between loading/unloding modules and read
> 'available_events' or read/write 'set_event', etc.
> 
> Below shows how to reproduce the race:
> 
>  # for ((; ;)) { cat /mnt/tracing/available_events; } > /dev/null &
>  # for ((; ;)) { insmod trace-events-sample.ko; rmmod sample; } &
> 
> After a while:
> 
> BUG: unable to handle kernel paging request at 0010011c
> IP: [<c1080f27>] t_next+0x1b/0x2d
> ...
> Call Trace:
>  [<c10c90e6>] ? seq_read+0x217/0x30d
>  [<c10c8ecf>] ? seq_read+0x0/0x30d
>  [<c10b4c19>] ? vfs_read+0x8f/0x136
>  [<c10b4fc3>] ? sys_read+0x40/0x65
>  [<c1002a68>] ? sysenter_do_call+0x12/0x36
> 
> [ Impact: fix races when concurrent accessing ftrace_events list ]
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>


Nice series of fixes!

Thanks!

Frederic.


> ---
>  kernel/trace/trace.h               |    1 +
>  kernel/trace/trace_event_profile.c |   19 ++++++++++++++-----
>  kernel/trace/trace_events.c        |   20 +++++++++++---------
>  kernel/trace/trace_events_filter.c |   10 +++++++---
>  4 files changed, 33 insertions(+), 17 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 83984ab..0bba080 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -827,6 +827,7 @@ static int filter_pred_##size(struct filter_pred *pred, void *event,	\
>  	return match;							\
>  }
>  
> +extern struct mutex event_mutex;
>  extern struct list_head ftrace_events;
>  
>  extern const char *__start___trace_bprintk_fmt[];
> diff --git a/kernel/trace/trace_event_profile.c b/kernel/trace/trace_event_profile.c
> index 7bf2ad6..5b5895a 100644
> --- a/kernel/trace/trace_event_profile.c
> +++ b/kernel/trace/trace_event_profile.c
> @@ -10,21 +10,30 @@
>  int ftrace_profile_enable(int event_id)
>  {
>  	struct ftrace_event_call *event;
> +	int ret = -EINVAL;
>  
> +	mutex_lock(&event_mutex);
>  	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id)
> -			return event->profile_enable(event);
> +		if (event->id == event_id) {
> +			ret = event->profile_enable(event);
> +			break;
> +		}
>  	}
> +	mutex_unlock(&event_mutex);
>  
> -	return -EINVAL;
> +	return ret;
>  }
>  
>  void ftrace_profile_disable(int event_id)
>  {
>  	struct ftrace_event_call *event;
>  
> +	mutex_lock(&event_mutex);
>  	list_for_each_entry(event, &ftrace_events, list) {
> -		if (event->id == event_id)
> -			return event->profile_disable(event);
> +		if (event->id == event_id) {
> +			event->profile_disable(event);
> +			break;
> +		}
>  	}
> +	mutex_unlock(&event_mutex);
>  }
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 72d619d..ac5b1c2 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -21,7 +21,7 @@
>  
>  #define TRACE_SYSTEM "TRACE_SYSTEM"
>  
> -static DEFINE_MUTEX(event_mutex);
> +DEFINE_MUTEX(event_mutex);
>  
>  LIST_HEAD(ftrace_events);
>  
> @@ -80,6 +80,7 @@ static void ftrace_clear_events(void)
>  {
>  	struct ftrace_event_call *call;
>  
> +	mutex_lock(&event_mutex);
>  	list_for_each_entry(call, &ftrace_events, list) {
>  
>  		if (call->enabled) {
> @@ -87,6 +88,7 @@ static void ftrace_clear_events(void)
>  			call->unregfunc();
>  		}
>  	}
> +	mutex_unlock(&event_mutex);
>  }
>  
>  static void ftrace_event_enable_disable(struct ftrace_event_call *call,
> @@ -274,6 +276,9 @@ t_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  static void *t_start(struct seq_file *m, loff_t *pos)
>  {
> +	mutex_lock(&event_mutex);
> +	if (*pos == 0)
> +		m->private = ftrace_events.next;
>  	return t_next(m, NULL, pos);
>  }
>  
> @@ -303,6 +308,9 @@ s_next(struct seq_file *m, void *v, loff_t *pos)
>  
>  static void *s_start(struct seq_file *m, loff_t *pos)
>  {
> +	mutex_lock(&event_mutex);
> +	if (*pos == 0)
> +		m->private = ftrace_events.next;
>  	return s_next(m, NULL, pos);
>  }
>  
> @@ -319,12 +327,12 @@ static int t_show(struct seq_file *m, void *v)
>  
>  static void t_stop(struct seq_file *m, void *p)
>  {
> +	mutex_unlock(&event_mutex);
>  }
>  
>  static int
>  ftrace_event_seq_open(struct inode *inode, struct file *file)
>  {
> -	int ret;
>  	const struct seq_operations *seq_ops;
>  
>  	if ((file->f_mode & FMODE_WRITE) &&
> @@ -332,13 +340,7 @@ ftrace_event_seq_open(struct inode *inode, struct file *file)
>  		ftrace_clear_events();
>  
>  	seq_ops = inode->i_private;
> -	ret = seq_open(file, seq_ops);
> -	if (!ret) {
> -		struct seq_file *m = file->private_data;
> -
> -		m->private = ftrace_events.next;
> -	}
> -	return ret;
> +	return seq_open(file, seq_ops);
>  }
>  
>  static ssize_t
> diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
> index 97bd140..8c62e5b 100644
> --- a/kernel/trace/trace_events_filter.c
> +++ b/kernel/trace/trace_events_filter.c
> @@ -433,6 +433,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
>  		filter->n_preds = 0;
>  	}
>  
> +	mutex_lock(&event_mutex);
>  	list_for_each_entry(call, &ftrace_events, list) {
>  		if (!call->define_fields)
>  			continue;
> @@ -442,6 +443,7 @@ static void filter_free_subsystem_preds(struct event_subsystem *system)
>  			remove_filter_string(call->filter);
>  		}
>  	}
> +	mutex_unlock(&event_mutex);
>  }
>  
>  static int filter_add_pred_fn(struct filter_parse_state *ps,
> @@ -605,6 +607,7 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  {
>  	struct event_filter *filter = system->filter;
>  	struct ftrace_event_call *call;
> +	int err = 0;
>  
>  	if (!filter->preds) {
>  		filter->preds = kzalloc(MAX_FILTER_PRED * sizeof(pred),
> @@ -622,8 +625,8 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  	filter->preds[filter->n_preds] = pred;
>  	filter->n_preds++;
>  
> +	mutex_lock(&event_mutex);
>  	list_for_each_entry(call, &ftrace_events, list) {
> -		int err;
>  
>  		if (!call->define_fields)
>  			continue;
> @@ -635,12 +638,13 @@ static int filter_add_subsystem_pred(struct filter_parse_state *ps,
>  		if (err) {
>  			filter_free_subsystem_preds(system);
>  			parse_error(ps, FILT_ERR_BAD_SUBSYS_FILTER, 0);
> -			return err;
> +			break;
>  		}
>  		replace_filter_string(call->filter, filter_string);
>  	}
> +	mutex_unlock(&event_mutex);
>  
> -	return 0;
> +	return err;
>  }
>  
>  static void parse_init(struct filter_parse_state *ps,
> -- 
> 1.5.4.rc3
> 
> 

