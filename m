Return-Path: <linux-kernel-owner+w=401wt.eu-S1761383AbYFLNMS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761383AbYFLNMS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 09:12:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759311AbYFLNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 09:12:00 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35643 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757737AbYFLNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 09:11:59 -0400
Date: Thu, 12 Jun 2008 15:11:42 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCHv4] SGI UV: TLB shootdown using broadcast assist unit
Message-ID: <20080612131142.GA30686@elte.hu>
References: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1K6lqI-0006pX-JQ@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> +ENTRY(uv_bau_message_intr1)
> +	apicinterrupt 220,uv_bau_message_interrupt
> +END(uv_bau_message_intr1)

style: we try to add a single space after commas, to make it visually 
less crowded.

> @@ -162,6 +164,9 @@ void native_flush_tlb_others(const cpuma
>  	union smp_flush_state *f;
>  	cpumask_t cpumask = *cpumaskp;
>  
> +	if (is_uv_system() && uv_flush_tlb_others(&cpumask, mm, va))
> +		return;

since you basically hook into this function and replace it, wouldnt it 
make more sense instead to override the flush_tlb_others callback in 
paravirt_ops? That way common code is not affected.

> +char *status_table[] = {
> +	"IDLE",
> +	"ACTIVE",
> +	"DESTINATION TIMEOUT",
> +	"SOURCE TIMEOUT"
> +};
> +
> +DEFINE_PER_CPU(struct ptc_stats, ptcstats);
> +DEFINE_PER_CPU(struct bau_control, bau_control);

shouldnt these be static too?

> +	if (msp)
> +		msp->seen_by.bits = 0;
> +	uv_write_local_mmr(UVH_LB_BAU_INTD_SOFTWARE_ACKNOWLEDGE_ALIAS, dw);
> +	return;
> +}

return is not needed at the end of void functions. (there are many other 
similar incidents in the whole file)

> +	this_cpu_mask = (unsigned long)1 << cpu;

why not 1UL?

> +	sender = smp_processor_id();
> +	for (i = 0; i < (sizeof(struct bau_target_nodemask) * BITSPERBYTE); i++) {
> +	     i++) {
> +		if (!bau_node_isset(i, distribution))
> +			continue;
> +		bau_tablesp = uv_bau_table_bases[i];
> +		for (msg = bau_tablesp->va_queue_first, j = 0;
> +		     j < DESTINATION_PAYLOAD_QUEUE_SIZE; msg++, j++) {
> +			if ((msg->sending_cpu == sender) &&
> +			    (!msg->replied_to)) {
> +				msp = bau_tablesp->msg_statuses + j;
> +				printk(KERN_DEBUG
> +				"blade %d: address:%#lx %d of %d, not cpu(s): ",
> +				       i, msg->address,
> +				       msg->acknowledge_count,
> +				       msg->number_of_cpus);
> +				for (k = 0; k < msg->number_of_cpus;
> +				     k++) {
> +					if (!((long)1 << k & msp->
> +					      seen_by.bits)) {
> +						count++;
> +						printk("%d ", k);
> +					}
> +				}
> +				printk("\n");

why not split the iterator into a helper function? That would avoid all 
these line length artifacts as well. Also, decrease constant name 
length.

> +int uv_flush_send_and_wait(int cpu, int this_blade,
> +	struct bau_activation_descriptor *bau_desc, cpumask_t *cpumaskp)

'struct bau_activation_descriptor' is too long of a name (and that 
uglifies many prototypes) - why not use 'struct bau_desc'

> +	time1 = get_cycles();
> +	do {
> +		tries++;
> +		index = ((unsigned long)
> +			1 << UVH_LB_BAU_SB_ACTIVATION_CONTROL_PUSH_SHFT) | cpu;
> +		uv_write_local_mmr(UVH_LB_BAU_SB_ACTIVATION_CONTROL, index);
> +		completion_status = uv_wait_completion(bau_desc, mmr_offset,
> +					right_shift);
> +	} while (completion_status == FLUSH_RETRY);
> +	time2 = get_cycles();

is get_cycles() guaranteed to be stable on UV platforms? No cpufreq?

> +	pqp = __get_cpu_var(bau_control).va_queue_first;
> +	msg = __get_cpu_var(bau_control).bau_msg_head;
> +	while (msg->sw_ack_vector) {
> +		count++;
> +		fw = msg->sw_ack_vector;
> +		msg_slot = msg - pqp;
> +		sw_ack_slot = ffs(fw) - 1;
> +
> +		uv_bau_process_message(msg, msg_slot, sw_ack_slot);
> +
> +		msg++;
> +		if (msg > __get_cpu_var(bau_control).va_queue_last)
> +			msg = __get_cpu_var(bau_control).va_queue_first;
> +		__get_cpu_var(bau_control).bau_msg_head = msg;

many repetitive __get_cpu_var(bau_control) instances - put that into a 
helper variable instead, that makes it all much more readable.

> +static void uv_ptc_seq_stop(struct seq_file *file, void *data)
> +{
> +}

i think a NULL seq_stop will achieve a NOP. (not sure)

> +static const struct seq_operations uv_ptc_seq_ops = {
> +	.start	= uv_ptc_seq_start,
> +	.next	= uv_ptc_seq_next,
> +	.stop	= uv_ptc_seq_stop,
> +	.show	= uv_ptc_seq_show
> +};

small nit, we try to keep vertical alignment consistent across files, 
i.e.:

> +static const struct seq_operations uv_ptc_seq_ops = {
> +	.start		= uv_ptc_seq_start,
> +	.next		= uv_ptc_seq_next,
> +	.stop		= uv_ptc_seq_stop,
> +	.show		= uv_ptc_seq_show
> +};

> +	if (!proc_mkdir("sgi_uv", NULL))
> +		return -EINVAL;
> +
> +	proc_uv_ptc = create_proc_entry(UV_PTC_BASENAME, 0444, NULL);
> +	if (!proc_uv_ptc) {
> +		printk(KERN_ERR "unable to create %s proc entry\n",
> +		       UV_PTC_BASENAME);
> +		return -EINVAL;
> +	}

this failure branch will leak the sgi_uv directory.

> +	bau_tablesp =
> +	    kmalloc_node(sizeof(struct bau_control), GFP_KERNEL, node);
> +	if (!bau_tablesp)
> +		BUG();

use BUG_ON(). (in other instances as well in this same file)

> +	for (i = 0, ip = bau_tablesp->watching;
> +	     i < DESTINATION_PAYLOAD_QUEUE_SIZE; i++, ip++) {
> +		*ip = 0;
> +	}

this iteration could avoid the linebreak via intelligent shrinking of 
overlong symbols:

> +	for (i = 0, ip = bau_tablesp->watching; i < BAU_QUEUE_SIZE; i++, ip++)
> +		*ip = 0;

(similar things in other places as well)

	Ingo
