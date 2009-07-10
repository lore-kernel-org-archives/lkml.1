Return-Path: <linux-kernel-owner+w=401wt.eu-S1752725AbZGJEHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752725AbZGJEHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 00:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbZGJEG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 00:06:59 -0400
Received: from mail-px0-f193.google.com ([209.85.216.193]:60973 "EHLO
	mail-px0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbZGJEG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 00:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=tnNMyUpUK2Y/PATG1stbIVtV/L/DLGR08NgpfLx1W26PLIe26hFLtxQxzGqMv8+npd
         VFATInXiUs7jZCAKri6LAFCTLNWFJUErUmDB3c4KXTJnvv4at2rjcqM1vqu1a1Ul3CZu
         PoTpMl82wsaR7tpAgtn1Ww0XBW15US1z7JACw=
Subject: Re: [PATCH 2/2] tracing/filter: remove empty subsystem and it's
 directory
From: Tom Zanussi <tzanussi@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4A55A8BE.9010707@cn.fujitsu.com>
References: <4A55A83C.1030005@cn.fujitsu.com>
	 <4A55A8BE.9010707@cn.fujitsu.com>
Content-Type: text/plain
Date: Thu, 09 Jul 2009 23:06:54 -0500
Message-Id: <1247198814.6229.4.camel@tropicana>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-07-09 at 16:22 +0800, Xiao Guangrong wrote:
> Remove empty subsystem and it's directory when module unload.
> 
> Before patch:
>  # rmmod trace-events-sample.ko
>  # ls sample
>  enable  filter
> 
> After patch:
>  # rmmod trace-events-sample.ko
>  # ls sample
>  ls: cannot access sample: No such file or directory
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>

Looks like it does the trick.

Acked-by: Tom Zanussi <tzanussi@gmail.com>

> ---
>  kernel/trace/trace.h        |    1 +
>  kernel/trace/trace_events.c |   32 +++++++++++++++++++++++++++++++-
>  2 files changed, 32 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace.h b/kernel/trace/trace.h
> index 61b4e94..0e7de4b 100644
> --- a/kernel/trace/trace.h
> +++ b/kernel/trace/trace.h
> @@ -780,6 +780,7 @@ struct event_subsystem {
>  	const char		*name;
>  	struct dentry		*entry;
>  	void			*filter;
> +	int			nr_events;
>  };
>  
>  struct filter_pred;
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index fecac13..90cf936 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -851,8 +851,10 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  
>  	/* First see if we did not already create this dir */
>  	list_for_each_entry(system, &event_subsystems, list) {
> -		if (strcmp(system->name, name) == 0)
> +		if (strcmp(system->name, name) == 0) {
> +			system->nr_events++;
>  			return system->entry;
> +		}
>  	}
>  
>  	/* need to create new entry */
> @@ -871,6 +873,7 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  		return d_events;
>  	}
>  
> +	system->nr_events = 1;
>  	system->name = kstrdup(name, GFP_KERNEL);
>  	if (!system->name) {
>  		debugfs_remove(system->entry);
> @@ -905,6 +908,32 @@ event_subsystem_dir(const char *name, struct dentry *d_events)
>  	return system->entry;
>  }
>  
> +static void remove_subsystem_dir(const char *name)
> +{
> +	struct event_subsystem *system;
> +
> +	if (strcmp(name, TRACE_SYSTEM) == 0)
> +		return;
> +
> +	list_for_each_entry(system, &event_subsystems, list) {
> +		if (strcmp(system->name, name) == 0) {
> +			if (!--system->nr_events) {
> +				struct event_filter *filter = system->filter;
> +
> +				debugfs_remove_recursive(system->entry);
> +				list_del(&system->list);
> +				if (filter) {
> +					kfree(filter->filter_string);
> +					kfree(filter);
> +				}
> +				kfree(system->name);
> +				kfree(system);
> +			}
> +			break;
> +		}
> +	}
> +}
> +
>  static int
>  event_create_dir(struct ftrace_event_call *call, struct dentry *d_events,
>  		 const struct file_operations *id,
> @@ -1079,6 +1108,7 @@ static void trace_module_remove_events(struct module *mod)
>  			list_del(&call->list);
>  			trace_destroy_fields(call);
>  			destroy_preds(call);
> +			remove_subsystem_dir(call->system);
>  		}
>  	}
>  

