Return-Path: <linux-kernel-owner+w=401wt.eu-S1751643AbZGKFyj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643AbZGKFyj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Jul 2009 01:54:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751388AbZGKFyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Jul 2009 01:54:31 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:39666 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZGKFyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Jul 2009 01:54:31 -0400
Date: Sat, 11 Jul 2009 11:24:18 +0530
From: "K.Prasad" <prasad@linux.vnet.ibm.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Alan Stern <stern@rowland.harvard.edu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
Message-ID: <20090711055418.GA7686@in.ibm.com>
Reply-To: prasad@linux.vnet.ibm.com
References: <4A52E291.1020408@cn.fujitsu.com> <4A52E2B4.6030706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52E2B4.6030706@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 01:52:52PM +0800, Li Zefan wrote:
> Reading ksym_trace_filter gave me some arbitrary characters,
> when it should show nothing. It's because buf is not initialized
> when there's no filter.
> 

I started noticing this behaviour recently.

A simple
char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX] = "\0";
solves the problem.

> Also reduce stack usage by about 512 bytes.
> 

The stack usage would be much lesser on other architectures with fewer
breakpoint registers (like PPC64), and should really be an issue.

> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> ---
>  kernel/trace/trace_ksym.c |   29 ++++++++++++++++++-----------
>  1 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/kernel/trace/trace_ksym.c b/kernel/trace/trace_ksym.c
> index 085ff05..b6710d3 100644
> --- a/kernel/trace/trace_ksym.c
> +++ b/kernel/trace/trace_ksym.c
> @@ -35,7 +35,6 @@
>  #define KSYM_TRACER_MAX HBP_NUM
> 
>  #define KSYM_TRACER_OP_LEN 3 /* rw- */
> -#define KSYM_FILTER_ENTRY_LEN (KSYM_NAME_LEN + KSYM_TRACER_OP_LEN + 1)
> 
>  struct trace_ksym {
>  	struct hw_breakpoint	*ksym_hbp;
> @@ -230,25 +229,33 @@ static ssize_t ksym_trace_filter_read(struct file *filp, char __user *ubuf,
>  {
>  	struct trace_ksym *entry;
>  	struct hlist_node *node;
> -	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX];
> -	ssize_t ret, cnt = 0;
> +	struct trace_seq *s;
> +	ssize_t cnt = 0;
> +	int ret;
> +
> +	s = kmalloc(sizeof(*s), GFP_KERNEL);
> +	if (!s)
> +		return -ENOMEM;
> +	trace_seq_init(s);
> 
>  	mutex_lock(&ksym_tracer_mutex);
> 
>  	hlist_for_each_entry(entry, node, &ksym_filter_head, ksym_hlist) {
> -		cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt, "%s:",
> -				entry->ksym_hbp->info.name);
> +		ret = trace_seq_printf(s, "%s:", entry->ksym_hbp->info.name);
>  		if (entry->ksym_hbp->info.type == HW_BREAKPOINT_WRITE)
> -			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> -								"-w-\n");
> +			ret = trace_seq_puts(s, "-w-\n");
>  		else if (entry->ksym_hbp->info.type == HW_BREAKPOINT_RW)
> -			cnt += snprintf(&buf[cnt], KSYM_FILTER_ENTRY_LEN - cnt,
> -								"rw-\n");
> +			ret = trace_seq_puts(s, "rw-\n");
> +		WARN_ON_ONCE(!ret);

Given that this change uses the tracer defined functions and a seq-file
implementation, the patch is welcome.

Thanks,
K.Prasad

