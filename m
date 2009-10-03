Return-Path: <linux-kernel-owner+w=401wt.eu-S1756187AbZJCA4v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756187AbZJCA4v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 20:56:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754312AbZJCA4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 20:56:50 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:45523 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbZJCA4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 20:56:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vNtc3yOvvSA22xNdVBuZ1HVOTQwx6dFZXrx16S9rjMfPS+fTP4s62SrIwxdKEmB5+k
         0FBk+KOvyr9r7CqxHIZdca42p7eq4KF4dI34KxJib6W1FlFUrhv1oWMIpj02ZOBnLTwG
         nrF3yIs9XsR1bvav9pMtYBOgqdCtxM/glBg6w=
Date: Sat, 3 Oct 2009 02:56:49 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 3/3] tracing/ftrace: Fix to check
	create_event_dir() when adding new events
Message-ID: <20091003005647.GA4828@nowhere>
References: <20090925181952.10157.9975.stgit@omoto> <20090925182054.10157.55219.stgit@omoto>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090925182054.10157.55219.stgit@omoto>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 25, 2009 at 11:20:54AM -0700, Masami Hiramatsu wrote:
> Check result of create_event_dir() and add ftrace_event_call to
> ftrace_events list only if it is succeeded. Thanks Li for pointing it out.
> 
> Signed-off-by: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Jim Keniston <jkenisto@us.ibm.com>
> Cc: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Christoph Hellwig <hch@infradead.org>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Jason Baron <jbaron@redhat.com>
> Cc: K.Prasad <prasad@linux.vnet.ibm.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Li Zefan <lizf@cn.fujitsu.com>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> ---
> 
>  kernel/trace/trace_events.c |   29 +++++++++++++++++++++--------
>  1 files changed, 21 insertions(+), 8 deletions(-)
> 
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index a4b7c9a..f03cda3 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -957,12 +957,14 @@ static int __trace_add_event_call(struct ftrace_event_call *call)
>  	if (!d_events)
>  		return -ENOENT;
>  
> -	list_add(&call->list, &ftrace_events);
>  	ret = event_create_dir(call, d_events, &ftrace_event_id_fops,
>  				&ftrace_enable_fops, &ftrace_event_filter_fops,
>  				&ftrace_event_format_fops);
>  	if (ret < 0)
> -		list_del(&call->list);
> +		pr_warning("Could not create directory of trace events/%s\n",
> +			   call->name);




We already have such warnings in event_create_dir, with even more granularity
against the failure reason. The patch is fine, but I'll just remove the warning
introduced inside while applying it.

Thanks.


PS: Also I guess we could add the event in the list right from
event_create_dir()...

