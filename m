Return-Path: <linux-kernel-owner+w=401wt.eu-S1759088AbZAHOPX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759088AbZAHOPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 09:15:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbZAHOPK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 09:15:10 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:64123 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbZAHOPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 09:15:08 -0500
Date: Thu, 8 Jan 2009 09:15:05 -0500 (EST)
From: Steven Rostedt <rostedt@goodmis.org>
X-X-Sender: rostedt@gandalf.stny.rr.com
To: akpm@linux-foundation.org
cc: mm-commits@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: + kernel-trace-ring_bufferc-reduce-inlining.patch added to -mm
 tree
In-Reply-To: <200901080529.n085TKaG015772@imap1.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0901080829360.22642@gandalf.stny.rr.com>
References: <200901080529.n085TKaG015772@imap1.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> ------------------------------------------------------
> Subject: kernel/trace/ring_buffer.c: reduce inlining
> From: Andrew Morton <akpm@linux-foundation.org>
> 
>           text    data     bss     dec     hex filename
> before:  11320     228       8   11556    2d24 kernel/trace/ring_buffer.o
> after:   10592     228       8   10828    2a4c kernel/trace/ring_buffer.o
> 
> Also: free_page(0) is legal.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  kernel/trace/ring_buffer.c |   23 +++++++++++------------
>  1 file changed, 11 insertions(+), 12 deletions(-)
> 
> diff -puN kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-reduce-inlining kernel/trace/ring_buffer.c
> --- a/kernel/trace/ring_buffer.c~kernel-trace-ring_bufferc-reduce-inlining
> +++ a/kernel/trace/ring_buffer.c
> @@ -133,7 +133,7 @@ enum {
>  };
>  
>  /* inline for ring buffer fast paths */

Well, we need to change the comment at the very least. Some of these (well
probably most of these) functions are in the hot path, and were inlined to
keep the overhead of tracing down. Remember, these functions can be called
at every kernel function call. And yes, some of these can make a noticeable 
difference. I'll have to pull out my old benchmarks (if I can find them), 
or make new ones.

Thanks,


-- Steve

