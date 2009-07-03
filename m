Return-Path: <linux-kernel-owner+w=401wt.eu-S1756943AbZGCKA3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756943AbZGCKA3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 06:00:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbZGCKAQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 06:00:16 -0400
Received: from mail-bw0-f207.google.com ([209.85.218.207]:63778 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGCKAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 06:00:15 -0400
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 03 Jul 2009 06:00:14 EDT
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=UWNvEf+8ImSWwLgkQ3NjnjWKDBkgadzvOqhybh56oRtW3YM+hSq7QaKRQ71pI3sjdY
         dN4ZvhcJLw6j/2EWjfr53YNW5z/Ll1BGF9ycZBTYFr7+GGG9cIQ3CXmU43MNReLhMr4N
         kDboKqGBg6/slPUNGe6HOFQSloGu9jfpL6Reg=
Date: Fri, 3 Jul 2009 12:54:56 +0300
From: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] kmemtrace: print binary output only if 'bin' option
	is set
Message-ID: <20090703095456.GA3505@localhost>
References: <4A4DD0A0.5060500@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4DD0A0.5060500@cn.fujitsu.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 05:34:24PM +0800, Li Zefan wrote:
> Currently by default the output of kmemtrace is binary format instead
> of human-readable output.
> 
> This patch makes the following changes:
>   - We'll see human-readable output by default
>   - We'll see binary output if 'bin' option is set
> 
> Note: you may probably need to explicitly disable context-info binary
>       output:
> 
> 	# echo 0 > options/context-info
> 	# echo 1 > options/bin
> 	# cat trace_pipe
> 
> v2:
> - use %pF to print call_site
> 
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> Acked-by: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
> ---
>  kernel/trace/kmemtrace.c |  120 ++++++++++++++++++++++++++++++++++-----------
>  1 files changed, 90 insertions(+), 30 deletions(-)
> 
> diff --git a/kernel/trace/kmemtrace.c b/kernel/trace/kmemtrace.c
> index 1edaa95..74903b6 100644
> --- a/kernel/trace/kmemtrace.c
> +++ b/kernel/trace/kmemtrace.c
> @@ -239,12 +239,52 @@ struct kmemtrace_user_event_alloc {
>  };
>  
>  static enum print_line_t
> -kmemtrace_print_alloc_user(struct trace_iterator *iter,
> -			   struct kmemtrace_alloc_entry *entry)
> +kmemtrace_print_alloc_user(struct trace_iterator *iter, int flags)
> +{
> +	struct trace_seq *s = &iter->seq;
> +	struct kmemtrace_alloc_entry *entry;
> +	int ret;
> +
> +	trace_assign_type(entry, iter->ent);
> +
> +	ret = trace_seq_printf(s, "type_id %d call_site %pF ptr %lu "
> +	    "bytes_req %lu bytes_alloc %lu gfp_flags %lu node %d\n",
> +	    entry->type_id, (void *)entry->call_site, (unsigned long)entry->ptr,
> +	    (unsigned long)entry->bytes_req, (unsigned long)entry->bytes_alloc,
> +	    (unsigned long)entry->gfp_flags, entry->node);
> +
> +	if (!ret)
> +		return TRACE_TYPE_PARTIAL_LINE;
> +	return TRACE_TYPE_HANDLED;
> +}

[snip]

kmemtrace_print_alloc_user() is meant for kmemtrace-user, that's what the
naming is meant to convey. Also, kmemtrace_print_alloc_user_bin is kinda
long. Could you leave the former as it was and come up with another name
for the non-binary variant?


	Eduard

