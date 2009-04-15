Return-Path: <linux-kernel-owner+w=401wt.eu-S1754366AbZDOQIT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbZDOQIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 12:08:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751702AbZDOQID
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 12:08:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:4624 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZDOQIB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 12:08:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mF0YDFdWl5PRMPBxGUe3ja2cwfh8kByfuV7a7tEcSFk5xNQ/JZEH90EV5EwvRGpsZD
         LSx3Wst6IkwbMXmXGgxq6AjfZ9U0EU3M+iST2ntiZvZjjiJ8ALUEpvy6d7vvqWXCq2Tf
         GXwVdheiQjvc19KwBr0xtCVK5L5MqQe+1ObxE=
Date: Wed, 15 Apr 2009 18:07:56 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Theodore Tso <tytso@mit.edu>,
       Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@lst.de>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Zhaolei <zhaolei@cn.fujitsu.com>,
       Li Zefan <lizf@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       "Frank Ch. Eigler" <fche@elastic.org>, Tom Zanussi <tzanussi@gmail.com>,
       Jiaying Zhang <jiayingz@google.com>, Michael Rubin <mrubin@google.com>,
       Martin Bligh <mbligh@google.com>
Subject: Re: [PATCH 1/4] tracing/events: fix compile for modules disabled
Message-ID: <20090415160755.GE5989@nowhere>
References: <20090415031511.128139334@goodmis.org> <20090415031604.688830915@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090415031604.688830915@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 11:15:12PM -0400, Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> Impact: compile fix
> 
> The addition of TRACE_EVENT for modules breaks the build for when
> modules are disabled. This code fixes that.
> 
> Reported-by: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_events.c |   12 ++++++++++--
>  1 files changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index a4b1777..6591d83 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -797,6 +797,7 @@ event_create_dir(struct ftrace_event_call *call, struct dentry *d_events)
>  	     (unsigned long)event < (unsigned long)end;		\
>  	     event++)
>  
> +#ifdef CONFIG_MODULES
>  static void trace_module_add_events(struct module *mod)
>  {
>  	struct ftrace_event_call *call, *start, *end;
> @@ -840,8 +841,8 @@ static void trace_module_remove_events(struct module *mod)
>  	}
>  }
>  
> -int trace_module_notify(struct notifier_block *self,
> -			unsigned long val, void *data)
> +static int trace_module_notify(struct notifier_block *self,
> +			       unsigned long val, void *data)
>  {
>  	struct module *mod = data;
>  
> @@ -858,6 +859,13 @@ int trace_module_notify(struct notifier_block *self,
>  
>  	return 0;
>  }
> +#else
> +static int trace_module_notify(struct notifier_block *self,
> +			       unsigned long val, void *data)



I don't remember when you register the module notifier but
I guess it is on init time, then you can set this func as __init
if !CONFIG_MODULES.


> +{
> +	return 0;
> +}
> +#endif /* CONFIG_MODULES */
>  
>  struct notifier_block trace_module_nb = {
>  	.notifier_call = trace_module_notify,


And then you can set this struct as __initdata_or_module, so
that you can safely register this module notifier whatever
config you have, and without consuming any space on the off case.


> -- 
> 1.6.2.1
> 
> -- 

