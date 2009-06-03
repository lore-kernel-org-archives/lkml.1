Return-Path: <linux-kernel-owner+w=401wt.eu-S1756311AbZFCJz3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311AbZFCJz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:55:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752881AbZFCJzV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:55:21 -0400
Received: from mx2.redhat.com ([66.187.237.31]:58424 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985AbZFCJzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:55:21 -0400
Subject: Re: trace: fix multiple use of __print_flags and __print_symbolic
From: Steven Whitehouse <swhiteho@redhat.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       cluster-devel@redhat.com, Christoph Hellwig <hch@infradead.org>,
       Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A26474C.1000900@cn.fujitsu.com>
References: <1244019900.29604.588.camel@localhost.localdomain>
	 <4A26474C.1000900@cn.fujitsu.com>
Content-Type: text/plain
Organization: Red Hat (UK) Ltd (Registered in England and Wales, No.
 3798903) Registered office: Red Hat UK Ltd, Amberley Place, 107-111 Peascod
 Street, Windsor, Berkshire, SL4 ITE
Date: Wed, 03 Jun 2009 10:54:49 +0100
Message-Id: <1244022889.29604.595.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 2009-06-03 at 17:50 +0800, Li Zefan wrote:
> Steven Whitehouse wrote:
> > When using multiple calls to __print_symbolic and __print_flags in
> > the same tracer, I noticed that the output was incorrect. I think
> > the following patch is the correct fix (it works for me) but please
> > check it carefully since I'm not that familiar with this code,
> > and I may well have made a mistake somewhere.
> > 
> 
> I don't see there's bug in __print_symbolic() or __print_flags():
> 
> enum print_line_t
> ftrace_raw_output_##call(struct trace_iterator *iter, int flags)
> {
> 	...
> 	p = &get_cpu_var(ftrace_event_seq);
> 	/* here we call ftrace_print_flags_seq(p, ...) */
> 	ret = trace_seq_printf(s, #call ": " print);
> 	put_cpu();
> 	...
> }
> 
> ftrace_event_seq is percpu data, and here is used with preempt-disabled,
> so there shouldn't be problem of concurrent accessing.
> 
> 
Well without the "fix" every call to __print_symbolic and __print_flags
seems to result in printing the same string, so with:


        TP_printk("%u.%u glock %d:%lld state %s => %s tgt:%s dmt:%s flags:%s",
                  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->gltype,
                 (unsigned long long)__entry->glnum,
                  glock_trace_name(__entry->cur_state),
                  glock_trace_name(__entry->new_state),
                  glock_trace_name(__entry->tgt_state),
                  glock_trace_name(__entry->dmt_state),
                  show_glock_flags(__entry->flags))
and

#define dlm_state_name(nn) { DLM_LOCK_##nn, #nn }
#define glock_trace_name(x) __print_symbolic(x,         \
                            dlm_state_name(IV),         \
                            dlm_state_name(NL),         \
                            dlm_state_name(CR),         \
                            dlm_state_name(CW),         \
                            dlm_state_name(PR),         \
                            dlm_state_name(PW),         \
                            dlm_state_name(EX))

#define show_glock_flags(flags) __print_flags(flags, "",        \
        {(1UL << GLF_LOCK),                     "l" },          \
        {(1UL << GLF_DEMOTE),                   "D" },          \
        {(1UL << GLF_PENDING_DEMOTE),           "d" },          \
        {(1UL << GLF_DEMOTE_IN_PROGRESS),       "p" },          \
        {(1UL << GLF_DIRTY),                    "y" },          \
        {(1UL << GLF_LFLUSH),                   "f" },          \
        {(1UL << GLF_INVALIDATE_IN_PROGRESS),   "i" },          \
        {(1UL << GLF_REPLY_PENDING),            "r" },          \
        {(1UL << GLF_INITIAL),                  "I" },          \
        {(1UL << GLF_FROZEN),                   "F" })

every call to glock_trace_name and the call to glock_show_flags resulted in the
string "EX" when I was testing it. With the previous version of my patch where
I did the constant to string conversion with my own function, this didn't happen.
Applying the patch corrects the output, so there is a bug here I think, even if I've
not found the correct fix for it,

Steve.



