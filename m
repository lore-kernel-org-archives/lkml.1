Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932269Ab0BYESk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 23:18:40 -0500
Received: from mail-fx0-f219.google.com ([209.85.220.219]:62332 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932194Ab0BYESi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 23:18:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=URkhp+KqkrJcHCyysjvxqMPF7IsQmi9i76pPs/QpXzijZDsS5ylpYTFjpyLJX1ye0c
         cN1mclNEljsDAfvbxrF73A+CPmMq8hahHoBWuY1o+mI+erVw4Qa4WBikDR4jh3pttARr
         PbPY2fErGzeQFlIJtzvWwIiVzrV3hTXx48g7E=
Date: Thu, 25 Feb 2010 05:18:36 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Wenji Huang <wenji.huang@oracle.com>
Cc: linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: [PATCH -tip 4/5] tracing: return accurate value for
	print_graph_prologue
Message-ID: <20100225041835.GF7491@nowhere>
References: <1266997226-6833-1-git-send-email-wenji.huang@oracle.com> <1266997226-6833-2-git-send-email-wenji.huang@oracle.com> <1266997226-6833-3-git-send-email-wenji.huang@oracle.com> <1266997226-6833-4-git-send-email-wenji.huang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1266997226-6833-4-git-send-email-wenji.huang@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 24, 2010 at 03:40:25PM +0800, Wenji Huang wrote:
> Return TRACE_TYPE_HANDLED instead of zero to avoid confusion.
> 
> Signed-off-by: Wenji Huang <wenji.huang@oracle.com>
> ---
>  kernel/trace/trace_functions_graph.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
> index 112561d..bd0bdeb 100644
> --- a/kernel/trace/trace_functions_graph.c
> +++ b/kernel/trace/trace_functions_graph.c
> @@ -806,7 +806,7 @@ print_graph_prologue(struct trace_iterator *iter, struct trace_seq *s,
>  			return TRACE_TYPE_PARTIAL_LINE;
>  	}
>  
> -	return 0;
> +	return TRACE_TYPE_HANDLED;


Actually TRACE_TYPE_HANDLED = 1
So print_graph_prologue always returns 0.
And the check is inverted everywhere:

	if (print_graph_prologue(...))
		return TRACE_TYPE_PARTIAL_LINE;

Which means we never it fails.

It's not a big deal because there will always be something
else to print after the prologue, and this will fail too
and then return the error.

But still, if you fix this, you also need to do:

diff --git a/kernel/trace/trace_functions_graph.c b/kernel/trace/trace_functions_graph.c
index 616b135..9da6487 100644
--- a/kernel/trace/trace_functions_graph.c
+++ b/kernel/trace/trace_functions_graph.c
@@ -819,7 +819,7 @@ print_graph_entry(struct ftrace_graph_ent_entry *field, struct trace_seq *s,
 	static enum print_line_t ret;
 	int cpu = iter->cpu;
 
-	if (print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
+	if (!print_graph_prologue(iter, s, TRACE_GRAPH_ENT, call->func))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	leaf_ret = get_return_for_leaf(iter, field);
@@ -866,7 +866,7 @@ print_graph_return(struct ftrace_graph_ret *trace, struct trace_seq *s,
 		*depth = trace->depth - 1;
 	}
 
-	if (print_graph_prologue(iter, s, 0, 0))
+	if (!print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* Overhead */
@@ -921,7 +921,7 @@ print_graph_comment(struct trace_seq *s,  struct trace_entry *ent,
 	if (data)
 		depth = per_cpu_ptr(data->cpu_data, iter->cpu)->depth;
 
-	if (print_graph_prologue(iter, s, 0, 0))
+	if (!print_graph_prologue(iter, s, 0, 0))
 		return TRACE_TYPE_PARTIAL_LINE;
 
 	/* No overhead */


