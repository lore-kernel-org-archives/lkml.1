Return-Path: <linux-kernel-owner+w=401wt.eu-S933811AbZHGU3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933811AbZHGU3j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 16:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932721AbZHGU3i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 16:29:38 -0400
Received: from casper.infradead.org ([85.118.1.10]:36469 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933730AbZHGU3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 16:29:38 -0400
Subject: Re: [PATCH] perfcounters: Support for ftrace event records sampling
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Steven Rostedt <rostedt@goodmis.org>,
       Paul Mackerras <paulus@samba.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>
In-Reply-To: <20090807202105.GB4999@nowhere>
References: <1249601154-5597-1-git-send-email-fweisbec@gmail.com>
	 <1249641477.32113.664.camel@twins> <1249675747.8088.5.camel@laptop>
	 <20090807202105.GB4999@nowhere>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 07 Aug 2009 22:28:51 +0200
Message-Id: <1249676931.17467.7.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-08-07 at 22:21 +0200, Frederic Weisbecker wrote:
> On Fri, Aug 07, 2009 at 10:09:07PM +0200, Peter Zijlstra wrote:
> > On Fri, 2009-08-07 at 12:38 +0200, Peter Zijlstra wrote:
> > > > +static void ftrace_profile_##call(proto)                             \
> > > > +{                                                                    \
> > > > +     struct ftrace_data_offsets_##call __maybe_unused __data_offsets;\
> > > > +     struct ftrace_event_call *event_call = &event_##call;           \
> > > > +     extern void perf_tpcounter_event(int, u64, u64, void *, int);   \
> > > > +     struct ftrace_raw_##call *entry;                                \
> > > > +     u64 __addr = 0, __count = 1;                                    \
> > > > +     unsigned long irq_flags;                                        \
> > > > +     int __entry_size;                                               \
> > > > +     int __data_size;                                                \
> > > > +     int pc;                                                         \
> > > > +                                                                     \
> > > > +     local_save_flags(irq_flags);                                    \
> > > > +     pc = preempt_count();                                           \
> > > > +                                                                     \
> > > > +     __data_size = ftrace_get_offsets_##call(&__data_offsets, args); \
> > > > +     __entry_size = __data_size + sizeof(*entry);                    \
> > > > +                                                                     \
> > > > +     do {                                                            \
> > > > +             char raw_data[__entry_size];                            \
> > > > +             struct trace_entry *ent;                                \
> > > > +                                                                     \
> > > > +             entry = (struct ftrace_raw_##call *)raw_data;           \
> > > > +             ent = &entry->ent;                                      \
> > > > +             tracing_generic_entry_update(ent, irq_flags, pc);       \
> > > > +             ent->type = event_call->id;                             \
> > > > +                                                                     \
> > > > +             tstruct                                                 \
> > > > +                                                                     \
> > > > +             { assign; }                                             \
> > > > +                                                                     \
> > > > +             perf_tpcounter_event(event_call->id, __addr, __count, entry,\
> > > > +                          __entry_size);                             \
> > > > +     } while (0);                                                    \
> > > > +                                                                     \
> > > > +}
> > > 
> > > ok, so the one concern I have here is that the data needs to fit on the
> > > stack. What if someone puts a large string in the data?
> > 
> > Also, how NMI safe is all that?
> 
> 
> Everything is allocated in the stack. It's NMI safe AFAICS, am I missing
> something?

I've no idea what all those trace calls do, I was hoping you would and
say, sure, no problem ;-)
