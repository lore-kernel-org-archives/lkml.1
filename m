Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZEFOYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZEFOYx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 10:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752567AbZEFOYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 10:24:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:63653 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZEFOYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 10:24:41 -0400
Date: Wed, 6 May 2009 10:24:40 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinder@kernel.org, jaswinderrajput@gmail.com, tglx@linutronix.de,
       mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/core] tracing: trace_output.c, fix false positive
 compiler warning
In-Reply-To: <tip-48dd0fed90e2b1f1ba87401439b85942181c6df3@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0905061018260.3239@gandalf.stny.rr.com>
References: <new-submission> <tip-48dd0fed90e2b1f1ba87401439b85942181c6df3@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Wed, 6 May 2009, tip-bot for Jaswinder Singh Rajput wrote:

> Commit-ID:  48dd0fed90e2b1f1ba87401439b85942181c6df3
> Gitweb:     http://git.kernel.org/tip/48dd0fed90e2b1f1ba87401439b85942181c6df3
> Author:     Jaswinder Singh Rajput <jaswinder@kernel.org>
> AuthorDate: Wed, 6 May 2009 15:45:45 +0530
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Wed, 6 May 2009 14:19:16 +0200
> 
> tracing: trace_output.c, fix false positive compiler warning
> 
> This compiler warning:
> 
>   CC      kernel/trace/trace_output.o
>  kernel/trace/trace_output.c: In function ?register_ftrace_event?:
>  kernel/trace/trace_output.c:544: warning: ?list? may be used uninitialized in this function
> 
> Is wrong as 'list' is always initialized - but GCC (4.3.2) does not
> recognize this relationship properly.
> 
> Work around the warning by initializing the variable to NULL.
> 
> [ Impact: fix false positive compiler warning ]
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Acked-by: Steven Rostedt <rostedt@goodmis.org>
> LKML-Reference: <new-submission>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/trace/trace_output.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
> index 5fc51f0..8bd9a2c 100644
> --- a/kernel/trace/trace_output.c
> +++ b/kernel/trace/trace_output.c
> @@ -541,7 +541,7 @@ int register_ftrace_event(struct trace_event *event)
>  	INIT_LIST_HEAD(&event->list);
>  
>  	if (!event->type) {
> -		struct list_head *list;
> +		struct list_head *list = NULL;

Actually this is the wrong place to initialize. The correct place is in 
the function that is expected to.

>  
>  		if (next_event_type > FTRACE_MAX_EVENT) {
>  

Could you test this patch instead:

tracing: quiet gcc compile warning

Some versions of gcc can not catch the fact that the list variable in 
register_ftrace_event is initialized. There's one place in the logic that 
is a bit complex. The trace_search_list function that initializes the list 
will not initialize it on error. But that's OK, because the caller checks 
for error and will not use the list variable if there is one. Some 
versions of gcc miss this.

[ Impact: quiet gcc from complaining about an unused variable ]

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index 5fc51f0..e949cf6 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -506,8 +506,10 @@ static int trace_search_list(struct list_head **list)
 	}
 
 	/* Did we used up all 65 thousand events??? */
-	if ((last + 1) > FTRACE_MAX_EVENT)
+	if ((last + 1) > FTRACE_MAX_EVENT) {
+		*list = NULL;
 		return 0;
+	}
 
 	*list = &e->list;
 	return last + 1;
