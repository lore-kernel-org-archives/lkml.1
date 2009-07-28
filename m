Return-Path: <linux-kernel-owner+w=401wt.eu-S1754042AbZG1Pdb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042AbZG1Pdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 11:33:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751470AbZG1Pda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 11:33:30 -0400
Received: from mail-ew0-f226.google.com ([209.85.219.226]:40547 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZG1Pda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 11:33:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QX0PkWMcuBy8JzJiE4WAxO288GP0fyBANKsGCqQCMK/vhctw/NE6xScLMY9E1S4EtB
         4QQUZR6danNUed73wiEqCv8l0ydDUcqeM0CzAUhXkMVSBrsQU8hVoc6B6otGO7Mu3R4h
         Pj38QqSV+ArWpZarKZnptgxHvwRtp9OQ+lUDI=
Date: Tue, 28 Jul 2009 17:33:24 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tracing: fix invalid function_graph entry
Message-ID: <20090728153322.GA6215@nowhere>
References: <4A6EEAEC.3050508@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A6EEAEC.3050508@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 28, 2009 at 08:11:24PM +0800, Lai Jiangshan wrote:
> 
> print_graph_entry() consumes current event, if this event
> is the last event in the page, the ring_buffer may reuse
> the page. It will become invalid.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---


Queued for .31, thanks Lai!


> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index abf7c4a..02102a3 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -835,9 +835,16 @@ print_graph_function(struct trace_iterator *iter)
>  
>  	switch (entry->type) {
>  	case TRACE_GRAPH_ENT: {
> -		struct ftrace_graph_ent_entry *field;
> +		/*
> +		 * print_graph_entry() may consume the current event,
> +		 * thus @field may become invalid, so we need to save it.
> +		 * sizeof(struct ftrace_graph_ent_entry) is very small,
> +		 * it is safely saved at the stack.
> +		 */
> +		struct ftrace_graph_ent_entry *field, saved;
>  		trace_assign_type(field, entry);
> -		return print_graph_entry(field, s, iter);
> +		saved = *field;
> +		return print_graph_entry(&saved, s, iter);
>  	}
>  	case TRACE_GRAPH_RET: {
>  		struct ftrace_graph_ret_entry *field;
> 

