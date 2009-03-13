Return-Path: <linux-kernel-owner+w=401wt.eu-S1758732AbZCMNRL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758732AbZCMNRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 09:17:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754335AbZCMNQ4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 09:16:56 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48194 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZCMNQz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 09:16:55 -0400
Subject: Re: [tip:tracing/ftrace] ftrace: remove struct list_head from
	struct dyn_ftrace
From: Steven Rostedt <srostedt@redhat.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, laijs@cn.fujitsu.com, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-e94142a67f8bad494c593f0a07c9fc2fbec98c0e@git.kernel.org>
References: <49BA2C9F.8020009@cn.fujitsu.com>
	 <tip-e94142a67f8bad494c593f0a07c9fc2fbec98c0e@git.kernel.org>
Content-Type: text/plain
Organization: Red Hat
Date: Fri, 13 Mar 2009 09:16:30 -0400
Message-Id: <1236950190.11290.15.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Fri, 2009-03-13 at 10:39 +0000, Lai Jiangshan wrote:
> Commit-ID:  e94142a67f8bad494c593f0a07c9fc2fbec98c0e
> Gitweb:     http://git.kernel.org/tip/e94142a67f8bad494c593f0a07c9fc2fbec98c0e
> Author:     Lai Jiangshan <laijs@cn.fujitsu.com>
> AuthorDate: Fri, 13 Mar 2009 17:51:27 +0800
> Commit:     Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 13 Mar 2009 11:36:20 +0100
> 
> ftrace: remove struct list_head from struct dyn_ftrace
> Impact: save memory
> 
> The struct dyn_ftrace table is very large, this patch will save
> about 50%.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Cc: Steven Rostedt <srostedt@redhat.com>
> LKML-Reference: <49BA2C9F.8020009@cn.fujitsu.com>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> 
> 
> ---
>  include/linux/ftrace.h |    1 -
>  kernel/trace/ftrace.c  |   14 ++++++++------
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/include/linux/ftrace.h b/include/linux/ftrace.h
> index c146c10..9d598bb 100644
> --- a/include/linux/ftrace.h
> +++ b/include/linux/ftrace.h
> @@ -145,7 +145,6 @@ enum {
>  };
>  
>  struct dyn_ftrace {
> -	struct list_head	list;
>  	unsigned long		ip; /* address of mcount call-site */
>  	unsigned long		flags;
>  	struct dyn_arch_ftrace	arch;
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index bf78a4c..90d5729 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -272,7 +272,7 @@ enum {
>  
>  static int ftrace_filtered;
>  
> -static LIST_HEAD(ftrace_new_addrs);
> +static struct dyn_ftrace *ftrace_new_addrs;
>  
>  static DEFINE_MUTEX(ftrace_regex_lock);
>  
> @@ -409,8 +409,8 @@ ftrace_record_ip(unsigned long ip)
>  		return NULL;
>  
>  	rec->ip = ip;
> -
> -	list_add(&rec->list, &ftrace_new_addrs);
> +	rec->flags = (unsigned long)ftrace_new_addrs;

Lets not play games with pointers. If we are going to do this, make it
into a union.

struct dyn_arch_ftrace {
	unsigned long ip;
	union {
		unsigned long flags;
		struct dyn_arch_ftrace *next;
	}
	struct dyn_arch_ftrace arch;
};


This way it is much clearer to what is going on.


> +	ftrace_new_addrs = rec;
>  
>  	return rec;
>  }
> @@ -716,19 +716,21 @@ unsigned long		ftrace_update_tot_cnt;
>  
>  static int ftrace_update_code(struct module *mod)
>  {
> -	struct dyn_ftrace *p, *t;
> +	struct dyn_ftrace *p;
>  	cycle_t start, stop;
>  
>  	start = ftrace_now(raw_smp_processor_id());
>  	ftrace_update_cnt = 0;
>  
> -	list_for_each_entry_safe(p, t, &ftrace_new_addrs, list) {
> +	while (ftrace_new_addrs) {
>  
>  		/* If something went wrong, bail without enabling anything */
>  		if (unlikely(ftrace_disabled))
>  			return -1;
>  
> -		list_del_init(&p->list);
> +		p = ftrace_new_addrs;
> +		ftrace_new_addrs = (struct dyn_ftrace *)p->flags;

This confused me (and scared me) for a bit. Having a union would not
have.

Make the change to a union, and then you have my:

Acked-by: Steven Rostedt <srostedt@redhat.com>

Thanks,

-- Steve



> +		p->flags = 0L;
>  
>  		/* convert record (i.e, patch mcount-call with NOP) */
>  		if (ftrace_code_disable(mod, p)) {