> -static inline unsigned
> +static unsigned
>  rb_event_length(struct ring_buffer_event *event)
>  {
>  	unsigned length;
> @@ -173,7 +173,7 @@ unsigned ring_buffer_event_length(struct
>  EXPORT_SYMBOL_GPL(ring_buffer_event_length);
>  
>  /* inline for ring buffer fast paths */
> -static inline void *
> +static void *
>  rb_event_data(struct ring_buffer_event *event)
>  {
>  	BUG_ON(event->type != RINGBUF_TYPE_DATA);
> @@ -223,10 +223,9 @@ static void rb_init_page(struct buffer_d
>   * Also stolen from mm/slob.c. Thanks to Mathieu Desnoyers for pointing
>   * this issue out.
>   */
> -static inline void free_buffer_page(struct buffer_page *bpage)
> +static void free_buffer_page(struct buffer_page *bpage)
>  {
> -	if (bpage->page)
> -		free_page((unsigned long)bpage->page);
> +	free_page((unsigned long)bpage->page);
>  	kfree(bpage);
>  }
>  
> @@ -805,7 +804,7 @@ rb_event_index(struct ring_buffer_event 
>  	return (addr & ~PAGE_MASK) - (PAGE_SIZE - BUF_PAGE_SIZE);
>  }
>  
> -static inline int
> +static int
>  rb_is_commit(struct ring_buffer_per_cpu *cpu_buffer,
>  	     struct ring_buffer_event *event)
>  {
> @@ -819,7 +818,7 @@ rb_is_commit(struct ring_buffer_per_cpu 
>  		rb_commit_index(cpu_buffer) == index;
>  }
>  
> -static inline void
> +static void
>  rb_set_commit_event(struct ring_buffer_per_cpu *cpu_buffer,
>  		    struct ring_buffer_event *event)
>  {
> @@ -844,7 +843,7 @@ rb_set_commit_event(struct ring_buffer_p
>  	local_set(&cpu_buffer->commit_page->page->commit, index);
>  }
>  
> -static inline void
> +static void
>  rb_set_commit_to_write(struct ring_buffer_per_cpu *cpu_buffer)
>  {
>  	/*
> @@ -890,7 +889,7 @@ static void rb_reset_reader_page(struct 
>  	cpu_buffer->reader_page->read = 0;
>  }
>  
> -static inline void rb_inc_iter(struct ring_buffer_iter *iter)
> +static void rb_inc_iter(struct ring_buffer_iter *iter)
>  {
>  	struct ring_buffer_per_cpu *cpu_buffer = iter->cpu_buffer;
>  
> @@ -920,7 +919,7 @@ static inline void rb_inc_iter(struct ri
>   * and with this, we can determine what to place into the
>   * data field.
>   */
> -static inline void
> +static void
>  rb_update_event(struct ring_buffer_event *event,
>  			 unsigned type, unsigned length)
>  {
> @@ -958,7 +957,7 @@ rb_update_event(struct ring_buffer_event
>  	}
>  }
>  
> -static inline unsigned rb_calculate_event_length(unsigned length)
> +static unsigned rb_calculate_event_length(unsigned length)
>  {
>  	struct ring_buffer_event event; /* Used only for sizeof array */
>  
> @@ -1432,7 +1431,7 @@ int ring_buffer_write(struct ring_buffer
>  }
>  EXPORT_SYMBOL_GPL(ring_buffer_write);
>  
> -static inline int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
> +static int rb_per_cpu_empty(struct ring_buffer_per_cpu *cpu_buffer)
>  {
>  	struct buffer_page *reader = cpu_buffer->reader_page;
>  	struct buffer_page *head = cpu_buffer->head_page;
> _
> 
> Patches currently in -mm which might be from akpm@linux-foundation.org are
> 
> origin.patch
> cgroups-skip-processes-from-other-namespaces-when-listing-a-cgroup.patch
> memcg-introduce-charge-commit-cancel-style-of-functions.patch
> memcg-new-force_empty-to-free-pages-under-group.patch
> memcg-swap-cgroup-for-remembering-usage.patch
> memory-cgroup-resource-counters-for-hierarchy-v4.patch
> memory-cgroup-hierarchical-reclaim-v4.patch
> memcg-avoid-unnecessary-system-wide-oom-killer.patch
> w1-allow-master-io-commands.patch
> romfs-romfs_iget-unsigned-ino-=-0-is-always-true.patch
> i-need-old-gcc.patch
> mm-remove-the-might_sleep-from-lock_page.patch
> linux-next.patch
> next-remove-localversion.patch
> linux-next-git-rejects.patch
> clocksource-pass-clocksource-to-read-callback-sparc-cleanup.patch
> drivers-input-touchscreen-ucb1400_tsc-needs-gpio.patch
> video-mbp_nvidia_bl-add-support-for-macbook-5-macbook-air-2-and-macbook-pro-5-fix.patch
> pci-quirks-unhide-overflow-device-on-i828675p-pe-chipsets.patch
> smp_call_function_single-be-slightly-less-stupid.patch
> kernel-trace-ring_bufferc-reduce-inlining.patch
> kernel-trace-ring_bufferc-use-div_round_up.patch
> raw-fix-rawctl-compat-ioctls-breakage-on-amd64-and-itanic-checkpatch-fixes.patch
> scsi-dpt_i2o-is-bust-on-ia64.patch
> page_fault-retry-with-nopage_retry-fix.patch
> page_fault-retry-with-nopage_retry-fix-fix.patch
> mm-add-proc-controls-for-pdflush-threads-fix.patch
> mm-add-proc-controls-for-pdflush-threads-fix-fix.patch
> filesystem-freeze-implement-generic-freeze-feature-fix.patch
> nilfs2-inode-operations-fix.patch
> nilfs2-pathname-operations-fix.patch
> nilfs2-super-block-operations-fix.patch
> kmemleak-add-the-base-support-fix.patch
> reiser4.patch
> reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
> nr_blockdev_pages-in_interrupt-warning.patch
> slab-leaks3-default-y.patch
> put_bh-debug.patch
> shrink_slab-handle-bad-shrinkers.patch
> getblk-handle-2tb-devices.patch
> getblk-handle-2tb-devices-fix.patch
> undeprecate-pci_find_device.patch
> notify_change-callers-must-hold-i_mutex.patch
> drivers-net-bonding-bond_sysfsc-suppress-uninitialized-var-warning.patch
> w1-build-fix.patch
> 
> 
> 
