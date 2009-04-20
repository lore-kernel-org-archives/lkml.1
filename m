Return-Path: <linux-kernel-owner+w=401wt.eu-S1753296AbZDTH01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbZDTH01 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Apr 2009 03:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZDTH0R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Apr 2009 03:26:17 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:26728 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbZDTH0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Apr 2009 03:26:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=pDWktyD/LrtowlYdbJP8ck9+pCjVUoT0mTKN8hvUfppx1TzxDNULHlzdCAzlI1xN//
         ++PxXKGoUnnKxcw32AdwMTZxXS4pd1PaMqzTx16KPyfiT+HwXqhGSgthphvtsGBGT0rb
         DgJlIkxgv0rZgu7feGtusVyVQP7EUeL2mG8qo=
Date: Mon, 20 Apr 2009 09:26:09 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Zhaolei <zhaolei@cn.fujitsu.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Steven Rostedt <rostedt@goodmis.org>, Tom Zanussi <tzanussi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Oleg Nesterov <oleg@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/4] trace_workqueue: use list_for_each_entry() instead
	of list_for_each_entry_safe()
Message-ID: <20090420072608.GB6081@nowhere>
References: <20090415085310.AC0D.A69D9226@jp.fujitsu.com> <20090415011533.GI5968@nowhere> <20090415141250.AC46.A69D9226@jp.fujitsu.com> <49EC1943.8080606@cn.fujitsu.com> <49EC1D12.7060207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49EC1D12.7060207@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 20, 2009 at 02:58:26PM +0800, Zhaolei wrote:
> No need to use list_for_each_entry_safe() in iteration without delete node,
> we use list_for_each_entry() instead.
> 
> Signed-off-by: Zhao Lei <zhaolei@cn.fujitsu.com>
> ---
>  kernel/trace/trace_workqueue.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/trace/trace_workqueue.c b/kernel/trace/trace_workqueue.c
> index 984b917..934b27c 100644
> --- a/kernel/trace/trace_workqueue.c
> +++ b/kernel/trace/trace_workqueue.c
> @@ -47,12 +47,11 @@ probe_workqueue_insertion(struct task_struct *wq_thread,
>  			  struct work_struct *work)
>  {
>  	int cpu = cpumask_first(&wq_thread->cpus_allowed);
> -	struct cpu_workqueue_stats *node, *next;
> +	struct cpu_workqueue_stats *node;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> -							list) {
> +	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
>  		if (node->pid == wq_thread->pid) {
>  			atomic_inc(&node->inserted);
>  			goto found;
> @@ -69,12 +68,11 @@ probe_workqueue_execution(struct task_struct *wq_thread,
>  			  struct work_struct *work)
>  {
>  	int cpu = cpumask_first(&wq_thread->cpus_allowed);
> -	struct cpu_workqueue_stats *node, *next;
> +	struct cpu_workqueue_stats *node;
>  	unsigned long flags;
>  
>  	spin_lock_irqsave(&workqueue_cpu_stat(cpu)->lock, flags);
> -	list_for_each_entry_safe(node, next, &workqueue_cpu_stat(cpu)->list,
> -							list) {
> +	list_for_each_entry(node, &workqueue_cpu_stat(cpu)->list, list) {
>  		if (node->pid == wq_thread->pid) {
>  			node->executed++;
>  			goto found;


Thanks, looks good.

Acked-by: Frederic Weisbecker <fweisbec@gmail.com> 

