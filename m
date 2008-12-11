Return-Path: <linux-kernel-owner+w=401wt.eu-S1758786AbYLKWBS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758786AbYLKWBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2008 17:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757417AbYLKWBG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Dec 2008 17:01:06 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:24879 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502AbYLKWBE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2008 17:01:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=T+eDSv6Oba17yalC9Ro3DX1NoRNaoCKviC+0t10bTMCkmS7zS9lA6ZeA6mCfLbATrA
         dkCawS9/8PeQWJvLxpuz3CsSn733RIfx2rrsGtHDvAbD6XpncXLSVsAfJmB3K5U1ihxx
         0uGIkgfKvJpAwEWXE1mNIhu990/etbAocyhBI=
Message-ID: <84144f020812111401n78f980a3v101b3518ab5a3b20@mail.gmail.com>
Date: Fri, 12 Dec 2008 00:01:01 +0200
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Catalin Marinas" <catalin.marinas@arm.com>
Subject: Re: [PATCH 01/15] kmemleak: Add the base support
Cc: linux-kernel@vger.kernel.org,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Ingo Molnar" <mingo@elte.hu>,
       "Andrew Morton" <akpm@linux-foundation.org>
In-Reply-To: <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081210182652.30323.4594.stgit@pc1117.cambridge.arm.com>
	 <20081210182659.30323.43898.stgit@pc1117.cambridge.arm.com>
X-Google-Sender-Auth: 286707cbf0fd8ee6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Catalin,

Few minor nits below.

