Return-Path: <linux-kernel-owner+w=401wt.eu-S1752568AbZDMQnX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752568AbZDMQnX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 12:43:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751579AbZDMQnP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 12:43:15 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:44394 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZDMQnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 12:43:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bhDocnnalzSgAJDDpPD7/g3nWMJjfnuWdVnmzm8/SIMxkMGo6BrCThyEIUOJN4GkF8
         CJaJMHRKzvpmiDDdyKWu88iovf6SPgr14OvA8FMTXRFa+v+siI6DFTRl2VzchgBLMpUz
         b83kEq1WXpv5O7WiizSNe41MYGk9hdiFNfJgk=
Date: Mon, 13 Apr 2009 18:43:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] tracing: Make branch trace display correct header
Message-ID: <20090413164309.GJ5977@nowhere>
References: <49E2F19A.3040006@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49E2F19A.3040006@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 13, 2009 at 04:02:34PM +0800, Zhaolei wrote:
> Before patch:
>   # tracer: branch
>   #
>   #           TASK-PID    CPU#    TIMESTAMP  FUNCTION
>   #              | |       |          |         |
>              <...>-2981  [000] 24008.872738: [  ok  ] trace_irq_handler_exit:irq_event_types.h:41
>              <...>-2981  [000] 24008.872742: [  ok  ] note_interrupt:spurious.c:229
>   ...
> 
> After patch:
> # tracer: branch
> #
> #           TASK-PID    CPU#    TIMESTAMP  CORRECT  FUNC:FILE:LINE
> #              | |       |          |         |       |
>            <...>-2985  [000] 26329.142970: [  ok  ] slab_free:slub.c:1776
>            <...>-2985  [000] 26329.142972: [  ok  ] trace_kmem_cache_free:kmem_event_types.h:191
>   ...
> 
> But it is not the best fix way.
> When format(length) of TASK-PID, CPU and TIMESTAMP chanegd in trace.c,
> other files who uses there fields need to changed for print right header line.
> 
> Maybe we can make a function to print header line of these 3 field:
> print_common_head()
> {
> 	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP");
> }
> 
> and call this function in other files' print_header:
> static void branch_print_header(struct seq_file *s)
> {
> 	print_common_head();
> 	seq_puts(s, "  CORRECT  FUNC:FILE:LINE\n");
> }
> 
> But if header line is multi-line, this way can't work.
> 
> Another way is to export specific header-line content in other files:
> static void branch_print_header(char *buf, int len)
> {
> 	strcpy(buf, "  CORRECT  FUNC:FILE:LINE\n"
> 		    "     |            |\n"
> 		    );
> }
> And combile common-header and specific header in trace.c, then do seq_puts.
> But this seems too complex for tracing framework.
> 
> Similar problem exists in other tracers as sched_switch.


Indeed. I don't see any smart solution.
May be:

print_common_header_begin() // first line
print_common_header_end()   // second line with pipes

That's not pretty but at least it factorizes...

Hm?

Frederic.


 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace_branch.c |    8 ++++++++
>  1 files changed, 8 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_branch.c b/kernel/trace/trace_branch.c
> index 8e64e60..7a7a9fd 100644
> --- a/kernel/trace/trace_branch.c
> +++ b/kernel/trace/trace_branch.c
> @@ -157,6 +157,13 @@ static enum print_line_t trace_branch_print(struct trace_iterator *iter,
>  	return TRACE_TYPE_HANDLED;
>  }
>  
> +static void branch_print_header(struct seq_file *s)
> +{
> +	seq_puts(s, "#           TASK-PID    CPU#    TIMESTAMP  CORRECT"
> +		"  FUNC:FILE:LINE\n");
> +	seq_puts(s, "#              | |       |          |         |   "
> +		"    |\n");
> +}
>  
>  static struct trace_event trace_branch_event = {
>  	.type		= TRACE_BRANCH,
> @@ -171,6 +178,7 @@ static struct tracer branch_trace __read_mostly =
>  #ifdef CONFIG_FTRACE_SELFTEST
>  	.selftest	= trace_selftest_startup_branch,
>  #endif /* CONFIG_FTRACE_SELFTEST */
> +	.print_header	= branch_print_header,
>  };
>  
>  __init static int init_branch_tracer(void)
> -- 1.5.5.3 
> 

