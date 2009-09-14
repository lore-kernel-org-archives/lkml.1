Return-Path: <linux-kernel-owner+w=401wt.eu-S1757199AbZINVHR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199AbZINVHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 17:07:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757124AbZINVHQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 17:07:16 -0400
Received: from mail-ew0-f206.google.com ([209.85.219.206]:35327 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756907AbZINVHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 17:07:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=LnbwN2WOwlSia1MDtaAX9/2xt+youATUJ74niXjxpPo4+jzCRW+Djj3XQp2SG5Cq8P
         PJp05nWTD+DCiQknb1+X1sRyl7gxreU/FYy5q1NP4TEgKVy+D7W56mkfeRqSVJGi5YXL
         bZsc3+p244sxqOdZWI92/t5aJrRu2lw1Lp77k=
Date: Mon, 14 Sep 2009 23:07:13 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
       lkml <linux-kernel@vger.kernel.org>,
       systemtap <systemtap@sources.redhat.com>,
       DLE <dle-develop@lists.sourceforge.net>,
       Jim Keniston <jkenisto@us.ibm.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Andi Kleen <ak@linux.intel.com>, Christoph Hellwig <hch@infradead.org>,
       "Frank Ch. Eigler" <fche@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
       Jason Baron <jbaron@redhat.com>, "K.Prasad" <prasad@linux.vnet.ibm.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH tracing/kprobes 4/7] tracing/kprobes: Add event
	profiling support
Message-ID: <20090914210712.GH6045@nowhere>
References: <20090910235258.22412.29317.stgit@dhcp-100-2-132.bos.redhat.com> <20090910235329.22412.94731.stgit@dhcp-100-2-132.bos.redhat.com> <20090911031253.GD16396@nowhere> <4AAA7938.7070200@redhat.com> <20090914030244.GC14306@nowhere> <4AAE7540.9090009@redhat.com> <20090914185540.GD6045@nowhere> <4AAE9B41.3020905@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4AAE9B41.3020905@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 14, 2009 at 03:36:33PM -0400, Masami Hiramatsu wrote:
> Frederic Weisbecker wrote:
>> On Mon, Sep 14, 2009 at 12:54:24PM -0400, Masami Hiramatsu wrote:
>>>>> I'd like to have a dispatcher function and flags internally :)
>>>>
>>>>
>>>> You mean kprobes that could support multiple probes?
>>>> That would be a nice solution IMHO...
>>>
>>> Yeah, actually kprobes could support multiple probes on the
>>> same point. But kprobe structure has many extensions which
>>> kprobe-tracer doesn't need, e.g. post_handler/break_handler,
>>> opcode, arch sprcific instructions.
>>> Kretprobe consumes more memories for storing return points :(.
>>>
>>> Thus, if we know there are two functions to be called on the
>>> same probe point, I think it is better to have a dispatcher.
>>> (Especially, in this case, we can call fixed functions, so
>>> it's easier way.)
>>
>>
>> Yeah, you could union the post_handler with profile_handler
>> or something like that.
>
> No, you can't do that, because kprobes calls post_handler if
> it is not NULL.


Yeah, I was meaning: having the normal probe call ftrace handler
and post probe call perf handler.
But well, that looks not that sane (your dispatch idea looks fine).


>>
>> It depends if kprobes may need one day to support an undeterminate
>> number of probes.
>
> Kprobes itself is supporting those multiple kprobes on the same
> address. I meant that we don't need to have multiple kprobes on
> the same "kprobe-tracer's event". Even if introducing a dispatcher,
> kprobe-tracer can support multiple trace-event at the same location.


Yeah, I was not meaning several kprobes on the same address but
actually a single kprobe instance with multiple probe callbacks.

But your dispatch patch (sorry) does that in essence, though
specialized to the ftrace/perf couple but that's fine since nothing
else may need to have multiplexed probes.


>> Also, is the post_handler called at the same location than the normal
>> probe?
>
> No, post_handler is called after single-stepping.


Ok.


>
>> And is a post handler called even if there is no normal handler?
>
> Yes, it is.
>
> Hmm, I assume I have told about kprobes infrastructure, and have you
> told about kprobe-tracer?:)


No I was talking about kprobes in general :)



>> There might be some of such factors that would force you to handle a
>> lot of corner cases, things that you wouldn't need to worry about
>> if you just had to maintain a simple rcu list of probes to call.
>
>
> Anyway, I never see who are using post_handler:). I'm not sure why
> it is needed...


May be it's a legacy of code that was used by the past, in which case
that could perhaps be cleaned up?

