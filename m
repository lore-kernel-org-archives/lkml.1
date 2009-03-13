Return-Path: <linux-kernel-owner+w=401wt.eu-S1755278AbZCMMDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278AbZCMMDS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 08:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752911AbZCMMDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 08:03:01 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:49916 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254AbZCMMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 08:03:00 -0400
Date: Fri, 13 Mar 2009 08:02:56 -0400 (EDT)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       zhaolei@cn.fujitsu.com, tglx@linutronix.de, mingo@elte.hu
cc: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:tracing/ftrace] ftrace: don't try to __ftrace_replace_code
 on !FTRACE_FL_CONVERTED rec
In-Reply-To: <tip-fa9d13cf135efbd454453a53b6299976bea245a9@git.kernel.org>
Message-ID: <alpine.DEB.2.00.0903130757450.18396@gandalf.stny.rr.com>
References: <49BA2472.4060206@cn.fujitsu.com> <tip-fa9d13cf135efbd454453a53b6299976bea245a9@git.kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 13 Mar 2009, Zhaolei wrote:

> Commit-ID:  fa9d13cf135efbd454453a53b6299976bea245a9
> Gitweb:     http://git.kernel.org/tip/fa9d13cf135efbd454453a53b6299976bea245a9
> Author:     Zhaolei <zhaolei@cn.fujitsu.com>
> AuthorDate: Fri, 13 Mar 2009 17:16:34 +0800
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 10:25:06 +0100
> 
> ftrace: don't try to __ftrace_replace_code on !FTRACE_FL_CONVERTED rec
> 
> Do __ftrace_replace_code for !FTRACE_FL_CONVERTED rec will always
> fail, we should ignore this rec.

Is this also by code review or did you actually hit it?

This code is very sensitive, and changing must be done extremely 
carefully.

> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> Cc: "Steven Rostedt ;" <rostedt@goodmis.org>
> LKML-Reference: <49BA2472.4060206@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  kernel/trace/ftrace.c |    9 +++++----
>  1 files changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 26c45aa..08f4a62 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -532,11 +532,12 @@ static void ftrace_replace_code(int enable)
>  
>  	do_for_each_ftrace_rec(pg, rec) {
>  		/*
> -		 * Skip over free records and records that have
> -		 * failed.
> +		 * Skip over free records, records that have
> +		 * failed and not converted.
>  		 */
>  		if (rec->flags & FTRACE_FL_FREE ||
> -		    rec->flags & FTRACE_FL_FAILED)
> +		    rec->flags & FTRACE_FL_FAILED ||
> +		    rec->flags & FTRACE_FL_CONVERTED)
>  			continue;
>  
>  		/* ignore updates to this record's mcount site */
> @@ -548,7 +549,7 @@ static void ftrace_replace_code(int enable)
>  		}
>  
>  		failed = __ftrace_replace_code(rec, enable);
> -		if (failed && (rec->flags & FTRACE_FL_CONVERTED)) {
> +		if (failed) {

Note, if we get here when a record does not have FL_CONVERTED set, then
something already went wrong and tracing should have been disabled.
The check here was simply to prevent mulitple errors from being printed 
out.

I'm just getting ready to travel, but maybe I'll look into this code a bit
more, and see what reasons we can get here without that CONVERTED flag
being set. Perhaps the best thing to do is exit the loop?

-- Steve

>  			rec->flags |= FTRACE_FL_FAILED;
>  			if ((system_state == SYSTEM_BOOTING) ||
>  			    !core_kernel_text(rec->ip)) {
> 
