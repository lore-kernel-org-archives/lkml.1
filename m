Return-Path: <linux-kernel-owner+w=401wt.eu-S1753530AbZGTSkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753530AbZGTSkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 14:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752795AbZGTSkb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 14:40:31 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:40818 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751629AbZGTSk3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 14:40:29 -0400
Message-ID: <4A64BA05.30006@polymtl.ca>
Date: Mon, 20 Jul 2009 14:40:05 -0400
From: Benjamin Poirier <benjamin.poirier@polymtl.ca>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: ltt-dev@lists.casi.polymtl.ca, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [ltt-dev] LTTng 0.149 adds experimental ascii output module
References: <20090720140858.GA21257@Krystal>
In-Reply-To: <20090720140858.GA21257@Krystal>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Poly-FromMTA: (hal.drap.polymtl.ca [132.207.162.51]) at Mon, 20 Jul 2009 18:40:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Commit 04751bee05525eaa9310f4050b2f6ebdbcb62567
"cpufreq-cleanup-cpufreq_add_dev" in the lttng tree breaks the build on
machines without CONFIG_SMP:
drivers/cpufreq/cpufreq.c: In function ‘cpufreq_add_dev’:
drivers/cpufreq/cpufreq.c:957: error: ‘managed_policy’ undeclared (first
use in this function)
drivers/cpufreq/cpufreq.c:957: error: (Each undeclared identifier is
reported only once
drivers/cpufreq/cpufreq.c:957: error: for each function it appears in.)
drivers/cpufreq/cpufreq.c:1007: warning: label ‘err_unlock_gov_mutex’
defined but not used
make[2]: *** [drivers/cpufreq/cpufreq.o] Error 1

-Ben

