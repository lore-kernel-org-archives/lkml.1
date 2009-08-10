Return-Path: <linux-kernel-owner+w=401wt.eu-S1754501AbZHJNG6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbZHJNG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 09:06:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751265AbZHJNG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 09:06:57 -0400
Received: from casper.infradead.org ([85.118.1.10]:55573 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040AbZHJNG4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 09:06:56 -0400
Subject: Re: [PATCH 4/3] perf_counter: Correct PERF_SAMPLE_RAW output
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
In-Reply-To: <20090810125731.GA5124@nowhere>
References: <1249698400-5441-1-git-send-email-fweisbec@gmail.com>
	 <1249698400-5441-2-git-send-email-fweisbec@gmail.com>
	 <1249896447.17467.74.camel@twins>  <20090810125731.GA5124@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Aug 2009 15:06:25 +0200
Message-Id: <1249909585.17467.135.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2009-08-10 at 14:57 +0200, Frederic Weisbecker wrote:

> > Index: linux-2.6/include/trace/ftrace.h
> > ===================================================================
> > --- linux-2.6.orig/include/trace/ftrace.h
> > +++ linux-2.6/include/trace/ftrace.h
> > @@ -687,7 +687,8 @@ static void ftrace_profile_##call(proto)
> >  	pc = preempt_count();						\
> >  									\
> >  	__data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> > -	__entry_size = ALIGN(__data_size + sizeof(*entry), sizeof(u64));\
> > +	__entry_size = ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
> > +			     sizeof(u64));				\
> 
> 
> 
> Here you are reserving a room for the size of the buffer inside the buffer.

No, here I align so that __entry_size + the u32 ends up at a u64
boundary.

Oh gah, now I see.. I should have subtracted sizeof(u32) after the
alignment.

> > @@ -2717,9 +2716,15 @@ void perf_counter_output(struct perf_cou
> >  	}
> >  
> >  	if (sample_type & PERF_SAMPLE_RAW) {
> > -		raw = data->raw;
> > -		if (raw)
> > -			header.size += raw->size;
> > +		int size = sizeof(u32);
> > +
> > +		if (data->raw)
> > +			size += data->raw->size;
> 
> 
> 
> And here you reserve a size for the buffer once again?

This is the actual output buffer reservation code, that needs the u32
above and the data->raw size.

> 
> > +		else
> > +			size += sizeof(u32);
> > +
> > +		WARN_ON_ONCE(size & (sizeof(u64)-1));

Which when taken together should be u64 aligned.

So this will always fail with the above.

> > +		header.size += size;
> >  	}
> >  
> >  	ret = perf_output_begin(&handle, counter, header.size, nmi, 1);
> > @@ -2785,8 +2790,21 @@ void perf_counter_output(struct perf_cou
> >  		}
> >  	}
> >  
> > -	if ((sample_type & PERF_SAMPLE_RAW) && raw)
> > -		perf_output_copy(&handle, raw->data, raw->size);
> > +	if (sample_type & PERF_SAMPLE_RAW) {
> > +		if (data->raw) {
> > +			perf_output_put(&handle, data->raw->size);
> > +			perf_output_copy(&handle, data->raw->data, data->raw->size);
> 

> And actually you copy the buffer that has the size of the buffer
> plus the u32 reserved for the size, whereas the size has already been
> copied.
> 
> When I look at a perf sample raw it gives me the following:
> 
> ..  0000:  09 00 00 00 01 00 54 00 d0 c7 00 81 ff ff ff ff  ......T........
> ..  0010:  69 01 00 00 69 01 00 00 e6 15 00 00 00 00 00 00  i...i..........
> ..  0020:  30 00 00 00 2b 00 01 02 69 01 00 00 69 01 00 00  0...+...i...i..
> 
>           ^  ^  ^  ^  ^  ^  ^  ^  ^  ^ .................
>            Buf size   struct trace_entry
> 
> 
> 
> ..  0030:  6b 6f 6e 64 65 6d 61 6e 64 2f 31 00 00 00 00 00  kondemand/1....
> 
>           ^  ^  ^  ^  ..................................
>           Rest of struct ftrace_raw_<call>
> 
> ..  0040:  69 01 00 00 70 82 46 81 ff ff ff ff 00 00 00 00  i...p.F........
> 
>           ..................................  ^  ^  ^  ^
>                                               The room you have
>                                               reserved for the buffer size
>                                               (zeroed from a tmp patch)
> ..  0050:  00 00 00 00
>           ^  ^  ^  ^
>           padding from alignment (ALIGN(__data_size + sizeof(*entry) + sizeof(u32),\
> 			     sizeof(u64));

Right, one u32 too much :/

> I first thought the 0x4c bytes was a padding from gcc because
> sizeof(struct ftrace_raw_<call>) % 8 != 0
> But no, it is equal to 0: It's between 0x4c and 0x24 = 40 bytes.
> 
> I'm preparing a patch to fix this. Just wanted to expose my idea here,
> because I'm perhaps wrong in the middle of this dump.
> 
> I'll do the alignment right in the end, just before inserting the entry
> in the output. That will be more easy. I'll zeroe the rest in the same time.

OK.
