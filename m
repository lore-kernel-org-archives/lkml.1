Return-Path: <linux-kernel-owner+w=401wt.eu-S1754626AbZHJM5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626AbZHJM5j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 08:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754320AbZHJM5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 08:57:39 -0400
Received: from an-out-0708.google.com ([209.85.132.241]:42134 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754069AbZHJM5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 08:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Id9ZuFfdZGSte0l33faW/DT4ulm7h0RF9r+tc7q/GW7Gp90s3WfzRp5a66zgaT46wl
         LKOL9fW8wOyS/SnGXXIN5eZsSoUcEn1VmrBbIq3EhgNe9jHeWJ3DrRn6n1lX4GyXNXy9
         tYGyYOwgb4Y/sJkSNyW7lUoWCDumI4U/GSvXE=
Date: Mon, 10 Aug 2009 14:57:32 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 4/3] perf_counter: Correct PERF_SAMPLE_RAW output
Message-ID: <20090810125731.GA5124@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com> <1249698400-5441-2-git-send-email-fweisbec@gmail.com> <1249896447.17467.74.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1249896447.17467.74.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 11:27:27AM +0200, Peter Zijlstra wrote:
> Subject: perf_counter: Correct PERF_SAMPLE_RAW output
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Mon Aug 10 11:16:52 CEST 2009
> 
> PERF_SAMPLE_* output switches should unconditionally output the
> correct format, as they are the only way to unambiguously parse the
> PERF_EVENT_SAMPLE data.
> 
> Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  include/linux/perf_counter.h |    2 ++
>  include/trace/ftrace.h       |    3 ++-
>  kernel/perf_counter.c        |   30 ++++++++++++++++++++++++------
>  3 files changed, 28 insertions(+), 7 deletions(-)
> 
> Index: linux-2.6/include/linux/perf_counter.h
> ===================================================================
> --- linux-2.6.orig/include/linux/perf_counter.h
> +++ linux-2.6/include/linux/perf_counter.h
> @@ -369,6 +369,8 @@ enum perf_event_type {
>  	 *
>  	 *	{ u64			nr,
>  	 *	  u64			ips[nr];  } && PERF_SAMPLE_CALLCHAIN
> +	 *	{ u32			size;
> +	 *	  char                  data[size];}&& PERF_SAMPLE_RAW
>  	 * };
>  	 */
>  	PERF_EVENT_SAMPLE		= 9,
> Index: linux-2.6/include/trace/ftrace.h
> ===================================================================
> --- linux-2.6.orig/include/trace/ftrace.h
> +++ linux-2.6/include/trace/ftrace.h
> @@ -687,7 +687,8 @@ static void ftrace_profile_##call(proto)
>  	pc = preempt_count();						\
>  									\
>  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> -	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
> +	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
> +			     sizeof(u64));				\



Here you are reserving a room for the size of the buffer inside the buffer.



>  									\
>  	do {								\
>  		char raw_data[__entry_size];				\
> Index: linux-2.6/kernel/perf_counter.c
> ===================================================================
> --- linux-2.6.orig/kernel/perf_counter.c
> +++ linux-2.6/kernel/perf_counter.c
> @@ -2647,7 +2647,6 @@ void perf_counter_output(struct perf_cou
>  		u64 counter;
>  	} group_entry;
>  	struct perf_callchain_entry *callchain = NULL;
> -	struct perf_raw_record *raw = NULL;
>  	int callchain_size = 0;
>  	u64 time;
>  	struct {
> @@ -2717,9 +2716,15 @@ void perf_counter_output(struct perf_cou
>  	}
>  
>  	if (sample_type & PERF_SAMPLE_RAW) {
> -		raw = data->raw;
> -		if (raw)
> -			header.size += raw->size;
> +		int size = sizeof(u32);
> +
> +		if (data->raw)
> +			size += data->raw->size;



And here you reserve a size for the buffer once again?



> +		else
> +			size += sizeof(u32);
> +
> +		WARN_ON_ONCE(size & (sizeof(u64)-1));
> +		header.size += size;
>  	}
>  
>  	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
> @@ -2785,8 +2790,21 @@ void perf_counter_output(struct perf_cou
>  		}
>  	}
>  
> -	if ((sample_type & PERF_SAMPLE_RAW) && raw)
> -		perf_output_copy(&handle, raw->data, raw->size);
> +	if (sample_type & PERF_SAMPLE_RAW) {
> +		if (data->raw) {
> +			perf_output_put(&handle, data->raw->size);
> +			perf_output_copy(&handle, data->raw->data, data->raw->size);



And actually you copy the buffer that has the size of the buffer
plus the u32 reserved for the size, whereas the size has already been
copied.

When I look at a perf sample raw it gives me the following:

.  0000:  09 00 00 00 01 00 54 00 d0 c7 00 81 ff ff ff ff  ......T........
.  0010:  69 01 00 00 69 01 00 00 e6 15 00 00 00 00 00 00  i...i..........
.  0020:  30 00 00 00 2b 00 01 02 69 01 00 00 69 01 00 00  0...+...i...i..

          ^  ^  ^  ^  ^  ^  ^  ^  ^  ^ .................
           Buf size   struct trace_entry



.  0030:  6b 6f 6e 64 65 6d 61 6e 64 2f 31 00 00 00 00 00  kondemand/1....

          ^  ^  ^  ^  ..................................
          Rest of struct ftrace_raw_<call>

.  0040:  69 01 00 00 70 82 46 81 ff ff ff ff 00 00 00 00  i...p.F........

          ..................................  ^  ^  ^  ^
                                              The room you have
                                              reserved for the buffer size
                                              (zeroed from a tmp patch)
.  0050:  00 00 00 00
          ^  ^  ^  ^
          padding from alignment (ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
			     sizeof(u64));

I first thought the 0x4c bytes was a padding from gcc because
sizeof(struct ftrace_raw_<call>) % 8 != 0
But no, it is equal to 0: It's between 0x4c and 0x24 = 40 bytes.

I'm preparing a patch to fix this. Just wanted to expose my idea here,
because I'm perhaps wrong in the middle of this dump.

I'll do the alignment right in the end, just before inserting the entry
in the output. That will be more easy. I'll zeroe the rest in the same time.


> +		} else {
> +			struct {
> +				u32	size;
> +				u32	data;
> +			} raw = {
> +				.size = sizeof(u32),
> +				.data = 0,
> +			};
> +			perf_output_put(&handle, raw);
> +		}
> +	}
>  
>  	perf_output_end(&handle);
>  }
> 