Mathieu Desnoyers wrote:
> Hi,
>
> I completed the work needed to add an ascii output to LTTng last week.
> This effort has been initiated by Lai, but needed some polishing to
> correctly interact with the LTTng ring buffer synchronization.
>
> I decided to release this feature as "EXPERIMENTAL", given it still
> needs some enhancements and testing. Those are explained in the TODO
> comment at the beginning of ltt/ltt-ascii.c. One of the main items would
> be to merge-sort events on a per-trace basis, so people can select
> which channel they want using the per channel "enable" file and then
> simply have a single ascii output for the channel collection.
>
> This patch is integrated in LTTng 0.149. I plan to start going through
> these TODOs when I finish writing my thesis, in a few weeks.
>
> Sample output of the kernel channel:
> (patch below)
>
> # cat /mnt/debugfs/ltt/ascii/trace/kernel
> event:   softirq_raise: cpu: 5 time:00000501376636750494 softirq_id 1
> event:   softirq_raise: cpu: 5 time:00000501376636752660 softirq_id 6
> event:        irq_exit: cpu: 5 time:00000501376636753002 handled 1
> event:       irq_entry: cpu: 5 time:00000501376644750066 ip 18446744071564245255 handler (null) irq_id 239 kernel_mode 1
> event:   softirq_raise: cpu: 2 time:00000501376639351302 softirq_id 4
> event:        irq_exit: cpu: 2 time:00000501376639356114 handled 1
> event:sched_migrate_ta: cpu: 2 time:00000501376639369422 pid 19862 state 2 dest_cpu 2
> event:sched_try_wakeup: cpu: 2 time:00000501376639371060 pid 19862 cpu_id 2 state 2
> event:       timer_set: cpu: 2 time:00000501376639380420 expires 4357539470 function ffffffff80400690 data 18446612150560638464
> event:  sched_schedule: cpu: 2 time:00000501376639389012 prev_pid 0 next_pid 19862 prev_state 0
> event: page_fault_exit: cpu: 2 time:00000501376639394466 res 516
> event:   syscall_entry: cpu: 2 time:00000501376639458606 ip 140218697167927 syscall_id 11
> event:    syscall_exit: cpu: 2 time:00000501376639489320 ret 0
>
> Mathieu
>
>
> LTTng text output module, basic features working
>
> Here is the ltt-ascii module working, with still a few TODO left. Therefore,
> still considered experimental.
>
> See Documentation/lttng.txt.
>
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> CC: Lai Jiangshan <laijs@cn.fujitsu.com>
> ---
>  Documentation/lttng.txt      |   35 +++
>  include/linux/ltt-channels.h |    2 
>  include/linux/ltt-relay.h    |    3 
>  include/linux/ltt-tracer.h   |   29 ++
>  include/linux/marker.h       |    4 
>  kernel/marker.c              |    8 
>  ltt/Kconfig                  |    3 
>  ltt/ltt-ascii.c              |  432 +++++++++++++++++++++++++------------------
>  ltt/ltt-relay-alloc.c        |    8 
>  ltt/ltt-relay-irqoff.c       |   17 +
>  ltt/ltt-relay-locked.c       |   17 +
>  ltt/ltt-relay-lockless.c     |   17 +
>  12 files changed, 386 insertions(+), 189 deletions(-)
>
> Index: linux-2.6-lttng/include/linux/marker.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/marker.h	2009-07-20 09:27:27.000000000 -0400
> +++ linux-2.6-lttng/include/linux/marker.h	2009-07-20 09:27:28.000000000 -0400
> @@ -237,8 +237,8 @@ extern int marker_probe_unregister_priva
>  extern void *marker_get_private_data(const char *channel, const char *name,
>  	marker_probe_func *probe, int num);
>  
> -const char *marker_get_name_form_id(u16 channel_id, u16 event_id);
> -const char *marker_get_fmt_form_id(u16 channel_id, u16 event_id);
> +const char *marker_get_name_from_id(u16 channel_id, u16 event_id);
> +const char *marker_get_fmt_from_id(u16 channel_id, u16 event_id);
>  
>  /*
>   * marker_synchronize_unregister must be called between the last marker probe
> Index: linux-2.6-lttng/ltt/ltt-ascii.c
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/ltt-ascii.c	2009-07-20 09:27:26.000000000 -0400
> +++ linux-2.6-lttng/ltt/ltt-ascii.c	2009-07-20 09:27:28.000000000 -0400
> @@ -8,32 +8,30 @@
>   */
>  
>  /*
> - * TODO :
> - * This file is work-in-progress. It should be adapted to the new internal API
> - * for readers. The algorithm is :
> + * TODO
>   *
> - * sleep (for polling mode) or wait on a reader wait queue.
> - * wait for all buffers to be ready for read
> - * when ready, get subbuf (for all subbuffers)
> - * merge sort reads by timestamp
> - *  a read is done with get_offset/get_consumed to know
> - *    - Where to read
> - *    - If buffer is empty
> - *    - If buffer has reached EOF
> - * put subbuf when read ends for a subbuf
> - * while buffers are not both finalized and empty.
> + * - Automate periodical switch:
>   *
> - * struct ltt_relay_cpu_iter and struct ltt_relay_iter should be adapted
> - * to work on buffer "consumed/write" offsets rather than a single "offset"
> - * variable.
> - *
> - * The new debugfs file "switch_timer" receives a timer period as parameter
> + * The debugfs file "switch_timer" receives a timer period as parameter
>   * (e.g. echo 100 > switch_timer) to activate the timer per channel. This can
>   * also be accessed through the internal API _before the trace session starts_.
>   * This timer will insure that we periodically have subbuffers to read, and
>   * therefore that the merge-sort does not wait endlessly for a subbuffer.
> + *
> + * - If a channel is switched and read without data, make sure it is still
> + * considered afterward (not removed from the queue).
> + *
> + * - Create a ascii/tracename/ALL file to merge-sort all active channels.
> + * - Create a ascii/tracename/README file to contain the text output legend.
> + * - Remove leading zeroes from timestamps.
> + * - Enhance pretty-printing to make sure all types used for addesses output in
> + * the form 0xAB00000000 (not decimal). This is true for %p and 0x%...X.
> + * - Hotplug support
>   */
>  
> +
> +
> +
>  #include <linux/module.h>
>  #include <linux/ltt-tracer.h>
>  #include <linux/ltt-relay.h>
> @@ -45,26 +43,51 @@
>  #include <linux/cpu.h>
>  #include <linux/fs.h>
>  
> +#if 0
> +#define DEBUGP printk
> +#else
> +#define DEBUGP(fmt , a...)
> +#endif
> +
>  struct dentry *ltt_ascii_dir_dentry;
>  EXPORT_SYMBOL_GPL(ltt_ascii_dir_dentry);
>  
> -/* TODO : offset high bits, no disable., use API */
> +struct ltt_relay_iter;
>  
>  struct ltt_relay_cpu_iter {
>  	/* cpu buffer information */
>  	struct rchan_buf *buf;
> -	size_t start_offset;
> -	size_t eof_offset;
> +	struct ltt_relay_iter *iter;
> +	int sb_ref;		/* holding a reference to a subbuffer */
> +	long read_sb_offset;	/* offset of the subbuffer read */
>  
>  	/* current event information */
>  	struct ltt_subbuffer_header *header;
> -	size_t offset;
> -	u64 tsc;
> +	long hdr_offset;	/* event header offset */
> +	long payload_offset;	/* event payload offset */
> +	u64 tsc;	/* full 64-bits timestamp value */
>  	u32 data_size;
> -	u16 chID; /* channel ID, const */
> +	u16 chID;	/* channel ID, const */
>  	u16 eID;
>  };
>  
> +struct ltt_relay_iter {
> +	struct ltt_relay_cpu_iter iter_cpu[NR_CPUS];
> +	struct ltt_channel_struct *ltt_channel;
> +	loff_t pos;
> +	int cpu;
> +	int nr_refs;
> +};
> +
> +static int is_subbuffer_offset_end(struct ltt_relay_cpu_iter *citer,
> +				   long offset)
> +{
> +	long sub_offset = SUBBUF_OFFSET(offset, citer->buf->chan);
> +
> +	return (sub_offset + citer->header->lost_size
> +			>= citer->buf->chan->subbuf_size);
> +}
> +
>  static u64 calculate_tsc(u64 pre_tsc, u64 read_tsc, unsigned int rflags)
>  {
>  	u64 new_tsc = read_tsc;
> @@ -80,124 +103,158 @@ static u64 calculate_tsc(u64 pre_tsc, u6
>  	return new_tsc;
>  }
>  
> -static inline size_t calculate_offset(size_t offset, u16 chID, u16 eID)
> +/*
> + * calculate payload offset */
> +static inline long calculate_payload_offset(long offset, u16 chID, u16 eID)
>  {
>  	const char *fmt;
>  
>  	if (!ltt_get_alignment())
>  		return offset;
>  
> -	fmt = marker_get_fmt_form_id(chID, eID);
> +	fmt = marker_get_fmt_from_id(chID, eID);
>  	BUG_ON(!fmt);
>  
>  	return offset + ltt_fmt_largest_align(offset, fmt);
>  }
>  
> -static void update_new_event(struct ltt_relay_cpu_iter *citer)
> +static void update_new_event(struct ltt_relay_cpu_iter *citer, long hdr_offset)
>  {
>  	u64 read_tsc;
>  	unsigned int rflags;
> +	long tmp_offset;
> +
> +	WARN_ON_ONCE(hdr_offset != citer->hdr_offset);
>  
> -	citer->offset = ltt_read_event_header(citer->buf, citer->offset,
> +	tmp_offset = ltt_read_event_header(citer->buf, hdr_offset,
>  			&read_tsc, &citer->data_size, &citer->eID, &rflags);
> +	citer->payload_offset = calculate_payload_offset(tmp_offset,
> +			citer->chID, citer->eID);
>  
> -	citer->offset = calculate_offset(citer->offset, citer->chID,
> -			citer->eID);
>  	citer->tsc = calculate_tsc(citer->tsc, read_tsc, rflags);
>  }
>  
> -static void update_event_size(struct ltt_relay_cpu_iter *citer)
> +static void update_event_size(struct ltt_relay_cpu_iter *citer, long hdr_offset)
>  {
>  	char output[1];
>  	const char *fmt;
> +	size_t data_size;
>  
>  	if (citer->data_size != INT_MAX)
>  		return;
>  
> -	fmt = marker_get_fmt_form_id(citer->chID, citer->eID);
> +	fmt = marker_get_fmt_from_id(citer->chID, citer->eID);
>  	BUG_ON(!fmt);
> -	ltt_serialize_printf(citer->buf, citer->offset, &citer->data_size,
> -			output, 0, fmt);
> +	ltt_serialize_printf(citer->buf, citer->payload_offset,
> +			     &data_size, output, 0, fmt);
> +	citer->data_size = data_size;
>  }
>  
> -/* Is @value in the region [@left, @right) in a circular buffer */
> -static int is_in_region(size_t value, size_t left, size_t right, size_t len)
> +static void update_cpu_iter(struct ltt_relay_cpu_iter *citer, long hdr_offset)
>  {
> -	if (right < left)
> -		right += len;
> -	if (value < left)
> -		value += len;
> -	return value < right;
> +	if (unlikely((!citer->sb_ref)
> +		     || is_subbuffer_offset_end(citer, hdr_offset))) {
> +		citer->header = NULL;
> +		return;
> +	}
> +	update_new_event(citer, hdr_offset);
> +	update_event_size(citer, hdr_offset);
>  }
>  
> -static void update_cpu_iter(struct ltt_relay_cpu_iter *citer, size_t old_offset)
> +/*
> + * returns 0 if we get a subbuffer reference.
> + * else, the buffer has not available data, try again later.
> + */
> +static int subbuffer_start(struct ltt_relay_cpu_iter *citer, long *offset)
>  {
> -	size_t len = citer->buf->chan->alloc_size;
> -	size_t eof_offset = BUFFER_OFFSET(citer->eof_offset, citer->buf->chan);
> +	int ret;
> +	struct ltt_relay_iter *iter = citer->iter;
> +	struct ltt_channel_buf_access_ops *buf_access_ops;
>  
> -	if (is_in_region(eof_offset, old_offset, citer->offset, len)) {
> -		citer->header = NULL;
> -	} else {
> -		update_new_event(citer);
> -		update_event_size(citer);
> +	buf_access_ops = iter->ltt_channel->buf_access_ops;
>  
> -		if (is_in_region(eof_offset, old_offset,
> -				citer->offset + citer->data_size, len))
> -			citer->header = NULL;
> +	ret = buf_access_ops->get_subbuf(citer->buf, offset);
> +	if (!ret) {
> +		citer->header = ltt_relay_read_offset_address(citer->buf,
> +							      *offset);
> +		citer->hdr_offset = (*offset) + ltt_subbuffer_header_size();
> +		citer->tsc = citer->header->cycle_count_begin;
> +		iter->nr_refs++;
> +		citer->sb_ref = 1;
> +		return 0;
> +	} else {
> +		if (buf_access_ops->is_finalized(citer->buf)) {
> +			/*
> +			 * Currently, kill the iterator for
> +			 * this cpu buffer (TODO resume support)
> +			 */
> +			buf_access_ops->release(citer->buf);
> +			citer->buf = NULL;
> +			return -ENODATA;
> +		}
> +		return -EAGAIN;
>  	}
>  }
>  
> -static void start_new_subbuffer(struct ltt_relay_cpu_iter *citer, size_t offset)
> +static void subbuffer_stop(struct ltt_relay_cpu_iter *citer,
> +			   long offset)
>  {
> -	int index = SUBBUF_INDEX(offset, citer->buf->chan);
> -	size_t head_offset = index << citer->buf->chan->subbuf_size_order;
> +	int ret;
> +	struct ltt_relay_iter *iter = citer->iter;
>  
> -	citer->header = ltt_relay_offset_address(citer->buf, head_offset);
> -	citer->offset = head_offset + ltt_subbuffer_header_size();
> -	citer->tsc = citer->header->cycle_count_begin;
> +	WARN_ON_ONCE(!citer->sb_ref);
> +	ret = iter->ltt_channel->buf_access_ops->put_subbuf(
> +			citer->buf, offset);
> +	WARN_ON_ONCE(ret);
> +	citer->sb_ref = 0;
> +	iter->nr_refs--;
>  }
>  
>  static void ltt_relay_advance_cpu_iter(struct ltt_relay_cpu_iter *citer)
>  {
> -	size_t old_offset = citer->offset, new_offset = citer->offset;
> -	size_t sub_offset = SUBBUF_OFFSET(old_offset, citer->buf->chan);
> -
> -	new_offset += citer->data_size;
> +	long old_offset = citer->payload_offset;
> +	long new_offset = citer->payload_offset;
> +	int ret;
>  
>  	/* find that whether we read all data in this subbuffer */
> -	if (sub_offset + citer->data_size + citer->header->lost_size
> -			>= citer->buf->chan->subbuf_size) {
> -		new_offset += citer->header->lost_size;
> -		start_new_subbuffer(citer, new_offset);
> +	if (unlikely(is_subbuffer_offset_end(citer,
> +					     old_offset + citer->data_size))) {
> +		DEBUGP(KERN_DEBUG "LTT ASCII stop cpu %d offset %lX\n",
> +			citer->buf->cpu, citer->read_sb_offset);
> +		subbuffer_stop(citer, citer->read_sb_offset);
> +		for (;;) {
> +			ret = subbuffer_start(citer, &citer->read_sb_offset);
> +			DEBUGP(KERN_DEBUG
> +				"LTT ASCII start cpu %d ret %d offset %lX\n",
> +				citer->buf->cpu, ret, citer->read_sb_offset);
> +			if (!ret || ret == -ENODATA) {
> +				break;	/* got data, or finalized */
> +			} else {	/* -EAGAIN */
> +				if (signal_pending(current))
> +					break;
> +				schedule_timeout_interruptible(1);
> +			}
> +		}
>  	} else {
> -		citer->offset = new_offset + ltt_align(new_offset,
> +		new_offset += citer->data_size;
> +		citer->hdr_offset = new_offset + ltt_align(new_offset,
>  				sizeof(struct ltt_event_header));
> +		DEBUGP(KERN_DEBUG
> +			"LTT ASCII old_offset %lX new_offset %lX cpu %d\n",
> +			old_offset, new_offset, citer->buf->cpu);
>  	}
>  
> -	update_cpu_iter(citer, old_offset);
> -}
> -
> -static void ltt_relay_reset_cpu_iter(struct ltt_relay_cpu_iter *citer)
> -{
> -	start_new_subbuffer(citer, citer->start_offset);
> -	update_cpu_iter(citer, citer->start_offset);
> +	update_cpu_iter(citer, citer->hdr_offset);
>  }
>  
>  static int cpu_iter_eof(struct ltt_relay_cpu_iter *citer)
>  {
> -	return !citer->header;
> +	return !citer->sb_ref;
>  }
>  
> -struct ltt_relay_iter {
> -	struct ltt_relay_cpu_iter iter_cpu[NR_CPUS];
> -	struct ltt_channel_struct *ltt_channel;
> -	loff_t pos;
> -	int cpu;
> -};
> -
>  static int ltt_relay_iter_eof(struct ltt_relay_iter *iter)
>  {
> -	return iter->cpu < 0;
> +	return iter->nr_refs == 0;
>  }
>  
>  static void ltt_relay_advance_iter(struct ltt_relay_iter *iter)
> @@ -213,10 +270,10 @@ static void ltt_relay_advance_iter(struc
>  	for_each_possible_cpu(i) {
>  		curr = &iter->iter_cpu[i];
>  
> -		if (!curr->buf)
> +		if (!curr->buf || !curr->header)
>  			continue;
>  
> -		if (cpu_iter_eof(curr) || cpu_iter_empty(curr))
> +		if (cpu_iter_eof(curr))
>  			continue;
>  
>  		if (!min || curr->tsc < min->tsc) {
> @@ -228,70 +285,31 @@ static void ltt_relay_advance_iter(struc
>  	/* update cpu_iter for next ltt_relay_advance_iter() */
>  	if (min)
>  		ltt_relay_advance_cpu_iter(min);
> -
> -	/* increase pos */
> -	iter->pos++;
> -}
> -
> -static void ltt_relay_start_iter(struct ltt_relay_iter *iter)
> -{
> -	BUG_ON(iter->pos != -1);
> -
> -	/* TODO: use min-heep for 4096CPUS */
> -	ltt_relay_advance_iter(iter);
>  }
>  
>  static void *ascii_next(struct seq_file *m, void *v, loff_t *ppos)
>  {
>  	struct ltt_relay_iter *iter = m->private;
>  
> -	BUG_ON(iter->pos != *ppos || v != iter);
> +	WARN_ON_ONCE(!iter->nr_refs);
> +	BUG_ON(v != iter);
>  
>  	ltt_relay_advance_iter(iter);
> -	(*ppos)++;
> -
> -	return ltt_relay_iter_eof(iter) ? NULL : iter;
> -}
> -
> -/*
> - * Restart iterator at the beginning of the current subbuffer.
> - */
> -static void ltt_relay_reset_iter(struct ltt_relay_iter *iter)
> -{
> -	int i;
> -
> -	for_each_possible_cpu(i) {
> -		if (iter->iter_cpu[i].buf)
> -			ltt_relay_reset_cpu_iter(&iter->iter_cpu[i]);
> -	}
> -
> -	ltt_relay_start_iter(iter);
> +	return (ltt_relay_iter_eof(iter) || signal_pending(current))
> +		? NULL : iter;
>  }
>  
>  static void *ascii_start(struct seq_file *m, loff_t *ppos)
>  {
> -	loff_t pos = *ppos;
>  	struct ltt_relay_iter *iter = m->private;
>  
> -
> -	if (pos != iter->pos) {
> -		/* restart when read backward */
> -		if (pos < iter->pos)
> -			iter->pos = -1;
> -
> -		if (iter->pos < 0)
> -			ltt_relay_reset_iter(iter);
> -
> -		while (!ltt_relay_iter_eof(iter) && iter->pos < pos)
> -			ltt_relay_advance_iter(iter);
> -	}
> -
> -	return ltt_relay_iter_eof(iter) ? NULL : iter;
> +	ltt_relay_advance_iter(iter);
> +	return (ltt_relay_iter_eof(iter) || signal_pending(current))
> +		? NULL : iter;
>  }
>  
>  static void ascii_stop(struct seq_file *m, void *v)
>  {
> -	/* do nothing */
>  }
>  
>  static int seq_serialize(struct seq_file *m, struct rchan_buf *buf,
> @@ -315,22 +333,37 @@ static int seq_serialize(struct seq_file
>  static int ascii_show(struct seq_file *m, void *v)
>  {
>  	struct ltt_relay_iter *iter = v;
> -	struct ltt_relay_cpu_iter *citer = &iter->iter_cpu[iter->cpu];
> +	struct ltt_relay_cpu_iter *citer;
>  	const char *name;
>  	const char *fmt;
> -	unsigned long long tsc = citer->tsc;
> -	size_t *data_size;
> -	data_size = citer->data_size == INT_MAX ? &citer->data_size : NULL;
> +	unsigned long long tsc;
> +	size_t data_size;
> +
> +	if (iter->cpu == -1)
> +		return 0;
>  
> -	name = marker_get_name_form_id(citer->chID, citer->eID);
> -	fmt = marker_get_fmt_form_id(citer->chID, citer->eID);
> +	citer = &iter->iter_cpu[iter->cpu];
> +	WARN_ON_ONCE(!citer->sb_ref);
> +	/*
> +	 * Nothing to show, we are at the end of the last subbuffer currently
> +	 * having data.
> +	 */
> +	if (!citer->header)
> +		return 0;
> +
> +	tsc = citer->tsc;
> +	name = marker_get_name_from_id(citer->chID, citer->eID);
> +	fmt = marker_get_fmt_from_id(citer->chID, citer->eID);
>  
>  	if (!name || !fmt)
>  		return 0;
>  
> -	seq_printf(m, "%16.16s: %2d %20.20llu ", name, iter->cpu, tsc);
> -	seq_serialize(m, citer->buf, citer->offset, fmt, data_size);
> +	seq_printf(m, "event:%16.16s: cpu:%2d time:%20.20llu ",
> +		   name, iter->cpu, tsc);
> +	seq_serialize(m, citer->buf, citer->payload_offset, fmt, &data_size);
>  	seq_puts(m, "\n");
> +	if (citer->data_size == INT_MAX)
> +		citer->data_size = data_size;
>  
>  	return 0;
>  }
> @@ -342,47 +375,88 @@ static struct seq_operations ascii_seq_o
>  	.show		= ascii_show,
>  };
>  
> -#define get_value(ltt_chan, value, cpu)			\
> -	ltt_chan->buf_access_ops->get_##value(ltt_chan->buf, cpu)
> -
>  /* FIXME : cpu hotplug support */
> -static int ltt_relay_iter_get_channel(struct ltt_relay_iter *iter,
> +static int ltt_relay_iter_open_channel(struct ltt_relay_iter *iter,
>  		struct ltt_channel_struct *ltt_channel)
>  {
> -	int i;
> +	int i, ret;
>  	struct rchan *chan = ltt_channel->trans_channel_data;
>  	u16 chID = ltt_channels_get_index_from_name(ltt_channel->channel_name);
> +	struct ltt_channel_buf_access_ops *buf_access_ops;
> +
> +	buf_access_ops = ltt_channel->buf_access_ops;
>  
>  	/* we don't need lock relay_channels_mutex */
>  	for_each_possible_cpu(i) {
> -		iter->iter_cpu[i].buf = chan->buf[i];
> -		if (iter->iter_cpu[i].buf)
> -			ltt_channel->buf_access_ops->open(ltt_channel->buf, i);
> -		iter->iter_cpu[i].chID = chID;
> -	}
> -/*
> -	for_each_possible_cpu(i) {
> -		if (!iter->iter_cpu[i].buf)
> +		struct ltt_relay_cpu_iter *citer = &iter->iter_cpu[i];
> +
> +		citer->buf = chan->buf[i];
> +		if (!citer->buf)
>  			continue;
> -		iter->iter_cpu[i].start_offset = SUBBUF_TRUNC(
> -				get_value(ltt_channel, consumed, i),
> -				iter->iter_cpu[i].buf->chan);
> -		iter->iter_cpu[i].eof_offset =
> -				get_value(ltt_channel, offset, i);
> +
> +		citer->iter = iter;	/* easy lazy parent info */
> +		citer->chID = chID;
> +
> +		ret = buf_access_ops->open(citer->buf);
> +		if (ret) {
> +			/* Failed to open a percpu buffer, close everything. */
> +			citer->buf = NULL;
> +			goto error;
> +		}
> +
> +		for (;;) {
> +			ret = subbuffer_start(citer,
> +					      &citer->read_sb_offset);
> +			DEBUGP(KERN_DEBUG
> +				"LTT ASCII open start "
> +				"cpu %d ret %d offset %lX\n",
> +				citer->buf->cpu, ret, citer->read_sb_offset);
> +			if (!ret || ret == -ENODATA) {
> +				break;	/* got data, or finalized */
> +			} else {	/* -EAGAIN */
> +				if (signal_pending(current))
> +					break;
> +				schedule_timeout_interruptible(1);
> +			}
> +		}
> +		update_cpu_iter(citer, citer->hdr_offset);
>  	}
> -*/
> +	if (!iter->nr_refs)
> +		return -ENODATA; /* no data available */
>  	return 0;
> +
> +error:
> +	for_each_possible_cpu(i) {
> +		struct ltt_relay_cpu_iter *citer = &iter->iter_cpu[i];
> +
> +		if (citer->buf)
> +			buf_access_ops->release(citer->buf);
> +	}
> +	return ret;
>  }
>  
> -static int ltt_relay_iter_put_channel(struct ltt_relay_iter *iter)
> +static int ltt_relay_iter_release_channel(struct ltt_relay_iter *iter)
>  {
>  	int i;
> +	struct ltt_channel_buf_access_ops *buf_access_ops;
> +
> +	buf_access_ops = iter->ltt_channel->buf_access_ops;
>  
>  	for_each_possible_cpu(i) {
> -		if (iter->iter_cpu[i].buf)
> -			ltt_channel->buf_access_ops->release(ltt_channel->buf,
> -							     i);
> +		struct ltt_relay_cpu_iter *citer = &iter->iter_cpu[i];
> +
> +		if (citer->sb_ref) {
> +			WARN_ON_ONCE(!citer->buf);
> +			DEBUGP(KERN_DEBUG
> +				"LTT ASCII release stop cpu %d offset %lX\n",
> +				citer->buf->cpu, citer->read_sb_offset);
> +			subbuffer_stop(&iter->iter_cpu[i],
> +			       citer->read_sb_offset);
> +		}
> +		if (citer->buf)
> +			buf_access_ops->release(citer->buf);
>  	}
> +	WARN_ON_ONCE(iter->nr_refs);
>  	return 0;
>  }
>  
> @@ -390,30 +464,34 @@ static int ltt_relay_ascii_open(struct i
>  {
>  	int ret;
>  	struct ltt_channel_struct *ltt_channel = inode->i_private;
> -	struct ltt_relay_iter *iter = kmalloc(sizeof(*iter), GFP_KERNEL);
> +	struct ltt_relay_iter *iter = kzalloc(sizeof(*iter), GFP_KERNEL);
>  	if (!iter)
>  		return -ENOMEM;
>  
>  	iter->ltt_channel = ltt_channel;
> -	iter->pos = -1;
> -	ltt_relay_iter_get_channel(iter, ltt_channel);
> +	ret = ltt_relay_iter_open_channel(iter, ltt_channel);
> +	if (ret)
> +		goto error_free_alloc;
>  
>  	ret = seq_open(file, &ascii_seq_ops);
> -	if (ret) {
> -		ltt_relay_iter_put_channel(iter);
> -		kfree(iter);
> -		return ret;
> -	}
> +	if (ret)
> +		goto error_release_channel;
>  	((struct seq_file *)file->private_data)->private = iter;
> -
>  	return 0;
> +
> +error_release_channel:
> +	ltt_relay_iter_release_channel(iter);
> +error_free_alloc:
> +	kfree(iter);
> +	return ret;
>  }
>  
>  static int ltt_relay_ascii_release(struct inode *inode, struct file *file)
>  {
>  	struct seq_file *seq = file->private_data;
>  	struct ltt_relay_iter *iter = seq->private;
> -	ltt_relay_iter_put_channel(iter);
> +
> +	ltt_relay_iter_release_channel(iter);
>  	kfree(iter);
>  	return 0;
>  }
> @@ -423,6 +501,7 @@ static struct file_operations ltt_ascii_
>  	.read = seq_read,
>  	.open = ltt_relay_ascii_open,
>  	.release = ltt_relay_ascii_release,
> +	.llseek = no_llseek,
>  	.owner = THIS_MODULE,
>  };
>  
> @@ -433,10 +512,8 @@ struct dentry *ltt_ascii_create(struct l
>  			S_IRUSR | S_IRGRP, trace->dentry.ascii_root,
>  			ltt_channel,
>  			&ltt_ascii_fops);
> -
>  	if (entry)
> -		ltt_relay_get_chan(ltt_channel->trans_channel_data);
> -
> +		entry->d_inode->i_private = ltt_channel;
>  	return entry;
>  }
>  EXPORT_SYMBOL_GPL(ltt_ascii_create);
> @@ -444,10 +521,8 @@ EXPORT_SYMBOL_GPL(ltt_ascii_create);
>  void ltt_ascii_remove(struct ltt_channel_struct *ltt_channel,
>  		struct dentry *ascii)
>  {
> -	if (ascii) {
> +	if (ascii)
>  		debugfs_remove(ascii);
> -		ltt_relay_put_chan(ltt_channel->trans_channel_data);
> -	}
>  }
>  EXPORT_SYMBOL_GPL(ltt_ascii_remove);
>  
> @@ -470,6 +545,7 @@ EXPORT_SYMBOL_GPL(ltt_ascii_remove_dir);
>  static __init int ltt_ascii_init(void)
>  {
>  	ltt_ascii_dir_dentry = debugfs_create_dir(LTT_ASCII, get_ltt_root());
> +	put_ltt_root();
>  
>  	return ltt_ascii_dir_dentry ? 0 : -EFAULT;
>  }
> Index: linux-2.6-lttng/include/linux/ltt-relay.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/ltt-relay.h	2009-07-20 09:27:28.000000000 -0400
> +++ linux-2.6-lttng/include/linux/ltt-relay.h	2009-07-20 09:27:28.000000000 -0400
> @@ -60,6 +60,7 @@ struct rchan_buf {
>  	unsigned int page_count;	/* number of current buffer pages */
>  	unsigned int cpu;		/* this buf's cpu */
>  	unsigned int random_access;	/* buffer performs random page access */
> +	struct dentry *ascii_dentry;	/* Text output dentry */
>  } ____cacheline_aligned;
>  
>  /*
> @@ -167,6 +168,8 @@ extern struct page *ltt_relay_read_get_p
>   */
>  extern void *ltt_relay_offset_address(struct rchan_buf *buf,
>  	size_t offset);
> +extern void *ltt_relay_read_offset_address(struct rchan_buf *buf,
> +	size_t offset);
>  
>  #ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>  static __inline__ void ltt_relay_do_copy(void *dest, const void *src, size_t len)
> Index: linux-2.6-lttng/ltt/ltt-relay-alloc.c
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/ltt-relay-alloc.c	2009-07-20 09:27:28.000000000 -0400
> +++ linux-2.6-lttng/ltt/ltt-relay-alloc.c	2009-07-20 09:27:28.000000000 -0400
> @@ -631,9 +631,11 @@ int ltt_relay_read_cstr(struct rchan_buf
>  		strpagelen = strnlen(str, pagelen);
>  		if (len) {
>  			pagecpy = min_t(size_t, len, strpagelen);
> -			memcpy(dest, str, pagecpy);
> +			if (dest) {
> +				memcpy(dest, str, pagecpy);
> +				dest += pagecpy;
> +			}
>  			len -= pagecpy;
> -			dest += pagecpy;
>  		}
>  		offset += strpagelen;
>  		index = (offset & (buf->chan->subbuf_size - 1)) >> PAGE_SHIFT;
> @@ -645,7 +647,7 @@ int ltt_relay_read_cstr(struct rchan_buf
>  		 */
>  		WARN_ON(offset >= buf->chan->alloc_size);
>  	}
> -	if (len)
> +	if (dest && len)
>  		((char *)dest)[0] = 0;
>  	return offset - orig_offset;
>  }
> Index: linux-2.6-lttng/include/linux/ltt-channels.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/ltt-channels.h	2009-07-20 09:27:26.000000000 -0400
> +++ linux-2.6-lttng/include/linux/ltt-channels.h	2009-07-20 09:27:28.000000000 -0400
> @@ -20,7 +20,6 @@ struct rchan_buf;
>  struct ltt_channel_struct {
>  	/* First 32 bytes cache-hot cacheline */
>  	struct ltt_trace_struct	*trace;
> -	void *buf;
>  	void *trans_channel_data;
>  	int overwrite:1;
>  	int active:1;
> @@ -53,6 +52,7 @@ struct ltt_channel_buf_access_ops {
>  	int (*release)(struct rchan_buf *buf);
>  	int (*get_subbuf)(struct rchan_buf *buf, unsigned long *consumed);
>  	int (*put_subbuf)(struct rchan_buf *buf, unsigned long consumed);
> +	int (*is_finalized)(struct rchan_buf *buf);
>  	unsigned long (*get_n_subbufs)(struct rchan_buf *buf);
>  	unsigned long (*get_subbuf_size)(struct rchan_buf *buf);
>  	void (*start_switch_timer)(struct ltt_channel_struct *ltt_channel);
> Index: linux-2.6-lttng/ltt/ltt-relay-irqoff.c
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/ltt-relay-irqoff.c	2009-07-20 09:27:28.000000000 -0400
> +++ linux-2.6-lttng/ltt/ltt-relay-irqoff.c	2009-07-20 09:27:28.000000000 -0400
> @@ -136,6 +136,8 @@ static struct dentry *ltt_create_buf_fil
>  			&ltt_file_operations);
>  	if (!dentry)
>  		goto error;
> +	if (buf->cpu == 0)
> +		buf->ascii_dentry = ltt_ascii_create(ltt_chan->trace, ltt_chan);
>  	return dentry;
>  error:
>  	ltt_relay_destroy_buffer(ltt_chan, buf->cpu);
> @@ -147,6 +149,7 @@ static int ltt_remove_buf_file_callback(
>  	struct rchan_buf *buf = dentry->d_inode->i_private;
>  	struct ltt_channel_struct *ltt_chan = buf->chan->private_data;
>  
> +	ltt_ascii_remove(ltt_chan, buf->ascii_dentry);
>  	debugfs_remove(dentry);
>  	ltt_relay_destroy_buffer(ltt_chan, buf->cpu);
>  
> @@ -213,6 +216,13 @@ static int _ltt_release(struct rchan_buf
>  	return 0;
>  }
>  
> +static int is_finalized(struct rchan_buf *buf)
> +{
> +	struct ltt_channel_buf_struct *ltt_buf = buf->chan_private;
> +
> +	return ltt_buf->finalized;
> +}
> +
>  /*
>   * Promote compiler barrier to a smp_mb().
>   * For the specific LTTng case, this IPI call should be removed if the
> @@ -443,6 +453,7 @@ static struct ltt_channel_buf_access_ops
>  	.get_consumed = get_consumed,
>  	.get_subbuf = get_subbuf,
>  	.put_subbuf = put_subbuf,
> +	.is_finalized = is_finalized,
>  	.get_n_subbufs = get_n_subbufs,
>  	.get_subbuf_size = get_subbuf_size,
>  	.open = _ltt_open,
> @@ -828,6 +839,7 @@ static void ltt_relay_print_buffer_error
>  
>  static void ltt_relay_remove_dirs(struct ltt_trace_struct *trace)
>  {
> +	ltt_ascii_remove_dir(trace);
>  	debugfs_remove(trace->dentry.trace_root);
>  }
>  
> @@ -974,6 +986,7 @@ end:
>  static int ltt_relay_create_dirs(struct ltt_trace_struct *new_trace)
>  {
>  	struct dentry *ltt_root_dentry;
> +	int ret;
>  
>  	ltt_root_dentry = get_ltt_root();
>  	if (!ltt_root_dentry)
> @@ -987,6 +1000,10 @@ static int ltt_relay_create_dirs(struct 
>  				new_trace->trace_name);
>  		return EEXIST;
>  	}
> +	ret = ltt_ascii_create_dir(new_trace);
> +	if (ret)
> +		printk(KERN_WARNING "LTT : Unable to create ascii output file "
> +				    "for trace %s\n", new_trace->trace_name);
>  
>  	new_trace->callbacks.create_buf_file = ltt_create_buf_file_callback;
>  	new_trace->callbacks.remove_buf_file = ltt_remove_buf_file_callback;
> Index: linux-2.6-lttng/ltt/ltt-relay-lockless.c
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/ltt-relay-lockless.c	2009-07-20 09:27:28.000000000 -0400
> +++ linux-2.6-lttng/ltt/ltt-relay-lockless.c	2009-07-20 09:27:28.000000000 -0400
> @@ -137,6 +137,8 @@ static struct dentry *ltt_create_buf_fil
>  			&ltt_file_operations);
>  	if (!dentry)
>  		goto error;
> +	if (buf->cpu == 0)
> +		buf->ascii_dentry = ltt_ascii_create(ltt_chan->trace, ltt_chan);
>  	return dentry;
>  error:
>  	ltt_relay_destroy_buffer(ltt_chan, buf->cpu);
> @@ -148,6 +150,7 @@ static int ltt_remove_buf_file_callback(
>  	struct rchan_buf *buf = dentry->d_inode->i_private;
>  	struct ltt_channel_struct *ltt_chan = buf->chan->private_data;
>  
> +	ltt_ascii_remove(ltt_chan, buf->ascii_dentry);
>  	debugfs_remove(dentry);
>  	ltt_relay_destroy_buffer(ltt_chan, buf->cpu);
>  
> @@ -214,6 +217,13 @@ static int _ltt_release(struct rchan_buf
>  	return 0;
>  }
>  
> +static int is_finalized(struct rchan_buf *buf)
> +{
> +	struct ltt_channel_buf_struct *ltt_buf = buf->chan_private;
> +
> +	return ltt_buf->finalized;
> +}
> +
>  /*
>   * Promote compiler barrier to a smp_mb().
>   * For the specific LTTng case, this IPI call should be removed if the
> @@ -444,6 +454,7 @@ static struct ltt_channel_buf_access_ops
>  	.get_consumed = get_consumed,
>  	.get_subbuf = get_subbuf,
>  	.put_subbuf = put_subbuf,
> +	.is_finalized = is_finalized,
>  	.get_n_subbufs = get_n_subbufs,
>  	.get_subbuf_size = get_subbuf_size,
>  	.open = _ltt_open,
> @@ -831,6 +842,7 @@ static void ltt_relay_print_buffer_error
>  
>  static void ltt_relay_remove_dirs(struct ltt_trace_struct *trace)
>  {
> +	ltt_ascii_remove_dir(trace);
>  	debugfs_remove(trace->dentry.trace_root);
>  }
>  
> @@ -979,6 +991,7 @@ end:
>  static int ltt_relay_create_dirs(struct ltt_trace_struct *new_trace)
>  {
>  	struct dentry *ltt_root_dentry;
> +	int ret;
>  
>  	ltt_root_dentry = get_ltt_root();
>  	if (!ltt_root_dentry)
> @@ -992,6 +1005,10 @@ static int ltt_relay_create_dirs(struct 
>  				new_trace->trace_name);
>  		return EEXIST;
>  	}
> +	ret = ltt_ascii_create_dir(new_trace);
> +	if (ret)
> +		printk(KERN_WARNING "LTT : Unable to create ascii output file "
> +				    "for trace %s\n", new_trace->trace_name);
>  
>  	new_trace->callbacks.create_buf_file = ltt_create_buf_file_callback;
>  	new_trace->callbacks.remove_buf_file = ltt_remove_buf_file_callback;
> Index: linux-2.6-lttng/ltt/ltt-relay-locked.c
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/ltt-relay-locked.c	2009-07-20 09:27:28.000000000 -0400
> +++ linux-2.6-lttng/ltt/ltt-relay-locked.c	2009-07-20 09:27:28.000000000 -0400
> @@ -137,6 +137,8 @@ static struct dentry *ltt_create_buf_fil
>  			&ltt_file_operations);
>  	if (!dentry)
>  		goto error;
> +	if (buf->cpu == 0)
> +		buf->ascii_dentry = ltt_ascii_create(ltt_chan->trace, ltt_chan);
>  	return dentry;
>  error:
>  	ltt_relay_destroy_buffer(ltt_chan, buf->cpu);
> @@ -148,6 +150,7 @@ static int ltt_remove_buf_file_callback(
>  	struct rchan_buf *buf = dentry->d_inode->i_private;
>  	struct ltt_channel_struct *ltt_chan = buf->chan->private_data;
>  
> +	ltt_ascii_remove(ltt_chan, buf->ascii_dentry);
>  	debugfs_remove(dentry);
>  	ltt_relay_destroy_buffer(ltt_chan, buf->cpu);
>  
> @@ -214,6 +217,13 @@ static int _ltt_release(struct rchan_buf
>  	return 0;
>  }
>  
> +static int is_finalized(struct rchan_buf *buf)
> +{
> +	struct ltt_channel_buf_struct *ltt_buf = buf->chan_private;
> +
> +	return ltt_buf->finalized;
> +}
> +
>  static int get_subbuf(struct rchan_buf *buf, unsigned long *consumed)
>  {
>  	struct ltt_channel_struct *ltt_channel =
> @@ -396,6 +406,7 @@ static struct ltt_channel_buf_access_ops
>  	.get_consumed = get_consumed,
>  	.get_subbuf = get_subbuf,
>  	.put_subbuf = put_subbuf,
> +	.is_finalized = is_finalized,
>  	.get_n_subbufs = get_n_subbufs,
>  	.get_subbuf_size = get_subbuf_size,
>  	.open = _ltt_open,
> @@ -783,6 +794,7 @@ static void ltt_relay_print_buffer_error
>  
>  static void ltt_relay_remove_dirs(struct ltt_trace_struct *trace)
>  {
> +	ltt_ascii_remove_dir(trace);
>  	debugfs_remove(trace->dentry.trace_root);
>  }
>  
> @@ -918,6 +930,7 @@ end:
>  static int ltt_relay_create_dirs(struct ltt_trace_struct *new_trace)
>  {
>  	struct dentry *ltt_root_dentry;
> +	int ret;
>  
>  	ltt_root_dentry = get_ltt_root();
>  	if (!ltt_root_dentry)
> @@ -931,6 +944,10 @@ static int ltt_relay_create_dirs(struct 
>  				new_trace->trace_name);
>  		return EEXIST;
>  	}
> +	ret = ltt_ascii_create_dir(new_trace);
> +	if (ret)
> +		printk(KERN_WARNING "LTT : Unable to create ascii output file "
> +				    "for trace %s\n", new_trace->trace_name);
>  
>  	new_trace->callbacks.create_buf_file = ltt_create_buf_file_callback;
>  	new_trace->callbacks.remove_buf_file = ltt_remove_buf_file_callback;
> Index: linux-2.6-lttng/kernel/marker.c
> ===================================================================
> --- linux-2.6-lttng.orig/kernel/marker.c	2009-07-20 09:27:27.000000000 -0400
> +++ linux-2.6-lttng/kernel/marker.c	2009-07-20 09:27:28.000000000 -0400
> @@ -1107,19 +1107,19 @@ static struct marker_entry *get_entry_fr
>  }
>  
>  /* must call when ids/marker_entry are kept alive */
> -const char *marker_get_name_form_id(u16 channel_id, u16 event_id)
> +const char *marker_get_name_from_id(u16 channel_id, u16 event_id)
>  {
>  	struct marker_entry *e = get_entry_from_id(channel_id, event_id);
>  	return e ? e->name : NULL;
>  }
> -EXPORT_SYMBOL_GPL(marker_get_name_form_id);
> +EXPORT_SYMBOL_GPL(marker_get_name_from_id);
>  
> -const char *marker_get_fmt_form_id(u16 channel_id, u16 event_id)
> +const char *marker_get_fmt_from_id(u16 channel_id, u16 event_id)
>  {
>  	struct marker_entry *e = get_entry_from_id(channel_id, event_id);
>  	return e ? e->format : NULL;
>  }
> -EXPORT_SYMBOL_GPL(marker_get_fmt_form_id);
> +EXPORT_SYMBOL_GPL(marker_get_fmt_from_id);
>  
>  /**
>   * markers_compact_event_ids - Compact markers event IDs and reassign channels
> Index: linux-2.6-lttng/include/linux/ltt-tracer.h
> ===================================================================
> --- linux-2.6-lttng.orig/include/linux/ltt-tracer.h	2009-07-20 09:27:27.000000000 -0400
> +++ linux-2.6-lttng/include/linux/ltt-tracer.h	2009-07-20 09:27:28.000000000 -0400
> @@ -654,6 +654,35 @@ extern void ltt_dump_marker_state(struct
>  void ltt_lock_traces(void);
>  void ltt_unlock_traces(void);
>  
> +#ifdef CONFIG_LTT_ASCII
> +extern int ltt_ascii_create_dir(struct ltt_trace_struct *new_trace);
> +extern void ltt_ascii_remove_dir(struct ltt_trace_struct *trace);
> +extern struct dentry *ltt_ascii_create(struct ltt_trace_struct *trace,
> +		struct ltt_channel_struct *ltt_channel);
> +extern void ltt_ascii_remove(struct ltt_channel_struct *ltt_channel,
> +		struct dentry *ascii);
> +#else
> +static inline int ltt_ascii_create_dir(struct ltt_trace_struct *new_trace)
> +{
> +	return 0;
> +}
> +
> +static inline void ltt_ascii_remove_dir(struct ltt_trace_struct *trace)
> +{
> +}
> +
> +static inline struct dentry *ltt_ascii_create(struct ltt_trace_struct *trace,
> +		struct ltt_channel_struct *ltt_channel)
> +{
> +	return NULL;
> +}
> +
> +static inline void ltt_ascii_remove(struct ltt_channel_struct *ltt_channel,
> +		struct dentry *ascii)
> +{
> +}
> +#endif
> +
>  extern void ltt_statedump_register_kprobes_dump(
>  	void (*callback)(void *call_data));
>  extern void ltt_statedump_unregister_kprobes_dump(
> Index: linux-2.6-lttng/Documentation/lttng.txt
> ===================================================================
> --- /dev/null	1970-01-01 00:00:00.000000000 +0000
> +++ linux-2.6-lttng/Documentation/lttng.txt	2009-07-20 09:27:28.000000000 -0400
> @@ -0,0 +1,35 @@
> +
> +Linux Text Toolkit Next Generation
> +Mathieu Desnoyers, July 2009
> +
> +This guide contains quickstart information on how to to use LTTng. It currently
> +only contains information about ascii text dump, but (TODO) we should bring the
> +LTTng manual here.
> +
> + * Quick and dirty startup ascii output script:
> +
> +#!/bin/sh
> +
> +LTT_DIR=/mnt/debugfs/ltt
> +ltt-armall
> +echo trace > ${LTT_DIR}/setup_trace
> +cd control/
> +cd trace/
> +echo relay > ${LTT_DIR}/control/trace/trans
> +cd channel/
> +for a in ${LTT_DIR}/control/trace/channel/*/switch_timer;
> +	do echo 100 > $a; done
> +#note: error for metadata channel for the following line is OK
> +#it is not permitted to set metadata channel in overwrite mode
> +for a in ${LTT_DIR}/control/trace/channel/*/overwrite;
> +	do echo 1 > $a; done
> +for a in ${LTT_DIR}/control/trace/channel/*/enable;
> +	do echo 1 > $a; done
> +cd ..
> +echo 1 > ${LTT_DIR}/control/trace/alloc
> +echo 1 > ${LTT_DIR}/control/trace/enabled
> +
> +To see the events for a given channel (e.g. kernel events):
> +
> +cat ${LTT_DIR}/ascii/trace/kernel
> +(hit CTRL-C to stop)
> Index: linux-2.6-lttng/ltt/Kconfig
> ===================================================================
> --- linux-2.6-lttng.orig/ltt/Kconfig	2009-07-20 09:27:54.000000000 -0400
> +++ linux-2.6-lttng/ltt/Kconfig	2009-07-20 09:29:10.000000000 -0400
> @@ -208,7 +208,8 @@ config LTT_FTRACE
>  	  surroundings of a problem has been identified in a prior trace.
>  
>  config LTT_ASCII
> -	bool "Linux Trace Toolkit Ascii Output (work in progress)"
> +	bool "Linux Trace Toolkit Ascii Output (EXPERIMENTAL)"
> +	depends on EXPERIMENTAL
>  	depends on LTT_TRACER
>  	depends on LTT_RELAY_ALLOC
>  	depends on LTT_SERIALIZE
>
>   
