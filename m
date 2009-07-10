Return-Path: <linux-kernel-owner+w=401wt.eu-S1752958AbZGJJIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958AbZGJJIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jul 2009 05:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZGJJH6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 10 Jul 2009 05:07:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:65163 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZGJJH5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jul 2009 05:07:57 -0400
Message-ID: <4A5704EA.5000807@cn.fujitsu.com>
Date: Fri, 10 Jul 2009 17:07:54 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>, Alan.Brunelle@hp.com,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Fix blktrace unaligned memory access
References: <20090710075339.GX23611@kernel.dk>
In-Reply-To: <20090710075339.GX23611@kernel.dk>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jens Axboe wrote:
> Hi,
> 
> It seems that relay_reserve() (or the ring_buffer_event_data(), that one
> still needs some love) can return unaligned memory, there's no way
> around that when you have pdu lengths that aren't a nice size. This can
> cause unaligned access warnings on platforms that care about alignment.
> 

Seems relay_reserve() does nothing for alignment..On the other hand,
ring_buffer_event_data() returns a ptr which is 32bit-aligned, but
this still means it can cause unaligned accesses on 64bits arch, while
I think it's fixable in ring buffer, it's certainly not an easy job.

> This is an RFC, perhaps we can fix this in some other way. This one takes
> the simple approach, use an on-stack copy and memcpy() that to the
> destination.
> 

or get_unaligned() ?

> diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
> index 39af8af..9aba4ec 100644
> --- a/kernel/trace/blktrace.c
> +++ b/kernel/trace/blktrace.c
> @@ -62,7 +62,7 @@ static void blk_unregister_tracepoints(void);
>  static void trace_note(struct blk_trace *bt, pid_t pid, int action,
>  		       const void *data, size_t len)
>  {
> -	struct blk_io_trace *t;
> +	struct blk_io_trace *ptr, __t, *t = &__t;
>  	struct ring_buffer_event *event = NULL;
>  	int pc = 0;
>  	int cpu = smp_processor_id();
> @@ -75,15 +75,15 @@ static void trace_note(struct blk_trace *bt, pid_t pid, int action,
>  						  0, pc);
>  		if (!event)
>  			return;
> -		t = ring_buffer_event_data(event);
> +		ptr = t = ring_buffer_event_data(event);
>  		goto record_it;
>  	}
>  
>  	if (!bt->rchan)
>  		return;
>  
> -	t = relay_reserve(bt->rchan, sizeof(*t) + len);
> -	if (t) {
> +	ptr = relay_reserve(bt->rchan, sizeof(*t) + len);
> +	if (ptr) {
>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
>  		t->time = ktime_to_ns(ktime_get());
>  record_it:
> @@ -92,7 +92,9 @@ record_it:
>  		t->pid = pid;
>  		t->cpu = cpu;
>  		t->pdu_len = len;
> -		memcpy((void *) t + sizeof(*t), data, len);
> +		if (t == &__t)
> +			memcpy(ptr, t, sizeof(*t));
> +		memcpy((void *) ptr + sizeof(*ptr), data, len);
>  
>  		if (blk_tracer)
>  			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
> @@ -178,7 +180,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  {
>  	struct task_struct *tsk = current;
>  	struct ring_buffer_event *event = NULL;
> -	struct blk_io_trace *t;
> +	struct blk_io_trace *ptr, __t, *t = &__t;
>  	unsigned long flags = 0;
>  	unsigned long *sequence;
>  	pid_t pid;
> @@ -209,7 +211,7 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  						  0, pc);
>  		if (!event)
>  			return;
> -		t = ring_buffer_event_data(event);
> +		ptr = t = ring_buffer_event_data(event);
>  		goto record_it;
>  	}
>  
> @@ -223,8 +225,8 @@ static void __blk_add_trace(struct blk_trace *bt, sector_t sector, int bytes,
>  	if (unlikely(tsk->btrace_seq != blktrace_seq))
>  		trace_note_tsk(bt, tsk);
>  
> -	t = relay_reserve(bt->rchan, sizeof(*t) + pdu_len);
> -	if (t) {
> +	ptr = relay_reserve(bt->rchan, sizeof(*ptr) + pdu_len);
> +	if (ptr) {
>  		sequence = per_cpu_ptr(bt->sequence, cpu);
>  
>  		t->magic = BLK_IO_TRACE_MAGIC | BLK_IO_TRACE_VERSION;
> @@ -247,8 +249,10 @@ record_it:
>  		t->error = error;
>  		t->pdu_len = pdu_len;
>  
> +		if (t == &__t)
> +			memcpy(ptr, t, sizeof(*t));
>  		if (pdu_len)
> -			memcpy((void *) t + sizeof(*t), pdu_data, pdu_len);
> +			memcpy((void *) ptr + sizeof(*ptr), pdu_data, pdu_len);
>  
>  		if (blk_tracer) {
>  			trace_buffer_unlock_commit(blk_tr, event, 0, pc);
> 

