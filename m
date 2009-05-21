Return-Path: <linux-kernel-owner+w=401wt.eu-S1755368AbZEUCkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368AbZEUCkn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 22:40:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754209AbZEUCkf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 22:40:35 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52925 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753596AbZEUCkf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 22:40:35 -0400
Message-ID: <4A14BF65.8040506@cn.fujitsu.com>
Date: Thu, 21 May 2009 10:41:41 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jiaying Zhang <jiayingz@google.com>
CC: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
References: <cover.1242763826.git.jbaron@redhat.com>	 <20090520073348.GA12316@elte.hu> <20090520154241.GC3081@redhat.com>	 <5df78e1d0905201849l5e71953bg8444166ae3c8f92a@mail.gmail.com>	 <4A14B56F.6030109@cn.fujitsu.com> <5df78e1d0905201915l6b81ef7cn8d1836faf9e11726@mail.gmail.com>
In-Reply-To: <5df78e1d0905201915l6b81ef7cn8d1836faf9e11726@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiaying Zhang wrote:
> But if we convert blktrace to use event tracer interface, we can have:
> 

Actually we are converting block tracepoints to TRACE_EVENT, and we are
not going to remove relay+ioctl-based blktrace or ftrace-plugin blktrace.

> trace_block_bio_complete(md, bio);
> 
> TRACE_EVENT(block_bio_complete,
>         TP_PROTO(struct mapped_device *md, struct bio *bio),
> ...
>         TP_fast_assign(
>                 __entry->queue            = md->queue;
> ...
>         ),
> );
> 

I'm not sure if this piece of code can pass compile when !CONFIG_MD
if we put it in include/trace/events/block.h with other block tracepoints.

And what if we have another trace_block_bio_complete(rq, bio) in blk-core.c?

Even it works, still this is not the key to this issue.

We have some other ptr-deref in block tracepoints and other places:

  static inline void blk_partition_remap(struct bio *bio)
  {
	...
	trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
			    bdev->bd_dev,
			    bio->bi_sector - p->start_sect);
	...
  }

  static int __end_that_request_first(struct request *req, int error,
				    int nr_bytes)
  {
	...
	trace_block_rq_complete(req->q, req);
	...
  }

> Jiaying
> 
> On Wed, May 20, 2009 at 6:59 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Jiaying Zhang wrote:
>>> Is it possible to convert blktrace to use event tracer? Then in this case we
>> Yes, I'm doing this, see:
>>        http://marc.info/?l=linux-kernel&m=124228198011297&w=2
>>
>>> can pass 'md' as the parameter to trace_block_bio_complete and dereference
>>> md->queue during assignment.
>>>
>> But the problem discussed here exists whether you use plain tracepoints
>> or TRACE_EVENT.
>>
>> Though we can add a new tracepoint named trace_md_bio_complete, this is
>> not the way to solve it.
>>
>>> Jiaying
>>>
>>> On Wed, May 20, 2009 at 8:42 AM, Jason Baron <jbaron@redhat.com> wrote:
>>>> On Wed, May 20, 2009 at 09:33:48AM +0200, Ingo Molnar wrote:
>>>>> hm, this is really a compiler bug in essence - the compiler should
>>>>> delay the construction of arguments into unlikely branches - if the
>>>>> arguments are only used there.
>>>>>
>>>>> We'd basically open-code a clear-cut:
>>>>>
>>>>>    trace_block_bio_complete(md->queue, bio);
>>>>>
>>>>> into this form:
>>>>>
>>>>>    trace(block_bio_complete, md->queue, bio);
>>>>>
>>>>> .. and this latter form could become moot (and a nuisance) if the
>>>>> compiler is fixed.
>>>>>
>>>>> Have you tried very latest GCC, does it still have this optimization
>>>>> problem?
>>>>>
>>>>> Note that the compiler getting this right would help a _lot_ of
>>>>> other inline functions in the kernel as well. Arguments only used
>>>>> within unlikely() branches are quite common.
>>>>>
>>>>>       Ingo
>>>> hi,
>>>>
>>>> I e-mailed the gcc list, where they suggested using a macro, as I've
>>>> done. They also suggested filing an enhancement request for this, which
>>>> I've done: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=40207 It seems
>>>> like they agree with the suggestion.
>>>>
>>>> It still might make sense to make this requirement explicit (by adding
>>>> the extra macro), as the tracepoint off case should really be as optimized as
>>>> possible.
>>>>
>>>> thanks,
>>>>
>>>> -Jason
>>>>
> 
> 

