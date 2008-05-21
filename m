Return-Path: <linux-kernel-owner+w=401wt.eu-S932649AbYEUXdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932649AbYEUXdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 19:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756959AbYEUXdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 19:33:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55619 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755867AbYEUXdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 19:33:05 -0400
Date: Wed, 21 May 2008 16:32:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Srinivasa D S <srinivasa@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, ananth@in.ibm.com, mhiramat@redhat.com,
       jkenisto@us.ibm.com, srikar@linux.vnet.ibm.com
Subject: Re: [RFC] [PATCH] To improve kretprobe scalability
Message-Id: <20080521163235.0fcb39ed.akpm@linux-foundation.org>
In-Reply-To: <200805210632.17655.srinivasa@in.ibm.com>
References: <200805210632.17655.srinivasa@in.ibm.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 May 2008 06:32:17 +0530
Srinivasa D S <srinivasa@in.ibm.com> wrote:

> 
> Currently list of kretprobe instances are stored in kretprobe object (as
> used_instances,free_instances) and in kretprobe hash table. We have one 
> global kretprobe lock to serialise the access to these lists. This causes 
> only one kretprobe handler to execute at a time. Hence affects system 
> performance, particularly on SMP systems and when return probe is set on
> lot of functions (like on all systemcalls).
> 
> Solution proposed here gives fine-grain locks that performs better on SMP
> system compared to present kretprobe implementation.
> 
> Solution:
>    1) Instead of having one global lock to protect kretprobe instances  
> present in kretprobe object and kretprobe hash table. We will have two locks, 
> one lock for protecting kretprobe hash table and another lock for kretporbe 
> object.
> 	
>   2) We hold lock present in kretprobe object while we modify kretprobe 
> instance in kretprobe object and we hold per-hash-list lock while modifying 
> kretprobe instances present in that hash list. To prevent deadlock, we never 
> grab a per-hash-list lock while holding a kretprobe lock.
> 
>   3) We can remove used_instances from struct kretprobe, as we can track used
> instances of kretprobe instances using kretprobe hash table.

Are you sure that all the code which was previously globally serialised
is safe to run concurrently?

> Time duration for  kernel compilation ("make -j 8") on a 8-way ppc64 system
> with return probes set on all systemcalls looks like this.
> 
> Patched-kernel                            Un-Patched kernel
> ============================================================
> real    10m49.694s                       real    13m21.276s
> user    35m6.117s                        user    40m30.454s
> sys     2m55.480s                        sys     3m23.221s
> ===========================================================

That's a large speedup.

Do you have available the figures for the same workload when no probes
are set at all?

> --- linux-2.6.26-rc2-mm1.orig/kernel/kprobes.c
> +++ linux-2.6.26-rc2-mm1/kernel/kprobes.c
> @@ -62,6 +62,7 @@
>  	addr = ((kprobe_opcode_t *)(kallsyms_lookup_name(name)))
>  #endif
>  
> +static int kprobes_initialized;
>  static struct hlist_head kprobe_table[KPROBE_TABLE_SIZE];
>  static struct hlist_head kretprobe_inst_table[KPROBE_TABLE_SIZE];
>  
> @@ -69,8 +70,8 @@ static struct hlist_head kretprobe_inst_
>  static bool kprobe_enabled;
>  
>  DEFINE_MUTEX(kprobe_mutex);		/* Protects kprobe_table */
> -DEFINE_SPINLOCK(kretprobe_lock);	/* Protects kretprobe_inst_table */
>  static DEFINE_PER_CPU(struct kprobe *, kprobe_instance) = NULL;
> +static spinlock_t kretprobe_table_locks[KPROBE_TABLE_SIZE];

An array of 64 spinlocks.  These will all be crammed into two or four
cachelines.  If there is really any concurrency in here, the contention
will be large.

I suggest that you experiment with one-lock-per-cacheline here and see
whether it is worth doing that permanently.

Something along the lines of

static struct {
	spinlock_t lock __cacheline_aligned;
} kretprobe_locks[KPROBE_TABLE_SIZE];

static spinlock_t *kretprobe_lock_ptr(...)
{
	return kretprobe_locks + hash(...);
}


Also, none of this new code is needed on uniprocessor builds.  Did we
just add some bloat?

> -struct hlist_head __kprobes *kretprobe_inst_table_head(struct task_struct 
> *tsk)
> +void get_kretprobe_hash_lock(struct task_struct *tsk,
> +			 struct hlist_head **head, unsigned long *flags)
> +{
> +	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
> +	spinlock_t *hlist_lock;
> +
> +	*head = &kretprobe_inst_table[hash];
> +	hlist_lock = &kretprobe_table_locks[hash];
> +	spin_lock_irqsave(hlist_lock, *flags);
> +}
> +
> +void put_kretprobe_hash_lock(struct task_struct *tsk, unsigned long *flags)
>  {
> -	return &kretprobe_inst_table[hash_ptr(tsk, KPROBE_HASH_BITS)];
> +	unsigned long hash = hash_ptr(tsk, KPROBE_HASH_BITS);
> +	spinlock_t *hlist_lock;
> +
> +	hlist_lock = &kretprobe_table_locks[hash];
> +	spin_unlock_irqrestore(hlist_lock, *flags);
>  }

I think these functions are misnamed.  Generally functions whose names
are of the form get_foo() and put_foo() are used for acquiring and
releasing reference counts.  These functions don't do that.

kretprobe_hash_lock() and kretprobe_hash_unlock() would be better?

>  /*
> @@ -401,17 +417,21 @@ void __kprobes kprobe_flush_task(struct 
>  	struct kretprobe_instance *ri;
>  	struct hlist_head *head, empty_rp;
>  	struct hlist_node *node, *tmp;
> -	unsigned long flags = 0;
> +	unsigned long hash, flags = 0;
>  
> -	INIT_HLIST_HEAD(&empty_rp);
> -	spin_lock_irqsave(&kretprobe_lock, flags);
> -	head = kretprobe_inst_table_head(tk);
> +	if (unlikely(!kprobes_initialized))
> +		/* Early boot.  kretprobe_table_locks not yet initialized. */
> +		return;
> +
> +	hash = hash_ptr(tk, KPROBE_HASH_BITS);
> +	head = &kretprobe_inst_table[hash];
> +	spin_lock_irqsave(&kretprobe_table_locks[hash], flags);

that's an open-coded copy of get_kretprobe_hash_lock()?

>  	hlist_for_each_entry_safe(ri, node, tmp, head, hlist) {
>  		if (ri->task == tk)
>  			recycle_rp_inst(ri, &empty_rp);
>  	}
> -	spin_unlock_irqrestore(&kretprobe_lock, flags);
> -
> +	spin_unlock_irqrestore(&kretprobe_table_locks[hash], flags);

and of put_kretprobe_hash_lock().  Perhaps a separate function which
just obtains the spinlock_t* is needed.

> +	INIT_HLIST_HEAD(&empty_rp);
>  	hlist_for_each_entry_safe(ri, node, tmp, &empty_rp, hlist) {
>  		hlist_del(&ri->hlist);
>  		kfree(ri);
> @@ -423,24 +443,29 @@ static inline void free_rp_inst(struct k
>  	struct kretprobe_instance *ri;
>  	struct hlist_node *pos, *next;
>  
> -	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, uflist) {
> -		hlist_del(&ri->uflist);
> +	hlist_for_each_entry_safe(ri, pos, next, &rp->free_instances, hlist) {
> +		hlist_del(&ri->hlist);
>  		kfree(ri);
>  	}
>  }
>  

