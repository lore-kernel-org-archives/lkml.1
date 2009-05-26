Return-Path: <linux-kernel-owner+w=401wt.eu-S1754445AbZEZVBa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754445AbZEZVBa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 17:01:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752802AbZEZVBV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 17:01:21 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:38120 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbZEZVBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 17:01:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=agjd9K209Zn6WbRFWzvERonCRGYicohBc5W+843DvQ3s8rKhi4SxNMIP9VNsVRH1aC
         VbHqnDxKP5U7+mHTobzizUG0wqKCoH+lWZrogG8kljqnbdwNiMcqMzBywnokFMOvgSYX
         O8YaCZ3oMqIgIMmjh0sl4Kr6czSW5TUoD6eqc=
Date: Tue, 26 May 2009 23:01:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] tracing/workqueue: make events sort in ascending
	order
Message-ID: <20090526210113.GG5969@nowhere>
References: <4A1BA322.9060505@cn.fujitsu.com> <4A1BA696.9090404@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A1BA696.9090404@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 04:21:42PM +0800, Zhaolei wrote:
> Events in workqueue tracer need to be sorted in ascending order to make user
> clear.
> But now it is reversed by "tracing/stat: replace linked list by an rbtree
> for sorting"(53059c9b67a62a3dc8c80204d3da42b9267ea5a0).
> We need to define a custom cmp() callback to make sorting correct.


That's my bad, the reverse sorting subsequent to this patch is an accident
so the fix should be done in the stat tracing framework.

I'll fix that.

The other patches for the workqueue tracer look good. I'll apply
them and send a pull request to Ingo.

Thanks!



> 
> Before patch:
>  # CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID
>  #  |     |        |         |        |      `-WORKFUNC
>  #  |     |        |         |        |           |
>      0        1        1     1155     1155   `-xprt_autoclose
>      0       19       19      864      143   |-xs_udp_connect_worker4
>  ...
>      0        1        1     4825     4825   |-reg_todo
>      0      443      515                     events/0:5
> 
> After patch:
>  # CPU INSERTED EXECUTED   MAX us   AVG us   TASKNAME:PID
>  #  |     |        |         |        |      `-WORKFUNC
>  #  |     |        |         |        |           |
>      0      443      515                     events/0:5
>      0        1        1     4825     4825   |-reg_todo
>  ...
>      0       19       19      797      134   |-xs_udp_connect_worker4
>      0        1        1     8359     8359   `-xprt_autoclose
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace_workqueue.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index 53fe43e..7fa0d23 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -383,6 +383,12 @@ static void *workqueue_stat_next(void *prev, int idx)
>  	return ret;
>  }
>  
> +/* To make events sort in ascending order */
> +static int workqueue_stat_cmp(void *p1, void *p2)
> +{
> +	return -1;
> +}
> +
>  static int workqueue_stat_show(struct seq_file *s, void *p)
>  {
>  	struct workfunc_stats *wfstat = p;
> @@ -470,6 +476,7 @@ static struct tracer_stat workqueue_stats __read_mostly = {
>  	.name		= "workqueues",
>  	.stat_start	= workqueue_stat_start,
>  	.stat_next	= workqueue_stat_next,
> +	.stat_cmp	= workqueue_stat_cmp,
>  	.stat_show	= workqueue_stat_show,
>  	.stat_headers	= workqueue_stat_headers,
>  	.file_open	= workqueue_stat_file_open,
> -- 
> 1.5.5.3
> 

