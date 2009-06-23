Return-Path: <linux-kernel-owner+w=401wt.eu-S1758180AbZFWOaU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758180AbZFWOaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 10:30:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753903AbZFWOaI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 10:30:08 -0400
Received: from mail-ew0-f210.google.com ([209.85.219.210]:50566 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbZFWOaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 10:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Ev/2KwRQNeDpWGXSJlR6YfUhJN4kBYQmKdi2emqtWvbPrz4IJXCZtBZh07kRqsAqtM
         vkFmZZPxkf/tgE3uYtO43TWwrrlRTul2CQwaeN5KlnXuVxy2dTY9ULgVQz1Q4JTeCIjc
         HrzOIPjCxxPAuHl6/9gPPSqJOWao18i/C5pto=
Date: Tue, 23 Jun 2009 16:30:06 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "K.Prasad" <prasad@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Patch 2/3] ksym_tracer: Allow bulk removal using empty or
	wildcard string input - ver II
Message-ID: <20090623143004.GB6010@nowhere>
References: <20090619172035.443923337@prasadkr_t60p.in.ibm.com> <20090619172512.GC26071@in.ibm.com> <20090620133507.GA30216@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090620133507.GA30216@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 20, 2009 at 07:05:07PM +0530, K.Prasad wrote:
> Accept an empty string or wildcard input (of the form *:---) as input for
> ksym_trace_filter to perform bulk removal of all monitored entries.
> 
> Signed-off-by: K.Prasad <prasad@linux.vnet.ibm.com>
> ---
>  kernel/trace/trace_ksym.c |   77 +++++++++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 34 deletions(-)
> 
> Index: linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> ===================================================================
> --- linux-2.6-tip.hbkpt.orig/kernel/trace/trace_ksym.c
> +++ linux-2.6-tip.hbkpt/kernel/trace/trace_ksym.c
> @@ -23,6 +23,7 @@
>  #include <linux/debugfs.h>
>  #include <linux/ftrace.h>
>  #include <linux/module.h>
> +#include <linux/ctype.h>
>  #include <linux/fs.h>
>  
>  #include "trace_output.h"
> @@ -138,6 +139,34 @@ static int ksym_trace_get_access_type(ch
>  	return access;
>  }
>  
> +static void ksym_trace_reset(struct trace_array *tr)
> +{
> +	struct trace_ksym *entry;
> +	struct hlist_node *node, *node1;
> +
> +	ksym_tracing_enabled = 0;
> +
> +	mutex_lock(&ksym_tracer_mutex);
> +	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
> +								ksym_hlist) {
> +		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
> +		ksym_filter_entry_count--;
> +		hlist_del_rcu(&(entry->ksym_hlist));
> +		synchronize_rcu();
> +		/* Free the 'input_string' only if reset
> +		 * after startup self-test
> +		 */
> +#ifdef CONFIG_FTRACE_SELFTEST
> +		if (strncmp(entry->ksym_hbp->info.name, KSYM_SELFTEST_ENTRY,
> +					strlen(KSYM_SELFTEST_ENTRY)) != 0)
> +#endif /* CONFIG_FTRACE_SELFTEST*/
> +			kfree(entry->ksym_hbp->info.name);
> +		kfree(entry->ksym_hbp);
> +		kfree(entry);
> +	}
> +	mutex_unlock(&ksym_tracer_mutex);
> +}
> +
>  /*
>   * There can be several possible malformed requests and we attempt to capture
>   * all of them. We enumerate some of the rules
> @@ -163,7 +192,7 @@ static int parse_ksym_trace_str(char *in
>  	/* Check for malformed request: (2), (1) and (5) */
>  	if ((!input_string) ||
>  		(strlen(input_string) != (KSYM_TRACER_OP_LEN + 1)) ||
> -			(*addr == 0))
> +			((*addr == 0) && strncmp(*ksymname, "*", strlen("*"))))
>  		goto return_code;
>  	ret = ksym_trace_get_access_type(input_string);
>  
> @@ -211,6 +240,7 @@ int process_new_ksym_entry(char *ksymnam
>  	}
>  	hlist_add_head_rcu(&(entry->ksym_hlist), &ksym_filter_head);
>  	ksym_filter_entry_count++;
> +	ksym_tracing_enabled = 1;
>  
>  	return 0;
>  }
> @@ -220,7 +250,7 @@ static ssize_t ksym_trace_filter_read(st
>  {
>  	struct trace_ksym *entry;
>  	struct hlist_node *node;
> -	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX];
> +	char buf[KSYM_FILTER_ENTRY_LEN * KSYM_TRACER_MAX] = "\0";
>  	ssize_t ret, cnt = 0;
>  
>  	mutex_lock(&ksym_tracer_mutex);
> @@ -251,10 +281,6 @@ static ssize_t ksym_trace_filter_write(s
>  	unsigned long ksym_addr = 0;
>  	int ret, op, changed = 0;
>  
> -	/* Ignore echo "" > ksym_trace_filter */
> -	if (count == 0)
> -		return 0;
> -
>  	input_string = kzalloc(count, GFP_KERNEL);
>  	if (!input_string)
>  		return -ENOMEM;
> @@ -263,12 +289,23 @@ static ssize_t ksym_trace_filter_write(s
>  		kfree(input_string);
>  		return -EFAULT;
>  	}
> +	/* Clear all breakpoint requests if echo "" > ksym_trace_filter */
> +	if ((count == 1) && !isalnum(input_string[0])) {
> +		ksym_trace_reset(NULL);
> +		return count;
> +	}
>  
>  	ret = op = parse_ksym_trace_str(input_string, &ksymname, &ksym_addr);
>  	if (ret < 0) {
>  		kfree(input_string);
>  		return ret;
>  	}
> +	/* Clear all breakpoints if echo "*:---" > ksym_trace_filter */
> +	if ((strncmp(ksymname, "*", strlen("*")) == 0) && (op == 0)) {


If you returned -EINVAL above, 


if (*ksymname == '*' && !op)

..would be shorter

Also that doesn't check if symname = "*something:---"



> +		ksym_trace_reset(NULL);
> +		kfree(input_string);
> +		return count;
> +	}
>  
>  	mutex_lock(&ksym_tracer_mutex);
>  
> @@ -325,34 +362,6 @@ static const struct file_operations ksym
>  	.write		= ksym_trace_filter_write,
>  };
>  
> -static void ksym_trace_reset(struct trace_array *tr)
> -{
> -	struct trace_ksym *entry;
> -	struct hlist_node *node, *node1;
> -
> -	ksym_tracing_enabled = 0;
> -
> -	mutex_lock(&ksym_tracer_mutex);
> -	hlist_for_each_entry_safe(entry, node, node1, &ksym_filter_head,
> -								ksym_hlist) {
> -		unregister_kernel_hw_breakpoint(entry->ksym_hbp);
> -		ksym_filter_entry_count--;
> -		hlist_del_rcu(&(entry->ksym_hlist));
> -		synchronize_rcu();
> -		/* Free the 'input_string' only if reset
> -		 * after startup self-test
> -		 */
> -#ifdef CONFIG_FTRACE_SELFTEST
> -		if (strncmp(entry->ksym_hbp->info.name, KSYM_SELFTEST_ENTRY,
> -					strlen(KSYM_SELFTEST_ENTRY)) != 0)
> -#endif /* CONFIG_FTRACE_SELFTEST*/
> -			kfree(entry->ksym_hbp->info.name);
> -		kfree(entry->ksym_hbp);
> -		kfree(entry);
> -	}
> -	mutex_unlock(&ksym_tracer_mutex);
> -}
> -
>  static int ksym_trace_init(struct trace_array *tr)
>  {
>  	int cpu, ret = 0;

