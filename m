Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbZEUCPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbZEUCPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 22:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZEUCP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 22:15:27 -0400
Received: from smtp-out.google.com ([216.239.33.17]:12566 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958AbZEUCP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 22:15:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=nwr9ZYL2YDA37VeTLQ0FEPePrAGTCgs9EjiO5g0KPn9Dr+RsxmTGaOJWaEA8VS9N7
	8iFHMnABKr17h36GUGLVg==
MIME-Version: 1.0
In-Reply-To: <4A14B56F.6030109@cn.fujitsu.com>
References: <cover.1242763826.git.jbaron@redhat.com>
	 <20090520073348.GA12316@elte.hu> <20090520154241.GC3081@redhat.com>
	 <5df78e1d0905201849l5e71953bg8444166ae3c8f92a@mail.gmail.com>
	 <4A14B56F.6030109@cn.fujitsu.com>
Date: Wed, 20 May 2009 19:15:23 -0700
Message-ID: <5df78e1d0905201915l6b81ef7cn8d1836faf9e11726@mail.gmail.com>
Subject: Re: [PATCH 0/3] tracepoints: delay argument evaluation
From: Jiaying Zhang <jiayingz@google.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Jason Baron <jbaron@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, fweisbec@gmail.com, laijs@cn.fujitsu.com,
       rostedt@goodmis.org, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
       mbligh@google.com, roland@redhat.com, fche@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

But if we convert blktrace to use event tracer interface, we can have:

trace_block_bio_complete(md, bio);

TRACE_EVENT(block_bio_complete,
        TP_PROTO(struct mapped_device *md, struct bio *bio),
...
        TP_fast_assign(
                __entry->queue            = md->queue;
...
        ),
);

Jiaying

On Wed, May 20, 2009 at 6:59 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Jiaying Zhang wrote:
>> Is it possible to convert blktrace to use event tracer? Then in this case we
>
> Yes, I'm doing this, see:
>        http://marc.info/?l=linux-kernel&m=124228198011297&w=2
>
>> can pass 'md' as the parameter to trace_block_bio_complete and dereference
>> md->queue during assignment.
>>
>
> But the problem discussed here exists whether you use plain tracepoints
> or TRACE_EVENT.
>
> Though we can add a new tracepoint named trace_md_bio_complete, this is
> not the way to solve it.
>
>> Jiaying
>>
>> On Wed, May 20, 2009 at 8:42 AM, Jason Baron <jbaron@redhat.com> wrote:
>>> On Wed, May 20, 2009 at 09:33:48AM +0200, Ingo Molnar wrote:
>>>> hm, this is really a compiler bug in essence - the compiler should
>>>> delay the construction of arguments into unlikely branches - if the
>>>> arguments are only used there.
>>>>
>>>> We'd basically open-code a clear-cut:
>>>>
>>>>    trace_block_bio_complete(md->queue, bio);
>>>>
>>>> into this form:
>>>>
>>>>    trace(block_bio_complete, md->queue, bio);
>>>>
>>>> .. and this latter form could become moot (and a nuisance) if the
>>>> compiler is fixed.
>>>>
>>>> Have you tried very latest GCC, does it still have this optimization
>>>> problem?
>>>>
>>>> Note that the compiler getting this right would help a _lot_ of
>>>> other inline functions in the kernel as well. Arguments only used
>>>> within unlikely() branches are quite common.
>>>>
>>>>       Ingo
>>> hi,
>>>
>>> I e-mailed the gcc list, where they suggested using a macro, as I've
>>> done. They also suggested filing an enhancement request for this, which
>>> I've done: http://gcc.gnu.org/bugzilla/show_bug.cgi?id=40207 It seems
>>> like they agree with the suggestion.
>>>
>>> It still might make sense to make this requirement explicit (by adding
>>> the extra macro), as the tracepoint off case should really be as optimized as
>>> possible.
>>>
>>> thanks,
>>>
>>> -Jason
>>>
>
