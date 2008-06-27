Return-Path: <linux-kernel-owner+w=401wt.eu-S1763564AbYF0VAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763564AbYF0VAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 17:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754193AbYF0VAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 17:00:04 -0400
Received: from mx1.redhat.com ([66.187.233.31]:50300 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754063AbYF0VAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 17:00:00 -0400
Message-ID: <48655464.5040000@redhat.com>
Date: Fri, 27 Jun 2008 16:58:12 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Takashi Nishiie <t-nishiie@np.css.fujitsu.com>,
       "'Alexey Dobriyan'" <adobriyan@gmail.com>,
       "'Peter Zijlstra'" <peterz@infradead.org>,
       "'Steven Rostedt'" <rostedt@goodmis.org>,
       "'Frank Ch. Eigler'" <fche@redhat.com>, "'Ingo Molnar'" <mingo@elte.hu>,
       "'LKML'" <linux-kernel@vger.kernel.org>,
       "'systemtap-ml'" <systemtap@sources.redhat.com>,
       "'Hideo AOKI'" <haoki@redhat.com>
Subject: Re: [RFC PATCH] Kernel Tracepoints
References: <007601c8d5ca$18fa0e10$4aee2a30$@css.fujitsu.com> <48611B03.1000003@redhat.com> <20080625011951.D83E.KOSAKI.MOTOHIRO@jp.fujitsu.com> <48612879.5090809@redhat.com> <20080625235214.GA14249@Krystal> <486403F0.4020801@redhat.com> <20080627133009.GC13751@Krystal>
In-Reply-To: <20080627133009.GC13751@Krystal>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mathieu Desnoyers wrote:
> * Masami Hiramatsu (mhiramat@redhat.com) wrote:
>  >
>>> Implementation of kernel tracepoints. Inspired from the Linux Kernel Markers.
>> What would you think redesigning markers on tracepoints? because most of the
>> logic (scaning sections, multiple probe and activation) seems very similar
>> to markers.
>>
> 
> We could, although markers, because they use var args, allow to put the
> iteration on the multi probe array out-of-line. Tracepoints cannot
> afford this and the iteration must be done at the initial call-site.
> 
> From what I see in your proposal, it's mostly to extract the if() call()
> code from the inner __trace_mark() macro and to put it in a separate
> macro, am I correct ? This would make the macro more readable.

Sure, I think marker and tracepoint can share below functions;
- definition of static local variables in specific sections
- probe activation code (if() call())
- multi probe handling
Then, marker just exports marker_strings sections.

>> For example, (not complete, I just thought :-))
>>
>>  struct tracepoint {
>>  	const char *name;		/* Tracepoint name */
>>  	DEFINE_IMV(char, state);	/* Immediate value state. */
>>  	struct tracepoint_probe_closure *multi;	/* Closures */
>> 	void * callsite_data;		/* private date from call site */
>>  } __attribute__((aligned(8)));
>>
>>  #define __tracepoint_block(generic, name, data, func, args)
>>  	static const char __tpstrtab_##name[]			\
>>  	__attribute__((section("__tracepoints_strings")))	\
>>  	= #name;						\
>>  	static struct tracepoint __tracepoint_##name		\
>>  	__attribute__((section("__tracepoints"), aligned(8))) =	\
>>  	{ __tpstrtab_##name, 0, NULL, data};			\
>>  	if (!generic) {						\
>>  		if (unlikely(imv_cond(__tracepoint_##name.state))) { \
>>  			imv_cond_end();				\
>>  			func(&__tracepoint_##name, args); \
>>  		} else						\
>>  			imv_cond_end();				\
>>  	} else {						\
>>  		if (unlikely(_imv_read(__tracepoint_##name.state))) \
>>  			func(&__tracepoint_##name, args); \
>>  	}


So, in my idea, __trace_##name() also uses __tracepoint_block() for
avoiding code duplication.


> [...]
>>> +	static inline int register_trace_##name(			\
>>> +		void (*probe)(void *private_data, proto),		\
>>> +		void *private_data)					\
>>> +	{								\
>>> +		return tracepoint_probe_register(#name, (void *)probe,	\
>>> +			private_data);					\
>>> +	}								\
>>> +	static inline void unregister_trace_##name(			\
>>> +		void (*probe)(void *private_data, proto),		\
>>> +		void *private_data)					\
>>> +	{								\
>>> +		tracepoint_probe_unregister(#name, (void *)probe,	\
>>> +			private_data);					\
>>> +	}
>> Out of curiousity, what the private_data is for?
>>
> 
> When a probe is registered, it gives more flexibility to be able to pass
> a pointer to private data associated with that probe. For instance, if a
> tracer needs to register the same probe to many different tracepoints,
> but having a different context associated with each, it will pass the
> same function pointer with different private_data to the registration
> function.

Hmm, only for tracepoint, it might be not so useful, because
most of tracepoint's prototypes are different and so we can't
use same probe to those tracepoints.
Anyway, it is useful for more general probe(ex. markers) if that
is implemented on tracepoint ;-)


Thank you,

-- 
Masami Hiramatsu

Software Engineer
Hitachi Computer Products (America) Inc.
Software Solutions Division

e-mail: mhiramat@redhat.com