On Wed, Dec 10, 2008 at 8:26 PM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> +static void put_object(struct memleak_object *object)
> +{
> +       if (!atomic_dec_and_test(&object->use_count))
> +               return;
> +
> +       /* should only get here after delete_object was called */
> +       BUG_ON(object->flags & OBJECT_ALLOCATED);

This could be

    if (WARN_ON(object->flags & OBJECT_ALLOCATED))
            return;

> +static void create_object(unsigned long ptr, size_t size, int min_count,
> +                         gfp_t gfp)
> +{
> +       unsigned long flags;
> +       struct memleak_object *object;
> +       struct prio_tree_node *node;
> +       struct stack_trace trace;
> +
> +       object = kmem_cache_alloc(object_cache, gfp);
> +       if (!object)
> +               memleak_panic("kmemleak: Cannot allocate a memleak_object "
> +                             "structure\n");

Don't you want to exit early here if object == NULL?

> +
> +       INIT_LIST_HEAD(&object->object_list);
> +       INIT_LIST_HEAD(&object->gray_list);
> +       INIT_HLIST_HEAD(&object->area_list);
> +       spin_lock_init(&object->lock);
> +       atomic_set(&object->use_count, 1);
> +       object->flags = OBJECT_ALLOCATED;
> +       object->pointer = ptr;
> +       object->size = size;
> +       object->min_count = min_count;
> +       object->count = -1;                     /* no color initially */
> +       object->jiffies = jiffies;
> +
> +       /* task information */
> +       if (in_irq()) {
> +               object->pid = 0;
> +               strncpy(object->comm, "hardirq", TASK_COMM_LEN);
> +       } else if (in_softirq()) {
> +               object->pid = 0;
> +               strncpy(object->comm, "softirq", TASK_COMM_LEN);
> +       } else {
> +               object->pid = current->pid;
> +               get_task_comm(object->comm, current);
> +       }
> +
> +       /* kernel backtrace */
> +       trace.max_entries = MAX_TRACE;
> +       trace.nr_entries = 0;
> +       trace.entries = object->trace;
> +       trace.skip = 1;
> +       save_stack_trace(&trace);
> +       object->trace_len = trace.nr_entries;
> +
> +       INIT_PRIO_TREE_NODE(&object->tree_node);
> +       object->tree_node.start = ptr;
> +       object->tree_node.last = ptr + size - 1;
> +
> +       write_lock_irqsave(&memleak_lock, flags);
> +       min_addr = min(min_addr, ptr);
> +       max_addr = max(max_addr, ptr + size);
> +       node = prio_tree_insert(&object_tree_root, &object->tree_node);
> +       /*
> +        * The code calling the kernel does not yet have the pointer to the
> +        * memory block to be able to free it.  However, we still hold the
> +        * memleak_lock here in case parts of the kernel started freeing
> +        * random memory blocks.
> +        */
> +       if (node != &object->tree_node) {
> +               unsigned long flags;
> +
> +               pr_warning("kmemleak: Existing pointer\n");
> +               dump_stack();

How come you don't dump_stack() or even WARN_ON() unconditionally in
kmemleak_panic() which is called bit later so you can remove this kind
of ad hoc logging?

> +
> +               object = lookup_object(ptr, 1);
> +               spin_lock_irqsave(&object->lock, flags);
> +               dump_object_info(object);
> +               spin_unlock_irqrestore(&object->lock, flags);
> +
> +               memleak_panic("kmemleak: Cannot insert 0x%lx into the object "
> +                             "search tree\n", ptr);


> +       }
> +       list_add_tail_rcu(&object->object_list, &object_list);
> +       write_unlock_irqrestore(&memleak_lock, flags);
> +}
> +
> +/*
> + * Remove the metadata (struct memleak_object) for a memory block from the
> + * object_list and object_tree_root and decrement its use_count.
> + */
> +static void delete_object(unsigned long ptr)
> +{
> +       unsigned long flags;
> +       struct memleak_object *object;
> +
> +       write_lock_irqsave(&memleak_lock, flags);
> +       object = lookup_object(ptr, 0);
> +       if (!object) {
> +               pr_warning("kmemleak: Freeing unknown object at 0x%08lx\n",
> +                          ptr);
> +               dump_stack();

Hmm, dump_stack() is called in quite a few places. Might make sense to
add a memleak_report() function that does this in an uniform way.

> +               write_unlock_irqrestore(&memleak_lock, flags);
> +               return;
> +       }
> +       prio_tree_remove(&object_tree_root, &object->tree_node);
> +       list_del_rcu(&object->object_list);
> +       write_unlock_irqrestore(&memleak_lock, flags);
> +
> +       BUG_ON(!(object->flags & OBJECT_ALLOCATED));
> +       BUG_ON(atomic_read(&object->use_count) < 1);

These could be converted to WARN_ON() calls, I think?

> +
> +       /*
> +        * Locking here also ensures that the corresponding memory block
> +        * cannot be freed when it is being scanned.
> +        */
> +       spin_lock_irqsave(&object->lock, flags);
> +       object->flags &= ~OBJECT_ALLOCATED;
> +#ifdef REPORT_ORPHAN_FREEING
> +       if (color_white(object)) {
> +               pr_warning("kmemleak: Freeing orphan object 0x%08lx\n", ptr);
> +               dump_stack();
> +               dump_object_info(object);
> +       }
> +#endif
> +       spin_unlock_irqrestore(&object->lock, flags);
> +       put_object(object);
> +}
> +
> +/*
> + * Make a object permanently as gray-colored so that it can no longer be
> + * reported as a leak. This is used in general to mark a false positive.
> + */
> +static void make_gray_object(unsigned long ptr)
> +{
> +       unsigned long flags;
> +       struct memleak_object *object;
> +
> +       object = find_and_get_object(ptr, 0);
> +       if (!object) {
> +               dump_stack();
> +               memleak_panic("kmemleak: Graying unknown object at 0x%08lx\n",
> +                             ptr);

Early return here?

> +       }
> +
> +       spin_lock_irqsave(&object->lock, flags);
> +       object->min_count = 0;
> +       spin_unlock_irqrestore(&object->lock, flags);
> +       put_object(object);
> +}
> +
> +/*
> + * Mark the object as black-colored so that it is ignored from scans and
> + * reporting.
> + */
> +static void make_black_object(unsigned long ptr)
> +{
> +       unsigned long flags;
> +       struct memleak_object *object;
> +
> +       object = find_and_get_object(ptr, 0);
> +       if (!object) {
> +               dump_stack();
> +               memleak_panic("kmemleak: Blacking unknown object at 0x%08lx\n",
> +                             ptr);

Ditto.

> +       }
> +
> +       spin_lock_irqsave(&object->lock, flags);
> +       object->min_count = -1;
> +       spin_unlock_irqrestore(&object->lock, flags);
> +       put_object(object);
> +}
> +
> +/*
> + * Add a scanning area to the object. If at least one such area is added,
> + * kmemleak will only scan these ranges rather than the whole memory block.
> + */
> +static void add_scan_area(unsigned long ptr, unsigned long offset,
> +                         size_t length, gfp_t gfp)
> +{
> +       unsigned long flags;
> +       struct memleak_object *object;
> +       struct memleak_scan_area *area;
> +
> +       object = find_and_get_object(ptr, 0);
> +       if (!object) {
> +               dump_stack();
> +               memleak_panic("kmemleak: Adding scan area to unknown "
> +                             "object at 0x%08lx\n", ptr);

Ditto.

> +       }
> +
> +       area = kmem_cache_alloc(scan_area_cache, gfp);
> +       if (!area)
> +               memleak_panic("kmemleak: Cannot allocate a scan area\n");
> +
> +       spin_lock_irqsave(&object->lock, flags);
> +       if (offset + length > object->size) {
> +               dump_stack();
> +               dump_object_info(object);
> +               memleak_panic("kmemleak: Scan area larger than object "
> +                             "0x%08lx\n", ptr);
> +       }
> +
> +       INIT_HLIST_NODE(&area->node);
> +       area->offset = offset;
> +       area->length = length;
> +
> +       hlist_add_head(&area->node, &object->area_list);
> +       spin_unlock_irqrestore(&object->lock, flags);
> +       put_object(object);
> +}
> +
> +/*
> + * Log an early memleak_* call to the early_log buffer. These calls will be
> + * processed later once kmemleak is fully initialized.
> + */
> +static void __init log_early(int op_type, const void *ptr, size_t size,
> +                            int min_count,
> +                            unsigned long offset, size_t length)
> +{
> +       unsigned long flags;
> +       struct early_log *log;
> +
> +       if (crt_early_log >= ARRAY_SIZE(early_log))
> +               memleak_panic("kmemleak: Early log buffer exceeded\n");

Here as well.

> +
> +       /*
> +        * There is no need for locking since the kernel is still in UP mode
> +        * at this stage. Disabling the IRQs is enough.
> +        */
> +       local_irq_save(flags);
> +       log = &early_log[crt_early_log];
> +       log->op_type = op_type;
> +       log->ptr = ptr;
> +       log->size = size;
> +       log->min_count = min_count;
> +       log->offset = offset;
> +       log->length = length;
> +       crt_early_log++;
> +       local_irq_restore(flags);
> +}
