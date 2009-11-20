Return-Path: <linux-kernel-owner+w=401wt.eu-S1753951AbZKTXqb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951AbZKTXqb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Nov 2009 18:46:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZKTXq3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Nov 2009 18:46:29 -0500
Received: from mail1.radix.net ([207.192.128.31]:40721 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753743AbZKTXqT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Nov 2009 18:46:19 -0500
Subject: Re: [PATCH 17/19] workqueue: introduce worker
From: Andy Walls <awalls@radix.net>
To: Tejun Heo <tj@kernel.org>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, mingo@elte.hu, akpm@linux-foundation.org,
       jens.axboe@oracle.com, rusty@rustcorp.com.au, cl@linux-foundation.org,
       dhowells@redhat.com, arjan@linux.intel.com, avi@redhat.com,
       peterz@infradead.org, johannes@sipsolutions.net
In-Reply-To: <1258692407-8985-18-git-send-email-tj@kernel.org>
References: <1258692407-8985-1-git-send-email-tj@kernel.org>
	 <1258692407-8985-18-git-send-email-tj@kernel.org>
Content-Type: text/plain
Date: Fri, 20 Nov 2009 18:44:31 -0500
Message-Id: <1258760671.3058.28.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-11-20 at 13:46 +0900, Tejun Heo wrote:
> Separate out worker thread related information to struct worker from
> struct cpu_workqueue_struct and implement helper functions to deal
> with the new struct worker.  The only change which is visible outside
> is that now workqueue worker are all named "kworker/CPUID:WORKERID"
> where WORKERID is allocated from per-cpu ida.
> 
> This is in preparation of concurrency managed workqueue where shared
> multiple workers would be available per cpu.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c |  220 +++++++++++++++++++++++++++++++++++++---------------
>  1 files changed, 157 insertions(+), 63 deletions(-)

> +static struct worker *create_worker(struct cpu_workqueue_struct *cwq, bool bind)
> +{
> +	int id = -1;
> +	struct worker *worker = NULL;
> +
> +	spin_lock(&workqueue_lock);
> +	while (ida_get_new(&per_cpu(worker_ida, cwq->cpu), &id)) {
> +		spin_unlock(&workqueue_lock);
> +		if (!ida_pre_get(&per_cpu(worker_ida, cwq->cpu), GFP_KERNEL))
> +			goto fail;
> +		spin_lock(&workqueue_lock);
> +	}
> +	spin_unlock(&workqueue_lock);
> +
> +	worker = alloc_worker();
> +	if (!worker)
> +		goto fail;
> +
> +	worker->cwq = cwq;
> +	worker->id = id;
> +
> +	worker->task = kthread_create(worker_thread, worker, "kworker/%u:%d",
> +				      cwq->cpu, id);


 
> -static int create_workqueue_thread(struct cpu_workqueue_struct *cwq, int cpu)
> -{
> -	struct workqueue_struct *wq = cwq->wq;
> -	const char *fmt = is_wq_single_threaded(wq) ? "%s" : "%s/%d";
> -	struct task_struct *p;
> -
> -	p = kthread_create(worker_thread, cwq, fmt, wq->name, cpu);


Hi Tejun,

I think this change means a user can no longer see worker names that can
be easily mapped to kernel drivers in utiltites like top:

 2499 root      20   0  196m  33m 9012 S  2.7  3.6  14:20.55 Xorg               
 1313 root      15  -5     0    0    0 S  1.3  0.0   0:37.76 cx18-0-in         <---
 2418 root      15  -5     0    0    0 D  1.3  0.0   1:14.59 kdvb-ad-0-fe-0    <--- 
 2360 root      20   0  537m  16m 7012 S  0.7  1.8   3:20.32 mythbackend        
  877 root      15  -5     0    0    0 S  0.3  0.0   0:01.01 usb-storage        
 1311 root      15  -5     0    0    0 S  0.3  0.0   0:22.65 cx18-0-out/0      <---
 3034 andy      20   0  277m 7832 6340 S  0.3  0.8   0:26.36 multiload-apple    
 4779 andy      20   0 14880 1172  872 R  0.3  0.1   0:00.13 top                
    1 root      20   0  4088  868  616 S  0.0  0.1   0:00.72 init               
    2 root      15  -5     0    0    0 S  0.0  0.0   0:00.00 kthreadd           

If so, I think that it may hamper the ordinary user in submitting good
bug reports or trying to do some troubleshooting on their own.  Also,
when forced to dump state with the magic-alt-syrq, I think this change
makes debugging the dump slightly more difficult.

Do you have a pressing need to use the naming convention you have chosen
over the current convention?  I do realize that the "/cpu_numnber" part
of the current naming convention needs to be augmented.  I just am
apprehensive about the descriptive names all being replaced with
"kworker".

Regards,
Andy

