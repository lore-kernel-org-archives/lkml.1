Return-Path: <linux-kernel-owner+w=401wt.eu-S1758897AbZGGV30@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758897AbZGGV30 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 17:29:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756525AbZGGV3R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 17:29:17 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:58071 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756052AbZGGV3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 17:29:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QtpMfqI5gzX4aCoTn37qbO6j8SB0huxpznv3K0F1MKsjjTp6nyXvxpsCFEjrG3Gcaq
         Uq1vwY4aduZOLIlcA6e+qWWrYOSWtcQWeTHDNMrD2IHzZuB2XUxV42uzymDWcZmESgob
         /60nUk4jpcNrCJgWpNlQFhB4VA769vMc8fmHg=
Date: Tue, 7 Jul 2009 23:29:12 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] ksym_tracer: Rewrite ksym_trace_filter_read()
Message-ID: <20090707212910.GB7412@nowhere>
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
> Also reduce stack usage by about 512 bytes.
> 
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


Hehe, this trace_seq type is very convenient :)


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
>  	}
> -	ret = simple_read_from_buffer(ubuf, count, ppos, buf, strlen(buf));
> +
> +	cnt = simple_read_from_buffer(ubuf, count, ppos, s->buffer, s->len);
> +
>  	mutex_unlock(&ksym_tracer_mutex);
>  
> -	return ret;
> +	kfree(s);
> +
> +	return cnt;
>  }
>  
>  static ssize_t ksym_trace_filter_write(struct file *file,


Looks good too.

Ack.

